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
                    ZStack {
                        LinearGradient(
                            colors: [Color.bgSplash1, Color.bgSplash2],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                        .ignoresSafeArea()

                        VStack(spacing: 8) {   // spacing nhỏ hơn
                            LottieView(filename: "splash", loopMode: .playOnce)
                                .frame(width: 150, height: 150)  // giảm size cho cân đối
                                .padding(.bottom,-10)
                            Text("Story Maker")
                                .font(.system(size: 30, weight: .bold))
                                .foregroundColor(.white)

                            Text("Use StoryArt to unfold your stories")
                                .font(.system(size: 14, weight: .regular))
                                .foregroundColor(.white.opacity(0.85))
                                .padding(.top, -6)               // kéo subtitle lên gần title
                        }
                        .offset(y: -50)
                        .padding(.horizontal, 32)
                        .multilineTextAlignment(.center)

                        // BUTTON BOTTOM
                        VStack(spacing: 0) {
                            Spacer()
                            if !AppUsage.shared.hasSeenIntro {
                                Button {
                                    showIntro = true
                                } label: {
                                    Text("Get Started")
                                        .font(.system(size: 18, weight: .semibold))
                                        .foregroundColor(.black)
                                        .frame(width: 230, height: 50)
                                        .background(Color.white)
                                        .cornerRadius(30)
                                        .shadow(color: .black.opacity(0.15), radius: 8, y: 4)
                                }
                                .padding(.bottom, 18)
                            }
                            else{
                                LottieView(filename: "loading_bar", loopMode: .playOnce)
                                    .frame(width: 150, height: 150)
                            }
                            Text("Terms of Use  ·  Privacy Policy")
                                .font(.system(size: 12))
                                .foregroundColor(.white.opacity(0.8))
                                .padding(.bottom, 14)
                        }
                    }
                }
            }
            .onAppear {
                if AppUsage.shared.hasSeenIntro {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                        screen = .home
                    }
                }
            }
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
        }
    }
}

