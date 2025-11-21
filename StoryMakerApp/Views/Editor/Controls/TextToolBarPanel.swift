//
//  TextToolBarPanel.swift
//  StoryMakerApp
//
//  Created by Nam To on 19/11/25.
//

import SwiftUI

import SwiftUI

struct TextToolbarPanel: View {
    let onSelectTool: (OverlayTextEditEnum) -> Void
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 32) {
                Spacer().frame(width: 6)
                
                toolbarButton(image: "img_edit1_text", title: "Edit", tool: .fontSize)
                toolbarButton(image: "img_edit1_size", title: "Size", tool: .fontFamily)
                toolbarButton(image: "img_edit1_color", title: "Color", tool: .colorSolid)
                toolbarButton(image: "img_edit1_gradient", title: "Gradient", tool: .gradient)
                toolbarButton(image: "img_edit1_stroke", title: "Stroke", tool: .stroke)
                toolbarButton(image: "img_edit1_align", title: "Align", tool: .align)
                toolbarButton(image: "img_edit1_shadow", title: "Shadow", tool: .shadow)
                toolbarButton(image: "img_edit1_bg", title: "Background", tool: .background)
                
                Spacer().frame(width: 6)
            }
            .padding(.top)
            .background(.white)
        }
        .background(.white)
    }
    
    private func toolbarButton(image: String, title: String, tool: OverlayTextEditEnum) -> some View {
        Button(action: { onSelectTool(tool) }) {
            VStack {
                Image(image)
                Text(title)
            }
            .foregroundColor(.black)
        }
    }
}

