//
//  TextView.swift
//  StoryMakerApp
//
//  Created by to hoang nam on 19/8/25.
//

import SwiftUI

struct TextView: View {
    
    @ObservedObject var overlayVM: OverlayTextViewModel
    
    var selectedEditText: OverlayTextEditEnum
    @EnvironmentObject var language: LanguageManager

    
    static let solidColors: [String] = [
        "#000000",
        "#742A2A", "#9B2C2C", "#C53030", "#E53E3E", "#F56565", "#FC8181", "#FEB2B2", "#FED7D7", "#FFF5F5",
        "#7B341E", "#9C4221", "#C05621", "#DD6B20", "#ED8936", "#F6AD55", "#FBD38D", "#FEEBC8", "#FFFAF0",
        "#744210", "#975A16", "#B7791F", "#D69E2E", "#ECC94B", "#F6E05E", "#FAF089", "#FEFCBF", "#FFFFF0",
        "#22543D", "#276749", "#2F855A", "#38A169", "#48BB78", "#68D391", "#9AE6B4", "#C6F6D5", "#F0FFF4",
        "#234E52", "#285E61", "#2C7A7B", "#319795", "#38B2AC", "#4FD1C5", "#81E6D9", "#B2F5EA", "#E6FFFA",
        "#2A4365", "#2C5282", "#2B6CB0", "#3182CE", "#4299E1", "#63B3ED", "#90CDF4", "#BEE3F8", "#EBF8FF",
        "#3C366B", "#434190", "#4C51BF", "#5A67D8", "#667EEA", "#7F9CF5", "#A3BFFA", "#C3DAFE", "#EBF4FF",
        "#44337A", "#553C9A", "#6B46C1", "#805AD5", "#9F7AEA", "#B794F4", "#D6BCFA", "#E9D8FD", "#FAF5FF",
        "#702459", "#97266D", "#B83280", "#D53F8C", "#ED64A6", "#F687B3", "#FBB6CE", "#FED7E2"]
    
    static let gradientColors: [[String]] = [
        
        ["#234E52", "#285E61"],
        ["#2C7A7B", "#319795"],
        ["#38B2AC", "#4FD1C5"],
        ["#81E6D9", "#B2F5EA"],
        ["#E6FFFA", "#2A4365"],
        ["#2C5282", "#2B6CB0"],
        ["#4299E1", "#63B3ED"],
        ["#90CDF4", "#BEE3F8"],
        ["#EBF8FF", "#3C366B"],
        ["#434190", "#4C51BF"],
        ["#5A67D8", "#667EEA"],
        ["#7F9CF5", "#A3BFFA"],
        ["#C3DAFE", "#EBF4FF"],
        ["#44337A", "#553C9A"],
        ["#6B46C1", "#805AD5"],
        ["#9F7AEA", "#B794F4"],
        ["#D6BCFA", "#E9D8FD"],
        ["#FAF5FF", "#702459"],
        ["#97266D", "#B83280"],
        ["#D53F8C", "#ED64A6"],
        ["#F687B3", "#FBB6CE"],
    ]
    
    static let bgColors: [String] = [
        "#000000",
        "#742A2A", "#9B2C2C", "#C53030", "#E53E3E", "#F56565", "#FC8181", "#FEB2B2", "#FED7D7", "#FFF5F5",
        "#7B341E", "#9C4221", "#C05621", "#DD6B20", "#ED8936", "#F6AD55", "#FBD38D", "#FEEBC8", "#FFFAF0",
        "#744210", "#975A16", "#B7791F", "#D69E2E", "#ECC94B", "#F6E05E", "#FAF089", "#FEFCBF", "#FFFFF0",
        "#22543D", "#276749", "#2F855A", "#38A169", "#48BB78", "#68D391", "#9AE6B4", "#C6F6D5", "#F0FFF4",
        "#234E52", "#285E61", "#2C7A7B", "#319795", "#38B2AC", "#4FD1C5", "#81E6D9", "#B2F5EA", "#E6FFFA",
        "#2A4365", "#2C5282", "#2B6CB0", "#3182CE", "#4299E1", "#63B3ED", "#90CDF4", "#BEE3F8", "#EBF8FF",
        "#3C366B", "#434190", "#4C51BF", "#5A67D8", "#667EEA", "#7F9CF5", "#A3BFFA", "#C3DAFE", "#EBF4FF",
        "#44337A", "#553C9A", "#6B46C1", "#805AD5", "#9F7AEA", "#B794F4", "#D6BCFA", "#E9D8FD", "#FAF5FF",
        "#702459", "#97266D", "#B83280", "#D53F8C", "#ED64A6", "#F687B3", "#FBB6CE", "#FED7E2"]
    
    
    var body: some View {
        VStack{
            if let overlay = $overlayVM.overlays.first(where: { $0.id == overlayVM.selectedOverlayID }) {
                switch selectedEditText {
                case .fontSize:
                    VStack{
                        VStack(spacing: 2) {
                            CustomSliderRow(title: language.localized("Font Size", "Cỡ chữ"), value: overlay.fontSize, minValue: 15.0, maxValue: 80.0, sliderColor: .gray, thumbColor: .red.opacity(0.6))
                            CustomSliderRow(title: language.localized("Line Height", "Chiều cao dòng"), value: overlay.lineHeight, minValue: 15.0, maxValue: 80.0, sliderColor: .gray, thumbColor: .red.opacity(0.6))
                            CustomSliderRow(title: language.localized("Letter Spacing", "Khoảng cách chữ"), value: overlay.letterSpacing, minValue: 0, maxValue: 20.0, sliderColor: .gray, thumbColor: .red.opacity(0.6))
                        }
                        .padding()
                    }
                    
                case .fontFamily:
                    VStack{
                        LazyVGrid(
                            columns: Array(repeating: GridItem(.flexible(), spacing: 5), count: 3),
                            spacing: 5
                        ) {
                            ForEach(FontFmailyEnum.allCases, id: \.self) { font in
                                Text(font.titleFF)
                                    .font(.custom(font.fontFamily, size: 16))
                                    .frame(width: 114, height: 40)
                                    .frame(maxWidth: .infinity)
                                    .aspectRatio(4/3, contentMode: .fit)
                                    .background(
                                        font == overlay.selectedFontFamily.wrappedValue ? Color.white : Color.gray.opacity(0.3)
                                    )
                                    .clipped()
                                    .cornerRadius(8)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(
                                                font == overlay.selectedFontFamily.wrappedValue ? Color.red : Color.clear,
                                                lineWidth: 3
                                            )
                                    )
                                    .onTapGesture {
                                        overlay.selectedFontFamily.wrappedValue = font
                                    }
                            }
                        }
                        .frame(height: 200)
                    }
                    
                case .colorSolid:
                    VStack{
                        CustomSliderOpacity(title: language.localized("Opacity", "Độ mờ"), valueOpacity:overlay.valueOpacity, sliderColor: .gray,thumbColor: .red.opacity(0.6))
                        ScrollViewReader { proxy in
                            ScrollView(.horizontal,showsIndicators: false) {
                                HStack() {
                                    ColorPickerFromImage(overlay: overlay)
                                    
                                    ForEach(TextView.solidColors, id: \.self) { color in
                                        Circle()
                                            .frame(width: 40, height: 40)
                                            .foregroundColor(Color(color))
                                            .id(color)
                                            .onTapGesture {
                                                overlay.userGradient.wrappedValue = false
                                                overlay.colorSolid.wrappedValue = color
                                            }
                                            .overlay(
                                                Circle()
                                                    .strokeBorder( overlay.colorSolid.wrappedValue == color ? Color.red: Color.clear,lineWidth: 3)
                                            )
                                    }
                                }
                                .padding(.horizontal)
                                
                            }
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                                    proxy.scrollTo(overlay.colorSolid.wrappedValue, anchor: .center)
                                }
                                
                            }
                            .onChange(of: overlay.colorSolid.wrappedValue) { newColor in
                                withAnimation(.easeInOut(duration: 0.25)) {
                                    proxy.scrollTo(newColor, anchor: .center)
                                }
                            }
                            
                        }
                        
                    }
                    .padding(.leading, 8)
                    
                case .gradient:
                    VStack {
                        CustomSliderOpacity(title: language.localized("Opacity", "Độ mờ"), valueOpacity: overlay.valueOpacity, sliderColor: .gray, thumbColor: .red.opacity(0.6))
                        ScrollViewReader { proxy in
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack {
                                    ColorPickerFromImage(overlay: overlay)
                                    
                                    ForEach(0..<TextView.gradientColors.count, id: \.self) { gradientIndex in
                                        let first = Color(TextView.gradientColors[gradientIndex][0])
                                        let second = Color(TextView.gradientColors[gradientIndex][1])
                                        Circle()
                                            .fill(
                                                LinearGradient(
                                                    gradient: Gradient(colors: [first, second]),
                                                    startPoint: .topLeading,
                                                    endPoint: .bottomTrailing
                                                )
                                            )
                                            .frame(width: 40, height: 40)
                                            .id(gradientIndex)
                                            .onTapGesture {
                                                overlay.colorGradient.wrappedValue = [
                                                    first.toHex() ?? "#FFFFFF",
                                                    second.toHex() ?? "#FFFFFF"
                                                ]
                                                overlay.userGradient.wrappedValue = true
                                            }
                                            .overlay(
                                                Circle()
                                                    .strokeBorder( overlay.colorGradient.wrappedValue == [
                                                        first.toHex() ?? "#FFFFFF",
                                                        second.toHex() ?? "#FFFFFF"
                                                    ] ? Color.red: Color.clear,lineWidth: 3)
                                            )
                                        
                                    }
                                }
                                .padding(.horizontal)
                            }
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                                    if let targetIndex = TextView.gradientColors.firstIndex(where: { pair in
                                        pair == overlay.colorGradient.wrappedValue
                                    }) {
                                        proxy.scrollTo(targetIndex, anchor: .center)
                                    }
                                }
                            }
                            .onChange(of: overlay.colorGradient.wrappedValue) { newColor in
                                if let targetIndex = TextView.gradientColors.firstIndex(where: { pair in
                                    pair == newColor
                                }) {
                                    withAnimation(.easeInOut(duration: 0.25)) {
                                        proxy.scrollTo(targetIndex, anchor: .center)
                                    }
                                }
                            }
                            
                            
                        }
                    }
                    .padding(.leading, 8)
                case .stroke:
                    VStack {
                        CustomSliderRow(title: language.localized("Stroke Width", "Độ dày viền"), value: overlay.strokeWidth, minValue: 0, maxValue: 30.0, sliderColor: .gray, thumbColor: .red.opacity(0.6))
                        CustomSliderOpacity(title: language.localized("Opacity", "Độ mờ"), valueOpacity: overlay.valueOpacity, sliderColor: .gray, thumbColor: .red.opacity(0.6))
                        ScrollViewReader { proxy in
                            ScrollView(.horizontal) {
                                HStack {
                                    ColorPickerFromImage(overlay: overlay)
                                    
                                    ForEach(TextView.solidColors, id: \.self) { color in
                                        Circle()
                                            .foregroundColor(Color(color))
                                            .frame(width: 40, height: 40)
                                            .id(color)
                                            .onTapGesture {
                                                overlay.colorSolid.wrappedValue = color
                                            }
                                            .overlay(
                                                Circle()
                                                    .strokeBorder( overlay.colorSolid.wrappedValue == color ? Color.red: Color.clear,lineWidth: 3)
                                            )
                                    }
                                }
                                .padding(.horizontal)
                            }
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                                    proxy.scrollTo(overlay.colorSolid.wrappedValue, anchor: .center)
                                }
                                
                            }
                            .onChange(of: overlay.colorSolid.wrappedValue) { newColor in
                                withAnimation(.easeInOut(duration: 0.25)) {
                                    proxy.scrollTo(newColor, anchor: .center)
                                }
                            }
                            
                        }
                    }
                    .padding(.leading, 8)
                case .align:
                    VStack{
                        CustomAlign(title: language.localized("Align", "Căn chữ"), selectedAlign: overlay.selectedAlign)
                        CustomAlignCase(title:  language.localized("Case", "Kiểu chữ"), selectedAlignCase: overlay.selectedAlignCase)
                        CustomSliderRow(title:  language.localized("Curve", "Độ cong"), value: overlay.cuver, minValue: 0, maxValue: 30.0, sliderColor: .gray, thumbColor: .red.opacity(0.6))
                    }
                    .padding(.top, 12)
                    
                case .background:
                    VStack{
                        CustomSliderRow(title: language.localized("Padding", "Khoảng cách"), value: overlay.paddingBG, minValue: 0, maxValue: 100.0, sliderColor: .gray, thumbColor: .red.opacity(0.6))
                        CustomSliderRow(title:language.localized("Corner", "Bo góc"), value: overlay.cornerRadiusBG, minValue: 0, maxValue: 100.0, sliderColor: .gray, thumbColor: .red.opacity(0.6))
                        CustomSliderOpacity(title: language.localized("Opacity", "Độ mờ"), valueOpacity: overlay.opacityBG, minValue: 0.1, maxValue: 1,  sliderColor: .gray,thumbColor: .red.opacity(0.6))

                        ScrollViewReader { proxy in
                            ScrollView(.horizontal) {
                                HStack {
                                    ColorPickerFromImage(overlay: overlay)
                                    
                                    ForEach(TextView.solidColors, id: \.self) { color in
                                        Circle()
                                            .foregroundColor(Color(color))
                                            .frame(width: 40, height: 40)
                                            .id(color)
                                            .onTapGesture {
                                                overlay.bgColor.wrappedValue = color
                                            }
                                            .overlay(
                                                Circle()
                                                    .strokeBorder(overlay.bgColor.wrappedValue == color ? Color.red : Color.clear, lineWidth: 3)
                                            )
                                    }
                                }
                                .padding(.horizontal)
                            }
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now()+0.05) {
                                    proxy.scrollTo(overlay.bgColor.wrappedValue, anchor: .center)
                                }
                            }
                            .onChange(of: overlay.bgColor.wrappedValue) { newColor in
                                withAnimation(.easeInOut(duration: 0.25)) {
                                    proxy.scrollTo(newColor, anchor: .center)
                                }
                            }
                            
                        }
                    }
                    .padding(.leading, 8)
                    
                case .shadow:
                    VStack{
                        CustomSliderRow(title: "X", value: overlay.offSetXSD, minValue: -5, maxValue: 5, sliderColor: .gray, thumbColor: .red.opacity(0.6))
                        CustomSliderRow(title: "Y", value: overlay.offSetYSD, minValue: -5, maxValue: 5, sliderColor: .gray, thumbColor: .red.opacity(0.6))
                        CustomSliderRow(title: language.localized("Blur", "Làm mờ"), value: overlay.blurSD, minValue: 2.0, maxValue: 10.0, sliderColor: .gray, thumbColor: .red.opacity(0.6))
                        CustomSliderOpacity(title: language.localized("Opacity", "Độ mờ"), valueOpacity:overlay.opacitySD, sliderColor: .gray,thumbColor: .red.opacity(0.6))
                        
                        ScrollViewReader { proxy in
                            ScrollView(.horizontal) {
                                HStack {
                                    ColorPickerFromImage(overlay: overlay)
                                    
                                    ForEach(TextView.solidColors, id: \.self) { color in
                                        Circle()
                                            .foregroundColor(Color(color))
                                            .frame(width: 40, height: 40)
                                            .id(color)
                                            .onTapGesture {
                                                overlay.shawDowColor.wrappedValue = color
                                            }
                                            .overlay(
                                                Circle()
                                                    .strokeBorder(overlay.shawDowColor.wrappedValue == color ? Color.red : Color.clear, lineWidth: 3)
                                            )
                                    }
                                }
                                .padding(.horizontal)
                            }
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now()+0.05) {
                                    proxy.scrollTo(overlay.shawDowColor.wrappedValue, anchor: .center)
                                }
                            }
                            .onChange(of: overlay.shawDowColor.wrappedValue) { newColor in
                                withAnimation(.easeInOut(duration: 0.25)) {
                                    proxy.scrollTo(newColor, anchor: .center)
                                }
                            }
                        }
                    }
                    .padding(.leading, 8)
                    
                case nil:
                    ProgressView()
                case .none:
                    Text("8 Family Picker")
                }
            }
        }
        .background(.white)
        .padding(.top,5)
    }
}

//customSlider

struct CustomSliderRow: View {
    let title: String
    @Binding var value: Double
    var minValue: Double = 15
    var maxValue: Double = 80
    var sliderColor: Color = .red
    var thumbColor: Color = .red
    var trackHeight: CGFloat = 3
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title)
                .font(.system(size: 12))
                .frame(width: 200, alignment: .leading)
            
            HStack {
                CustomSlider(value: $value,
                             minValue: minValue,
                             maxValue: maxValue,
                             trackColor: .gray,
                             thumbColor: .red)
                .frame(height: 25)
                
                Text("\(Int(value))")
            }
        }
        .padding(.horizontal)

    }
}
//customsilder color solid


struct CustomSliderOpacity: View {
    let title: String
    @Binding var valueOpacity: Double
    var minValue: Double = 0.1
    var maxValue: Double = 1.0
    var sliderColor: Color = .red
    var thumbColor: Color = .red
    var trackHeight: CGFloat = 3
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title)
                .font(.system(size: 12))
            HStack {
                CustomUISlider(valueOpacity: $valueOpacity,minValue: 0.3,maxValue: 1.0,trackColor: .gray,thumbColor: .red)
                .frame(height: 25)
                
                Text(String(format: "%.0f", valueOpacity * 10))
            }
        }
        .padding(.horizontal)
    }
}

//customAlign

struct CustomAlign: View {
    var title: String
    @Binding var selectedAlign: AlignEnum
    
    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 12))
            Spacer()
            HStack(spacing: 8) {
                
                Button(action: {
                    selectedAlign = .left
                }) {
                    Image("align_left")
                        .background(selectedAlign == .left ? Color.black.opacity(0.65) : Color.clear)
                        .frame(width: 30, height: 30)
                }
                
                Button(action: {
                    selectedAlign = .center
                }) {
                    Image("align_left")
                        .background(selectedAlign == .center ? Color.black.opacity(0.65) : Color.clear)
                        .frame(width: 30, height: 30)
                }
                
                Button(action: {
                    selectedAlign = .right
                }) {
                    Image("align_right")
                        .background(selectedAlign == .right ? Color.black.opacity(0.65) : Color.clear)
                        .frame(width: 30, height: 30)
                }
            }
        }
        .padding(.horizontal)
    }
}

struct CustomAlignCase: View {
    var title: String
    @Binding var selectedAlignCase : AlignCaseEnum
    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 12))
            Spacer()
            
            HStack{
                Button(action: {
                    selectedAlignCase = .up
                }) {
                    Text("UP")
                        .font(.system(size: 14))
                        .foregroundColor(selectedAlignCase == .up ? .white : .black)
                        .padding(5)
                        .background(selectedAlignCase == .up ? Color.black : Color.clear)
                }
                
                Button(action: {
                    selectedAlignCase = .cap
                }) {
                    Text("Cap")
                        .font(.system(size: 14))
                        .foregroundColor(selectedAlignCase == .cap ? .white : .black)
                        .padding(5)
                        .background(selectedAlignCase == .cap ? Color.black : Color.clear)
                }
                
                Button(action: {
                    selectedAlignCase = .low
                }) {
                    Text("low")
                        .font(.system(size: 14))
                        .foregroundColor(selectedAlignCase == .low ? .white : .black)
                        .padding(5)
                        .background(selectedAlignCase == .low ? Color.black : Color.clear)
                }
            }
        }
        .padding(.horizontal)
        
    }
}

