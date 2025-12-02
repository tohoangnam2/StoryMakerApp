//
//  APIService.swift
//  StoryMakerApp
//
//  Created by Nam To on 1/12/25.
//
import Foundation

struct APIService {
    static func fetchFramesByCategory(_ categoryID: String,
                                      completion: @escaping (Result<[Frame], Error>) -> Void) {

        let urlString = "https://api.fleet-tech.net/story/get_background_by_category?category_id=\(categoryID)"

        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else { return }

            do {
                let frames = try JSONDecoder().decode([Frame].self, from: data)
                completion(.success(frames))
            } catch {
                completion(.failure(error))
            }

        }
        .resume()
    }
}
