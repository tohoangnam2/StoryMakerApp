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
    
    var body: some View {
        HStack {
            Spacer()
            Button(action: onAddText) {
                VStack {
                    Image("home_tabbartext")
                    Text("Add Text")
                }
                .foregroundColor(.black.opacity(0.8))
            }
            Spacer()
            
            Button(action: onBackground) {
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
    }
}

