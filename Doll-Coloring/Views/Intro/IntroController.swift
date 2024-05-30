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
    @IBOutlet private weak var viewAds: UIView!
    
    @IBOutlet weak var sliderView: UIStackView!
    
    @IBOutlet weak var btnNext: UIButton!
    
    private let listIntro: [IntroModel] = [
        IntroModel(name: LocalizableUtils.introIntroTitlePage1(),
                   desc: LocalizableUtils.introIntroContentPage1(),
                   image: R.image.ic_item_onboading1(),
                   id: 0),
        IntroModel(name: LocalizableUtils.introIntroTitlePage1(),
                   desc: LocalizableUtils.introIntroContentPage1(),
                   image: R.image.ic_item_onboading2(),
                   id: 1),
        IntroModel(name: LocalizableUtils.introIntroTitlePage1(),
                   desc: LocalizableUtils.introIntroContentPage1(),
                   image: R.image.ic_item_onboading3(),
                   id: 2)
    ]
    
    // MARK: - Setup controller and IBAction
    override func setup() {
        super.setup()
        setupView()
    }
    
    override func bindingData() {
        super.bindingData()
    }
    
    // MARK: - Language change event
    override func onLanguageChange() {
        super.onLanguageChange()
    }
    
    func customPageControl(currentIndex: Int = 0) {
        let numberOfPage = listIntro.count - 1
        guard numberOfPage > 0 else {return}
        sliderView.removeAllArrangedSubviews()
        for i in 0...numberOfPage {
            let view = UIView()
            let isIndex = i == currentIndex
            view.backgroundColor = isIndex ? R.color.mainPrimary()! : R.color.mainPrimary()!.withAlphaComponent(0.5)
            view.layer.cornerRadius = 4
            sliderView.addArrangedSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                view.heightAnchor.constraint(equalTo: sliderView.heightAnchor, multiplier: 1),
                view.widthAnchor.constraint(equalToConstant: isIndex ? 20 : 8)
            ])
        }
        if currentIndex == (listIntro.count - 1) {
            btnNext.setTitle(LocalizableUtils.commonStart().uppercased(), for: .normal)
        } else {
            btnNext.setTitle(LocalizableUtils.commonNext().uppercased(), for: .normal)
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
            customPageControl(currentIndex: currentPage)
        } else {
            UserDefaults.standard.set(true, forKey: UserDefault.showedIntro.rawValue)
            AppRouter.shared.navigate(to: TabbarViewRoute.main, with: .changeRoot)
        }
    }
    
}

// MARK: - Setup view
extension IntroController {
    
    private func setupView() {
        fsPagerView.dataSource = self
        fsPagerView.delegate = self
        fsPagerView.isInfinite = false
        fsPagerView.decelerationDistance = 1
        fsPagerView.register(cellType: IntroductionCell.self)
        customPageControl()
        loadAdsHigh()
        preloadAdsNative()
    }
    
    private func loadAdsHigh() {
        self.viewAds.isHidden = false
        ADManager.shared.loadNative(DollColoringAdID.native_onboarding_high,
                                    to: viewAds, refreshAd: true) { [weak self] idAds, success, _  in
            guard idAds.contains(DollColoringAdID.native_onboarding_high.adId) else {return}
            if !success {
                self?.loadAds()
            }
        }
    }
    
    private func loadAds() {
        self.viewAds.isHidden = false
        ADManager.shared.loadNative(DollColoringAdID.native_onboarding,
                                    to: viewAds, refreshAd: true) { [weak self] idAds, success, _  in
            guard idAds.contains(DollColoringAdID.native_onboarding.adId) else {return}
            self?.viewAds.isHidden = !success
        }
    }
    
    func preloadAdsNative() {
    }
    
}

extension IntroController: FSPagerViewDelegate, FSPagerViewDataSource {
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return listIntro.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(for: index, cellType: IntroductionCell.self)
        let intro = listIntro[index]
        cell.loadData(intro: intro)
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
        customPageControl(currentIndex: currentPage)
    }
    
}
