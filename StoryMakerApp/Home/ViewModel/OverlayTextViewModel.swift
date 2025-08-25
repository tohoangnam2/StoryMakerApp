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
    @Published var selectedOverlayID: UUID? = nil
    
    

    
//    func addOverlay(_ text: String) {
//        overlays.append(OverlayTextModel(text: text))
//    }
    
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
    func setEditingSelectedOverlay(_ isEditing: Bool) {
        if let index = overlays.firstIndex(where: { $0.id == selectedOverlayID }) {
            overlays[index].isEditingText = isEditing
        }
    }

    
    func selectOverlay(_ id: UUID) {
        selectedOverlayID = id
    }
    func addOverlay(_ text: String) -> OverlayTextModel {
        let newOverlay = OverlayTextModel(
            id: UUID(),
            text: text,
            offset: .zero,
            endset: .zero,
            angle: .zero,
            currentAngle: .zero,
            currentZoom: 0,
            scaleZoom: 1
        )
        overlays.append(newOverlay)
        return newOverlay
    }

    


}

