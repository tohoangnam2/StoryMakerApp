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

    
    var body: some View {
        NavigationView {
            ZStack{
                VStack{
                    //top bar
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
                        if frame != nil {
                            exitExport {
                                saveCurrentProject(project: project,
                                                    overlayVM: overlayVM,
                                                    vm: vm) {
                                    print("x : \(snapshotImage)")
                                    
                                    showPreview = true
                                }
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
                                vm: vm,
                                filteredImage: vm.filteredImage, // dùng filteredImage thay cho finalImage
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

                                if let originalName = existingProject.originalImagePath {
                                    let folderURL = ProjectStorage.projectFolder(for: existingProject.id)
                                    let url = folderURL.appendingPathComponent(originalName)
                                    if FileManager.default.fileExists(atPath: url.path),
                                       let data = try? Data(contentsOf: url),
                                       let uiImage = UIImage(data: data) {

                                        vm.baseImage = uiImage

                                        if let filterRaw = existingProject.selectedFilter,
                                           let filter = FilterType(rawValue: filterRaw) {
                                            vm.selectedFilter = filter
                                        } else {
                                            vm.selectedFilter = .none
                                        }

                                        // ✅ Render lại preview filter hiện tại
                                        vm.filteredImage = nil
                                        vm.applySelectedFilter()
                                    }
                                }
                            }


                        } else {
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
                                filteredImage: vm.filteredImage, // dùng filteredImage thay cho finalImage
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
                    } else if let filtered = vm.filteredImage {
                        ProjectStorage.saveProject(current, previewImage: filtered)
                        print("Saved filtered image onDisappear")
                    }
                }
            }
        }
        
        .fullScreenCover(isPresented: $isShowBackgroundPicker) {
            BackGroundView() { picked in
                guard let newFrame = picked else { return }

                self.frame = newFrame
                vm.currentProject = project

                // Nếu background thay đổi
                if vm.currentFrameID != picked?.backgroundID {
                    vm.currentFrameID = picked?.backgroundID
                    vm.filteredImage = nil

                    if let url = picked?.backgroundURL,
                        let data = try? Data(contentsOf: url),
                        let uiImage = UIImage(data: data) {

                        vm.baseImage = uiImage
                        vm.filteredImage = nil
                        vm.applySelectedFilter(animated: false)


                        // Lưu project ngay lần đầu chọn background
                        if var current = self.project {
                            current.frame = picked

                            // 1. Lưu ảnh gốc
                            let folderURL = ProjectStorage.projectFolder(for: current.id)
                            let originalURL = folderURL.appendingPathComponent("original.jpg")
                            try? data.write(to: originalURL)

                            // 2. Lưu JSON + preview (preview = filteredImage nếu đã có filter, hoặc ảnh gốc)
                            current.previewImage = vm.filteredImage ?? uiImage
                            ProjectStorage.saveProject(current,
                                                        previewImage: current.previewImage,
                                                        baseImage: uiImage)

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
                          showBackgroundEdit: $showBackgroundEdit, snapshotImage: $snapshotImage, triggerSnapshot:$triggerSnapshot, vm: vm, filteredImage: vm.filteredImage, project: $project)
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
    
    func exitExport(completion: @escaping () -> Void) {
        isExport = true
        resetEditState()

        //  Delay nhỏ để cho UI snapshot ổn định
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            triggerSnapshot = true
        }

        //  Sau khi snapshot xong, lưu lại dự án
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            guard let snap = snapshotImage,
                  var current = project else {
                print("Snapshot still nil — retrying filter flatten")
                completion()
                return
            }

            //  Lưu filter + ảnh flatten vào project
            current.selectedFilter = vm.selectedFilter.rawValue
            current.previewImage = snap

            //  Ghi xuống bộ nhớ
            ProjectStorage.saveProject(current, previewImage: snap, baseImage: vm.baseImage)

            // ✅ Cập nhật trong danh sách chính
            if let index = vm.mainprojects.firstIndex(where: { $0.id == current.id }) {
                vm.mainprojects[index] = current
                vm.mainprojects = Array(vm.mainprojects)
            }

            self.project = current
            print("✅ Snapshot captured & project saved (\(current.id))")

            completion()
        }
    }
    
    func saveCurrentProject(
        project: MainModel?,
        overlayVM: OverlayTextViewModel,
        vm: BackgroundEditorViewModel,
        completion: @escaping () -> Void
    ) {
        guard var currentProject = project else {
            completion()
            return
        }

        // ✅ Lưu lại toàn bộ layer và filter hiện tại
        currentProject.textLayers = overlayVM.overlays
        currentProject.frame      = frame
        currentProject.blur       = vm.blur
        currentProject.shadow     = vm.shadow
        currentProject.opacity    = vm.opacity
        currentProject.lightness  = vm.lightness
        currentProject.saturation = vm.saturation
        currentProject.selectedFilter = vm.selectedFilter.rawValue
        currentProject.previewImage = snapshotImage ?? vm.filteredImage


        // ✅ Lưu preview — ưu tiên snapshot > final > filtered
        if let snap = snapshotImage {
            currentProject.previewImage = snap
        } else if let final = vm.filteredImage {
            currentProject.previewImage = final
        } else if let filtered = vm.filteredImage {
            currentProject.previewImage = filtered
        }

        // ✅ Ghi cả base image gốc (rất quan trọng)
        ProjectStorage.saveProject(
            currentProject,
            previewImage: currentProject.previewImage,
            baseImage: vm.baseImage
        )

        // ✅ Cập nhật trong RAM
        if let index = vm.mainprojects.firstIndex(where: { $0.id == currentProject.id }) {
            vm.mainprojects[index] = currentProject
            vm.mainprojects = Array(vm.mainprojects)
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
//bọc lại chuẩn view con luôn

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







