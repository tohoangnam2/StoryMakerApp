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

    
    func deleteProject(_ project: MainModel) {
        ProjectStorage.deleteProject(id: project.id)
        withAnimation {
            loadProjects()
        }
    }


    func loadProjects() {
        let projects = ProjectStorage.loadAllProjects()
        var loaded: [MainModel] = []

        for var project in projects {
            if let previewPath = project.previewImagePath {
                let folderURL = ProjectStorage.projectFolder(for: project.id)
                let previewURL = folderURL.appendingPathComponent(previewPath)
                //nếu tồn tại dưới dangnj đường dẫn thì load thành ảnh
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

        //  Sort theo thời điểm sửa JSON
        loaded.sort { lhs, rhs in
            let lFolder = ProjectStorage.projectFolder(for: lhs.id)
            let rFolder = ProjectStorage.projectFolder(for: rhs.id)
            let lJSON = lFolder.appendingPathComponent("project_\(lhs.id).json")
            let rJSON = rFolder.appendingPathComponent("project_\(rhs.id).json")

            let lDate = (try? FileManager.default
                .attributesOfItem(atPath: lJSON.path)[.modificationDate] as? Date) ?? .distantPast
            let rDate = (try? FileManager.default
                .attributesOfItem(atPath: rJSON.path)[.modificationDate] as? Date) ?? .distantPast
            return (lDate ?? .distantPast) > (rDate ?? .distantPast)
        }

        DispatchQueue.main.async {
            self.mainprojects = loaded
            print("Loaded \(loaded.count) projects with previews")
        }
    }
}

