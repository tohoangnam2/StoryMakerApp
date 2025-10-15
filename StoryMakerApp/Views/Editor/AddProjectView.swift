//
//  AddProjectView.swift
//  StoryMakerApp
//
//  Created by to hoang nam on 19/8/25.
//

import SwiftUI



struct AddProjectView: View {
    
    @State var project: MainModel?
    
    @State var openedProjectID: UUID? = nil
    let projectID: UUID?
    var isNewProject: Bool = false
    
    
    
    @StateObject private var overlayVM = OverlayTextViewModel()
    @EnvironmentObject var vm: BackgroundEditorViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedTab: Int? = nil
    @State  var isShowBackgroundPicker = false
    @State  var showBackgroundEdit = false
    @State var frame: Frame?
    
    //show bàn phím
    @FocusState private var isTextFieldFocused: Bool
    @State  var showTextField: Bool = false
    @State var isSelected : Bool = false
    @State var isEditingText = false
    @State var isClick : Bool = false
    
    //bg text
    
    //edit text
    
    @State var selectedEditText : OverlayTextEditEnum = .none
    @State var selectedFontFamily : FontFmailyEnum? = nil
    @State private var editEnum: BackGroundEditEditEnum = .filter
    //snapshort
    @State private var showPreview = false
    @State private var takeSnapshot = false
    @State var snapshotImage: UIImage? = nil
    @State private var triggerSnapshot = false
    @StateObject private var exportingVM = ExportingViewModel()
    @State var isExport = false

    var completion: ((UIImage) -> Void)? = nil

    
    
    var body: some View {
        NavigationView {
            ZStack{
                VStack{
                    HStack{
                        Button(action: {
                            exitExport {
                                saveCurrentProject(project: project,
                                                   overlayVM: overlayVM,
                                                   vm: vm) {
                                    print("x : \(snapshotImage)")
                                    presentationMode.wrappedValue.dismiss()
                                }
                            }
                        }) {
                            Image("home_back")
                        }
                        Spacer()
                        Button {
                            resetEditState()
                            showPreview = true
                        } label: {
                            Image("home_share")
                        }
                    }
                    .padding(.horizontal)
                    Spacer()
                    
                    ZStack (alignment: .bottom){
                        if isExport {
                            SnapshotContainer(
                                content: AddBackgroundsView(
                                    overlayVM: overlayVM,
                                    frame: frame,
                                    showTextField: $showTextField,
                                    isTextFieldFocused: $isTextFieldFocused,
                                    isSelected: $isSelected,
                                    isEditingText: $isEditingText,
                                    onAddTap: { isShowBackgroundPicker = true },
                                    onTapOutside: {},
                                    onOpenBackgroundEditor: { showBackgroundEdit = true },
                                    isShowBackgroundPicker: $isShowBackgroundPicker,
                                    showBackgroundEdit: $showBackgroundEdit,
                                    filteredImage: vm.finalImage, project: $project
                                )
                                .environmentObject(vm),
                                snapshot: $snapshotImage,
                                trigger: $triggerSnapshot,
                            )
                        }
                    Group {
                        if let project = vm.mainprojects.first(where: { $0.id == projectID })  {
                                // mở lại project đã lưu
                                AddBackgroundsView(
                                    overlayVM: overlayVM,
                                    frame: frame,
                                    showTextField: $showTextField,
                                    isTextFieldFocused: $isTextFieldFocused,
                                    isSelected: $isSelected,
                                    isEditingText: $isEditingText,
                                    onAddTap: { isShowBackgroundPicker = true },
                                    onTapOutside: { resetEditState() },
                                    onOpenBackgroundEditor: { showBackgroundEdit = true },
                                    isShowBackgroundPicker: $isShowBackgroundPicker,
                                    showBackgroundEdit: $showBackgroundEdit,
                                    filteredImage: vm.finalImage, project: $project
                                )
                                .environmentObject(vm)
                                .onAppear {
                                    self.project = project
                                    overlayVM.overlays = project.textLayers
                                    frame = project.frame
                                    if let url = project.frame?.backgroundURL,
                                       let data = try? Data(contentsOf: url),
                                       let uiImage = UIImage(data: data) {
                                        vm.baseImage = uiImage
//                                      vm.defaultPreview = uiImage
                                        // apply lại filte  r LUT
                                        if let filter = project.selectedFilter {
                                            vm.selectedFilter = filter
                                            vm.loadSelectedFilter(baseImage: uiImage) { filtered in
                                                vm.finalImage = filtered
                                            }
                                        } else {
                                            vm.finalImage = uiImage
                                        }
                                    }
                                }
                            } else {
                                AddBackgroundsView(
                                    overlayVM: overlayVM,
                                    frame: frame,
                                    showTextField: $showTextField,
                                    isTextFieldFocused: $isTextFieldFocused,
                                    isSelected: $isSelected,
                                    isEditingText: $isEditingText,
                                    onAddTap: {
                                        isShowBackgroundPicker = true
                                        let newProject = vm.createEmptyProject()
                                        self.project = newProject
                                    },
                                    onTapOutside: { resetEditState() },
                                    onOpenBackgroundEditor: { showBackgroundEdit = true },
                                    isShowBackgroundPicker: $isShowBackgroundPicker,
                                    showBackgroundEdit: $showBackgroundEdit,
                                    filteredImage: vm.finalImage, project: $project
                                )
                                .environmentObject(vm)
                                
                            }
                        }
                    if showBackgroundEdit {
                        BackgroundEditorView(overlayVM: overlayVM, frame: frame, isShowBackgroundPicker: $isShowBackgroundPicker, showBackgroundEdit: $showBackgroundEdit, isSelected: $isSelected, project: $project)
                                    .id(showBackgroundEdit) // ép SwiftUI coi là view mới mỗi lần đổi
                                    .transition(.move(edge: .bottom).combined(with: .opacity)) // trượt từ dưới lên + fade
                                    .animation(.easeInOut(duration: 0.2), value: showBackgroundEdit) // animate khi state thay đổi
                    }
                        else {
                            if  selectedEditText != .none {
                                VStack(spacing: 0) {
                                    VStack {
                                        HStack {
                                            Button(action: {}) {
                                                Image("img_edit1_keyboard")
                                            }
                                            Spacer()
                                            Text(selectedEditText.title)
                                                .font(.system(size: 16, weight: .medium))
                                            Spacer()
                                            Button(action: {
                                                selectedEditText = .none
                                            }) {
                                                Image("img_bg_check")
                                            }
                                            .background(.white)
                                        }
                                        .padding(.top, 10)
                                        .padding(.horizontal)
                                        HStack(spacing: 20) {
                                            iconButton("img_edit1_text", .fontSize)
                                            iconButton("img_edit1_size", .fontFamily)
                                            iconButton("img_edit1_color", .colorSolid)
                                            iconButton("img_edit1_gradient", .gradient)
                                            iconButton("img_edit1_stroke", .stroke)
                                            iconButton("img_edit1_align", .align)
                                            iconButton("img_edit1_shadow", .shadow)
                                            iconButton("img_edit1_bg", .background)
                                        }
                                        .padding(10)
                                        .padding(.horizontal, 12)
                                        .background(Color.gray.opacity(0.2).cornerRadius(70))

                                    }
                                    ZStack {
                                        switch selectedEditText {
                                        case .fontSize:
                                            TextView(overlayVM: overlayVM, selectedEditText: .fontSize)
                                                .transition(.opacity.combined(with: .move(edge: .bottom))) // fade + trượt từ dưới lên

                                        case .fontFamily:
                                            TextView(overlayVM: overlayVM, selectedEditText: .fontFamily)
                                                .transition(.opacity.combined(with: .move(edge: .bottom)))

                                        case .colorSolid:
                                            TextView(overlayVM: overlayVM, selectedEditText: .colorSolid)
                                                .transition(.opacity.combined(with: .move(edge: .bottom)))

                                        case .gradient:
                                            TextView(overlayVM: overlayVM, selectedEditText: .gradient)
                                                .transition(.opacity.combined(with: .move(edge: .bottom)))

                                        case .stroke:
                                            TextView(overlayVM: overlayVM, selectedEditText: .stroke)
                                                .transition(.opacity.combined(with: .move(edge: .bottom)))

                                        case .align:
                                            TextView(overlayVM: overlayVM, selectedEditText: .align)
                                                .transition(.opacity.combined(with: .move(edge: .bottom)))

                                        case .shadow:
                                            TextView(overlayVM: overlayVM, selectedEditText: .shadow)
                                                .transition(.opacity.combined(with: .move(edge: .bottom)))

                                        case .background:
                                            TextView(overlayVM: overlayVM, selectedEditText: .background)
                                                .transition(.opacity.combined(with: .move(edge: .bottom)))

                                        case .none:
                                            EmptyView()
                                        }
                                    }
                                    .id(selectedEditText)
                                    .transition(.opacity.combined(with: .move(edge: .bottom)))
                                    .animation(.easeInOut(duration: 0.35), value: selectedEditText)
                                }
                                .background(Color.white)
                            }
                            else {
                                if !isTextFieldFocused  {
                                    if !isSelected {
                                            HStack {
                                                Spacer()
                                                Button(action: {
                                                    guard frame != nil else { return }
                                                    let newOverlay = overlayVM.addOverlay("")
                                                    overlayVM.selectOverlay(newOverlay.id)
                                                    isTextFieldFocused = true
                                                    showTextField = true
                                                    isSelected = true
                                                }) {
                                                    VStack {
                                                        Image("home_tabbartext")
                                                        Text("Add Text")
                                                    }
                                                    .foregroundColor(.black.opacity(0.8))
                                                }
                                                Spacer()
                                                Button(action: {
                                                    isShowBackgroundPicker = true
                                                }) {
                                                    VStack {
                                                        Image("home_tabbarbg")
                                                        Text("Background")
                                                    }
                                                    .foregroundColor(.black.opacity(0.8))
                                                }
                                                Spacer()
                                            }
                                            .padding(.top)
                                            .background(ignoresSafeAreaEdges: .bottom)
                                                                                
                                    } else {
                                        ScrollView(.horizontal,showsIndicators: false){
                                            HStack (spacing: 16) {
                                                Spacer().frame(width: 16)
                                                Button(action: {
                                                    selectedEditText = .fontSize
                                                }) {
                                                    VStack {
                                                        Image("img_edit1_text")
                                                        Text("Edit")
                                                    }
                                                    .foregroundColor(.black.opacity(0.8))
                                                }
                                                Spacer()
                                                Button(action: {
                                                    selectedEditText = .fontFamily
                                                }) {
                                                    VStack {
                                                        Image("img_edit1_size")
                                                        Text("Size")
                                                    }
                                                    .foregroundColor(.black.opacity(0.8))
                                                }
                                                Spacer()
                                                Button(action: {
                                                    selectedEditText = .colorSolid
                                                }) {
                                                    VStack {
                                                        Image("img_edit1_color")
                                                        Text("Color")
                                                    }
                                                    .foregroundColor(.black.opacity(0.8))
                                                }
                                                Spacer()
                                                Button(action: {
                                                    selectedEditText = .gradient
                                                }) {
                                                    VStack {
                                                        Image("img_edit1_gradient")
                                                        Text("Gradient")
                                                    }
                                                    .foregroundColor(.black.opacity(0.8))
                                                }
                                                Spacer()
                                                Button(action: {
                                                    selectedEditText = .stroke
                                                }) {
                                                    VStack {
                                                        Image("img_edit1_stroke")
                                                        Text("Stroke")
                                                    }
                                                    .foregroundColor(.black.opacity(0.8))
                                                }
                                                Spacer()
                                                Button(action: {
                                                    selectedEditText = .align
                                                }) {
                                                    VStack {
                                                        Image("img_edit1_align")
                                                        Text("Align")
                                                    }
                                                    .foregroundColor(.black.opacity(0.8))
                                                }
                                                Spacer()
                                                Button(action: {
                                                    selectedEditText = .shadow
                                                }) {
                                                    VStack {
                                                        Image("img_edit1_shadow")
                                                        Text("Shadow")
                                                    }
                                                    .foregroundColor(.black.opacity(0.8))
                                                }
                                                Spacer()
                                                Button(action: {
                                                    selectedEditText = .background
                                                }) {
                                                    VStack {
                                                        Image("img_edit1_bg")
                                                        Text("BackGround")
                                                    }
                                                    .foregroundColor(.black.opacity(0.8))
                                                }
                                                Spacer().frame(width: 16)
                                            }
                                            .padding(.top)
                                            .background(ignoresSafeAreaEdges: .bottom)
                                            .background(.white)
                                        }
                                        .background(.white)
                                    }
                                }
                                else {
                                        HStack {
                                            Button(action: {
                                            }) {
                                                Image("img_textEdit")
                                                    .opacity(0)
                                            }
                                            Spacer()
                                            Text("Text Edit")
                                                .font(.system(size: 16, weight: .medium, design: .default))
                                            Spacer()
                                            Button(action: {
                                                showTextField = false
                                                isTextFieldFocused = false
                                                isSelected = true
                                            }) {
                                                Image("img_bg_check")
                                            }
                                            .background(.white)
                                        }
                                        .padding(.top, 8)
                                        .padding(.horizontal,20)
                                        .background(.white)
                                }
                            }
                        }

                    }
                }
                .onDisappear {
                    guard var current = project else {
                        print("Không có project, bỏ qua lưu")
                        return
                    }
                    guard vm.baseImage != nil || snapshotImage != nil else {
                        print("Project chưa chọn background, bỏ qua lưu")
                        return
                    }
                    // merge state từ vm.projectStates
                    if let snap = snapshotImage {
                        ProjectStorage.saveProject(current, previewImage: snap)
                        print("Saved snapshot onDisappear")
                    } else if let filtered = vm.finalImage {
                        ProjectStorage.saveProject(current, previewImage: filtered)
                        print("Saved filtered image onDisappear")
                    }
                }
            }
        }
        .fullScreenCover(isPresented: $isShowBackgroundPicker) {
            BackGroundView(isShowBackgroundPicker: $isShowBackgroundPicker) { picked in
                if let newFrame = picked {
                    self.frame = newFrame
                    vm.currentProject = project
                }
                if vm.currentFrameID != picked?.backgroundID {
                    vm.currentFrameID = picked?.backgroundID

//                    overlayVM.overlays.removeAll()
//                    overlayVM.addOverlay("")
                    vm.finalImage = nil
//                    vm.opacity = 1.0
//                    vm.selectedFilterImage = nil
//                    vm.selectedFilter = nil
//                    vm.previewImages.removeAll()

                    if let url = picked?.backgroundURL,
                       let data = try? Data(contentsOf: url),
                       let uiImage = UIImage(data: data) {
                        
                        // Gán baseImage
                        vm.baseImage = uiImage
                        vm.defaultPreview = uiImage

                        //  Lưu project ngay lần đầu chọn background
                        if var current = self.project {
                            current.frame = picked

                            // 1. Lưu ảnh gốc
                            let folderURL = ProjectStorage.projectFolder(for: current.id)
                            let originalURL = folderURL.appendingPathComponent("original.jpg")
                            try? data.write(to: originalURL)

                            // 2. Lưu JSON + preview (chưa có edit thì preview = ảnh gốc)
                            current.previewImage = uiImage
                            ProjectStorage.saveProject(current, previewImage: uiImage)

                            // 3. Update vào RAM
                            if let index = vm.mainprojects.firstIndex(where: { $0.id == current.id }) {
                                vm.mainprojects[index] = current
                            } else {
                                vm.mainprojects.insert(current, at: 0)
                            }
                            self.project = current
                        }
                    }
                }
            }
        }
        .onChange(of: frame?.id) { _ in
            if selectedTab == 1 {
//                overlayVM.overlays.removeAll()
//                overlayVM.addOverlay("")
                showTextField = false
            }
        }
        .navigationBarBackButtonHidden(true)
        .fullScreenCover(isPresented: $showPreview) {
            HomePreview(  exportingVM: exportingVM, overlayVM: overlayVM,
                          frame: frame,
                          showTextField: $showTextField,
                          isTextFieldFocused: $isTextFieldFocused,
                          isSelected: $isSelected,
                          isEditingText: $isEditingText,
                          onAddTap: { isShowBackgroundPicker = true },
                          onTapOutside: {  },
                          onOpenBackgroundEditor: { showBackgroundEdit = true },
                          isShowBackgroundPicker: $isShowBackgroundPicker,
                          showBackgroundEdit: $showBackgroundEdit, snapshotImage: $snapshotImage, triggerSnapshot:$triggerSnapshot, filteredImage: vm.finalImage, project: $project)
                          .environmentObject(vm)
        }
    }
    
    //func
    func resetEditState() {
        selectedEditText = .none
        showTextField = false
        isTextFieldFocused = false
        isSelected = false
        overlayVM.deselectAll()
        showBackgroundEdit = false
    }
//    func exitExport(completion: @escaping () -> Void) {
//        isExport = true
//        resetEditState()
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
//            triggerSnapshot = true
//        }
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
//            if let snap = snapshotImage,
//               let index = vm.mainprojects.firstIndex(where: { $0.id == project?.id }) {
//                vm.mainprojects[index].previewImage = snap
//                print("Snapshot captured: \(snap)")
//            } else {
//                print("Snapshot still nil")
//            }
//            completion()
//        }
//    }
    func exitExport(completion: @escaping () -> Void) {
        isExport = true
        resetEditState()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            triggerSnapshot = true
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            if let snap = snapshotImage,
               var current = project {
                //  Lưu ảnh full flatten cho thumbnail
                current.previewImage = snap
                ProjectStorage.saveProject(current, previewImage: snap)

                if let index = vm.mainprojects.firstIndex(where: { $0.id == current.id }) {
                    vm.mainprojects[index] = current
                    vm.mainprojects = Array(vm.mainprojects)
                }
                self.project = current
                print("Snapshot captured: \(snap)")
            } else {
                print("Snapshot still nil")
            }
            completion()
        }
    }


    func saveCurrentProject(project: MainModel?,overlayVM: OverlayTextViewModel,vm: BackgroundEditorViewModel,completion: @escaping () -> Void) {        
        guard var currentProject = project else {
            completion()
            return
        }
        // data vm
        // Lưu state
         currentProject.frame      = frame
         currentProject.blur       = project?.blur ?? 0
         currentProject.shadow     = project?.shadow ?? 0
         currentProject.opacity    = project?.opacity ?? 1
         currentProject.lightness  = project?.lightness ?? 0
         currentProject.saturation = project?.saturation ?? 1
         currentProject.previewImage = snapshotImage ?? vm.finalImage
         currentProject.textLayers = overlayVM.overlays
         currentProject.selectedFilter = vm.selectedFilter

         // Preview full flatten cho list
         if let snap = snapshotImage {
             currentProject.previewImage = snap
         } else if let filtered = vm.finalImage {
             currentProject.previewImage = filtered
         }
        
        // lưu docs
        ProjectStorage.saveProject(currentProject, previewImage: currentProject.previewImage)

        // Update vào RAM
        if let index = vm.mainprojects.firstIndex(where: { $0.id == currentProject.id }) {
            vm.mainprojects[index] = currentProject
            vm.mainprojects = Array(vm.mainprojects) // ép SwiftUI publish lại
        } else {
            vm.mainprojects.insert(currentProject, at: 0)
        }
        self.project = currentProject
        
        completion()
    }
    
    // Helper để tạo nút icon
    @ViewBuilder
    private func iconButton(_ imageName: String, _ type: OverlayTextEditEnum) -> some View {
        Image(imageName)
            .foregroundColor(selectedEditText == type ? .red : .black)
            .onTapGesture {
                selectedEditText = type
            }
    }
}

//snapshoot view con

struct SnapshotContainer<Content: View>: UIViewRepresentable {
    let content: Content
    @Binding var snapshot: UIImage?
    @Binding var trigger: Bool
    
    var completion: ((UIImage) -> Void)? = nil


    func makeUIView(context: Context) -> UIView {
        let hosting = UIHostingController(rootView: content)
        hosting.view.backgroundColor = .clear
        return hosting.view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        if trigger {
            DispatchQueue.main.async {
                let renderer = UIGraphicsImageRenderer(size: uiView.bounds.size)
                let image = renderer.image { _ in
                    uiView.drawHierarchy(in: uiView.bounds, afterScreenUpdates: true)
                }
                snapshot = image
                trigger = false
            }
        }
    }
}

// MARK: EXTENSION

extension View {
    @ViewBuilder
    func `if`<Content: View>(
        _ condition: Bool,
        transform: (Self) -> Content
    ) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}


//align

extension Text {
    func applyAlign(_ align: AlignEnum) -> some View {
        switch align {
        case .left:
            return self.frame(maxWidth: .infinity, alignment: .leading)
        case .center:
            return self.frame(maxWidth: .infinity, alignment: .center)
        case .right:
            return self.frame(maxWidth: .infinity, alignment: .trailing)
        case .none:
            return self.frame(maxWidth: .infinity, alignment: .center)

        }
    }
    
    func applyCase(_ textCase: AlignCaseEnum) -> Text {
        switch textCase {
        case .up:
            return Text(self.string.uppercased())
        case .cap:
            return Text(self.string.capitalized)
        case .low:
            return Text(self.string.lowercased())
        case .none:
            return Text(self.string.lowercased())

        }
    }
    
    // Helper property để lấy String từ Text
    private var string: String {
        let mirror = Mirror(reflecting: self)
        for child in mirror.children {
            if let storage = child.value as? String {
                return storage
            }
        }
        return ""
    }
}







