//
//  BackGroundView.swift
//  StoryMakerApp
//
//  Created by to hoang nam on 19/8/25.
//

import SwiftUI

struct BackGroundView: View {
    var body: some View {
        NavigationView{
            ZStack{
                VStack {
                    VStack{
                        HStack{
                            Image("img_bg_check")
                                .opacity(0)
                            Spacer()
                            Text("Background")
                                .font(.system(size: 16, weight: .medium, design: .default))
                            Spacer()
                            Image("img_bg_check")
                        }
                        .padding(.horizontal)
                        Spacer()
                        
                    }
                    
                }
            }
        }
        .navigationBarBackButtonHidden(true)

    }

}

#Preview {
    BackGroundView()
}
