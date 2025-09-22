//
//  Shimmering.swift
//  StoryMakerApp
//
//  Created by Nam To on 22/9/25.
//

import SwiftUICore

extension View {
    func shimmering(active: Bool = true, duration: Double = 1.5) -> some View {
        self
            .overlay(
                ZStack {
                    if active {
                        LinearGradient(
                            gradient: Gradient(colors: [.clear, Color.white.opacity(0.4), .clear]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                        .rotationEffect(.degrees(30))
                        .offset(x: -200)
                        .frame(width: 200)
                        .animation(
                            Animation.linear(duration: duration)
                                .repeatForever(autoreverses: false),
                            value: UUID()
                        )
                    }
                }
            )
            .mask(self)
    }
}
