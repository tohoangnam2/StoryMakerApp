//
//  TextDetailPanel.swift
//  StoryMakerApp
//
//  Created by Nam To on 19/11/25.
//

import SwiftUI

struct TextDetailPanel: View {
    
    @Binding var tool: OverlayTextEditEnum
    @ObservedObject var overlayVM: OverlayTextViewModel
    @Binding var panel : EditorPanelEnum
    @EnvironmentObject var language: LanguageManager

    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button { } label: {
                    Image("img_edit1_keyboard")
                }
                Spacer()
                Text(language.currentLanguage == .english ? tool.title : tool.titleVN)
                    .font(.system(size: 16, weight: .medium))
                Spacer()
                Button {
                    panel = .default1
                    overlayVM.selectedOverlayID = nil
                } label: {
                    Image("img_bg_check")
                }
                .background(.white)
            }
            .padding(.top, 10)
            .padding(.horizontal)
            HStack(spacing: 20) {
                iconButton("img_edit1_text", .fontSize)
                iconButton("img_edit1_size", .fontFamily)
                iconButton("img_edit1_color", .colorSolid)
                iconButton("img_edit1_gradient", .gradient)
                iconButton("img_edit1_stroke", .stroke)
                iconButton("img_edit1_align", .align)
                iconButton("img_edit1_shadow", .shadow)
                iconButton("img_edit1_bg", .background)
            }
            .padding(10)
            .padding(.horizontal, 12)
            .background(Color.gray.opacity(0.2).cornerRadius(70))
            // Nội dung chính
            Group {
                switch tool {
                case .fontSize:
                    TextView(overlayVM: overlayVM, selectedEditText: .fontSize)
                case .fontFamily:
                    TextView(overlayVM: overlayVM, selectedEditText: .fontFamily)
                case .colorSolid:
                    TextView(overlayVM: overlayVM, selectedEditText: .colorSolid)
                case .gradient:
                    TextView(overlayVM: overlayVM, selectedEditText: .gradient)
                case .stroke:
                    TextView(overlayVM: overlayVM, selectedEditText: .stroke)
                case .align:
                    TextView(overlayVM: overlayVM, selectedEditText: .align)
                case .shadow:
                    TextView(overlayVM: overlayVM, selectedEditText: .shadow)
                case .background:
                    TextView(overlayVM: overlayVM, selectedEditText: .background)
                case .none:
                    EmptyView()
                }
            }
        }
        .background(Color.white)
    }
    
    
    // Helper để tạo nút icon
    @ViewBuilder
    private func iconButton(_ imageName: String, _ type: OverlayTextEditEnum) -> some View {
        Image(imageName)
            .foregroundColor(tool == type ? .red : .black)
            .onTapGesture {
                tool = type
            }
    }
}
