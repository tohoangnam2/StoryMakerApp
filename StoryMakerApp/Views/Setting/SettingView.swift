//
//  SettingView.swift
//  StoryMakerApp
//
//  Created by Nam To on 25/11/25.
//

import SwiftUI
import MessageUI
import StoreKit


struct SettingView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var appUsage = AppUsage.shared
    @State var isShowPremium: Bool = false
    @State private var showPrivacy = false
    @State private var showMail = false

    
    @EnvironmentObject var language: LanguageManager

    
    var body: some View {
        ZStack{
            NavigationView{
                VStack{
                    //topbar
                    HStack{
                        Button(action: { dismiss() }) {
                            Image("home_back")
                        }
                        Spacer()
                        Text(language.localized("SETTINGS", "Cài đặt"))
                            .font(.system(size: 18, weight: .bold, design: .default))
                        Spacer()
                        Button(action: { dismiss() }) {
                            Image("home_back")
                                .opacity(0)
                        }
                    }
                    .padding(.horizontal, 16)
               
                    List {
                        // SECTION 1
                        Section {
                            Button(action: {
                              isShowPremium = true
                            }, label: {
                                HStack{
                                    Image("st1")
                                    Text(language.localized("Update VIP", "Cập nhật VIP"))
                                        .font(.system(size: 16, weight: .medium, design: .default))
                                    Spacer()
                                    Image("home_setting")
                                        .frame(width: 12, height: 12)
                                }
                                .foregroundStyle(.red)
                            })
                            
                            NavigationLink {
                                LanguageView()
                            } label: {
                                HStack(spacing: 15){
                                    Image("st2")
                                    Text(language.currentLanguage == .english ? "Language" : "Ngôn ngữ")
                                        .font(.system(size: 16, weight: .medium, design: .default))
                                    Spacer()
                                }
                            }
                            
                            Toggle(isOn: $appUsage.isDarkMode) {
                                     HStack(spacing: 15) {
                                         Image("st3")
                                         Text(language.currentLanguage == .english ? "Darks Theme" : "Chủ đề tối")
                                             .font(.system(size: 16, weight: .medium, design: .default))
                                     }
                            }
                                 .toggleStyle(SwitchToggleStyle(tint: .green))
                        }
                        .padding()

                        // SECTION 2
                        Section {
                            ForEach(SettingEnum.allCases, id: \.self) { setting in
                                Button(action: {
                                    handleSettingAction(setting)
                                }, label: {
                                    HStack(spacing: 15){
                                        Image(setting.image)
                                        Text(language.currentLanguage == .english ? setting.title : setting.titleVN)
                                            .font(.system(size: 16, weight: .medium, design: .default))
                                    }
                                    .padding()
                                })                                
                            }
                        }
                    }
                }
            }
            .navigationBarBackButtonHidden(true)

        }
        .sheet(isPresented: $showPrivacy) {
            SafariView(url: URL(string: "https://chatgpt.com")!)
        }
        .sheet(isPresented: $showMail) {
            MailView(subject: "Feedback for StoryMakerApp",
                     toEmail: "tohoangnam03@gmail.com")
        }
        .fullScreenCover(isPresented: $isShowPremium) {
            SubcriptionView()
        }
    }
    func rateApp() {
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
    func feedback() {
        if MFMailComposeViewController.canSendMail() {
            showMail = true
        } else {
            // Nếu máy user chưa đăng nhập email
            let url = URL(string: "mailto:tohoangnam03@gmail.com")!
            UIApplication.shared.open(url)
        }
    }
    
    func handleSettingAction(_ setting: SettingEnum) {
        switch setting {
        case .policy:
            showPrivacy = true
        case .share:
            EmptyView()
        case .feedback:
            feedback()
        case .rate:
            rateApp()
        case .other:
            EmptyView()
        case .version:
            break
        }
    }

}
enum SettingEnum: CaseIterable {
    case policy
    case share
    case feedback
    case rate
    case other
    case version
    
    var title: String {
        switch self {
        case .policy:
            return "Privacy Policy"
        case .share:
            return "Share App"
        case .feedback:
            return "Feedback"
        case .rate:
            return "Rate App"
        case .other:
            return "Other App"
        case .version:
            return "Version 2.0.1"
        }
    }
    var titleVN: String {
        switch self {
        case .policy:
            return "Chính sách bảo mật"
        case .share:
            return "Chia sẻ App"
        case .feedback:
            return "Nhận xét"
        case .rate:
            return "Đánh giá"
        case .other:
            return "App khác"
        case .version:
            return "Phiên bản 2.0.1"
        }
    }
    
    var image: String {
        switch self {
        case .policy:
            return "st4"
        case .share:
            return "st5"
        case .feedback:
            return "st6"
        case .rate:
            return "st7"
        case .other:
            return "st8"
        case .version:
            return "st9"
        }
    }
    
    
}



#Preview {
    SettingView()
}
