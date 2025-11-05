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

    var body: some Scene {
        WindowGroup {
            switch screen {
            case .splash:
                SplashView(screen: $screen)
            case .home:
                HomeView()
            }
        }
    }
}
enum ScreenEnum {
    case splash
    case home
}
