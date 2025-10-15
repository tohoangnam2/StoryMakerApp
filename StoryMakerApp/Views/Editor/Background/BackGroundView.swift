//
//  BackGroundView.swift
//  StoryMakerApp
//
//  Created by to hoang nam on 19/8/25.
//

import SwiftUI

struct BackGroundView: View {
    
    @ObservedObject var vm = BackGroundViewModel()
    
    @Environment(\.dismiss) var dismiss

    //next page
    
    @State private var selectedFrame: Frame? = nil
    @State var isNextPage = false
    
    @Binding var isShowBackgroundPicker : Bool

    
    let onPicked: (Frame?) -> Void

    
    var body: some View {
        NavigationView{
            ZStack{
                VStack{
                    HStack{
                        Button(action: {
                            dismiss()
                        }) {
                            Image("home_back")
                        }
                        Spacer()
                        Text("Background")
                            .font(.system(size: 18, weight: .medium, design: .default))
                        Spacer()
                        Button(action: {
                            onPicked(selectedFrame)
                                dismiss()
                        }) {
                            Image("img_bg_check")
                                .foregroundColor(selectedFrame != nil ? .green : .gray)
                        }
                    }
                    .padding(.horizontal , 16)
                    VStack {
                        if let _ = vm.model {
                            CategoryTagView(vm: vm)
                                ScrollView {
                                    LazyVGrid(
                                        columns: Array(repeating: GridItem(.flexible(), spacing: 5), count: 5),
                                        spacing: 5
                                    ) {
                                        ForEach(vm.framesForSelectedCategory()) { frame in
                                                
                                                AsyncImage(url: frame.thumbURL) { img in
                                                    img.resizable()
                                                        .scaledToFill()
                                                }
                                                placeholder: {
                                                    Color.gray.opacity(0.3)
                                                }
                                                .frame(width: UIScreen.main.bounds.width/5 - 16,
                                                       height: UIScreen.main.bounds.width/5-16)
                                                .clipped()
                                                .cornerRadius(8)
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 8)
                                                        .stroke(selectedFrame?.id == frame.id ? Color.blue : Color.clear, lineWidth: 3)
                                                )
                                                .onTapGesture {
                                                    selectedFrame = frame
                                            }
                        
                                        }
                                    }
                                    .padding(.all, 12)
                                    
                                }
                                .refreshable {
                                    vm.fetch()
                                }

                        } else {
                            VStack {
                                   ScrollView(.horizontal) {
                                       HStack {
                                           ForEach(0..<5, id: \.self) { _ in
                                               RoundedRectangle(cornerRadius: 8)
                                                   .fill(Color.gray.opacity(0.3))
                                                   .frame(width: 80, height: 30)
                                                   .shimmering() // optional, nếu bạn muốn hiệu ứng shimmer

                                           }
                                       }
                                       .padding(.horizontal)
                                   }
                                   
                                   LazyVGrid(
                                       columns: Array(repeating: GridItem(.flexible(), spacing: 5), count: 5),
                                       spacing: 5
                                   ) {
                                       ForEach(0..<16, id: \.self) { _ in
                                           RoundedRectangle(cornerRadius: 8)
                                               .fill(Color.gray.opacity(0.3))
                                               .frame(width: UIScreen.main.bounds.width/5 - 16,
                                                      height: UIScreen.main.bounds.width/5 - 16)
                                       }
                                   }
                                   .padding(.all, 12)
                               }
                            Spacer()
                        }
                    }
                    
                    .onAppear{
                        vm.fetch()
                    }
                    
                }
                

                
            }
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationBarBackButtonHidden(true)
        
    }
    
}
struct CategoryTagView: View {
    @ObservedObject var vm: BackGroundViewModel
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(vm.model?.config.category ?? [], id: \.id) { category in
                    Text(category.name)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .foregroundColor(vm.selectedCategory?.id == category.id ? .red : .black)
                        .onTapGesture {
                            vm.selectedCategory = category
                        }
                }
            }
            .padding(.horizontal)
        }
    }
}

