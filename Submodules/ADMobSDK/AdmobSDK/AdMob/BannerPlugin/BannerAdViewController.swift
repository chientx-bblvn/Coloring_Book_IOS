//
//  BannerAdView.swift
//  bannerplugin
//
//  Created by Hung Pham on 5/6/23.
//

import Foundation
import GoogleMobileAds
import SkeletonView

class BannerAdViewController : BaseAdViewController, GADBannerViewDelegate {
    
    private var lastCBRequestTime : Int64 = 0
    
    let adUnitId: String
    private let bannerType: BannerType
    private let cbFetchIntervalSec: Int
    
    var adView: GADBannerView?
    private var hasSetAdSize = false
    
    private var onAdLoadDone : ((_ adUnitID: String) -> Void)? = nil
    
    required init?(coder: NSCoder) {
        // Should not be used from storyboard or xib
        fatalError("init(coder:) has not been implemented")
    }
    
    required init(adUnitId: String,
                  bannerType: BannerType,
                  refreshRateSec: Int?,
                  cbFetchIntervalSec: Int) {
        self.adUnitId = adUnitId
        self.bannerType = bannerType
        self.cbFetchIntervalSec = cbFetchIntervalSec
        super.init(refreshRateSec: refreshRateSec)
        
        createAdBannerView()
        
        attachAdViewToMainView(adView: adView)
        
    }
    
    private func createAdBannerView() {
        adView = GADBannerView()
        adView?.isSkeletonable = true
        let gradient = SkeletonGradient(baseColor: UIColor.clouds)
        adView?.showAnimatedGradientSkeleton(usingGradient: gradient, animation: SkeletonAnimationBuilder().makeSlidingAnimation(withDirection: .leftRight, duration: 0.7))
        
        adView?.rootViewController = self
        adView?.adUnitID = adUnitId
    }
    
    private func attachAdViewToMainView(adView: GADBannerView?) {
        adView?.translatesAutoresizingMaskIntoConstraints = false
        if let ad = adView {
            view.addSubview(ad)
            view.addConstraints(
                [NSLayoutConstraint(item: ad,
                                    attribute: .centerY,
                                    relatedBy: .equal,
                                    toItem: view.safeAreaLayoutGuide,
                                    attribute: .centerY,
                                    multiplier: 1,
                                    constant: 0),
                 NSLayoutConstraint(item: ad,
                                    attribute: .centerX,
                                    relatedBy: .equal,
                                    toItem: view,
                                    attribute: .centerX,
                                    multiplier: 1,
                                    constant: 0)
                ])
        }
    }
    
    override func loadAdInternal(onDone: @escaping (_ adUnitID: String) -> Void) {
        if (!hasSetAdSize) {
            // Wait until view is rendered
            DispatchQueue.main.async {
                let adSize = self.getAdSize(bannerType: self.bannerType)
                self.adView?.adSize = adSize
                
                // Update layout width & height by ad size
                if let rootView = self.view {
                    rootView.addConstraints([
                        NSLayoutConstraint(item: rootView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: adSize.size.width),
                        NSLayoutConstraint(item: rootView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: adSize.size.height)
                    ])
                }
                
                self.hasSetAdSize = true
                self.doLoadAd(onDone: onDone)
            }
        } else {
            doLoadAd(onDone: onDone)
        }
    }
    
    private func getAdSize(bannerType: BannerType) -> GADAdSize {
        switch (bannerType) {
        case .Standard: return GADAdSizeBanner
        case .LargeBanner: return GADAdSizeLargeBanner
        case .MediumRectangle: return GADAdSizeMediumRectangle
        case .Adaptive,
                .CollapsibleBottom,
                .CollapsibleTop: return getAdaptiveSize()
        }
    }
    
    private func getAdaptiveSize() -> GADAdSize {
        var frame: CGRect
        
        if #available(iOS 11.0, *) {
            frame = view.frame.inset(by: view.safeAreaInsets)
        } else {
            frame = view.frame
        }
        
        var viewWidth = frame.size.width
        
        // Fallback to screen width if viewWidth = 0
        if (viewWidth == 0) {
            viewWidth = UIScreen.main.bounds.width
        }
        
        let adSize = GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(viewWidth)
        return adSize
    }
    
    private func doLoadAd(onDone: @escaping ((_ adUnitID: String) -> Void)) {
        var isCollapsibleBannerRequest = false
        
        let adRequest = GADRequest()
        switch (bannerType) {
        case .CollapsibleTop,
                .CollapsibleBottom:
            log(message: "shouldRequestCollapsible() = \(shouldRequestCollapsible())")
            
            if (shouldRequestCollapsible()) {
                let position = bannerType == .CollapsibleTop ? "top" : "bottom"
                let extras = GADExtras()
                extras.additionalParameters = ["collapsible": position]
                adRequest.register(extras)
                isCollapsibleBannerRequest = true
            }
        case .Standard: break
        case .LargeBanner: break
        case .MediumRectangle: break
        case .Adaptive: break
        }
        
        if (isCollapsibleBannerRequest) {
            lastCBRequestTime = getCurrentMillis()
        }
        
        adView?.paidEventHandler = { [weak self] value in
            guard let `self` = self else { return }
            let adUnitID = self.adView?.adUnitID ?? ""
            if let adNetworkName = self.adView?.responseInfo?.adNetworkInfoArray.first?.adNetworkClassName {
                print("Ad Network Name: \(adNetworkName)")
                
                var type: AdFormatType = .banner
                switch self.bannerType {
                case .Standard, .MediumRectangle, .LargeBanner:
                    type = .banner
                case .Adaptive:
                    type = .adaptive
                case .CollapsibleTop, .CollapsibleBottom:
                    type = .collapsible
                }
                AdMobManager.shared.trackAdRevenue(format: type,
                                                   value: value,
                                                   unitId: adUnitID,
                                                   adNetwork: adNetworkName)
            }
            self.onBannerPaidAds?(adUnitID)
        }
        onAdLoadDone = onDone
        adView?.delegate = self
        adView?.load(adRequest)
    }
    
    private func shouldRequestCollapsible() -> Bool {
        return getCurrentMillis() - lastCBRequestTime >= cbFetchIntervalSec * 1000
    }
    
    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
        let adUnitID = bannerView.adUnitID ?? ""
        print("ad==> bannerView did load \(adUnitID)")
        bannerView.hideSkeleton()
        bannerView.superview?.hideSkeleton()
        adView?.delegate = nil
        onAdLoadDone?(adUnitID)
        onLoadBannerSuccess?(adUnitID)
    }
    
    func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
        print("ad==> bannerView faild \(error.localizedDescription)")
        let adUnitID = bannerView.adUnitID ?? ""
        bannerView.delegate = nil
        adView?.delegate = nil
        onAdLoadDone?(adUnitID)
        onBannerFailed?(adUnitID)
    }
    
    func bannerViewDidRecordClick(_ bannerView: GADBannerView) {
        let adUnitID = bannerView.adUnitID ?? ""
        onBannerClick?(adUnitID)
        AdMobManager.shared.logEvenClick(id: adUnitID)
    }
    
    func bannerViewDidRecordImpression(_ bannerView: GADBannerView) {
        let adUnitID = bannerView.adUnitID ?? ""
        print("ad==> adViewDidRecordImpression bannerView\(adUnitID)")
        bannerView.delegate = nil
        bannerView.hideSkeleton()
        bannerView.superview?.hideSkeleton()
    }
    
    func bannerViewWillDismissScreen(_ bannerView: GADBannerView) {
        let adUnitID = bannerView.adUnitID ?? ""
        onBannerWillDismiss?(adUnitID)
    }

}
