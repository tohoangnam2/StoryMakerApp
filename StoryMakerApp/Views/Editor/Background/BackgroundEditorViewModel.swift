import Foundation
import Combine
import SwiftUI


class BackgroundEditorViewModel: ObservableObject {
    
    @Published var categories: [CategoryBG] = []
    @Published var backgrounds: [BackgroundItem] = []
    @Published var valueOpacity : Double = 1
    @Published var opacity : Double = 1
    @Published var lightness : Double = 0
    @Published var saturation : Double = 1
    @Published var blur : Double = 0
    @Published var shadow : Double = 0

    //change bg -> rs frame
    @Published var currentFrameID: String?
    @Published var defaultPreview: UIImage? = nil
    
    // dùng khi ko cần click vào preview
    
    // lưu project
    @Published var projects: [Frame] = []  // lưu danh sách project
    @Published  var isImageLoaded = false
    @Published var mainprojects: [MainModel] = []
    @Published var currentProjectID: UUID?
    @Published var currentProject: MainModel?   // project đang edit
    @Published var project: MainModel = MainModel()
    @Published var filteredImage: UIImage?
    @Published var selectedFilter: FilterType = .none
    @Published var hasLoadedFiltered = false
    //Là để lưu tạm (cache) các ảnh thumbnail đã được xử lý
    @Published var thumbnails: [FilterType: UIImage] = [:]

    private let context = CIContext()
    private let processingQueue = DispatchQueue(label: "FilterProcessingQueue", qos: .userInitiated)
    private let thumbnailCache = NSCache<NSString, UIImage>() // Cache cho preview

    //network
    @Published var isOnline: Bool = NetworkManager.shared.isOnline
    private var cancellables = Set<AnyCancellable>()

    init() {
        NetworkManager.shared.$isOnline
            .receive(on: DispatchQueue.main)
            .assign(to: \.isOnline, on: self)
            .store(in: &cancellables)
    }
    
    @Published var baseImage: UIImage? {
        //base change là cái này cũng change
        didSet {
            guard let newImage = baseImage else { return }
            updatePreviewForNewBaseImage(newImage)
        }
    }

    func resetFilterState() {
        selectedFilter = .none
        filteredImage = nil
        thumbnails.removeAll()
        thumbnailCache.removeAllObjects()
        isImageLoaded = false
    }

    func updatePreviewForNewBaseImage(_ newImage: UIImage) {
        self.defaultPreview = newImage
        self.filteredImage = newImage
        self.thumbnails.removeAll()
        self.thumbnailCache.removeAllObjects()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.generateThumbnails()
            //nếu có filter nào được chọn sẵn thì apply lên luôn
            if self.selectedFilter != .none {
                self.applySelectedFilter(animated: false)
            }
            self.isImageLoaded = true
        }
    }

    // Filter Preview Cache
    func generateThumbnails() {
        guard let base = baseImage else { return }
        let thumbnail = base.resized(to: CGSize(width: 150, height: 150))
        for filter in FilterType.allCases {
            processingQueue.async {
//                App sẽ kiểm tra cache trước: nếu ảnh preview cho filter đó đã có rồi → lấy ngay từ RAM.
                let key = filter.rawValue as NSString
                if let cached = self.thumbnailCache.object(forKey: key) {
                    DispatchQueue.main.async { self.thumbnails[filter] = cached }
                    return
                }
//          Nếu chưa có → apply filter, rồi lưu lại vào cache
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

    //  Main Filter Apply
    func applySelectedFilter(animated: Bool = true) {
        // Nếu vừa load filtered.jpg thì bỏ qua apply
        guard !hasLoadedFiltered else {
            print(" Skip reapplying filter (already loaded filtered image)")
            hasLoadedFiltered = false // reset để lần sau chọn filter mới thì apply lại bình thường
            return
        }
        guard let baseImage = baseImage else { return }

        // Giữ lại ảnh hiện tại để không bị trắng nháy
        let previousImage = filteredImage ?? baseImage
        let currentFilter = selectedFilter

        DispatchQueue.global(qos: .userInitiated).async {
            guard let output = self.applyFilter(currentFilter, to: baseImage) else { return }

            DispatchQueue.main.async {
                // Crossfade nhẹ giữa 2 ảnh
                withAnimation(animated ? .easeInOut(duration: 0.25) : nil) {
                    self.filteredImage = output
                }
            }
        }
        
    }

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
        
        case .toneCuver:
            // tone curve filter
            let filter = CIFilter.toneCurve()
            filter.inputImage = ciImage
            filter.point0 = CGPoint(x: 0.0, y: 0.0)
            filter.point1 = CGPoint(x: 0.22, y: 0.25)
            filter.point2 = CGPoint(x: 0.4, y: 0.5)
            filter.point3 = CGPoint(x: 0.65, y: 0.75)
            filter.point4 = CGPoint(x: 1.0, y: 1.0)
            return render(filter.outputImage)

        case .vibrance:
            let filter = CIFilter.vibrance()
            filter.inputImage = ciImage
            filter.amount = 2
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
//nhận core - uiimage
    private func render(_ output: CIImage?) -> UIImage? {
        guard let output = output,
              let cgimg = context.createCGImage(output, from: output.extent)
        else { return nil }
        return UIImage(cgImage: cgimg)
    }
    
    func createEmptyProject() -> MainModel {
        let newProject = MainModel(id: UUID())
        ProjectStorage.saveProject(newProject, previewImage: nil)
        
        DispatchQueue.main.async {
            self.mainprojects.insert(newProject, at: 0)
        }
        return newProject
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


