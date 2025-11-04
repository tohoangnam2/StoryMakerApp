////
////  TestPhotopicker.swift
////  StoryMakerApp
////
////  Created by Nam To on 31/10/25.
////
//
//
//import SwiftUI
//import UIKit
//
//// MARK: - Model overlay
//struct OverlayImageModel: Identifiable {
//    var id = UUID()
//    var imageURL: URL?
//    var text: String
//    var offset: CGSize = .zero
//    var scale: CGFloat = 1.0
//    var isEditing: Bool = false
//}
//
//// MARK: - ViewModel
//class OverlayViewModel: ObservableObject {
//    @Published var overlays: [OverlayImageModel] = []
//    @Published var selectedOverlayID: UUID?
//
//    func addOverlay(_ overlay: OverlayImageModel) {
//        overlays.append(overlay)
//        selectedOverlayID = overlay.id
//    }
//
//    func updateOverlayImage(overlayID: UUID, imageURL: URL) {
//        guard let index = overlays.firstIndex(where: { $0.id == overlayID }) else { return }
//        overlays[index].imageURL = imageURL
//    }
//
//    func selectOverlay(_ id: UUID) {
//        for i in overlays.indices { overlays[i].isEditing = false }
//        if let idx = overlays.firstIndex(where: { $0.id == id }) {
//            overlays[idx].isEditing = true
//            selectedOverlayID = id
//        }
//    }
//    
//}
//
//// MARK: - ImagePicker
////struct ImagePicker: UIViewControllerRepresentable {
////    @Binding var selectedImage: UIImage?
////    @Environment(\.presentationMode) var presentationMode
////
////    func makeUIViewController(context: Context) -> UIImagePickerController {
////        let picker = UIImagePickerController()
////        picker.delegate = context.coordinator
////        picker.sourceType = .photoLibrary
////        return picker
////    }
////
////    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) { }
////
////    func makeCoordinator() -> Coordinator { Coordinator(self) }
////
////    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
////        let parent: ImagePicker
////        init(_ parent: ImagePicker) { self.parent = parent }
////
////        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
////            if let image = info[.originalImage] as? UIImage {
////                parent.selectedImage = image
////            }
////            parent.presentationMode.wrappedValue.dismiss()
////        }
////
////        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
////            parent.presentationMode.wrappedValue.dismiss()
////        }
////    }
////}
//
//// MARK: - ContentView
//struct ContentView: View {
//    @StateObject private var overlayVM = OverlayViewModel()
//    @State private var showImagePicker = false
//    @State private var selectedImage: UIImage?
//
//    var body: some View {
//        ZStack {
//            Color.gray.opacity(0.1).ignoresSafeArea()
//
//            // Overlay Layer
//            ForEach(overlayVM.overlays) { overlay in
//                ZStack {
//                    if let url = overlay.imageURL, let uiImage = UIImage(contentsOfFile: url.path) {
//                        Image(uiImage: uiImage)
//                            .resizable()
//                            .scaledToFit()
//                            .frame(width: 200, height: 200)
//                    } else {
//                        Text(overlay.text)
//                            .padding()
//                            .background(Color.yellow.opacity(0.3))
//                    }
//                }
//                .scaleEffect(overlay.scale)
//                .offset(overlay.offset)
//                .gesture(
//                    DragGesture()
//                        .onChanged { value in
//                            if overlay.id == overlayVM.selectedOverlayID {
//                                if let idx = overlayVM.overlays.firstIndex(where: { $0.id == overlay.id }) {
//                                    overlayVM.overlays[idx].offset = value.translation
//                                }
//                            }
//                        }
//                )
//                .onTapGesture {
//                    overlayVM.selectOverlay(overlay.id)
//                }
//            }
//
//            // Menu nổi 2 nút
//            HStack(spacing: 25) {
//                // Nút 1: NavigationLink
//                NavigationLink(destination: Text("Add Project View")) {
//                    Image("home_icBtn")
//                        .resizable()
//                        .scaledToFit()
//                        .frame(width: 65, height: 65)
//                }
//
//                // Nút 2: Chọn ảnh
//                Button(action: { showImagePicker = true }) {
//                    Image(systemName: "photo")
//                        .resizable()
//                        .scaledToFit()
//                        .frame(width: 65, height: 65)
//                }
//            }
//            .padding(.bottom, 30)
//            .frame(maxHeight: .infinity, alignment: .bottom)
//        }
//        .sheet(isPresented: $showImagePicker, onDismiss: loadSelectedImage) {
//            ImagePicker(selectedImage: $selectedImage)
//        }
//        .navigationTitle("Overlay Editor")
//    }
//
//    // Khi chọn xong ảnh, lưu local và gán overlay đang edit
//    func loadSelectedImage() {
//        guard let image = selectedImage,
//              let overlayID = overlayVM.selectedOverlayID,
//              let url = saveImageToLocal(image)
//        else { return }
//
//        overlayVM.updateOverlayImage(overlayID: overlayID, imageURL: url)
//    }
//
//    func saveImageToLocal(_ image: UIImage) -> URL? {
//        guard let data = image.jpegData(compressionQuality: 0.9) else { return nil }
//        let tempDir = FileManager.default.temporaryDirectory
//        let fileURL = tempDir.appendingPathComponent("\(UUID().uuidString).jpg")
//        do {
//            try data.write(to: fileURL)
//            return fileURL
//        } catch {
//            print("Error saving image: \(error)")
//            return nil
//        }
//    }
//}
//
//
//#Preview {
//    ContentView()
//}
