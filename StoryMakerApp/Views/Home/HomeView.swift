//
//  HomeView.swift
//  StoryMakerApp
//
//  Created by to hoang nam on 19/8/25.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject var vm: BackgroundEditorViewModel = BackgroundEditorViewModel()
    @State private var selectedProjectID: UUID?
    @State var isShowPremium: Bool = false
    @State var project: MainModel?

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
                                    ForEach(vm.mainprojects, id: \.id) { project in
                                        if project.frame != nil {
                                            ZStack(alignment: .topTrailing) {
                                                Button(action: {
                                                    selectedProjectID = project.id
                                                }, label: {
                                                    let folderURL = ProjectStorage.projectFolder(for: project.id)
                                                    let previewURL = folderURL.appendingPathComponent("project_\(project.id).jpg")
                                                    
                                                    if let data = try? Data(contentsOf: previewURL),
                                                        let uiImage = UIImage(data: data) {
                                                        Image(uiImage: uiImage)
                                                            .resizable()
                                                            .scaledToFill()
                                                            .frame(width: 98, height: 208)
                                                            .cornerRadius(8)
                                                            .clipped()
                                                    } else {
                                                        Color.gray
                                                            .frame(width: 98, height: 208)
                                                            .cornerRadius(8)
                                                    }
                                                })
                                                Menu {
                                                    Button(role: .destructive) {
                                                        vm.deleteProject(project)
                                                    } label: {
                                                        Label("Delete", systemImage: "trash")
                                                    }
                                                    Button {
                                                        selectedProjectID = project.id
                                                    } label: {
                                                        Label("Edit", systemImage: "pencil")
                                                    }
                                                } label: {
                                                    Image(systemName: "ellipsis.circle")
                                                        .foregroundColor(.white)
                                                        .padding(6)
                                                }
                                                
                                                NavigationLink(
                                                    destination: EditorView(projectID: project.id, vm: vm),
                                                    tag: project.id,
                                                    selection: $selectedProjectID
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
                            .onChange(of: vm.mainprojects.first?.id) { newID in
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
                        NavigationLink(destination: EditorView(project : nil, projectID: nil,vm:vm)
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
            let projects = ProjectStorage.loadAllProjects()
            vm.mainprojects = projects
        }
        .fullScreenCover(isPresented: $isShowPremium) {
            SubcriptionView()
        }
        .navigationBarBackButtonHidden(true)
    }
}


