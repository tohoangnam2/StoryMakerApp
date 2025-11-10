//
//  AddProjectView.swift
//  StoryMakerApp
//
//  Created by to hoang nam on 19/8/25.
//

import SwiftUI



struct EditorView: View {
    
    @State var project: MainModel?
    @State var openedProjectID: UUID? = nil
    var isNewProject: Bool = false
    @StateObject  var overlayVM = OverlayTextViewModel()
    @StateObject var vm = BackgroundEditorViewModel()
    @ObservedObject var homeVM : HomeViewModel

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
    @State var lastEdit: BackGroundEditEditEnum = .filter
    
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom){
                VStack{
                    //top bar
                    HStack{
                        Button(action: {
                            saveAndExitExport(
                                project: project,
                                overlayVM: overlayVM,
                                vm: vm,
                                homeVM: homeVM
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
                                    vm: vm,
                                    homeVM: homeVM

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
                            EditorCanvasView(
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
                                filteredImage: vm.filteredImage,
                                project: $project
                            )
                            .onAppear {
                                print("onapear")
                                guard !isInitialized else { return }
                                isInitialized = true

                                if let existingProject = project {
                                    print("Khôi phục project cũ:", existingProject.id)
                                    overlayVM.overlays = existingProject.textLayers
                                    frame = existingProject.frame
                                    vm.loadFromProject(existingProject)
                                } else {
                                    let newProject = homeVM.createEmptyProject()
                                    project = newProject
                                    frame = newProject.frame
                                }
                            }
                        }
                        .modifier(SnapshotWrapper(isExport: isExport, snapshot: $snapshotImage, trigger: $triggerSnapshot))
                        
                        //view editor
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
                                            Spacer()
                                                .frame(width: 16)
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
                //view backgroundedit
                if showBackgroundEdit {
                    Color.white.opacity(0.01)
                        .ignoresSafeArea()
                        .transition(.opacity)
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                showBackgroundEdit = false
                                isSelected = false
                            }
                        }
                    BackgroundEditorView(vm: vm,frame: frame,isShowBackgroundPicker: $isShowBackgroundPicker,showBackgroundEdit:$showBackgroundEdit,isSelected:$isSelected,project:$project,editEnum:$lastEdit)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                        .animation(.easeInOut(duration: 0.2), value: showBackgroundEdit)
                }
            }
            .onDisappear {
                homeVM.loadProjects()
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
        
        .fullScreenCover(isPresented: $isShowBackgroundPicker) {
            BackGroundView { pickedFrame, pickedImage in
                if let newFrame = pickedFrame {
                    self.frame = newFrame
                    vm.currentProject = project
                    
                    if vm.currentFrameID != newFrame.backgroundID {
                        vm.currentFrameID = newFrame.backgroundID
                        vm.resetFilterState()
                        
                        if let url = newFrame.backgroundURL,
                           let data = try? Data(contentsOf: url),
                           let uiImage = UIImage(data: data) {
                            
                            vm.baseImage = uiImage
                            vm.defaultPreview = uiImage
                            vm.filteredImage = nil
                            vm.isImageLoaded = true
                            vm.objectWillChange.send()
                            vm.generateThumbnails()
                            
                            if var current = self.project {
                                current.frame = newFrame
                                current.previewImage = uiImage
                                current.selectedFilter = FilterType.none.rawValue
                                
                                ProjectStorage.saveProject(
                                    current,
                                    previewImage: uiImage,
                                    baseImage: uiImage,
                                    filteredImage: nil
                                )
                                
                                self.project = current
                                vm.currentProject = current
                            }
                        }
                    }
                }
                else if let uiImage = pickedImage {
                    // xử lý ảnh từ máy
                    vm.baseImage = uiImage
                    vm.defaultPreview = uiImage
                    vm.filteredImage = nil
                    vm.isImageLoaded = true
                    vm.objectWillChange.send()
                    vm.generateThumbnails()
                    
                    if var current = self.project {
                        current.frame = nil
                        current.previewImage = uiImage
                        current.selectedFilter = FilterType.none.rawValue
                        
                        ProjectStorage.saveProject(
                            current,
                            previewImage: uiImage,
                            baseImage: uiImage,
                            filteredImage: nil
                        )
                        
                        self.project = current
                        vm.currentProject = current
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
    
    func saveAndExitExport(project: MainModel?,overlayVM: OverlayTextViewModel,vm: BackgroundEditorViewModel,homeVM: HomeViewModel,completion: @escaping () -> Void) {
        
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
                // Lưu state cục bộ
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

extension View {
    //cho phép trả về nheiefu view hay viewkhac nhau 
    @ViewBuilder
    //trànorm closure đúng thì apply vào
    func `if`<Content: View>(_ condition: Bool,transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}








