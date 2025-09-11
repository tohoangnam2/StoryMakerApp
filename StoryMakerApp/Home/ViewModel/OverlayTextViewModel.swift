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
    
    var isAnyOverlayEditing: Bool {
        overlays.contains { $0.isEditingText }
    }
    // Thêm biến này vào class Overlay của bạn
    

    
//    func addOverlay(_ text: String) {
//        overlays.append(OverlayTextModel(text: text))
//    }
    
    func removeOverlay(_ id: UUID) {
        overlays.removeAll { $0.id == id }
    }
    

    
    func copyOverlay(_ overlay: OverlayTextModel) {
        //bỏ chọn các overlay trước 
        for index in overlays.indices {
                overlays[index].isEditingText = true
            }
        
        var newOverlay = overlay
        newOverlay.id = UUID()
        newOverlay.offset.width += 30
        newOverlay.offset.height += 30
        overlays.append(newOverlay)
        selectOverlay(newOverlay.id)
            
    }
    
    //tìm vị trí trong mảng đúng thì edit =true
    func setEditingSelectedOverlay(_ isEditing: Bool) {
        if let index = overlays.firstIndex(where: { $0.id == selectedOverlayID }) {
            overlays[index].isEditingText = isEditing
        }
    }

    
    func selectOverlay(_ id: UUID) {
        selectedOverlayID = id
        setEditingSelectedOverlay(false)
    }
    
    func addOverlay(_ text: String) -> OverlayTextModel {
        let newOverlay = OverlayTextModel(
            id: UUID(),
            text: text,
            offset: .zero,
            endset: .zero,
            
            currentZoom: 1,
            displayZoom: 1, value: 0
        )
        overlays.append(newOverlay)
        return newOverlay
    }
    
    func deselectAll() {
        selectedOverlayID = nil
        for index in overlays.indices {
            overlays[index].isEditingText = true
        }
    }
    
    func activateGesture(for id: UUID, type: OverlayGestureType) {
        for index in overlays.indices {
            if overlays[index].id == id {
                overlays[index].activeGesture = type
            } else {
                overlays[index].activeGesture = .none
            }
        }
    }

  

    


}

