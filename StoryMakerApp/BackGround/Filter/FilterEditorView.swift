//
//  FilterEditorView.swift
//  StoryMakerApp
//
//  Created by Nam To on 10/9/25.
//

import SwiftUI

struct FilterEditorView: View {
    @EnvironmentObject var vm: BackgroundEditorViewModel
    
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
                    .padding(.horizontal,12)
                }
                ScrollView(.horizontal){
                    HStack {
                        let allBackgrounds = [vm.defaultBackgroundItem].compactMap { $0 } + vm.backgrounds

                        ForEach(allBackgrounds) { bg in
                            ZStack {
                                if bg.isDefault, let base = bg.baseImage {
                                    Image(uiImage: base)
                                        .resizable()
                                        .scaledToFill()
                                } else if let filtered = vm.previewImages[bg.image] {
                                    Image(uiImage: filtered)
                                        .resizable()
                                        .scaledToFill()
                                } else {
                                    ProgressView()                                }
                            }
                            .frame(width: 50, height: 50)
                            .clipped()
                            .onAppear {

                            }
                            .onTapGesture {
                                if bg.isDefault {
                                    vm.finalImage = bg.baseImage
                                    vm.selectedFilter = nil
                                } else {
                                    vm.selectedFilter = bg.image
                                    if let base = vm.baseImage {
                                        vm.loadSelectedFilter(baseImage: base) { filtered in
                                            vm.finalImage = filtered
                                        }
                                    }
                                }
                            }
                            
                        }
                    }
                    .padding()
                }
                
            }
            .padding(.top,5)
            .onAppear {
                vm.fetchCategories()
                vm.prepareAllPreviews()

            }
        
      
    }
}








