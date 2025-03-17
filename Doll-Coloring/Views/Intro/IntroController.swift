//
//  IntroController.swift
//  Doll-Coloring
//
//  Created by BBLabs on 13/08/2023.
//  Copyright ©2023. All rights reserved.
//

import Foundation
import RxSwift
import UIKit

class IntroController: BaseViewController {
    
    // MARK: - Variable and Outlet
    @IBOutlet private weak var fsPagerView: FSPagerView!
    
    private let listIntro: [IntroModel] = [
        IntroModel(name: LocalizableUtils.introIntroTitlePage1(),
                   desc: LocalizableUtils.introIntroContentPage1(),
                   image: R.image.ic_item_onboading1(),
                   insideImage: UIImage(named: "ic_inside_onboading1"),
                   id: 0,
                   indicator: R.image.indicator_page1()),
        IntroModel(name: LocalizableUtils.introIntroTitlePage2(),
                   desc: LocalizableUtils.introIntroContentPage2(),
                   image: R.image.ic_item_onboading2(),
                   insideImage: UIImage(named: "ic_inside_onboading2"),
                   id: 1,
                   indicator: R.image.indicator_page2()),
        IntroModel(name: LocalizableUtils.introIntroTitlePage3(),
                   desc: LocalizableUtils.introIntroContentPage3(),
                   image: R.image.ic_item_onboading3(),
                   insideImage: UIImage(named: "ic_inside_onboading3"),
                   id: 2,
                   indicator: R.image.indicator_page3())
    ]
    
    private var hasAd: Bool = true
    
    private var nativeAdNative: NativeAdProtocol? {
        didSet {
            fsPagerView.reloadData()
        }
    }
    
    // MARK: - Setup controller and IBAction
    override func setup() {
        super.setup()
        setupView()
        loadNativeFullSCR()
    }
    
    override func bindingData() {
        super.bindingData()
    }
    
    // MARK: - Language change event
    override func onLanguageChange() {
        super.onLanguageChange()
    }
    
    func loadNativeFullSCR() {
        ADManager.shared.loadNativeWithoutView(DollColoringAdID.naitve_fullscreen_onboarding, nativeAdType: .customFullScreenNative) { adId, success, nativeAdView in
            if ADManager.shared.isTestMode {
                self.hasAd = success
                self.nativeAdNative = nativeAdView
            } else {
                if adId.contains(DollColoringAdID.naitve_fullscreen_onboarding.adId) {
                    self.hasAd = success
                    self.nativeAdNative = nativeAdView
                }
            }
        }
    }

}

// MARK: - Action view
extension IntroController {
    
    @IBAction func clickSkip(_ sender: Any) {
        UserDefaults.standard.set(true, forKey: UserDefault.showedIntro.rawValue)
    }
    
    @IBAction func clickNext (_ sender: Any) {
        let currentPage = fsPagerView.currentIndex
        if currentPage < (listIntro.count - 1) {
            fsPagerView.scrollToItem(at: currentPage + 1, animated: true)
        } else {
            UserDefaults.standard.set(true, forKey: UserDefault.showedIntro.rawValue)
            AppRouter.shared.navigate(to:   MainTabbarViewRoute.tabbar, with: .changeRoot)
        }
    }
    
}

// MARK: - Setup view
extension IntroController {
    
    private func setupView() {
        fsPagerView.dataSource = self
        fsPagerView.delegate = self
        fsPagerView.isInfinite = false
        fsPagerView.isScrollEnabled = true
        fsPagerView.decelerationDistance = 1
        fsPagerView.register(cellType: IntroductionCell.self)
        fsPagerView.register(cellType: IntroADSFullCollectionViewCell.self)
    }
    
    
}

extension IntroController: FSPagerViewDelegate, FSPagerViewDataSource {
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        if hasAd {
            return listIntro.count + 1
        }
        return listIntro.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        guard hasAd else {
            let cell = pagerView.dequeueReusableCell(for: index, cellType: IntroductionCell.self)
            let intro = listIntro[index]
            cell.loadData(intro: intro)
            cell.onNext = {
                DispatchQueue.main.asyncSafety {
                    let currentPage = self.fsPagerView.currentIndex
                    if currentPage < (self.listIntro.count - 1) {
                        self.fsPagerView.scrollToItem(at: currentPage + 1, animated: true)
                    } else {
                        UserDefaults.standard.set(true, forKey: UserDefault.showedIntro.rawValue)
                        UserDefaultManager.currentDateFirstOpenApp = Date().toMyString(format: "dd/MM/yyyy")
                        AppRouter.shared.navigate(to: MainTabbarViewRoute.tabbar, with: .changeRoot)
                    }
                }
            }
            return cell
        }
        
        if index == 2 {
            let cell = pagerView.dequeueReusableCell(for: index, cellType: IntroADSFullCollectionViewCell.self)
            return cell
        }
    
        let cell = pagerView.dequeueReusableCell(for: index, cellType: IntroductionCell.self)
        let intro = listIntro[index == 3 ? 2 : index]
        cell.loadData(intro: intro)
        cell.onNext = {
            DispatchQueue.main.asyncSafety {
                let currentPage = self.fsPagerView.currentIndex
                if currentPage < (self.listIntro.count) {
                    self.fsPagerView.scrollToItem(at: currentPage + 1, animated: true)
                } else {
                    UserDefaults.standard.set(true, forKey: UserDefault.showedIntro.rawValue)
                    UserDefaultManager.currentDateFirstOpenApp = Date().toMyString(format: "dd/MM/yyyy")
                    AppRouter.shared.navigate(to:  MainTabbarViewRoute.tabbar, with: .changeRoot)
                }
            }
        }
        return cell
    }
    
    func pagerViewDidScroll(_ pagerView: FSPagerView) {
        let currentPage = pagerView.currentIndex
        switch currentPage {
        case 0:
            FirebaseEventManager.logEvent(with: RMBGEventTracking.scrOnboard1)
        case 1:
            FirebaseEventManager.logEvent(with: RMBGEventTracking.scrOnboard2)
        case 2:
            FirebaseEventManager.logEvent(with: RMBGEventTracking.scrOnboard3)
        default: break
        }
    }
    
    func pagerView(_ pagerView: FSPagerView, willDisplay cell: FSPagerViewCell, forItemAt index: Int) {
        if let cell = cell as? IntroADSFullCollectionViewCell {
            cell.loadAds(nativeAd: nativeAdNative)
        }
    }
    
    func pagerView(_ pagerView: FSPagerView, didEndDisplaying cell: FSPagerViewCell, forItemAt index: Int) {
        if let cell = cell as? IntroADSFullCollectionViewCell {
            cell.removeViewAds()
        }
    }
}
