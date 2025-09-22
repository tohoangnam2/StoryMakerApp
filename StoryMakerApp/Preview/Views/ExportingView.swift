// ExportingView.swift

import SwiftUI

struct ExportingView: View {
    // Nhận ViewModel từ HomePreview
    @ObservedObject var exportingVM: ExportingViewModel
    
    @Environment(\.dismiss) var dismiss

    
    var body: some View {
        NavigationView {
            ZStack(alignment: .topLeading) {
                VStack() {
                    // Thanh navigationbar
                    HStack {
                        // Nút Cancel (nếu cần)
                        Button(action: {
                            dismiss()

                        }) {
                            Image("home_back") // Có thể thay bằng icon "x" hoặc "cancel"
                        }
                        Spacer()
                    }
                    .padding(.bottom, 31)

                    // Vòng tròn tiến độ
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

                    // Text "Processing..."
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


//struct ProcessingContent: View {
//    @ObservedObject var exportingVM: ExportingViewModel
//    
//    
//    @Environment(\.dismiss) var dismiss
//
//    
//    var body: some View {
//        VStack {
//            // Vòng tròn tiến độ
//            ZStack {
//                Circle()
//                    .stroke(Color("#F5F5F5"), lineWidth: 10)
//                    .frame(width: 120, height: 120)
//                
//                Circle()
//                    .trim(from: 0, to: exportingVM.progress)
//                    .stroke(
//                        LinearGradient(
//                            gradient: Gradient(colors: [Color.red, Color.orange]), // Giả định Color.bgSplashX là màu này
//                            startPoint: .top,
//                            endPoint: .bottom
//                        ),
//                        style: StrokeStyle(lineWidth: 10, lineCap: .round)
//                    )
//                    .rotationEffect(.degrees(-90))
//                    .frame(width: 120, height: 120)
//                
//                // Hiển thị phần trăm
//                Text("\(Int(exportingVM.progress * 100))%")
//                    .font(.system(size: 22, weight: .bold))
//            }
//            .padding(.bottom, 30)
//
//            // Text "Processing..."
//            Text("Processing...")
//                .font(.system(size: 18, weight: .bold, design: .default))
//                .padding(.bottom, 15)
//
//            // Nút Cancel
//            Button(action: {
//                dismiss()
//                // **Lưu ý:** Cần thêm logic hủy tác vụ xuất file thực tế trong ViewModel
//            }) {
//                ZStack{
//                    RoundedRectangle(cornerRadius: 60)
//                        .fill(
//                             // Dùng màu đơn giản hoặc định nghĩa lại màu của bạn
//                            Color.gray.opacity(0.8)
//                        )
//                        .frame(height: 50)
//                    Text("Cancel")
//                        .foregroundColor(.white)
//                }
//            }
//            .padding(.horizontal, 64) // Điều chỉnh padding cho phù hợp
//            Spacer() // Đẩy nội dung lên trên
//        }
//    }
//}
//
//struct DoneContent: View {
//    @ObservedObject var exportingVM: ExportingViewModel
//    @State var dismiss: DismissAction
//    
//    var body: some View {
//        VStack {
//            // Icon Success
//            Image(systemName: "checkmark.circle.fill")
//                .resizable()
//                .frame(width: 120, height: 120)
//                .foregroundColor(.green) // Màu xanh cho thành công
//                .padding(.bottom, 30)
//
//            // Text thông báo
//            Text("Photo saved to gallery")
//                .font(.system(size: 18, weight: .bold, design: .default))
//                .padding(.bottom, 50)
//
//            // Các nút chia sẻ (Giả định bạn có các icon share_story, share_feed...)
//            HStack(spacing: 40) {
//                ShareButton(iconName: "share_story", title: "Story")
//                ShareButton(iconName: "share_feed", title: "Feed")
//                ShareButton(iconName: "share_message", title: "Message")
//                ShareButton(iconName: "share_other", title: "Other")
//            }
//            .padding(.bottom, 80)
//            
//            // Nút Done (Quay lại màn hình chỉnh sửa)
//            Button(action: {
//                dismiss() // Đóng ExportingView và quay lại HomePreview
//            }) {
//                ZStack{
//                    RoundedRectangle(cornerRadius: 60)
//                        .fill(
//                            LinearGradient(gradient: Gradient(colors: [Color.red, Color.orange]), // Giả định là màu gradient chính
//                                           startPoint: .topLeading,
//                                           endPoint: .bottomTrailing)
//                        )
//                        .frame(height: 50)
//                    Text("Done")
//                        .foregroundColor(.white)
//                }
//            }
//            .padding(.horizontal, 64)
//            Spacer() // Đẩy nội dung lên trên
//        }
//    }
//}
//
//// Subview cho Nút chia sẻ
//struct ShareButton: View {
//    let iconName: String
//    let title: String
//    
//    var body: some View {
//        VStack {
//            // Thay bằng icon thực tế của bạn
//            Circle()
//                .fill(Color.gray.opacity(0.1))
//                .frame(width: 56, height: 56)
//                .overlay(
//                    Text("Icon") // Thay bằng Image(iconName)
//                )
//            Text(title)
//                .font(.caption)
//                .foregroundColor(.gray)
//        }
//    }
//}
