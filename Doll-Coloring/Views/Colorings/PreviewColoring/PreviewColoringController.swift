//
//  PreviewColoringController.swift
//  Doll-Coloring
//
//  Created by Việt Anh Nguyễn on 10/04/2024.
//  
//

import Foundation
import RxSwift
import UIKit
import Lottie

class PreviewColoringController: BaseViewController {
    
    var viewModel: PreviewColoringVM!
    
    @IBOutlet weak var topBarView: TopBarView!
    
    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var animationPreview: LottieAnimationView!
    
    @IBOutlet weak var animationView: LottieAnimationView!
    
    private var coloringBookView: ColoringBookView!
    var context = CIContext(options: nil)
    var downloadManager = DownloadManager()
    
    override func setup() {
        super.setup()
        downloadManager.processDelegate = self
        setupTopBarView()
        setupView()
    }
    
    private func setupTopBarView() {
        topBarView.title = LocalizableUtils.commonStartColoring()
    }
    
    func setupView() {
        topBarView.titleFont = .systemFont(ofSize: 24, weight: .bold)
        animationView.loadAnimation(file: "animation_progess", loopMode: .loop)
        animationPreview.loadAnimation(file: "animation_loading_preview", loopMode: .loop, autoPlay: true, animationSpeed: 1.2)
        let preview = apiBaseUrl + "/doll-coloring2/canvas/" + (viewModel.coloring?.filePreview ?? "")
        if let coloring = viewModel.coloringLocal, let image = UIImage(contentsOfFile: FileManagerLocal.shared.getFileFoderFileUssing(typeFile: .Coloring, file:  coloring.fileLocal).path) {
            if let img = UIImage(contentsOfFile: FileManagerLocal.shared.getFileFoderFileUssing(typeFile: .ColoringSave, file:  viewModel.history?.imagePath ?? "").path) {
                imgView.image = img
            } else {
                imgView.setImage(with: preview, placeholder: nil)
            }
            self.createColoringBookView(with: image)
        } else {
            let path = apiBaseUrl + "/doll-coloring2/canvas/" + (viewModel.coloring?.filePath ?? "")
            imgView.setImage(with: preview, placeholder: nil)
            downloadImageColor(linkDowload: path)
        }
        blurEffect()
    }
    
    func blurEffect() {
        guard let currentFilter = CIFilter(name: "CIGaussianBlur") else {return}
        if let image  = imgView.image {
            guard let beginImage = CIImage(image: image) else {return}
            currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
            currentFilter.setValue(10, forKey: kCIInputRadiusKey)
            guard let cropFilter = CIFilter(name: "CICrop") else {return}
            cropFilter.setValue(currentFilter.outputImage, forKey: kCIInputImageKey)
            cropFilter.setValue(CIVector(cgRect: beginImage.extent), forKey: "inputRectangle")
            guard let output = cropFilter.outputImage else {return}
            guard let cgimg = context.createCGImage(output, from: output.extent) else {return}
            let processedImage = UIImage(cgImage: cgimg)
            imgView.image = processedImage
        }
    }

    
    func downloadImageColor(linkDowload: String) {
        downloadManager.coloringLocal = viewModel.coloringLocal
        downloadManager.isTheme = false
        let fileTo = FileManagerLocal.shared.getFileFoderFileUssing(typeFile: .Coloring)
        let indexName = FileManagerLocal.shared.getFileInDoucment(url: fileTo).sorted(by: {return ($0 as NSString).deletingPathExtension.compare(($1 as NSString).deletingPathExtension, options: .numeric) == .orderedAscending}).last?.replacingOccurrences(of: ".png", with: "")
        let fileName = fileTo.lastPathComponent + "\((Int(String(indexName?.extractNumbers() ?? "0")) ?? 0) + 1).png"
        downloadManager.fileTo = fileTo.appendingPathComponent(fileName)
        let completion = BlockOperation {
            /// Do something here when all of the download is done
            DispatchQueue.main.async {
                let file = SQLiteManager.shared.selectionColorings().first(where: {$0.fileLocal.contains(fileName)})
                self.viewModel.coloringLocal = file
                if let coloring = file, let img = UIImage(contentsOfFile: FileManagerLocal.shared.getFileFoderFileUssing(typeFile: .Coloring, file:  coloring.fileLocal).path) {
                    self.createColoringBookView(with: img)
                }
            }
        }
        if let url = URL(string: linkDowload) {
            let downloadOperation = downloadManager.addDownload(url)
            completion.addDependency(downloadOperation)
        }
        OperationQueue.main.addOperation(completion)
    }
    
    func createColoringBookView(with image:UIImage, optimized:Bool = true) {
        DispatchQueue.global(qos: .background).async{
            //Create the coloring image struct in a background thread
            let coloringImage = ColoringImageBook(from: image, optimized: optimized)
            //Once done return to the main thread
            DispatchQueue.main.async{
                //Create the Coloring Book View
                self.coloringBookView = ColoringBookView(coloringImage: coloringImage)
                self.dismissView(isDownloadSucceeded: true)
            }
        }
    }
    
}

extension PreviewColoringController: DownloadProcessProtocol {
    func downloadingProgress(_ percent: Float, fileName: String) {
    }
    
    func downloadSucceeded(_ fileName: String) {
        print(fileName)
    }
    
    func downloadWithError(_ error: Error?, fileName: String) {
        
    }
    
    func dismissView(isDownloadSucceeded: Bool) {
        self.imgView.image = nil
        AppRouter.shared.dismiss(animated: !isDownloadSucceeded) {
            if let coloring = self.viewModel.coloringLocal {
                AppRouter.shared.navigate(to: StartColoringRoute.startColoring(coloringLocal: coloring, history: self.viewModel.history, typeScreen: self.viewModel.typeScreen, coloringBookView: self.coloringBookView), with: .push)
            }
        }
    }
}
