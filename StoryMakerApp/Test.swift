import SwiftUI

struct RotatableTextView: View {
    @State private var angle: CGFloat = 0           // Góc xoay của Text
    @State private var iconCenter: CGPoint = .zero  // Tâm icon để tính góc
    @State private var textSize: CGSize = .zero     // Kích thước Text + padding

    var body: some View {
        GeometryReader { geo in
            ZStack {
                
                Text("Hello World")
                    .font(.title)
                    .padding(12)
                    .background(
                        GeometryReader { textGeo in
                            Rectangle()
                                .stroke(style: StrokeStyle(lineWidth: 1))
                                .onAppear {
                                    textSize = textGeo.size
                                    // Tọa độ icon góc trái dưới
                                    iconCenter = CGPoint(
                                        x: geo.size.width/2 - textSize.width/2,
                                        y: geo.size.height/2 + textSize.height/2
                                    )
                                }
                        }
                    )
                    .rotationEffect(Angle(radians: Double(angle))) // Xoay quanh icon
                    .position(x: geo.size.width/2, y: geo.size.height/2)
                
                // MARK: Icon xoay
                Image(systemName: "arrow.triangle.2.circlepath")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .background(Color.yellow)
                    .cornerRadius(20)
                    .position(x: iconCenter.x, y: iconCenter.y) // Góc trái dưới của Text
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                // Tính góc giữa iconCenter và vị trí drag
                                angle = atan2(
                                    value.location.y - iconCenter.y,
                                    value.location.x - iconCenter.x
                                )
                            }
                    )
                
            }
            .frame(width: geo.size.width, height: geo.size.height)
            .background(Color.gray.opacity(0.2))
        }
    }
}

struct RotatableTextView_Previews: PreviewProvider {
    static var previews: some View {
        RotatableTextView()
    }
}
