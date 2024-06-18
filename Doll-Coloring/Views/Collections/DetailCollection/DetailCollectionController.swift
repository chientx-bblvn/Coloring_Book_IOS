//
//  DetailCollectionController.swift
//  Doll-Coloring
//
//  Created by Việt Anh Nguyễn on 6/5/24.
//  
//

import Foundation
import RxSwift
import UIKit
import Photos
import SDWebImage

class DetailCollectionController: BaseViewController {
    
    var viewModel: DetailCollectionVM!
    
    @IBOutlet weak var topBarView: TopBarView!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var btnDelete: UIButton!
    
    @IBOutlet weak var btnSave: UIButton!
    
    @IBOutlet weak var btnEdit: UIButton!
    
    @IBOutlet weak var viewAds: UIView!
    
    
    
    override func setup() {
        super.setup()
        setupView()
        loadNativeAds()
        FirebaseEventManager.logEvent(with: RMBGEventTracking.collection_detail)
        ADManager.shared.preLoadReward(DollColoringAdID.reward_save)
    }

    override func bindingData() {
        super.bindingData()
    }
    
    private func setupView() {
        topBarView.title = LocalizableUtils.commonCollections().uppercased()
        topBarView.onLeftClick = {
            if self.viewModel.isCollection {
                AppRouter.shared.popToController(controller: TabbarViewController.classForCoder())
            } else {
                AppRouter.shared.popToController(controller: TabbarViewController.classForCoder())
            }
        }
        if IAPState.isUserVip {
            btnSave.setImage(nil, for: .normal)
        }
        topBarView.titleFont = UIFont.systemFont(ofSize: 20, weight: .bold)
        imageView.setLocalImage(with: FileManagerLocal.shared.getFileFoderFileUssing(typeFile: .ColoringSave, file: viewModel.history?.imagePath ?? "").path, placeholder: nil)
    }
    
    
    @IBAction func actionDelete(_ sender: Any) {
        DeleteColoringViewController.show(in: self) {
        
        } onclickDelete: {
            self.deleteColoring()
        }
    }
    
    @IBAction func actionSave(_ sender: Any) {
        checkPhotoLibraryPermission()
    }
    
    @IBAction func actionEdit(_ sender: Any) {
        loadInterADSEdit()
    }
    
    func deleteColoring() {
        let coloring = viewModel.coloringLocal
        guard let history = viewModel.history else {
            if viewModel.isCollection {
                AppRouter.shared.popToController(controller: TabbarViewController.classForCoder())
            } else {
                AppRouter.shared.popToController(controller: TabbarViewController.classForCoder())
            }
            return
        }
        FirebaseEventManager.logEvent(with: RMBGEventTracking.collection_detele)
        if coloring.historys.count == 1 {
            SQLiteManager.shared.deleteColorings(id: coloring.id)
            FileManagerLocal.shared.deleteFile(typeFile: .ColoringSave, fileName: history.imagePath)
            FileManagerLocal.shared.deleteFile(typeFile: .Coloring, fileName: coloring.filePath)
        } else {
            var newHis = coloring.historys
            newHis.removeAll(where: {$0.imagePath == history.imagePath})
            let historys = ColoringHistoryModel(id: coloring.id, filePath: coloring.filePath, fileLocal: coloring.fileLocal, historys: newHis)
            _ = SQLiteManager.shared.updateColorings(data: historys)
            FileManagerLocal.shared.deleteFile(typeFile: .ColoringSave, fileName: history.imagePath)
        }
        if viewModel.isCollection {
            AppRouter.shared.popToController(controller: TabbarViewController.classForCoder())
        } else {
            AppRouter.shared.popToController(controller: TabbarViewController.classForCoder())
        }
        let local = FileManagerLocal.shared.getFileColoringlocalURL()
        local.forEach { url in
            let cacheKey = SDWebImageManager.shared.cacheKey(for: url)
            SDImageCache.shared.removeImage(forKey: cacheKey, withCompletion: nil)
        }
    }
    
    func checkPhotoLibraryPermission() {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            //handle authorized status
            DispatchQueue.main.async {
                DispatchQueue.main.async {
                    self.checkVip()
                }
            }
        case .denied, .restricted :
            DispatchQueue.main.async {
                self.createMyAlert(title: LocalizableUtils.title_open_library(), LocalizableUtils.message_open_libary()) {
                    DispatchQueue.main.async {
                        self.gotoSettings()
                    }
                }
            }
        case .notDetermined:
            // ask for permissions
            PHPhotoLibrary.requestAuthorization { status in
                switch status {
                case .authorized:
                    DispatchQueue.main.async {
                        DispatchQueue.main.async {
                            self.checkVip()
                        }
                    }
                case .limited:
                    DispatchQueue.main.async {
                        DispatchQueue.main.async {
                            self.checkVip()
                        }
                    }
                case .notDetermined:
                    break
                case .restricted:
                    break
                case .denied:
                    break
                @unknown default:
                    break
                }
            }
        case .limited:
            DispatchQueue.main.async {
                self.checkVip()
            }
        @unknown default:
            break
        }
    }
    
    private func gotoSettings() {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString),
              UIApplication.shared.canOpenURL(settingsUrl) else { return }
        UIApplication.shared.open(settingsUrl, options: [:])
    }
    
    private func checkVip() {
        if IAPState.isUserVip {
            savePhotosAlbum()
        } else {
            PopupSaveColoringViewController.show(in: self) {
                
            } onclickDelete: {
                DispatchQueue.main.async {
                    self.loadAdsView()
                }
            }
        }
    }
    
    func loadInterAds() {
        ADManager.shared.loadFull(DollColoringAdID.inter_save, isSplash: true) {[weak self] status in
            switch status {
            case .closed, .error:
                self?.savePhotosAlbum()
            default:
                break
            }
        }
    }
    
    func loadInterADSEdit() {
        ADManager.shared.loadFull(DollColoringAdID.inter_edit_collection, isSplash: true) {[weak self] status in
            switch status {
            case .closed, .error:
                self?.editColoring()
            default:
                break
            }
        }
    }
    
    func loadAdsView() {
        ADManager.shared.loadReward(DollColoringAdID.reward_save) {[weak self] status in
            switch status {
            case .closed:
                self?.savePhotosAlbum()
            case .error:
                self?.loadInterAds()
            default:
                break
            }
        }
    }
    
    func loadNativeAds() {
        ADManager.shared.loadNative(DollColoringAdID.native_result, to: viewAds) {[weak self] adId, success, nativeAdView in
            self?.viewAds.isHidden = !success
        }
    }
    
    func savePhotosAlbum() {
        if let image = imageView.image {
            FirebaseEventManager.logEvent(with: RMBGEventTracking.collection_save)
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        }
    }
    
    //MARK: - Add image to Library
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if error != nil {
            // we got back an error!
            showAlertWith(title: LocalizableUtils.commonSave(), message: LocalizableUtils.save_picture_fail())
        } else {
            showAlertWith(title: LocalizableUtils.commonSave(), message: LocalizableUtils.save_picture_success())
        }
    }
    
    func showAlertWith(title: String, message: String){
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: {_ in
            DispatchQueue.main.async {
                if self.viewModel.isCollection {
                    AppRouter.shared.popToController(controller: TabbarViewController.classForCoder())
                } else {
                    AppRouter.shared.popToController(controller: TabbarViewController.classForCoder())
                }
            }
        }))
        present(ac, animated: true)
    }
    
    func editColoring() {
        let history = viewModel.history
        let coloring = viewModel.coloringLocal
        let imageUrlString = FileManagerLocal.shared.getFileFoderFileUssing(typeFile: .ColoringSave, file: history?.imagePath ?? "")
        let cacheKey = SDWebImageManager.shared.cacheKey(for: imageUrlString)
        FirebaseEventManager.logEvent(with: RMBGEventTracking.collection_edit)
        SDImageCache.shared.removeImage(forKey: cacheKey, withCompletion: nil)
        AppRouter.shared.navigate(to: PreviewColoringRoute.main(coloring: nil, coloringLocal: coloring, history: history, typeScreen: .collection), with: .push)
    }
    
}
