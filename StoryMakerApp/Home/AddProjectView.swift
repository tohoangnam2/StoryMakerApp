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
    //    @State private var overlayText: String = ""
    
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
                                HStack {
                                    Spacer()
                                    Button(action: {

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

struct AddBackgroundsView: View {
    
    @ObservedObject var overlayVM: OverlayTextViewModel
    
    let frame: Frame?
    
    @Binding var showTextField: Bool
    //    @Binding var overlayText: String
    @FocusState.Binding var isTextFieldFocused: Bool
    
    @State private var isShow = false
    
    @State private var isShowImage = false
    
    //xoay
    var angle: Angle = Angle(degrees: 0)
    var currentAngle : Angle = Angle(degrees: 0)
    var isRotating: Bool = false
    
    //zoom
    var currentZoom : CGFloat = 0
    var scaleZoom : CGFloat = 0
    var isZoom: Bool = false
    
    //offset
    var offset : CGSize = .zero
    var endset : CGSize = .zero
    
    @Binding var isSelected : Bool
    @Binding var isEditingText : Bool
    
    @State var isShowBGText: Bool = false

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
                                overlayVM.setEditingSelectedOverlay(true)
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
//                                                    overlay.isEditingText = false
                                                }
                                        }

                                        else  {
                                            
                                            Button(action: {
//                                                overlayVM.selectOverlay(overlay.id)
                                                
//                                                isSelected.toggle()
//                                                overlay.isEditingText = true
                                                overlayVM.setEditingSelectedOverlay(false)
                                                if !overlay.isEditingText {
                                                    isSelected = true
//                                                    showTextField = true
                                                    isTextFieldFocused = true
                                                }
                                                print(overlay.id)

                                            }){
                                                Text(overlay.text)
                                                    .font(.system(size: 40, weight: .bold))
                                                    .foregroundColor(.white)
                                                    .shadow(radius: 2)
                                                    .padding()
                                                    .onTapGesture(count: 2, perform: {
                                                        overlayVM.selectOverlay(overlay.id)
                                                        showTextField = true
                                                        isTextFieldFocused = true
                                                    })

                                            }
                                            .background(
                                                Group{
                                                    if !overlay.isEditingText {
                                                        Rectangle()
                                                            .stroke(style: StrokeStyle(lineWidth: 2))
                                                            .foregroundColor(Color.black.opacity(0.6))
                                                    }
                                                }
                                            )
                                            .background(
                                                Group{
                                                    if !overlay.isEditingText {
                                                GeometryReader { textGeo in
                                                    ZStack {
                                                        Image("img_edit_x")
                                                            .position(x: 0, y: 0)
                                                            .onTapGesture {
                                                                overlayVM.removeOverlay(overlay.id)
                                                            }
                                                        
                                                        Image("img_edit_copy")
                                                            .position(x: textGeo.size.width, y: 0)
                                                            if 
                                                            .onTapGesture {
                                                                    overlayVM.copyOverlay(overlay)
                                                                for item in overlayVM.overlays {
                                                                    print(item.id)
                                                                }
                                                            }
                                                        
                                                        Image("img_edit_xoay")
                                                            .position(x: 0, y: textGeo.size.height)
                                                            .onTapGesture {
                                                                overlay.isRotating.toggle()
                                                                print("onXoay")
                                                            }
                                                        Image("img_edit_zoom")
                                                            .position(x: textGeo.size.width, y: textGeo.size.height)
                                                            .onTapGesture {
                                                                overlay.isZoom.toggle()
                                                                print("onZoom")
                                                            }
                                                    }
                                                }
                                                    }
                                                }
                                            )
                                            .fixedSize()
//                                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                                            .offset(overlay.offset)
                                            .gesture(
                                                DragGesture()
                                                    .onChanged { value in
                                                        withAnimation (.easeInOut) {
                                                            overlay.offset = CGSize(
                                                                width: overlay.endset.width + value.translation.width,
                                                                height: overlay.endset.height + value.translation.height
                                                            )
                                                        }

                                                       
                                                    }
                                                    .onEnded({ value in
                                                        withAnimation (.easeInOut) {
                                                            overlay.endset = overlay.offset
                                                        }
                                                    })
                                            )
                                        //text

                                        //xoay -zoom
                                            .rotationEffect(overlay.angle)
                                            .scaleEffect( 1 + overlay.currentZoom )
                                            .gesture(
                                                RotationGesture()
                                                    .onChanged { value in
                                                        withAnimation (.easeInOut) {
                                                            
                                                            overlay.angle = overlay.currentAngle + value
                                                        }
                                                    }
                                                    .onEnded { value in
                                                        withAnimation(.easeInOut) {
                                                            overlay.currentAngle = value
                                                        }
                                                        
                                                    }
                                                
                                                    .simultaneously(with:
                                                                        MagnificationGesture()
                                                        .onChanged {value in
                                                            withAnimation (.easeInOut) {
                                                                
                                                                overlay.currentZoom = 1 - value
                                                            }
                                                            
                                                        }
                                                        .onEnded { value in
                                                            withAnimation(.easeInOut) {
                                                                overlay.scaleZoom += overlay.currentZoom
                                                            }
                                                            
                                                        }
                                                )
                                                
                                            )
                                        
//                                            .frame(width: 100  , height: 100)
//                                            .background(.red
//                                            )
                                            
                                        }
                                    }
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
}

#Preview {
    AddProjectView()
}
