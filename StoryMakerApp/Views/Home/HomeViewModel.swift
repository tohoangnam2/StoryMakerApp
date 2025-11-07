//
//  HomeViewModel.swift
//  StoryMakerApp
//
//  Created by Nam To on 7/11/25.
//

import SwiftUI
import Foundation

class HomeViewModel: ObservableObject {
    @Published var mainprojects: [MainModel] = []
    @Published var selectedProjectID: UUID?
    @Published var isShowPremium: Bool = false

    
    func createEmptyProject() -> MainModel {
        let newProject = MainModel(id: UUID())
        ProjectStorage.saveProject(newProject, previewImage: nil)
        return newProject
    }
    
    func deleteProject(_ project: MainModel) {
        ProjectStorage.deleteProject(id: project.id)
        if let index = mainprojects.firstIndex(where: { $0.id == project.id }) {
            mainprojects.remove(at: index)
        }
    }
    func loadProjects() {
        let projects = ProjectStorage.loadAllProjects()
        //mảng tạm chứa project đã load
        var loaded: [MainModel] = []

        for var project in projects {
            if let previewPath = project.previewImagePath {
                let folderURL = ProjectStorage.projectFolder(for: project.id)
                let previewURL = folderURL.appendingPathComponent(previewPath)
                if let data = try? Data(contentsOf: previewURL),
                   let image = UIImage(data: data) {
                    project.previewImage = image
                }
            }
            loaded.append(project)
        }

        DispatchQueue.main.async {
            //thêm ảnh đấy xong gán vào main
            self.mainprojects = loaded
            print(" Loaded \(loaded.count) projects with previews")
        }
    }

}

