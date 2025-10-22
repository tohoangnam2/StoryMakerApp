//
//  HomeView.swift
//  StoryMakerApp
//
//  Created by to hoang nam on 19/8/25.
//

import SwiftUI

struct HomeView: View {
    @StateObject var vm: BackgroundEditorViewModel = BackgroundEditorViewModel()


    @State var mockDataImage: [UIImage] = [
        UIImage(imageLiteralResourceName: "home_mockdata"),
        UIImage(imageLiteralResourceName: "home_mockdata"),
        UIImage(imageLiteralResourceName: "home_mockdata")
        
    ]
    
    @State private var selectedProjectID: UUID?
    
    @Binding var isShowPremium: Bool

    var body: some View {
        NavigationView{
            ZStack{
                VStack(){
                    VStack(){
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
                        ScrollViewReader { proxy in
                            ScrollView(.vertical, showsIndicators: false) {
                                LazyVGrid(
                                    columns: Array(repeating: GridItem(.flexible()), count: 3),
                                    spacing: 16
                                ) {
                                    ForEach(vm.mainprojects, id: \.id) { project in
                                        if project.frame != nil {
                                            ZStack(alignment: .topTrailing) {
                                                NavigationLink(
                                                    destination: AddProjectView(projectID: project.id,vm:vm)
                                                ) {
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
                                                }
                                                
                                                Menu {
                                                    Button(role: .destructive) {
                                                        vm.deleteProject(project)
                                                    } label: {
                                                        Label("Delete", systemImage: "trash")
                                                        
                                                    }
                                                    Button {
                                                        selectedProjectID = project.id   //  trigger link ẩn
                                                    } label: {
                                                        Label("Edit", systemImage: "pencil")
                                                    }
                                                } label: {
                                                    Image(systemName: "ellipsis.circle")
                                                        .foregroundColor(.white)
                                                        .padding(6)
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
                                        proxy.scrollTo(id, anchor: .top) //  scroll về đầu
                                    }
                                }
                            }
                        }
                        // NavigationLink ẩn
                    }
                    
                    Spacer()
                    VStack(spacing:15){
                        withAnimation(.spring){
                            NavigationLink(destination: AddProjectView(project : nil, projectID: nil,vm:vm)
                               ) {
                                Image("home_icBtn")
                            }
                        }
                        Text("Add new Project")
                            .font(.system(size: 16, weight: .medium, design: .default))
                    }
                    .padding(.top)
                }
                
            }
            
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

