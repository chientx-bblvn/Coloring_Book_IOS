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

class HomeController: BaseViewController {
    
    var viewModel: HomeVM!
    
    @IBOutlet weak var topbarView: TopBarView!
    
    @IBOutlet weak var slidePages: FSPagerView! {
        didSet {
            self.slidePages.register(cellType: HistoryCellCollectionViewCell.self)
            self.slidePages.itemSize = FSPagerView.automaticSize
            self.slidePages.automaticSlidingInterval = 2
            self.slidePages.isInfinite = true
            self.slidePages.transformer = FSPagerViewTransformer(type: .crossFading)
            self.slidePages.decelerationDistance = 2
            self.slidePages.delegate = self
            self.slidePages.dataSource = self
        }
    }
    
    @IBOutlet weak var pageController: FSPageControl! {
        didSet {
            self.pageController.numberOfPages = bannerHome.images.count
            self.pageController.contentHorizontalAlignment = .center
            self.pageController.contentInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        }
    }
    
    @IBOutlet weak var listMenu: UICollectionView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var heightSlider: NSLayoutConstraint! {
        didSet {
            var height = UIScreen.main.bounds.width
            if UIDevice.current.userInterfaceIdiom == .pad {
                height = height * (220 / 768)
            } else {
                height = height * (200 / 393)
                
            }
            heightSlider.constant = height
        }
    }
    
    @IBOutlet weak var widthSlider: NSLayoutConstraint! {
        didSet {
            widthSlider.constant =  UIScreen.main.bounds.width
        }
    }
    
    let collectionViewHeaderFooterReuseIdentifier = "HeaderHomeCell"
    private var coloringLocal: [ColoringHistoryModel] = []
    var isShowAds: Bool = true
    var numberClick = 0
    var indexCategory = 0
    private var typeHome = TypeHome.allCases
    private var bannerHome: BannerHome = .iphone
    private var isLandscape: Bool = false
    
    override func loadView() {
        super.loadView()
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            bannerHome = .ipad
        }
        topbarView.titleFont = UIFont.systemFont(ofSize: 24, weight: .bold)
        topbarView.title = ""
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
            self.listMenu.reloadData()
            self.collectionView.reloadData()
        }
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
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 20, right: 16)
        collectionView.register(cellType: AllColoringCell.self)
        listMenu.delegate = self
        listMenu.dataSource = self
        listMenu.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        listMenu.register(cellType: CategoryMenuCell.self)
        updateLayoutContent()
    }
    
    private func updateCategory() {
        viewModel.itemColoring = viewModel.colorings[indexCategory].imageUrls ?? []
        collectionView.reloadData()
    }
    
    private func updateLayoutContent() {
        let rotation = UIApplication.shared.windows.first?.windowScene?.interfaceOrientation
        switch rotation {
        case .unknown:
            break
        case .portrait, .portraitUpsideDown:
            isLandscape = false
            slidePages.reloadData()
            collectionView.reloadData()
        case .landscapeLeft, .landscapeRight:
            isLandscape = true
            slidePages.reloadData()
            collectionView.reloadData()
        default:
            break
        }
    }
    
    func loadLanguage() {
        collectionView.reloadData()
    }
}

extension HomeController: FSPagerViewDataSource,FSPagerViewDelegate {
    public func numberOfItems(in pagerView: FSPagerView) -> Int {
        return bannerHome.images.count
    }
    
    public func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(for: index, cellType: HistoryCellCollectionViewCell.self)
        cell.imageView?.image = UIImage(named: bannerHome.images[index])
        cell.imageView?.contentMode = .scaleAspectFill
        cell.imageView.layer.borderWidth = 0
        cell.imageView.layer.cornerRadius = 0
        cell.imageView?.clipsToBounds = true
        return cell
    }
    
    // MARK:- FSPagerView Delegate
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        pagerView.deselectItem(at: index, animated: true)
        pagerView.scrollToItem(at: index, animated: true)
    }
    
    func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int) {
        self.pageController.currentPage = targetIndex
    }
    
    func pagerViewDidEndScrollAnimation(_ pagerView: FSPagerView) {
        self.pageController.currentPage = pagerView.currentIndex
    }
}

extension HomeController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == listMenu {
            return viewModel.colorings.count
        } else {
            return viewModel.itemColoring.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == listMenu {
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: CategoryMenuCell.self)
            cell.setupData(isSelect: indexCategory == indexPath.row, title: viewModel.colorings[indexPath.row].categoryName?.capitalized)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: AllColoringCell.self)
            let data = viewModel.itemColoring[indexPath.row]
            cell.setupView(image: data.filePreview, coloringLocal: coloringLocal, filePath: data.filePath)
            if data.isPremium ?? false {
                cell.adsViewAnimation.isHidden = false
                cell.loadAnimationAds()
            } else {
                cell.adsViewAnimation.isHidden = true
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == listMenu {
            indexCategory = indexPath.row
            listMenu.reloadData()
            listMenu.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            updateCategory()
            FirebaseEventManager.logEvent(with: RMBGEventTracking.category_name, params: ["category": viewModel.colorings[indexPath.row].categoryName?.capitalized ?? ""])
          return
        }
        
        let data = viewModel.itemColoring[indexPath.row]
        
        FirebaseEventManager.logEvent(with: RMBGEventTracking.start_coloring, params: ["category": viewModel.colorings[indexCategory].categoryName?.capitalized ?? "",
                                                                                       "image": data.filePath ?? "",
                                                                                       "isPremium": data.isPremium ?? false])
        guard (data.isPremium ?? false) else {
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
            return
        }
        
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
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width - 32
        if collectionView == listMenu {
            let index = indexPath.row
            let item = viewModel.colorings[index].categoryName
            let widthF = item?.trimmingCharacters(in: .whitespaces).width(withConstrainedHeight: 8, font: .systemFont(ofSize: 14, weight: .bold)) ?? 0
            return CGSize(width: 32 + widthF, height: listMenu.frame.height)
        }
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
        if collectionView == listMenu {
            return 0
        }
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == listMenu {
            return 0
        }
        return 8
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        var height = UIScreen.main.bounds.width
        let headerHeightMin: CGFloat = 0
        if UIDevice.current.userInterfaceIdiom == .pad {
            height = height * (220 / 768)
        } else {
            height = height * (200 / 393)
            
        }
        let newHeaderHeight = max(headerHeightMin, height - offsetY)
        
        heightSlider.constant = newHeaderHeight
        
        if (height / 2) >= newHeaderHeight {
            UIView.animate(withDuration: 0.2) {
                self.topbarView.isHidden = true
            }
        } else {
            UIView.animate(withDuration: 0.2) {
                self.topbarView.isHidden = false
            }
        }
        
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
}
