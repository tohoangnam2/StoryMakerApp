//
//  ShadowColorPickerView.swift
//  StoryMakerApp
//
//  Created by Nam To on 9/9/25.
//

import SwiftUI

struct ShadowColorPickerView: View {
    @State private var shadowColor: Color = .black
    @State private var colors: Color = .black
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Aaa")
                .foregroundColor(colors
                )
                .padding(30)
                .background()
                .frame(width: 200, height: 100)
                .shadow(
                    color: shadowColor.opacity(0.5), // dùng màu picker
                    radius: 10,
                    x: 5,
                    y: 5
                )
            
            ColorPicker("Colors", selection: $colors)
                .padding()
        }
    }
}

#Preview {
    ShadowColorPickerView()
}
