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
    
    //bg text
    
    //edit text
    
    @State var selectedEditText : OverlayTextEditEnum? = nil
    
    
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
                    
                    if let editType = selectedEditText {
                        VStack(spacing: 0) {
                            switch editType {
                            case .fontSize:
                                VStack{
                                    HStack {
                                        Button(action: {}) {
                                            Image("img_edit1_keyboard")
                                        }
                                        Spacer()
                                        Text(editType.title)
                                            .font(.system(size: 16, weight: .medium))
                                        Spacer()
                                        Button(action: {
                                            selectedEditText = nil
                                        }) {
                                            Image("img_bg_check")
                                        }
                                        .background(.white)
                                    }
                                    .padding(.horizontal)
                                    HStack (spacing: 20) {
                                        Button(action: {
                                            selectedEditText = .fontSize
                                        }) {
                                            Image("img_edit1_text")
                                        }
                                        Button(action: {
                                            selectedEditText = .fontFamily
                                        }) {
                                            Image("img_edit1_size")
                                        }
                                        Button(action: {
                                            selectedEditText = .colorSolid
                                            
                                        }) {
                                            Image("img_edit1_color")
                                        }
                                        
                                        Button(action: {
                                            selectedEditText = .gradient
                                        }) {
                                            Image("img_edit1_gradient")
                                        }
                                        Button(action: {
                                            selectedEditText = .stroke
                                        }) {
                                            Image("img_edit1_stroke")
                                        }
                                        Button(action: {
                                            selectedEditText = .align
                                        }) {
                                            Image("img_edit1_align")
                                        }
                                        Button(action: {
                                            selectedEditText = .shadow
                                        }) {
                                            Image("img_edit1_shadow")
                                        }
                                        Button(action: {
                                            selectedEditText = .background
                                        }) {
                                            Image("img_edit1_bg")
                                        }
                                    }
                                    .padding(10)
                                    .padding(.horizontal,12)
                                    .background(Color.gray.opacity(0.2).cornerRadius(70))
                                }
                                
                                
                            case .fontFamily:
                                HStack {
                                    Button(action: {}) {
                                        Image("img_edit1_keyboard")
                                    }
                                    Spacer()
                                    Text(editType.title)
                                        .font(.system(size: 16, weight: .medium))
                                    Spacer()
                                    Button(action: {
                                        selectedEditText = nil
                                    }) {
                                        Image("img_bg_check")
                                    }
                                    .background(.white)
                                }
                                .padding(.horizontal, 20)
                                Image(editType.img)
                                
                            case .colorSolid:
                                HStack {
                                    Button(action: {}) {
                                        Image("img_edit1_keyboard")
                                    }
                                    Spacer()
                                    Text(editType.title)
                                        .font(.system(size: 16, weight: .medium))
                                    Spacer()
                                    Button(action: {
                                        selectedEditText = nil
                                    }) {
                                        Image("img_bg_check")
                                    }
                                    .background(.white)
                                }
                                .padding(.horizontal, 20)
                                Image(editType.img)
                                
                            case .gradient:
                                HStack {
                                    Button(action: {}) {
                                        Image("img_edit1_keyboard")
                                    }
                                    Spacer()
                                    Text(editType.title)
                                        .font(.system(size: 16, weight: .medium))
                                    Spacer()
                                    Button(action: {
                                        selectedEditText = nil
                                    }) {
                                        Image("img_bg_check")
                                    }
                                    .background(.white)
                                }
                                .padding(.horizontal, 20)
                                Image(editType.img)
                                
                            case .stroke:
                                HStack {
                                    Button(action: {}) {
                                        Image("img_edit1_keyboard")
                                    }
                                    Spacer()
                                    Text(editType.title)
                                        .font(.system(size: 16, weight: .medium))
                                    Spacer()
                                    Button(action: {
                                        selectedEditText = nil
                                    }) {
                                        Image("img_bg_check")
                                    }
                                    .background(.white)
                                }
                                .padding(.horizontal, 20)
                                Image(editType.img)
                                
                            case .align:
                                HStack {
                                    Button(action: {}) {
                                        Image("img_edit1_keyboard")
                                    }
                                    Spacer()
                                    Text(editType.title)
                                        .font(.system(size: 16, weight: .medium))
                                    Spacer()
                                    Button(action: {
                                        selectedEditText = nil
                                    }) {
                                        Image("img_bg_check")
                                    }
                                    .background(.white)
                                }
                                .padding(.horizontal, 20)
                                Image(editType.img)
                                
                            case .background:
                                HStack {
                                    Button(action: {}) {
                                        Image("img_edit1_keyboard")
                                    }
                                    Spacer()
                                    Text(editType.title)
                                        .font(.system(size: 16, weight: .medium))
                                    Spacer()
                                    Button(action: {
                                        selectedEditText = nil
                                    }) {
                                        Image("img_bg_check")
                                    }
                                    .background(.white)
                                }
                                .padding(.horizontal, 20)
                                Image(editType.img)
                                
                            case .shadow:
                                HStack {
                                    Button(action: {}) {
                                        Image("img_edit1_keyboard")
                                    }
                                    Spacer()
                                    Text(editType.title)
                                        .font(.system(size: 16, weight: .medium))
                                    Spacer()
                                    Button(action: {
                                        selectedEditText = nil
                                    }) {
                                        Image("img_bg_check")
                                    }
                                    .background(.white)
                                }
                                .padding(.horizontal, 20)
                                Image(editType.img)
                                
                            }
                            
                            
                            switch editType {
                            case .fontSize:
                                TextView(selectedEditText: .fontSize)
                                    .transition(.move(edge: .bottom))
                            case .fontFamily:
                                TextView(selectedEditText: .fontFamily)
                                    .transition(.move(edge: .bottom))
                                
                            case .colorSolid:
                                TextView(selectedEditText: .colorSolid)
                                    .transition(.move(edge: .bottom))
                                
                            case .gradient:
                                TextView(selectedEditText: .gradient)
                                    .transition(.move(edge: .bottom))
                                
                            case .stroke:
                                TextView(selectedEditText: .stroke)
                                    .transition(.move(edge: .bottom))
                                
                            case .align:
                                TextView(selectedEditText: .align)
                                    .transition(.move(edge: .bottom))
                                
                            case .background:
                                TextView(selectedEditText: .background)
                                    .transition(.move(edge: .bottom))
                                
                            case .shadow:
                                TextView(selectedEditText: .shadow)
                                    .transition(.move(edge: .bottom))
                                
                            case nil:
                                ProgressView()
                                
                            }
                        }
                    }
                    else {
                        
                        
                        if !isTextFieldFocused  {
                            if !isSelected {
                                HStack {
                                    Spacer()
                                    Button(action: {
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
                                            
                                        }) {
                                            VStack {
                                                Image("img_edit1_size")
                                                Text("Size")
                                            }
                                            .foregroundColor(.black.opacity(0.8))
                                        }
                                        Spacer()
                                        Button(action: {
                                            
                                        }) {
                                            VStack {
                                                Image("img_edit1_color")
                                                Text("Color")
                                            }
                                            .foregroundColor(.black.opacity(0.8))
                                        }
                                        Spacer()
                                        Button(action: {
                                            
                                        }) {
                                            VStack {
                                                Image("img_edit1_gradient")
                                                Text("Gradient")
                                            }
                                            .foregroundColor(.black.opacity(0.8))
                                        }
                                        Spacer()
                                        Button(action: {
                                            
                                        }) {
                                            VStack {
                                                Image("img_edit1_stroke")
                                                Text("Stroke")
                                            }
                                            .foregroundColor(.black.opacity(0.8))
                                        }
                                        Spacer()
                                        Button(action: {
                                            
                                        }) {
                                            VStack {
                                                Image("img_edit1_text")
                                                Text("Size")
                                            }
                                            .foregroundColor(.black.opacity(0.8))
                                        }
                                        Spacer()
                                        Button(action: {
                                            
                                        }) {
                                            VStack {
                                                Image("img_edit1_text")
                                                Text("Size")
                                            }
                                            .foregroundColor(.black.opacity(0.8))
                                        }
                                        Spacer()
                                        Button(action: {
                                            
                                        }) {
                                            VStack {
                                                Image("img_edit1_text")
                                                Text("Size")
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
        .onChange(of: frame?.id) { _ in
            if selectedTab == 1 {
                overlayVM.overlays.removeAll()
                overlayVM.addOverlay("")
                showTextField = false
            }
        }
        .navigationBarBackButtonHidden(true)
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
    
    
    var body: some View {
        NavigationView {
            ZStack {
                if let frame = frame {
                    AsyncImage(url: frame.backgroundURL) {img in
                        img.resizable()
                            .scaledToFill()
                            .frame(maxWidth: .infinity,maxHeight: .infinity)
                        
                        //img
                            .onTapGesture {
                                showTextField = false
                                overlayVM.setEditingSelectedOverlay(false)
                                overlayVM.deselectAll()
                                if !isEditingText {
                                    isSelected = false
                                    
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
                                        
                                        else  {
                                                ZStack{
                                                    Button(action: {}) {
                                                        Text(overlay.text)
                                                            .font(.system(size: 22, weight: .bold))
                                                            .foregroundColor(.white)
                                                            .shadow(radius: 2)
                                                            .padding(.horizontal)
//                                                            .position(
//                                                                x: overlay.iconCenter.x + overlay.radius * cos(overlay.angle),
//                                                                y: overlay.iconCenter.y + overlay.radius * sin(overlay.angle)
//                                                            )
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
                                                                        if currentMode == .none {
                                                                            currentMode = .moving
                                                                        }
                                                                        if currentMode == .moving {
                                                                            overlay.offset = CGSize(
                                                                                width: overlay.endset.width + value.translation.width,
                                                                                height: overlay.endset.height + value.translation.height
                                                                            )
                                                                        }
                                                                    }
                                                                    .onEnded { _ in
                                                                        if currentMode == .moving {
                                                                            overlay.endset = overlay.offset
                                                                        }
                                                                        currentMode = .none
                                                                    }
                                                            )
                                                    }
                                                    .padding()
                                                    .overlay {
                                                        if !overlay.isEditingText {
                                                            GeometryReader {textGeo in
                                                                ZStack {
                                                                    Rectangle()
                                                                        .stroke(style: StrokeStyle(lineWidth: 2))
                                                                        .foregroundColor(Color.black.opacity(0.6))
                                                                    Image("img_edit_x")
                                                                        .padding(10)
                                                                    
                                                                        .position(x: 0, y: 0)
                                                                        .onTapGesture {
                                                                            overlayVM.removeOverlay(overlay.id)
                                                                        }
                                                                    
                                                                    Image("img_edit_copy")
                                                                        .padding(10)
                                                                        .position(x: textGeo.size.width, y: 0)
                                                                        .onTapGesture {
                                                                            overlayVM.selectOverlay(overlay.id)
                                                                            overlayVM.copyOverlay(overlay)
                                                                            for item in overlayVM.overlays {
                                                                                print(item.id)
                                                                            }
                                                                        }
                                                                    
                                                                    // Icon xoay
                                                                    Image("img_edit_xoay")
                                                                        .frame(width: 30, height: 30)
                                                                        .padding(30)
                                                                        .contentShape(Rectangle())
                                                                        .position(x: 0, y: textGeo.size.height) // góc dưới trái
                                                                    
                                                                    
                                                                    
                                                                    
                                                                    Image("img_edit_zoom")
                                                                        .padding(10)
                                                                        .position(x: textGeo.size.width, y: textGeo.size.height)
                                                                        .gesture(
                                                                            DragGesture()
                                                                                .onChanged { value in
                                                                                    // Tính tâm theo global coordinate để không bị ảnh hưởng scale
                                                                                    let center = CGPoint(
                                                                                        x: textGeo.frame(in: .global).midX,
                                                                                        y: textGeo.frame(in: .global).midY
                                                                                    )
                                                                                    
                                                                                    if overlay.startDistance == 0 {
                                                                                        overlay.startDistance = hypot(
                                                                                            value.startLocation.x - center.x,
                                                                                            value.startLocation.y - center.y
                                                                                        )
                                                                                        overlay.initialZoom = overlay.currentZoom
                                                                                    }
                                                                                    
                                                                                    let currentDistance = hypot(
                                                                                        value.location.x - center.x,
                                                                                        value.location.y - center.y
                                                                                    )
                                                                                    
                                                                                    // Tỉ lệ zoom giới hạn 0.2x - 5x
                                                                                    let scaleRatio = max(0.2, min(overlay.startDistance / currentDistance, 5))
                                                                                    
                                                                                    // Cập nhật zoom hiển thị tạm
                                                                                    overlay.displayZoom = overlay.initialZoom * scaleRatio
                                                                                }
                                                                                .onEnded { _ in
                                                                                    withAnimation(.spring(response: 0.25, dampingFraction: 0.85)) {
                                                                                        overlay.currentZoom = overlay.displayZoom
                                                                                    }
                                                                                    overlay.startDistance = 0
                                                                                }
                                                                        )
                                                                }
                                                                
                                                            }
                                                        }
                                                    }
                                                    .offset(overlay.offset)
                                                    .scaleEffect(overlay.displayZoom)
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
