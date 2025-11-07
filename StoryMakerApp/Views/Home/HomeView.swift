//
//  HomeView.swift
//  StoryMakerApp
//
//  Created by to hoang nam on 19/8/25.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject var homeVM = HomeViewModel()
    @State private var selectedProject: MainModel? = nil
    @State var isShowPremium: Bool = false

    var body: some View {
        NavigationView{
            ZStack{
                VStack{
                    VStack{
                        //view tabbar
                        VStack(spacing: 25){
                            HStack{
                                Image("home_ictabbar")
                                Spacer()
                                Text("Art story".uppercased())
                                    .font(.system(size: 18, weight: .bold, design: .default))
                                Spacer()
                               
                                Button(action: {
                                    isShowPremium = true
                                }, label: {
                                    Image("home_premium")
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 30, height: 30)
                                        .padding(.trailing,18)
                                })
                                
                            }
                            .padding(.horizontal,20)
                            Text("Recent Project".uppercased())
                                .font(.system(size: 18, weight: .bold, design: .default))
                                .frame(maxWidth: .infinity, alignment: .topLeading)
                                .padding(.leading,25)
                        }
                        
                        //view preview
                        ScrollViewReader { proxy in
                            ScrollView(.vertical, showsIndicators: false) {
                                LazyVGrid(
                                    columns: Array(repeating: GridItem(.flexible()), count: 3),
                                    spacing: 16
                                ) {
                                    ForEach(homeVM.mainprojects, id: \.id) { project in
                                        if project.frame != nil {
                                            ZStack(alignment: .topTrailing) {
                                                Button(action: {
                                                    selectedProject = project
                                                }, label: {
                                                    if let img = project.previewImage {
                                                        Image(uiImage: img)
                                                            .resizable()
                                                            .scaledToFill()
                                                            .frame(width: 98, height: 208)
                                                            .cornerRadius(8)
                                                    } else {
                                                        Color.gray
                                                            .frame(width: 98, height: 208)
                                                            .cornerRadius(8)
                                                    }

                                                })
                                                Menu {
                                                    Button(role: .destructive) {
                                                        homeVM.deleteProject(project)
                                                    } label: {
                                                        Label("Delete", systemImage: "trash")
                                                    }
                                                    Button {
                                                        selectedProject = project
                                                    } label: {
                                                        Label("Edit", systemImage: "pencil")
                                                    }
                                                } label: {
                                                    Image(systemName: "ellipsis.circle")
                                                        .foregroundColor(.white)
                                                        .padding(6)
                                                }
                                                NavigationLink(
                                                    destination: EditorView(project: selectedProject, homeVM: homeVM),
                                                    isActive: Binding(
                                                        get: { selectedProject?.id == project.id },
                                                        set: { isActive in
                                                            //back thì rs state
                                                            if !isActive { selectedProject = nil }
                                                        }
                                                    )
                                                ) {
                                                    EmptyView()
                                                }
                                                
                                            }
                                            .id(project.id)
                                        }
                                    }
                                }
                                    .padding(.horizontal)
                            }
                            .onChange(of: homeVM.mainprojects.first?.id) { newID in
                                if let id = newID {
                                    withAnimation {
                                        proxy.scrollTo(id, anchor: .top)
                                    }
                                }
                            }
                        }
                    }
                    Spacer()
                }
            }
            //view add
            .overlay(
                VStack(spacing:15){
                    withAnimation(.spring){
                        NavigationLink(destination: EditorView(project : nil, homeVM: homeVM)
                        ) {
                            Image("home_icBtn")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 65, height: 65)
                        }
                    }
                    
                }
                ,alignment: .bottom
            )
        }
        .onAppear {
            homeVM.loadProjects()
        }
        
        .fullScreenCover(isPresented: $isShowPremium) {
            SubcriptionView()
        }
        .navigationBarBackButtonHidden(true)
    }
}


