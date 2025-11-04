// ExportingViewModel.swift

import SwiftUI
import UIKit
import Photos // Thêm import này nếu bạn muốn dùng PHPhotoLibrary để lưu ảnh thật



class ExportingViewModel: ObservableObject {
    @Published var isExporting: Bool = false
    @Published var progress: Double = 0.0
    @Published var isDone: Bool = false
    
    @Published var exportedFileURL: URL? = nil
    
    private var timer: Timer?
    
    private var documentController: UIDocumentInteractionController?

    func startExporting(projectID: UUID, image: UIImage) {
        self.isExporting = true
        self.progress = 0.0
        
        // Giả lập progress
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.005, repeats: true) { [weak self] t in
            guard let self = self else { return }
            if self.progress < 1.0 {
                self.progress += 0.005
            } else {
                t.invalidate()
                self.isExporting = false
                self.isDone = true
            }
        }
        
        DispatchQueue.global(qos: .background).async {
            self.saveImageToProjectDirectory(
                projectID: projectID,
                image: image,
                filename: "project_\(projectID).jpg"
            )
        }
    }


    private func saveImageToProjectDirectory(projectID: UUID, image: UIImage, filename: String) {
        guard let imageData = image.jpegData(compressionQuality: 0.9) else { return }
        
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let projectFolder = documentsURL.appendingPathComponent("project_\(projectID)")
        
        // Tạo folder nếu chưa có
        try? FileManager.default.createDirectory(at: projectFolder, withIntermediateDirectories: true)
        
        let fileURL = projectFolder.appendingPathComponent(filename)
        
        do {
            try imageData.write(to: fileURL)
            print(" Saved JPG to: \(fileURL)")
            
            //lưu vào Photo Library
            PHPhotoLibrary.requestAuthorization { status in
                        switch status {
                        case .authorized, .limited:
                            // Người dùng đã cho phép → lưu vào Photos
                            PHPhotoLibrary.shared().performChanges({
                                PHAssetChangeRequest.creationRequestForAssetFromImage(atFileURL: fileURL)
                            }) { success, error in
                                if success {
                                    print("Saved to Photos")
                                } else {
                                    print("Error saving to Photos: \(error?.localizedDescription ?? "Unknown error")")
                                }
                            }
                        case .denied, .restricted, .notDetermined:
                            // Người dùng từ chối hoặc chưa cho phép → KHÔNG lưu
                            print("User denied photo library access, skip saving to Photos")
                        @unknown default:
                            break
                        }
                    }
            
            DispatchQueue.main.async {
                self.progress = 1.0
                self.isDone = true
                self.isExporting = false
                self.exportedFileURL = fileURL
            }
        } catch {
            print(" Error writing image: \(error)")
        }
    }

    func openInFiles(url: URL) {
        DispatchQueue.main.async {
            guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let rootVC = scene.windows.first?.rootViewController else {
                return
            }
            
            let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
            
            if let popover = activityVC.popoverPresentationController {
                popover.sourceView = rootVC.view
                popover.sourceRect = CGRect(x: rootVC.view.bounds.midX,
                                            y: rootVC.view.bounds.midY,
                                            width: 0, height: 0)
                popover.permittedArrowDirections = []
            }
            
            rootVC.present(activityVC, animated: true)
        }
    }
    
    @MainActor func snapshotAndSave<V: View>(view: V, size: CGSize, filename: String = "snapshot_\(UUID().uuidString).jpg") {
          let renderer = ImageRenderer(content: view)
          renderer.proposedSize = .init(size)
          
          if let uiImage = renderer.uiImage {
              // Lưu ngay không cần progress
              saveImageToDocumentsDirectory(image: uiImage, filename: filename)
          } else {
              print("Không render được snapshot")
          }
      }
      
      // Chụp ngay từ UIImage có sẵn và lưu
      func snapshotAndSave(image: UIImage, filename: String = "snapshot_\(UUID().uuidString).jpg") {
          saveImageToDocumentsDirectory(image: image, filename: filename)
      }






    

    
    
    
}
