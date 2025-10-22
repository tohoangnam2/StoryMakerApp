//
//  SplashView.swift
//  StoryMakerApp
//
//  Created by to hoang nam on 19/8/25.
//



import SwiftUI

struct SplashView: View {
    
    @Binding var isShowPremium: Bool
    
    @Binding var hasShownGetStarted: Bool
    
    var body: some View {
        NavigationView {
            ZStack{
                LinearGradient(gradient: Gradient(colors: [Color.bgSplash2, Color.bgSplash1]),
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
                VStack(spacing:200) {
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
                    .padding(.bottom,50)
                   
                    VStack(spacing:19){
                            NavigationLink {
                                HomeView(vm: BackgroundEditorViewModel(), isShowPremium: $isShowPremium)
                                    .navigationBarBackButtonHidden(true)
                                    .onAppear {
                                        hasShownGetStarted = true
                                    }
                            } label: {
                                Text("Get Started")
                                    .font(.headline)
                                    .foregroundColor(Color.bgSplashBtn)
                                    .frame(width: 258,height: 47)
                                    .background(Color.white.cornerRadius(57))
                            }
                            .opacity(hasShownGetStarted ? 0 : 1)
                            .disabled(hasShownGetStarted)
                        
                     

                        Text("Terms of Use  ·  Privacy Policy")
                            .font(.system(size: 12, weight: .medium, design: .default))
                            .foregroundStyle(.white)
                    }
                    
                }
            }

        }
        
        
    }
}
