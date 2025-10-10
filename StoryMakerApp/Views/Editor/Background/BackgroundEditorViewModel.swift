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
    
    
//    @Published var opacity: Double = UserDefaults.standard.object(forKey: "opacity") as? Double ?? 1 {
//        didSet {
//            UserDefaults.standard.set(opacity, forKey: "opacity")
//        }
//    }
    @Published var valueOpacity : Double = 1
    @Published var opacity : Double = 1
    @Published var lightness : Double = 0
    @Published var saturation : Double = 1

    @Published var blur : Double = 0
    @Published var shadow : Double = 0



//    @Published var lightness: Double = UserDefaults.standard.object(forKey: "lightness") as? Double ?? 0 {
//        didSet {
//            UserDefaults.standard.set(lightness, forKey: "lightness")
//        }
//    }
//
//    @Published var saturation: Double = UserDefaults.standard.object(forKey: "saturation") as? Double ?? 1 {
//        didSet {
//            UserDefaults.standard.set(saturation, forKey: "saturation")
//        }
//    }
//
//    @Published var blur: Double = UserDefaults.standard.object(forKey: "blur") as? Double ?? 0 {
//        didSet {
//            UserDefaults.standard.set(blur, forKey: "blur")
//        }
//    }
//    @Published var shadow: Double = UserDefaults.standard.object(forKey: "shadow") as? Double ?? 0 {
//        didSet {
//            UserDefaults.standard.set(shadow, forKey: "shadow")
//        }
//    }

    
    @Published var selectedFilter: String? = nil
    @Published var selectedFilterImage: UIImage? = nil
    @Published var finalImage: UIImage? = nil
    @Published var baseImage: UIImage?
    
    //preview filter
    @Published var previewImages: [String: UIImage] = [:]
    @Published var categoryPreviews: [String: [BackgroundItem]] = [:]
    @Published var previewCache: [String: [String: UIImage]] = [:]
    // previewCache[backgroundID] = [lutURL: previewImage]

    //change bg -> rs frame
    @Published var currentFrameID: String?
    
    @Published var defaultPreview: UIImage? = nil
    
    @Published var allBackgrounds: [BackgroundItem] = []
    
    //position
    @Published var scrollOffsets: [String: CGFloat] = [:] // key = categoryId
    
    @Published var lastSelectedFilterPosition: [String: UUID] = [:]
    
    // dùng khi ko cần click vào preview
    private let context = CIContext()

    // lưu project
    @Published var projects: [Frame] = []  // lưu danh sách project
    
    
    @Published  var isImageLoaded = false
    
    @Published var mainprojects: [MainModel] = []
    
    @Published var currentProjectID: UUID?

//    @Published var projectStates: [UUID: ProjectState] = [:]
    @Published var currentProject: MainModel?   // project đang edit

    
    @Published var project: MainModel = MainModel()
    
    

    func createEmptyProject() -> MainModel {
           let newProject = MainModel(id: UUID())
           
           ProjectStorage.saveProject(newProject, previewImage: nil)
           self.mainprojects.insert(newProject, at: 0)
           return newProject
       }
    

//      func applyAdjustments(for bgID: String) {
//          if let saved = adjustments[bgID] {
//              // load lại chỉnh sửa cũ
//              opacity = saved.opacity
//              lightness = saved.lightness
//              saturation = saved.saturation
//              blur = saved.blur
//              shadow = saved.shadow
//          } else {
//              // nếu chưa có → set default
//              resetAdjustments()
//          }
//      }
//
//      func saveAdjustments(for bgID: String) {
//          adjustments[bgID] = (opacity, lightness, saturation, blur, shadow)
//      }

      func resetAdjustments() {
          opacity = 1
          lightness = 0
          saturation = 1
          blur = 0
          shadow = 0
      }
    
    //func update preview
    func updatePreview() {
        guard let base = baseImage else { return }
        var ciImage = CIImage(image: base)

        // Lightness + Saturation
        let colorControls = CIFilter.colorControls()
        colorControls.inputImage = ciImage
        colorControls.brightness = Float(lightness)   // -1...1
        colorControls.saturation = Float(saturation) // 0...2
        ciImage = colorControls.outputImage

        // Blur
        if blur > 0 {
            let blurFilter = CIFilter.gaussianBlur()
            blurFilter.inputImage = ciImage
            blurFilter.radius = Float(blur * 10) // scale cho rõ
            ciImage = blurFilter.outputImage
        }

        guard let output = ciImage,
              let cgimg = context.createCGImage(output, from: output.extent) else { return }

        DispatchQueue.main.async {
            self.finalImage = UIImage(cgImage: cgimg)
        }
    }

    

    
    
    //view default
    var defaultBackgroundItem: BackgroundItem? {
        guard let base = baseImage else { return nil }
        return BackgroundItem( image: "", isDefault: true, baseImage: base)
    }





    // Trong ViewModel
    func generatePreview(for bg: BackgroundItem) {
        guard let base = baseImage, let url = URL(string: bg.image) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data, let lutImage = UIImage(data: data) {
                DispatchQueue.global().async {
                    if let preview = base.applyingLUT(lutImage: lutImage, dimension: 64) {
                        DispatchQueue.main.async {
                            self.previewImages[bg.image] = preview
                        }
                    }
                }
            }
        }.resume()
    }

    // Khi baseImage đã load xong, generate tất cả preview
    func generateAllPreviews() {
        guard let _ = baseImage else { return }
        for bg in backgrounds {
            generatePreview(for: bg)
        }
    }
    
    //tải lut trước
    func preloadLUTs() {
        guard let base = baseImage else { return }
        for bg in backgrounds {
            if let url = URL(string: bg.image) {
                URLSession.shared.dataTask(with: url) { data, _, _ in
                    if let data = data, let filterImage = UIImage(data: data) {
                        // Apply filter ngay với base
                        DispatchQueue.global(qos: .userInitiated).async {
                            if let preview = base.applyingLUT(lutImage: filterImage, dimension: 64) {
                                DispatchQueue.main.async {
                                    self.previewImages[bg.image] = preview
                                }
                            }
                        }
                    }
                }.resume()
            }
        }
    }



    
//    func loadSelectedFilter(baseImage: UIImage? = nil, completion: ((UIImage) -> Void)? = nil) {
//        guard let urlString = selectedFilter, let url = URL(string: urlString) else { return }
//        URLSession.shared.dataTask(with: url) { data, _, _ in
//            if let data = data, let image = UIImage(data: data) {
//                DispatchQueue.main.async {
//                    self.selectedFilterImage = image
//                    // Nếu có ảnh gốc thì apply luôn filter
//                    if let base = baseImage {
//                        self.applyFilter(to: base) { filtered in
//                            completion?(filtered) // trả về UIImage đã filter xong
//                        }
//                    }   
//                }
//            }
//        }.resume()
//    }
//
//
//
//
//    func applyFilter(to baseImage: UIImage, completion: ((UIImage) -> Void)? = nil) {
//        guard let filterImage = selectedFilterImage else { return }
//        DispatchQueue.global().async {
//            if let newImage = baseImage.applyingLUT(lutImage: filterImage, dimension: 64) {
//                DispatchQueue.main.async {
//                    self.finalImage = newImage
//                    completion?(newImage) // trả về cho preview
//                }
//            }
//        }
//    }

    func loadSelectedFilter(baseImage: UIImage, completion: @escaping (UIImage) -> Void) {
        guard let filterPath = selectedFilter,
              let url = URL(string: filterPath) else {
            completion(baseImage)
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data, let lutImage = UIImage(data: data) {
                DispatchQueue.global().async {
                    if let newImage = baseImage.applyingLUT(lutImage: lutImage, dimension: 64) {
                        DispatchQueue.main.async {
                            self.finalImage = newImage
                            completion(newImage)
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.finalImage = baseImage
                            completion(baseImage)
                        }
                    }
                }
            }
        }.resume()
    }

    func applyFilter(to baseImage: UIImage, completion: ((UIImage) -> Void)? = nil) {
        guard let filterImage = selectedFilterImage else {
            // Nếu chưa có filter thì finalImage = base
            DispatchQueue.main.async {
                self.finalImage = baseImage
                completion?(baseImage)
            }
            return
        }

        DispatchQueue.global().async {
            if let newImage = baseImage.applyingLUT(lutImage: filterImage, dimension: 64) {
                DispatchQueue.main.async {
                    self.finalImage = newImage
                    completion?(newImage)
                }
            } else {
                DispatchQueue.main.async {
                    self.finalImage = baseImage
                    completion?(baseImage)
                }
            }
        }
    }



    
    func loadUIImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, _, _ in
            var result: UIImage? = nil
            if let data = data {
                result = UIImage(data: data)
            }
            DispatchQueue.main.async {
                completion(result)
            }
        }.resume()
    }








    
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
        // Nếu cache có rồi thì dùng luôn
        if let cached = categoryPreviews[categoryId] {
            self.backgrounds = cached
            self.prepareAllPreviews()
            return
        }

        guard let url = URL(string: "https://api.fleet-tech.net/story/get_lut_detail?id=\(categoryId)") else { return }
        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data {
                if let decoded = try? JSONDecoder().decode(BackgroundResponse.self, from: data) {
                    DispatchQueue.main.async {
                        let items = decoded.data.map { BackgroundItem(image: $0) }
                        self.backgrounds = items
                        self.categoryPreviews[categoryId] = items // lưu cache
                        
                        self.prepareAllPreviews()
                    }
                }
            }
        }.resume()
    }

}



extension BackgroundEditorViewModel {

    // Gọi khi mở chế độ edit filter để preload tất cả preview
    func prepareAllPreviews() {
        guard let base = baseImage,
              let bgID = currentFrameID else { return }

        allBackgrounds = [defaultBackgroundItem].compactMap { $0 } + backgrounds

        // Nếu cache đã tồn tại cho bgID thì gán ra trước
        if let cached = previewCache[bgID] {
            previewImages = cached
        }

        for bg in backgrounds {
            // Nếu đã có preview cho bg này thì bỏ qua
            if let cachedPreview = previewCache[bgID]?[bg.image] {
                previewImages[bg.image] = cachedPreview
                continue
            }

            // Chưa có preview -> mới load LUT và render
            guard let url = URL(string: bg.image) else { continue }
            URLSession.shared.dataTask(with: url) { data, _, _ in
                if let data = data, let lutImage = UIImage(data: data) {
                    DispatchQueue.global(qos: .userInitiated).async {
                        if let preview = base.applyingLUT(lutImage: lutImage, dimension: 64) {
                            DispatchQueue.main.async {
                                self.previewImages[bg.image] = preview
                                if self.previewCache[bgID] == nil {
                                    self.previewCache[bgID] = [:]
                                }
                                self.previewCache[bgID]?[bg.image] = preview
                            }
                        }
                    
                    }
                }
            }.resume()
        }
    }
    

    func deleteProject(_ project: MainModel) {
          // 1. Xoá trong docs
          ProjectStorage.deleteProject(id: project.id)

          // 2. Xoá trong RAM
          if let index = mainprojects.firstIndex(where: { $0.id == project.id }) {
              mainprojects.remove(at: index)
          }
      }



}


