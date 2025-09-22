//
//  BackgroundEditorView.swift
//  StoryMakerApp
//
//  Created by Nam To on 10/9/25.
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

struct BackgroundEditorView: View {
    @EnvironmentObject var vm: BackgroundEditorViewModel
    @Environment(\.dismiss) private var dismiss


    @State var editEnum : BackGroundEditEditEnum = .filter
    
    @ObservedObject  var overlayVM : OverlayTextViewModel
    
    @State private var frame: Frame?
    
    
    @Binding var isShowBackgroundPicker : Bool
    @Binding var showBackgroundEdit : Bool
    
    @Binding var isSelected : Bool


    
    var body: some View {
        ZStack{
            VStack {
                VStack{
                    HStack {
                        Button(action: {}) {
                            Image("img_edit1_keyboard")
                                .opacity(0)
                        }
                        Spacer()
                        Text(editEnum.title)
                            .font(.system(size: 16, weight: .medium))
                        Spacer()
                        Button(action: {
                            showBackgroundEdit = false

                        }) {
                            Image("img_bg_check")
                        }
                        .background(.white)
                    }
                    .padding(.top, 10)
                    .padding(.horizontal)
                    HStack(spacing: 20) {
                        Button(action: {
                            editEnum = .none
                            isShowBackgroundPicker = true
                            showBackgroundEdit = false

                        }) {
                            Image("none")
                                .foregroundColor(editEnum == .none ? .red : .black)
                        }

                        Button(action: {
                            editEnum = .filter

                        }) {
                            Image("ic_filter")
                                .foregroundColor(editEnum == .filter ? .red : .black)
                        }
                        Button(action: {
                            editEnum = .brightness
                        }) {
                            Image("ic_brightness")
                                .foregroundColor(editEnum == .brightness ? .red : .black)
                        }
                    }
                    .padding(10)
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 12)
                    .background(Color.gray.opacity(0.2).cornerRadius(70))
                }
                ZStack {
                    switch editEnum {
                    case .none:
                        EmptyView()
                    case .filter:
                        FilterEditorView()
                    case .brightness:
                        BrightNessBGView()
                        
                    }
                }
                .id(editEnum)
                .transition(.opacity.combined(with: .move(edge: .bottom)))
                .animation(.easeInOut(duration: 0.2), value: editEnum)

                
                

            }
        }
        .background(.white)
        .padding(.top,5)


    }
}


//MARK: EXTENSION LUT- FILTER

extension UIImage {
    func applyingLUT(lutImage: UIImage, dimension: Int = 64) -> UIImage? {
        guard let ciImage = CIImage(image: self),
              let lutCI = CIImage(image: lutImage) else { return nil }

        let size = lutCI.extent.size
        let rowCount = Int(size.height) / dimension
        let columnCount = Int(size.width) / dimension
        let dataSize = dimension * dimension * dimension * 4
        var cubeData = [Float](repeating: 0, count: dataSize)

        var offset = 0
        let bitmap = lutCI.bitmapRepresentation() // sẽ viết helper bên dưới
        for z in 0..<dimension {
            let zOffset = z / columnCount
            let xOffset = z % columnCount
            for y in 0..<dimension {
                for x in 0..<dimension {
                    let px = (x + xOffset * dimension)
                    let py = (y + zOffset * dimension)
                    let pixelIndex = (py * Int(size.width) + px) * 4
                    let r = bitmap[pixelIndex]
                    let g = bitmap[pixelIndex + 1]
                    let b = bitmap[pixelIndex + 2]
                    let a = bitmap[pixelIndex + 3]

                    cubeData[offset] = Float(r) / 255.0
                    cubeData[offset + 1] = Float(g) / 255.0
                    cubeData[offset + 2] = Float(b) / 255.0
                    cubeData[offset + 3] = Float(a) / 255.0
                    offset += 4
                }
            }
        }

        let data = Data(buffer: UnsafeBufferPointer(start: &cubeData, count: cubeData.count))
        guard let filter = CIFilter(name: "CIColorCube") else { return nil }
        filter.setValue(dimension, forKey: "inputCubeDimension")
        filter.setValue(data, forKey: "inputCubeData")
        filter.setValue(ciImage, forKey: kCIInputImageKey)

        guard let output = filter.outputImage else { return nil }
        let context = CIContext()
        if let cgimg = context.createCGImage(output, from: output.extent) {
            return UIImage(cgImage: cgimg)
        }
        return nil
    }
}

private extension CIImage {
    func bitmapRepresentation() -> [UInt8] {
        let context = CIContext()
        let width = Int(extent.width)
        let height = Int(extent.height)
        var bitmap = [UInt8](repeating: 0, count: width * height * 4)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        context.render(self,
                       toBitmap: &bitmap,
                       rowBytes: width * 4,
                       bounds: extent,
                       format: .RGBA8,
                       colorSpace: colorSpace)
        return bitmap
    }
}
