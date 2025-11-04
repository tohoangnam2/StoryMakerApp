//
//  ExtensionTextView.swift
//  StoryMakerApp
//
//  Created by Nam To on 4/11/25.
//

import SwiftUI

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


