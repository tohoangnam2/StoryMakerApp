//
//  HomePreview.swift
//  StoryMakerApp
//
//  Created by Nam To on 17/9/25.
//

import SwiftUI

struct HomePreview: View {
//    let snapshotImage: UIImage
    @ObservedObject var exportingVM: ExportingViewModel
    @Environment(\.dismiss) var dismiss
    
    
    @ObservedObject var overlayVM: OverlayTextViewModel
    
    @StateObject private var bgoverrlayVM = BackGroundViewModel()

    let frame: Frame?
    
    @Binding var showTextField: Bool
    @FocusState.Binding var isTextFieldFocused: Bool
    @Binding var isSelected : Bool
    @Binding var isEditingText : Bool
    let onAddTap: () -> Void
    
    let onTapOutside: () -> Void
    
    let onOpenBackgroundEditor: () -> Void

    @Binding var isShowBackgroundPicker: Bool
    @Binding var showBackgroundEdit: Bool
    
    
    @State private var isImageLoaded = false
    
    @FocusState private var fakeFocus: Bool

    
    
    //export
    @Binding  var snapshotImage: UIImage?
    @Binding var triggerSnapshot : Bool

    @ObservedObject var vm: BackgroundEditorViewModel

    let filteredImage: UIImage?

    @Binding var project: MainModel?

    var body: some View {
        VStack {
            HStack {
                Button(action: { dismiss() }) {
                    Image("home_back")
                }
                Spacer()
                Text("Preview")
                    .font(.system(size: 16, weight: .medium))
                Spacer()
                Image("home_back").opacity(0)
            }
            .padding()
            
            SnapshotContainer(content:
                                AddBackgroundsView(
                                    overlayVM: overlayVM,
                                    frame: frame,
                                    showTextField: .constant(false),
                                    isTextFieldFocused: $fakeFocus,
                                    isSelected: .constant(false),
                                    isEditingText: .constant(false),
                                    onAddTap: {},
                                    onTapOutside: {},
                                    onOpenBackgroundEditor: {},
                                    isShowBackgroundPicker: .constant(false),
                                    showBackgroundEdit: .constant(false), vm: vm,
                                    filteredImage: vm.finalImage, project: $project,

                                )
            , snapshot: $snapshotImage, trigger: $triggerSnapshot)
            .allowsHitTesting(false)
            .padding(.horizontal,20)

            

            ZStack {
                RoundedRectangle(cornerRadius: 60)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.bgSplash2, Color.bgSplash1]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(height: 50)

                Button(action: {
                    triggerSnapshot = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        if let image = snapshotImage {
                            // Nếu chưa có project thì tạo mới
                            var currentProject = project ?? MainModel(id: UUID())
                            currentProject.previewImage = image

                            // Update RAM
                            if let index = vm.mainprojects.firstIndex(where: { $0.id == currentProject.id }) {
                                vm.mainprojects[index] = currentProject
                            } else {
                                vm.mainprojects.insert(currentProject, at: 0)
                            }
                                // Export JPG ra thư mục + Photos
                                exportingVM.startExporting(projectID: currentProject.id, image: image)
                            
                        } else {
                            print(" Snapshot chưa kịp tạo")
                        }
                    }
                }) {
                    HStack {
                        Text("Export Photo")
                            .foregroundColor(.white)
                        Image("ic_right")
                    }
                }

            }
            .padding(.horizontal, 80)
        }
        .fullScreenCover(isPresented: $exportingVM.isExporting) {
            ExportingView(exportingVM: exportingVM)
        }
        .fullScreenCover(isPresented: $exportingVM.isDone) {
            ExportingDoneView(
                exportingVM: exportingVM, overlayVM: overlayVM,
                frame: frame,
                showTextField: $showTextField,
                isTextFieldFocused: $isTextFieldFocused,
                isSelected: $isSelected,
                isEditingText: $isEditingText,
                onAddTap: { isShowBackgroundPicker = true },
                onTapOutside: { },
                onOpenBackgroundEditor: { showBackgroundEdit = true },
                isShowBackgroundPicker: $isShowBackgroundPicker,
                showBackgroundEdit: $showBackgroundEdit,
                triggerSnapshot: $triggerSnapshot, vm: vm, filteredImage: vm.finalImage, snapshotImage: snapshotImage!
            )
            .environmentObject(vm)
        }
        
    }
}



