//
//  MainModel.swift
//  StoryMakerApp
//
//  Created by Nam To on 22/9/25.
//

import SwiftUI


struct MainModel: Identifiable, Codable {
    var id: UUID
    
    // Text layers
    var textLayers: [OverlayTextModel] = []
    
    // Background
    var blur: Double = 0
    var shadow: Double = 0
    var opacity: Double = 1
    var lightness: Double = 0
    var saturation: Double = 1
    
    // Frame
    var frame: Frame? = nil
    var frameID: String? = nil
    var selectedFilter: String?

    // Preview và original path
    var previewImagePath: String?
    var originalImagePath: String?
    
    // Không encode UIImage trực tiếp
    var previewImage: UIImage?
    

    enum CodingKeys: String, CodingKey {
        case id, textLayers, frame, blur, shadow, opacity, lightness, saturation,selectedFilter,previewImagePath,originalImagePath
    }
    
    init(id: UUID = UUID()) {
        self.id = id
    }
}

