// ExportingViewModel.swift

import SwiftUI
import UIKit
import Photos

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
        self.isDone = false
          
        timer?.invalidate()
        
        // Timer chỉ chạy đến 0.99
        timer = Timer.scheduledTimer(withTimeInterval: 0.005, repeats: true) { [weak self] t in
            guard let self = self else { return }
            
            if self.progress < 0.99 {
                self.progress += 0.005
            } else {
                t.invalidate()
                self.timer = nil
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
        try? FileManager.default.createDirectory(at: projectFolder, withIntermediateDirectories: true)

        let fileURL = projectFolder.appendingPathComponent(filename)

        do {
            try imageData.write(to: fileURL)
            print("Saved JPG to: \(fileURL)")

            // Lưu vào Photos
            PHPhotoLibrary.requestAuthorization { status in
                if status == .authorized || status == .limited {
                    PHPhotoLibrary.shared().performChanges({
                        PHAssetChangeRequest.creationRequestForAssetFromImage(atFileURL: fileURL)
                    }) { _, _ in
                        DispatchQueue.main.async {
                            withAnimation {
                                self.progress = 1.0
                            }
                            self.isDone = true
                            self.isExporting = false
                            self.exportedFileURL = fileURL
                        }
                    }
                } else {
                    // User không cho phép → vẫn kết thúc nhưng không save Photos
                    DispatchQueue.main.async {
                        withAnimation { self.progress = 1.0 }
                        self.isDone = true
                        self.isExporting = false
                        self.exportedFileURL = fileURL
                    }
                }
            }

        } catch {
            print("Error: \(error)")
        }
    }
}
