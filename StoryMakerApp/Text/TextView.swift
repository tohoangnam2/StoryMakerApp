//
//  TextView.swift
//  StoryMakerApp
//
//  Created by to hoang nam on 19/8/25.
//

import SwiftUI

struct TextView: View {
    
    @State var selectedEditText: OverlayTextEditEnum
//    @Binding var selectedFontFamily : FontFmailyEnum
    @State var selectedFontFamily : FontFmailyEnum? = nil
    
    @State var selectedAlign : AlignEnum = .none
    
    @State var selectedAlignCase : AlignCaseEnum = .none
    
    static let solidColors: [String] = [
            "#FFFFFF", "#000000",
            "#742A2A", "#9B2C2C", "#C53030", "#E53E3E", "#F56565", "#FC8181", "#FEB2B2", "#FED7D7", "#FFF5F5",
            "#7B341E", "#9C4221", "#C05621", "#DD6B20", "#ED8936", "#F6AD55", "#FBD38D", "#FEEBC8", "#FFFAF0",
            "#744210", "#975A16", "#B7791F", "#D69E2E", "#ECC94B", "#F6E05E", "#FAF089", "#FEFCBF", "#FFFFF0",
            "#22543D", "#276749", "#2F855A", "#38A169", "#48BB78", "#68D391", "#9AE6B4", "#C6F6D5", "#F0FFF4",
            "#234E52", "#285E61", "#2C7A7B", "#319795", "#38B2AC", "#4FD1C5", "#81E6D9", "#B2F5EA", "#E6FFFA",
            "#2A4365", "#2C5282", "#2B6CB0", "#3182CE", "#4299E1", "#63B3ED", "#90CDF4", "#BEE3F8", "#EBF8FF",
            "#3C366B", "#434190", "#4C51BF", "#5A67D8", "#667EEA", "#7F9CF5", "#A3BFFA", "#C3DAFE", "#EBF4FF",
            "#44337A", "#553C9A", "#6B46C1", "#805AD5", "#9F7AEA", "#B794F4", "#D6BCFA", "#E9D8FD", "#FAF5FF",
            "#702459", "#97266D", "#B83280", "#D53F8C", "#ED64A6", "#F687B3", "#FBB6CE", "#FED7E2"]
    
    static let gradientColors: [String] = [
          
            "#234E52", "#285E61", "#2C7A7B", "#319795", "#38B2AC", "#4FD1C5", "#81E6D9", "#B2F5EA", "#E6FFFA",
            "#2A4365", "#2C5282", "#2B6CB0", "#3182CE", "#4299E1", "#63B3ED", "#90CDF4", "#BEE3F8", "#EBF8FF",
            "#3C366B", "#434190", "#4C51BF", "#5A67D8", "#667EEA", "#7F9CF5", "#A3BFFA", "#C3DAFE", "#EBF4FF",
            "#44337A", "#553C9A", "#6B46C1", "#805AD5", "#9F7AEA", "#B794F4", "#D6BCFA", "#E9D8FD", "#FAF5FF",
            "#702459", "#97266D", "#B83280", "#D53F8C", "#ED64A6", "#F687B3", "#FBB6CE", "#FED7E2"]


    
    
    //fontsize
    @State var fontSize: Double = 32
    @State var lineHeight: Double = 32
    @State var letterSpacing: Double = 32
    
    //color solid
    @State var colorSolid: Double = 0.5
    
    //stroke
    @State var strokeWidth: Double = 15
    
    var body: some View {
        VStack{
            switch selectedEditText {
            case .fontSize:
                VStack{
                    VStack(spacing: 2) {
                        CustomSliderRow(title: "Font size", value: $fontSize, sliderColor: .gray,thumbColor: .red)
                        CustomSliderRow(title: "Line height", value: $lineHeight, sliderColor: .gray,thumbColor: .red)
                        CustomSliderRow(title: "Letter Spacing", value: $letterSpacing, sliderColor: .gray,thumbColor: .red)
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
                                Image(font.img) 
//                                    .frame(
//                                        width: UIScreen.main.bounds.width / 3 - 16,
//                                        height: (UIScreen.main.bounds.width / 3 - 16) * 0.5
//                                    )
                                    .frame(maxWidth: .infinity)
                                     .aspectRatio(4/3, contentMode: .fit)
                                    .clipped()
                                    .cornerRadius(8)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(
                                                font == selectedFontFamily ? Color.red : Color.clear,
                                                lineWidth: 3
                                            )
                                    )
                                    .onTapGesture {
                                        selectedFontFamily = font
                                    }
                            }
                        }
                        .frame(height: 200)
                }
                

            case .colorSolid:
                VStack{
                    CustomSliderRowColor(title: "Opacity", valueOpacity:$colorSolid, sliderColor: .gray,thumbColor: .red)
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(TextView.solidColors, id: \.self) { color in
                                Circle()
                                    .frame(width: 40, height: 40)
                                    .foregroundColor(Color(color))
                                    .onTapGesture {
                                    }
                            }
                        }
                    }
                }
                .padding(.top, 12)
            
            case .gradient:
                VStack {
                    CustomSliderRowColor(title: "Opacity", valueOpacity: $colorSolid, sliderColor: .gray, thumbColor: .red)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(0..<TextView.gradientColors.count, id: \.self) { _ in
                                let first = TextView.gradientColors.randomElement() ?? "#FFFFFF"
                                let second = TextView.gradientColors.randomElement() ?? "#000000"
                                
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            gradient: Gradient(colors: [Color(first), Color(second)]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 40, height: 40)
                                    .onTapGesture {
                                    }
                            }
                        }
                    }
                }

                .padding(.top, 12)
            case .stroke:
                VStack {
                    CustomSliderRowStroke(title: "Stroke Width", value: $strokeWidth, sliderColor: .gray, thumbColor: .red)
                    CustomSliderRowColor(title: "Opacity", valueOpacity: $colorSolid, sliderColor: .gray, thumbColor: .red)
                    
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(TextView.solidColors, id: \.self) { color in
                                Circle()
                                    .foregroundColor(Color(color))
                                    .frame(width: 40, height: 40)
                                    .onTapGesture {
                                    }
                            }
                        }
                    }
                }

                .padding(.top, 12)
            case .align:
                VStack{
                    CustomAlign(title: "Align", selectedAlign: $selectedAlign)
                    CustomAlignCase(title: "Case", selectedAlignCase: $selectedAlignCase)
                    CustomSliderRowColor(title: "Opacity", valueOpacity: $colorSolid, sliderColor: .gray, thumbColor: .red)
                }
                    .padding(.top, 12)

                
            case .background:
                Text("7 Family Picker")
            case .shadow:
                Text("8 Family Picker")
            case nil:
                ProgressView()
            case .none:
                Text("8 Family Picker")

            }

        }
    }
}

//customSlider


struct CustomSliderRow: View {
    let title: String
    @Binding var value: Double
    var minValue: Double = 0
    var maxValue: Double = 60
    var sliderColor: Color = .red
    var thumbColor: Color = .red
    var trackHeight: CGFloat = 3

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title)
                .font(.system(size: 12))
                .frame(width: 200, alignment: .leading)
            
            HStack {
                Slider(value: $value, in: minValue...maxValue)
                    .tint(sliderColor) // track fill
                    .frame(height: 20)
                    .overlay(
                        GeometryReader { geo in
                            let percent = (value - minValue) / (maxValue - minValue)
                            Circle()
                                .fill(thumbColor)
                                .frame(width: 20, height: 20)
                                .offset(x: CGFloat(percent) * (geo.size.width - 20))
                        }
                    )
                
                Text("\(Int(value))")
            }
        }
    }
}

//customsilder color solid

struct CustomSliderRowColor: View {
    let title: String
    @Binding var valueOpacity: Double
    var minValue: Double = 0
    var maxValue: Double = 1.0
    var sliderColor: Color = .red
    var thumbColor: Color = .red
    var trackHeight: CGFloat = 3

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title)
                .font(.system(size: 12))
            HStack {
                Slider(value: $valueOpacity, in: minValue...maxValue)
                    .tint(sliderColor)
                    .frame(height: 20)
                    .overlay(
                        GeometryReader { geo in
                            let percent = (valueOpacity - minValue) / (maxValue - minValue)
                            Circle()
                                .fill(thumbColor)
                                .frame(width: 20, height: 20)
                                .offset(x: CGFloat(percent) * (geo.size.width - 20))
                        }
                    )
                
                Text(String(format: "%.1f", valueOpacity))
            }
        }
        .padding(.horizontal)
    }
}

//customslider stroke

struct CustomSliderRowStroke: View {
    let title: String
    @Binding var value: Double

    var minValue: Double = 0
    var maxValue: Double = 30
    var sliderColor: Color = .red
    var thumbColor: Color = .red
    var trackHeight: CGFloat = 3

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title)
                .font(.system(size: 12))
            HStack {
                Slider(value: $value, in: minValue...maxValue)
                    .tint(sliderColor)
                    .frame(height: 20)
                    .overlay(
                        GeometryReader { geo in
                            let percent = (value - minValue) / (maxValue - minValue)
                            Circle()
                                .fill(thumbColor)
                                .frame(width: 20, height: 20)
                                .offset(x: CGFloat(percent) * (geo.size.width - 20))
                        }
                    )
                
                Text("\(Int(value))")
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
                            .background(selectedAlign == .left ? Color.black : Color.clear)
                            .frame(width: 30, height: 30)
                    }
                    Button(action: {
                        selectedAlign = .center
                    }) {
                        Image("align_left")
                            .background(selectedAlign == .center ? Color.black : Color.clear)
                            .frame(width: 30, height: 30)
                    }
                    Button(action: {
                        selectedAlign = .right
                    }) {
                        Image("align_right")
                            .background(selectedAlign == .right ? Color.black : Color.clear)
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
                HStack() {
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



















//MARK: EXTENSION

extension Color {
    init(_ hex: String) {
        var hex = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hex = hex.replacingOccurrences(of: "#", with: "")
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)

        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB, e.g. "f00"
            (a, r, g, b) = (255,
                            (int >> 8) * 17,
                            (int >> 4 & 0xF) * 17,
                            (int & 0xF) * 17)
        case 6: // RRGGBB
            (a, r, g, b) = (255,
                            (int >> 16) & 0xFF,
                            (int >> 8) & 0xFF,
                            int & 0xFF)
        case 8: // AARRGGBB
            (a, r, g, b) = ((int >> 24) & 0xFF,
                            (int >> 16) & 0xFF,
                            (int >> 8) & 0xFF,
                            int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }

        self.init(.sRGB,
                  red: Double(r) / 255,
                  green: Double(g) / 255,
                  blue: Double(b) / 255,
                  opacity: Double(a) / 255)
    }
}
