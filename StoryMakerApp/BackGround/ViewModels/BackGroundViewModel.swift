//
//  BackGroundViewModel.swift
//  StoryMakerApp
//
//  Created by to hoang nam on 19/8/25.
//

import Foundation
import SwiftUI

class BackGroundViewModel: ObservableObject {
    @Published var model: BackGroundModel? = nil
    @Published var selectedCategory: Category? = nil
    
    func fetch() {
        guard let url = URL(string: "https://api.fleet-tech.net/story/get_background") else { return }
        let task = URLSession.shared.dataTask(with: url) {[weak self] data, _, error in
            guard let data = data, error == nil else { return }
            do {
                let response = try JSONDecoder().decode(BackGroundModel.self, from: data)
                DispatchQueue.main.async {
                    self?.model = response
                    self?.selectedCategory = response.config.category.first 
                }
            } catch {
                print(error)
            }
        }
        task.resume()
    }
    //trả về fram mà category đang chọn
    func framesForSelectedCategory() -> [Frame] {
        guard let selected = selectedCategory else { return [] }
        return model?.data.filter { $0.category == selected.id } ?? []
    }
    //Tìm tên category mà 1 frame đang thuộc về.
    func categoryName(for frame: Frame) -> String? {
          return model?.config.category.first(where: { $0.id == frame.category })?.name
      }
}



