//
//  StoryMakerAppApp.swift
//  StoryMakerApp
//
//  Created by to hoang nam on 19/8/25.
//
import SwiftUI

@main
struct StoryMakerAppApp: App {
    
    // luu trang trang thai same userdefault
    @AppStorage("seenOnboarding") var seenOnboarding: Bool = false
    @AppStorage("hasShownGetStarted") var hasShownGetStarted: Bool = false
    @State private var showSplash: Bool = true
    @State var isShowPremium: Bool = false
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                if showSplash {
                    SplashView(isShowPremium: $isShowPremium, hasShownGetStarted: $hasShownGetStarted)
                        .transition(.move(edge: .leading))
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                withAnimation {
                                    self.showSplash = false
                                    if seenOnboarding {
                                        self.isShowPremium = true
                                    }
                                }
                            }
                        }
                } else {
                    if !seenOnboarding {
                        OnboardingView(isShowPremium: $isShowPremium, seenOnboarding: $seenOnboarding)
                            .transition(.move(edge: .leading))
                            .onDisappear {
                                self.seenOnboarding = true
                                self.hasShownGetStarted = true
                            }
                    } else {
                        HomeView(vm: BackgroundEditorViewModel(), isShowPremium: $isShowPremium)
                    }
                }
            }
            .fullScreenCover(isPresented: $isShowPremium) {
                SubcriptionView()
            }
        }
    }
}

