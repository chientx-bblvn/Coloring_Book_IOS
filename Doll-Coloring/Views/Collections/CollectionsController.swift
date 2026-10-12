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
import SDWebImage

class CollectionsController: BaseViewController {
    
    var viewModel: CollectionsVM!
    
    @IBOutlet weak var topBarView: TopBarView!
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var viewEmpty: UIView!
    
    @IBOutlet weak var lbEmpty: UILabel!
    
    @IBOutlet weak var imgEmpty: UIImageView!
    
    @IBOutlet weak var btnStartColoring: UIButton!
    
    @IBOutlet weak var viewAds: UIView!
    
    @IBOutlet weak var viewHeightAds: NSLayoutConstraint!
    
    private var listCollection: [String] = []
    
    private var lisCompleted: [String] = []
    
    private var listNotCompleted: [String] = []
    
    private var listColoring: [ColoringHistoryModel] = []
    
    var navigate: Bool = false
    
    private var isLandscape: Bool = false
    
    override func setup() {
        super.setup()
        topBarView.titleFont = UIFont.systemFont(ofSize: 24, weight: .bold)
        
        segmentControl.selectedSegmentIndex = 0
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
        
        let dataFilter = filterImagePaths()
        lisCompleted = dataFilter.completed
        listNotCompleted = dataFilter.notCompleted
        updateDataColection()
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
    }
    
    
    
    @IBAction func segmentChanged(_ sender: Any) {
        updateDataColection()
    }
    
    func updateDataColection() {
        listColoring = SQLiteManager.shared.selectionColorings()
        listCollection = FileManagerLocal.shared.getFileColoringlocal()
        switch segmentControl.selectedSegmentIndex {
        case 0:
            listCollection = listNotCompleted
            collectionView.reloadData()
            viewEmpty.isHidden = !listCollection.isEmpty
            
        case 1:
            listCollection = lisCompleted
            collectionView.reloadData()
            viewEmpty.isHidden = !listCollection.isEmpty
        default:
            break
        }
    }
    
    func filterImagePaths() -> (completed: [String], notCompleted: [String]) {
        var completedImages: [String] = []
        var notCompletedImages: [String] = []
        
        for coloring in listColoring {
            for history in coloring.historys {
                let percent = ((history.percent_complete ?? 0) * 100).rounded()
                if percent >= 100 {
                    completedImages.append(history.imagePath)
                } else {
                    notCompletedImages.append(history.imagePath)
                }
            }
        }
        
        return (completedImages, notCompletedImages)
    }
    
    
}

extension CollectionsController {
    func loadLanguage() {
        topBarView.title = LocalizableUtils.commonCollections()
        lbEmpty.text = LocalizableUtils.commonEmptyCollections()
        btnStartColoring.setTitle(LocalizableUtils.commonStartColoring(), for: .normal)
        segmentControl.setTitle(LocalizableUtils.commonFinished(), forSegmentAt: 1)
        segmentControl.setTitle(LocalizableUtils.commonUnfinished(), forSegmentAt: 0)
    }
    
    func loadColapBanner() {
        viewAds.isHidden = true

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
        if let coloring = listColoring.first(where: { coloring in
            coloring.historys.contains(where: { $0.imagePath == listCollection[indexPath.row] })
        }) {
            if let lastHistory = coloring.historys.last {
                let percent = (lastHistory.percent_complete ?? 0) * 100
                cell.labelPercent.text = "\(Int(percent.rounded()))%"
            } else {
                cell.labelPercent.text = "0%"
            }
        } else {
            cell.labelPercent.text = "0%"
        }
        
        cell.navigateToDetail = {
            self.naviScreenColoring(fileName: data)
        }
        
        cell.trashButtonTapped = {
            DeleteColoringViewController.show(in: self) {
                
            } onclickDelete: {
                self.deleteColoring(fileName: data)
            }
            
        }
        return cell
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
        return CGSize(width: (Int(width) - 8) / 2, height: (Int(width) - 8) / 2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
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
    func deleteColoring(fileName: String) {
        if let index = listColoring.firstIndex(where: { coloring in
            coloring.historys.contains(where: { history in
                history.imagePath.contains(fileName)
            })
        }) {
            var coloring = listColoring[index]
            
            coloring.historys.removeAll { history in
                history.imagePath.contains(fileName)
            }

            FileManagerLocal.shared.deleteFile(typeFile: .Coloring, fileName: coloring.filePath)
            FileManagerLocal.shared.deleteFile(typeFile: .ColoringSave, fileName: fileName)
            
            if coloring.historys.isEmpty {
                SQLiteManager.shared.deleteColorings(id: coloring.id)
            } else {
                _ = SQLiteManager.shared.updateColorings(data: coloring)
            }
            
            listColoring.remove(at: index)

            listCollection.removeAll { $0 == fileName }
            
            let imageUrlString = FileManagerLocal.shared.getFileFoderFileUssing(typeFile: .ColoringSave, file: fileName)
            let cacheKey = SDWebImageManager.shared.cacheKey(for: imageUrlString)
            SDImageCache.shared.removeImage(forKey: cacheKey, withCompletion: nil)
            
            collectionView.reloadData()
            viewEmpty.isHidden = !listCollection.isEmpty
        }
    }
    
    func reloadDataColection() {
        listColoring = SQLiteManager.shared.selectionColorings()
        listCollection = FileManagerLocal.shared.getFileColoringlocal()
        viewEmpty.isHidden = !listCollection.isEmpty
        collectionView.reloadData()
    }
}
