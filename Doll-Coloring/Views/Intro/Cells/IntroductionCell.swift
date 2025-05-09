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
    @IBOutlet weak var imgInside: UIImageView!
    
    @IBOutlet weak var btnNext2: UIButton!
    
    
    var onNext: (() -> Void)?
    private var isLoadingAd = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.btnNext2.customGenerateOuterShadow(shadowOpacity: 1, shadowRadius: 0, color: UIColor(hexString: "000000"), shadowOffset: CGSize(width: 2, height: 2))
        
    }
        
    
    
    func loadData(intro: IntroModel) {
        switch intro.id {
        case 0:
            changeButtonNext(LocalizableUtils.commonNext())
            viewAds.isHidden = false
            self.btnNext.isHidden = false
            self.btnNext2.isHidden = true
            loadNativeAd(adId: .native_onboarding_1)
        case 1:
            changeButtonNext(LocalizableUtils.commonNext())
            viewAds.isHidden = true
            self.btnNext.isHidden = true
            self.btnNext2.isHidden = false
            self.indicatorImg.isHidden = true
           
//            loadNativeAd(adId: .native_onboarding_2)
        case 2:
            changeButtonNext(LocalizableUtils.commonStart())
            viewAds.isHidden = false
            self.btnNext.isHidden = false
            self.btnNext2.isHidden = true
            loadNativeAd(adId: .native_onboarding_3)
        default:
            break
        }
        imageviewIntro.image = intro.image
        lbTitle.text = intro.name
        lbSubTitle.text = intro.desc
        imgInside.image = intro.insideImage
        indicatorImg.image = intro.indicator
    }
    
    func changeButtonNext(_ title: String) {
        self.btnNext.setTitle(title, for: .normal)
        self.btnNext2.setTitle(title, for: .normal)
    }
    
    private func loadNativeAd(adId: DollColoringAdID) {
            if isLoadingAd { return }
            isLoadingAd = true
            viewAds.isHidden = false

            ADManager.shared.loadNative(adId, to: viewAds, nativeAdType: .customMediaFixedHeight) { [weak self] idAds, success, _ in
                guard idAds == adId.adId else { return }
                self?.isLoadingAd = false
                self?.viewAds.isHidden = !success
            }
        }
    
    @IBAction func buttonNextOnTouch(_ sender: UIButton) {
        onNext?()
    }
    
}
