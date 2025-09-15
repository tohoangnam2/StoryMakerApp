//
//  BackGroundModel.swift
//  StoryMakerApp
//
//  Created by to hoang nam on 19/8/25.
//

import Foundation
import SwiftUI

class BackgroundModel: Identifiable, ObservableObject {
    let id = UUID()
    let url: URL
    @Published var opacity: Double
    @Published var filter: FilterType
    var editEnum : BackGroundEditEditEnum = .filter
    
    init(url: URL, opacity: Double = 1.0, filter: FilterType = .normal) {
        self.url = url
        self.opacity = opacity
        self.filter = filter
    }
}
enum BackGroundEditEditEnum : CaseIterable {
    case filter
    case brightness
    case none
    
    var title : String {
        switch self {
        case .filter:
            return "Filter"
        case .brightness:
            return "Brightness"
        case .none:
            return ""
        }
    }
}


enum FilterType: String, CaseIterable {
    case normal, light, red, cyal, vintage, hot, old
}

struct CategoryResponse: Codable {
    let error: Int
    let data: [CategoryBG]
}

struct CategoryBG: Identifiable, Codable ,Equatable {
    let id: String
    let value: String   // tên category hiển thị
}
struct BackgroundResponse: Codable {
    let error: Int
    let category: String
    let data: [String]   // danh sách URL ảnh
}

struct BackgroundItem: Identifiable {
    let id: UUID
    let image: String
    var isDefault: Bool = false
    var baseImage: UIImage? = nil
    
    // Custom initializer
    init(id: UUID = UUID(), image: String, isDefault: Bool = false, baseImage: UIImage? = nil) {
        self.id = id
        self.image = image
        self.isDefault = isDefault
        self.baseImage = baseImage
    }
}







//background open

struct BackGroundModel: Codable {
    let config: Config
    let data: [Frame]
}

struct Config: Codable {
    let category: [Category]
}

struct Category: Codable ,Equatable{
    let id: String
    let name: String
}


struct Frame: Codable, Identifiable {
    let id = UUID()
    let category: String
    let thumb: String
    let background: String
    let feature: Int
    let updated: Double
    
    //fake id bg
    var backgroundID: String {
        return background.hash.description
    }

    
    var thumbURL: URL? {
         return URL(string: "https://api.fleet-tech.net" + thumb)
     }
     
     var backgroundURL: URL? {
         return URL(string: "https://api.fleet-tech.net" + background)
     }
}











