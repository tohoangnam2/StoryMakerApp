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
    
    @ObservedObject var vm : BackgroundEditorViewModel
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
    @State private var isInitialized = false
    
    //go home
    @State private var showExport = false
    @State private var goHome = false
        
    var body: some View {
        NavigationView {
            ZStack{
                VStack{
                    //top bar
                HStack{
                    Button(action: {
                        saveAndExitExport(
                            project: project,
                            overlayVM: overlayVM,
                            vm: vm
                        ) {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }) {
                        Image("home_back")
                    }

                    Spacer()
                    Button {
                        if frame != nil {
                            saveAndExitExport(
                                project: project,
                                overlayVM: overlayVM,
                                vm: vm
                            ) {
                                showPreview = true
                            }
                        }
                    } label: {
                        Image("home_share")
                    }
                }
                    .padding(.horizontal)
                    Spacer()
                    
                ZStack (alignment: .bottom){
                    
                    //view project
                    Group {
                        if let existingProject = vm.mainprojects.first(where: { $0.id == projectID }) {
                            AddBackgroundsView(
                                overlayVM: overlayVM,
                                frame: existingProject.frame,
                                showTextField: $showTextField,
                                isTextFieldFocused: $isTextFieldFocused,
                                isSelected: $isSelected,
                                isEditingText: $isEditingText,
                                onAddTap: { isShowBackgroundPicker = true },
                                onTapOutside: { resetEditState() },
                                onOpenBackgroundEditor: { showBackgroundEdit = true },
                                isShowBackgroundPicker: $isShowBackgroundPicker,
                                showBackgroundEdit: $showBackgroundEdit,
                                vm: vm,
                                filteredImage: vm.filteredImage,
                                project: $project
                            )
                            .onAppear {
                                guard !isInitialized else { return }
                                isInitialized = true

                                self.project = existingProject
                                overlayVM.overlays = existingProject.textLayers
                                frame = existingProject.frame

                                vm.blur = existingProject.blur
                                vm.opacity = existingProject.opacity
                                vm.lightness = existingProject.lightness
                                vm.saturation = existingProject.saturation

                                let folderURL = ProjectStorage.projectFolder(for: existingProject.id)

                                // Luôn load original.jpg làm baseImage
                                if let originalName = existingProject.originalImagePath {
                                    let originalURL = folderURL.appendingPathComponent(originalName)
                                    if FileManager.default.fileExists(atPath: originalURL.path),
                                       let data = try? Data(contentsOf: originalURL),
                                       let originalImage = UIImage(data: data) {
                                        vm.baseImage = originalImage
                                        vm.defaultPreview = originalImage
                                    }
                                }

                                // Nếu có filtered.jpg thì hiển thị filter preview, không thay base
                                if let filteredName = existingProject.filteredImagePath {
                                    let filteredURL = folderURL.appendingPathComponent(filteredName)
                                    if FileManager.default.fileExists(atPath: filteredURL.path),
                                       let data = try? Data(contentsOf: filteredURL),
                                       let filteredImg = UIImage(data: data) {

                                        vm.filteredImage = filteredImg
                                        vm.selectedFilter = FilterType(rawValue: existingProject.selectedFilter ?? "") ?? .none
                                        print(" Hiển thị filtered.jpg preview (base vẫn là original)")
                                        return
                                    }
                                }

                                //  Nếu không có filtered → apply filter lại
                                vm.selectedFilter = FilterType(rawValue: existingProject.selectedFilter ?? "") ?? .none
                                if vm.selectedFilter != .none {
                                    vm.applySelectedFilter(animated: false)
                                    print(" Apply lại filter từ original")
                                } else {
                                    vm.filteredImage = vm.baseImage
                                }
                            }


                        }
                        else {
                            AddBackgroundsView(
                                overlayVM: overlayVM,
                                frame: project?.frame,
                                showTextField: $showTextField,
                                isTextFieldFocused: $isTextFieldFocused,
                                isSelected: $isSelected,
                                isEditingText: $isEditingText,
                                onAddTap: { isShowBackgroundPicker = true },
                                onTapOutside: { resetEditState() },
                                onOpenBackgroundEditor: { showBackgroundEdit = true },
                                isShowBackgroundPicker: $isShowBackgroundPicker,
                                showBackgroundEdit: $showBackgroundEdit,
                                vm: vm,
                                filteredImage: vm.filteredImage,
                                project: $project
                            )
                            .onAppear {
                                if project == nil {
                                    let newProject = vm.createEmptyProject()
                                    self.project = newProject
                                    self.frame = newProject.frame
                                }
                            }
                        }
                    }
                    .modifier(SnapshotWrapper(isExport: isExport, snapshot: $snapshotImage, trigger: $triggerSnapshot))

                    
                    //view editor
                    if showBackgroundEdit {
                        BackgroundEditorView(vm: vm, overlayVM: overlayVM, frame: frame, isShowBackgroundPicker: $isShowBackgroundPicker, showBackgroundEdit: $showBackgroundEdit, isSelected: $isSelected, project: $project)
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
                                    if selectedEditText != .none {
                                        Group {
                                            switch selectedEditText {
                                            case .fontSize:
                                                TextView(overlayVM: overlayVM, selectedEditText: .fontSize)
                                            case .fontFamily:
                                                TextView(overlayVM: overlayVM, selectedEditText: .fontFamily)
                                            case .colorSolid:
                                                TextView(overlayVM: overlayVM, selectedEditText: .colorSolid)
                                            case .gradient:
                                                TextView(overlayVM: overlayVM, selectedEditText: .gradient)
                                            case .stroke:
                                                TextView(overlayVM: overlayVM, selectedEditText: .stroke)
                                            case .align:
                                                TextView(overlayVM: overlayVM, selectedEditText: .align)
                                            case .shadow:
                                                TextView(overlayVM: overlayVM, selectedEditText: .shadow)
                                            case .background:
                                                TextView(overlayVM: overlayVM, selectedEditText: .background)
                                            case .none:
                                                EmptyView()
                                            }
                                        }
                                        .transition(.asymmetric(
                                            insertion: .move(edge: .bottom).combined(with: .opacity),
                                            removal: .move(edge: .bottom).combined(with: .opacity)
                                        ))
                                        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: selectedEditText)

                                    }
                                }
                                .id(selectedEditText)
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
                        print("bỏ qua lưu")
                        return
                    }

                    guard vm.baseImage != nil || snapshotImage != nil else {
                        print(" Project chưa chọn background, ko lưu")
                        return
                    }
                    current.textLayers = overlayVM.overlays
                    current.frame      = frame
                    current.blur       = vm.blur
                    current.shadow     = vm.shadow
                    current.opacity    = vm.opacity
                    current.lightness  = vm.lightness
                    current.saturation = vm.saturation
                    current.selectedFilter = vm.selectedFilter.rawValue

                    // preview
                    if let snap = snapshotImage {
                        current.previewImage = snap
                        ProjectStorage.saveProject(current, previewImage: snap)
                        print(" Saved snapshot onDisappear")
                    } else if let filtered = vm.filteredImage {
                        current.previewImage = filtered
                        ProjectStorage.saveProject(current, previewImage: filtered)
                        print(" Saved filtered image onDisappear")
                    }
                }
            }
        }
        
        .fullScreenCover(isPresented: $isShowBackgroundPicker) {
            BackGroundView { picked in
                guard let newFrame = picked else { return }
                self.frame = newFrame
                vm.currentProject = project

                // Nếu background thực sự thay đổi
                if vm.currentFrameID != newFrame.backgroundID {
                    vm.currentFrameID = newFrame.backgroundID

                    //  Reset toàn bộ state filter + cache cũ
                    vm.resetFilterState()

                    if let url = newFrame.backgroundURL,
                       let data = try? Data(contentsOf: url),
                       let uiImage = UIImage(data: data) {

                        //  Cập nhật base image mới
                        vm.baseImage = uiImage
                        vm.defaultPreview = uiImage
                        vm.filteredImage = nil
                        vm.isImageLoaded = true
                        vm.objectWillChange.send()
                        vm.generateThumbnails()

                        //  Lưu lại project ngay lần đầu chọn background
                        if var current = self.project {
                            current.frame = newFrame
                            current.previewImage = uiImage
                            current.selectedFilter = FilterType.none.rawValue

                            //  Lưu cả base image và filtered (lúc đầu = nil)
                            ProjectStorage.saveProject(
                                current,
                                previewImage: uiImage,
                                baseImage: uiImage,
                                filteredImage: nil
                            )

                            //  Update vào RAM
                            if let index = vm.mainprojects.firstIndex(where: { $0.id == current.id }) {
                                vm.mainprojects[index] = current
                            } else {
                                vm.mainprojects.insert(current, at: 0)
                            }

                            self.project = current
                        }
                    } else {
                        print(" Không thể đọc ảnh từ background URL.")
                    }
                }
            }
        }
        .onChange(of: frame?.id) { _ in
            if selectedTab == 1 {
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
                          showBackgroundEdit: $showBackgroundEdit, snapshotImage: $snapshotImage, triggerSnapshot:$triggerSnapshot, vm: vm, filteredImage: vm.filteredImage, project: $project,goHome:$goHome)
        }
        
        //back về rôt home
        .onChange(of: goHome) { newValue in
            if newValue {
                presentationMode.wrappedValue.dismiss()
            }
        }

    }
    
    //reset
    func resetEditState() {
        selectedEditText = .none
        showTextField = false
        isTextFieldFocused = false
        isSelected = false
        overlayVM.deselectAll()
        showBackgroundEdit = false
        
    }
    func saveAndExitExport(
        project: MainModel?,
        overlayVM: OverlayTextViewModel,
        vm: BackgroundEditorViewModel,
        completion: @escaping () -> Void
    ) {
        isExport = true
        resetEditState()

        //  trigger snapshot
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            triggerSnapshot = true
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            guard var currentProject = project else {
                print("0 có project hiện tại")
                completion()
                return
            }

            // Ảnh snapshot / filtered / default
            let snap = snapshotImage ?? vm.filteredImage ?? vm.defaultPreview
            let filteredImage = vm.filteredImage ?? snap

            // Cập nhật các thuộc tính chỉnh sửa
            currentProject.textLayers = overlayVM.overlays
            currentProject.frame      = frame
            currentProject.blur       = vm.blur
            currentProject.shadow     = vm.shadow
            currentProject.opacity    = vm.opacity
            currentProject.lightness  = vm.lightness
            currentProject.saturation = vm.saturation
            currentProject.selectedFilter = vm.selectedFilter.rawValue
            currentProject.previewImage   = snap
            currentProject.filteredImagePath = "filtered.jpg"

            // Lưu project vào file
            ProjectStorage.saveProject(
                currentProject,
                previewImage: snap,
                baseImage: vm.baseImage,
                filteredImage: filteredImage
            )

            // Cập nhật lại danh sách project trong VM
            if let index = vm.mainprojects.firstIndex(where: { $0.id == currentProject.id }) {
                vm.mainprojects[index] = currentProject
                vm.mainprojects = Array(vm.mainprojects)
            } else {
                vm.mainprojects.insert(currentProject, at: 0)
            }

            self.project = currentProject
            print(" Saved full project with snapshot & overlays")
            ProjectStorage.debugPrintProjectJSON(id: currentProject.id)

            completion()
        }
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
//bọc lại view con luôn

//snapshoot view con
    struct SnapshotContainer<Content: View>: UIViewRepresentable {
        let content: Content
        @Binding var snapshot: UIImage?
        @Binding var trigger: Bool

        //render thành ảnh
        func makeUIView(context: Context) -> UIView {
            let container = UIView()
            let hosting = UIHostingController(rootView: content)
            hosting.view.backgroundColor = .clear
            hosting.view.translatesAutoresizingMaskIntoConstraints = false
            container.addSubview(hosting.view)

            NSLayoutConstraint.activate([
                hosting.view.topAnchor.constraint(equalTo: container.topAnchor),
                hosting.view.leadingAnchor.constraint(equalTo: container.leadingAnchor),
                hosting.view.trailingAnchor.constraint(equalTo: container.trailingAnchor),
                hosting.view.bottomAnchor.constraint(equalTo: container.bottomAnchor)
            ])

            return container
        }

        func updateUIView(_ uiView: UIView, context: Context) {
            if trigger {
                DispatchQueue.main.async {
                    let renderer = UIGraphicsImageRenderer(bounds: uiView.bounds)
                    let image = renderer.image { _ in
                        //vẽ lại toàn bộ giao diện
                        uiView.drawHierarchy(in: uiView.bounds, afterScreenUpdates: true)
                    }
                    snapshot = image
                    // tránh chup lai
                    trigger = false
                }
            }
        }
    }
struct SnapshotWrapper: ViewModifier {
    let isExport: Bool
    @Binding var snapshot: UIImage?
    //kH hanh dong chup
    @Binding var trigger: Bool

    func body(content: Content) -> some View {
        Group {
            if isExport {
                SnapshotContainer(content: content,
                                  snapshot: $snapshot,
                                  trigger: $trigger)
            } else {
                //kothi hien thi bthg
                content
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







