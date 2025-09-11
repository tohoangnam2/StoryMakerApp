//
//  BackgroundEditorView.swift
//  StoryMakerApp
//
//  Created by Nam To on 10/9/25.
//

import SwiftUI

struct BackgroundEditorView: View {
    @StateObject var vm = BackgroundEditorViewModel()
    
    @State var editEnum : BackGroundEditEditEnum = .filter

    var body: some View {
        ZStack{
            VStack {
                VStack{
                    HStack {
                        Button(action: {}) {
                            Image("img_edit1_keyboard")
                                .opacity(0)
                        }
                        Spacer()
                        Text(editEnum.title)
                            .font(.system(size: 16, weight: .medium))
                        Spacer()
                        Button(action: {
                        }) {
                            Image("img_bg_check")
                        }
                        .background(.white)
                    }
                    .padding(.horizontal)
                    HStack(spacing: 20) {
                        Button(action: {
                            editEnum = .none
                        }) {
                            Image("none")
                                .foregroundColor(editEnum == .none ? .red : .black)
                        }
                        Button(action: {
                            editEnum = .filter
                        }) {
                            Image("ic_filter")
                                .foregroundColor(editEnum == .filter ? .red : .black)
                        }
                        Button(action: {
                            editEnum = .brightness
                        }) {
                            Image("ic_brightness")
                                .foregroundColor(editEnum == .brightness ? .red : .black)
                        }
                    }
                    .padding(10)
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 12)
                    .background(Color.gray.opacity(0.2).cornerRadius(70))
                }
                ZStack {
                    switch editEnum {
                    case .none:
                        EmptyView()
                    case .filter:
                        FilterEditorView()
                    case .brightness:
                        BrightNessBGView()
                    }
                }
                .id(editEnum)
                .transition(.opacity.combined(with: .move(edge: .bottom)))
                .animation(.easeInOut(duration: 0.2), value: editEnum)
                
                

            }
        }
    }
}


