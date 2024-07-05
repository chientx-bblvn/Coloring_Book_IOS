//
//  IntroductionCell.swift
//  Doll-Coloring
//
//  Created by BBLabs on 13/08/2023.
//

import UIKit
import Reusable

class IntroductionCell: FSPagerViewCell, NibReusable {
    
    @IBOutlet private weak var imageviewIntro: UIImageView!
    @IBOutlet private weak var lbTitle: UILabel!
    @IBOutlet private weak var lbSubTitle: UILabel!
    @IBOutlet weak var indicatorImg: UIImageView!
    @IBOutlet weak var viewAds: UIView!
    
    @IBOutlet weak var btnNext: UIButton!
    
    var onNext: (() -> Void)?
    private var isLoadingAd = false
    
    
    
    func loadData(intro: IntroModel) {
        switch intro.id {
        case 0:
            changeButtonNext(LocalizableUtils.commonNext())
            viewAds.isHidden = true
        case 1:
            changeButtonNext(LocalizableUtils.commonStart())
            viewAds.isHidden = false
            loadAdsHigh()
        case 2:
            changeButtonNext(LocalizableUtils.commonNext())
            viewAds.isHidden = true
        default:
            break
        }
        imageviewIntro.image = intro.image
        lbTitle.text = intro.name
        lbSubTitle.text = intro.desc
        indicatorImg.image = intro.indicator
    }
    
    func changeButtonNext(_ title: String) {
        self.btnNext.setTitle(title, for: .normal)
    }
    
    private func loadAdsHigh() {
        self.viewAds.isHidden = false
        ADManager.shared.loadNative(DollColoringAdID.native_onboarding_high,
                                    to: viewAds, refreshAd: true, nativeAdType: .customMediaFixedHeight) { [weak self] idAds, success, _  in
            guard idAds.contains(DollColoringAdID.native_onboarding_high.adId) else {return}
            if !success {
                self?.loadAds()
            }
        }
    }
    
    private func loadAds() {
        if isLoadingAd { return }
        isLoadingAd = true
        self.viewAds.isHidden = false
        ADManager.shared.loadNative(DollColoringAdID.native_onboarding,
                                    to: viewAds, refreshAd: true, nativeAdType: .customMediaFixedHeight) { [weak self] idAds, success, _  in
            guard idAds.contains(DollColoringAdID.native_onboarding.adId) else {return}
            self?.isLoadingAd = false
            self?.viewAds.isHidden = !success
        }
    }
    
    @IBAction func buttonNextOnTouch(_ sender: UIButton) {
        onNext?()
    }
    
}
