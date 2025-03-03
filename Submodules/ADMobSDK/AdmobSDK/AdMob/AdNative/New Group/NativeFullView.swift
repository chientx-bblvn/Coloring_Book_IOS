//
//  IntroAdView.swift
//  PetLanguage
//
//  Created by Lê Minh Sơn on 21/11/24.
//

import UIKit
import GoogleMobileAds

extension NativeAdType {
    public static var nativeAdFull: NativeAdType {
        return .custom(nibName: "NativeFullView")
    }
}

class NativeFullView: GADNativeAdView {
    
    @IBOutlet private weak var btnAd: UIButton!
    @IBOutlet private weak var imageViewMedia: UIImageView!
    
    var onClickNext: (() -> Void)?
    var gadNativeAd: GADNativeAd?
    var adUnitID: String?
    
    class func addToView(viewContainer: UIView) -> NativeFullView? {
        guard let view = Bundle.main.loadNibNamed("NativeFullView", owner: nil, options: nil)?.first as? NativeFullView else { return nil }
        view.translatesAutoresizingMaskIntoConstraints = false
        viewContainer.addSubview(view)
        NSLayoutConstraint.activate([
            viewContainer.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            viewContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            viewContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            viewContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0)
        ])
        return view
    }
    
    func loadData(nativeAd: GADNativeAd?) {
        let btnNext = callToActionView as? UIButton
        stopSkeletonAnimation()
        hideSkeleton()
        btnNext?.isUserInteractionEnabled = true
        imageViewMedia.contentMode = .scaleAspectFit
        if let ad = nativeAd {
            bindingData(nativeAd: ad)
        }
    }
    
    func bindingData(nativeAd: GADNativeAd) {
        nativeAd.delegate = self
        gadNativeAd = nativeAd
        let btnNext = callToActionView as? UIButton
        let headlineLb = headlineView as? UILabel
        let bodyLb = bodyView as? UILabel
        let iconImageView = iconView as? UIImageView
        
        iconImageView?.isHidden = false
        imageViewMedia.contentMode = .scaleAspectFill
        self.hideSkeleton()
        btnAd.isHidden = false
        
        headlineLb?.text = nativeAd.headline
        let mediaContent = nativeAd.mediaContent
        self.imageViewMedia?.isHidden = mediaContent.hasVideoContent
        self.mediaView?.isHidden = !mediaContent.hasVideoContent
        mediaView?.scalesLargeContentImage = true
        mediaView?.mediaContent = mediaContent
        mediaView?.contentMode = .scaleAspectFill
        
        bodyLb?.text = nativeAd.body
        bodyLb?.isHidden = nativeAd.body == nil
        imageViewMedia.image = nativeAd.images?.first?.image
        
        btnNext?.setTitle(nativeAd.callToAction, for: .normal)
        btnNext?.isHidden = nativeAd.callToAction == nil
        
        iconImageView?.image = nativeAd.icon?.image ??  nativeAd.images?.first?.image
        iconImageView?.isHidden = iconImageView?.image == nil
        
        self.nativeAd = nativeAd
    }
    
}

extension NativeFullView: GADNativeAdDelegate {
    func nativeAdDidRecordClick(_ nativeAd: GADNativeAd) {
        FirebaseEventManager.logEvent(with: "user_click_ads",
                                      params: ["adunitid" : nativeAd.advertiser ?? (adUnitID ?? "")])
        onClickNext?()
    }
}


extension NativeFullView: NativeAdProtocol {
    
    func getGADView() -> GADNativeAdView {
        return self
    }
}
