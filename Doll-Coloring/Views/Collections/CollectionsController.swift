//
//  CollectionsController.swift
//  Doll-Coloring
//
//  Created by Việt Anh Nguyễn on 10/04/2024.
//  
//

import Foundation
import RxSwift
import UIKit
import Lottie
import AdmobSDK
import SDWebImage

class CollectionsController: BaseViewController {
    
    var viewModel: CollectionsVM!
    
    @IBOutlet weak var topBarView: TopBarView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var viewEmpty: UIView!
    
    @IBOutlet weak var lbEmpty: UILabel!
    
    @IBOutlet weak var viewAnimation: LottieAnimationView!

    @IBOutlet weak var btnStartColoring: UIButton!
    
    @IBOutlet weak var viewAds: UIView!
    
    @IBOutlet weak var viewHeightAds: NSLayoutConstraint!
    
    private var listCollection: [String] = []
    
    private var listColoring: [ColoringHistoryModel] = []
    
    var navigate: Bool = false
    
    private var isLandscape: Bool = false
    
    override func setup() {
        super.setup()
        viewAnimation.loadAnimation(file: "animation_collection", loopMode: .loop, autoPlay: true)
        topBarView.title = ""
        topBarView.titleFont = UIFont.systemFont(ofSize: 24, weight: .bold)
        if navigate {
            topBarView.title = LocalizableUtils.commonCollections().uppercased()
            topBarView.leftIcon = R.image.ic_back()
            topBarView.textAlignmentCenter = true
        } else {
            settingIAP()
        }
        topBarView.onLeftClick = {
            self.topBarView.textAlignmentCenter = false
            AppRouter.shared.dismissDetail()
        }
        
        topBarView.onClickPremium = {
            SubcriptionViewController.show(checkTime: true) {
                
            }
        }
        
        topBarView.onRightClick = {
            self.showSettingView()
        }
        setupCollectionView()
        loadLanguage()
    }

    override func bindingData() {
        super.bindingData()
    }
    
    override func onLanguageChange() {
        super.onLanguageChange()
        loadLanguage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        reloadDataColection()
        updateLayoutContent()
        if navigate {
            loadColapBanner()
        }
        
    }
    
    private func settingIAP() {
        InappManager.share.didPaymentSuccess.subscribe(onNext: { [weak self] _ in
            self?.topBarView.showPremium = IAPState.isUserVip
        }).disposed(by: disposeBag)
    }
    
    override func updateMorePortrait() {
        super.updateMorePortrait()
        updateLayoutContent()
    }
    
    override func updateMoreLandscape() {
        super.updateMoreLandscape()
        updateLayoutContent()
    }
    
    private func updateLayoutContent() {
        let rotation = UIApplication.shared.windows.first?.windowScene?.interfaceOrientation
        switch rotation {
        case .unknown:
            break
        case .portrait, .portraitUpsideDown:
            isLandscape = false
            collectionView.reloadData()
        case .landscapeLeft, .landscapeRight:
            isLandscape = true
            collectionView.reloadData()
        default:
            break
        }
    }
    
    func setupCollectionView() {
        collectionView.register(cellType: CollectionCell.self)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    @IBAction func actionStartColoring(_ sender: Any) {
        FirebaseEventManager.logEvent(with: RMBGEventTracking.collection_start_coloring)
        NotificationCenter.default.post(name: NSNotification.Name("GOTOHOME_TABBAR"), object: nil)
//        AppRouter.shared.navigate(to: MainColoringsRoute.main, with: .push)
    }
    
}

extension CollectionsController {
    func loadLanguage() {
        topBarView.title = LocalizableUtils.commonCollections().uppercased()
        lbEmpty.text = LocalizableUtils.commonEmptyCollections()
        btnStartColoring.setTitle(LocalizableUtils.commonStartColoring(), for: .normal)
    }
    
    func loadColapBanner() {
        viewAds.isHidden = false
        viewHeightAds.constant = DeviceInfos.isIpad() ? 90 : 56
        ADManager.shared.loadBanner(DollColoringAdID.banner_collection, viewBanner: viewAds) {[weak self] success in
            self?.viewAds.isHidden = !success
            if DeviceInfos.isIpad() {
                self?.viewHeightAds.constant = success ? 90 : 0
            } else {
                self?.viewHeightAds.constant = success ? 56 : 0
            }
           
        }
    }
}

extension CollectionsController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        listCollection.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: CollectionCell.self)
        let data = listCollection[indexPath.row]
        cell.imageView.setLocalImage(with: FileManagerLocal.shared.getFileFoderFileUssing(typeFile: .ColoringSave, file: data).path, placeholder: nil)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = listCollection[indexPath.row]
        naviScreenColoring(fileName: data)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 32)
        if UIDevice.current.userInterfaceIdiom == .pad {
            if isLandscape {
                return CGSize(width: (Int(width) - 42) / 5, height: Int(width / 5))
            } else {
                return CGSize(width: (Int(width) - 34) / 4, height: Int(width / 4))
            }
        }
        return CGSize(width: (Int(width) - 8) / 2, height: Int(width / 2))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func naviScreenColoring(fileName: String) {
        if let coloring = listColoring.first (where: { coloring in
            coloring.historys.contains { history in
                history.imagePath.contains(fileName)
            }
        }), let history = coloring.historys.first(where: { model in
            fileName.contains(model.imagePath)}) {
            
            let imageUrlString = FileManagerLocal.shared.getFileFoderFileUssing(typeFile: .ColoringSave, file: history.imagePath)
            let cacheKey = SDWebImageManager.shared.cacheKey(for: imageUrlString)
            SDImageCache.shared.removeImage(forKey: cacheKey, withCompletion: nil)
            AppRouter.shared.navigate(to: DetailCollectionRoute.main(coloringLocal: coloring, history: history, isCollection: true), with: .push)
        }
    }
    
    func reloadDataColection() {
        listColoring = SQLiteManager.shared.selectionColorings()
        listCollection = FileManagerLocal.shared.getFileColoringlocal()
        viewEmpty.isHidden = !listCollection.isEmpty
        collectionView.reloadData()
    }
}
