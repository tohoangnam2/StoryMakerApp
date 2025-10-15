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
                            CustomSliderRow(title: "Font size", value: overlay.fontSize, sliderColor: .gray,thumbColor: .red.opacity(0.6))
                            CustomSliderRowLineHeight(title: "Line height", value: overlay.lineHeight, sliderColor: .gray,thumbColor: .red.opacity(0.6))
                            CustomSliderRowLetter(title: "Letter Spacing", value: overlay.letterSpacing, sliderColor: .gray,thumbColor: .red.opacity(0.6))
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
                        CustomSliderRowColor(title: "Opacity", valueOpacity:overlay.valueOpacity, sliderColor: .gray,thumbColor: .red.opacity(0.6))
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
                                                withAnimation{
                                                    proxy.scrollTo(color, anchor: .leading)
                                                    overlay.colorSolid.wrappedValue = color
                                                    overlay.userGradient.wrappedValue = false
                                                }
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
                                DispatchQueue.main.async {
                                    withAnimation {
                                        proxy.scrollTo(overlay.colorSolid.wrappedValue, anchor: .leading)
                                    }
                                }
                                
                            }
                            
                        }
                       
                    }
                    .padding(.leading, 8)
                    
                case .gradient:
                    VStack {
                        CustomSliderRowColor(title: "Opacity", valueOpacity: overlay.valueOpacity, sliderColor: .gray, thumbColor: .red.opacity(0.6))
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
                                                withAnimation {
                                                    proxy.scrollTo(gradientIndex, anchor: .leading)
                                                    overlay.colorGradient.wrappedValue = [
                                                        first.toHex() ?? "#FFFFFF",
                                                        second.toHex() ?? "#FFFFFF"
                                                    ]
                                                    overlay.userGradient.wrappedValue = true
                                                }
                                            }
                                            .overlay(
                                                Circle()
                                                    .stroke( overlay.colorGradient.wrappedValue == [
                                                        first.toHex() ?? "#FFFFFF",
                                                        second.toHex() ?? "#FFFFFF"
                                                    ] ? Color.red: Color.clear,lineWidth: 3)
                                            )
                                            
                                    }
                                }
                                .padding(.horizontal)
                            }
                            .onAppear {
                                DispatchQueue.main.async {
                                    withAnimation {
                                        proxy.scrollTo(overlay.colorGradient.wrappedValue, anchor: .leading)
                                    }
                                }
                                
                            }


                        }
                        .padding(.leading,12)
                        

                    }
                    .padding(.top, 12)
                case .stroke:
                    VStack {
                        CustomSliderRowStroke(title: "Stroke Width", value: overlay.strokeWidth, sliderColor: .gray, thumbColor: .red.opacity(0.6))
                        CustomSliderRowColor(title: "Opacity", valueOpacity: overlay.valueOpacity, sliderColor: .gray, thumbColor: .red.opacity(0.6))
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
                                                withAnimation {
                                                    proxy.scrollTo(color, anchor: .leading)
                                                    overlay.colorSolid.wrappedValue = color
                                                }
                                            }
                                            .overlay(
                                                Circle()
                                                    .stroke( overlay.colorSolid.wrappedValue == color ? Color.red: Color.clear,lineWidth: 3)
                                            )
                                    }
                                }
                                .padding(.horizontal)
                            }
                            .onAppear {
                                DispatchQueue.main.async {
                                    withAnimation {
                                        proxy.scrollTo(overlay.colorGradient.wrappedValue, anchor: .leading)
                                    }
                                }
                                
                            }

                        }
                    }
                    .padding(.top, 12)
                case .align:
                    VStack{
                        CustomAlign(title: "Align", selectedAlign: overlay.selectedAlign)
                        CustomAlignCase(title: "Case", selectedAlignCase: overlay.selectedAlignCase)
                        CustomSliderBackGround(title: "Cuver", valueBG: overlay.cuver, sliderColor: .gray, thumbColor: .red.opacity(0.6))
                    }
                    .padding(.top, 12)
                case .background:
                    VStack{
                        CustomSliderBackGround(title: "Padding", valueBG: overlay.paddingBG, sliderColor: .gray,thumbColor: .red.opacity(0.6))
                        CustomSliderBackGround(title: "Corner", valueBG: overlay.cornerRadiusBG, sliderColor: .gray,thumbColor: .red.opacity(0.6))
                        CustomSliderRowBgOpacity(title: "Opacity", valueOpacity:overlay.opacityBG, sliderColor: .gray,thumbColor: .red.opacity(0.6))
                        
                        ScrollView(.horizontal) {
                            HStack {
                                Image("cs1")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                ForEach(TextView.solidColors, id: \.self) { color in
                                    Circle()
                                        .foregroundColor(Color(color))
                                        .frame(width: 40, height: 40)
                                        .onTapGesture {
                                            overlay.bgColor.wrappedValue = color
                                        }
                                }
                            }
                            .padding(.horizontal)
                        }
                        
                    }
                    .padding(.top, 12)
                case .shadow:
                    VStack{
                        CustomSliderShadow(title: "X", valueBG: overlay.offSetXSD, sliderColor: .gray,thumbColor: .red.opacity(0.6))
                        CustomSliderShadow(title: "Y", valueBG: overlay.offSetYSD, sliderColor: .gray,thumbColor: .red.opacity(0.6))
                        CustomSliderShaDowBlur(title: "Blur", valueBG:overlay.blurSD, sliderColor: .gray,thumbColor: .red.opacity(0.6))
                        CustomSliderRowColor(title: "Opacity", valueOpacity:overlay.opacitySD, sliderColor: .gray,thumbColor: .red.opacity(0.6))
                        
                        
                        ScrollView(.horizontal) {
                            HStack {
                                Image("cs1")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                ForEach(TextView.solidColors, id: \.self) { color in
                                    Circle()
                                        .foregroundColor(Color(color))
                                        .frame(width: 40, height: 40)
                                        .onTapGesture {
                                            overlay.shawDowColor.wrappedValue = color

                                        }
                                }
                            }
                            .padding(.horizontal)
                        }
                        
                    }
                    .padding(.top, 12)
                case nil:
                    ProgressView()
                case .none:
                    Text("8 Family Picker")
                }
            }
//            else{
//                Text("Không có overlay nào được chọn")
//            }
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
    }
}
struct CustomSliderRowLineHeight: View {
    let title: String
    @Binding var value: Double
    var minValue: Double = 5
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
    }
}
struct CustomSliderRowLetter: View {
    let title: String
    @Binding var value: Double
    var minValue: Double = 0
    var maxValue: Double = 20
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
    }
}

//customsilder color solid

struct CustomSliderRowColor: View {
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
                CustomUISlider(
                                valueOpacity: $valueOpacity,
                                minValue: 0.3,
                                maxValue: 1.0,
                                trackColor: .gray,
                                thumbColor: .red // màu thumb
                 )
                .frame(height: 25)
                
                Text(String(format: "%.0f", valueOpacity * 10)) // Hiển thị 1-10
            }
        }
        .padding(.horizontal)
    }
}


struct CustomSliderRowBgOpacity: View {
    let title: String
    @Binding var valueOpacity: Double
    var minValue: Double = 0.1
    var maxValue: Double = 1
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
                                minValue: 0,
                                maxValue: 1,
                                trackColor: .gray,
                                thumbColor: .red // màu thumb
                            )
                            .frame(height: 25)
                
                Text(String(format: "%.0f", valueOpacity * 10)) // Hiển thị 1-10
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

//background

struct CustomSliderShadow: View {
    let title: String
    @Binding var valueBG: Double
    var minValue: Double = -200
    var maxValue: Double = 200
    var sliderColor: Color = .red
    var thumbColor: Color = .red
    var trackHeight: CGFloat = 3

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title)
                .font(.system(size: 12))
                .frame(width: 200, alignment: .leading)
            
            HStack {
                CustomSlider(value: $valueBG,
                             minValue: minValue,
                             maxValue: maxValue,
                             trackColor: .gray,
                             thumbColor: .red)
                .frame(height: 25)

                Text("\(Int(valueBG))")
            }
        }
        .padding(.horizontal)
    }
}

struct CustomSliderBackGround: View {
    let title: String
    @Binding var valueBG: Double
    var minValue: Double = 0
    var maxValue: Double = 100
    var sliderColor: Color = .red
    var thumbColor: Color = .red
    var trackHeight: CGFloat = 3

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title)
                .font(.system(size: 12))
                .frame(width: 200, alignment: .leading)
            
            HStack {
                CustomSlider(value: $valueBG,
                             minValue: minValue,
                             maxValue: maxValue,
                             trackColor: .gray,
                             thumbColor: .red)
                .frame(height: 25)

                Text("\(Int(valueBG))")
            }
        }
        .padding(.horizontal)
    }
}



struct CustomSliderShaDowBlur: View {
    let title: String
    @Binding var valueBG: Double
    var minValue: Double = 0
    var maxValue: Double = 10
    var sliderColor: Color = .red
    var thumbColor: Color = .red
    var trackHeight: CGFloat = 3

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title)
                .font(.system(size: 12))
                .frame(width: 200, alignment: .leading)
            
            HStack {
                CustomSlider(value: $valueBG,
                             minValue: minValue,
                             maxValue: maxValue,
                             trackColor: .gray,
                             thumbColor: .red)
                    .frame(height: 25)
                Text("\(Int(valueBG))")
            }
        }
        .padding(.horizontal)
    }
}

//MARK: CUSTOMSLIDER
struct CustomSlider: UIViewRepresentable {
    @Binding var value: Double
    var minValue: Double
    var maxValue: Double
    var trackColor: UIColor
    var thumbColor: UIColor
    
    func makeUIView(context: Context) -> UISlider {
        let slider = UISlider(frame: .zero)
        slider.minimumValue = Float(minValue)
        slider.maximumValue = Float(maxValue)
        slider.minimumTrackTintColor = trackColor
        slider.maximumTrackTintColor = .lightGray
        slider.thumbTintColor = thumbColor
        slider.addTarget(context.coordinator, action: #selector(Coordinator.valueChanged(_:)), for: .valueChanged)
        return slider
    }
    
    func updateUIView(_ uiView: UISlider, context: Context) {
        uiView.value = Float(value)
        uiView.thumbTintColor = thumbColor // cập nhật màu thumb khi đổi
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject {
        var parent: CustomSlider
        init(_ parent: CustomSlider) { self.parent = parent }
        
        @objc func valueChanged(_ sender: UISlider) {
            parent.value = Double(sender.value)
        }
    }
}

//slider X10

struct CustomUISlider: UIViewRepresentable {
    @Binding var valueOpacity: Double  // 0.1 → 1.0
    var minValue: Double = 0.1
    var maxValue: Double = 1.0
    var trackColor: UIColor = .red
    var thumbColor: UIColor = .blue
    
    func makeUIView(context: Context) -> UISlider {
        let slider = UISlider()
        slider.minimumValue = Float(minValue * 10)  // 1 → 10
        slider.maximumValue = Float(maxValue * 10)
        slider.minimumTrackTintColor = trackColor
        slider.maximumTrackTintColor = .lightGray
        slider.thumbTintColor = thumbColor
        slider.addTarget(context.coordinator, action: #selector(Coordinator.valueChanged(_:)), for: .valueChanged)
        return slider
    }
    
    func updateUIView(_ uiView: UISlider, context: Context) {
        uiView.value = Float(valueOpacity * 10) // binding ngược lại
        uiView.thumbTintColor = thumbColor
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    //khi kéo nhận giá trị ở đay và gửi sang vm.lightness
    class Coordinator: NSObject {
        var parent: CustomUISlider
        init(_ parent: CustomUISlider) {
            self.parent = parent
        }
        
        @objc func valueChanged(_ sender: UISlider) {
            parent.valueOpacity = Double(sender.value) / 10  // scale ngược lại
        }
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
