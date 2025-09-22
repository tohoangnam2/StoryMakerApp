//import SwiftUI
//
////construct enum to decide which sheet to present:
//enum ActiveSheet: String, Identifiable { // <--- note that it's now Identifiable
//    case photoLibrary, shareSheet
//    var id: String {
//        return self.rawValue
//    }
//}
//
//struct ShareHomeView: View {
//    
//    @State private var shareCardAsImage: UIImage? = nil
//    
//    @State var activeSheet: ActiveSheet? = nil // <--- now an optional property
//    
//    var shareCard: some View {
//        ZStack {
//            VStack {
//                Spacer()
//                LinearGradient(
//                    gradient: Gradient(colors: [.black, .red]),
//                    startPoint: .topLeading,
//                    endPoint: .bottomTrailing
//                )
//                    .cornerRadius(10.0)
//                    .padding(.horizontal)
//                Spacer()
//            }
//            SubView()
//                .padding(.horizontal)
//            VStack {
//                HStack {
//                    HStack(alignment: .center) {
//                        Image(systemName: "gamecontroller")
//                            .resizable()
//                            .aspectRatio(contentMode: .fit)
//                            .frame(height: 40)
//                            .padding(.leading)
//                        VStack(alignment: .leading, spacing: 3) {
//                            Text("My App")
//                                .foregroundColor(.white)
//                                .font(.headline)
//                                .fontWeight(.bold)
//                            Text("Wed 30 Mar 22")
//                                .foregroundColor(.white)
//                                .font(.headline)
//                            // .fontWeight(.bold)
//                        }
//                    }
//                    Spacer()
//                }
//                .padding([.leading, .top])
//                Spacer()
//            }
//            
//        } //End of ZStack
//        .frame(height: 350)
//    }
//    var body: some View {
//        NavigationView {
//            VStack {
//                HStack {
//                    Spacer()
//                    Button {
//                        self.activeSheet = .photoLibrary
//                    } label: {
//                        Image(systemName: "photo")
//                            .resizable()
//                            .scaledToFit()
//                            .frame(height: 40)
//                    }
//                    .padding(.trailing)
//                }
//                //GeometryReader { geometry in
//                shareCard
//                // } //End of GeometryReader
//                Button(action: {
//                    
//                    shareCardAsImage = shareCard.asImage()
//                    self.activeSheet = .shareSheet
//                    
//                }) {
//                    HStack {
//                        Image(systemName: "square.and.arrow.up")
//                            .font(.system(size: 20))
//                        Text("Share")
//                            .font(.headline)
//                    }
//                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50, maxHeight: 50)
//                    .background(Color.blue)
//                    .foregroundColor(.white)
//                    .cornerRadius(20)
//                }
//                .padding(.horizontal)
//            } //End of Master VStack
//            //sheet choosing view to display based on selected enum value:
//            .sheet(item: $activeSheet) { sheet in // <--- sheet is of type ActiveSheet and lets you present the appropriate sheet based on which is active
//                switch sheet {
//                case .photoLibrary:
//                    Text("TODO")
//                case .shareSheet:
//                    if let unwrappedImage = shareCardAsImage {
//                        ShareSheet(photo: unwrappedImage)
//                    }
//                    
//                }
//            }
//            //Needed to Wrap in a Navigation View and hide title so that dark mode would work, otherwise this sheet was always in the iPhone's light or dark mode
//            .navigationBarHidden(true)
//            .navigationTitle("")
//        }
//    }
//}
//
//struct RecoveryShareHomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        ShareHomeView().preferredColorScheme(.dark)
//        ShareHomeView().preferredColorScheme(.light)
//    }
//}
//
//
//extension View {
//    func asImage() -> UIImage {
//        let controller = UIHostingController(rootView: self)
//        
//        // locate far out of screen
//        controller.view.frame = CGRect(x: 0, y: CGFloat(Int.max), width: 1, height: 1)
//        UIApplication.shared.windows.first!.rootViewController?.view.addSubview(controller.view)
//        
//        let size = controller.sizeThatFits(in: UIScreen.main.bounds.size)
//        controller.view.bounds = CGRect(origin: .zero, size: size)
//        controller.view.sizeToFit()
//        
//        let image = controller.view.asImage()
//        controller.view.removeFromSuperview()
//        return image
//    }
//}
//
//extension UIView {
//    func asImage() -> UIImage {
//        let renderer = UIGraphicsImageRenderer(bounds: bounds)
//        return renderer.image { rendererContext in
//            // [!!] Uncomment to clip resulting image
//            //             rendererContext.cgContext.addPath(
//            //                UIBezierPath(roundedRect: bounds, cornerRadius: 20).cgPath)
//            //            rendererContext.cgContext.clip()
//            
//            // As commented by @MaxIsom below in some cases might be needed
//            // to make this asynchronously, so uncomment below DispatchQueue
//            // if you'd same met crash
//            //            DispatchQueue.main.async {
//            layer.render(in: rendererContext.cgContext)
//            //            }
//        }
//    }
//}
//
//
//
//
//
//
//import LinkPresentation
//
//
////This code is from https://gist.github.com/tsuzukihashi/d08fce005a8d892741f4cf965533bd56
//
////struct ShareSheet: UIViewControllerRepresentable {
////    let photo: UIImage
////    
////    func makeUIViewController(context: Context) -> UIActivityViewController {
////        //let text = ""
////        //let itemSource = ShareActivityItemSource(shareText: text, shareImage: photo)
////        
////        let activityItems: [Any] = [photo]
////        
////        let controller = UIActivityViewController(
////            activityItems: activityItems,
////            applicationActivities: nil)
////        
////        return controller
////    }
////    
////    func updateUIViewController(_ vc: UIActivityViewController, context: Context) {
////        
////    }
////}
//
//
//
//struct SubView: View {
//    var body: some View {
//        HStack {
//            Image(systemName: "star")
//            Text("Test View")
//            Image(systemName: "star")
//        }
//        
//        
//    }
//}
