//
//  OnboardingView.swift
//  StoryMaker
//
//  Created by to hoang nam on 18/8/25.
//

import SwiftUI

struct IntroView: View {
    
    @State var onboardingState : Int = 0
    let trainstion: AnyTransition = .asymmetric(insertion: .move(edge: .trailing),
                                                removal: .move(edge: .leading))
    @Binding var screen : ScreenEnum

    
    var body: some View {
        NavigationView {
            ZStack {
                switch onboardingState {
                case 0:
                    withAnimation(.spring()){
                        firstOnboarding
                            .transition(trainstion)
                    }
                case 1:
                    withAnimation(.spring()){
                        secondOnboarding
                            .transition(trainstion)
                    }

                case 2:
                    withAnimation(.spring()){
                        threeOnboarding
                            .transition(trainstion)
                    }

                case 3:
                    withAnimation(.spring()){
                        fourOnboarding
                            .transition(trainstion)
                    }
                default:
                    withAnimation(.spring()){
                       HomeView()
                    }
                }
               
            }
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
        }
      
    }
}

extension IntroView {
    private var firstOnboarding: some View {
        ZStack{
            Image("bg_ob_1")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .edgesIgnoringSafeArea(.all)
            VStack {
                Spacer()
                VStack(spacing: 45) {
                    VStack(spacing: 7) {
                        Text("Template")
                            .font(.system(size: 28))
                            .fontWeight(.bold)
                            .foregroundColor(Color.bgSplashBtn)
                        Text("More than 1000 Template with many topic")
                            .font(.system(size: 18))
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color.bgSplashBtn)
                            .lineLimit(2)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.horizontal, 75)
                    }
                    VStack(spacing:19){
                        Button(action: {
                            self.onboardingState += 1
                        }) {
                            Text("Next")
                                .frame(width:258,height: 47)
                                .background(Color.red)
                                .foregroundColor(.white)
                                .cornerRadius(57)
                        }
                        Text("Terms of Use  ·  Privacy Policy")
                            .font(.footnote)
                            .foregroundColor(Color.bgSplashBtn)
                    }
                }
            }
        }
    }
    
    private var secondOnboarding: some View {
        ZStack{
            Image("bg_ob_2")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .edgesIgnoringSafeArea(.all)
            VStack {
                Spacer()
                
                VStack(spacing: 45) {
                    VStack(spacing: 7) {
                        Text("Effect & Filter")
                            .font(.system(size: 28))
                            .fontWeight(.bold)
                            .foregroundColor(Color.bgSplashBtn)
                        Text("More than 1000 Template with many topic")
                            .font(.system(size: 18))
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color.bgSplashBtn)
                            .lineLimit(2)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.horizontal, 75)
                    }
                    VStack(spacing:19){
                        Button(action: {
                            self.onboardingState += 1

                        }) {
                            Text("Next")
                                .frame(width:258,height: 47)
                                .background(Color.red)
                                .foregroundColor(.white)
                                .cornerRadius(57)
                        }
                        Text("Terms of Use  ·  Privacy Policy")
                            .font(.footnote)
                            .foregroundColor(Color.bgSplashBtn)
                    }
                    
                }
            }
        }
    }
    
    private var threeOnboarding: some View {
        ZStack{
            Image("bg_ob_3")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .edgesIgnoringSafeArea(.all)
            VStack {
                Spacer()
                
                VStack(spacing: 45) {
                    VStack(spacing: 7) {
                        Text("Text Art")
                            .font(.system(size: 28))
                            .fontWeight(.bold)
                            .foregroundColor(Color.bgSplashBtn)
                        Text("More than 1000 Template with many topic")
                            .font(.system(size: 18))
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color.bgSplashBtn)
                            .lineLimit(2)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.horizontal, 75)
                    }
                    VStack(spacing:19){
                        Button(action: {
                            self.onboardingState += 1

                        }) {
                            Text("Next")
                                .frame(width:258,height: 47)
                                .background(Color.red)
                                .foregroundColor(.white)
                                .cornerRadius(57)
                        }
                        Text("Terms of Use  ·  Privacy Policy")
                            .font(.footnote)
                            .foregroundColor(Color.bgSplashBtn)
                    }
                }
            }
        }
    }
    
    private var fourOnboarding: some View {
        ZStack{
            Image("bg_ob_4")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .edgesIgnoringSafeArea(.all)
            VStack {
                Spacer()
                
                VStack(spacing: 45) {
                    VStack(spacing: 7) {
                        Text("Sticker & Shape")
                            .font(.system(size: 28))
                            .fontWeight(.bold)
                            .foregroundColor(Color.bgSplashBtn)
                        Text("More than 1000 Template with many topic")
                            .font(.system(size: 18))
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color.bgSplashBtn)
                            .lineLimit(2)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.horizontal, 75)
                    }
                    VStack(spacing:19){
                        Button(action: {
                            self.onboardingState += 1

                        }) {
                            Text("Next")
                                .frame(width:258,height: 47)
                                .background(Color.red)
                                .foregroundColor(.white)
                                .cornerRadius(57)
                        }
                        Text("Terms of Use  ·  Privacy Policy")
                            .font(.footnote)
                            .foregroundColor(Color.bgSplashBtn)
                    }
                    
                }
             
            }
        }
    }
    
   
    
    
}


