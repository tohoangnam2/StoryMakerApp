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
    
    var angle: CGFloat = 0           // Góc xoay của Text
    var topLeft: CGPoint = .zero
    var topRight: CGPoint = .zero
    var bottomLeft: CGPoint = .zero
    var bottomRight: CGPoint = .zero
    var textSize: CGSize = .zero     // Kích thước Text + padding
    
 
    
    
    var isZoom: Bool = false
    
    var isSelected: Bool = false
    var isEditingText: Bool = false
    var isShowBGText : Bool = false
    
    var startDragAngle: CGFloat? = nil
    var startZoomDistance: CGFloat? = nil
    var activeGesture: OverlayGestureType = .none
    
   
    var startLocation: CGPoint = .zero
    
    
    
    

    var startAngleToCenter: CGFloat? = nil
    var startRadius: CGFloat? = nil
    
    //lastdance










    //zoom
    
    var startDistance: CGFloat = 0
    var initialZoom: CGFloat = 1
    var currentZoom: CGFloat = 1
    var displayZoom: CGFloat = 1
    
    

}

enum OverlayTextEditEnum {
    case fontSize
    case fontFamily
    case colorSolid
    case gradient
    case stroke
    case align
    case background
    case shadow
    
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
        }
    }
    
    
    
}




