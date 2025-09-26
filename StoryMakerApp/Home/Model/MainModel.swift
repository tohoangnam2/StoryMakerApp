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
    var selectedFilter: String? = nil
    var blur: Double = 0
    var shadow: Double = 0
    var opacity: Double = 1
    var lightness: Double = 0
    var saturation: Double = 1
    
    // Frame
    var frame : Frame? = nil
    var frameID: String? = nil
    
    // Preview
    var previewImageData: Data? = nil // lưu UIImage dưới dạng Data nếu cần
    
    init(id: UUID = UUID()) {
            self.id = id
        }
}


extension MainModel {
    var isNew: Bool {
        return previewImageData == nil
    }
}
