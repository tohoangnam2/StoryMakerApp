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
    
    @Published var isLoadingFullImage = false
    //lưu ảnh fullsize theo url
    private var fullImageCache: [URL: UIImage] = [:]
    
    func cachedImage(for url: URL) -> UIImage? {
        fullImageCache[url]
    }
    
    func saveToCache(url: URL, image: UIImage) {
        fullImageCache[url] = image
    }
    
    func fetch() {
        guard let url = URL(string: "https://api.fleet-tech.net/story/get_background") else { return }
        let task = URLSession.shared.dataTask(with: url) {[weak self] data, _, error in
            guard let data = data, error == nil else { return }
            do {
                //decode json vào model
                let response = try JSONDecoder().decode(BackGroundModel.self, from: data)
                DispatchQueue.main.async {
                    //lưu model vào viewmodel
                    self?.model = response
                    //auto chọn category đầu tiền
                    self?.selectedCategory = response.config.category.first
                }
            } catch {
                print(error)
            }
        }
        task.resume()
    }
    func refreshSelectedCategory() {
        objectWillChange.send()
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



