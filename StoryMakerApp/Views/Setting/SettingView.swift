//
//  SettingView.swift
//  StoryMakerApp
//
//  Created by Nam To on 25/11/25.
//

import SwiftUI

struct SettingView: View {
    @Environment(\.dismiss) var dismiss
    
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
                        Text("SETTINGS")
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
                            HStack{
                                Image("st1")
                                Text("Update VIP")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.red)
                                Spacer()
                                Image("home_setting")
                                    .frame(width: 12, height: 12)
                            }

                            HStack{
                                Image("st2")
                                Text("Language")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(Color("bg_splash_btn"))
                                Spacer()
                                Image("home_setting")
                                    .frame(width: 12, height: 12)
                            }

                            HStack{
                                Image("st3")
                                Text("Dark Themes")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(Color("bg_splash_btn"))
                            }
                        }

                        // SECTION 2
                        Section {
                            ForEach(SettingEnum.allCases, id: \.self) { setting in
                                HStack(spacing: 15){
                                    Image(setting.image)
                                    Text(setting.title)
                                        .font(.system(size: 16))
                                        .foregroundColor(Color("bg_splash_btn"))
                                }
                                .padding(.vertical, 8)
                            }
                        }
                    }
                    .listStyle(.insetGrouped)

                    
                }

            }
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
