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
        loadAds()
    }
    
    func loadAds() {
        ADManager.shared.loadNative(DollColoringAdID.native_home, to: adsView, nativeAdType: .smallMedia) {[weak self] adId, success, nativeAdView in
            if adId.contains(DollColoringAdID.native_home.adId) {
                self?.adsView.isHidden = !success
                self?.actionAds?(success)
            }
        }
    }

}
