//
//  BackgroundEditModel.swift
//  StoryMakerApp
//
//  Created by Nam To on 10/9/25.
//


import Foundation
import SwiftUI



struct CategoryBGResponse: Codable {
    let error: Int
    let data: [CategoryBGItem]
}

struct CategoryBGItem: Codable, Identifiable {
    let id: String
    let value: String

}


struct FrameCategoryBGResponse: Codable {
    let error: Int
    let category: String
    let data: [String]
}


// Optional: biến computed để chuyển String thành URL
extension FrameCategoryBGResponse {
    var imageURLs: [URL] {
        data.compactMap { URL(string: $0) }
    }
}












