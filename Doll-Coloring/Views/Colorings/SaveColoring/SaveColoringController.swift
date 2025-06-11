//
//  SaveColoringController.swift
//  Doll-Coloring
//
//  Created by Việt Anh Nguyễn on 10/04/2024.
//
//

import Foundation
import RxSwift
import UIKit
import Photos
import AdmobSDK

class SaveColoringController: BaseViewController {
    
    var viewModel: SaveColoringVM!
    
    @IBOutlet weak var btnShare: UIButton!
    
    @IBOutlet weak var btnClose: UIButton!
    
    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var lbNameApp: UILabel!
    
    @IBOutlet weak var btnDelete: UIButton!
    
    @IBOutlet weak var btnSave: UIButton!
    
    @IBOutlet weak var btnCollection: UIButton!
    
    @IBOutlet weak var viewAds: UIView!
    
    override func setup() {
        super.setup()
        setupView()
        ADManager.shared.preLoadReward(DollColoringAdID.reward_save)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadNativeAds()
    }
    
    override func bindingData() {
        super.bindingData()
    }
    
    private func setupView() {
        imgView.image = viewModel.imageColoring
        lbNameApp.text = Bundle.main.applicationName
        btnDelete.setTitle(LocalizableUtils.commonDelete(), for: .normal)
        btnSave.setTitle(LocalizableUtils.commonSave(), for: .normal)
        btnCollection.setTitle(LocalizableUtils.commonCollections(), for: .normal)
        if IAPState.isUserVip {
            btnSave.setImage(nil, for: .normal)
        }
    }
    
    @IBAction func actionShare(_ sender: Any) {
        
        showActivityController()
    }
    
    @IBAction func actionDismis(_ sender: Any) {
        switch viewModel.typeScreen {
        case .home:
            AppRouter.shared.popToController(controller: TabbarViewController.classForCoder())
        case .coloring:
            AppRouter.shared.popToController(controller: MainColoringsController.classForCoder())
        case .detailColoring:
            AppRouter.shared.popToController(controller: DetailColoringController.classForCoder())
        case .collection:
            AppRouter.shared.popToController(controller: TabbarViewController.classForCoder())
        }
    }
    
    @IBAction func actionDelete(_ sender: Any) {
        deleteColoring()
    }
    
    @IBAction func actionSave(_ sender: Any) {
        checkPhotoLibraryPermission()
    }
    
    @IBAction func actionCollection(_ sender: Any) {
        FirebaseEventManager.logEvent(with: RMBGEventTracking.colletion_coloring_screen)
        AppRouter.shared.navigate(to: CollectionsRoute.main(), with: .push)
    }
}

extension SaveColoringController {
    
    func showActivityController() {
        // Setting description
        let firstActivityItem = Bundle.main.applicationName ?? "Brainrot Coloring"
        
        // Setting url
        let imageToShare = [viewModel.imageColoring, firstActivityItem] as [Any]
        
        let activityViewController : UIActivityViewController = UIActivityViewController(
            activityItems: imageToShare, applicationActivities: nil)
        
        // Pre-configuring activity items
        activityViewController.activityItemsConfiguration = [
            UIActivity.ActivityType.message
        ] as? UIActivityItemsConfigurationReading
        
        // Anything you want to exclude
        activityViewController.excludedActivityTypes = [
            UIActivity.ActivityType.saveToCameraRoll,
            UIActivity.ActivityType.airDrop
            
        ]
        
        if DeviceInfos.isIpad() {
            if let view = btnShare ?? self.view {
                activityViewController.popoverPresentationController?.sourceView = view
                activityViewController.popoverPresentationController?.sourceRect = view.bounds
            }
        }
        FirebaseEventManager.logEvent(with: RMBGEventTracking.share_coloring_screen)
        activityViewController.isModalInPresentation = true
        DispatchQueue.main.async {
            self.present(activityViewController, animated: true, completion: nil)
        }
    }
    
    func deleteColoring() {
        FirebaseEventManager.logEvent(with: RMBGEventTracking.delete_coloring_screen)
        let coloring = viewModel.coloringLocal
        guard let history = viewModel.history else {
            switch viewModel.typeScreen {
            case .home:
                AppRouter.shared.popToController(controller: TabbarViewController.classForCoder())
            case .coloring:
                AppRouter.shared.popToController(controller: MainColoringsController.classForCoder())
            case .detailColoring:
                AppRouter.shared.popToController(controller: DetailColoringController.classForCoder())
            case .collection:
                AppRouter.shared.popToController(controller: TabbarViewController.classForCoder())
            }
            return
        }
        if coloring.historys.count == 1 {
            SQLiteManager.shared.deleteColorings(id: coloring.id)
            FileManagerLocal.shared.deleteFile(typeFile: .ColoringSave, fileName: history.imagePath)
            FileManagerLocal.shared.deleteFile(typeFile: .Coloring, fileName: coloring.fileLocal)
        } else {
            var newHis = coloring.historys
            newHis.removeAll(where: {$0.imagePath == history.imagePath})
            let historys = ColoringHistoryModel(id: coloring.id, filePath: coloring.filePath, fileLocal: coloring.fileLocal, historys: newHis)
            _ = SQLiteManager.shared.updateColorings(data: historys)
            FileManagerLocal.shared.deleteFile(typeFile: .ColoringSave, fileName: history.imagePath)
        }
        switch viewModel.typeScreen {
        case .home:
            AppRouter.shared.popToController(controller: TabbarViewController.classForCoder())
        case .coloring:
            AppRouter.shared.popToController(controller: MainColoringsController.classForCoder())
        case .detailColoring:
            AppRouter.shared.popToController(controller: DetailColoringController.classForCoder())
        case .collection:
            AppRouter.shared.popToController(controller: TabbarViewController.classForCoder())
        }
    }
    
    func checkPhotoLibraryPermission() {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            //handle authorized status
            DispatchQueue.main.async {
                self.checkVip()
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
                        self.checkVip()
                    }
                case .limited:
                    DispatchQueue.main.async {
                        self.checkVip()
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
    
//    func loadInterAds() {
//        guard DollColoringAdID.inter_save.isEnableAd else {
//            self.savePhotosAlbum()
//            return
//        }
//
//        AdLoadingView.show()
//        ADManager.shared.loadFull(DollColoringAdID.inter_save, isSplash: true) { status in
//            AdLoadingView.dismiss()
//            switch status {
//            case .closed, .error:
//                DispatchQueue.main.async {
//                    self.savePhotosAlbum()
//                }
//            default:
//                break
//            }
//        }
//    }
    
    func loadAdsView() {
        ADManager.shared.loadReward(DollColoringAdID.reward_save) {[weak self] status in
            switch status {
            case .closed, .success:
                self?.savePhotosAlbum()
            case .error:
                print("reward save error")
            default:
                break
            }
        }
    }
    
    func loadNativeAds() {
        viewAds.isHidden = false
        ADManager.shared.loadNative(DollColoringAdID.native_result, to: viewAds, refreshAd: true, nativeAdType: .customMediaFixedHeight) {[weak self] adId, success, nativeAdView in
            self?.viewAds.isHidden = !success
        }
    }
    
    func savePhotosAlbum() {
        let image = viewModel.imageColoring
        FirebaseEventManager.logEvent(with: RMBGEventTracking.save_coloring_screen)
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
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
        ac.addAction(UIAlertAction(title: LocalizableUtils.commonOK(), style: .default, handler: {_ in
            DispatchQueue.main.async {
                switch self.viewModel.typeScreen {
                case .home:
                    AppRouter.shared.popToController(controller: TabbarViewController.classForCoder())
                case .coloring:
                    AppRouter.shared.popToController(controller: MainColoringsController.classForCoder())
                case .detailColoring:
                    AppRouter.shared.popToController(controller: DetailColoringController.classForCoder())
                case .collection:
                    AppRouter.shared.popToController(controller: TabbarViewController.classForCoder())
                }
            }
        }))
        present(ac, animated: true)
    }
}
