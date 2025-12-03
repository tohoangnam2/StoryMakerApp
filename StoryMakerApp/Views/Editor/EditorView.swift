//
//  AddProjectView.swift
//  StoryMakerApp
//
//  Created by to hoang nam on 19/8/25.
//

import SwiftUI
import UIKit

struct EditorView: View {
    
    @State var project: MainModel?
    var isNewProject: Bool = false
    @StateObject  var overlayVM = OverlayTextViewModel()
    @StateObject var vm = BackgroundEditorViewModel()
    @Environment(\.presentationMode) var presentationMode
    @State  var isShowBackgroundPicker = false
    @State var frame: Frame?
    
    // show bàn phím
    @FocusState private var isTextFieldFocused: Bool
    @State var isEditingText = false
    
    // edit text
    @State var selectedEditText : OverlayTextEditEnum = .none
    @State var selectedFontFamily : FontFmailyEnum? = nil
    @State private var editEnum: BackGroundEditEditEnum = .filter
    
    // snapshot
    @State var snapshotImage: UIImage? = nil
    @State private var triggerSnapshot: Bool = false
    
    @ObservedObject  var exportingVM = ExportingViewModel()
    var completion: ((UIImage) -> Void)? = nil
    
    // go home
    @State private var showExport = false
    @State private var goHome = false
    @State var lastEdit: BackGroundEditEditEnum = .filter
    @State var isCreateText : Bool = false
    var onDismiss: (() -> Void)?
    @State var panel : EditorPanelEnum = .default1
    @State var editingText : String = ""
    @State private var showExporting = false
    @State private var showPreviewFinal = false

    @EnvironmentObject var language: LanguageManager

    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom){
                VStack{
                    // top bar
                    HStack{
                        Button(action: {
                            saveAndExitExport(project: project,
                                              overlayVM: overlayVM,
                                              vm: vm) {
                                presentationMode.wrappedValue.dismiss()
                            }
                        }) {
                            Image("home_back")
                        }
                        Spacer()
                        
                        Button {
                            if vm.baseImage != nil {
                                saveAndExitExport(project: project,
                                                  overlayVM: overlayVM,
                                                  vm: vm) {
                                    exportingVM.resetState()
                                    showExporting = true
                                }
                            }
                        } label: {
                            Image("home_share")
                        }
                    }
                    .padding(.horizontal)
                    
                    ZStack (alignment: .bottom){
                        Group {
                            SnapshotContainer(
                                content:
                                    EditorCanvasView(
                                        overlayVM: overlayVM,
                                        frame: frame,
                                        isTextFieldFocused: $isTextFieldFocused,
                                        isEditingText: $isEditingText,
                                        onAddTap: { isShowBackgroundPicker = true },
                                        onTapOutside: { resetEditState() },
                                        onOpenBackgroundEditor: { panel = .backgroundEditor },
                                        isShowBackgroundPicker: $isShowBackgroundPicker,
                                        vm: vm,
                                        project: $project,
                                        isCreateText: $isCreateText,
                                        panel: $panel,
                                        editingText: $editingText
                                    )
                                    .onAppear {
                                        print("onapear")
                                        if let existingProject = project {
                                            print("Khôi phục project:", existingProject.id)
                                            overlayVM.overlays = existingProject.textLayers
                                            frame = existingProject.frame
                                            vm.loadFromProject(existingProject)
                                            // gán id của project đang edit = vm.currentFrameID này
                                            if let f = existingProject.frame {
                                                vm.currentFrameID = f.backgroundID
                                            }
                                        }
                                    },
                                snapshot: $snapshotImage,
                                trigger: $triggerSnapshot
                            )
                        }
                        
                        // view editor
                        switch panel {
                        case .default1:
                            DefaultPanel(
                                onAddText: {
                                    guard vm.baseImage != nil else { return }
                                    panel = .keyboard(text: "", isNew: true)
                                    // gán trị ban đầu
                                    editingText = ""
                                },
                                onBackground: {
                                    isShowBackgroundPicker = true
                                }
                            )
                            
                        case .keyboard(let text, let isNew):
                            KeyboardPanel(
                                // gán cho giá trị đang hiện thị trực tiếp của textfield
                                text: $editingText,
                                isNew: isNew,
                                onDone: { text, isNew in
                                    handleTextDone(text, isNew: isNew)
                                }
                            )
                            
                        case .textToolBar:
                            TextToolbarPanel(onSelectTool: { tool in
                                selectedEditText = tool
                                panel = .textDetail(tool)
                            })
                            
                        case .textDetail:
                            TextDetailPanel(tool: $selectedEditText,
                                            overlayVM: overlayVM,
                                            panel: $panel)
                            
                        default:
                            EmptyView()
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                
                // view background editor
                if panel == .backgroundEditor {
                    Color.white.opacity(0.01)
                        .ignoresSafeArea()
                        .transition(.opacity)
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                panel = .default1
                            }
                        }
                    
                    BackgroundEditorView(vm: vm,
                                         frame: frame,
                                         isShowBackgroundPicker: $isShowBackgroundPicker,
                                         project: $project,
                                         editEnum: $lastEdit,
                                         panel: $panel)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .animation(.easeInOut(duration: 0.2), value: panel)
                }
            }
            .onDisappear {
                onDismiss?()
                
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
                }
            }
        }
        .fullScreenCover(isPresented: $isShowBackgroundPicker) {
            BackGroundView { pickedFrame, pickedImage in
                handleBackgroundPicked(frame: pickedFrame, image: pickedImage)
            }
        }
        .navigationBarBackButtonHidden(true)
        .fullScreenCover(isPresented: $showExporting) {
            ExportFlowView(
                exportingVM: exportingVM,
                snapshotImage: $snapshotImage,
                project: $project,
                goHome: $goHome
            )
        }


        // back về root home
        .onChange(of: goHome) { newValue in
            if newValue {
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
    
    func resetEditState() {
        selectedEditText = .none
        overlayVM.deselect()
        panel = .default1
    }
    
    // MARK: - Export + Snapshot
    func saveAndExitExport(project: MainModel?,
                           overlayVM: OverlayTextViewModel,
                           vm: BackgroundEditorViewModel,
                           completion: @escaping () -> Void)
    {
        resetEditState()
        
        // bật trigger để SnapshotContainer chụp lại đúng canvas view
        triggerSnapshot = true
        
        // đợi 1 nhịp cho snapshot hoàn thành rồi mới lưu
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.saveProjectWithSnapshot(project: project,
                                         overlayVM: overlayVM,
                                         vm: vm,
                                         completion: completion)
        }
    }
    
    private func saveProjectWithSnapshot(project: MainModel?,
                                         overlayVM: OverlayTextViewModel,
                                         vm: BackgroundEditorViewModel,
                                         completion: @escaping () -> Void)
    {
        guard var currentProject = project else {
            print("0 có project hiện tại")
            completion()
            return
        }
        
        // Cập nhật các thuộc tính chỉnh sửa
        currentProject.textLayers = overlayVM.overlays
        currentProject.frame      = frame
        currentProject.blur       = vm.blur
        currentProject.shadow     = vm.shadow
        currentProject.opacity    = vm.opacity
        currentProject.lightness  = vm.lightness
        currentProject.saturation = vm.saturation
        currentProject.selectedFilter = vm.selectedFilter.rawValue
        currentProject.previewImage   = snapshotImage
        
        // Lưu project vào file
        ProjectStorage.saveProject(
            currentProject,
            previewImage: snapshotImage,
            baseImage: vm.baseImage
        )
        
        //  Cập nhật state cục bộ trong EditorView
        self.project = currentProject
        print(" Saved full project with snapshot & overlays")
        ProjectStorage.debugPrintProjectJSON(id: currentProject.id)
        
        completion()
    }

    private func ensureProject() {
        if project == nil {
            let newProject = vm.createEmptyProject()
            project = newProject
            frame = newProject.frame
        }
    }
    
    func handleBackgroundPicked(frame pickedFrame: Frame? ,image pickedImage: UIImage?) {
        // khi pick 1 ảnh xong thì mới tạo project , nếu chưa pick gì thì chưa tạo
        ensureProject()
        if let newFrame = pickedFrame {
            if vm.currentFrameID != newFrame.backgroundID {
                vm.currentFrameID = newFrame.backgroundID
                vm.resetFilterState()
                let finalImage = pickedImage ?? UIImage(named: "placeholder")!
                vm.baseImage = finalImage
                vm.generateThumbnails()
                updateProjectSaving(frame: newFrame, image: finalImage)
                return
            }
        }
        else if let uiImage = pickedImage {
            vm.baseImage = uiImage
            vm.generateThumbnails()
            updateProjectSaving(frame: nil, image: uiImage)
        }
    }
    
    private func updateProjectSaving(frame: Frame?, image: UIImage) {
        if var current = self.project {
            current.frame = frame
            current.previewImage = image
            current.selectedFilter = FilterType.none.rawValue
            ProjectStorage.saveProject(current,
                                       previewImage: image,
                                       baseImage: image)
            self.project = current
        }
    }

    public func handleTextDone(_ text: String, isNew: Bool) {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            panel = .default1
            return
        }
        if isNew {
            let newOverlay = overlayVM.addOverlay(trimmed)
            overlayVM.selectOverlay(newOverlay.id)
        } else {
            if let id = overlayVM.selectedOverlayID,
               let idx = overlayVM.overlays.firstIndex(where: { $0.id == id }) {
                overlayVM.overlays[idx].text = trimmed
            }
        }
        // reset
        overlayVM.editingOverlayID = nil
        panel = .textToolBar
        editingText = ""
    }
}

// MARK: - Helpers

extension View {
    // cho phép trả về nhiều view hay view khác nhau
    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool,
                             transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}

// MARK: - Snapshot Container (chỉ chụp đúng view được wrap)

struct SnapshotContainer<Content: View>: View {
    let content: Content
    @Binding var snapshot: UIImage?
    @Binding var trigger: Bool

    var body: some View {
        SnapshotRepresentable(
            snapshot: $snapshot,
            trigger: $trigger,
            rootView: content
        )
    }
}

struct SnapshotRepresentable<Content: View>: UIViewRepresentable {
    @Binding var snapshot: UIImage?
    @Binding var trigger: Bool
    let rootView: Content

    func makeUIView(context: Context) -> UIView {
        let container = UIView()
        let host = UIHostingController(rootView: rootView)
        host.view.backgroundColor = .clear
        host.view.translatesAutoresizingMaskIntoConstraints = false
        
        container.addSubview(host.view)
        
        NSLayoutConstraint.activate([
            host.view.topAnchor.constraint(equalTo: container.topAnchor),
            host.view.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            host.view.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            host.view.trailingAnchor.constraint(equalTo: container.trailingAnchor),
        ])
        
        return container
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        guard trigger else { return }
        
        DispatchQueue.main.async {
            uiView.layoutIfNeeded()
            let renderer = UIGraphicsImageRenderer(bounds: uiView.bounds)
            let image = renderer.image { _ in
                uiView.drawHierarchy(in: uiView.bounds, afterScreenUpdates: true)
            }
            snapshot = image
            trigger = false
        }
    }
}
