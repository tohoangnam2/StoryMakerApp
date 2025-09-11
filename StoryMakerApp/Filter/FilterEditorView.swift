//
//  FilterEditorView.swift
//  StoryMakerApp
//
//  Created by Nam To on 10/9/25.
//

import SwiftUI

struct FilterEditorView: View {
    @ObservedObject var vm = BackgroundEditorViewModel()
    
    var body: some View {
            
            VStack {
                CustomSliderRowColor(title: "Opacity", valueOpacity: $vm.opacity, sliderColor: .gray,thumbColor: .red.opacity(0.6))
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
                        ForEach(vm.backgrounds) { bg in
                            AsyncImage(url: URL(string: bg.image)) { img in
                                img.resizable().scaledToFill()
                            } placeholder: {
                                Color.gray
                            }
                            .frame(width: 50,height: 50)
                        }
                    }
                    .padding()
                }
            }
            .padding(.top,5)
            .onAppear {
                vm.fetchCategories()
            }
        
      
    }
}






