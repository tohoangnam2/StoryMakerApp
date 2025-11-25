//
//  SplashView.swift
//  StoryMakerApp
//
//  Created by to hoang nam on 19/8/25.
//



import SwiftUI


struct SplashView: View {
    
    @Binding var screen: ScreenEnum
    @State private var showIntro = false
    
    var body: some View {
        NavigationView {
            ZStack {
                if showIntro {
                    IntroView(screen: $screen)
                } else {
                    ZStack(alignment: .bottom) {
                        Image("splash")
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .edgesIgnoringSafeArea(.all)
                        
                        VStack(spacing: 19) {
                            if !AppUsage.shared.hasSeenIntro {
                                Button(action: {
                                    showIntro = true
                                }) {
                                    Text("Get Started")
                                        .font(.headline)
                                        .foregroundColor(Color.bgSplashBtn)
                                        .frame(width: 258, height: 47)
                                        .background(Color.white.cornerRadius(57))
                                }
                            }
                            
                            Text("Terms of Use  ·  Privacy Policy")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.white)
                        }
                    }
                }
            }
            .onAppear {
                if AppUsage.shared.hasSeenIntro {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        screen = .home
                    }
                }
            }
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
        }
    }
}

