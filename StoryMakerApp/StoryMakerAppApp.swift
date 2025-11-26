//
//  StoryMakerAppApp.swift
//  StoryMakerApp
//
//  Created by to hoang nam on 19/8/25.
//
import SwiftUI

@main
struct StoryMakerAppApp: App {
    @State var screen : ScreenEnum = .splash
    @ObservedObject var appUsage = AppUsage.shared
    
    @StateObject var language = LanguageManager.shared

    var body: some Scene {
        WindowGroup {
            Group {
                switch screen {
                case .splash:
                    SplashView(screen: $screen)
                case .home:
                    HomeView()
                }
            }
            .environmentObject(language)
            .preferredColorScheme(appUsage.isDarkMode ? .dark : .light)
        }
    }
}

enum ScreenEnum {
    case splash
    case home
}
