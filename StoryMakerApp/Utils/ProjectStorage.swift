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
    static func saveProject(_ project: MainModel, previewImage: UIImage?, baseImage: UIImage? = nil) {
        let folderURL = projectFolder(for: project.id)
        do {
            try FileManager.default.createDirectory(at: folderURL, withIntermediateDirectories: true)

            var projectToSave = project

            // Lưu preview
            if let img = previewImage,
               let imgData = img.jpegData(compressionQuality: 0.9) {
                let previewFileName = "project_\(project.id).jpg"
                let previewURL = folderURL.appendingPathComponent(previewFileName)
                try imgData.write(to: previewURL)
                projectToSave.previewImagePath = previewFileName
            }

            // Lưu original
            let originalFileName = "original.jpg"
            let originalURL = folderURL.appendingPathComponent(originalFileName)
            if let base = baseImage,
               let data = base.jpegData(compressionQuality: 1.0) {
                try? data.write(to: originalURL)
            }
            // Ép luôn lưu tên file vào JSON
            projectToSave.originalImagePath = originalFileName

            // Lưu JSON
            let jsonURL = folderURL.appendingPathComponent("project_\(project.id).json")
            let data = try JSONEncoder().encode(projectToSave)
            try data.write(to: jsonURL)

            print("Saved JSON + preview + original.jpg")
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
                    print(" Failed to decode project at:", jsonURL.path)
                    return nil
                }
                
                // Load preview từ relative path
                if let previewName = project.previewImagePath {
                    let previewURL = folderURL.appendingPathComponent(previewName)
                    if let imgData = try? Data(contentsOf: previewURL),
                       let uiImage = UIImage(data: imgData) {
                        project.previewImage = uiImage
                        print(" Loaded preview image:", previewName)
                    } else {
                        print(" Failed to load preview image:", previewName)
                    }
                }
                
                // Kiểm tra ảnh gốc từ originalImagePath
                if let originalName = project.originalImagePath {
                    let originalURL = folderURL.appendingPathComponent(originalName)
                    if FileManager.default.fileExists(atPath: originalURL.path) {
                        print(" original.jpg exists for project:", project.id)
                    } else {
                        print(" original.jpg NOT FOUND for project:", project.id)
                    }
                } else {
                    print(" originalImagePath is nil for project:", project.id)
                }
                
                return project
            }
        } catch {
            print(" Error loading projects from Documents:", error)
            return []
        }
    }
    func loadProject(id: UUID) -> MainModel? {
        let folderURL = ProjectStorage.projectFolder(for: id)
        let jsonURL = folderURL.appendingPathComponent("project_\(id).json")

        do {
            let data = try Data(contentsOf: jsonURL)
            var project = try JSONDecoder().decode(MainModel.self, from: data)

            //  Load ảnh gốc từ local
            if let originalName = project.originalImagePath {
                let originalURL = folderURL.appendingPathComponent(originalName)
                if FileManager.default.fileExists(atPath: originalURL.path),
                   let imgData = try? Data(contentsOf: originalURL),
                   let uiImage = UIImage(data: imgData) {
                    project.previewImage = uiImage   // hoặc gán vào vm.baseImage
                    print(" Loaded original image from:", originalURL.path)
                } else {
                    print(" original.jpg not found at:", originalURL.path)
                }
            }

            return project
        } catch {
            print(" Failed to load project:", error)
            return nil
        }
    }
    
    func debugPrintProjectJSON(id: UUID) {
        let folderURL = ProjectStorage.projectFolder(for: id)
        let jsonURL = folderURL.appendingPathComponent("project_\(id).json")
        print("📄 JSON path:", jsonURL.path)

        do {
            let data = try Data(contentsOf: jsonURL)
            if let rawString = String(data: data, encoding: .utf8) {
                print("📜 Raw JSON content:\n\(rawString)")
            } else {
                print("⚠️ Không đọc được JSON thành chuỗi UTF-8")
            }
        } catch {
            print("❌ Lỗi đọc JSON:", error)
        }
    }


//    static func loadProject(id: UUID) -> MainModel? {
//        let folderURL = projectFolder(for: id)
//        let jsonURL = folderURL.appendingPathComponent("project_\(id).json")
//        print("JSON path:", jsonURL.path)
//        
//        do {
//            let data = try Data(contentsOf: jsonURL)
//            var project = try JSONDecoder().decode(MainModel.self, from: data)
//            
//            // Load preview từ relative path
//            if let previewName = project.previewImagePath {
//                let previewURL = folderURL.appendingPathComponent(previewName)
//                if let imgData = try? Data(contentsOf: previewURL),
//                   let uiImage = UIImage(data: imgData) {
//                    project.previewImage = uiImage
//                    print(" Loaded preview image:", previewName)
//                } else {
//                    print(" Failed to load preview image:", previewName)
//                }
//            }
//            
//            // Kiểm tra ảnh gốc có tồn tại không (không gán vào project)
//            if let originalName = project.originalImagePath {
//                let originalURL = folderURL.appendingPathComponent(originalName)
//                if FileManager.default.fileExists(atPath: originalURL.path) {
//                    print(" original.jpg exists at:", originalURL.path)
//                } else {
//                    print(" original.jpg NOT FOUND at:", originalURL.path)
//                }
//            } else {
//                print(" originalImagePath is nil in JSON")
//            }
//            
//            return project
//        } catch {
//            print(" Failed to load project: \(error)")
//            return nil
//        }
//    }




    /// Liệt kê tất cả folder project
    static func listSavedProjects() -> [URL] {
        let documentsURL = getDocumentsDirectory()
        let files = try? FileManager.default.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
        return files?.filter { $0.lastPathComponent.hasPrefix("project_") } ?? []
    }
    
    // Xoá project
    static func deleteProject(id: UUID) {
        let folderURL = projectFolder(for: id)
        do {
            if FileManager.default.fileExists(atPath: folderURL.path) {
                try FileManager.default.removeItem(at: folderURL)
                print(" Deleted project folder: \(folderURL.lastPathComponent)")
            }
        } catch {
            print("Failed to delete project: \(error)")
        }
    }
}

extension OverlayTextViewModel {
    func restore(from project: MainModel) {
        self.overlays = project.textLayers
        self.selectedOverlayID = nil
    }
}


