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

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(FilterType.allCases) { filter in
                        VStack(spacing: 4) {
                            ZStack {
                                if let thumb = vm.thumbnails[filter] {
                                    Image(uiImage: thumb)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 70, height: 70)
                                        .cornerRadius(8)
                                } else {
                                    ProgressView()
                                        .frame(width: 70, height: 70)
                                }
                            }

                            Text(filter.displayName)
                                .font(.caption2)
                                .lineLimit(1)
                                .foregroundColor(vm.selectedFilter == filter ? .red : .primary)
                        }
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(vm.selectedFilter == filter ? Color.red : Color.clear, lineWidth: 2)
                        )
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
        }
        .onAppear {
            // Nếu baseImage đã có (từ frame đã chọn) → sinh thumbnail filter sẵn
            if let _ = vm.baseImage {
                vm.generateThumbnails()
            }
        }
    }
}

extension FilterType {
    var displayName: String {
        self.rawValue
            .replacingOccurrences(of: "CI", with: "")
            .replacingOccurrences(of: "Filter", with: "")
    }
}
