//
//  HomeView.swift
//  StoryMakerApp
//
//  Created by to hoang nam on 19/8/25.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var vm: BackgroundEditorViewModel
    
    @State var mockDataImage: [UIImage] = [
        UIImage(imageLiteralResourceName: "home_mockdata"),
        UIImage(imageLiteralResourceName: "home_mockdata"),
        UIImage(imageLiteralResourceName: "home_mockdata")
        
    ]
    
    @State private var selectedProjectID: UUID?
    
    var body: some View {
        NavigationView{
            ZStack{
                VStack(){
                    VStack(){
                        VStack(spacing: 25){
                            HStack{
                                NavigationLink(destination: SplashView()){
                                    Image("home_ictabbar")
                                }
                                Spacer()
                                Text("Art story".uppercased())
                                    .font(.system(size: 18, weight: .bold, design: .default))
                                Spacer()
                                Image("home_ictabbar")
                                    .opacity(0)
                                
                            }
                            .padding(.horizontal,20)
                            Text("Recent Project".uppercased())
                                .font(.system(size: 18, weight: .bold, design: .default))
                                .frame(maxWidth: .infinity, alignment: .topLeading)
                                .padding(.leading,25)
                        }
                        ScrollView(.vertical, showsIndicators: false) {
                            LazyVGrid(
                                columns: Array(repeating: GridItem(.flexible()), count: 3),
                                spacing: 16
                            ) {
                                ForEach(vm.mainprojects, id: \.id) { project in
                                    if project.frame != nil {
                                        ZStack(alignment: .topTrailing) {
                                            NavigationLink(
                                                destination: AddProjectView(projectID: project.id)
                                                    .environmentObject(vm)
                                            ) {
                                                if let preview = project.previewImage {
                                                    Image(uiImage: preview)
                                                        .resizable()
                                                        .scaledToFill()
                                                        .frame(width:98,height:208)
                                                        .cornerRadius(8)
                                                        .clipped()
                                                }
                                            }
                                            Button(action: {
                                                vm.deleteProject(project)
                                            }) {
                                                Image(systemName: "xmark.circle.fill")
                                                    .foregroundColor(.white)
                                                    .padding(6)
                                            }
                                        }
                                    }
                                }

                            }
                            .padding(.horizontal)
                            
                        }
                    }
                    Spacer()
                    VStack(spacing:15){
                        withAnimation(.spring){
                            NavigationLink(destination: AddProjectView(project : nil, projectID: nil)
                                .environmentObject(vm)) {
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
//        .onAppear {
//            let projects = ProjectStorage.loadAllProjects()
//            print(" Reloaded projects: \(projects.count)")
//            projects.forEach { print("   id: \($0.id)") }
//            vm.mainprojects = projects
//        }
        .onAppear {
            let projects = ProjectStorage.loadAllProjects()
            vm.mainprojects = projects
        }


        .navigationBarBackButtonHidden(true)
        
    }
    func loadSavedProjects() {
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!

        do {
            let files = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
            let jsonFiles = files.filter { $0.pathExtension == "json" }

            var loadedProjects: [MainModel] = []

            for file in jsonFiles {
                if let data = try? Data(contentsOf: file),
                   let project = try? JSONDecoder().decode(MainModel.self, from: data) {
                    loadedProjects.append(project)
                }
            }

            vm.mainprojects = loadedProjects
        } catch {
            print("Failed to load projects: \(error)")
        }
    }
    static func loadAllProjects() -> [MainModel] {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        var loaded: [MainModel] = []

        do {
            let folders = try FileManager.default.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
            for folder in folders where folder.lastPathComponent.hasPrefix("project_") {
                let jsonURL = folder.appendingPathComponent("\(folder.lastPathComponent).json")
                if FileManager.default.fileExists(atPath: jsonURL.path),
                   let data = try? Data(contentsOf: jsonURL),
                   let project = try? JSONDecoder().decode(MainModel.self, from: data) {
                    // load preview.jpg nếu có
                    let previewURL = folder.appendingPathComponent("\(folder.lastPathComponent).jpg")
                    if let imgData = try? Data(contentsOf: previewURL),
                       let uiImage = UIImage(data: imgData) {
                        var proj = project
                        proj.previewImage = uiImage
                        loaded.append(proj)
                    } else {
                        loaded.append(project)
                    }
                }
            }
        } catch {
            print("Failed to list projects: \(error)")
        }
        return loaded
    }




}

