//
//  OverlayTextViewModel.swift
//  StoryMakerApp
//
//  Created by to hoang nam on 21/8/25.
//

import SwiftUI
import Foundation

class OverlayTextViewModel: ObservableObject {
    @Published var overlays: [OverlayTextModel] = []
    
    func addOverlay(_ text: String) {
        overlays.append(OverlayTextModel(text: text))
    }
    
    func removeOverlay(_ id: UUID) {
        overlays.removeAll { $0.id == id }
    }
    func copyOverlay(_ overlay: OverlayTextModel) {
        var newOverlay = overlay
        newOverlay.id = UUID()
        newOverlay.offset.width += 30
        newOverlay.offset.height += 30
        overlays.append(newOverlay)
    }
    
    //tìm vị trí trong mảng đúng thì edit =true
    func focusSelectedOverlay() {
        if let index = overlays.firstIndex(where: { $0.isSelected }) {
            overlays[index].isEditingText = true
        }
    }
    
//    func saveEditing(newText: String) {
//        if let index = overlays.firstIndex(where: { $0.isEditing }) {
//            overlays[index].text = newText
//            overlays[index].isEditing = false
//        }
//    }

}

