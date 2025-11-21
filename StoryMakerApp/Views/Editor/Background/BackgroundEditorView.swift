//
//  BackgroundEditorView.swift
//  StoryMakerApp
//
//  Created by Nam To on 10/9/25.
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

struct BackgroundEditorView: View {
    
    @ObservedObject var vm: BackgroundEditorViewModel
    @Environment(\.dismiss) private var dismiss
    let frame: Frame?
    @Binding var isShowBackgroundPicker : Bool
    @Binding var showBackgroundEdit : Bool
    @Binding var isSelected : Bool
    @Binding var project: MainModel?
    @Binding var editEnum: BackGroundEditEditEnum
    
    @Binding var panel: EditorPanelEnum
    
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
                            panel = .default1
                        }) {
                            Image("img_bg_check")
                        }
                        .background(.white)
                    }
                    .padding(.top, 10)
                    .padding(.horizontal)
                    
                    HStack(spacing: 20) {
                        Button(action: {
                            isShowBackgroundPicker = true
                            panel = .default1
                            
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
                    .scaleEffect(1.0)
                    .animation(.spring(response: 0.3, dampingFraction: 0.7), value: editEnum)
                }
                
                ZStack {
                    switch editEnum {
                    case .none:
                        EmptyView()
                    case .filter:
                        FilterEditorCIView(vm:vm)
                    case .brightness:
                        //unwrap get lay giari that xogn gán ngược lai
                        if let _ = project {
                            BrightNessBGView(
                                vm: vm, project: Binding(
                                    get: { project! },
                                    set: { project = $0 }
                                )
                            )
                        }   
                    }
                }
                .id(editEnum)
                .transition(.opacity.combined(with: .move(edge: .bottom)))
                .animation(.spring(response: 0.3, dampingFraction: 0.7), value: editEnum)

            }
        }
        .background(.white)
        .padding(.top,5)
    }
}
