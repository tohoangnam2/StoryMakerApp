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
    @EnvironmentObject var language: LanguageManager

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 32) {
                Spacer().frame(width: 6)
                
                toolbarButton(image: "img_edit1_text", title: language.localized("Edit", "Chỉnh"), tool: .fontSize)
                toolbarButton(image: "img_edit1_size", title: language.localized("Font", "Phông"), tool: .fontFamily)
                toolbarButton(image: "img_edit1_color", title:language.localized("Color", "Màu"), tool: .colorSolid)
                toolbarButton(image: "img_edit1_gradient", title: language.localized("Gradient", "Màu ghép"), tool: .gradient)
                toolbarButton(image: "img_edit1_stroke", title: language.localized("Stroke", "Viền"), tool: .stroke)
                toolbarButton(image: "img_edit1_align", title:language.localized("Align", "Căn chỉnh"), tool: .align)
                toolbarButton(image: "img_edit1_shadow", title: language.localized("Shadow", "Bóng"), tool: .shadow)
                toolbarButton(image: "img_edit1_bg", title: language.localized("Background", "Nền chữ"), tool: .background)
                
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

