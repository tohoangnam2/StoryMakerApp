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

    func startExporting(from frame: Frame?) {
            guard let frame = frame,
                  let url = frame.backgroundURL else {
                print(" Frame hoặc backgroundURL nil")
                return
            }
            
            self.isExporting = true
            self.progress = 0.1
            
            // Load image từ URL (hoặc local nếu đã có)
            URLSession.shared.dataTask(with: url) { data, _, error in
                guard let data = data, error == nil,
                      let image = UIImage(data: data) else {
                    DispatchQueue.main.async {
                        self.isExporting = false
                    }
                    return
                }
                
                DispatchQueue.main.async {
                    self.progress = 0.5
                }
                
                // Lưu vào Documents
                self.saveImageToDocumentsDirectory(image: image, filename: "namto_\(UUID().uuidString).jpg")

            }.resume()
        }
    
    func startExporting(image: UIImage) {
        self.isExporting = true
        self.progress = 0.0
        
        // Giả lập progress tăng dần
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
            self.saveImageToDocumentsDirectory(image: image, filename: "namto_\(UUID().uuidString).jpg")
        }
    }
    
    func quickExport(image: UIImage, filename: String = "snapshot_\(UUID().uuidString).jpg") {
        // Không bật progress, chỉ lưu ngay
        self.isExporting = false
        self.progress = 1.0
        self.isDone = true
        
        DispatchQueue.global(qos: .background).async {
            self.saveImageToDocumentsDirectory(image: image, filename: filename)
        }
    }

    private func saveImageToDocumentsDirectory(image: UIImage, filename: String) {
        guard let imageData = image.jpegData(compressionQuality: 0.9) else { return }
        
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsURL.appendingPathComponent(filename)
        
        do {
            try imageData.write(to: fileURL)
            
            // Lưu vào Photo Library
            PHPhotoLibrary.requestAuthorization { status in
                if status == .authorized || status == .limited {
                    PHPhotoLibrary.shared().performChanges({
                        PHAssetChangeRequest.creationRequestForAssetFromImage(atFileURL: fileURL)
                    }) { success, error in
                        if success {
                            print("luu app")
                        } else {
                            print(" Lỗi lưu vào Photos: \(error?.localizedDescription ?? "Unknown error")")
                        }
                    }
                } else {
                    print("ko co quyen")
                }
            }
            
            DispatchQueue.main.async {
                self.progress = 1.0
                self.isDone = true
                self.isExporting = false
                self.exportedFileURL = fileURL
                print(" Saved to Documents: \(fileURL)")
            }
            
        } catch {
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
      
      /// Chụp ngay từ UIImage có sẵn và lưu
      func snapshotAndSave(image: UIImage, filename: String = "snapshot_\(UUID().uuidString).jpg") {
          saveImageToDocumentsDirectory(image: image, filename: filename)
      }






    

    
    
    
}
