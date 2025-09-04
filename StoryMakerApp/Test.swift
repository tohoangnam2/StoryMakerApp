import SwiftUI

struct RotatableView: View {
    
    // 1. Biến trạng thái để lưu góc xoay
    @State private var currentRotation: Angle = .degrees(0)
    
    // Biến tạm để lưu góc ban đầu khi bắt đầu kéo
    @State private var startAngle: Angle = .degrees(0)
    
    // Biến tạm để lưu vị trí ban đầu của ngón tay khi xoay
    @State private var startLocation: CGPoint?
    
    // 2. Biến trạng thái để lưu zoom
    @State private var currentScale: CGFloat = 1.0
    
    // Biến tạm để lưu scale ban đầu
    @State private var startScale: CGFloat = 1.0
    
    // Biến tạm để lưu khoảng cách ban đầu từ tâm khi zoom
    @State private var startDistance: CGFloat = 0.0
    
    var body: some View {
        ZStack {
            Text("Xoay & Zoom tôi đi!")
                .font(.largeTitle)
                .padding(50)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .overlay {
                    GeometryReader { textGeo in
                        ZStack {
                            Rectangle()
                                .stroke(style: StrokeStyle(lineWidth: 2))
                                .foregroundColor(Color.black.opacity(0.6))
                            
                            // Nút xóa
                            Image("img_edit_x")
                                .padding(10)
                                .position(x: 0, y: 0)
                            
                            // Nút copy
                            Image("img_edit_copy")
                                .padding(10)
                                .position(x: textGeo.size.width, y: 0)
                            
                            // Nút xoay
                            Image("img_edit_xoay")
                                .frame(width: 30, height: 30)
                                .padding(30)
                                .contentShape(Rectangle())
                                .position(x: 0, y: textGeo.size.height)
                                .gesture(
                                    DragGesture(minimumDistance: 0, coordinateSpace: .global)
                                        .onChanged { value in
                                            let frame = textGeo.frame(in: .global)
                                            let center = CGPoint(x: frame.midX, y: frame.midY)
                                            
                                            if self.startLocation == nil {
                                                self.startLocation = value.startLocation
                                                self.startAngle = self.currentRotation
                                            }
                                            
                                            let startVector = CGVector(dx: (self.startLocation?.x ?? 0) - center.x,
                                                                       dy: (self.startLocation?.y ?? 0) - center.y)
                                            
                                            let currentVector = CGVector(dx: value.location.x - center.x,
                                                                         dy: value.location.y - center.y)
                                            
                                            let angleChange = atan2(currentVector.dy, currentVector.dx) - atan2(startVector.dy, startVector.dx)
                                            self.currentRotation = self.startAngle + Angle(radians: Double(angleChange))
                                        }
                                        .onEnded { _ in
                                            self.startLocation = nil
                                        }
                                )
                            
                            // Nút zoom
                            Image("img_edit_zoom")
                                .padding(10)
                                .position(x: textGeo.size.width, y: textGeo.size.height)
                                .gesture(
                                    DragGesture(minimumDistance: 0, coordinateSpace: .global)
                                        .onChanged { value in
                                            let frame = textGeo.frame(in: .global)
                                            let center = CGPoint(x: frame.midX, y: frame.midY)
                                            
                                            let currentDistance = hypot(value.location.x - center.x,
                                                                        value.location.y - center.y)
                                            
                                            if self.startDistance == 0 {
                                                self.startDistance = currentDistance
                                                self.startScale = self.currentScale
                                            }
                                            
                                            if self.startDistance != 0 {
                                                let scaleFactor = currentDistance / self.startDistance
                                                self.currentScale = max(0.2, min(self.startScale * scaleFactor, 5.0)) // giới hạn 0.2x - 5x
                                            }
                                        }
                                        .onEnded { _ in
                                            self.startDistance = 0
                                        }
                                )
                        }
                    }
                }
        }
        .rotationEffect(self.currentRotation, anchor: .center) // Xoay
        .scaleEffect(self.currentScale) // Zoom
    }
}

#Preview {
    RotatableView()
}
