//
//  FilterEditorCIView.swift
//  StoryMakerApp
//
//  Created by Nam To on 29/10/25.
//

import SwiftUI

struct FilterEditorCIView: View {
    
    @ObservedObject var vm: BackgroundEditorViewModel

    var body: some View {
        VStack(spacing: 12) {
            CustomSliderRowBgOpacity(title: "Opacity", valueOpacity: $vm.opacity, sliderColor: .gray,thumbColor: .red.opacity(0.6))
            ScrollViewReader { proxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(FilterType.allCases) { filter in
                            VStack(spacing: 4) {
                                ZStack(alignment: .bottom) {
                                    if let thumb = vm.thumbnails[filter] {
                                        Image(uiImage: thumb)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 70, height: 90)
                                            .cornerRadius(8)
                                    } else {
                                        ProgressView()
                                            .frame(width: 70, height: 70)
                                    }
                                    Text(filter.displayName)
                                        .font(.system(size: 15))
                                        .fontWeight(.medium)
                                        .lineLimit(1)
                                        .foregroundColor(vm.selectedFilter == filter ? .white : .white.opacity(0.8))
                                        .padding(.bottom,6)
                                }
                            }
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(vm.selectedFilter == filter ? Color.red : Color.clear, lineWidth: 2)
                            )
                            .id(filter)
                            .onTapGesture {
                                guard vm.selectedFilter != filter else { return }
                                vm.selectedFilter = filter
                                vm.applySelectedFilter(animated: true)
                            }
                        }
                       
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                        proxy.scrollTo(vm.selectedFilter, anchor: .center)
                    }
                }
                .onChange(of: vm.selectedFilter) { newFilter in
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8, blendDuration: 0.8)) {
                            proxy.scrollTo(newFilter, anchor: .center)
                        }
                    }
                }


            }
        }
        .onAppear {
            // Nếu baseImage đã có (từ frame đã chọn) → sinh thumbnail filter sẵn
            if let _ = vm.baseImage {
                vm.generateThumbnails()
            }
        }
    }
}

