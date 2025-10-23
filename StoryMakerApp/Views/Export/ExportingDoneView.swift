//
//  ExportingDoneView.swift
//  StoryMakerApp
//
//  Created by Nam To on 19/9/25.
//

import SwiftUI

import AVFoundation



struct ExportingDoneView: View {
    //    let snapshotImage: UIImage
    @ObservedObject var exportingVM: ExportingViewModel
    @Environment(\.dismiss) var dismiss
    
    
    @ObservedObject var overlayVM: OverlayTextViewModel
    
    
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
    
    
    //export
    @Binding var triggerSnapshot : Bool
    
    @ObservedObject var vm: BackgroundEditorViewModel
    
    let filteredImage: UIImage?
    
    //others share
    
    @State private var showShareSheet = false
    @State private var shareItems: [Any] = []
    
    let snapshotImage: UIImage
    
    
    
    var body: some View {
        VStack(spacing: 10){
            HStack {
                Button(action: { dismiss() }) {
                    Image("home_back")
                }
                Spacer()
                Text("Preview")
                    .font(.system(size: 16, weight: .medium))
                    .opacity(0)
                Spacer()
                Image("home_back").opacity(0)
            }
            .padding()
            
            Image(uiImage: snapshotImage)
                .resizable()
                .scaledToFill()
                .frame(width: UIScreen.main.bounds.width - 80, height: 560)
                .clipped()
                .padding(.horizontal,20)
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
                                .fill(
                                    Color.preBg
                                )
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
                                    .fill(
                                        Color.preBg
                                    )
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
                        item: Image(uiImage: snapshotImage),
                        preview: SharePreview("My Photo", image: Image(uiImage: snapshotImage))
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
            .padding(.bottom,20)
            
        }
    }
    func shareToStory() {
        
        guard let instagramURL = URL(string: "instagram-stories://share?source_application=a.StoryMakerApp"),
                     UIApplication.shared.canOpenURL(instagramURL) else {
                   return
               }
               
               guard
                     let imageData = snapshotImage.pngData() else {
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
                  let imageData = snapshotImage.pngData() else {
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





