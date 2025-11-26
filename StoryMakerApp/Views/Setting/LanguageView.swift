//
//  LanguageView.swift
//  StoryMakerApp
//
//  Created by Nam To on 26/11/25.
//

import SwiftUI

enum AppLanguage: String, CaseIterable {
    case english = "en"
    case vietnamese = "vi"

    var title: String {
        switch self {
        case .english: return "English"
        case .vietnamese: return "Tiếng Việt"
        }
    }

    var flag: String {
        switch self {
        case .english: return "🇺🇸"
        case .vietnamese: return "🇻🇳"
        }
    }
}

class LanguageManager: ObservableObject {
    static let shared = LanguageManager()

    @AppStorage("app_language") var savedLanguage: String = AppLanguage.english.rawValue

    @Published var currentLanguage: AppLanguage = .english
    @Published var isLoading = false

    init() {
        self.currentLanguage = AppLanguage(rawValue: savedLanguage) ?? .english
    }

    func localized(_ en: String, _ vi: String) -> String {
        return currentLanguage == .english ? en : vi
    }

    func changeLanguage(to lang: AppLanguage) {
        guard lang != currentLanguage else { return }

        isLoading = true
        
        // mô phỏng hiệu ứng loading 0.5s
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.currentLanguage = lang
            self.savedLanguage = lang.rawValue
            self.isLoading = false
        }
    }
}

struct LanguageView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var language = LanguageManager.shared

    var body: some View {
        ZStack {
            VStack {
                List {
                    Section {
                        ForEach(AppLanguage.allCases, id: \.self) { lang in
                            HStack {
                                Text(lang.flag)
                                Text(lang.title)
                                    .font(.system(size: 16, weight: .medium))

                                Spacer()

                                // dấu tick
                                if language.currentLanguage == lang {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.green)
                                        .font(.system(size: 18, weight: .bold))
                                }
                            }
                            .padding()
                            .contentShape(Rectangle())
                            .onTapGesture {
                                language.changeLanguage(to: lang)
                            }
                        }
                    }
                }
                .listStyle(.insetGrouped)
            }

            // loading overlay
            if language.isLoading {
                ZStack {
                    Color.black.opacity(0.3).ignoresSafeArea()
                    ProgressView("Loading…")
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                }
                
            }
        }
        .navigationTitle(language.currentLanguage == .english ? "Language" : "Ngôn ngữ")
        .navigationBarTitleDisplayMode(.inline)
    }
}
