//
//  SmoothAnimator.swift
//  StoryMakerApp
//
//  Created by Nam To on 28/10/25.
//

import SwiftUI
import Combine

// MARK: - Singleton animator 60fps
final class SmoothAnimator {
    static let shared = SmoothAnimator()
    
    private var displayLink: CADisplayLink?
    private var cancellables = Set<AnyCancellable>()
    
    // Danh sách overlay cần update
    private var overlays: [OverlayTextModel] = []
    
    private init() {}

    func register(_ overlay: OverlayTextModel) {
        if !overlays.contains(where: { $0.id == overlay.id }) {
            overlays.append(overlay)
        }
    }
    
    func unregister(_ overlay: OverlayTextModel) {
        overlays.removeAll { $0.id == overlay.id }
    }
    
    func start() {
        displayLink?.invalidate()
        displayLink = CADisplayLink(target: self, selector: #selector(tick))
        displayLink?.add(to: .main, forMode: .common)
    }
    
    func stop() {
        displayLink?.invalidate()
        displayLink = nil
    }

    // MARK: - Update mỗi frame (60fps)
    @objc private func tick() {
        let lerpFactor: CGFloat = 0.35
        for i in 0..<overlays.count {
            overlays[i].offset.width += (overlays[i].targetOffset.width - overlays[i].offset.width) * lerpFactor
            overlays[i].offset.height += (overlays[i].targetOffset.height - overlays[i].offset.height) * lerpFactor
        }
    }

}

