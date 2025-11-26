//
//  AppUsage.swift
//  StoryMakerApp
//
//  Created by Nam To on 5/11/25.
//
import Foundation
import SwiftUI

class AppUsage: ObservableObject {
    static let shared = AppUsage()

    @AppStorage("hasSeenIntro") var hasSeenIntro: Bool = false
    @AppStorage("isDarkMode") var isDarkMode: Bool = false
    
}

