import SwiftUI

struct a: View {
    let title: String
    @Binding var value: Double
    var minValue: Double = 0
    var maxValue: Double = 100
    var sliderColor: Color = .red
    var thumbColor: Color = .red
    var trackHeight: CGFloat = 3
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .frame(width: 200, alignment: .leading)
            
            HStack{
                Slider(value: $value, in: minValue...maxValue)
                    .tint(sliderColor)
                    .frame(height: 20)
                    
                Text("\(Int(value))")
            }
        }
    }
}

struct SliderDemo: View {
    @State private var fontSize: Double = 32
    @State private var lineHeight: Double = 32
    @State private var letterSpacing: Double = 32
    
    var body: some View {
        VStack(spacing: 20) {
            CustomSliderRow(title: "Font size", value: $fontSize, sliderColor: .gray)
            CustomSliderRow(title: "Line height", value: $lineHeight, sliderColor: .gray)
            CustomSliderRow(title: "Letter Spacing", value: $letterSpacing, sliderColor: .gray)
        }
        .padding()
    }
}
#Preview {
    SliderDemo()
}
