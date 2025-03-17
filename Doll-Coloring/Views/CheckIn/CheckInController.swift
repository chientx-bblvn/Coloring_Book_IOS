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
import BmoViewPager
import FBAudienceNetwork
import SDWebImage

class CheckInController: BaseViewController {
    
    var viewModel: DalyMonthVM!
    
    @IBOutlet weak var topbarView: TopBarView!
    
//    @IBOutlet weak var slidePages: FSPagerView! {
//        didSet {
//            self.slidePages.register(cellType: HistoryCellCollectionViewCell.self)
//            self.slidePages.itemSize = FSPagerView.automaticSize
//            self.slidePages.automaticSlidingInterval = 2
//            self.slidePages.isInfinite = true
//            self.slidePages.decelerationDistance = 2
//            self.slidePages.delegate = self
//            self.slidePages.dataSource = self
//        }
//    }
    
//    @IBOutlet weak var pageController: FSPageControl! {
//        didSet {
//            self.pageController.numberOfPages = bannerHome.images.count
//            self.pageController.contentHorizontalAlignment = .center
//            self.pageController.contentInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
//        }
//    }
    
//    @IBOutlet weak var heightSlider: NSLayoutConstraint! {
//        didSet {
//            var height = UIScreen.main.bounds.width
//            if UIDevice.current.userInterfaceIdiom == .pad {
//                height = height * (250 / 768)
//            } else {
//                height = height * (250 / 412)
//            }
//            heightSlider.constant = height
//        }
//    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var typeHome = TypeHome.allCases
    private var bannerHome: BannerHome = .iphone
    private var isLandscape: Bool = false
    private var coloringLocal = SQLiteManager.shared.selectionColorings()
    private var currentDay: Int = 0
    
    override func setup() {
        super.setup()
        setupView()
        ADManager.shared.preLoadReward(DollColoringAdID.reward_dailygift)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        coloringLocal = SQLiteManager.shared.selectionColorings()
        collectionView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let local = FileManagerLocal.shared.getFileColoringlocalURL()
        local.forEach { url in
            let cacheKey = SDWebImageManager.shared.cacheKey(for: url)
            SDImageCache.shared.removeImage(forKey: cacheKey, withCompletion: nil)
        }
    }
    
    override func onLanguageChange() {
        loadLanguage()
    }
    
    override func updateMorePortrait() {
        super.updateMorePortrait()
        updateLayoutContent()
    }
    
    override func updateMoreLandscape() {
        super.updateMoreLandscape()
        updateLayoutContent()
    }
    
    func setupView() {
        if UIDevice.current.userInterfaceIdiom == .pad {
            bannerHome = .ipad
        }
        topbarView.titleFont = UIFont.systemFont(ofSize: 24, weight: .bold)
//        topbarView.title = ""
        topbarView.title = "Daily"
        topbarView.titleFont = UIFont.systemFont(ofSize: 24, weight: .bold)
        topbarView.onLeftClick = {
            AppRouter.shared.popToController(controller: MainTabbarViewController.classForCoder())
        }
        topbarView.textAlignmentCenter = true
        
        updateLayoutContent()
        loadLanguage()
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(cellType: ItemGitDalyCell.self)
        collectionView.register(cellType: GitDaylyCell.self)
        collectionView.register(UINib(nibName: "HeaderDalyView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderDalyView")
        collectionView.register(UINib(nibName: "HeaderDalyView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "HeaderDalyView")

        
        collectionView.contentInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
    
    private func updateLayoutContent() {
        let rotation = UIApplication.shared.windows.first?.windowScene?.interfaceOrientation
        switch rotation {
        case .unknown:
            break
        case .portrait, .portraitUpsideDown:
            isLandscape = false
//            slidePages.reloadData()
        case .landscapeLeft, .landscapeRight:
            isLandscape = true
//            slidePages.reloadData()
        default:
            break
        }
    }
    
    func loadLanguage() {
        
    }
    
}

//extension CheckInController: FSPagerViewDataSource,FSPagerViewDelegate {
//    public func numberOfItems(in pagerView: FSPagerView) -> Int {
//        return bannerHome.images.count
//    }
//    
//    public func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
//        let cell = pagerView.dequeueReusableCell(for: index, cellType: HistoryCellCollectionViewCell.self)
//        cell.imageView?.image = UIImage(named: bannerHome.images[index])
//        cell.imageView?.contentMode = .scaleAspectFill
//        cell.imageView.layer.borderWidth = 0
//        cell.imageView.layer.cornerRadius = 0
//        cell.imageView?.clipsToBounds = true
//        return cell
//    }
//    
//    // MARK:- FSPagerView Delegate
//    
//    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
//        pagerView.deselectItem(at: index, animated: true)
//        pagerView.scrollToItem(at: index, animated: true)
//    }
//    
//    func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int) {
//        self.pageController.currentPage = targetIndex
//    }
//    
//    func pagerViewDidEndScrollAnimation(_ pagerView: FSPagerView) {
//        self.pageController.currentPage = pagerView.currentIndex
//    }
//}

extension CheckInController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.monthsData.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
           return viewModel.monthsData[section - 1].day.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: GitDaylyCell.self)
            if viewModel.totalGitDaly == 0 {
                cell.loadImage(image: viewModel.itemDaly.first?.filePath ?? "")
            } else {
                if viewModel.itemDaly.count > viewModel.totalGitDaly {
                    cell.loadImage(image: viewModel.itemDaly[viewModel.totalGitDaly].filePath ?? "")
                } else {
                    cell.loadImage(image: viewModel.itemDaly.first?.filePath ?? "")
                }
            }
            cell.coloringLocal = coloringLocal
            cell.onclickImage = {[weak self] name in
                if let data = self?.viewModel.itemDaly.first(where: {$0.filePath?.contains(name) ?? false}) {
                    self?.navigateColoring(data)
                }
            }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: ItemGitDalyCell.self)
            let image = viewModel.monthsData[indexPath.section - 1].image.reversed()[indexPath.row]
            if let coloring = coloringLocal.first(where: {$0.filePath.contains(image)}) {
                if let file = coloring.historys.last?.imagePath {
                    let imageUrlString = FileManagerLocal.shared.getFileFoderFileUssing(typeFile: .ColoringSave, file: file)
                    let cacheKey = SDWebImageManager.shared.cacheKey(for: imageUrlString)
                    SDImageCache.shared.removeImage(forKey: cacheKey, withCompletion: nil)
                    cell.imageItem.setLocalImage(with: imageUrlString.path, placeholder: nil)
                } else {
                    cell.imageItem.setImage(with: image)
                }
            } else {
                cell.imageItem.setImage(with: image)
            }
            cell.imageAds.isHidden = SQLiteManager.shared.selectionGitColorings().contains(where: {$0.filePath.contains(image)})
            cell.lbDate.text = "\(viewModel.monthsData[indexPath.section - 1].day.reversed()[indexPath.row])"
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section != 0 {
            let image  = viewModel.monthsData[indexPath.section - 1].image.reversed()[indexPath.row]
            if SQLiteManager.shared.selectionGitColorings().contains(where: {$0.filePath.contains(image)}) {
                if let data = viewModel.itemDaly.first(where: {$0.filePath?.contains(image) ?? false}) {
                    navigateColoring(data)
                }
            } else {
                if let data = viewModel.itemDaly.first(where: {$0.filePath?.contains(image) ?? false}) {
                    if IAPState.isUserVip {
                        self.navigateColoring(data)
                        return
                    }
                    showRew(data)
                }
            }
        }
    }
    
    func showRew(_ data: ColoringImage) {
        guard SQLiteManager.shared.selectionColoringsRew().first(where: {$0.filePath == data.filePath}) == nil else {
            navigateColoring(data)
            return
        }
        if IAPState.isUserVip {
            navigateColoring(data)
            return
        }
        if !UserDefaultManager.disableMusicBackground {
            pauseAudioBackground()
        }
        PopupShowAdsViewController.show(in: self, data: data, {
            ADManager.shared.loadReward(DollColoringAdID.reward_dailygift) { status in
                switch status {
                case .closed, .success:
                    if !UserDefaultManager.disableMusicBackground {
                        self.playAudioBackground()
                    }
                    SQLiteManager.shared.insertTableColoringRew(data: data)
                    SQLiteManager.shared.insertTableGitColoring(_id: SQLiteManager.shared.selectionGitColorings().count, _name: data.filePath ?? "")
                    self.navigateColoring(data)
                case .error:
                    self.loadInter(data)
                default:
                    break
                }
            }
        }, {
            SubcriptionViewController.show(checkTime: true)
        })
    }
    
    func loadInter(_ data: ColoringImage) {
        ADManager.shared.preLoadNative(DollColoringAdID.nativefull_afterinter, refreshAd: true, nativeAdType: .customFullScreenNative)
        AdLoadingView.show()
        ADManager.shared.loadFull(DollColoringAdID.inter_dailygift, isSplash: true){state in
            AdLoadingView.dismiss()
            switch state {
            case .closed, .error :
                
                DispatchQueue.main.async {
                    NativeFullScreenController.show() {
                        if !UserDefaultManager.disableMusicBackground {
                            self.playAudioBackground()
                        }
                        SQLiteManager.shared.insertTableGitColoring(_id: SQLiteManager.shared.selectionGitColorings().count, _name: data.filePath ?? "")
                        self.navigateColoring(data)
                }
                }
            default:
                break
            }
        }
    }
    
    func navigateColoring(_ data: ColoringImage) {
        if let path = data.filePath?.components(separatedBy: "/").last, let colorLocal = SQLiteManager.shared.selectionColorings().first(where: {$0.filePath.contains(path)}) {
            AppRouter.shared.navigate(to: HistoryColoringRoute.main(coloring: colorLocal, typeScreen: .home, coloringAPI: data), with: .modal)
        } else {
            AppRouter.shared.navigate(to: PreviewColoringRoute.main(coloring: data, coloringLocal: nil, history: nil, typeScreen: .home), with: .modal)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let cell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderDalyView", for: indexPath) as? HeaderDalyView else {return UICollectionReusableView()}
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMMM"
            if indexPath.section == 0 {
                cell.lbTitle.text = "Gift Today"
            } else {
                let month = dateFormatter.string(from: viewModel.monthsData.reversed()[indexPath.section - 1].month)
                cell.lbTitle.text = month.capitalized
            }
            return cell
        case UICollectionView.elementKindSectionFooter:
            guard let cell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "HeaderDalyView", for: indexPath) as? HeaderDalyView else {return UICollectionReusableView()}
            return cell
        default:
            fatalError("Unexpected element kind")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width - 32, height: 0.001)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width - 32, height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize (width: collectionView.frame.width - 32, height: collectionView.frame.height * 0.5)
        } else {
            let width = (collectionView.frame.width - 32 - (16 * 3)) / 3
            return CGSize(width: width, height: width)
        }
    }
}
