//
//  AddProjectView.swift
//  StoryMakerApp
//
//  Created by to hoang nam on 19/8/25.
//

import SwiftUI

struct AddProjectView: View {
    
    @StateObject private var overlayVM = OverlayTextViewModel()
    
    
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedTab: Int? = nil
    @State private var isShowBackgroundPicker = false
    @State private var frame: Frame?
    
    //show bàn phím
    @FocusState private var isTextFieldFocused: Bool
    @State private var showTextField: Bool = false
    
    @State var isSelected : Bool = false
    @State var isEditingText = false
    
    @State var isClick : Bool = false
    
    //bg text
    
    //edit text
    
    @State var selectedEditText : OverlayTextEditEnum = .none
    @State var selectedFontFamily : FontFmailyEnum? = nil
    
    
    @State var showBackgroundEditor : Bool = false
    @State private var editEnum: BackGroundEditEditEnum = .filter

    var body: some View {
        NavigationView {
            ZStack{
                VStack{
                    HStack{
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {Image("home_back")}
                        Spacer()
                        NavigationLink(destination: SplashView()){
                            Image("home_share")
                        }
                    }
                    .padding(.horizontal)
                    Spacer()
                    
                    AddBackgroundsView(overlayVM: overlayVM,
                                       frame: frame,
                                       showTextField: $showTextField,
                                       isTextFieldFocused: $isTextFieldFocused,
                                       isSelected : $isSelected, isEditingText: $isEditingText
                    )
                    {
                        isShowBackgroundPicker = true
                        
                    }
                    onTapOutside: {
                        resetEditState()
                    }
                    onOpenBackgroundEditor: {
                          showBackgroundEditor = true
                      }
                    if  selectedEditText != .none {
                        VStack(spacing: 0) {
                            VStack {
                                HStack {
                                    Button(action: {}) {
                                        Image("img_edit1_keyboard")
                                    }
                                    Spacer()
                                    Text(selectedEditText.title)
                                        .font(.system(size: 16, weight: .medium))
                                    Spacer()
                                    Button(action: {
                                        selectedEditText = .none
                                    }) {
                                        Image("img_bg_check")
                                    }
                                    .background(.white)
                                }
                                .padding(.horizontal)
                                HStack(spacing: 20) {
                                    iconButton("img_edit1_text", .fontSize)
                                    iconButton("img_edit1_size", .fontFamily)
                                    iconButton("img_edit1_color", .colorSolid)
                                    iconButton("img_edit1_gradient", .gradient)
                                    iconButton("img_edit1_stroke", .stroke)
                                    iconButton("img_edit1_align", .align)
                                    iconButton("img_edit1_shadow", .shadow)
                                    iconButton("img_edit1_bg", .background)
                                }
                                .padding(10)
                                .padding(.horizontal, 12)
                                .background(Color.gray.opacity(0.2).cornerRadius(70))

                            }

                            ZStack {
                                switch selectedEditText {
                                case .fontSize:
                                    TextView(overlayVM: overlayVM, selectedEditText: .fontSize)
                                case .fontFamily:
                                    TextView(overlayVM: overlayVM, selectedEditText: .fontFamily)
                                case .colorSolid:
                                    TextView(overlayVM: overlayVM, selectedEditText: .colorSolid)
                                case .gradient:
                                    TextView(overlayVM: overlayVM, selectedEditText: .gradient)
                                case .stroke:
                                    TextView(overlayVM: overlayVM, selectedEditText: .stroke)
                                case .align:
                                    TextView(overlayVM: overlayVM, selectedEditText: .align)
                                case .shadow:
                                    TextView(overlayVM: overlayVM, selectedEditText: .shadow)
                                case .background:
                                    TextView(overlayVM: overlayVM, selectedEditText: .background)
                                case .none:
                                    EmptyView()
                                }
                            }
                            .id(selectedEditText) // giúp SwiftUI animate mượt
                            .transition(.opacity.combined(with: .move(edge: .bottom))) // fade + trượt từ dưới lên
                            .animation(.easeInOut(duration: 0.35), value: selectedEditText)
                        }
                    }
                    else {
                        if !isTextFieldFocused  {
                            if !isSelected {
                                HStack {
                                    Spacer()
                                    Button(action: {
                                        guard frame != nil else { return }
                                        let newOverlay = overlayVM.addOverlay("")
                                        overlayVM.selectOverlay(newOverlay.id)
                                        isTextFieldFocused = true
                                        showTextField = true
                                        isSelected = true
                                    }) {
                                        VStack {
                                            Image("home_tabbartext")
                                            Text("Add Text")
                                        }
                                        .foregroundColor(.black.opacity(0.8))
                                    }
                                    Spacer()
                                    Button(action: { selectedTab = 1; isShowBackgroundPicker = true}) {
                                        VStack {
                                            Image("home_tabbarbg")
                                            Text("Background")
                                        }
                                        .foregroundColor(.black.opacity(0.8))
                                    }
                                    Spacer()
                                }
                                .padding(.top)
                                .background(ignoresSafeAreaEdges: .bottom)
                            } else {
                                ScrollView(.horizontal){
                                    HStack (spacing: 16) {
                                        Spacer()
                                        Button(action: {
                                            selectedEditText = .fontSize
                                        }) {
                                            VStack {
                                                Image("img_edit1_text")
                                                Text("Edit")
                                            }
                                            .foregroundColor(.black.opacity(0.8))
                                        }
                                        Spacer()
                                        Button(action: {
                                            selectedEditText = .fontFamily

                                        }) {
                                            VStack {
                                                Image("img_edit1_size")
                                                Text("Size")
                                            }
                                            .foregroundColor(.black.opacity(0.8))
                                        }
                                        Spacer()
                                        Button(action: {
                                            selectedEditText = .colorSolid

                                        }) {
                                            VStack {
                                                Image("img_edit1_color")
                                                Text("Color")
                                            }
                                            .foregroundColor(.black.opacity(0.8))
                                        }
                                        Spacer()
                                        Button(action: {
                                            selectedEditText = .gradient

                                        }) {
                                            VStack {
                                                Image("img_edit1_gradient")
                                                Text("Gradient")
                                            }
                                            .foregroundColor(.black.opacity(0.8))
                                        }
                                        Spacer()
                                        Button(action: {
                                            selectedEditText = .stroke

                                        }) {
                                            VStack {
                                                Image("img_edit1_stroke")
                                                Text("Stroke")
                                            }
                                            .foregroundColor(.black.opacity(0.8))
                                        }
                                        Spacer()
                                        Button(action: {
                                            selectedEditText = .align

                                        }) {
                                            VStack {
                                                Image("img_edit1_align")
                                                Text("Align")
                                            }
                                            .foregroundColor(.black.opacity(0.8))
                                        }
                                        Spacer()
                                        Button(action: {
                                            selectedEditText = .shadow

                                        }) {
                                            VStack {
                                                Image("img_edit1_shadow")
                                                Text("Shadow")
                                            }
                                            .foregroundColor(.black.opacity(0.8))
                                        }
                                        Spacer()
                                        Button(action: {
                                            selectedEditText = .background

                                        }) {
                                            VStack {
                                                Image("img_edit1_bg")
                                                Text("BackGround")
                                            }
                                            .foregroundColor(.black.opacity(0.8))
                                        }
                                        Spacer()
                                    }
                                    .padding(.top)
                                    .background(ignoresSafeAreaEdges: .bottom)
                                }
                                
                            }
                        }
                        else {
                            HStack {
                                Button(action: {
                                }) {
                                    Image("img_textEdit")
                                        .opacity(0)
                                }
                                Spacer()
                                
                                Text("Text Edit")
                                    .font(.system(size: 16, weight: .medium, design: .default))
                                Spacer()
                                Button(action: {
                                    showTextField = false
                                    isTextFieldFocused = false
                                    isSelected = true
                                    
                                }) {
                                    Image("img_bg_check")
                                }
                                .background(.white)
                            }
                            .padding(.horizontal,20)
                        }
                        
                    }
                }
            }
        }
        .fullScreenCover(isPresented: $isShowBackgroundPicker) {
            BackGroundView { picked in
                self.frame = picked
            }
        }
        .sheet(isPresented: $showBackgroundEditor) {
            if #available(iOS 16.0, *) {
                BackgroundEditorView()
                    .presentationDetents([.height(290)])
            } else {
                // Fallback on earlier versions
            }        }
        
        .onChange(of: frame?.id) { _ in
            if selectedTab == 1 {
                overlayVM.overlays.removeAll()
                overlayVM.addOverlay("")
                showTextField = false
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    //func
    func resetEditState() {
        selectedEditText = .none
        showTextField = false
        isTextFieldFocused = false
        isSelected = false
        overlayVM.deselectAll()
    }
    
    // Helper để tạo nút icon

    @ViewBuilder
    private func iconButton(_ imageName: String, _ type: OverlayTextEditEnum) -> some View {
        Image(imageName)
            .foregroundColor(selectedEditText == type ? .red : .black)
            .onTapGesture {
                selectedEditText = type
            }
    }
}

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
    //    @Binding var overlayText: String
    @FocusState.Binding var isTextFieldFocused: Bool
    
    @State private var isShow = false
    
    @State private var isShowImage = false
    
    //xoay
    var angle: Angle = .zero
    var currentAngle : Angle = Angle(degrees: 0)
    var isRotating: Bool = false
    

    
    //zoom
    @State private var startDistance: CGFloat = 0
    @State private var initialZoom: CGFloat = 1
    @State private var currentZoom: CGFloat = 1   // Zoom cuối cùng
    @State private var displayZoom: CGFloat = 1   // Zoom đang hiển thị khi kéo
    
    //offset
    var offset : CGSize = .zero
    var endset : CGSize = .zero
    
    @Binding var isSelected : Bool
    @Binding var isEditingText : Bool
    
    @State var isShowBGText: Bool = false
    
    @State var isCheck : Bool = false
    
    @State private var currentMode: EditMode = .none
    @State private var rotBase: Double = 0
    @State private var rotInProgress = false
    //new rotate
    @State private var rotation: Angle = .degrees(0)
    @State private var lastAngle: Angle = .degrees(0)
    let onAddTap: () -> Void
    
    let onTapOutside: () -> Void
    
    let onOpenBackgroundEditor: () -> Void


    
    
    
    var body: some View {
        NavigationView {
            ZStack {
                if let frame = frame {
                    AsyncImage(url: frame.backgroundURL) {img in
                        img.resizable()
                            .scaledToFill()
                            .frame(maxWidth: .infinity,maxHeight: .infinity)
                            
//                            .overlay(Color.black.opacity(0.3))
                        //img
                            .onTapGesture {
                                if showTextField == false && isTextFieldFocused == false && isSelected == false{
                                    onOpenBackgroundEditor()
                                } else {
                                    onTapOutside()

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
                                                                 view.foregroundColor(overlay.colorSolid.opacity(overlay.valueOpacity))
                                                             }
                                                    //gradient
                                                             .if(overlay.userGradient) { view in
                                                                 view.foregroundStyle(overlay.colorGradient.opacity(overlay.valueOpacity))
                                                             }
                                                             .padding(overlay.paddingBG)
                                                             .shadow(
                                                                     color: overlay.shawDowColor.opacity(overlay.opacitySD),
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
                                                                                overlay.bgColor
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
                                                                                        .frame(width: 30 / overlay.currentScale, height: 30 / overlay.currentScale)
                                                                                        .padding(10 / overlay.currentScale)
                                                                                        .contentShape(Rectangle())
                                                                                    
                                                                                        .position(x: 0, y: 0)
                                                                                        .onTapGesture {
                                                                                            overlayVM.removeOverlay(overlay.id)
                                                                                        }
                                                                                    
                                                                                    Image("img_edit_copy")
                                                                                        .resizable()
                                                                                        .scaledToFit()
                                                                                        .frame(width: 30 / overlay.currentScale, height: 30 / overlay.currentScale)
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
                                                                                        .frame(width: 30 / overlay.currentScale, height: 30 / overlay.currentScale)
                                                                                        .padding(10 / overlay.currentScale)
                                                                                        .contentShape(Rectangle())
                                                                                        .position(x: 0, y: textGeo.size.height)
                                                                                        .gesture(
                                                                                            DragGesture(minimumDistance: 10, coordinateSpace: .named("canvas"))
                                                                                                .onChanged { value in
                                                                                                    let center = CGPoint(x: textGeo.frame(in: .named("canvas")).midX,
                                                                                                                         y: textGeo.frame(in: .named("canvas")).midY)
                                                                                                    
                                                                                                    if overlay.startLocation == nil {
                                                                                                        let dx = value.startLocation.x - center.x
                                                                                                        let dy = value.startLocation.y - center.y
                                                                                                        overlay.startLocation = CGPoint(x: dx, y: dy)
                                                                                                        overlay.startAngle = overlay.currentRotation
                                                                                                    }
                                                                                                    
                                                                                                    let currentVector = CGVector(dx: value.location.x - center.x,
                                                                                                                                 dy: value.location.y - center.y)
                                                                                                    let startVector = CGVector(dx: overlay.startLocation!.x,
                                                                                                                               dy: overlay.startLocation!.y)
                                                                                                    let angleChange = atan2(currentVector.dy, currentVector.dx) - atan2(startVector.dy, startVector.dx)
                                                                                                    overlay.currentRotation = overlay.startAngle + Angle(radians: Double(angleChange))
                                                                                                }
                                                                                                .onEnded { _ in
                                                                                                    overlay.startLocation = nil
                                                                                                }
                                                                                        )
                                                                                    
                                                                                    Image("img_edit_zoom")
                                                                                        .resizable()
                                                                                        .scaledToFit()
                                                                                        .frame(width: 30 / overlay.currentScale, height: 30 / overlay.currentScale)
                                                                                        .padding(10 / overlay.currentScale)
                                                                                        .contentShape(Rectangle())
                                                                                        .position(x: textGeo.size.width, y: textGeo.size.height)
                                                                                        .gesture(
                                                                                            DragGesture(minimumDistance: 0, coordinateSpace: .named("canvas"))
                                                                                                .onChanged { value in
                                                                                                    if overlay.startDistance == 0 {
                                                                                                        // Dùng size thay vì frame để tránh lỗi khi move
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
                                                            .rotationEffect(overlay.currentRotation, anchor: .center)
                                                            .offset(x: overlay.offset.width / overlay.currentScale,
                                                                y: overlay.offset.height / overlay.currentScale)
                                                            .scaleEffect(overlay.currentScale)
                                                }
                                        }}
                                    .coordinateSpace(name: "canvas")

                                }
                            )
                    } placeholder: {
                        ProgressView()
                    }}
                else {
                    Color.colHomeBg
                    VStack(spacing: 16){
                        Button(action: onAddTap){
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




// MARK: EXTENSION

extension View {
    @ViewBuilder
    func `if`<Content: View>(
        _ condition: Bool,
        transform: (Self) -> Content
    ) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}


//align

extension Text {
    func applyAlign(_ align: AlignEnum) -> some View {
        switch align {
        case .left:
            return self.frame(maxWidth: .infinity, alignment: .leading)
        case .center:
            return self.frame(maxWidth: .infinity, alignment: .center)
        case .right:
            return self.frame(maxWidth: .infinity, alignment: .trailing)
        case .none:
            return self.frame(maxWidth: .infinity, alignment: .center)

        }
    }
    
    func applyCase(_ textCase: AlignCaseEnum) -> Text {
        switch textCase {
        case .up:
            return Text(self.string.uppercased())
        case .cap:
            return Text(self.string.capitalized)
        case .low:
            return Text(self.string.lowercased())
        case .none:
            return Text(self.string.lowercased())

        }
    }
    
    // Helper property để lấy String từ Text
    private var string: String {
        let mirror = Mirror(reflecting: self)
        for child in mirror.children {
            if let storage = child.value as? String {
                return storage
            }
        }
        return ""
    }
}











