//
//  Snapshot.swift
//  StoryMakerApp
//
//  Created by Nam To on 18/9/25.
//
import UIKit
import SwiftUI

//extension UIView {
//    func snapshot() -> UIImage {
//        let renderer = UIGraphicsImageRenderer(bounds: bounds)
//        return renderer.image { ctx in
//            layer.render(in: ctx.cgContext)
//        }
//    }
//}
// Hàm tiện ích snapshot view SwiftUI
import SwiftUI

@available(iOS 16.0, *)
extension View {
    func snapshotImage(size: CGSize? = nil) -> UIImage {
        let renderer = ImageRenderer(content: self)
        
        if let size = size {
            renderer.proposedSize = .init(size)
        } else {
            renderer.proposedSize = .unspecified
        }
        
        if let uiImage = renderer.uiImage {
            return uiImage
        } else {
            return UIImage()
        }
    }
}

extension UIView {
    func snapshot() -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: bounds.size)
        return renderer.image { _ in
            drawHierarchy(in: bounds, afterScreenUpdates: true)
        }
    }
}








//extension View {
//    func snapshotFromWindow() -> UIImage? {
//        let controller = UIHostingController(rootView: self)
//        guard let view = controller.view else { return nil }
//
//        let window = UIApplication.shared.connectedScenes
//            .compactMap { ($0 as? UIWindowScene)?.keyWindow }
//            .first
//
//        guard let rootView = window?.rootViewController?.view else { return nil }
//
//        return rootView.snapshot()
//    }
//}





