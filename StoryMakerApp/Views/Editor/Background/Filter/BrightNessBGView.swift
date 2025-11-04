//
//  BrightNessBGView.swift
//  StoryMakerApp
//
//  Created by Nam To on 10/9/25.
//

import SwiftUI

struct BrightNessBGView: View {
    
    @ObservedObject var vm: BackgroundEditorViewModel
    
    @Binding var project : MainModel
    
    var body: some View {
        VStack{
            CustomSliderBG(title: "Lightness", valueOpacity: $vm.lightness, minValue: -0.4, maxValue: 0.3, sliderColor: .gray, thumbColor: .red.opacity(0.6))
            CustomSliderBG(title: "Saturation", valueOpacity: $vm.saturation, minValue: 0.1, maxValue: 2.0, sliderColor: .gray, thumbColor: .red.opacity(0.6))
            CustomSliderBG(title: "Blur", valueOpacity: $vm.blur, minValue: 0.1, maxValue: 2.0, sliderColor: .gray, thumbColor: .red.opacity(0.6))
        }
        .padding(.top,5)
    }
}
struct CustomSliderBG: View {
    let title: String
    @Binding var valueOpacity: Double
    var minValue: Double = -1.0
    var maxValue: Double = 1.0
    var sliderColor: Color = .red
    var thumbColor: Color = .red
    var trackHeight: CGFloat = 3

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title)
                .font(.system(size: 12))
            HStack {
                CustomUISlider(
                                valueOpacity: $valueOpacity,
                                minValue: minValue,
                                maxValue: maxValue,
                                trackColor: .gray,
                                thumbColor: .red
                 )
                            .frame(height: 25)
                
                Text(String(format: "%.0f", valueOpacity * 10)) 
            }
        }
        .padding(.horizontal)
    }
}

