//
//  FilterEditorView.swift
//  StoryMakerApp
//
//  Created by Nam To on 10/9/25.
//

import SwiftUI

struct FilterEditorView: View {
    @EnvironmentObject var vm: BackgroundEditorViewModel
    
    @Binding var project: MainModel
    
    
    
    
    var body: some View {
            
            VStack {
                CustomSliderRowBgOpacity(title: "Opacity", valueOpacity: $vm.opacity, sliderColor: .gray,thumbColor: .red.opacity(0.6))
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(vm.categories) { category in
                            Text(category.value)
                                .padding(6)
                                .foregroundColor(vm.selectedCategory?.id == category.id ? Color.red : Color.black.opacity(0.8))
                                .onTapGesture {
                                    vm.selectedCategory = category
                                }
                        }
                    }
                    .padding()
                }
                ScrollViewReader { proxy in
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(vm.allBackgrounds) { bg in
                                ZStack {
                                    if bg.isDefault, let base = bg.uiImage {
                                        Image(uiImage: base)
                                            .resizable()
                                            .scaledToFill()
                                    } else if let filtered = vm.previewImages[bg.image] {
                                        Image(uiImage: filtered)
                                            .resizable()
                                            .scaledToFill()
                                    } else {
                                        ProgressView()
                                    }
                                }
                                .frame(width: 50, height: 50)
                                .clipped()
                                .id(bg.id)
                                .onTapGesture {
                                    if bg.isDefault {
                                        vm.finalImage = bg.uiImage
                                        vm.selectedFilter = nil
                                        project.selectedFilter = nil //upadte
                                        project.previewImage = bg.uiImage
                                    } else {
                                        vm.selectedFilter = bg.image
                                        project.selectedFilter = bg.image //update filter cho proj
                                        if let base = vm.baseImage {
                                            vm.loadSelectedFilter(baseImage: base) { filtered in
                                                vm.finalImage = filtered
                                                project.previewImage = filtered
                                            }
                                        }
                                    }
                                    // Lưu vị trí filter đã chọn cho category hiện tại
                                    if let categoryID = vm.selectedCategory?.id {
                                        vm.lastSelectedFilterPosition[categoryID] = bg.id
                                    }

                                    withAnimation {
                                        proxy.scrollTo(bg.id, anchor: .center)
                                    }
                                }
                                .overlay(
                                    RoundedRectangle(cornerRadius: 2)
                                        .stroke(
                                            (bg.isDefault && vm.selectedFilter == nil) || vm.selectedFilter == bg.image
                                                ? Color.blue
                                                : Color.clear,
                                            lineWidth: 2
                                        )
                                )
                            }
                        }
                        .padding(.horizontal,12)
                    }
                    .onChange(of: vm.selectedCategory?.id) { newCategoryID in
                        guard let categoryID = newCategoryID else { return }
                        DispatchQueue.main.async {
                            if let selectedFilterID = vm.lastSelectedFilterPosition[categoryID] {
                                proxy.scrollTo(selectedFilterID, anchor: .center)
                            } else if let first = vm.allBackgrounds.first {
                                proxy.scrollTo(first.id, anchor: .leading)
                            }
                        }
                    }

                }
                .padding(.horizontal,12)


            }
            .padding(.top,5)
            .onAppear {
                vm.fetchCategories()
                // đồng bộ lại filter từ project
               
            }

        
      
    }
}








