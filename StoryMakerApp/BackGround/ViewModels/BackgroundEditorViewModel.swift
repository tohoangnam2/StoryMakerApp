import Foundation
import SwiftUI


class BackgroundEditorViewModel: ObservableObject {
    @Published var categories: [CategoryBG] = []
    @Published var backgrounds: [BackgroundItem] = []
    @Published var selectedCategory: CategoryBG? = nil {
        didSet {
            if let id = selectedCategory?.id {
                fetchBackgrounds(for: id)
            }
        }
    }
    
    @Published var selectedBackground: BackgroundModel? = nil
    
    @Published var opacity: Double = 1.0
    @Published var lightness: Double = 0
    @Published var saturation: Double = 1.0
    @Published var blur: Double = 0




    
    func fetchCategories() {
        guard let url = URL(string: "https://api.fleet-tech.net/story/get_lut") else { return }
        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data {
                if let decoded = try? JSONDecoder().decode(CategoryResponse.self, from: data) {
                    DispatchQueue.main.async {
                        self.categories = decoded.data
                        if self.selectedCategory == nil, let first = self.categories.first {
                            self.selectedCategory = first
                        }
                    }
                }
            }
        }.resume()
    }
    
    // Lấy backgrounds theo categoryId
    func fetchBackgrounds(for categoryId: String) {
        guard let url = URL(string: "https://api.fleet-tech.net/story/get_lut_detail?id=\(categoryId)") else { return }
        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data {
                if let decoded = try? JSONDecoder().decode(BackgroundResponse.self, from: data) {
                    DispatchQueue.main.async {
                        self.backgrounds = decoded.data.map { BackgroundItem(image: $0) }
                    }
                }
            }
        }.resume()
    }
}
