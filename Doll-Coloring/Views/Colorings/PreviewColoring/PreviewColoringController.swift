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

class PreviewColoringController: BaseViewController {
    
    var viewModel: PreviewColoringVM!
    
    @IBOutlet weak var topBarView: TopBarView!
    
    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var viewLoading: UIView!
    
    @IBOutlet weak var progressView: UIProgressView!
    
    private var times: Timer?
    private var currentTime: Double = 0
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
        if let coloring = viewModel.coloringLocal {
            imgView.setLocalImage(with: FileManagerLocal.shared.getFileFoderFileUssing(typeFile: .Coloring, file:  coloring.fileLocal).path, placeholder: nil)
            startTime()
        } else {
            let path = apiBaseUrl + "/doll-coloring/" + (viewModel.coloring?.filePath ?? "")
            imgView.setImage(with: path, placeholder: nil)
            downloadImageColor(linkDowload: path)
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
                self.dismissView(isDownloadSucceeded: true)
            }
        }
        if let url = URL(string: linkDowload) {
            let downloadOperation = downloadManager.addDownload(url)
            completion.addDependency(downloadOperation)
        }
        OperationQueue.main.addOperation(completion)
    }
    
    func startTime() {
        times = Timer.scheduledTimer(timeInterval: 0.01,
                                           target: self,
                                           selector: #selector(advanceTimePlayer(timer:)),
                                           userInfo: nil,
                                           repeats: true)
        RunLoop.main.add(times!, forMode: RunLoop.Mode.common)
    }
    
    @objc private func advanceTimePlayer(timer: Timer) {
        currentTime = roundNumber(num: currentTime + 0.01)
        progressView.setProgress(Float(currentTime), animated: true)
        if currentTime >= 0.8 {
            endTime()
        }
    }
    
    func endTime() {
        times?.invalidate()
        times = nil
        dismissView(isDownloadSucceeded: true)
    }
    
    func roundNumber(num : Double) -> Double {
        let number = round(num * 100) / 100
        return number
    }
}

extension PreviewColoringController: DownloadProcessProtocol {
    func downloadingProgress(_ percent: Float, fileName: String) {
        progressView.setProgress(percent, animated: true)
    }
    
    func downloadSucceeded(_ fileName: String) {
        print(fileName)
    }
    
    func downloadWithError(_ error: Error?, fileName: String) {
        
    }
    
    func dismissView(isDownloadSucceeded: Bool) {
        AppRouter.shared.dismiss(animated: !isDownloadSucceeded) {
            self.imgView.image = nil
            if let coloring = self.viewModel.coloringLocal {
                AppRouter.shared.navigate(to: StartColoringRoute.main(coloringLocal: coloring, history: self.viewModel.history, isCollection: self.viewModel.isCollection), with: .push)
            }
        }
    }
}
