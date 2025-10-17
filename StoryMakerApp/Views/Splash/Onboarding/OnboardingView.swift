//
//  OnboardingView.swift
//  StoryMaker
//
//  Created by to hoang nam on 18/8/25.
//

import SwiftUI

struct OnboardingView: View {
    
    @State var onboardingState : Int = 0
    @Binding var isShowPremium: Bool
    @Binding var seenOnboarding: Bool
    let trainstion: AnyTransition = .asymmetric(insertion: .move(edge: .trailing),
                                                removal: .move(edge: .leading))
    
    
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
                       EmptyView()
                    }
                }
               
            }
            .onChange(of: onboardingState) { value in
                if value > 3 {
                    seenOnboarding = true
                    isShowPremium = true
                }
            }
        }
      
    }
}

extension OnboardingView {
    private var firstOnboarding: some View {
        VStack{
            Image("bg_onb_1")
                .resizable()
                .edgesIgnoringSafeArea(.all)
                .frame(height: 556)
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
                .frame(maxWidth: .infinity)
                .background(
                    TopCurvedShape()
                        .fill(Color.white)
                        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: -4)
                        .frame(height: 332)
                    
                )
            }
        }
    }
    
    private var secondOnboarding: some View {
        VStack{
            Image("bg_onb_2")
                .resizable()
                .edgesIgnoringSafeArea(.all)
                .frame(height: 556)
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
                .frame(maxWidth: .infinity)
                .background(
                    TopCurvedShape()
                        .fill(Color.white)
                        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: -4) // drop shadow
                        .frame(height: 332)
                    
                )
            }
        }
    }
    
    private var threeOnboarding: some View {
        VStack{
            ZStack {
                Image("bg_onb_3")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)

                ZStack {
                    Image("bg_onb_3_1")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                        .background(
                            Image("bg_onb_bg_3")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 250, height: 250)
                        )
                        .offset(y: -16)
                        .offset(x: 13)
                   
                }
            }
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
                    VStack(){
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
                    .padding(.bottom,10)

                    
                }
                .frame(maxWidth: .infinity)
                .background(
                    TopCurvedShape()
                        .fill(Color.white)
                        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: -4)
                        .frame(height: 332)
                    
                )
            }
        }
    }
    
    private var fourOnboarding: some View {
        VStack{
            Image("bg_onb_4")
                .resizable()
                .edgesIgnoringSafeArea(.all)
                .frame(height: 556)
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
                .frame(maxWidth: .infinity)
                .background(
                    TopCurvedShape()
                        .fill(Color.white)
                        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: -4) // drop shadow
                        .frame(height: 332)
                    
                )
            }
        }
    }
    
   
    
    
}


struct TopCurvedShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        // bắt đầu từ góc trái trên
        path.move(to: CGPoint(x: 0, y: 40))
        
        // vẽ đường cong (control point)
        path.addQuadCurve(
            to: CGPoint(x: rect.width, y: 40),
            control: CGPoint(x: rect.width/2, y: -40) // điểm điều khiển cong
        )
        
        // vẽ xuống dưới
        path.addLine(to: CGPoint(x: rect.width, y: rect.height))
        path.addLine(to: CGPoint(x: 0, y: rect.height))
        path.closeSubpath()
        
        return path
    }
}

