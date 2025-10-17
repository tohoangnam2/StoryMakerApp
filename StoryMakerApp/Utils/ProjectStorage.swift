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
            
            // Lưu preview flatten
            if let img = previewImage,
               let imgData = img.jpegData(compressionQuality: 0.9) {
                let previewFileName = "project_\(project.id).jpg"
                let previewURL = folderURL.appendingPathComponent(previewFileName)
                try imgData.write(to: previewURL)
                projectToSave.previewImagePath = previewFileName   // chỉ lưu tên file
            }
            
            // Đảm bảo luôn có original.jpg
            let originalFileName = "original.jpg"
            let originalURL = folderURL.appendingPathComponent(originalFileName)
            
            if let base = baseImage,   // truyền vào baseImage khi gọi hàm
               let data = base.jpegData(compressionQuality: 1.0) {
                try? data.write(to: originalURL)
                projectToSave.originalImagePath = originalFileName
            } else if FileManager.default.fileExists(atPath: originalURL.path) {
                // Nếu file đã tồn tại từ trước thì vẫn giữ
                projectToSave.originalImagePath = originalFileName
            }
            
            // Lưu JSON
            let jsonURL = folderURL.appendingPathComponent("project_\(project.id).json")
            let data = try JSONEncoder().encode(projectToSave)
            try data.write(to: jsonURL)
            
            print("✅ Saved JSON + preview + original.jpg")
        } catch {
            print("❌ Error saving project: \(error)")
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
                
                // Load preview từ relative path
                if let previewName = project.previewImagePath {
                    let url = folderURL.appendingPathComponent(previewName)
                    if let imgData = try? Data(contentsOf: url),
                       let uiImage = UIImage(data: imgData) {
                        project.previewImage = uiImage
                    }
                }
                
                return project
            }
        } catch {
            print(" Error loading projects: \(error)")
            return []
        }
    }

    static func loadProject(id: UUID) -> MainModel? {
        let folderURL = projectFolder(for: id)
        let jsonURL = folderURL.appendingPathComponent("project_\(id).json")
        do {
            let data = try Data(contentsOf: jsonURL)
            var project = try JSONDecoder().decode(MainModel.self, from: data)
            
            // Load preview từ relative path
            if let previewName = project.previewImagePath {
                let url = folderURL.appendingPathComponent(previewName)
                if let imgData = try? Data(contentsOf: url),
                   let uiImage = UIImage(data: imgData) {
                    project.previewImage = uiImage
                }
            }
            
            return project
        } catch {
            print(" Failed to load project: \(error)")
            return nil
        }
    }

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
