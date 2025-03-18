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
    
    //bỏ
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
    //bỏ
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
                height = height * (250 / 768)
            } else {
                height = height * (250 / 412)
                
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
//        topbarView.onLeftClick = {
//            CheckInController.show(self)
//        }
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
    }
    
    override func setup() {
        super.setup()
        if UserDefaultManager.ABShowIAPColoring, !IAPState.isUserVip {
            SubcriptionViewController.show(checkTime: false,handler: {
                if UserDefaultManager.disableSale {
                    ADManager.shared.loadFull(DollColoringAdID.inter_back)
                    return
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    PremiumFloatingView.show()
                    DiscountViewController.show {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            self.calculatorDay()
                        }
                        
                    }
                }
            }, onClickCLose:  {
                
            })
            
        }
        NotificationCenter.default.addObserver(self, selector: #selector(gotoDaily), name: NSNotification.Name("GOTODAILY_TABBAR"), object: nil)
        if !IAPState.isUserVip {
            ADManager.shared.preLoadReward(DollColoringAdID.reward_alltopic)
            ADManager.shared.preLoadReward(DollColoringAdID.reward_dailygift)
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
        viewModel.getNewColorings {[weak self] in
            guard let self = self else {return}
            self.viewPageController.removeAll()
            let day = calculatorDays()
            self.viewModel.colorings.forEach { model in
                let vc = PageViewSwirlViewController.loadController()
                vc.categoryName = model.categoryName
                vc.itemColoring = model.imageUrls ?? []
                vc.totalDays = day
                vc.handleScrollView = { scroll in
                    self.scrollView(scroll)
                }
                vc.onClickItem = { item, categoty, index in
                    guard !(categoty.contains("Daily")) else {
                        if SQLiteManager.shared.selectionGitColorings().contains(where: {$0.filePath.contains(item.filePath ?? "")}) {
                            self.navigateColoring(item)
                        } else if index <= day {
                            self.showRewDaily(item)
                        } else {
                            AppRouter.shared.navigate(to: HomeRoute.showCombackTomorrow, with: .modal, animated: false)
                        }
                        return
                    }
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
            self.bmoViewPager.presentedPageIndex = 1
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
            self?.topbarView.showPremium = IAPState.isUserVip
            if IAPState.isUserVip {
                PremiumFloatingView.hide()
            }
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
        bmoViewPager.infinitScroll = false
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
        viewBackground.layer.cornerRadius = 8
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
            height = height * (250 / 768)
        } else {
            height = height * (250 / 412)
            
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
        if IAPState.isUserVip {
            navigateColoring(data)
            return
        }
        numberClick += 1
        if numberClick >= UserDefaultManager.numberClickItemAllTopic {
            if !UserDefaultManager.disableMusicBackground {
                pauseAudioBackground()
            }
            ADManager.shared.preLoadNative(DollColoringAdID.nativefull_afterinter, refreshAd: true, nativeAdType: .customFullScreenNative)
            AdLoadingView.show()
            ADManager.shared.loadFull(DollColoringAdID.inter_alltopic, isSplash: true) { status in
                AdLoadingView.dismiss()
                switch status {
                case .closed, .error:
                    DispatchQueue.main.async {
                        NativeFullScreenController.show() {
                            if !UserDefaultManager.disableMusicBackground {
                                self.playAudioBackground()
                            }
                            self.numberClick = 0
                            self.navigateColoring(data)
                        }
                    }
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
                case .closed, .success:
                    if !UserDefaultManager.disableMusicBackground {
                        self.playAudioBackground()
                    }
                    SQLiteManager.shared.insertTableColoringRew(data: data)
                    self.navigateColoring(data)
                case .error:
                    self.loadInter(data)
                case .showed:
                    break
                case .loaded:
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
        ADManager.shared.loadFull(DollColoringAdID.inter_alltopic, isSplash: true){ state in
            AdLoadingView.dismiss()
            switch state {
            case .closed, .error :
                DispatchQueue.main.async {
                    NativeFullScreenController.show() {
                        if !UserDefaultManager.disableMusicBackground {
                            self.playAudioBackground()
                        }
                        self.navigateColoring(data)
                    }
                }
            default:
                break
            }
        }
    }
    

    func showRewDaily(_ data: ColoringImage) {
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
                    self.loadInterDaily(data)
                default:
                    break
                }
            }
        }, {
            SubcriptionViewController.show(checkTime: true)
        })
    }
    
    func loadInterDaily(_ data: ColoringImage) {
        ADManager.shared.preLoadNative(DollColoringAdID.nativefull_afterinter, refreshAd: true, nativeAdType: .customFullScreenNative)
        AdLoadingView.show()
        ADManager.shared.loadFull(DollColoringAdID.inter_dailygift, isSplash: true){ state in
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
    
    @objc private func gotoDaily() {
        let sqliteData = SQLiteManager.shared.selectionGitColorings()
        guard sqliteData.count < viewModel.itemDaly.count else {return}
        let currentDate = Date()
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        guard let pastDate = dateFormatter.date(from: UserDefaultManager.dateFirstOpenApp) else {
            return
        }
        
        let components = calendar.dateComponents([.day], from: pastDate, to: currentDate)
        if let totalDays = components.day {
            if totalDays >= viewModel.itemDaly.count {
                let name = viewModel.itemDaly[(viewModel.itemDaly.count - 1)]
                navigateColoring(name)
            } else {
                let name = viewModel.itemDaly[totalDays]
                navigateColoring(name)
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
    
    func calculatorDay() {
        let sqliteData = SQLiteManager.shared.selectionGitColorings()
        guard sqliteData.count < viewModel.itemDaly.count else {return}
        let currentDate = Date()
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        guard let pastDate = dateFormatter.date(from: UserDefaultManager.dateFirstOpenApp) else {
            return
        }
        let components = calendar.dateComponents([.day], from: pastDate, to: currentDate)
        
        if let totalDays = components.day {
            if totalDays >= viewModel.itemDaly.count {
                if let name = viewModel.itemDaly[(viewModel.itemDaly.count - 1)].filePath, !sqliteData.contains(where: {$0.filePath.contains(name)}){
                    AppRouter.shared.navigate(to: CheckInRoute.gitPopup(name: name), with: .modal)
                }
            } else {
                if let name = viewModel.itemDaly[totalDays].filePath, !sqliteData.contains(where: {$0.filePath.contains(name)}){
                    AppRouter.shared.navigate(to: CheckInRoute.gitPopup(name: name), with: .modal)
                }
            }
        }
    }
    
    func calculatorDays() -> Int {
        let sqliteData = SQLiteManager.shared.selectionGitColorings()
        guard sqliteData.count < viewModel.itemDaly.count else {return 0}
        let currentDate = Date()
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        guard let pastDate = dateFormatter.date(from: UserDefaultManager.dateFirstOpenApp) else {
            return 0
        }
        let components = calendar.dateComponents([.day], from: pastDate, to: currentDate)
        
        if let totalDays = components.day {
            return totalDays
        }
        return 0
    }
}
