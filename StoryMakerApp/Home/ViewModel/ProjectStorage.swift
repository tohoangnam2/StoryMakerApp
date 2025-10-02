//
//  ProjectStorage.swift
//  StoryMakerApp
//
//  Created by Nam To on 24/9/25.
//

import Foundation

//struct ProjectStorage {
//    static func getDocumentsDirectory() -> URL {
//            FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
//        }
//
//        static func saveProject(_ project: MainModel, filename: String) {
//            let url = getDocumentsDirectory().appendingPathComponent(filename)
//            do {
//                let data = try JSONEncoder().encode(project)
//                try data.write(to: url)
//                print("Saved project to: \(url)")
//            } catch {
//                print(" Failed to save project: \(error)")
//            }
//        }
//
//        static func loadAllProjects() -> [MainModel] {
//            let url = getDocumentsDirectory()
//            do {
//                let files = try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil)
//                let projectFiles = files.filter { $0.lastPathComponent.hasPrefix("project_") && $0.pathExtension == "json" }
//                
//                return projectFiles.compactMap { fileURL in
//                    do {
//                        let data = try Data(contentsOf: fileURL)
//                        return try JSONDecoder().decode(MainModel.self, from: data)
//                    } catch {
////                        print(" Decode error for \(fileURL.lastPathComponent): \(error)")
//                        return nil
//                    }
//
//                }
//            } catch {
//                print(" Failed to list directory: \(error)")
//                return []
//            }
//        }
//
//
//    static func loadProject(from filename: String) -> MainModel? {
//        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//        let fileURL = documentsURL.appendingPathComponent(filename)
//
//        do {
//            let data = try Data(contentsOf: fileURL)
//            let decoder = JSONDecoder()
//            return try decoder.decode(MainModel.self, from: data)
//        } catch {
//            print(" Failed to load project:", error)
//            return nil
//        }
//        
//    }
//
//    static func listSavedProjects() -> [URL] {
//        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//        let files = try? FileManager.default.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
//        return files?.filter { $0.pathExtension == "json" } ?? []
//    }
//}
import Foundation
import UIKit

struct ProjectStorage {
    static func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    /// Tạo folder riêng cho project
    static func projectFolder(for projectID: UUID) -> URL {
        return getDocumentsDirectory().appendingPathComponent("project_\(projectID)")
    }
    
    /// Lưu project + ảnh snapshot vào folder riêng
    static func saveProject(_ project: MainModel, previewImage: UIImage?) {
        let folderURL = projectFolder(for: project.id)
        do {
            try FileManager.default.createDirectory(at: folderURL, withIntermediateDirectories: true)
            
            // 1. Lưu JSON
            let jsonURL = folderURL.appendingPathComponent("project_\(project.id).json")
            let data = try JSONEncoder().encode(project)
            try data.write(to: jsonURL)
            print(" Saved JSON: \(jsonURL)")
            
            // 2. Lưu ảnh JPG (nếu có)
            if let img = previewImage,
               let imgData = img.jpegData(compressionQuality: 0.9) {
                let imageURL = folderURL.appendingPathComponent("project_\(project.id).jpg")
                try imgData.write(to: imageURL)
                print(" Saved Image: \(imageURL)")
            }
        } catch {
            print(" Error saving project: \(error)")
        }
    }
    
    /// Load tất cả project từ Documents
    static func loadAllProjects() -> [MainModel] {
        let documentsURL = getDocumentsDirectory()
        do {
            let folders = try FileManager.default.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
                .filter { $0.lastPathComponent.hasPrefix("project_") }
            
            return folders.compactMap { folderURL in
                let jsonURL = folderURL.appendingPathComponent("\(folderURL.lastPathComponent).json")
                guard let data = try? Data(contentsOf: jsonURL),
                      var project = try? JSONDecoder().decode(MainModel.self, from: data) else {
                    return nil
                }
                
                // Load ảnh preview nếu có
                let imageURL = folderURL.appendingPathComponent("\(folderURL.lastPathComponent).jpg")
                if let imgData = try? Data(contentsOf: imageURL),
                   let uiImage = UIImage(data: imgData) {
                    project.previewImage = uiImage
                }
                return project
            }
        } catch {
            print(" Error loading projects: \(error)")
            return []
        }
    }
    
    /// Load 1 project cụ thể
    static func loadProject(id: UUID) -> MainModel? {
        let folderURL = projectFolder(for: id)
        let jsonURL = folderURL.appendingPathComponent("project_\(id).json")
        do {
            let data = try Data(contentsOf: jsonURL)
            var project = try JSONDecoder().decode(MainModel.self, from: data)
            
            let imageURL = folderURL.appendingPathComponent("project_\(id).jpg")
            if let imgData = try? Data(contentsOf: imageURL),
               let uiImage = UIImage(data: imgData) {
                project.previewImage = uiImage
            }
            return project
        } catch {
            print("❌ Failed to load project: \(error)")
            return nil
        }
    }
    
    /// Liệt kê tất cả folder project
    static func listSavedProjects() -> [URL] {
        let documentsURL = getDocumentsDirectory()
        let files = try? FileManager.default.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
        return files?.filter { $0.lastPathComponent.hasPrefix("project_") } ?? []
    }
}


extension OverlayTextViewModel {
    func restore(from project: MainModel) {
        // Khôi phục text layers
        self.overlays = project.textLayers
        self.selectedOverlayID = nil
    }
}

//extension BackgroundEditorViewModel {
//    func restore(from project: MainModel) {
//        self.selectedBackground = findBackground(by: project.selectedBackgroundID)
//        self.selectedFilter = project.selectedFilter
//        self.blur = project.blur
//        self.shadow = project.shadow
//        self.opacity = project.opacity
//        self.lightness = project.lightness
//        self.saturation = project.saturation
//        // Nếu có frameID thì set lại frame tương ứng
//        self.selectedFrameID = project.frameID
//    }
//    
//    private func findBackground(by id: String?) -> Background? {
//        guard let id = id else { return nil }
//        return self.backgrounds.first { $0.id == id }
//    }
//}
