import Foundation
import Combine
import SwiftUI


class BackgroundEditorViewModel: ObservableObject {
    
    @Published var categories: [CategoryBG] = []
    @Published var backgrounds: [BackgroundItem] = []

    @Published var selectedBackground: BackgroundModel? = nil
    @Published var valueOpacity : Double = 1
    @Published var opacity : Double = 1
    @Published var lightness : Double = 0
    @Published var saturation : Double = 1
    @Published var blur : Double = 0
    @Published var shadow : Double = 0
    
  
    //preview filter
    @Published var previewImages: [String: UIImage] = [:]
    @Published var categoryPreviews: [String: [BackgroundItem]] = [:]
    @Published var previewCache: [String: [String: UIImage]] = [:]
    
    //change bg -> rs frame
    @Published var currentFrameID: String?
    @Published var defaultPreview: UIImage? = nil
    @Published var allBackgrounds: [BackgroundItem] = []

    //position
    @Published var scrollOffsets: [String: CGFloat] = [:] // key = categoryId
    @Published var lastSelectedFilterPosition: [String: UUID] = [:]
    
    // dùng khi ko cần click vào preview
    
    // lưu project
    @Published var projects: [Frame] = []  // lưu danh sách project
    @Published  var isImageLoaded = false
    @Published var mainprojects: [MainModel] = []
    @Published var currentProjectID: UUID?
    @Published var currentProject: MainModel?   // project đang edit
    @Published var project: MainModel = MainModel()
    
   
    
    @Published var baseImage: UIImage? {
        didSet {
            guard let _ = baseImage else { return }
            generateThumbnails()
            applySelectedFilter(animated: false)
        }
    }

    @Published var filteredImage: UIImage?
    @Published var selectedFilter: FilterType = .none
    @Published var thumbnails: [FilterType: UIImage] = [:]
    

    private let context = CIContext()
    private let processingQueue = DispatchQueue(label: "FilterProcessingQueue", qos: .userInitiated)
    private let thumbnailCache = NSCache<NSString, UIImage>() // ⚡ Cache cho preview

    //network
    @Published var isOnline: Bool = NetworkManager.shared.isOnline
    private var cancellables = Set<AnyCancellable>()

    init() {
        NetworkManager.shared.$isOnline
            .receive(on: DispatchQueue.main)
            .assign(to: \.isOnline, on: self)
            .store(in: &cancellables)
    }


    // MARK: - Filter Preview Cache
    func generateThumbnails() {
        guard let base = baseImage else { return }
        let thumbnail = base.resized(to: CGSize(width: 150, height: 150))
        for filter in FilterType.allCases {
            processingQueue.async {
                let key = filter.rawValue as NSString
                if let cached = self.thumbnailCache.object(forKey: key) {
                    DispatchQueue.main.async { self.thumbnails[filter] = cached }
                    return
                }

                let result = self.applyFilter(filter, to: thumbnail)
                if let result {
                    self.thumbnailCache.setObject(result, forKey: key)
                    DispatchQueue.main.async {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            self.thumbnails[filter] = result
                        }
                    }
                }
            }
        }
    }

    // MARK: - Main Filter Apply
    func applySelectedFilter(animated: Bool = true) {
        guard let baseImage = baseImage else { return }

        // Giữ lại ảnh hiện tại để không bị trắng nháy
        let previousImage = filteredImage ?? baseImage
        let currentFilter = selectedFilter

        DispatchQueue.global(qos: .userInitiated).async {
            guard let output = self.applyFilter(currentFilter, to: baseImage) else { return }

            DispatchQueue.main.async {
                // Crossfade nhẹ giữa 2 ảnh thay vì nháy
                withAnimation(animated ? .easeInOut(duration: 0.25) : nil) {
                    self.filteredImage = output
                }
            }
        }
    }

    // MARK: - Core Image Logic
    private func applyFilter(_ filterType: FilterType, to image: UIImage) -> UIImage? {
        guard let ciImage = CIImage(image: image) else { return nil }

        switch filterType {
        case .none:
            return image

        case .colorAbsolute:
            guard let secondImage = UIImage(named: "example2"),
                  let ciImage2 = CIImage(image: secondImage)
            else { return image }
            let filter = CIFilter.colorAbsoluteDifference()
            filter.inputImage = ciImage
            filter.inputImage2 = ciImage2
            return render(filter.outputImage)

        default:
            guard let filter = CIFilter(name: filterType.rawValue) else { return nil }
            filter.setValue(ciImage, forKey: kCIInputImageKey)
            if filterType == .sepia {
                filter.setValue(0.8, forKey: kCIInputIntensityKey)
            }
            return render(filter.outputImage)
        }
    }

    private func render(_ output: CIImage?) -> UIImage? {
        guard let output = output,
              let cgimg = context.createCGImage(output, from: output.extent)
        else { return nil }
        return UIImage(cgImage: cgimg)
    }
    
    func updatePreviewForNewBaseImage(_ newImage: UIImage) {
        // 1. Cập nhật baseImage
        self.baseImage = newImage
        self.defaultPreview = newImage

        // 2. Reset ảnh hiện tại
        self.filteredImage = newImage

        // 🧠 3. Xóa cache filter cũ (rất quan trọng!)
        self.thumbnails.removeAll()
        self.generateThumbnails() // tái tạo từ base mới

        // 4. Áp lại filter đang chọn (nếu có)
        if selectedFilter != .none {
            applySelectedFilter(animated: false)
        } else {
            self.filteredImage = newImage
        }

        // 5. Báo UI biết đã load xong ảnh
        self.isImageLoaded = true
    }


    
    func createEmptyProject() -> MainModel {
        let newProject = MainModel(id: UUID())
        ProjectStorage.saveProject(newProject, previewImage: nil)
        
        DispatchQueue.main.async {
            self.mainprojects.insert(newProject, at: 0)
        }
        
        return newProject
    }
}



extension BackgroundEditorViewModel {
    
    func deleteProject(_ project: MainModel) {
        // 1. Xoá trong docs
        ProjectStorage.deleteProject(id: project.id)
        
        // 2. Xoá trong RAM
        if let index = mainprojects.firstIndex(where: { $0.id == project.id }) {
            mainprojects.remove(at: index)
        }
    }

}



