//
//  TestMoveCanve.swift
//  StoryMakerApp
//
//  Created by Nam To on 28/10/25.
//

import SwiftUI

struct MovableText: View {
    @State private var position: CGSize = .zero      // vị trí tuyệt đối
    @State private var dragOffset: CGSize = .zero    // offset tạm khi drag
    
    var body: some View {
        Text("move text test")
            .padding()
            .background(Color.yellow.opacity(0.3))
            .cornerRadius(8)
            .offset(x: position.width + dragOffset.width,
                    y: position.height + dragOffset.height)
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        // delta = current finger - start finger
                        dragOffset = value.translation
                        
                    }
                    .onEnded { value in
                        // cộng offset tạm vào vị trí tuyệt đối
                        position.width += value.translation.width
                        position.height += value.translation.height
                        dragOffset = .zero
                    }
            )
    }
}


#Preview {
    MovableText()
}
