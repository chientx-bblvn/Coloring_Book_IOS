//
//  HomeAdsCell.swift
//  Doll-Coloring
//
//  Created by Việt Anh Nguyễn on 6/5/24.
//

import UIKit
import Reusable

class HomeAdsCell: UICollectionViewCell, NibReusable {

    @IBOutlet weak var adsView: UIView!
    
    var actionAds: ((Bool) -> Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        adsView.layer.borderWidth = 0
        adsView.generateOuterShadow()
        adsView.layer.cornerRadius = 16
        loadAds()
    }
    
    func loadAds() {
        ADManager.shared.loadNative(DollColoringAdID.native_home, to: adsView, nativeAdType: .customNativeMediaHorizontal) {[weak self] adId, success, nativeAdView in
            if adId.contains(DollColoringAdID.native_home.adId) {
                self?.adsView.isHidden = !success
                self?.actionAds?(success)
            }
        }
    }
}
