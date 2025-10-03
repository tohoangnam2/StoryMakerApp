//
//  TestPreview.swift
//  StoryMakerApp
//
//  Created by Nam To on 18/9/25.
//

import SwiftUI

struct TestPreview: View {
//    @State private var selectedImage: UIImage? // Assume this is populated from PhotosPicker or similar
    @State private var selectedImage: UIImage? = UIImage(named: "bg_onb_1")


    var body: some View {
        VStack {
            if let image = selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            }

            Button("Save Image") {
                if let imageToSave = selectedImage {
                    saveImageToDocumentsDirectory(image: imageToSave, filename: "mySavedImage.png")
                } else {
                    print("No image selected to save.")
                }
            }
        }
    }
}


func saveImageToDocumentsDirectory(image: UIImage, filename: String) {
    guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
        print("Error: Could not find Documents directory.")
        return
    }

    let fileURL = documentsDirectory.appendingPathComponent(filename)

    guard let imageData = image.pngData() else { // Use .jpegData(compressionQuality: 0.8) for JPEG
        print("Error: Could not convert UIImage to Data.")
        return
    }

    do {
        try imageData.write(to: fileURL)
        print("Image saved successfully to: \(fileURL.lastPathComponent)")
        
        // Gọi mở Files sau khi lưu
        DispatchQueue.main.async {
            openInFiles(url: fileURL)
        }
    } catch {
        print(" Error saving image: \(error.localizedDescription)")
    }

}
func openInFiles(url: URL) {
    let controller = UIDocumentInteractionController(url: url)
    controller.uti = "public.png"
    
    guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
          let rootVC = scene.windows.first?.rootViewController else {
        print(" No rootViewController found")
        return
    }
    
    controller.presentOptionsMenu(from: rootVC.view.bounds, in: rootVC.view, animated: true)
}


#Preview {
    TestPreview()
}
