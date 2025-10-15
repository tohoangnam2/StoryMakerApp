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
    @AppStorage("hasShownGetStarted") var hasShownGetStarted: Bool = false
    @State private var showSplash: Bool = true
    @StateObject var vm = BackgroundEditorViewModel()
    @State var isShowPremium: Bool = false

    var body: some Scene {
        WindowGroup {
            ZStack {
                if showSplash {
                    SplashView(isShowPremium: $isShowPremium, hasShownGetStarted: $hasShownGetStarted)
                        .transition(.move(edge: .leading))
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                withAnimation {
                                    self.showSplash = false
                                    self.isShowPremium = true

                                }
                            }
                            
                        }
                    
                } else {
                    if !seenOnboarding {
                        OnboardingView()
                            .transition(.move(edge: .leading))
                            .onDisappear {
                                self.seenOnboarding = true
                                self.hasShownGetStarted = true
                            }
                    } else {
                        HomeView(isShowPremium: $isShowPremium)
                    }
                }
            }
            .environmentObject(vm)
            .fullScreenCover(isPresented: $isShowPremium) {
                SubcriptionView()
                    .environmentObject(vm)
            }

        }
    }
}

