//
//  OverlayTextModel.swift
//  StoryMakerApp
//
//  Created by to hoang nam on 21/8/25.
//

import Foundation

import SwiftUI

struct OverlayTextModel: Identifiable {
    var id = UUID()
    var text: String
    var offset: CGSize = .zero
    var endset: CGSize = .zero
    var angle: Angle = Angle(degrees: 0)
    var currentAngle: Angle = Angle(degrees: 0)
    var currentZoom: CGFloat = 0
    var scaleZoom: CGFloat = 0
    var isRotating: Bool = false
    var isZoom: Bool = false
    
    var isSelected: Bool = false
    var isEditingText: Bool = false
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
}

