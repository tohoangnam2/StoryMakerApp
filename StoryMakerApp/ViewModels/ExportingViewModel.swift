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
    
    func startExporting(image: UIImage, completion: (() -> Void)? = nil) {
        
        resetState()
        
        self.isExporting = true
        self.progress = 0.0
        self.isDone = false
        
        timer?.invalidate()
        
        // Progress chạy đến 0.90 (90%)
        timer = Timer.scheduledTimer(withTimeInterval: 0.002, repeats: true) { [weak self] t in
            guard let self = self else { return }
            
            if self.progress < 0.9 {
                self.progress += 0.002
            } else {
                t.invalidate()
                self.timer = nil
            }
        }
        
        // Bước 2: Save vào Photos
        DispatchQueue.global(qos: .background).async {
            
            self.saveToPhotosOnly(
                image,
                onDenied: {
                    // Không lưu được → vẫn hoàn thành export
                    DispatchQueue.main.async {
                        self.finishExport()
                        completion?()
                    }
                },
                onSaved: {
                    DispatchQueue.main.async {
                        self.finishExport()
                        completion?()
                    }
                }
            )
        }
    }
    private func finishExport() {
        withAnimation(.linear(duration: 0.3)) {
            self.progress = 1.0
        }
        self.isDone = true
        self.isExporting = false
    }
    
    func resetState() {
        timer?.invalidate()
        timer = nil
        progress = 0
        isDone = false
        isExporting = false
        exportedFileURL = nil
    }
    func saveToPhotosOnly(
        _ image: UIImage,
        onDenied: @escaping () -> Void,
        onSaved: @escaping () -> Void
    ) {
        let status = PHPhotoLibrary.authorizationStatus(for: .addOnly)
        
        switch status {
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization(for: .addOnly) { newStatus in
                DispatchQueue.main.async {
                    if newStatus == .authorized || newStatus == .limited {
                        self.performSave(image, onSaved: onSaved)
                    } else {
                        onDenied()
                    }
                }
            }
            
        case .authorized, .limited:
            performSave(image, onSaved: onSaved)
            
        default:
            onDenied()
        }
    }
    
    private func performSave(_ image: UIImage, onSaved: @escaping () -> Void) {
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAsset(from: image)
        }) { success, error in
            DispatchQueue.main.async {
                onSaved()
            }
        }
    }
}
