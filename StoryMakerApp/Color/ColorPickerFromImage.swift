//
//  ShadowColorPickerView.swift
//  StoryMakerApp
//
//  Created by Nam To on 9/9/25.
//

import SwiftUI

struct ColorPickerFromImage: View {
    @Binding var overlay: OverlayTextModel

    var body: some View {
        ZStack {
            Image("cs1")
                .resizable()
                .frame(width: 40, height: 40)
//                .colorMultiply(overlay.colorSolid)
                .allowsHitTesting(false) // ảnh không chặn sự kiện tap

            ColorPicker("Colors", selection: Binding<Color>(
                get: {
                    Color(overlay.colorSolid) ?? .black
                },
                set: { newColor in
                    overlay.colorSolid = newColor.toHex() ?? "#000000"
                }
            ))
                .labelsHidden()
                .opacity(0.02)
                .frame(width: 40, height: 40)
        }




    }
}




