import Foundation
import Combine
import SwiftUI


class BackgroundEditorViewModel: ObservableObject {

    @Published var valueOpacity : Double = 1
    @Published var opacity : Double = 1
    @Published var lightness : Double = 0
    @Published var saturation : Double = 1
    @Published var blur : Double = 0
    @Published var shadow : Double = 0
    @Published var currentFrameID: String?
    @Published  var isImageLoaded = false
    @Published var filteredImage: UIImage?
    @Published var selectedFilter: FilterType = .none
    @Published var hasLoadedFiltered = false
    @Published var thumbnails: [FilterType: UIImage] = [:]
    private let context = CIContext()
    private let processingQueue = DispatchQueue(label: "FilterProcessingQueue", qos: .userInitiated)
    
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
        isImageLoaded = false
    }

    func updatePreviewForNewBaseImage(_ newImage: UIImage) {
        self.filteredImage = newImage
        self.thumbnails.removeAll()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.generateThumbnails()
            //nếu có filter nào được chọn sẵn thì apply lên luôn
            if self.selectedFilter != .none {
                self.applySelectedFilter(animated: false)
            }
            self.isImageLoaded = true
        }
    }

    func generateThumbnails() {
        guard let base = baseImage else { return }
        // Tạo ảnh nhỏ cho nhanh (chỉ 150px)
        let thumbnail = base.resized(to: CGSize(width: 150, height: 150))
        
        for filter in FilterType.allCases {
            // Nếu đã có rồi thì bỏ qua
            if thumbnails[filter] != nil { continue }
            
            DispatchQueue.global(qos: .userInitiated).async {
                // Apply filter cho bản thumbnail
                guard let result = self.applyFilter(filter, to: thumbnail) else { return }
                
                DispatchQueue.main.async {
                    withAnimation(.easeInOut(duration: 0.25)) {
                        self.thumbnails[filter] = result
                    }
                }
            }
        }
    }
    //  luồng xử lí
    func applySelectedFilter(animated: Bool = true) {
        guard let baseImage = baseImage else { return }
        let currentFilter = selectedFilter
        
        // Nếu user chọn "none" thì reset về ảnh gốc
        if currentFilter == .none {
            withAnimation(animated ? .easeInOut(duration: 0.25) : nil) {
                self.filteredImage = baseImage
            }
            return
        }
        // Xử lý filter ở background thread
        DispatchQueue.global(qos: .userInitiated).async {
            guard let output = self.applyFilter(currentFilter, to: baseImage) else { return }
            
            DispatchQueue.main.async {
                    self.filteredImage = output
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
    
    func loadFromProject(_ project: MainModel) {
        print("Load lại project \(project.id)")

        // copy thông số cơ bản
        blur = project.blur
        shadow = project.shadow
        opacity = project.opacity
        lightness = project.lightness
        saturation = project.saturation
        selectedFilter = FilterType(rawValue: project.selectedFilter ?? "") ?? .none

        let folderURL = ProjectStorage.projectFolder(for: project.id)
        
        // Load original base image
        if let originalName = project.originalImagePath {
            let originalURL = folderURL.appendingPathComponent(originalName)
            if FileManager.default.fileExists(atPath: originalURL.path),
               let data = try? Data(contentsOf: originalURL),
               let originalImage = UIImage(data: data) {
                baseImage = originalImage
            } else {
                print(" Không tìm thấy original.jpg cho project \(project.id)")
            }
        }

      
    }
    
    func createEmptyProject() -> MainModel {
        let newProject = MainModel(id: UUID())
        ProjectStorage.saveProject(newProject, previewImage: nil)
        return newProject
    }
    
    


}
