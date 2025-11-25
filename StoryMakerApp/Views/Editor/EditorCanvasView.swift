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

struct EditorCanvasView: View {
    
    @ObservedObject var overlayVM: OverlayTextViewModel
    let frame: Frame?
    @FocusState.Binding var isTextFieldFocused: Bool
    @Binding var isEditingText : Bool
    let onAddTap: () -> Void
    let onTapOutside: () -> Void
    let onOpenBackgroundEditor: () -> Void
    @Binding var isShowBackgroundPicker: Bool
    @ObservedObject var vm: BackgroundEditorViewModel
    @State private var isImageLoaded = false
    @Binding var project : MainModel?
    @Binding var isCreateText: Bool
    @Binding var panel : EditorPanelEnum
    @Binding var editingText : String

    var body: some View {
        NavigationView {
            ZStack {
                if let project = project {
                    // Luôn ưu tiên đọc ảnh gốc từ project 
                    // dùng chung cho cả background từ API lẫn ảnh từ Photos
                    let folderURL = ProjectStorage.projectFolder(for: project.id)
                    let localImageURL = folderURL.appendingPathComponent("original.jpg")
                    
                    if FileManager.default.fileExists(atPath: localImageURL.path),
                       let uiImage = UIImage(contentsOfFile: localImageURL.path) {
                        
                            backgroundView(uiImage: uiImage, projectID: project.id)
                        
                    } else {
                        emptyBackgroundView()
                    }
                }
                else{
                    emptyBackgroundView()
                }
            }
        }
        .onChange(of: panel) { newValue in
            withAnimation {
                if case .keyboard(let text, let isNew) = panel {
                    isTextFieldFocused = true
                }
                else{
                    isTextFieldFocused = false
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    @ViewBuilder
    private func emptyBackgroundView() -> some View {
        Color.colHomeBg
        VStack(spacing: 16) {
            Button(action: onAddTap) {
                Image("home_add")
                    .frame(width: 50, height: 50)
            }
            Text("Tap to add Background")
                .font(.system(size: 16, weight: .regular))
        }
    }

    // View dựng background + filter + overlay text
    @ViewBuilder
    private func backgroundView(uiImage: UIImage, projectID: UUID) -> some View {
        //chọn filter
        let display = vm.filteredImage ?? uiImage
                Image(uiImage: display)
                    .resizable()
                    .scaledToFill()
                    .contentShape(Rectangle())
                    .id(projectID)
                    .overlay(Color.black.opacity(1 - vm.opacity))
                    .brightness(vm.lightness)
                    .saturation(vm.saturation)
                    .blur(radius: vm.blur)
                    // Tap vào background để mở editor hoặc tắt selection
                    .onTapGesture {
                        if overlayVM.selectedOverlayID != nil {
                            onTapOutside()
                        }else{
                            onOpenBackgroundEditor()
                        }
                    }
                    // Lớp text overlay
                    .overlay(
                        Group {
                            switch panel {
                            case .keyboard(let text, let isNew):
                                TextField("Nhập chữ...", text: $editingText)
                                    .padding(8)
                                    .background(Color.white.opacity(0.8))
                                    .cornerRadius(8)
                                    .padding(.horizontal,UIScreen.main.bounds.width/3)
                                    .focused($isTextFieldFocused)
                                    .onSubmit {
                                       panel = .default1
                                    }
                                    .animation(.easeInOut(duration: 0.18), value: panel)

                             default:
                                EmptyView()
                            }
                            
                            ForEach($overlayVM.overlays){ $overlay in
                                if overlayVM.editingOverlayID == overlay.id { EmptyView() }
                                else{
                                    if !overlay.text.isEmpty  {
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
                                                view.foregroundColor(Color(hex: overlay.colorSolid)?.opacity(overlay.valueOpacity) ?? .black)
                                            }
                                            //gradient
                                            .if(overlay.userGradient) { view in
                                                view.foregroundStyle(overlay.gradient)
                                                    .opacity(overlay.valueOpacity)
                                            }
                                            .padding(overlay.paddingBG)
                                            .animation(nil, value: overlay.paddingBG)
                                            .shadow(
                                                color:Color(hex: overlay.shawDowColor)?.opacity(overlay.opacitySD) ?? .black,
                                                //độ mở
                                                radius: overlay.blurSD,
                                                x: overlay.offSetXSD,
                                                y: overlay.offSetYSD
                                            )
                                            .padding(.horizontal)
                                            .gesture(
                                                DragGesture(minimumDistance: 0,coordinateSpace: .named("canvas"))
                                                    .onChanged { value in
                                                        //vị trí cuối + dịch chuyển ngón tay =giá trị thực
                                                        overlay.offset = CGSize(
                                                            width: overlay.endset.width + value.translation.width,
                                                            height: overlay.endset.height + value.translation.height
                                                        )
                                                    }
                                                
                                                    .onEnded { _ in
                                                        overlay.endset = overlay.offset
                                                    }
                                            )
                                            .simultaneousGesture(
                                                TapGesture(count: 2)
                                                    .onEnded {
                                                        overlayVM.selectOverlay(overlay.id)
                                                        overlayVM.editingOverlayID = overlay.id
                                                        panel = .keyboard(text: overlay.text, isNew: false)
                                                        editingText = overlay.text
                                                        isTextFieldFocused = true
                                                        
                                                    }
                                            )
                                            .simultaneousGesture(
                                                TapGesture()
                                                    .onEnded {
                                                        overlayVM.selectOverlay(overlay.id)
                                                        panel = .textToolBar
                                                        isTextFieldFocused = false
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
                                                            
                                                            if overlayVM.selectedOverlayID == overlay.id {
                                                                
                                                                Rectangle()
                                                                    .stroke(style: StrokeStyle(lineWidth: 2 / overlay.currentScale))
                                                                    .foregroundColor(Color.black.opacity(0.6))
                                                                Image("img_edit_x")
                                                                    .resizable()
                                                                    .scaledToFit()
                                                                    .frame(width:30 , height:30)
                                                                    .padding(10 / overlay.currentScale)
                                                                    .contentShape(Rectangle())
                                                                    .position(x: 0, y: 0)
                                                                    .onTapGesture {
                                                                        overlayVM.removeOverlay(overlay.id)
                                                                    }
                                                                
                                                                Image("img_edit_copy")
                                                                    .resizable()
                                                                    .scaledToFit()
                                                                    .frame(width:30 , height:30)
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
                                                                    .frame(width:30 , height:30)
                                                                    .padding(10 / overlay.currentScale)
                                                                    .contentShape(Rectangle())
                                                                    .position(x: 0, y: textGeo.size.height)
                                                                    .gesture(
                                                                        DragGesture(minimumDistance: 10, coordinateSpace: .named("canvas"))
                                                                            .onChanged { value in
                                                                                //tâm
                                                                                let center = CGPoint(
                                                                                    x: textGeo.frame(in: .named("canvas")).midX,
                                                                                    y: textGeo.frame(in: .named("canvas")).midY
                                                                                )
                                                                                // vị trí chạm ban đầu , lưu góc xoay
                                                                                if overlay.startLocation == nil {
                                                                                    let dx = value.startLocation.x - center.x
                                                                                    let dy = value.startLocation.y - center.y
                                                                                    overlay.startLocation = CGPoint(x: dx, y: dy)
                                                                                    overlay.startAngle = overlay.currentRotation   // Double
                                                                                }
                                                                                //move thì tạo 2 vector : hướng từ tâm đến vị trí move của ngón tay
                                                                                let currentVector = CGVector(
                                                                                    dx: value.location.x - center.x,
                                                                                    dy: value.location.y - center.y
                                                                                )
                                                                                // từ tâm đến vị trí ban đầu
                                                                                let startVector = CGVector(
                                                                                    dx: overlay.startLocation!.x,
                                                                                    dy: overlay.startLocation!.y
                                                                                )
                                                                                //hiệu 2 góc là sự thay đổi góc giữa hiện tại và ban đầu, phép trừ là để xác định chiều xoay
                                                                                let angleChange = atan2(currentVector.dy, currentVector.dx)
                                                                                - atan2(startVector.dy, startVector.dx)
                                                                                
                                                                                let angleInDegrees = CGFloat(angleChange) * 180 / .pi
                                                                                //cộng với góc ban đầu ra vị trí hiện tại
                                                                                overlay.currentRotation = overlay.startAngle + angleInDegrees
                                                                            }
                                                                            .onEnded { _ in
                                                                                //rs dểd xoay lại
                                                                                overlay.startLocation = nil
                                                                            }
                                                                    )
                                                                
                                                                Image("img_edit_zoom")
                                                                    .resizable()
                                                                    .scaledToFit()
                                                                    .frame(width:30 , height:30)
                                                                    .padding(10 / overlay.currentScale)
                                                                    .contentShape(Rectangle())
                                                                    .position(x: textGeo.size.width, y: textGeo.size.height)
                                                                    .gesture(
                                                                        DragGesture(minimumDistance: 0, coordinateSpace: .named("canvas"))
                                                                            .onChanged { value in
                                                                                //chỉ kéo 1 lần ở drag
                                                                                if overlay.startDistance == 0 {
                                                                                    //frame = gốc
                                                                                    let frameSize = textGeo.size
                                                                                    //tâm khung text cộng với vị trí cuối cùng tính khi move
                                                                                    overlay.startCenter = CGPoint(
                                                                                        x: (frameSize.width / 2) + overlay.endset.width,
                                                                                        y: (frameSize.height / 2) + overlay.endset.height
                                                                                    )
                                                                                    //khoảng cách ban đầu từ tâm đến chỗ chạm , còn là bán kính ban đầu làm mốc scale
                                                                                    overlay.startDistance = hypot(
                                                                                        value.location.x - overlay.startCenter.x,
                                                                                        value.location.y - overlay.startCenter.y
                                                                                    )
                                                                                    //scale ban đầu
                                                                                    overlay.startScale = overlay.currentScale
                                                                                    //atan2 cho góc radian từ tâm đến vị trí kéo -> check xem hướng nào phóng to hay thu nhỏ
                                                                                    overlay.startAngleToCenter = atan2(
                                                                                        value.location.y - overlay.startCenter.y,
                                                                                        value.location.x - overlay.startCenter.x
                                                                                    )
                                                                                }
                                                                                // tính góc hiện tại giữa tâm và vị trí kéo
                                                                                let currentAngle = atan2(
                                                                                    value.location.y - overlay.startCenter.y,
                                                                                    value.location.x - overlay.startCenter.x
                                                                                )
                                                                                //
                                                                                if let startAngle = overlay.startAngleToCenter {
                                                                                    //chênh lệch góc hiện tại và góc ban đầu -> đưa chênh lệch -2pi .. 2pi tránh bị xoay vòng
                                                                                    let angleDiff = abs((currentAngle - startAngle).truncatingRemainder(dividingBy: .pi * 2))
                                                                                    //phải kéo theo hướng từ tâm ra các góc -> ko thì return
                                                                                    if angleDiff > (.pi / 4) { // ±45°
                                                                                        return
                                                                                    }
                                                                                }
                                                                                //khoảng cách từ tâm đến vị trí kéo
                                                                                let currentDistance = hypot(
                                                                                    value.location.x - overlay.startCenter.x,
                                                                                    value.location.y - overlay.startCenter.y
                                                                                )
                                                                                //kéo xa>1 phong to ngược lại nhỏ
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
                                            
                                        }
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
}

