//
//  OverlayTextModel.swift
//  StoryMakerApp
//
//  Created by to hoang nam on 21/8/25.
//

import Foundation

import SwiftUI

enum OverlayGestureType {
    case none
    case move
    case rotate
    case zoom
}

struct OverlayTextModel: Identifiable {
    var id = UUID()
    var text: String
    var offset: CGSize = .zero
    var endset: CGSize = .zero
    
    //rotate
    
    // 1. Biến trạng thái để lưu góc xoay
    var currentRotation: Angle = .degrees(0)
    
    // Biến tạm để lưu góc ban đầu khi bắt đầu kéo
    var startAngle: Angle = .degrees(0)
    
    // Biến tạm để lưu vị trí ban đầu của ngón tay
    var startLocation: CGPoint?
    
    // 2. Biến trạng thái để lưu zoom
    var currentScale: CGFloat = 1.0
    
    // Biến tạm để lưu scale ban đầu
    var startScale: CGFloat = 1.0
    
    // Biến tạm để lưu khoảng cách ban đầu từ tâm khi zoom
    var startDistance: CGFloat = 0.0
       
    var topLeft: CGPoint = .zero
    var topRight: CGPoint = .zero
    var bottomLeft: CGPoint = .zero
    var bottomRight: CGPoint = .zero
    var textSize: CGSize = .zero
    var isZoom: Bool = false
    var isSelected: Bool = false
    var isEditingText: Bool = false
    var isShowBGText : Bool = false
    
    var startDragAngle: CGFloat? = nil
    var startZoomDistance: CGFloat? = nil
    var activeGesture: OverlayGestureType = .none

    var startAngleToCenter: CGFloat? = nil
    var startRadius: CGFloat? = nil
    //zoom
    
    var initialZoom: CGFloat = 1
    var currentZoom: CGFloat = 1
    var displayZoom: CGFloat = 1
    
    // MARK: Edit Text
    //font size
    var value : Double
    
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
enum FontFmailyEnum : String , CaseIterable {
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
}

enum AlignEnum : String , CaseIterable {
    case left
    case center
    case right
    case none
}

enum AlignCaseEnum : String , CaseIterable {
    case up
    case cap
    case low
    case none
}






