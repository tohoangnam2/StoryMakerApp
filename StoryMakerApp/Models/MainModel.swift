//
//  MainModel.swift
//  StoryMakerApp
//
//  Created by Nam To on 22/9/25.
//

import SwiftUI

struct MainModel: Identifiable, Codable {
    var id: UUID
    var textLayers: [OverlayTextModel] = []
    var blur: Double = 0
    var shadow: Double = 0
    var opacity: Double = 1
    var lightness: Double = 0
    var saturation: Double = 1
    var frame: Frame? = nil
    var frameID: String? = nil
    var selectedFilter: String?
    var previewImagePath: String?
    var originalImagePath: String?
    var filteredImagePath : String?

    // Không encode UIImage
    var previewImage: UIImage?
    var filteredImage: UIImage? 

    enum CodingKeys: String, CodingKey {
        case id, textLayers, frame, blur, shadow, opacity, lightness, saturation, selectedFilter, previewImagePath, originalImagePath,filteredImagePath
    }
    init(id: UUID = UUID()) {
        self.id = id
    }
}



