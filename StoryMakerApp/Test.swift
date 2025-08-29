//
//  Test.swift
//  StoryMakerApp
//
//  Created by to hoang nam on 27/8/25.
//

import SwiftUI

struct Test: View {
    @State var angle: Angle = .degrees(0)
    var body: some View {
        Image("img_edit_xoay")
            .frame(width: 50, height: 50)
            .padding(20)
            .contentShape(Rectangle())
            .rotationEffect(angle)
            .gesture(
                LongPressGesture(minimumDuration: 0.2)
                    .sequenced(before: RotationGesture())
                    .onChanged { value in
                        switch value {
                        case .second(true, let rotation?):
                            angle = rotation
                        default:
                            break
                        }
                    }
                    .onEnded { value in
                        switch value {
                        case .second(true, let rotation?):
                            withAnimation(.easeInOut) {
                                angle = Angle(
                                    degrees: angle.degrees.truncatingRemainder(dividingBy: 360)
                                )
                            }
                        default:
                            break
                        }
                    }
            )
        
    }
}

#Preview {
    Test()
}
