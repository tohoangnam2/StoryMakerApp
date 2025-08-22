//
//  BackGroundModel.swift
//  StoryMakerApp
//
//  Created by to hoang nam on 19/8/25.
//

import Foundation
import SwiftUI

struct BackGroundModel: Codable {
    let config: Config
    let data: [Frame]
}

struct Config: Codable {
    let category: [Category]
}

struct Category: Codable {
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
    
    var thumbURL: URL? {
         return URL(string: "https://api.fleet-tech.net" + thumb)
     }
     
     var backgroundURL: URL? {
         return URL(string: "https://api.fleet-tech.net" + background)
     }
}








