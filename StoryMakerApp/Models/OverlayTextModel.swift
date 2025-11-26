//
//  OverlayTextModel.swift
//  StoryMakerApp
//
//  Created by to hoang nam on 21/8/25.
//

import Foundation

import SwiftUI

enum OverlayGestureType : Codable {
    case none
    case move
    case rotate
    case zoom
}

struct OverlayTextModel: Identifiable , Codable {
    var id = UUID()
    var text: String
    var offset: CGSize = .zero
    var endset: CGSize = .zero
    //rotate
    //  Biến trạng thái để lưu góc xoay
    var currentRotation: Double = 0
    // Biến tạm để lưu góc ban đầu khi bắt đầu kéo
    var startAngle: Double = 0
    // Biến tạm để lưu vị trí ban đầu của ngón tay
    var startLocation: CGPoint?
    
    //Biến trạng thái để lưu zoom
    var currentScale: CGFloat = 1.0
    // Biến tạm để lưu scale ban đầu
    var startScale: CGFloat = 1.0
    // Biến tạm để lưu khoảng cách ban đầu từ tâm khi zoom
    var startDistance: CGFloat = 0.0
    var startAngleToCenter: Double?
    var currentZoom: CGFloat = 1
    var displayZoom: CGFloat = 1
    var startCenter: CGPoint = .zero
    var isEditingText: Bool = false
    var activeGesture: OverlayGestureType = .none
    //font size
    var value : Double
    
    // Font
    var fontSize: Double = 30
    var lineHeight: Double = 5
    var letterSpacing: Double = 0
    
    // Font family
    var selectedFontFamily: FontFmailyEnum = .ff7
    
    // Align
    var selectedAlign: AlignEnum = .none
    var selectedAlignCase: AlignCaseEnum = .none
    var cuver : Double = 0
    
    // Color solid
    var colorSolid: String = "#FFFFFF"
    var valueOpacity : Double = 1
    //color gradient
    var colorGradient: [String] = ["#FFFFFF", "#FF0000"]
    var gradient: LinearGradient {
        let colors = colorGradient.toColorArray()
        let safeColors = colors.isEmpty ? [.white, .black] : colors
        return LinearGradient(
            gradient: Gradient(colors: safeColors),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    var userGradient: Bool = false
    
    // Stroke
    var strokeWidth: Double = 15
    var hasStroke: Bool = false
    
    // Background
    var paddingBG: Double = 10
    var cornerRadiusBG: Double = 10
    var opacityBG: Double = 0
    var bgColor:  String = "#FFFFFF"
    
    // Shadow
    var offSetXSD: Double = 0
    var offSetYSD: Double = 0
    var blurSD: Double = 1
    var opacitySD: Double = 1
    var shawDowColor: String = "#FFFFFF"
}

enum OverlayTextEditEnum : Equatable , CaseIterable {
    case fontSize
    case fontFamily
    case colorSolid
    case gradient
    case stroke
    case align
    case background
    case shadow
    case none
    
    var title: String {
        switch self {
        case .fontSize:
            return "Font Size"
        case .fontFamily:
            return "Font Family"
        case .colorSolid:
            return "Color Solid"
        case .gradient:
            return "Color Gradient"
        case .stroke:
            return "Stroke"
        case .align:
            return "Align"
        case .background:
            return "Background"
        case .shadow:
            return "ShaDow"
        case .none:
            return "ShaDow"
        }
    }
    var titleVN: String {
        switch self {
        case .fontSize:
            return "Cỡ chữ"
        case .fontFamily:
            return "Kiểu chữ"
        case .colorSolid:
            return "Màu chữ"
        case .gradient:
            return "Hiệu ứng chuyển màu"
        case .stroke:
            return "Viền chữ"
        case .align:
            return "Căn chỉnh"
        case .background:
            return "Nền chữ"
        case .shadow:
            return "Đổ bóng"
        case .none:
            return "Đổ bóng"
        }
    }

    
    var img: String {
        switch self {
        case .fontSize:
            return "img_edit1_text"
        case .fontFamily:
            return "img_edit1_size"
        case .colorSolid:
            return "img_edit1_color"
        case .gradient:
            return "img_edit1_gradient"
        case .stroke:
            return "img_edit1_stroke"
        case .align:
            return "img_edit1_align"
        case .background:
            return "img_edit1_bg"
        case .shadow:
            return "img_edit1_shadow"
        case .none:
            return "img_edit1_shadow"
        }
    }
}

enum FontFmailyEnum : String , CaseIterable , Codable {
    case ff1
    case ff2
    case ff3
    case ff4
    case ff5
    case ff6
    case ff7
    case ff8
    case ff9
    case ff10
    case ff11
    case ff12
    
    var img: String {
        switch self {
        case .ff1:
            return "ff1"
        case .ff2:
            return "ff2"
        case .ff3:
            return "ff3"
        case .ff4:
            return "ff4"
        case .ff5:
            return "ff5"
        case .ff6:
            return "ff6"
        case .ff7:
            return "ff7"
        case .ff8:
            return "ff8"
        case .ff9:
            return "ff9"
        case .ff10:
            return "ff10"
        case .ff11:
            return "ff11"
        case .ff12:
            return "ff12"
        }
    }
    
    var titleFF: String {
        switch self {
        case .ff1: return "Fancy"
        case .ff2: return "Playful"
        case .ff3: return "Cute"
        case .ff4: return "MV Boli"
        case .ff5: return "Vintage"
        case .ff6: return "Pixel"
        case .ff7: return "Loud"
        case .ff8: return "Happy"
        case .ff9: return "Childlike"
        case .ff10: return "Stencil"
        case .ff11: return "Shaded"
        case .ff12: return "Marker"
        }
    }
    
    var fontFamily: String {
        switch self {
        case .ff1: return "MonsieurLaDoulaise-Regular"
        case .ff2: return "Barriecito-Regular"
        case .ff3: return "Pacifico-Regular"
        case .ff4: return "Kapakana-VariableFont_wght"
        case .ff5: return "PPNeueMachina-Regular"
        case .ff6: return "AllertaStencil-Regular"
        case .ff7: return "Arbutus-Regular"
        case .ff8: return "Kablammo-Regular-VariableFont_MORF"
        case .ff9: return "Eater-Regular"
        case .ff10: return "Inspiration-Regular"
        case .ff11: return "FontdinerSwanky-Regular"
        case .ff12: return "RubikIso-Regular"
        }
    }
}

enum AlignEnum : String , CaseIterable , Codable {
    case left
    case center
    case right
    case none
}

enum AlignCaseEnum : String , CaseIterable , Codable {
    case up
    case cap
    case low
    case none
}






