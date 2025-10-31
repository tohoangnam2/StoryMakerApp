//
//  HomeView.swift
//  StoryMakerApp
//
//  Created by to hoang nam on 19/8/25.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject var vm: BackgroundEditorViewModel = BackgroundEditorViewModel()
    @State private var selectedProjectID: UUID?
    @Binding var isShowPremium: Bool
    
    @State var isShowProject: Bool = false
    
    @State private var showImagePicker = false
    @State private var selectedImage: UIImage?

    @State private var isShowAddProject = false
    
    @State var project: MainModel?

    var body: some View {
        NavigationView{
            ZStack{
                VStack{
                    VStack{
                        //view tabbar
                        VStack(spacing: 25){
                            HStack{
                                Image("home_ictabbar")
                                Spacer()
                                Text("Art story".uppercased())
                                    .font(.system(size: 18, weight: .bold, design: .default))
                                Spacer()
                               
                                Button(action: {
                                    isShowPremium = true
                                }, label: {
                                    Image("home_premium")
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 30, height: 30)
                                        .padding(.trailing,18)
                                })
                                
                            }
                            .padding(.horizontal,20)
                            Text("Recent Project".uppercased())
                                .font(.system(size: 18, weight: .bold, design: .default))
                                .frame(maxWidth: .infinity, alignment: .topLeading)
                                .padding(.leading,25)
                        }
                        
                        //view preview
                        ScrollViewReader { proxy in
                            ScrollView(.vertical, showsIndicators: false) {
                                LazyVGrid(
                                    columns: Array(repeating: GridItem(.flexible()), count: 3),
                                    spacing: 16
                                ) {
                                    ForEach(vm.mainprojects, id: \.id) { project in
                                        if project.frame != nil {
                                            ZStack(alignment: .topTrailing) {
                                                Button(action: {
                                                    selectedProjectID = project.id
                                                }, label: {
                                                    let folderURL = ProjectStorage.projectFolder(for: project.id)
                                                    let previewURL = folderURL.appendingPathComponent("project_\(project.id).jpg")
                                                    
                                                    if let data = try? Data(contentsOf: previewURL),
                                                        let uiImage = UIImage(data: data) {
                                                        Image(uiImage: uiImage)
                                                            .resizable()
                                                            .scaledToFill()
                                                            .frame(width: 98, height: 208)
                                                            .cornerRadius(8)
                                                            .clipped()
                                                    } else {
                                                        Color.gray
                                                            .frame(width: 98, height: 208)
                                                            .cornerRadius(8)
                                                    }
                                                })
                                                Menu {
                                                    Button(role: .destructive) {
                                                        vm.deleteProject(project)
                                                    } label: {
                                                        Label("Delete", systemImage: "trash")
                                                    }
                                                    Button {
                                                        selectedProjectID = project.id
                                                    } label: {
                                                        Label("Edit", systemImage: "pencil")
                                                    }
                                                } label: {
                                                    Image(systemName: "ellipsis.circle")
                                                        .foregroundColor(.white)
                                                        .padding(6)
                                                }
                                                
                                                NavigationLink(
                                                    destination: AddProjectView(projectID: project.id, vm: vm),
                                                    tag: project.id,
                                                    selection: $selectedProjectID
                                                ) {
                                                    EmptyView()
                                                }
                                            }
                                            .id(project.id)
                                        }
                                    }
                                }
                                    .padding(.horizontal)
                            }
                            .onChange(of: vm.mainprojects.first?.id) { newID in
                                if let id = newID {
                                    withAnimation {
                                        proxy.scrollTo(id, anchor: .top)
                                    }
                                }
                            }
                        }
                        
                        
                    }
                    Spacer()
                }
            }

            //view add
            .overlay(
                VStack(spacing:15) {
                    Menu {
                        // 1. Tạo project trống
                        Button {
                            let newProject = vm.createEmptyProject()
                            self.project = newProject
                            self.isShowAddProject = true
                        } label: {
                            Label("Tạo project mới", systemImage: "plus.capsule")
                        }

                        // 2. Chọn ảnh từ thư viện
                        Button {
                            self.showImagePicker = true
                        } label: {
                            Label("Chọn ảnh từ thư viện", systemImage: "photo")
                        }

                    } label: {
                        Image(systemName: "ellipsis.circle")
                            .foregroundColor(.white)
                            .padding(6)
                    }

                    // NavigationLink ẩn để điều hướng
                    NavigationLink(
                        destination: AddProjectView(project: project,
                                                    projectID: project?.id,
                                                    vm: vm),
                        isActive: $isShowAddProject
                    ) {
                        EmptyView()
                    }
                    .hidden()
                },
                alignment: .bottom
            )
   

        }
        // Khi người dùng chọn ảnh từ photo library
        .sheet(isPresented: $showImagePicker, onDismiss: applySelectedImage) {
            ImagePicker(selectedImage: $selectedImage)
        }

        .onAppear {
            let projects = ProjectStorage.loadAllProjects()
            vm.mainprojects = projects
        }
        .fullScreenCover(isPresented: $isShowPremium) {
            SubcriptionView()
        }
        .navigationBarBackButtonHidden(true)
    }

   

    // Hàm áp dụng ảnh vừa chọn
    func applySelectedImage() {
        guard let image = selectedImage else { return }

        // 1. Tạo project mới
        let newProject = vm.createEmptyProject()
        self.project = newProject

        // 2. Lưu ảnh gốc vào thư mục project
        let folderURL = ProjectStorage.projectFolder(for: newProject.id)
        let filename = "original.jpg"
        let fileURL = folderURL.appendingPathComponent(filename)

        if let data = image.jpegData(compressionQuality: 0.9) {
            try? data.write(to: fileURL)
        }

        // 3. Cập nhật VM
        vm.baseImage = image
        vm.filteredImage = image
        vm.selectedFilter = .none

        // 4. Cập nhật project
        var updated = newProject
        updated.originalImagePath = filename
        updated.previewImage = image
        ProjectStorage.saveProject(updated, previewImage: image, baseImage: image)

        if let index = vm.mainprojects.firstIndex(where: { $0.id == updated.id }) {
            vm.mainprojects[index] = updated
        } else {
            vm.mainprojects.insert(updated, at: 0)
        }
        self.project = updated

        // 5. Điều hướng sang AddProjectView
        DispatchQueue.main.async {
            self.isShowAddProject = true
        }
    }


    
    

}
struct ImagePicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @Binding var selectedImage: UIImage?

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker
        init(_ parent: ImagePicker) { self.parent = parent }

        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}


