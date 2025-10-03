//
//  SplashView.swift
//  StoryMakerApp
//
//  Created by to hoang nam on 19/8/25.
//



import SwiftUI

struct SplashView: View {
    
    var body: some View {
        NavigationView {
            ZStack{
                LinearGradient(gradient: Gradient(colors: [Color.bgSplash2, Color.bgSplash1]),
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
                VStack(spacing:232) {
                    Spacer()
                    VStack(spacing: 28){
                        Image("img_splash")
                            .frame(width: 80,height: 75)
                        VStack(spacing: 5) {
                            Text("Story Maker")
                                .font(.system(size: 28, weight: .bold, design: .default))
                                .foregroundStyle(.white)
                            Text("Use StoryArt to unfold your stories and ")
                                .font(.system(size: 15, weight: .regular, design: .default))
                                .foregroundStyle(.white)
                        }
                    }
                    VStack(spacing:19){
                        NavigationLink {
                            withAnimation(.spring()){
                                OnboardingView()
                                    .navigationBarBackButtonHidden(true)
                            }
                        } label: {
                            Text("Get Started")
                                .font(.headline)
                                .foregroundColor(Color.bgSplashBtn)
                                .frame(width: 258,height: 47)
                                .background(Color.white.cornerRadius(57))
                        }
                        Text("Terms of Use  ·  Privacy Policy")
                            .font(.system(size: 12, weight: .medium, design: .default))
                            .foregroundStyle(.white)
                    }
                }
            }
        }
        
    }
}
