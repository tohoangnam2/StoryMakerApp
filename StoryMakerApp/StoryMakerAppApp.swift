//
//  StoryMakerAppApp.swift
//  StoryMakerApp
//
//  Created by to hoang nam on 19/8/25.
//

import SwiftUI

@main
struct StoryMakerAppApp: App {
    @StateObject var vm = BackgroundEditorViewModel()

    var body: some Scene {
        WindowGroup {
//            ImageFromWebOrDisk(
//                baseURL: "https://picsum.photos/200/300?random=",
//                filename: "preview.jpg"
//            )
            HomeView()
                .environmentObject(vm)
        }
    }
}
