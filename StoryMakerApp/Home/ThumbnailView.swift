//
//  ThumbnailView.swift
//  StoryMakerApp
//
//  Created by Nam To on 29/9/25.
//

import SwiftUI

struct ThumbnailView: View {
    let project: MainModel
    @StateObject private var overlayVM: OverlayTextViewModel
    @FocusState private var isFocused: Bool
    @EnvironmentObject var vm: BackgroundEditorViewModel

    init(project: MainModel) {
        self.project = project
        _overlayVM = StateObject(wrappedValue: OverlayTextViewModel(overlays: project.textLayers))
    }

    var body: some View {
        AddBackgroundsView(
            overlayVM: overlayVM,
            frame: project.frame,
            showTextField: .constant(false),
            isTextFieldFocused: $isFocused,
            isSelected: .constant(false),
            isEditingText: .constant(false),
            onAddTap: {},
            onTapOutside: {},
            onOpenBackgroundEditor: {},
            isShowBackgroundPicker: .constant(false),
            showBackgroundEdit: .constant(false),
            filteredImage: nil
        )
        .environmentObject(vm)
        .frame(width: 97, height: 207)
        .cornerRadius(8)
        .allowsHitTesting(false)
    }
}

