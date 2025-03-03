//
//  FullScreenNativeAdsView.swift
//  AutoClick-iOS
//
//  Created by Nguyễn Việt Anh on 17/10/24.
//

import UIKit
import GoogleMobileAds
import SkeletonView

extension NativeAdType {
    static var customFullScreenNative: NativeAdType {
        return .custom(nibName: "FullScreenNativeAdsView")
    }
}


class FullScreenNativeAdsView: GADNativeAdView {

    @IBOutlet weak var lblAds: UILabel!
    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var lblRateCount: UILabel!
    
    var adUnitID: String?
    var gadNativeAd: GADNativeAd?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        lblAds.roundCorners(corners: [.topLeft, .bottomRight], radius: 6)
    }
    
    func bindingData(nativeAd: GADNativeAd) {
        gadNativeAd = nativeAd
        self.hideSkeleton()
        (self.headlineView as? UILabel)?.text = nativeAd.headline
        let mediaContent = nativeAd.mediaContent
        self.mediaView?.scalesLargeContentImage = true
        self.mediaView?.mediaContent = mediaContent
        self.mediaView?.contentMode = .scaleAspectFit
    
        (self.bodyView as? UILabel)?.text = nativeAd.body
        self.bodyView?.isHidden = nativeAd.body == nil
        bannerImageView.image = nativeAd.images?.first?.image
        bannerImageView.isHidden = mediaContent.hasVideoContent
        (self.callToActionView as? UIButton)?.setTitle(nativeAd.callToAction, for: .normal)
        self.callToActionView?.isHidden = nativeAd.callToAction == nil
        
        
        (self.iconView as? UIImageView)?.image = nativeAd.icon?.image
        self.iconView?.isHidden = nativeAd.icon == nil
        self.iconView?.layer.cornerRadius = 17
        self.iconView?.layer.masksToBounds = true
        (self.starRatingView as? UIImageView)?.image = self.imageOfStars(from: nativeAd.starRating)
        self.starRatingView?.isHidden = nativeAd.starRating == nil || nativeAd.starRating == 0
        self.lblRateCount.isHidden = nativeAd.starRating == nil || nativeAd.starRating == 0
        self.lblRateCount.text = "\(nativeAd.starRating ?? 0)"
        (self.storeView as? UILabel)?.text = nativeAd.store
        self.storeView?.isHidden = nativeAd.store == nil

        (self.priceView as? UILabel)?.text = nativeAd.price
        self.priceView?.isHidden = nativeAd.price == nil

        (self.advertiserView as? UILabel)?.text = nativeAd.advertiser
        self.advertiserView?.isHidden = nativeAd.advertiser == nil
        
        self.nativeAd = nativeAd
    }
    
    func imageOfStars(from starRating: NSDecimalNumber?) -> UIImage? {
        guard let rating = starRating?.doubleValue else {
            return nil
        }
        if rating >= 5 {
            return UIImage(named: "stars_5.png", in: Bundle(for: type(of: self)), compatibleWith: nil)
        } else if rating >= 4.5 {
            return UIImage(named: "stars_4_5.png", in: Bundle(for: type(of: self)), compatibleWith: nil)
        } else if rating >= 4 {
            return UIImage(named: "stars_4.png", in: Bundle(for: type(of: self)), compatibleWith: nil)
        } else if rating >= 3.5 {
            return UIImage(named: "stars_3_5.png", in: Bundle(for: type(of: self)), compatibleWith: nil)
        } else {
            return nil
        }
    }
}

extension FullScreenNativeAdsView: NativeAdProtocol {
    func getGADView() -> GADNativeAdView {
        return self
    }
}
