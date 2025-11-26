//
//  Untitled.swift
//  StoryMakerApp
//
//  Created by Nam To on 19/11/25.
//

import SwiftUI

struct DefaultPanel: View {
    let onAddText: () -> Void
    let onBackground: () -> Void
    @EnvironmentObject var language: LanguageManager

    var body: some View {
        HStack {
            Spacer()
            Button(action: onAddText) {
                VStack {
                    Image("home_tabbartext")
                    Text(language.localized("Add Text", "Thêm Chữ"))
                }
                .foregroundColor(.black.opacity(0.8))
            }
            Spacer()
            
            Button(action: onBackground) {
                VStack {
                    Image("home_tabbarbg")
                    Text(language.localized("Background", "Hình Nền"))
                }
                .foregroundColor(.black.opacity(0.8))
            }
            Spacer()
        }
        .padding(.top)
        .background(ignoresSafeAreaEdges: .bottom)
    }
}

