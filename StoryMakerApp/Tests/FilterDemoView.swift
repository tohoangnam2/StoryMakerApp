////import SwiftUI
////import CoreImage
////import CoreImage.CIFilterBuiltins
////
////// MARK: - Filter Types
////enum FilterType: String, CaseIterable, Identifiable {
////    var id: String { rawValue }
////
////    case none = "None"
////    case noir = "CIPhotoEffectNoir"
////    case sepia = "CISepiaTone"
////    case invert = "CIColorInvert"
////    case mono = "CIPhotoEffectMono"
////    case chrome = "CIPhotoEffectChrome"
////    case fade = "CIPhotoEffectFade"
////    case instant = "CIPhotoEffectInstant"
////    case posterize = "CIColorPosterize"
////    case colorAbsolute = "CIColorAbsoluteDifference"
////}
////
////// MARK: - ViewModel
////class FilterDemoViewModel: ObservableObject {
////    @Published var baseImage: UIImage? = UIImage(named: "bg_ob_1")
////    @Published var filteredImage: UIImage?
////    @Published var selectedFilter: FilterType = .none
////    @Published var thumbnails: [FilterType: UIImage] = [:]
////
////    private let context = CIContext()
////    private let processingQueue = DispatchQueue(label: "FilterProcessingQueue", qos: .userInitiated)
////    private let thumbnailCache = NSCache<NSString, UIImage>() // ⚡ Cache cho preview
////
////    init() {
////        generateThumbnails()
////        applySelectedFilter(animated: false)
////    }
////
////    // MARK: - Filter Preview Cache
////    func generateThumbnails() {
////        guard let base = baseImage else { return }
////        let thumbnail = base.resized(to: CGSize(width: 150, height: 150))
////        for filter in FilterType.allCases {
////            processingQueue.async {
////                let key = filter.rawValue as NSString
////                if let cached = self.thumbnailCache.object(forKey: key) {
////                    DispatchQueue.main.async { self.thumbnails[filter] = cached }
////                    return
////                }
////
////                let result = self.applyFilter(filter, to: thumbnail)
////                if let result {
////                    self.thumbnailCache.setObject(result, forKey: key)
////                    DispatchQueue.main.async {
////                        withAnimation(.easeInOut(duration: 0.2)) {
////                            self.thumbnails[filter] = result
////                        }
////                    }
////                }
////            }
////        }
////    }
////
////    // MARK: - Main Filter Apply
////    func applySelectedFilter(animated: Bool = true) {
////        guard let base = baseImage else { return }
////        processingQueue.async {
////            let filtered = self.applyFilter(self.selectedFilter, to: base)
////            DispatchQueue.main.async {
////                guard let filtered else { return }
////                if animated {
////                    withAnimation(.easeInOut(duration: 0.25)) {
////                        self.filteredImage = filtered
////                    }
////                } else {
////                    self.filteredImage = filtered
////                }
////            }
////        }
////    }
////
////    // MARK: - Core Image Logic
////    private func applyFilter(_ filterType: FilterType, to image: UIImage) -> UIImage? {
////        guard let ciImage = CIImage(image: image) else { return nil }
////
////        switch filterType {
////        case .none:
////            return image
////
////        case .colorAbsolute:
////            guard let secondImage = UIImage(named: "example2"),
////                  let ciImage2 = CIImage(image: secondImage)
////            else { return image }
////            let filter = CIFilter.colorAbsoluteDifference()
////            filter.inputImage = ciImage
////            filter.inputImage2 = ciImage2
////            return render(filter.outputImage)
////
////        default:
////            guard let filter = CIFilter(name: filterType.rawValue) else { return nil }
////            filter.setValue(ciImage, forKey: kCIInputImageKey)
////            if filterType == .sepia {
////                filter.setValue(0.8, forKey: kCIInputIntensityKey)
////            }
////            return render(filter.outputImage)
////        }
////    }
////
////    private func render(_ output: CIImage?) -> UIImage? {
////        guard let output = output,
////              let cgimg = context.createCGImage(output, from: output.extent)
////        else { return nil }
////        return UIImage(cgImage: cgimg)
////    }
////}
////
////// MARK: - Helper: Resize
////extension UIImage {
////    func resized(to targetSize: CGSize) -> UIImage {
////        let widthRatio = targetSize.width / size.width
////        let heightRatio = targetSize.height / size.height
////        let ratio = min(widthRatio, heightRatio)
////        let newSize = CGSize(width: size.width * ratio, height: size.height * ratio)
////        let renderer = UIGraphicsImageRenderer(size: newSize)
////        return renderer.image { _ in self.draw(in: CGRect(origin: .zero, size: newSize)) }
////    }
////}
//
//// MARK: - View
//struct FilterDemoView: View {
//    @StateObject private var vm = FilterDemoViewModel()
//
//    var body: some View {
//        NavigationView {
//            VStack {
//                // Preview Image
//                ZStack {
//                    if let img = vm.filteredImage {
//                        Image(uiImage: img)
//                            .resizable()
//                            .scaledToFit()
//                            .frame(height: 320)
//                            .cornerRadius(12)
//                            .transition(.opacity)
//                            .animation(.easeInOut(duration: 0.25), value: vm.filteredImage)
//                    } else {
//                        ProgressView().frame(height: 320)
//                    }
//                }
//                .padding(.top)
//
//                Divider().padding(.vertical, 8)
//
//                // Filter selector
//                ScrollView(.horizontal, showsIndicators: false) {
//                    HStack(spacing: 12) {
//                        ForEach(FilterType.allCases) { filter in
//                            VStack {
//                                if let thumb = vm.thumbnails[filter] {
//                                    Image(uiImage: thumb)
//                                        .resizable()
//                                        .scaledToFill()
//                                        .frame(width: 70, height: 70)
//                                        .cornerRadius(8)
//                                        .clipped()
//                                } else {
//                                    ProgressView().frame(width: 70, height: 70)
//                                }
//
//                                Text(filter.rawValue.replacingOccurrences(of: "CI", with: ""))
//                                    .font(.caption2)
//                                    .foregroundColor(vm.selectedFilter == filter ? .red : .primary)
//                            }
//                            .overlay(
//                                RoundedRectangle(cornerRadius: 8)
//                                    .stroke(vm.selectedFilter == filter ? Color.red : Color.clear, lineWidth: 2)
//                            )
//                            .onTapGesture {
//                                guard vm.selectedFilter != filter else { return }
//                                vm.selectedFilter = filter
//                                vm.applySelectedFilter(animated: true)
//                            }
//                        }
//                    }
//                    .padding(.horizontal)
//                }
//
//                Spacer()
//            }
//            .navigationTitle("CIFilter Demo (Cache)")
//        }
//    }
//}
//
//#Preview {
//    FilterDemoView()
//}
