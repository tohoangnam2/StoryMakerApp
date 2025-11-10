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
        //Insert vào đầu mảng để nó thành phần tử đầu tiên
        mainprojects.insert(newProject, at: 0)
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
        var loaded: [MainModel] = []

        for var project in projects {
            if let previewPath = project.previewImagePath {
                let folderURL = ProjectStorage.projectFolder(for: project.id)
                let previewURL = folderURL.appendingPathComponent(previewPath)

                // Kiểm tra file tồn tại rồi tạo UIImage trực tiếp
                if FileManager.default.fileExists(atPath: previewURL.path),
                   let image = UIImage(contentsOfFile: previewURL.path) {
                    project.previewImage = image
                } else {
                    project.previewImage = nil
                }
            } else {
                project.previewImage = nil
            }

            loaded.append(project)
        }

        DispatchQueue.main.async {
            self.mainprojects = loaded
            print("Loaded \(loaded.count) projects with previews")
        }
    }


}

