//
//  HomeController.swift
//  Doll-Coloring
//
//  Created by Việt Anh Nguyễn on 08/04/2024.
//  
//

import Foundation
import RxSwift
import UIKit
import AdmobSDK

class HomeController: BaseViewController {
    
    var viewModel: HomeVM!
    
    @IBOutlet weak var topbarView: TopBarView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let collectionViewHeaderFooterReuseIdentifier = "HeaderHomeCell"
    private var coloringLocal: [ColoringHistoryModel] = []
    var isShowAds: Bool = true
    var numberClick = 0
    
    private var typeHome = TypeHome.allCases
    
    var coloring: ColoringModel?

    override func setup() {
        super.setup()
        topbarView.titleFont = UIFont.systemFont(ofSize: 24, weight: .bold)
        topbarView.onRightClick = {
            self.showSettingView()
        }
        enableAudioBackground()
        loadLanguage()
        setupView()
        
        let archiveFiles = ArchiveFileLocal.allCases
        
        for file in archiveFiles {
            if !FileManagerLocal.shared.checkFileExits(typeFile: file, fileName: "") {
                FileManagerLocal.shared.createFolderManager(fileName: file.rawValue)
            }
        }
        ADManager.shared.preLoadReward(DollColoringAdID.reward_alltopic)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        coloringLocal = SQLiteManager.shared.selectionColorings()
        collectionView.reloadData()
    }
    
    override func onLanguageChange() {
        loadLanguage()
    }

    override func bindingData() {
        super.bindingData()
        viewModel.getColorings {
            self.coloring = self.viewModel.colorings.first
            self.collectionView.reloadData()
        }
    }
    
    func setupView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        collectionView.register(cellType: HomeAdsCell.self)
        collectionView.register(cellType: FeatureHomeCell.self)
        collectionView.register(cellType: AllColoringCell.self)
        collectionView.register(UINib(nibName: collectionViewHeaderFooterReuseIdentifier, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: collectionViewHeaderFooterReuseIdentifier)
        collectionView.register(UINib(nibName: collectionViewHeaderFooterReuseIdentifier, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: collectionViewHeaderFooterReuseIdentifier)
    }
    
    func loadLanguage() {
        topbarView.title = LocalizableUtils.commonHome()
        
        collectionView.reloadData()
    }
    
}
extension HomeController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return typeHome.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return 1
        default: return coloring?.imageUrls?.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: HomeAdsCell.self)
            cell.actionAds = { [weak self] isShow in
                self?.isShowAds = isShow
                self?.collectionView.reloadData()
            }
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: FeatureHomeCell.self)
            cell.reloadLanguage()
            cell.onClickColoring = {
                AppRouter.shared.navigate(to: MainColoringsRoute.main, with: .push)
            }
            
            cell.onClickCollections = {
                AppRouter.shared.navigate(to: CollectionsRoute.main, with: .push)
            }
            return cell
        default:
            collectionView.collectionViewLayout.isKind(of: PinterestLayout.self)
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: AllColoringCell.self)
            cell.setupView(image: coloring?.imageUrls?[indexPath.row].filePreview, coloringLocal: coloringLocal, filePath: coloring?.imageUrls?[indexPath.row].filePath)
            if coloring?.imageUrls?[indexPath.row].isPremium ?? false {
                cell.adsViewAnimation.isHidden = false
                cell.loadAnimationAds()
            } else {
                cell.adsViewAnimation.isHidden = true
            }
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 2 {
            guard let data = coloring?.imageUrls?[indexPath.row] else {
                return
            }
            
            guard !(data.isPremium ?? false) else {
                guard SQLiteManager.shared.selectionColoringsRew().first(where: {$0.filePath == data.filePath}) == nil else {
                    if let colorLocal = SQLiteManager.shared.selectionColorings().first(where: {$0.filePath == data.filePath}) {
                        AppRouter.shared.navigate(to: HistoryColoringRoute.main(coloring: colorLocal, typeScreen: .home, coloringAPI: data), with: .modal)
                    } else {
                        AppRouter.shared.navigate(to: PreviewColoringRoute.main(coloring: data, coloringLocal: nil, history: nil, typeScreen: .home), with: .modal)
                    }
                    return
                }
                ADManager.shared.loadReward(DollColoringAdID.reward_alltopic) { status in
                    switch status {
                    case .closed:
                        SQLiteManager.shared.insertTableColoringRew(data: data)
                        if let colorLocal = SQLiteManager.shared.selectionColorings().first(where: {$0.filePath == data.filePath}) {
                            
                            AppRouter.shared.navigate(to: HistoryColoringRoute.main(coloring: colorLocal, typeScreen: .home, coloringAPI: data), with: .modal)
                        } else {
                            AppRouter.shared.navigate(to: PreviewColoringRoute.main(coloring: data, coloringLocal: nil, history: nil, typeScreen: .home), with: .modal)
                        }
                    case .error:
                        if let colorLocal = SQLiteManager.shared.selectionColorings().first(where: {$0.filePath == data.filePath}) {
                            AppRouter.shared.navigate(to: HistoryColoringRoute.main(coloring: colorLocal, typeScreen: .home, coloringAPI: data), with: .modal)
                        } else {
                            AppRouter.shared.navigate(to: PreviewColoringRoute.main(coloring: data, coloringLocal: nil, history: nil, typeScreen: .home), with: .modal)
                        }
                    default:
                        break
                    }
                }
                return
            }
            
            numberClick += 1
            guard numberClick >= UserDefaultManager.numberClickItemAllTopic  else {
                if let colorLocal = SQLiteManager.shared.selectionColorings().first(where: {$0.filePath == data.filePath}) {
                    AppRouter.shared.navigate(to: HistoryColoringRoute.main(coloring: colorLocal, typeScreen: .home, coloringAPI: data), with: .modal)
                } else {
                    AppRouter.shared.navigate(to: PreviewColoringRoute.main(coloring: data, coloringLocal: nil, history: nil, typeScreen: .home), with: .modal)
                }
                return
            }
            ADManager.shared.loadFull(DollColoringAdID.inter_alltopic) {[weak self] status in
                switch status {
                case .closed, .error:
                    self?.numberClick = 0
                    if let colorLocal = SQLiteManager.shared.selectionColorings().first(where: {$0.filePath == data.filePath}) {
                        AppRouter.shared.navigate(to: HistoryColoringRoute.main(coloring: colorLocal, typeScreen: .home, coloringAPI: data), with: .modal)
                    } else {
                        AppRouter.shared.navigate(to: PreviewColoringRoute.main(coloring: data, coloringLocal: nil, history: nil, typeScreen: .home), with: .modal)
                    }
                default:
                    break
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: collectionViewHeaderFooterReuseIdentifier, for: indexPath) as? HeaderHomeCell else {
            return UICollectionReusableView()
        }
        headerView.lbTitle.text = typeHome[indexPath.section].rawValue
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width = UIScreen.main.bounds.width - 32
        if section == 0 {
            return CGSize(width: width, height: 0.001)
        } else {
            return CGSize(width: width, height: 30)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        let width = UIScreen.main.bounds.width - 32
        return CGSize(width: width, height: 0.001)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width - 32
        switch indexPath.section {
        case 0:
            return CGSize(width: width, height: isShowAds ?  220 : 0.001)
        case 1:
            return CGSize(width: width, height: width / 2 * 0.7)
        default:
            return CGSize(width: (Int(width) - 8) / 2, height: Int(width / 2))
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
}
