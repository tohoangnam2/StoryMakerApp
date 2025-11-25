// ExportingView.swift

import SwiftUI

struct ExportingView: View {
    
    @ObservedObject var exportingVM: ExportingViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .topLeading) {
                VStack() {
                    // Thanh navigationbar
                    HStack {
                        Button(action: {
                            dismiss()
                        }) {
                            Image("home_back")
                        }
                        Spacer()
                    }
                    .padding(.bottom, 31)

                    ZStack {
                        Circle()
                            .stroke(Color("#F5F5F5"), lineWidth: 10)
                            .frame(width: 120, height: 120)
                        
                        Circle()
                            .trim(from: 0, to: exportingVM.progress)
                            .stroke(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.red, Color.orange]),
                                    startPoint: .top,
                                    endPoint: .bottom
                                ),
                                style: StrokeStyle(lineWidth: 10, lineCap: .round)
                            )
                            .rotationEffect(.degrees(-90))
                            .frame(width: 120, height: 120)
                            .animation(.easeInOut(duration: 0.3), value: exportingVM.progress)

                        
                        // Hiển thị phần trăm
                        Text("\(Int(exportingVM.progress * 100))%")
                            .font(.system(size: 22, weight: .bold))
                    }
                    .padding(.bottom, 30)

                    Text("Processing...")
                        .font(.system(size: 18, weight: .bold, design: .default))
                        .padding(.bottom, 15)

                    Button(action: {
                        dismiss()
                    }) {
                        ZStack{
                            RoundedRectangle(cornerRadius: 60)
                                .fill(
                                    LinearGradient(gradient: Gradient(colors: [Color.bgSplash2, Color.bgSplash1]),
                                                   startPoint: .topLeading,
                                                   endPoint: .bottomTrailing)
                                )
                                .frame(height: 50)
                            Text("Cancel")
                                .foregroundColor(.white)
                        }
                        .padding(.horizontal, 80)
                    }
                }
                Spacer()
                .padding(.horizontal, 16)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}
