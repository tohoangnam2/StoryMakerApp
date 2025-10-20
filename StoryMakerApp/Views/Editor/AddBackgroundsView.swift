//
//  AddBackgroundsView.swift
//  StoryMakerApp
//
//  Created by Nam To on 17/9/25.
//

import SwiftUI

enum EditMode {
    case none
    case moving
    case rotating
    case scaling
}

struct AddBackgroundsView: View {
    
    @ObservedObject var overlayVM: OverlayTextViewModel
    
    @StateObject private var bgoverrlayVM = BackGroundViewModel()

    let frame: Frame?
    
    @Binding var showTextField: Bool
    @FocusState.Binding var isTextFieldFocused: Bool
    @Binding var isSelected : Bool
    @Binding var isEditingText : Bool
    let onAddTap: () -> Void
    
    let onTapOutside: () -> Void
    
    let onOpenBackgroundEditor: () -> Void

    @Binding var isShowBackgroundPicker: Bool
    @Binding var showBackgroundEdit: Bool
    
    @EnvironmentObject var vm: BackgroundEditorViewModel
    
    @State private var isImageLoaded = false
    
    var filteredImage: Binding<UIImage?>
    @Binding var project : MainModel?

    var body: some View {
        NavigationView {
            ZStack {
//                if let frame = frame {
//                    AsyncImage(url: frame.backgroundURL) {img in
//                        img.resizable()
//                            .scaledToFill()
//                            .frame(maxWidth: .infinity,maxHeight: .infinity)
//                            .contentShape(Rectangle())
//                            .onAppear {
//                                DispatchQueue.main.async {
//                                    if vm.finalImage == nil {
//                                        if let url = frame.backgroundURL,
//                                           let data = try? Data(contentsOf: url),
//                                           let uiImage = UIImage(data: data) {
//                                            vm.baseImage = uiImage
//                                            vm.defaultPreview = uiImage
//                                            vm.prepareAllPreviews()
//                                            vm.updatePreview()
//                                            vm.isImageLoaded = true
//                                        }
//                                    }
//                                }
//                            }
//                            .overlay(
//                                Group {
//                                    if let filtered = filteredImage.wrappedValue, let p = project {
//                                        Image(uiImage: filtered)
//                                            .resizable()
//                                            .scaledToFill()
//                                            .opacity(p.opacity)
//                                            .brightness(p.lightness)   // điều chỉnh sáng tối
//                                            .saturation(p.saturation) // điều chỉnh độ bão hòa
//                                            .blur(radius: p.blur)
//                                            .shadow(radius: p.blur)
//                                            .allowsHitTesting(false)
//                                    }
//                                    
//                                }
//                            )
//                        //img
//                            .onTapGesture {
//                                guard frame != nil else { return }
//                                if isSelected == false{
//                                    onOpenBackgroundEditor()
//                                } else {
//                                    onTapOutside()
//                                    showBackgroundEdit = false
//
//                                }
//
//                            }
//                            .overlay(
//                                //Group không ảnh hưởng layout, chỉ gom nhiều view trong điều kiện.
//                                Group {
//                                    ForEach($overlayVM.overlays){ $overlay in
//                                        if showTextField && overlay.id == overlayVM.selectedOverlayID   {
//                                            TextField("Nhập chữ...", text: $overlay.text)
//                                                .padding(8)
//                                                .background(Color.white.opacity(0.8))
//                                                .cornerRadius(8)
//                                                .padding(.horizontal,UIScreen.main.bounds.width/3)
//                                                .focused($isTextFieldFocused)
//                                                .onSubmit {
//                                                    showTextField = false
//                                                }
//                                        }
//                                        
//                                        else if !overlay.text.isEmpty  {
//                                            ZStack{
//                                                //case
//                                                Text({
//                                                    switch overlay.selectedAlignCase {
//                                                    case .up: return overlay.text.uppercased()
//                                                    case .cap: return overlay.text.capitalized
//                                                    case .low: return overlay.text.lowercased()
//                                                    case .none: return overlay.text
//                                                    }
//                                                }())
//                                                .font(.custom(overlay.selectedFontFamily.fontFamily, size: overlay.fontSize))
//                                                .kerning(overlay.letterSpacing)
//                                                .lineSpacing(overlay.lineHeight)
//                                                .rotation3DEffect(
//                                                    .degrees(overlay.cuver * 10), // slider điều khiển
//                                                    axis: (x: 0, y: 2, z: 0)
//                                                )
//                                                //align
//                                                .frame(maxWidth: UIScreen.main.bounds.width/1.5, alignment: {
//                                                    switch overlay.selectedAlign {
//                                                    case .left: return .leading
//                                                    case .center: return .center
//                                                    case .right: return .trailing
//                                                    case .none: return .center
//                                                    }
//                                                }())
//                                                .contentShape(Rectangle())
//                                                //solid
//                                                .if(!overlay.userGradient) { view in
//                                                    view.foregroundColor(Color(hex: overlay.colorSolid)?.opacity(overlay.valueOpacity) ?? .black)                                                }
//                                                //gradient
//                                                .if(overlay.userGradient) { view in
//                                                    view.foregroundStyle(overlay.gradient)
//                                                        .opacity(overlay.valueOpacity)
//                                                }
//                                                .padding(overlay.paddingBG)
//                                                .shadow(
//                                                    color:Color(hex: overlay.shawDowColor)?.opacity(overlay.opacitySD) ?? .black,
//                                                    //độ mở
//                                                    radius: overlay.blurSD,
//                                                    x: overlay.offSetXSD,
//                                                    y: overlay.offSetYSD
//                                                )
//                                                
//                                                .padding(.horizontal)
//                                                
//                                                .onTapGesture(perform: {
//                                                    overlayVM.setEditingSelectedOverlay(false)
//                                                    overlayVM.selectOverlay(overlay.id)
//                                                    if !overlay.isEditingText {
//                                                        isSelected = true
//                                                        isTextFieldFocused = true
//                                                    }
//                                                    print(overlay.id)
//                                                })
//                                                .onTapGesture(count: 2, perform: {
//                                                    showTextField = true
//                                                    isTextFieldFocused = true
//                                                    showBackgroundEdit = false
//
//                                                })
//                                                .gesture(
//                                                    DragGesture(coordinateSpace: .named("canvas"))
//                                                        .onChanged { value in
//                                                            overlay.offset = CGSize(
//                                                                width: overlay.endset.width + value.translation.width,
//                                                                height: overlay.endset.height + value.translation.height
//                                                            )
//                                                        }
//                                                        .onEnded { _ in
//                                                            overlay.endset = overlay.offset
//                                                        }
//                                                )
//                                                .padding()
//                                                
//                                                .background(
//                                                    Group{
//                                                        GeometryReader {textGeo in
//                                                            ZStack {
//                                                                Color(hex: overlay.bgColor)?
//                                                                    .opacity(overlay.opacityBG)
//                                                                    .cornerRadius(overlay.cornerRadiusBG)
//                                                                    .frame(width: textGeo.size.width, height: textGeo.size.height)
//                                                                    .allowsHitTesting(false)
//                                                                
//                                                                if !overlay.isEditingText {
//                                                                    
//                                                                    Rectangle()
//                                                                        .stroke(style: StrokeStyle(lineWidth: 2 / overlay.currentScale))
//                                                                        .foregroundColor(Color.black.opacity(0.6))
//                                                                    Image("img_edit_x")
//                                                                        .resizable()
//                                                                        .scaledToFit()
//                                                                        .frame(width: overlay.buttonSize , height:  overlay.buttonSize)
//                                                                        .padding(10 / overlay.currentScale)
//                                                                        .contentShape(Rectangle())
//                                                                    
//                                                                        .position(x: 0, y: 0)
//                                                                        .onTapGesture {
//                                                                            overlayVM.removeOverlay(overlay.id)
//                                                                        }
//                                                                    
//                                                                    Image("img_edit_copy")
//                                                                        .resizable()
//                                                                        .scaledToFit()
//                                                                        .frame(width: overlay.buttonSize , height:  overlay.buttonSize)
//                                                                        .padding(10 / overlay.currentScale)
//                                                                        .contentShape(Rectangle())
//                                                                        .position(x: textGeo.size.width, y: 0)
//                                                                        .onTapGesture {
//                                                                            overlayVM.selectOverlay(overlay.id)
//                                                                            overlayVM.copyOverlay(overlay)
//                                                                            for item in overlayVM.overlays {
//                                                                                print(item.id)
//                                                                            }
//                                                                        }
//                                                                    
//                                                                    Image("img_edit_xoay")
//                                                                        .resizable()
//                                                                        .scaledToFit()
//                                                                        .frame(width: overlay.buttonSize , height:  overlay.buttonSize)
//                                                                        .padding(10 / overlay.currentScale)
//                                                                        .contentShape(Rectangle())
//                                                                        .position(x: 0, y: textGeo.size.height)
//                                                                        .gesture(
//                                                                            DragGesture(minimumDistance: 10, coordinateSpace: .named("canvas"))
//                                                                                .onChanged { value in
//                                                                                    let center = CGPoint(
//                                                                                        x: textGeo.frame(in: .named("canvas")).midX,
//                                                                                        y: textGeo.frame(in: .named("canvas")).midY
//                                                                                    )
//                                                                                    
//                                                                                    if overlay.startLocation == nil {
//                                                                                        let dx = value.startLocation.x - center.x
//                                                                                        let dy = value.startLocation.y - center.y
//                                                                                        overlay.startLocation = CGPoint(x: dx, y: dy)
//                                                                                        overlay.startAngle = overlay.currentRotation   // Double
//                                                                                    }
//                                                                                    
//                                                                                    let currentVector = CGVector(
//                                                                                        dx: value.location.x - center.x,
//                                                                                        dy: value.location.y - center.y
//                                                                                    )
//                                                                                    let startVector = CGVector(
//                                                                                        dx: overlay.startLocation!.x,
//                                                                                        dy: overlay.startLocation!.y
//                                                                                    )
//                                                                                    
//                                                                                    let angleChange = atan2(currentVector.dy, currentVector.dx)
//                                                                                                     - atan2(startVector.dy, startVector.dx)
//
//                                                                                    let angleInDegrees = CGFloat(angleChange) * 180 / .pi
//
//                                                                                    overlay.currentRotation = overlay.startAngle + angleInDegrees
//                                                                                }
//                                                                                .onEnded { _ in
//                                                                                    overlay.startLocation = nil
//                                                                                }
//                                                                        )
//
//                                                                    
//                                                                    Image("img_edit_zoom")
//                                                                        .resizable()
//                                                                        .scaledToFit()
//                                                                        .frame(width: overlay.buttonSize , height:  overlay.buttonSize)
//                                                                        .padding(10 / overlay.currentScale)
//                                                                        .contentShape(Rectangle())
//                                                                        .position(x: textGeo.size.width, y: textGeo.size.height)
//                                                                        .gesture(
//                                                                            DragGesture(minimumDistance: 0, coordinateSpace: .named("canvas"))
//                                                                                .onChanged { value in
//                                                                                    if overlay.startDistance == 0 {
//                                                                                        let frameSize = textGeo.size
//
//                                                                                        overlay.startCenter = CGPoint(
//                                                                                            x: (frameSize.width / 2) + overlay.endset.width,
//                                                                                            y: (frameSize.height / 2) + overlay.endset.height
//                                                                                        )
//
//                                                                                        overlay.startDistance = hypot(
//                                                                                            value.location.x - overlay.startCenter.x,
//                                                                                            value.location.y - overlay.startCenter.y
//                                                                                        )
//                                                                                        overlay.startScale = overlay.currentScale
//
//                                                                                        overlay.startAngleToCenter = atan2(
//                                                                                            value.location.y - overlay.startCenter.y,
//                                                                                            value.location.x - overlay.startCenter.x
//                                                                                        )
//                                                                                    }
//
//                                                                                    let currentAngle = atan2(
//                                                                                        value.location.y - overlay.startCenter.y,
//                                                                                        value.location.x - overlay.startCenter.x
//                                                                                    )
//
//                                                                                    if let startAngle = overlay.startAngleToCenter {
//                                                                                        let angleDiff = abs((currentAngle - startAngle).truncatingRemainder(dividingBy: .pi * 2))
//                                                                                        if angleDiff > (.pi / 4) { // ±45°
//                                                                                            return
//                                                                                        }
//                                                                                    }
//
//                                                                                    let currentDistance = hypot(
//                                                                                        value.location.x - overlay.startCenter.x,
//                                                                                        value.location.y - overlay.startCenter.y
//                                                                                    )
//                                                                                    let scaleFactor = currentDistance / overlay.startDistance
//
//                                                                                    let minScale: CGFloat = 0.5
//                                                                                    let maxScale: CGFloat = 3.0
//
//                                                                                    var newScale = overlay.startScale * scaleFactor
//
//                                                                                    if newScale < minScale {
//                                                                                        newScale = minScale
//                                                                                    } else if newScale > maxScale {
//                                                                                        newScale = maxScale
//                                                                                    }
//
//                                                                                    overlay.currentScale = newScale
//                                                                                }
//                                                                                .onEnded { _ in
//                                                                                    overlay.startDistance = 0
//                                                                                    overlay.startScale = overlay.currentScale
//                                                                                    overlay.startAngleToCenter = nil
//                                                                                }
//                                                                        )
//                                                                }
//                                                            }
//                                                        }
//                                                    }
//                                                )
//                                                //move+ rotate + zoom
//                                                .rotationEffect(.degrees(overlay.currentRotation), anchor: .center)
//                                                .offset(x: overlay.offset.width / overlay.currentScale,
//                                                        y: overlay.offset.height / overlay.currentScale)
//                                                .scaleEffect(overlay.currentScale)
//                                            }
//                                        }
//                                    }
//                                    .coordinateSpace(name: "canvas")
//                                    
//                                }
//                            )
//                    }
//                    placeholder: {
//                        ProgressView()
//                    }
//                    .id(frame.id)
//                }
                if let frame = frame {
                    ZStack {
                        // Ưu tiên ảnh offline
                        if let project = project,
                           let originalName = project.originalImagePath {
                            
                            let folderURL = ProjectStorage.projectFolder(for: project.id)
                            let localURL = folderURL.appendingPathComponent(originalName)
                            
                            if let data = try? Data(contentsOf: localURL),
                               let uiImage = UIImage(data: data) {
                                
                                //  Ảnh offline (load thành công)
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .contentShape(Rectangle())
                                    .onAppear {
                                        if vm.finalImage == nil {
                                            vm.baseImage = uiImage
                                            vm.defaultPreview = uiImage
                                            vm.prepareAllPreviews()
                                            vm.updatePreview()
                                            vm.isImageLoaded = true
                                        }
                                    }
                                    .overlay(
                                        Group {
                                            if let filtered = filteredImage.wrappedValue {
                                                Image(uiImage: filtered)
                                                    .resizable()
                                                    .scaledToFill()
                                                    .opacity(project.opacity)
                                                    .brightness(project.lightness)   // điều chỉnh sáng tối
                                                    .saturation(project.saturation) // điều chỉnh độ bão hòa
                                                    .blur(radius: project.blur)
                                                    .shadow(radius: project.blur)
                                                    .allowsHitTesting(false)
                                            }
                                            
                                        }
                                    )
                                    .onTapGesture {
                                        guard frame != nil else { return }
                                        if isSelected == false{
                                            onOpenBackgroundEditor()
                                        } else {
                                            onTapOutside()
                                            showBackgroundEdit = false

                                        }

                                    }
                                    .overlay(
                                        //Group không ảnh hưởng layout, chỉ gom nhiều view trong điều kiện.
                                        Group {
                                            ForEach($overlayVM.overlays){ $overlay in
                                                if showTextField && overlay.id == overlayVM.selectedOverlayID   {
                                                    TextField("Nhập chữ...", text: $overlay.text)
                                                        .padding(8)
                                                        .background(Color.white.opacity(0.8))
                                                        .cornerRadius(8)
                                                        .padding(.horizontal,UIScreen.main.bounds.width/3)
                                                        .focused($isTextFieldFocused)
                                                        .onSubmit {
                                                            showTextField = false
                                                        }
                                                }
                                                
                                                else if !overlay.text.isEmpty  {
                                                    ZStack{
                                                        //case
                                                        Text({
                                                            switch overlay.selectedAlignCase {
                                                            case .up: return overlay.text.uppercased()
                                                            case .cap: return overlay.text.capitalized
                                                            case .low: return overlay.text.lowercased()
                                                            case .none: return overlay.text
                                                            }
                                                        }())
                                                        .font(.custom(overlay.selectedFontFamily.fontFamily, size: overlay.fontSize))
                                                        .kerning(overlay.letterSpacing)
                                                        .lineSpacing(overlay.lineHeight)
                                                        .rotation3DEffect(
                                                            .degrees(overlay.cuver * 10), // slider điều khiển
                                                            axis: (x: 0, y: 2, z: 0)
                                                        )
                                                        //align
                                                        .frame(maxWidth: UIScreen.main.bounds.width/1.5, alignment: {
                                                            switch overlay.selectedAlign {
                                                            case .left: return .leading
                                                            case .center: return .center
                                                            case .right: return .trailing
                                                            case .none: return .center
                                                            }
                                                        }())
                                                        .contentShape(Rectangle())
                                                        //solid
                                                        .if(!overlay.userGradient) { view in
                                                            view.foregroundColor(Color(hex: overlay.colorSolid)?.opacity(overlay.valueOpacity) ?? .black)                                                }
                                                        //gradient
                                                        .if(overlay.userGradient) { view in
                                                            view.foregroundStyle(overlay.gradient)
                                                                .opacity(overlay.valueOpacity)
                                                        }
                                                        .padding(overlay.paddingBG)
                                                        .shadow(
                                                            color:Color(hex: overlay.shawDowColor)?.opacity(overlay.opacitySD) ?? .black,
                                                            //độ mở
                                                            radius: overlay.blurSD,
                                                            x: overlay.offSetXSD,
                                                            y: overlay.offSetYSD
                                                        )
                                                        
                                                        .padding(.horizontal)
                                                        
                                                        .onTapGesture(perform: {
                                                            overlayVM.setEditingSelectedOverlay(false)
                                                            overlayVM.selectOverlay(overlay.id)
                                                            if !overlay.isEditingText {
                                                                isSelected = true
                                                                isTextFieldFocused = true
                                                            }
                                                            print(overlay.id)
                                                        })
                                                        .onTapGesture(count: 2, perform: {
                                                            showTextField = true
                                                            isTextFieldFocused = true
                                                            showBackgroundEdit = false

                                                        })
                                                        .gesture(
                                                            DragGesture(coordinateSpace: .named("canvas"))
                                                                .onChanged { value in
                                                                    overlay.offset = CGSize(
                                                                        width: overlay.endset.width + value.translation.width,
                                                                        height: overlay.endset.height + value.translation.height
                                                                    )
                                                                }
                                                                .onEnded { _ in
                                                                    overlay.endset = overlay.offset
                                                                }
                                                        )
                                                        .padding()
                                                        
                                                        .background(
                                                            Group{
                                                                GeometryReader {textGeo in
                                                                    ZStack {
                                                                        Color(hex: overlay.bgColor)?
                                                                            .opacity(overlay.opacityBG)
                                                                            .cornerRadius(overlay.cornerRadiusBG)
                                                                            .frame(width: textGeo.size.width, height: textGeo.size.height)
                                                                            .allowsHitTesting(false)
                                                                        
                                                                        if !overlay.isEditingText {
                                                                            
                                                                            Rectangle()
                                                                                .stroke(style: StrokeStyle(lineWidth: 2 / overlay.currentScale))
                                                                                .foregroundColor(Color.black.opacity(0.6))
                                                                            Image("img_edit_x")
                                                                                .resizable()
                                                                                .scaledToFit()
                                                                                .frame(width: overlay.buttonSize , height:  overlay.buttonSize)
                                                                                .padding(10 / overlay.currentScale)
                                                                                .contentShape(Rectangle())
                                                                            
                                                                                .position(x: 0, y: 0)
                                                                                .onTapGesture {
                                                                                    overlayVM.removeOverlay(overlay.id)
                                                                                }
                                                                            
                                                                            Image("img_edit_copy")
                                                                                .resizable()
                                                                                .scaledToFit()
                                                                                .frame(width: overlay.buttonSize , height:  overlay.buttonSize)
                                                                                .padding(10 / overlay.currentScale)
                                                                                .contentShape(Rectangle())
                                                                                .position(x: textGeo.size.width, y: 0)
                                                                                .onTapGesture {
                                                                                    overlayVM.selectOverlay(overlay.id)
                                                                                    overlayVM.copyOverlay(overlay)
                                                                                    for item in overlayVM.overlays {
                                                                                        print(item.id)
                                                                                    }
                                                                                }
                                                                            
                                                                            Image("img_edit_xoay")
                                                                                .resizable()
                                                                                .scaledToFit()
                                                                                .frame(width: overlay.buttonSize , height:  overlay.buttonSize)
                                                                                .padding(10 / overlay.currentScale)
                                                                                .contentShape(Rectangle())
                                                                                .position(x: 0, y: textGeo.size.height)
                                                                                .gesture(
                                                                                    DragGesture(minimumDistance: 10, coordinateSpace: .named("canvas"))
                                                                                        .onChanged { value in
                                                                                            let center = CGPoint(
                                                                                                x: textGeo.frame(in: .named("canvas")).midX,
                                                                                                y: textGeo.frame(in: .named("canvas")).midY
                                                                                            )
                                                                                            
                                                                                            if overlay.startLocation == nil {
                                                                                                let dx = value.startLocation.x - center.x
                                                                                                let dy = value.startLocation.y - center.y
                                                                                                overlay.startLocation = CGPoint(x: dx, y: dy)
                                                                                                overlay.startAngle = overlay.currentRotation   // Double
                                                                                            }
                                                                                            
                                                                                            let currentVector = CGVector(
                                                                                                dx: value.location.x - center.x,
                                                                                                dy: value.location.y - center.y
                                                                                            )
                                                                                            let startVector = CGVector(
                                                                                                dx: overlay.startLocation!.x,
                                                                                                dy: overlay.startLocation!.y
                                                                                            )
                                                                                            
                                                                                            let angleChange = atan2(currentVector.dy, currentVector.dx)
                                                                                                             - atan2(startVector.dy, startVector.dx)

                                                                                            let angleInDegrees = CGFloat(angleChange) * 180 / .pi

                                                                                            overlay.currentRotation = overlay.startAngle + angleInDegrees
                                                                                        }
                                                                                        .onEnded { _ in
                                                                                            overlay.startLocation = nil
                                                                                        }
                                                                                )

                                                                            
                                                                            Image("img_edit_zoom")
                                                                                .resizable()
                                                                                .scaledToFit()
                                                                                .frame(width: overlay.buttonSize , height:  overlay.buttonSize)
                                                                                .padding(10 / overlay.currentScale)
                                                                                .contentShape(Rectangle())
                                                                                .position(x: textGeo.size.width, y: textGeo.size.height)
                                                                                .gesture(
                                                                                    DragGesture(minimumDistance: 0, coordinateSpace: .named("canvas"))
                                                                                        .onChanged { value in
                                                                                            if overlay.startDistance == 0 {
                                                                                                let frameSize = textGeo.size

                                                                                                overlay.startCenter = CGPoint(
                                                                                                    x: (frameSize.width / 2) + overlay.endset.width,
                                                                                                    y: (frameSize.height / 2) + overlay.endset.height
                                                                                                )

                                                                                                overlay.startDistance = hypot(
                                                                                                    value.location.x - overlay.startCenter.x,
                                                                                                    value.location.y - overlay.startCenter.y
                                                                                                )
                                                                                                overlay.startScale = overlay.currentScale

                                                                                                overlay.startAngleToCenter = atan2(
                                                                                                    value.location.y - overlay.startCenter.y,
                                                                                                    value.location.x - overlay.startCenter.x
                                                                                                )
                                                                                            }

                                                                                            let currentAngle = atan2(
                                                                                                value.location.y - overlay.startCenter.y,
                                                                                                value.location.x - overlay.startCenter.x
                                                                                            )

                                                                                            if let startAngle = overlay.startAngleToCenter {
                                                                                                let angleDiff = abs((currentAngle - startAngle).truncatingRemainder(dividingBy: .pi * 2))
                                                                                                if angleDiff > (.pi / 4) { // ±45°
                                                                                                    return
                                                                                                }
                                                                                            }

                                                                                            let currentDistance = hypot(
                                                                                                value.location.x - overlay.startCenter.x,
                                                                                                value.location.y - overlay.startCenter.y
                                                                                            )
                                                                                            let scaleFactor = currentDistance / overlay.startDistance

                                                                                            let minScale: CGFloat = 0.5
                                                                                            let maxScale: CGFloat = 3.0

                                                                                            var newScale = overlay.startScale * scaleFactor

                                                                                            if newScale < minScale {
                                                                                                newScale = minScale
                                                                                            } else if newScale > maxScale {
                                                                                                newScale = maxScale
                                                                                            }

                                                                                            overlay.currentScale = newScale
                                                                                        }
                                                                                        .onEnded { _ in
                                                                                            overlay.startDistance = 0
                                                                                            overlay.startScale = overlay.currentScale
                                                                                            overlay.startAngleToCenter = nil
                                                                                        }
                                                                                )
                                                                        }
                                                                    }
                                                                }
                                                            }
                                                        )
                                                        //move+ rotate + zoom
                                                        .rotationEffect(.degrees(overlay.currentRotation), anchor: .center)
                                                        .offset(x: overlay.offset.width / overlay.currentScale,
                                                                y: overlay.offset.height / overlay.currentScale)
                                                        .scaleEffect(overlay.currentScale)
                                                    }
                                                }
                                            }
                                            .coordinateSpace(name: "canvas")
                                            
                                        }
                                    )
                            }
                            else {
                                // Nếu không có file local → fallback online
                                if let url = frame.backgroundURL {

                                    AsyncImage(url: url) { phase in
                                        switch phase {
                                        case .empty:
                                            // Khi ảnh đang tải
                                            ZStack {
                                                Color.black.opacity(0.05)
                                                ProgressView()
                                            }

                                        case .success(let img):
                                            img
                                                .resizable()
                                                .scaledToFill()
                                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                                .contentShape(Rectangle())
                                                .onAppear {
                                                    DispatchQueue.main.async {
                                                        // Gán ảnh online vào base để các phần filter/overlay có dữ liệu
                                                        if vm.finalImage == nil {
                                                            vm.defaultPreview = nil
                                                            vm.isImageLoaded = false

                                                            // Dùng chính AsyncImage hiển thị sẵn, convert về UIImage
                                                            if let url = frame.backgroundURL,
                                                               let data = try? Data(contentsOf: url),
                                                               let uiImage = UIImage(data: data) {
                                                                vm.baseImage = uiImage
                                                                vm.defaultPreview = uiImage
                                                                vm.finalImage = uiImage   // 🔥 quan trọng
                                                                vm.prepareAllPreviews()
                                                                vm.updatePreview()
                                                                vm.isImageLoaded = true
                                                            }
                                                        }
                                                    }
                                                }
                                                // Filter overlay
                                                .overlay(
                                                    Group {
                                                        if let filtered = filteredImage.wrappedValue {
                                                            Image(uiImage: filtered)
                                                                .resizable()
                                                                .scaledToFill()
                                                                .opacity(project.opacity)
                                                                .brightness(project.lightness)
                                                                .saturation(project.saturation)
                                                                .blur(radius: project.blur)
                                                                .shadow(radius: project.blur)
                                                                .allowsHitTesting(false)
                                                        }
                                                    }
                                                )

                                        case .failure(_):
                                            ZStack {
                                                Color.gray.opacity(0.2)
                                                Text("Không tải được ảnh online")
                                                    .foregroundColor(.gray)
                                                    .font(.footnote)
                                            }

                                        @unknown default:
                                            EmptyView()
                                        }
                                    }
                                } else {
                                    Color.gray.opacity(0.1)
                                        .overlay(Text("Không có frame.backgroundURL"))
                                }
                            }
                        }
                    }
                    .id(frame.id)
                }

                
                else {
                    Color.colHomeBg
                    VStack(spacing: 16){
                        Button(action: onAddTap)
                        {
                            Image("home_add")
                                .frame(width: 50,height: 50)
                        }
                        Text("Tap to add Background")
                            .font(.system(size: 16, weight: .regular, design: .default))
                        
                    }
                }
            }


        }
        .navigationBarBackButtonHidden(true)

    }
    // Hàm tính góc giữa 2 điểm (giúp tính toán góc xoay)
    func angleBetween(start: CGPoint, current: CGPoint) -> Angle {
        let deltaX = current.x - start.x
        let deltaY = current.y - start.y
        let radians = atan2(deltaY, deltaX)
        return Angle(radians: radians)
    }
    



   


    
    


}


