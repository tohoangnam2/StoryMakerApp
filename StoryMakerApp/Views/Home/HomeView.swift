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
                                                    destination: AddProjectView(projectID: project.id)
                                                        .environmentObject(vm)
                                                ) {
                                                    // Load preview trực tiếp từ file project_<id>.jpg
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
                                                        // fallback nếu chưa có preview
                                                        Color.gray
                                                            .frame(width: 98, height: 208)
                                                            .cornerRadius(8)
                                                    }
                                                }
                                                
                                                Button(action: {
                                                    vm.deleteProject(project)
                                                }) {
                                                    Image(systemName: "xmark.circle.fill")
                                                        .foregroundColor(.black)
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
        
        .onAppear {
            let projects = ProjectStorage.loadAllProjects()
            vm.mainprojects = projects
        }
        .fullScreenCover(isPresented: $isShowPremium) {
            SubcriptionView()
                .environmentObject(vm)
        }

        .navigationBarBackButtonHidden(true)
        
    }
//    func loadSavedProjects() {
//        let fileManager = FileManager.default
//        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
//
//        do {
//            let files = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
//            let jsonFiles = files.filter { $0.pathExtension == "json" }
//
//            var loadedProjects: [MainModel] = []
//
//            for file in jsonFiles {
//                if let data = try? Data(contentsOf: file),
//                   let project = try? JSONDecoder().decode(MainModel.self, from: data) {
//                    loadedProjects.append(project)
//                }
//            }
//
//            vm.mainprojects = loadedProjects
//        } catch {
//            print("Failed to load projects: \(error)")
//        }
//    }
//    static func loadAllProjects() -> [MainModel] {
//        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
//        var loaded: [MainModel] = []
//
//        do {
//            let folders = try FileManager.default.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
//            for folder in folders where folder.lastPathComponent.hasPrefix("project_") {
//                let jsonURL = folder.appendingPathComponent("\(folder.lastPathComponent).json")
//                if FileManager.default.fileExists(atPath: jsonURL.path),
//                   let data = try? Data(contentsOf: jsonURL),
//                   let project = try? JSONDecoder().decode(MainModel.self, from: data) {
//                    // load preview.jpg nếu có
//                    let previewURL = folder.appendingPathComponent("\(folder.lastPathComponent).jpg")
//                    if let imgData = try? Data(contentsOf: previewURL),
//                       let uiImage = UIImage(data: imgData) {
//                        var proj = project
//                        proj.previewImage = uiImage
//                        loaded.append(proj)
//                    } else {
//                        loaded.append(project)
//                    }
//                }
//            }
//        } catch {
//            print("Failed to list projects: \(error)")
//        }
//        return loaded
//    }
//    static func loadAllProjects() -> [MainModel] {
//        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
//        var loaded: [MainModel] = []
//
//        do {
//            let folders = try FileManager.default.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
//            for folder in folders where folder.lastPathComponent.hasPrefix("project_") {
//                let jsonURL = folder.appendingPathComponent("\(folder.lastPathComponent).json")
//                if FileManager.default.fileExists(atPath: jsonURL.path),
//                   let data = try? Data(contentsOf: jsonURL),
//                   let project = try? JSONDecoder().decode(MainModel.self, from: data) {
//                    //  Không cần load JPG rời nữa, previewImage sẽ tự decode từ base64
//                    loaded.append(project)
//                }
//            }
//        } catch {
//            print(" Failed to list projects: \(error)")
//        }
//        return loaded
//    }
    func previewImageView(for project: MainModel, isOnline: Bool) -> some View {
        if isOnline {
            // ONLINE → load từ file project_<id>.jpg
            let folderURL = ProjectStorage.projectFolder(for: project.id)
            let previewURL = folderURL.appendingPathComponent("project_\(project.id).jpg")
            if let data = try? Data(contentsOf: previewURL),
               let uiImage = UIImage(data: data) {
                return AnyView(
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 98, height: 208)
                        .cornerRadius(8)
                        .clipped()
                )
            }
        } else {
            // OFFLINE → load từ previewImagePath trong JSON
            if let previewPath = project.previewImagePath {
                let url = previewPath.hasPrefix("file://")
                    ? URL(string: previewPath)!
                    : URL(fileURLWithPath: previewPath)
                if let data = try? Data(contentsOf: url),
                   let uiImage = UIImage(data: data) {
                    return AnyView(
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 98, height: 208)
                            .cornerRadius(8)
                            .clipped()
                    )
                }
            }
        }
        // fallback
        return AnyView(
            Color.gray
                .frame(width: 98, height: 208)
                .cornerRadius(8)
        )
    }



}

