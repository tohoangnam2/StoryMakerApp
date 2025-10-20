import Foundation
import Combine
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
    
    //network
//    @Published var isOnline : Bool = false
    @Published var isOnline: Bool = NetworkManager.shared.isOnline
    private var cancellables = Set<AnyCancellable>()

    init() {
        NetworkManager.shared.$isOnline
            .receive(on: DispatchQueue.main)
            .assign(to: \.isOnline, on: self)
            .store(in: &cancellables)
    }

    

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
        guard let filterPath = selectedFilter?.trimmingCharacters(in: .whitespacesAndNewlines),
              !filterPath.isEmpty,
              filterPath.lowercased() != "none",
              filterPath.contains("/lut/"), // ✅ chỉ chấp nhận LUT filter
              let url = URL(string: filterPath) else {
            print("ℹ️ Filter không hợp lệ → dùng ảnh gốc")
            self.finalImage = baseImage
            completion(baseImage)
            return
        }

        print("🎨 Đang tải LUT filter từ:", filterPath)

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
            } else {
                print("❌ Không tải được LUT filter → dùng ảnh gốc")
                DispatchQueue.main.async {
                    self.finalImage = baseImage
                    completion(baseImage)
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
    func reloadProjectsAndCategories() {
           // Load lại toàn bộ project từ storage
           self.mainprojects = ProjectStorage.loadAllProjects()
           
           // Fetch lại categories (nếu có API hoặc local data)
           self.fetchCategories()
           
           // Reset filter khi đổi background
           self.selectedFilter = nil
           self.finalImage = self.baseImage
    }
    func reset() {
        baseImage = nil
        finalImage = nil
        defaultPreview = nil
        selectedFilter = nil
        selectedFilterImage = nil
        previewImages.removeAll()
        opacity = 1.0
        // reset thêm các biến khác nếu cần
        
        
    }
    
//    func reloadProjectsAndCategories(for projectID: UUID?) {
//        // Load lại toàn bộ project từ storage
//        self.mainprojects = ProjectStorage.loadAllProjects()
//        
//        // Fetch lại categories
//        self.fetchCategories()
//        
//        // Nếu có project cụ thể
//        if let id = projectID,
//           let project = self.mainprojects.first(where: { $0.id == id }) {
//            
//            // Nếu project đã có filter thì apply lại
//            if let filter = project.selectedFilter,
//               let url = project.frame?.backgroundURL,
//               let data = try? Data(contentsOf: url),
//               let uiImage = UIImage(data: data) {
//                
//                self.baseImage = uiImage
//                self.selectedFilter = filter
//                self.loadSelectedFilter(baseImage: uiImage) { filtered in
//                    self.finalImage = filtered
//                }
//            } else if let url = project.frame?.backgroundURL,
//                      let data = try? Data(contentsOf: url),
//                      let uiImage = UIImage(data: data) {
//                // Nếu chưa có filter thì set default
//                self.baseImage = uiImage
//                self.selectedFilter = nil
//                self.finalImage = uiImage
//            }
//        } else {
//            // Nếu không có project thì reset về default
//            self.selectedFilter = nil
//            self.finalImage = self.baseImage
//        }
//    }

    
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

    func restoreProject(_ project: MainModel) {
        guard let url = project.frame?.backgroundURL,
              let data = try? Data(contentsOf: url),
              let uiImage = UIImage(data: data) else { return }
        
        self.baseImage = uiImage
        self.defaultPreview = uiImage
        
        if let filter = project.selectedFilter {
            self.selectedFilter = filter
            self.loadSelectedFilter(baseImage: uiImage) { filtered in
                self.finalImage = filtered
            }
        } else {
            self.finalImage = uiImage
        }
        //  rebuild LUT previews
        self.prepareAllPreviews()
        self.updatePreview()
        self.isImageLoaded = true
    }
}
extension BackgroundEditorViewModel {
    func reloadProjectAssets(_ project: MainModel, overlayVM: OverlayTextViewModel) {
        // reset state cũ
        reset()
        
        // khôi phục text overlay
        overlayVM.overlays = project.textLayers
        
        // khôi phục filter đã lưu
        selectedFilter = project.selectedFilter
        opacity = project.opacity
        
        // đường dẫn ảnh gốc
        let folderURL = ProjectStorage.projectFolder(for: project.id)
        let originalURL = folderURL.appendingPathComponent("original.jpg")
        
        // 1. Ưu tiên load offline từ original.jpg
        if let data = try? Data(contentsOf: originalURL),
           let uiImage = UIImage(data: data) {
            print(" Offline: Load từ original.jpg")
            baseImage = uiImage
            applyFilterIfNeeded(uiImage)
            return
        }
        
        // 2. Nếu không có file gốc thì thử online từ backgroundURL
        if let url = project.frame?.backgroundURL,
           let data = try? Data(contentsOf: url),
           let uiImage = UIImage(data: data) {
            print(" Online: Load từ backgroundURL")
            baseImage = uiImage
            applyFilterIfNeeded(uiImage)
            return
        }
        
        // 3. Fallback cuối cùng: preview từ JSON
        if let preview = project.previewImage {
            print(" Fallback: dùng previewImage từ JSON")
            baseImage = preview
            finalImage = preview
        } else {
            print(" Không có original.jpg, backgroundURL, hay previewImage")
        }
    }
    
    private func applyFilterIfNeeded(_ uiImage: UIImage) {
        if let filter = selectedFilter {
            loadSelectedFilter(baseImage: uiImage) { filtered in
                self.finalImage = filtered
            }
        } else {
            finalImage = uiImage
        }
    }
}


