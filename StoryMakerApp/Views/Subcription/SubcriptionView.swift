//
//  SubcriptionView.swift
//  StoryMaker
//
//  Created by to hoang nam on 18/8/25.
//

import SwiftUI

struct SubcriptionView: View {
    

    //countdown 3 ngay
    // Tổng số giây còn lại
    @State private var remainingTime: Int = 3 * 24 * 60 * 60 // 3 ngày
    @Environment(\.presentationMode) var presentationMode
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    // Hàm chia ra days, hours, minutes
    func getTimeComponents(seconds: Int) -> (days: Int, hours: Int, minutes: Int) {
        let days = seconds / (24 * 3600)
        let hours = (seconds % (24 * 3600)) / 3600
        let minutes = (seconds % 3600) / 60
        return (days, hours, minutes)
    }
    
    
    var body: some View {
        
        let time = getTimeComponents(seconds: remainingTime)
        
        NavigationView{
            ZStack{
                Image("bg_subcription")
                    .resizable()
                    .ignoresSafeArea(edges: .all)
                    .scaledToFill()
                Button(action: {
                    presentationMode.wrappedValue.dismiss()

                }, label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.white)
                            .font(.system(size: 30))
                            .padding()
                            .padding(.top, 20)
                })
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                
                    VStack(spacing:15){
                        Spacer()
                        VStack(spacing:29){
                            
                            VStack(spacing: 10){
                                
                                Text("Hurry Up! Time is running out!")
                                    .font(.system(size: 16, weight: .medium, design: .default))
                                    .foregroundStyle(Color.colSubText)
                                HStack{
                                    ZStack{
                                        RoundedRectangle(cornerRadius: 10)
                                            .frame(width: 56,height: 56)
                                            .foregroundColor(.gray.opacity(0.5))
                                        VStack {
                                            Text("\(time.days)")
                                                .font(.system(size: 24, weight: .bold, design: .default))
                                                .foregroundColor(Color.colSubDate)
                                            Text("Days")
                                                .font(.system(size: 12, weight: .medium, design: .default))
                                        }
                                    }
                                    ZStack{
                                        RoundedRectangle(cornerRadius: 10)
                                            .frame(width: 56,height: 56)
                                            .foregroundColor(.gray.opacity(0.5))
                                        VStack {
                                            Text("\(time.hours)")
                                                .font(.system(size: 24, weight: .bold, design: .default))
                                                .foregroundColor(Color.colSubDate)
                                            Text("Hours")
                                                .font(.system(size: 12, weight: .medium, design: .default))
                                        }
                                    }
                                    ZStack{
                                        RoundedRectangle(cornerRadius: 10)
                                            .frame(width: 56,height: 56)
                                            .foregroundColor(.gray.opacity(0.5))
                                        VStack {
                                            Text("\(time.minutes)")
                                                .font(.system(size: 24, weight: .bold, design: .default))
                                                .foregroundColor(Color.colSubDate)
                                            Text("Minutes")
                                                .font(.system(size: 12, weight: .medium, design: .default))
                                        }
                                    }
                                }
                                .onReceive(timer) { _ in
                                    if remainingTime > 0 {
                                        remainingTime -= 1
                                    } else {
                                        timer.upstream.connect().cancel()
                                    }
                                }
                            }
                            VStack{
                                HStack {
                                    Text("Get unlimited access to all premium features.")
                                        .font(.system(size: 14, weight: .regular, design: .default))
                                        .foregroundColor(Color.black)
                                    + Text(" Cancel anytime")
                                        .font(.system(size: 14, weight: .regular, design: .default))
                                        .foregroundColor(Color.colSubText)
                                }
                                .padding(.horizontal,74)
                                .multilineTextAlignment(.center)
                                
                            }
                        }
                        VStack{
                            Text("15.8$ per week")
                                .foregroundColor(.gray.opacity(0.8))
                                .strikethrough(true, color: .gray)
                            Text("3.9$ per week")
                                .foregroundColor(.green)
                                .bold()
                                .font(.system(size: 33, weight: .bold, design: .default))
                            
                        }
                        VStack(spacing: 15){
                            Image("sub_btn")
                                
                            
                            Text("Auto-renewable")
                                .font(.system(size: 13, weight: .regular, design: .default))
                                .foregroundColor(Color.bgSplashBtn)
                            Text("Terms of Use  ·  Privacy Policy")
                                .font(.system(size: 12, weight: .regular, design: .default))
                                .foregroundColor(Color.gray)
                        }
                    }
                    .padding(.bottom,50)
            }
        }
      
    }
}

#Preview {
    SubcriptionView()
}
