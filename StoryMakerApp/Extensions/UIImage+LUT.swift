////
////  UIImage+LUT.swift
////  StoryMakerApp
////
////  Created by Nam To on 12/9/25.
////
//import SwiftUI
//import Foundation
//import UIKit
//import CoreImage
//
//extension UIImage {
//    func applyingLUT(lutImage: UIImage, dimension: Int = 64) -> UIImage? {
//        guard let lutCGImage = lutImage.cgImage else { return nil }
//        let lutWidth = lutCGImage.width
//        let lutHeight = lutCGImage.height
//
//        guard lutWidth % dimension == 0, lutHeight % dimension == 0 else { return nil }
//
//        guard let lutData = LUTImageToData(lutImage: lutImage, dimension: dimension) else { return nil }
//
//        guard let ciImage = CIImage(image: self) else { return nil }
//        let filter = CIFilter(name: "CIColorCube")
//        filter?.setValue(dimension, forKey: "inputCubeDimension")
//        filter?.setValue(lutData, forKey: "inputCubeData")
//        filter?.setValue(ciImage, forKey: kCIInputImageKey)
//
//        guard let output = filter?.outputImage else { return nil }
//        let context = CIContext()
//        if let cgImage = context.createCGImage(output, from: output.extent) {
//            return UIImage(cgImage: cgImage)
//        }
//        return nil
//    }
//
//    private func LUTImageToData(lutImage: UIImage, dimension: Int) -> Data? {
//        guard let cgImage = lutImage.cgImage else { return nil }
//        let width = cgImage.width
//        let height = cgImage.height
//
//        let bitmap = calloc(width * height * 4, MemoryLayout<GLubyte>.size)
//        defer { free(bitmap) }
//
//        let colorSpace = CGColorSpaceCreateDeviceRGB()
//        let context = CGContext(data: bitmap,
//                                width: width,
//                                height: height,
//                                bitsPerComponent: 8,
//                                bytesPerRow: width * 4,
//                                space: colorSpace,
//                                bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)
//
//        context?.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
//
//        guard let ptr = bitmap?.assumingMemoryBound(to: GLubyte.self) else { return nil }
//
//        var data = [Float]()
//        for z in 0 ..< dimension {
//            for y in 0 ..< dimension {
//                for x in 0 ..< dimension {
//                    let column = x + (z % (width / dimension)) * dimension
//                    let row = y + (z / (width / dimension)) * dimension
//                    let offset = (row * width + column) * 4
//
//                    let r = Float(ptr[offset]) / 255.0
//                    let g = Float(ptr[offset + 1]) / 255.0
//                    let b = Float(ptr[offset + 2]) / 255.0
//                    let a = Float(ptr[offset + 3]) / 255.0
//                    data.append(contentsOf: [r, g, b, a])
//                }
//            }
//        }
//
//        return Data(buffer: UnsafeBufferPointer(start: &data, count: data.count))
//    }
//}
