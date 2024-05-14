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
    
    @IBOutlet weak var btnDelete: UIButton!
    
    @IBOutlet weak var btnSave: UIButton!
    
    @IBOutlet weak var btnCollection: UIButton!
    
    @IBOutlet weak var viewAds: UIView!
    
    override func setup() {
        super.setup()
        setupView()
        loadNativeAds()
    }
    
    override func bindingData() {
        super.bindingData()
    }
    
    private func setupView() {
        imgView.image = viewModel.imageColoring
        btnDelete.setTitle(LocalizableUtils.commonDelete(), for: .normal)
        btnSave.setTitle(LocalizableUtils.commonSave(), for: .normal)
        btnCollection.setTitle(LocalizableUtils.commonCollections(), for: .normal)
    }
    
    @IBAction func actionShare(_ sender: Any) {
        showActivityController()
    }
    
    @IBAction func actionDismis(_ sender: Any) {
        AppRouter.shared.dismissDetail()
    }
    
    @IBAction func actionDelete(_ sender: Any) {
        deleteColoring()
    }
    
    @IBAction func actionSave(_ sender: Any) {
        checkPhotoLibraryPermission()
    }
    
    @IBAction func actionCollection(_ sender: Any) {
        AppRouter.shared.navigate(to: CollectionsRoute.main, with: .push)
    }
}

extension SaveColoringController {
    
    func showActivityController() {
        // Setting description
        let firstActivityItem = "Doll Coloring"
        
        // Setting url
        let imageToShare = [ viewModel.imageColoring ]
        
        let activityViewController : UIActivityViewController = UIActivityViewController(
            activityItems: [firstActivityItem, imageToShare], applicationActivities: nil)
        
        // This lines is for the popover you need to show in iPad
        activityViewController.popoverPresentationController?.sourceView = self.view
        
        // This line remove the arrow of the popover to show in iPad
        activityViewController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.down
        activityViewController.popoverPresentationController?.sourceRect = CGRect(x: 150, y: 150, width: 0, height: 0)
        
        // Pre-configuring activity items
        activityViewController.activityItemsConfiguration = [
            UIActivity.ActivityType.message
        ] as? UIActivityItemsConfigurationReading
        
        // Anything you want to exclude
        activityViewController.excludedActivityTypes = [
            UIActivity.ActivityType.postToWeibo,
            UIActivity.ActivityType.print,
            UIActivity.ActivityType.assignToContact,
            UIActivity.ActivityType.saveToCameraRoll,
            UIActivity.ActivityType.addToReadingList,
            UIActivity.ActivityType.postToFlickr,
            UIActivity.ActivityType.postToVimeo,
            UIActivity.ActivityType.postToTencentWeibo,
            UIActivity.ActivityType.postToFacebook,
            UIActivity.ActivityType.copyToPasteboard,
            UIActivity.ActivityType.airDrop
            
        ]
        
        activityViewController.isModalInPresentation = true
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    func deleteColoring() {
        let coloring = viewModel.coloringLocal
        guard let history = viewModel.history else {
            switch viewModel.typeScreen {
            case .home:
                AppRouter.shared.popToController(controller: HomeController.classForCoder())
            case .coloring:
                AppRouter.shared.popToController(controller: MainColoringsController.classForCoder())
            case .detailColoring:
                AppRouter.shared.popToController(controller: DetailColoringController.classForCoder())
            case .collection:
                AppRouter.shared.popToController(controller: CollectionsController.classForCoder())
            }
            return
        }
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
        switch viewModel.typeScreen {
        case .home:
            AppRouter.shared.popToController(controller: HomeController.classForCoder())
        case .coloring:
            AppRouter.shared.popToController(controller: MainColoringsController.classForCoder())
        case .detailColoring:
            AppRouter.shared.popToController(controller: DetailColoringController.classForCoder())
        case .collection:
            AppRouter.shared.popToController(controller: CollectionsController.classForCoder())
        }
    }
    
    func checkPhotoLibraryPermission() {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            //handle authorized status
            DispatchQueue.main.async {
                self.loadAdsView()
            }
        case .denied, .restricted :
            DispatchQueue.main.async {
                self.createMyAlert(title: LocalizableUtils.title_open_library(), LocalizableUtils.message_open_libary()) {
                    self.gotoSettings()
                }
            }
        case .notDetermined:
            // ask for permissions
            PHPhotoLibrary.requestAuthorization { status in
                switch status {
                case .authorized:
                    DispatchQueue.main.async {
                        self.loadAdsView()
                    }
                case .limited:
                    DispatchQueue.main.async {
                        self.loadAdsView()
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
                self.loadAdsView()
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
    
    func loadAdsView() {
        ADManager.shared.loadFull(DollColoringAdID.inter_save) {[weak self] status in
            switch status {
            case .closed, .error:
                self?.savePhotosAlbum()
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
        let image = viewModel.imageColoring
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
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: {_ in
            DispatchQueue.main.async {
                switch self.viewModel.typeScreen {
                case .home:
                    AppRouter.shared.popToController(controller: HomeController.classForCoder())
                case .coloring:
                    AppRouter.shared.popToController(controller: MainColoringsController.classForCoder())
                case .detailColoring:
                    AppRouter.shared.popToController(controller: DetailColoringController.classForCoder())
                case .collection:
                    AppRouter.shared.popToController(controller: CollectionsController.classForCoder())
                }
            }
        }))
        present(ac, animated: true)
    }
}
