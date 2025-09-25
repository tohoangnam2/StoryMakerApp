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
    
    var body: some View {
        NavigationView{
            ZStack{
                VStack(spacing:300){
                    VStack(spacing: 30){
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
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(vm.mainprojects, id: \.id) { project in
                                    
                                    if let data = project.previewImageData,
                                       let image = UIImage(data: data) {
                                        Image(uiImage: image)
                                            .resizable()
                                            .frame(width: 97, height: 207)
                                            .cornerRadius(8)
                                    } else {
                                        Rectangle()
                                            .fill(Color.gray.opacity(0.3))
                                            .frame(width: 97, height: 207)
                                            .cornerRadius(8)
                                            .overlay(Text("No preview").font(.caption))
                                    }
                                }

                            }
                            .padding(.horizontal)
                            Spacer()
                        }
                        
                        
                    }
                    VStack(spacing:15){
                        withAnimation(.spring){
                            NavigationLink(destination: AddProjectView()
                                .environmentObject(vm)) {
                                Image("home_icBtn")
                            }
                        }
                        Text("Add new Project")
                            .font(.system(size: 16, weight: .medium, design: .default))
                    }
                    .padding(.bottom,20)
                }
            }
        }
        .onAppear {
            loadSavedProjects()
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

}

