import SwiftUI
import PhotosUI

enum BackGroundTypeEnum {
   case photo
   case api
}

struct BackGroundView: View {
    
    @ObservedObject var vm = BackGroundViewModel()
    @Environment(\.dismiss) var dismiss
    @State private var selectedFrame: Frame? = nil
    @State private var pickedImage: UIImage? = nil
    @State private var showImagePicker = false
    @State var backgroundType: BackGroundTypeEnum = .api
    let onPicked: (Frame?, UIImage?) -> Void // callback trả Frame hoặc UIImage
    
    @State var isTransferring = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Top Bar
            HStack {
                Button(action: { dismiss() }) {
                    Image("home_back")
                }
                
                Spacer()
                Text("Background")
                    .font(.system(size: 18, weight: .medium))
                Spacer()
                
                Button(action: {
                    backgroundType = .photo
                    showImagePicker = true
                }) {
                    Image(systemName: "photo.on.rectangle")
                        .resizable()
                        .frame(width: 24, height: 24)
                }
                
                Button(action: {
                    onPicked(selectedFrame, pickedImage)
                    dismiss()
                }) {
                    Image("img_bg_check")
                        .foregroundColor(selectedFrame != nil || pickedImage != nil ? .green : .gray)
                }
                
            }
            .padding(.horizontal)
            
            Divider().padding(.vertical, 4)
            
            // Body
            ZStack{
                VStack {
                    if backgroundType == .api {
                        if let _ = vm.model {
                            CategoryTagView(vm: vm)
                            ScrollView {
                                LazyVGrid(
                                    columns: Array(repeating: GridItem(.flexible(), spacing: 5), count: 5),
                                    spacing: 5
                                ) {
                                    ForEach(vm.framesForSelectedCategory()) { frame in
                                        AsyncImage(url: frame.thumbURL) { img in
                                            img.resizable()
                                                .scaledToFill()
                                        } placeholder: {
                                            Color.gray.opacity(0.3)
                                        }
                                        .frame(width: UIScreen.main.bounds.width/5 - 16,
                                               height: UIScreen.main.bounds.width/5 - 16)
                                        .clipped()
                                        .cornerRadius(8)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 8)
                                                .stroke(selectedFrame?.id == frame.id ? Color.blue : Color.clear, lineWidth: 3)
                                        )
                                        .onTapGesture {
                                            selectedFrame = frame
                                            pickedImage = nil
                                        }
                                    }
                                }
                                .padding(12)
                            }
                            .refreshable {
                                vm.fetch()
                            }
                        }
                    }
                    if isTransferring {
                        ZStack {
                            Color.white.opacity(0.25)
                                .edgesIgnoringSafeArea(.bottom)
                                .transition(.opacity)
                            ProgressView()
                            Text("Loading…")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.white)
                        }
                        .padding(16)
                        .zIndex(1)
                    }
                }
                .onAppear {
                    if backgroundType == .api {
                        vm.fetch()
                    }
                }
            }
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .ignoresSafeArea(.all, edges: .bottom)
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(image: $pickedImage)
        }
        .onChange(of: pickedImage) { newImage in
            guard let img = newImage else { return }
            //  bật loading trước khi bắn callback
            isTransferring = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                onPicked(nil, img)
                // dismiss sau 0.15s để Editor có thời gian render ảnh
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                    dismiss()
                }
            }
        }
        .onChange(of: showImagePicker) { isShowing in
            if !isShowing && pickedImage == nil {
                withAnimation {
                    backgroundType = .api
                }
            }
        }
    }
}

// Category tags
struct CategoryTagView: View {
    @ObservedObject var vm: BackGroundViewModel
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(vm.model?.config.category ?? [], id: \.id) { category in
                    Text(category.name)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .foregroundColor(vm.selectedCategory?.id == category.id ? .red : .black)
                        .onTapGesture {
                            vm.selectedCategory = category
                        }
                }
            }
            .padding(.horizontal)
        }
    }
}

// SwiftUI wrapper cho PHPickerViewController
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 1

        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            guard let provider = results.first?.itemProvider else { return }

            if provider.canLoadObject(ofClass: UIImage.self) {
                provider.loadObject(ofClass: UIImage.self) { image, _ in
                    DispatchQueue.main.async {
                        self.parent.image = image as? UIImage
                    }
                }
            }
        }
    }
}
