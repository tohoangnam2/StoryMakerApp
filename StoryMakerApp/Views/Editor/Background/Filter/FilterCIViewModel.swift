//
//  FilterCIViewModel.swift
//  StoryMakerApp
//
//  Created by Nam To on 29/10/25.
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

enum FilterType: String, CaseIterable, Identifiable {
    
    var id: String { rawValue }

    case none = "None"
    case noir = "CIPhotoEffectNoir"
    case sepia = "CISepiaTone"
    case invert = "CIColorInvert"
    case mono = "CIPhotoEffectMono"
    case chrome = "CIPhotoEffectChrome"
    case fade = "CIPhotoEffectFade"
    case instant = "CIPhotoEffectInstant"
    case posterize = "CIColorPosterize"
    case colorAbsolute = "CIColorAbsoluteDifference"
    case toneCuver = "CustomToneCurve"
    case vibrance = "CIPhotoEffectVibrance"
    
    var displayName: String {
           switch self {
           case .none: 
               return "None"
           case .noir: 
               return "Noir"
           case .sepia: 
               return "Sepia"
           case .invert: 
               return "Invert"
           case .mono: 
               return "Mono"
           case .chrome: 
               return "Chrome"
           case .fade: 
               return "Fade"
           case .instant: 
               return "Instant"
           case .posterize: 
               return "Posterize"
           case .colorAbsolute: 
               return "Abs Diff"
           case .toneCuver:
               return "Tone Cur"
           case .vibrance:
               return "Vibrance"
           }
    }
}
// MARK: - Helper: Resize
extension UIImage {
    func resized(to targetSize: CGSize) -> UIImage {
        let widthRatio = targetSize.width / size.width
        let heightRatio = targetSize.height / size.height
        let ratio = min(widthRatio, heightRatio)
        let newSize = CGSize(width: size.width * ratio, height: size.height * ratio)
        let renderer = UIGraphicsImageRenderer(size: newSize)
        return renderer.image { _ in self.draw(in: CGRect(origin: .zero, size: newSize)) }
    }
}
