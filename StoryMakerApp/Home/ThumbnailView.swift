////
////  ThumbnailView.swift
////  StoryMakerApp
////
////  Created by Nam To on 29/9/25.
////
//
//import SwiftUI
//
//struct ThumbnailView: View {
//    let project: MainModel
//    @ObservedObject private var overlayVM: OverlayTextViewModel
//    @FocusState private var isFocused: Bool
////    @EnvironmentObject var vm: BackgroundEditorViewModel
//    @EnvironmentObject var projectManager: ProjectManager
//
//
//    init(project: MainModel) {
//        self.project = project
//
//        // ví dụ canvas gốc 390pt, thumbnail 97pt
//        let scaleFactor: CGFloat = 97 / 390
//
//        // scale dữ liệu textLayers ngay khi khởi tạo VM
//        let scaledOverlays = project.textLayers.map { overlay -> OverlayTextModel in
//            var o = overlay
//            o.fontSize     *= scaleFactor
//            o.letterSpacing *= scaleFactor
//            o.lineHeight   *= scaleFactor
//            o.paddingBG    *= scaleFactor
//            o.blurSD       *= scaleFactor
//            o.offSetXSD    *= scaleFactor
//            o.offSetYSD    *= scaleFactor
//            o.offset = CGSize(width: o.offset.width * scaleFactor,
//                              height: o.offset.height * scaleFactor)
//            o.currentScale *= scaleFactor
//            o.buttonSize = (30 / o.currentScale) * scaleFactor
//
//            return o
//        }
//
//        _overlayVM = ObservedObject(
//            wrappedValue: OverlayTextViewModel(overlays: scaledOverlays)
//        )
//    }
//
//
//    var body: some View {
//        let projectVM = projectManager.editor(for: project)
//            AddBackgroundsView(
//                overlayVM: overlayVM,
//                frame: project.frame,
//                showTextField: .constant(false),
//                isTextFieldFocused: $isFocused,
//                isSelected: .constant(false),
//                isEditingText: .constant(false),
//                onAddTap: {},
//                onTapOutside: {},
//                onOpenBackgroundEditor: {},
//                isShowBackgroundPicker: .constant(false),
//                showBackgroundEdit: .constant(false),
//                filteredImage: project.filteredUIImage
//            )
//            .environmentObject(projectVM)
//            .frame(width: 97, height: 207)
//            .cornerRadius(8)
//            .allowsHitTesting(false)
// 
//            
//        
//    }
//}
//
////extension BackgroundEditorViewModel {
////    func updateProjectSettings(for projectID: UUID) {
////        // tìm project trong danh sách
////        guard let index = mainprojects.firstIndex(where: { $0.id == projectID }) else { return }
////        
////        // copy project hiện tại
////        var currentProject = mainprojects[index]
////        
////        // cập nhật các thông số filter từ vm
////        currentProject.blur       = self.blur
////        currentProject.shadow     = self.shadow
////        currentProject.opacity    = self.opacity
////        currentProject.lightness  = self.lightness
////        currentProject.saturation = self.saturation
////        
////        // lưu lại ảnh filter cuối cùng
////        if let final = self.finalImage,
////           let data = final.jpegData(compressionQuality: 0.8) {
////            currentProject.filteredImageData = data
////        }
////        
////        // gán lại vào mảng
////        mainprojects[index] = currentProject
////    }
////    
////}
