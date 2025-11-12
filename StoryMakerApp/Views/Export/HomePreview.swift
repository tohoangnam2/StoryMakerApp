//
//  HomePreview.swift
//  StoryMakerApp
//
//  Created by Nam To on 17/9/25.
//

import SwiftUI

struct HomePreview: View {
    @ObservedObject var exportingVM: ExportingViewModel
    @Environment(\.dismiss) var dismiss
    
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
    
    @State private var isImageLoaded = false
    @FocusState private var fakeFocus: Bool
    
    //export
    @Binding  var snapshotImage: UIImage?
    @Binding var triggerSnapshot : Bool
    @ObservedObject var vm: BackgroundEditorViewModel
    let filteredImage: UIImage?
    @Binding var project: MainModel?
    
    @Binding var goHome: Bool

    

    var body: some View {
        NavigationView {
            ZStack{
              
                VStack {
                    HStack {
                        Button(action: { dismiss() }) {
                            Image("home_back")
                        }
                        Spacer()
                        Text("Preview")
                            .font(.system(size: 16, weight: .medium))
                        Spacer()
                        Button(action: {
                            goHome = true
                            dismiss()
                        }) {
                            Image(systemName: "house")
                                .foregroundColor(.black)
                        }

                            
                    }
                    .padding(.horizontal,10)
                    //main view
                    if let project = project {
                        let folderURL = ProjectStorage.projectFolder(for: project.id)
                        let previewURL = folderURL.appendingPathComponent("project_\(project.id).jpg")

                        if let uiImage = UIImage(contentsOfFile: previewURL.path) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFit()
                                .clipped()
                                .padding(.horizontal, 20)
                                .scaleEffect(exportingVM.isDone ? 0.95 : 1.0, anchor: .center)
                                .animation(.easeInOut(duration: 0.3), value: exportingVM.isDone)
                        }
                    }
                    
                    //view share
                    if exportingVM.isDone {
                        VStack{
                            Text("Photo saved to gallery")
                                .font(.system(size: 16, weight: .medium))
                            Text("Share photo to")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.gray)
                        }
                        HStack (spacing: 20){
                            //story
                            VStack{
                                Button(action: {
                                    shareToStory()
                                })
                                {
                                    ZStack {
                                        Rectangle()
                                            .fill(Color.preBg)
                                            .frame(width:50,height: 50)
                                            .cornerRadius(10)
                                        Image("pre_story")
                                    }
                                }
                                
                                Text("Story")
                                    .font(.system(size: 12, weight: .medium))
                            }
                            //feed
                            VStack{
                                Button(action: {
                                    shareToReels()
                                })
                                {
                                    ZStack {
                                        Rectangle()
                                            .fill(Color.preBg)
                                            .frame(width:50,height: 50)
                                            .cornerRadius(10)
                                        Image("pre_feed")
                                    }
                                }
                                Text("Feed")
                                    .font(.system(size: 12, weight: .medium))
                            }
                            
                            // Others
                            VStack {
                                ShareLink(
                                    item: Image(uiImage: snapshotImage!),
                                    preview: SharePreview("My Photo", image: Image(uiImage: snapshotImage!))
                                ) {
                                    ZStack {
                                        Rectangle()
                                            .fill(Color.preBg)
                                            .frame(width: 50, height: 50)
                                            .cornerRadius(10)
                                        Image("pre_none")
                                    }
                                }
                                Text("Others")
                                    .font(.system(size: 12, weight: .medium))
                            }
                        }
                        .padding(.horizontal,55)
                    }
                    //view export
                    else {
                        ZStack {
                            RoundedRectangle(cornerRadius: 60)
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color.bgSplash2, Color.bgSplash1]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(height: 50)

                            Button(action: {
                                triggerSnapshot = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    if let image = snapshotImage {
                                        // Nếu chưa có project thì tạo mới
                                        var currentProject = project ?? MainModel(id: UUID())
                                        currentProject.previewImage = image
                                        exportingVM.startExporting(projectID: currentProject.id, image: image)
                                        
                                    } else {
                                        print(" Snapshot chưa kịp tạo")
                                    }
                                }
                            }) {
                                HStack {
                                    Text("Export Photo")
                                        .foregroundColor(.white)
                                    Image("ic_right")
                                }
                            }
                        }
                        .padding(.horizontal, 80)
                    }
                }
            }
            .fullScreenCover(isPresented: $exportingVM.isExporting) {
                ExportingView(exportingVM: exportingVM)
            }
        }
       
    }
    func shareToStory() {
        
        guard let instagramURL = URL(string: "instagram-stories://share?source_application=a.StoryMakerApp"),
                     UIApplication.shared.canOpenURL(instagramURL) else {
                   return
               }
               guard
                let imageData = snapshotImage!.pngData() else {
                   return
               }
               let pasteboardItems: [String: Any] = [
                   "com.instagram.sharedSticker.backgroundImage": imageData
               ]
               let pasteboardOptions: [UIPasteboard.OptionsKey: Any] = [
                   .expirationDate: Date().addingTimeInterval(60)
               ]
        
               UIPasteboard.general.setItems([pasteboardItems], options: pasteboardOptions)
               UIApplication.shared.open(instagramURL, options: [:], completionHandler: nil)
    }
    
    func shareToReels() {
        if let urlScheme = URL(string: "instagram-reels://share?source_application=a.StoryMakerApp"), UIApplication.shared.canOpenURL(urlScheme) {
            guard
                let imageData = snapshotImage!.pngData() else {
                return
            }
            
            let pasteboardItems: [String: Any] = [
                "com.instagram.sharedSticker.backgroundImage": imageData
            ]
                   
               // Set pasteboard options
            let pasteboardOptions: [UIPasteboard.OptionsKey: Any] = [
                .expirationDate: Date().addingTimeInterval(60)
            ]
               // Attach the pasteboard items
               UIPasteboard.general.setItems([pasteboardItems], options: pasteboardOptions)

            UIApplication.shared.open(urlScheme, options: [:], completionHandler: nil)

           } else {
               // Handle error cases
           }
        }
}



