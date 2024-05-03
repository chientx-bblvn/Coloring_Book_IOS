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
    
    override func setup() {
        super.setup()
        viewAnimation.loadAnimation(file: "animation_collection", loopMode: .loop, autoPlay: true)
        topBarView.title = LocalizableUtils.commonCollections().uppercased()
        topBarView.titleFont = UIFont.systemFont(ofSize: 20, weight: .bold)
        topBarView.onLeftClick = {
            AppRouter.shared.dismissDetail()
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
        loadAdsNative()
    }
    
    func setupCollectionView() {
        collectionView.register(cellType: CollectionCell.self)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    @IBAction func actionStartColoring(_ sender: Any) {
        AppRouter.shared.navigate(to: MainColoringsRoute.main, with: .push)
    }
    
    func loadAdsNative() {
        viewHeightAds.constant = 60
        ADManager.shared.loadCollapsibleBannerAdaptive(DollColoringAdID.banner_collection, viewBanner: viewAds, isCollapsible: true) {[weak self] success in
            self?.viewHeightAds.constant = success ? 60 : 0
            self?.viewAds.isHidden = !success
        }
    }
}

extension CollectionsController {
    func loadLanguage() {
        topBarView.title = LocalizableUtils.commonCollections().uppercased()
        lbEmpty.text = LocalizableUtils.commonEmptyCollections()
        btnStartColoring.setTitle(LocalizableUtils.commonStartColoring(), for: .normal)
    }
    
    func loadColapBanner() {
        ADManager.shared.loadCollapsibleBannerAdaptive(DollColoringAdID.banner_collection, viewBanner: viewAds) {[weak self] success in
            self?.viewAds.isHidden = !success
            self?.viewHeightAds.constant = success ? 56 : 0
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
        cell.onclickEdit = {
            self.editColoring(fileName: data)
        }
        
        cell .onclickDelete = {
            DeleteColoringViewController.show(in: self) {
            
            } onclickDelete: {
                self.deteleColoring(fileName: data)
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 40) / 2
        return CGSize(width: width, height: width * 1.2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func editColoring(fileName: String) {
        if let coloring = listColoring.first (where: { coloring in
            coloring.historys.contains { history in
                fileName.contains(history.imagePath)
            }
        }) {
            let history = coloring.historys.first(where: { model in
                fileName.contains(model.imagePath)})
            let imageUrlString = FileManagerLocal.shared.getFileFoderFileUssing(typeFile: .ColoringSave, file: history?.imagePath ?? "")
            let cacheKey = SDWebImageManager.shared.cacheKey(for: imageUrlString)
            SDImageCache.shared.removeImage(forKey: cacheKey, withCompletion: nil)
            AppRouter.shared.navigate(to: PreviewColoringRoute.main(coloring: nil, coloringLocal: coloring, history: history, isCollection: true), with: .push)
        }
    }
    
    func deteleColoring(fileName: String) {
        if let coloring = listColoring.first (where: { coloring in
            coloring.historys.contains { history in
                fileName.contains(history.imagePath)
            }
        }) {
            if coloring.historys.count == 1 {
                let imageUrlString = FileManagerLocal.shared.getFileFoderFileUssing(typeFile: .ColoringSave, file: coloring.historys.first?.imagePath ?? "")
                let cacheKey = SDWebImageManager.shared.cacheKey(for: imageUrlString)
                SDImageCache.shared.removeImage(forKey: cacheKey, withCompletion: nil)
                SQLiteManager.shared.deleteColorings(id: coloring.id)
                FileManagerLocal.shared.deleteFile(typeFile: .Coloring, fileName: coloring.fileLocal)
                FileManagerLocal.shared.deleteFile(typeFile: .ColoringSave, fileName: coloring.historys.first?.imagePath ?? "")
            } else {
                if let history =  coloring.historys.first(where: { model in
                    fileName.contains(model.imagePath)
                }) {
                    var newHis = coloring.historys
                    newHis.removeAll(where: {$0.imagePath == history.imagePath})
                    let imageUrlString = FileManagerLocal.shared.getFileFoderFileUssing(typeFile: .ColoringSave, file: history.imagePath)
                    let cacheKey = SDWebImageManager.shared.cacheKey(for: imageUrlString)
                    SDImageCache.shared.removeImage(forKey: cacheKey, withCompletion: nil)
                    FileManagerLocal.shared.deleteFile(typeFile: .ColoringSave, fileName: history.imagePath)
                    let historys = ColoringHistoryModel(id: coloring.id, filePath: coloring.filePath, fileLocal: coloring.fileLocal, historys: newHis)
                    SQLiteManager.shared.updateColorings(data: historys)
                }
            }
        }
        reloadDataColection()
    }
    
    func reloadDataColection() {
        listColoring = SQLiteManager.shared.selectionColorings()
        listCollection = FileManagerLocal.shared.getFileColoringlocal()
        viewEmpty.isHidden = !listCollection.isEmpty
        collectionView.reloadData()
    }
}
