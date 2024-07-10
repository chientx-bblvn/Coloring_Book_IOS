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

class HomeController: BaseViewController {
    
    var viewModel: HomeVM!
    
    @IBOutlet weak var topbarView: TopBarView!
    
    @IBOutlet weak var slidePages: FSPagerView! {
        didSet {
            self.slidePages.register(cellType: HistoryCellCollectionViewCell.self)
            self.slidePages.itemSize = FSPagerView.automaticSize
            self.slidePages.automaticSlidingInterval = 2
            self.slidePages.isInfinite = true
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
    
    @IBOutlet weak var bmoViewPagerNavigation: BmoViewPagerNavigationBar!
    
    @IBOutlet weak var bmoViewPager: BmoViewPager!
    
    private var viewPageController: [PageViewSwirlViewController] = []
  
    private var numberClick = 4
    private var typeHome = TypeHome.allCases
    private var bannerHome: BannerHome = .iphone
    private var isLandscape: Bool = false
    
    private var timeDistanceShowad: TimeInterval = 5
    private var currentTime: TimeInterval = 0
    private var hasAd = true
    
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
        topbarView.onClickPremium = {
            SubcriptionViewController.show(checkTime: true)
        }
        enableAudioBackground()
        loadLanguage()
        setupView()
        settingIAP()
        requestNotification()
        let archiveFiles = ArchiveFileLocal.allCases
        
        for file in archiveFiles {
            if !FileManagerLocal.shared.checkFileExits(typeFile: file, fileName: "") {
                FileManagerLocal.shared.createFolderManager(fileName: file.rawValue)
            }
        }
        ADManager.shared.preLoadReward(DollColoringAdID.reward_alltopic)
    }
    
    override func setup() {
        super.setup()
        if UserDefaultManager.ABShowIAPColoring, !IAPState.isUserVip {
            SubcriptionViewController.show(checkTime: true)
        }
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
    
    override func bindingData() {
        super.bindingData()
        viewModel.getColorings {[weak self] in
            guard let self = self else {return}
            self.viewPageController.removeAll()
            self.viewModel.colorings.forEach { model in
                let vc = PageViewSwirlViewController.loadController()
                vc.categoryName = model.categoryName
                vc.itemColoring = model.imageUrls ?? []
                vc.handleScrollView = { scroll in
                    self.scrollView(scroll)
                }
                vc.onClickItem = { item in
                    guard UserDefaultManager.ABShowIAPColoring else {
                        if (item.isPremium ?? false) {
                            self.showRew(item)
                        } else {
                            self.showInter(item)
                        }
                        return
                    }
                    
                    if UserDefaultManager.ABis_free_trial_us {
                        self.showRew(item)
                    } else {
                        if (item.isPremium ?? false) {
                            self.showIAP(item)
                        } else {
                            self.showInter(item)
                        }
                    }
                }
                self.viewPageController.append(vc)
                self.bmoViewPager.reloadData()
                self.bmoViewPagerNavigation.reloadData()
            }
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
    
    private func settingIAP() {
        InappManager.share.didPaymentSuccess.subscribe(onNext: { [weak self] _ in
            self?.topbarView.showPremium = UserDefaultManager.ABShowIAPColoring
        }).disposed(by: disposeBag)
    }
    
    func setupView() {
        setupPageView()
        updateLayoutContent()
        timeDistanceShowad = TimeInterval(ADManager.shared.timeRemoteShowFull)
        numberClick = UserDefaultManager.numberClickItemAllTopic
    }
    
    private func requestNotification() {
        BBLLogging.d("Check:: requestNotification")
        appDelegate?.requestNotificationPermission(completion: { success, error in
            BBLLogging.d("Check:: requestNotificationPermission  --   success: \(success)  error: \(error?.localizedDescription ?? "error")")
        })
    }
    
    private func updateLayoutContent() {
        let rotation = UIApplication.shared.windows.first?.windowScene?.interfaceOrientation
        switch rotation {
        case .unknown:
            break
        case .portrait, .portraitUpsideDown:
            isLandscape = false
            slidePages.reloadData()
        case .landscapeLeft, .landscapeRight:
            isLandscape = true
            slidePages.reloadData()
        default:
            break
        }
    }
    
    func loadLanguage() {
        
    }
    
    private func requestGDPRAndATT(completion: @escaping (() -> Void)) {
        BBLLogging.d("Check:: requestGDPRAndATT")
        appDelegate?.requestShowUMPForEEAMarket(idx: 1, completion: { accepted in
            let needAcceptConsent = RemoteConfigManager.shared.getValue(by: RMBGRemoteConfig.needAcceptConsent)?.boolValue ?? true
            BBLLogging.d("Check:: requestShowUMPForEEAMarket   ---  accepted: \(accepted)  needAcceptConsent: \(needAcceptConsent)")
            if !needAcceptConsent {
                FBAdSettings.setAdvertiserTrackingEnabled(true)
                completion()
                return
            }
            if accepted {
                FBAdSettings.setAdvertiserTrackingEnabled(true)
            }
            completion()
        })
    }
    
    private func setupPageView() {
        bmoViewPagerNavigation.viewPager = bmoViewPager
        bmoViewPager.scrollable = true
        bmoViewPager.delegate = self
        bmoViewPager.dataSource = self
    }
}

extension HomeController: BmoViewPagerDelegate, BmoViewPagerDataSource {
    func bmoViewPagerDataSourceNumberOfPage(in viewPager: BmoViewPager) -> Int {
        return viewPageController.count
    }
    
    func bmoViewPagerDataSource(_ viewPager: BmoViewPager, viewControllerForPageAt page: Int) -> UIViewController {
        return viewPageController[page]
    }
}

extension HomeController {
    func bmoViewPagerDataSourceNaviagtionBarItemTitle(_ viewPager: BmoViewPager, navigationBar: BmoViewPagerNavigationBar, forPageListAt page: Int) -> String? {
        return viewModel.colorings[page].categoryName?.capitalized
    }
    
    func bmoViewPagerDataSourceNaviagtionBarItemNormalBackgroundView(_ viewPager: BmoViewPager, navigationBar: BmoViewPagerNavigationBar, forPageListAt page: Int) -> UIView? {
        return nil
    }
    
    func bmoViewPagerDataSourceNaviagtionBarItemHighlightedBackgroundView(_ viewPager: BmoViewPager, navigationBar: BmoViewPagerNavigationBar, forPageListAt page: Int) -> UIView? {
        let viewBackground = UIView()
        viewBackground.translatesAutoresizingMaskIntoConstraints = false
        viewBackground.backgroundColor = R.color.mainPrimary()
        viewBackground.layer.cornerRadius =  4
        return viewBackground
    }
    
    func bmoViewPagerDataSourceNaviagtionBarItemHighlightedAttributed(_ viewPager: BmoViewPager, navigationBar: BmoViewPagerNavigationBar, forPageListAt page: Int) -> [NSAttributedString.Key : Any]? {
        return [
            .font: UIFont.boldSystemFont(ofSize: 14),
            .foregroundColor: UIColor.white
        ]
    }
    
    func bmoViewPagerDataSourceNaviagtionBarItemNormalAttributed(_ viewPager: BmoViewPager, navigationBar: BmoViewPagerNavigationBar, forPageListAt page: Int) -> [NSAttributedString.Key : Any]? {
        return [
            .font: UIFont.boldSystemFont(ofSize: 14),
            .foregroundColor: R.color.colorTitle()!
        ]
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

extension HomeController {
        
    func scrollView(_ scrollView: UIScrollView) {
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
    
    
    func showIAP(_ data: ColoringImage) {
        guard IAPState.isUserVip else {
            
            if SQLiteManager.shared.selectionColoringsRew().first(where: {$0.filePath == data.filePath}) != nil {
                navigateColoring(data)
                return
            }
            
            SubcriptionViewController.show(checkTime: true) {
                
            } onClickCLose: {
                self.showRew(data)
            }
            return
        }
        navigateColoring(data)
    }
    
    func showInter(_ data: ColoringImage) {
        numberClick += 1
        if numberClick >= UserDefaultManager.numberClickItemAllTopic {
            if !UserDefaultManager.disableMusicBackground {
                pauseAudioBackground()
            }
            ADManager.shared.loadFull(DollColoringAdID.inter_alltopic, isSplash: true) {[weak self] status in
                switch status {
                case .closed, .error:
                    if !UserDefaultManager.disableMusicBackground {
                        self?.playAudioBackground()
                    }
                    self?.numberClick = 0
                    self?.navigateColoring(data)
                default:
                    break
                }
            }
        } else {
            navigateColoring(data)
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
            ADManager.shared.loadReward(DollColoringAdID.reward_alltopic) { status in
                switch status {
                case .closed:
                    if !UserDefaultManager.disableMusicBackground {
                        self.playAudioBackground()
                    }
                    SQLiteManager.shared.insertTableColoringRew(data: data)
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
        ADManager.shared.loadFull(DollColoringAdID.inter_alltopic, isSplash: true){[weak self] state in
            switch state {
            case .closed, .error :
                if !UserDefaultManager.disableMusicBackground {
                    self?.playAudioBackground()
                }
                self?.navigateColoring(data)
            default:
                break
            }
        }
    }
    
    func navigateColoring(_ data: ColoringImage) {
        if let colorLocal = SQLiteManager.shared.selectionColorings().first(where: {$0.filePath == data.filePath}) {
            AppRouter.shared.navigate(to: HistoryColoringRoute.main(coloring: colorLocal, typeScreen: .home, coloringAPI: data), with: .modal)
        } else {
            AppRouter.shared.navigate(to: PreviewColoringRoute.main(coloring: data, coloringLocal: nil, history: nil, typeScreen: .home), with: .modal)
        }
    }
}
