//
//  HomePreview.swift
//  StoryMakerApp
//
//  Created by Nam To on 17/9/25.
//

import SwiftUI
import Photos

struct HomePreview: View {
    
    //export
    @ObservedObject var exportingVM: ExportingViewModel
    @Environment(\.dismiss) var dismiss
    @Binding  var snapshotImage: UIImage?
    @Binding var project: MainModel?
    @Binding var goHome: Bool
    @EnvironmentObject var language: LanguageManager
    @State private var showPermissionAlert = false
    @State private var showSettingsAlert = false
    @State private var message = ""

    var body: some View {
        NavigationView {
            ZStack{
                VStack {
                    HStack {
                        Button(action: { dismiss() }) {
                            Image("home_back")
                        }
                        Spacer()
                        Text(language.localized("Preview", "Xem trước"))
                            .font(.system(size: 16, weight: .medium))
                            .opacity(0)
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
                    if let snapshot = snapshotImage {
                        Image(uiImage: snapshot)
                            .resizable()
                            .scaledToFit()
                            .clipped()
                            .padding(.horizontal, 20)
                            .scaleEffect(0.95 , anchor: .center)
                            .animation(.easeInOut(duration: 0.3), value: exportingVM.isDone)
                    } else if let project = project {
                        let folderURL = ProjectStorage.projectFolder(for: project.id)
                        let previewURL = folderURL.appendingPathComponent("project_\(project.id).jpg")

                        if let uiImage = UIImage(contentsOfFile: previewURL.path) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFit()
                                .clipped()
                                .padding(.horizontal, 20)
                                .scaleEffect(0.95 , anchor: .center)
                                .animation(.easeInOut(duration: 0.3), value: exportingVM.isDone)
                        }
                    }
                    
                    //view share
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
                                    downloadImage()
                                })
                                {
                                    ZStack {
                                        Rectangle()
                                            .fill(Color.preBg)
                                            .frame(width:50,height: 50)
                                            .cornerRadius(10)
                                        Image(systemName: "square.and.arrow.down")
                                            .foregroundColor(.black)
                                    }
                                }
                                
                                Text("DownLoad")
                                    .font(.system(size: 12, weight: .medium))
                            }
                            .alert("Permission Needed", isPresented: $showPermissionAlert) {
                                Button("OK", role: .cancel) { }
                            } message: {
                                Text(message)
                            }

                            .alert("Photo Access Denied", isPresented: $showSettingsAlert) {
                                Button("Open Settings") {
                                    if let url = URL(string: UIApplication.openSettingsURLString) {
                                        UIApplication.shared.open(url)
                                    }
                                }
                                Button("Cancel", role: .cancel) { }
                            } message: {
                                Text("Please enable photo access in Settings to save pictures.")
                            }
                            
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
            }

        }
       
    }
    
    func downloadImage() {
        guard let img = snapshotImage else { return }

        exportingVM.saveToPhotosOnly(
            img,
            onDenied: {
                showSettingsAlert = true
            },
            onSaved: {
                message = "Saved to your Photos!"
                showPermissionAlert = true
            }
        )
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



