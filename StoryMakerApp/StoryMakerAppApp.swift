//
//  StoryMakerAppApp.swift
//  StoryMakerApp
//
//  Created by to hoang nam on 19/8/25.
//

import SwiftUI

@main
struct StoryMakerAppApp: App {
    @AppStorage("seenOnboarding") var seenOnboarding: Bool = false
    @StateObject var vm = BackgroundEditorViewModel()

    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(vm)
        }
    }
}
