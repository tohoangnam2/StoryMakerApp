import Foundation
import UIKit

struct ProjectStorage {
    static func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    // Tạo folder riêng cho project
    static func projectFolder(for projectID: UUID) -> URL {
        return getDocumentsDirectory().appendingPathComponent("project_\(projectID)")
    }
    
    // Lưu project + ảnh snapshot vào folder riêng
    static func saveProject(
        _ project: MainModel,
        previewImage: UIImage?,
        baseImage: UIImage? = nil,
        filteredImage: UIImage? = nil
    ) {
        let folderURL = projectFolder(for: project.id)
        do {
            try FileManager.default.createDirectory(at: folderURL, withIntermediateDirectories: true)

            var projectToSave = project

            // Lưu preview (thumbnail / cover)
            if let img = previewImage,
               let imgData = img.jpegData(compressionQuality: 0.9) {
                let previewFileName = "project_\(project.id).jpg"
                let previewURL = folderURL.appendingPathComponent(previewFileName)
                try imgData.write(to: previewURL)
                projectToSave.previewImagePath = previewFileName
            }

            // Lưu original.jpg
            let originalFileName = "original.jpg"
            let originalURL = folderURL.appendingPathComponent(originalFileName)
            if let base = baseImage,
               let data = base.jpegData(compressionQuality: 1.0) {
                try? data.write(to: originalURL)
            }
            projectToSave.originalImagePath = originalFileName

            // Lưu filtered.jpg (để load nhanh)
            if let filtered = filteredImage,
               let filteredData = filtered.jpegData(compressionQuality: 0.9) {
                let filteredFileName = "filtered.jpg"
                let filteredURL = folderURL.appendingPathComponent(filteredFileName)
                try? filteredData.write(to: filteredURL)
                projectToSave.filteredImagePath = filteredFileName
            }

            // Ghi JSON
            let jsonURL = folderURL.appendingPathComponent("project_\(project.id).json")
            let data = try JSONEncoder().encode(projectToSave)
            try data.write(to: jsonURL)

            print(" Saved project: JSON + preview + original + filtered ")
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
            
            
            // Ưu tiên load ảnh filtered trước cho tốc độ mở nhanh
            let filteredURL = folderURL.appendingPathComponent(project.filteredImagePath ?? "filtered.jpg")
            if FileManager.default.fileExists(atPath: filteredURL.path),
               let imgData = try? Data(contentsOf: filteredURL),
               let filtered = UIImage(data: imgData) {
                project.previewImage = filtered
                print(" Loaded filtered image for preview:", filteredURL.lastPathComponent)
            }

            // Load ảnh gốc (dành cho re-apply filter)
            if let originalName = project.originalImagePath {
                let originalURL = folderURL.appendingPathComponent(originalName)
                if FileManager.default.fileExists(atPath: originalURL.path) {
                    print(" Loaded original.jpg for project:", id)
                } else {
                    print(" original.jpg not found:", originalURL.lastPathComponent)
                }
            }

            return project
        } catch {
            print(" Failed to load project:", error)
            return nil
        }
    }
    
    static func debugPrintProjectJSON(id: UUID) {
            let folderURL = projectFolder(for: id)
            let jsonURL = folderURL.appendingPathComponent("project_\(id).json")
            print(" JSON path:", jsonURL.path)

            do {
                let data = try Data(contentsOf: jsonURL)
                if let rawString = String(data: data, encoding: .utf8) {
                    print(" Raw JSON content:\n\(rawString)")
                } else {
                    print(" Không đọc được JSON thành chuỗi UTF-8")
                }
            } catch {
                print(" Lỗi đọc JSON:", error)
            }
        }

    // Liệt kê tất cả folder project
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


