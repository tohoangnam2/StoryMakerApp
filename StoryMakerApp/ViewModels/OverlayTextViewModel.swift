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
    @Published var editingOverlayID: UUID? = nil

    func selectOverlay(_ id: UUID) {
        selectedOverlayID = id
    }

    func deselect() {
        selectedOverlayID = nil
    }

    func addOverlay(_ text: String) -> OverlayTextModel {
        let newOverlay = OverlayTextModel(
            id: UUID(),
            text: text,
            offset: .zero,
            endset: .zero,
            currentZoom: 1,
            displayZoom: 1,
            value: 0
        )
        overlays.append(newOverlay)
        return newOverlay
    }

    func removeOverlay(_ id: UUID) {
        overlays.removeAll { $0.id == id }
        if selectedOverlayID == id {
            selectedOverlayID = nil
        }
    }

    func copyOverlay(_ overlay: OverlayTextModel) {
        var copied = overlay
        copied.id = UUID()
        copied.offset.width += 40
        copied.offset.height += 40
        copied.endset = copied.offset
        
        overlays.append(copied)
        selectedOverlayID = copied.id
    }
}


