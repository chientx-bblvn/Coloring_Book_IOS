//
//  ADManager+LoadAds.swift
//  AnimalTranslate-iOS
//
//  Created by BBLabs on 23/08/2023.
//

import Foundation
import GoogleMobileAds
import UIKit

public enum AdvertResult {
    case loaded
    case showed
    case closed
    case success(amount: NSDecimalNumber)
    case error
}

extension UIApplicationDelegate {
    public func getRootViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return getRootViewController(base: nav.visibleViewController)
        } else if let tab = base as? UITabBarController,
                  let selected = tab.selectedViewController {
            return getRootViewController(base: selected)
        } else if let presented = base?.presentedViewController {
            return getRootViewController(base: presented)
        }
        return base
    }
}

// MARK: - Load and reload Ads
extension ADManager {
    
    public var isTestMode: Bool { // Setting cho chế độ testmode
        return showState?.isTestMode ?? false
    }
    
    internal var isShowBanner: Bool {
        return (showState?.isShowBanner ?? false) && !IAPState.isUserVip
    }
    
    internal var isShowFull: Bool {
        return (showState?.isShowFull ?? false) && !IAPState.isUserVip
    }
    
    internal var isShowOpen: Bool {
        return (showState?.isShowOpen ?? false) && !IAPState.isUserVip
    }
    
    internal var isShowNative: Bool {
        return (showState?.isShowNative ?? false) && !IAPState.isUserVip
    }
    
    internal var isShowReward: Bool {
        return (showState?.isShowReward ?? false) && !IAPState.isUserVip
    }
    
    fileprivate var timeRemoteShowOpen: Int {
        return configTime?.timeShowOpen ?? 15
    }
    
    fileprivate var timeRemoteShowReward: Int {
        return configTime?.timeShowReward ?? 20
    }
    
    public var timeRemoteShowFull: Int {
        return configTime?.timeShowFull ?? 20
    }
    
    public var maxClickShowAd: Int {
        return configTime?.maxClickShowAd ?? 5
    }
    
}

extension ADManager {
    
    public func loadOpen(_ id: AdConfigId) {
        if AdResumeManager.shared.isShowingAd
            || AdResumeManager.shared.isLoadingAd { return }
        AdResumeManager.shared.appOpenAdManagerDelegate = nil
        var adId = id.adUnitId
        if isTestMode {
            adId = SampleAdUnitID.adFormatAppOpen
        }
        BBLLogging.d("ADMANAGER: OPEN \(id.name) with id: \(adId.rawValue)")
        guard id.isEnableAd else {
            BBLLogging.d("ADMANAGER: OPEN REMOTE CLOSE")
            return
        }
        AdResumeManager.shared.resumeAdId = adId
        if (Int(Date().timeIntervalSince1970) - timeShowOpen) <= timeRemoteShowOpen {
            BBLLogging.d("ADMANAGER: OPEN NOT MATCH TIME")
            return
        }
        
        if let controller = UIApplication.getTopViewController() {
            if AdResumeManager.shared.showAdIfAvailable(id: adId.rawValue, viewController: controller) {
                BBLLogging.d("ADMANAGER: OPEN SHOWING FOR AVAILABLE")
                self.timeShowOpen = Int(Date().timeIntervalSince1970)
            } else {
                BBLLogging.d("ADMANAGER: OPEN SHOWING FOR NOT AVAILABLE")
            }
        }
    }
    
    public func loadOpenAsync(_ id: AdConfigId, completion: @escaping ((_ showed: Bool) -> Void)) {
        var adId = id.adUnitId
        if isTestMode {
            adId = SampleAdUnitID.adFormatAppOpen
        }
        BBLLogging.d("ADMANAGER: OPEN ASYNC \(id.name) with id: \(adId.rawValue)")
        guard id.isEnableAd else {
            BBLLogging.d("ADMANAGER: OPEN REMOTE CLOSE")
            completion(false)
            return
        }
        if let controller = UIApplication.getTopViewController() {
            AdResumeManager.shared.appOpenAdManagerDelegate = completion
            AdResumeManager.shared.showOpenAd(adId: adId, viewController: controller)
        } else {
            completion(false)
        }
    }
    
    public func preloadInterstitial(_ id: AdConfigId,
                                    completion: ((_ success: Bool) -> Void)? = nil) {
        var adId = id.adUnitId
        if isTestMode {
            adId = SampleAdUnitID.adFormatInterstitialVideo
        }
        BBLLogging.d("ADMANAGER: PRELOAD FULL \(id.name) with id: \(adId.rawValue)")
        guard id.isEnableAd else {
            BBLLogging.d("ADMANAGER: FULL REMOTE CLOSE")
            completion?(false)
            return
        }
        BBLLogging.d("ADMANAGER: FULL Loading")
        AdMobManager.shared.preloadIntestialAd(unitId: adId,
                                               completion: completion)
    }
    
    public func loadFull(_ id: AdConfigId,
                         isSplash: Bool = false,
                         needRefresh: Bool = true,
                         _ completion: ((AdvertResult) -> Void)? = nil) {
        var adId = id.adUnitId
        if isTestMode {
            adId = SampleAdUnitID.adFormatInterstitialVideo
        }
        BBLLogging.d("ADMANAGER: FULL \(id.name) with id: \(adId.rawValue)")
        guard id.isEnableAd else {
            BBLLogging.d("ADMANAGER: FULL REMOTE CLOSE")
            completion?(.closed)
            return
        }
        if isShowingAd {
            BBLLogging.d("ADMANAGER: FULL HAS AD SHOWING")
            completion?(.error)
            return
        }
        self.isShowingAd = true
        BBLLogging.d("ADMANAGER: FULL Loading")
        AdMobManager.shared.showIntertitial(unitId: adId, isSplash: isSplash, blockWillDismiss: { [weak self] in
            self?.isShowingAd = false
            completion?(.showed)
        }, blockDidDismiss: { [weak self] in
            BBLLogging.d("ADMANAGER: FULL Showed and closed")
            AdMobManager.shared.blockFullScreenAdFailed = nil
            self?.isShowingAd = false
            completion?(.closed)
        }) {
            BBLLogging.d("ADMANAGER: FULL Showed and fail")
            AdMobManager.shared.blockFullScreenAdFailed = nil
            self.isShowingAd = false
            completion?(.error)
        }
    }
    
    public func preLoadReward(_ id: AdConfigId,
                              completion: BoolBlockAds? = nil) {
        var adId = id.adUnitId
        if isTestMode {
            adId = SampleAdUnitID.adFormatRewarded
        }
        BBLLogging.d("ADMANAGER: REWARD \(adId)")
        guard id.isEnableAd else {
            BBLLogging.d("ADMANAGER: REWARD REMOTE CLOSE")
            completion?(false)
            return
        }
        BBLLogging.d("ADMANAGER: REWARD SHOWED started")
        AdMobManager.shared.createAdRewardedIfNeed(unitId: adId, completion: completion)
    }
    
    public func loadReward(_ id: AdConfigId, _ completion: ((AdvertResult) -> Void)? = nil) {
        var adId = id.adUnitId
        if isTestMode {
            adId = SampleAdUnitID.adFormatRewarded
        }
        BBLLogging.d("ADMANAGER: REWARD \(adId)")
        guard id.isEnableAd else {
            BBLLogging.d("ADMANAGER: REWARD REMOTE CLOSE")
            completion?(.closed)
            return
        }
        if isShowingAd {
            BBLLogging.d("ADMANAGER: REWARD HAS AD SHOWING")
            completion?(.showed)
            return
        }
        self.isShowingAd = true
        BBLLogging.d("ADMANAGER: REWARD SHOWED started")
        AdMobManager.shared.showRewarded(unitId: adId) { [weak self] earned in
            BBLLogging.d("ADMANAGER: REWARD Completed \(earned)")
            if let amount = earned {
                self?.isShowingAd = false
                completion?(.success(amount: amount))
            } else {
                self?.isShowingAd = false
                completion?(.error)
            }
        }
    }
    
    public func loadBanner(_ id: AdConfigId, viewBanner: UIView, completion: @escaping ((_ success: Bool) -> Void)) {
        var adId = id.adUnitId
        if isTestMode {
            adId = SampleAdUnitID.adFormatBanner
        }
        BBLLogging.d("ADMANAGER: BANNER  \(adId)")
        guard                 id.isEnableAd,
                              let viewController = UIApplication.getTopViewController() else {
            completion(false)
            BBLLogging.d("ADMANAGER: BANNER REMOTE CLOSE")
            return
        }
        AdMobManager.shared.blockBannerFailed = { adId in
            BBLLogging.d("ADMANAGER: BANNER LOAD FAILED: \(adId)")
            completion(false)
        }
        AdMobManager.shared.blockLoadBannerSuccess = { success in
            BBLLogging.d("ADMANAGER: BANNER LOAD SUCCESS: \(adId)")
            completion(success)
        }
        AdMobManager.shared.blockBannerClick = { str in
            BBLLogging.d("ADMANAGER: BANNER CLICKED AND REFRESH: \(str)")
            self.loadBanner(id, viewBanner: viewBanner, completion: completion)
        }
        AdMobManager.shared.addAdBanner(unitId: adId, rootVC: viewController, view: viewBanner)
    }
    
    public func loadBannerAdaptive(_ id: AdConfigId, viewBanner: UIView, completion: @escaping ((_ success: Bool) -> Void)) {
        var adId = id.adUnitId
        if isTestMode {
            adId = SampleAdUnitID.adFormatBanner_2
        }
        BBLLogging.d("ADMANAGER: BANNER")
        guard               id.isEnableAd,
                            let viewController = UIApplication.getTopViewController() else {
            completion(false)
            BBLLogging.d("ADMANAGER: BANNER REMOTE CLOSE")
            return
        }
        AdMobManager.shared.blockBannerFailed = { adId in
            BBLLogging.d("ADMANAGER: BANNER ADAPTIVE LOAD FAILED: \(adId)")
            completion(false)
        }
        AdMobManager.shared.blockLoadBannerSuccess = { success in
            BBLLogging.d("ADMANAGER: BANNER ADAPTIVE LOAD SUCCESS: \(adId)")
            completion(success)
        }
        AdMobManager.shared.blockBannerClick = { str in
            BBLLogging.d("ADMANAGER: BANNER ADAPTIVE CLICKED AND REFRESH: \(str)")
            self.loadBannerAdaptive(id, viewBanner: viewBanner, completion: completion)
        }
        AdMobManager.shared.addAdBannerAdaptive(unitId: adId, rootVC: viewController, view: viewBanner)
    }
    
    public func loadCollapsibleBannerAdaptive(_ id: AdConfigId,
                                              viewBanner: UIView,
                                              isCollapsible: Bool = false,
                                              completion: @escaping ((_ success: Bool) -> Void)) {
        var adId = id.adUnitId
        if isTestMode {
            adId = SampleAdUnitID.adFormatCollapsibleBanner
        }
        BBLLogging.d("ADMANAGER: BANNER")
        guard               id.isEnableAd,
                            let viewController = UIApplication.getTopViewController() else {
            completion(false)
            BBLLogging.d("ADMANAGER: BANNER REMOTE CLOSE")
            return
        }
        AdMobManager.shared.blockBannerFailed = { adId in
            BBLLogging.d("ADMANAGER: BANNER COLLAPSIBLE ADAPTIVE LOAD FAILED: \(adId)")
            completion(false)
        }
        AdMobManager.shared.blockLoadBannerSuccess = { success in
            BBLLogging.d("ADMANAGER: BANNER COLLAPSIBLE ADAPTIVE LOAD SUCCESS: \(adId)")
            completion(success)
        }
        AdMobManager.shared.blockBannerClick = { str in
            BBLLogging.d("ADMANAGER: BANNER COLLAPSIBLE  ADAPTIVE CLICKED AND REFRESH: \(str)")
            self.loadCollapsibleBannerAdaptive(id, viewBanner: viewBanner, completion: completion)
        }
        AdMobManager.shared.addAdCollapsibleBannerAdaptive(unitId: adId, rootVC: viewController,
                                                           view: viewBanner, isCollapsibleBanner: isCollapsible)
    }
}

// MARK: - Native load
extension ADManager {
    
    public func preLoadNative(_ id: AdConfigId,
                              refreshAd: Bool = false,
                              nativeAdType: NativeAdType = .smallMedia,
                              ratio: GADMediaAspectRatio = .any,
                              completion: ((_ adId: String,
                                            _ success: Bool) -> Void)? = nil) {
        var adId = id.adUnitId
        if isTestMode {
            adId = SampleAdUnitID.adFormatNativeAdvancedVideo
        }
        guard id.isEnableAd else {
            return
        }
        AdMobManager.shared.blockNativeFailed = { adId in
            BBLLogging.d("ADMANAGER: NATIVE LOAD FAILED: \(adId)")
            completion?(adId, false)
        }
        AdMobManager.shared.blockLoadNativeSuccess = { idRequested, nativeAdView in
            BBLLogging.d("ADMANAGER: NATIVE LOAD SUCCESS: \(idRequested ?? "")")
            completion?(idRequested ?? "", idRequested?.elementsEqual(adId.rawValue) ?? true)
        }
        AdMobManager.shared.preloadAdNative(unitId: adId,
                                            refreshAd: refreshAd,
                                            type: nativeAdType,
                                            ratio: ratio)
    }
    
    public func preLoadNative(_ id: AdConfigId,
                              refreshAd: Bool = false,
                              nativeAdType: NativeAdType = .smallMedia,
                              ratio: GADMediaAspectRatio = .any) {
        var adId = id.adUnitId
        if isTestMode {
            adId = SampleAdUnitID.adFormatNativeAdvancedVideo
        }
        guard id.isEnableAd else {
            return
        }
        AdMobManager.shared.preloadAdNative(unitId: adId,
                                            refreshAd: refreshAd,
                                            type: nativeAdType,
                                            ratio: ratio)
    }
    
    public func loadNative(_ id: AdConfigId,
                           to view: UIView,
                           refreshAd: Bool = false,
                           nativeAdType: NativeAdType,
                           ratio: GADMediaAspectRatio = .landscape,
                           _ completion: @escaping ((_ adId: String,
                                                     _ success: Bool,
                                                     _ nativeAdView: NativeAdProtocol?) -> Void)) {
        var adId = id.adUnitId
        if isTestMode {
            adId = SampleAdUnitID.adFormatNativeAdvancedVideo
        }
        guard id.isEnableAd else {
            completion(id.adId, false, nil)
            return
        }
        AdMobManager.shared.blockNativeFailed = { adId in
            BBLLogging.d("ADMANAGER: NATIVE LOAD FAILED: \(adId)")
            completion(adId, false, nil)
        }
        AdMobManager.shared.blockLoadNativeSuccess = { idRequested, nativeAdView in
            BBLLogging.d("ADMANAGER: NATIVE LOAD SUCCESS: \(idRequested ?? "")")
            if idRequested?.elementsEqual(adId.rawValue) == true {
                if let adView = nativeAdView?.getGADView() {
                    adView.removeFromSuperview()
                    adView.translatesAutoresizingMaskIntoConstraints = false
                    view.addSubview(adView)
                    NSLayoutConstraint.activate([
                        adView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
                        adView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
                        adView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
                        adView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0)
                        
                    ])
                }
                completion(idRequested ?? "", true, nativeAdView)
            }
        }
        
        AdMobManager.shared.addAdNative(unitId: adId,
                                        view: view,
                                        refreshAd: refreshAd,
                                        type: nativeAdType,
                                        ratio: ratio)
    }
    
    public func loadNativeClick(_ id: AdConfigId,
                           to view: UIView,
                           refreshAd: Bool = false,
                           nativeAdType: NativeAdType,
                           ratio: GADMediaAspectRatio = .landscape,
                           _ completion: @escaping ((_ adId: String,
                                                     _ success: Bool,
                                                     _ nativeAdView: NativeAdProtocol?) -> Void), onClickAds: @escaping () -> Void) {
        var adId = id.adUnitId
        if isTestMode {
            adId = SampleAdUnitID.adFormatNativeAdvancedVideo
        }
        guard id.isEnableAd else {
            completion(id.adId, false, nil)
            return
        }
        AdMobManager.shared.blockNativeFailed = { adId in
            BBLLogging.d("ADMANAGER: NATIVE LOAD FAILED: \(adId)")
            completion(adId, false, nil)
        }
        AdMobManager.shared.blockLoadNativeSuccess = { idRequested, nativeAdView in
            BBLLogging.d("ADMANAGER: NATIVE LOAD SUCCESS: \(idRequested ?? "")")
            if idRequested?.elementsEqual(adId.rawValue) == true {
                if let adView = nativeAdView?.getGADView() {
                    adView.removeFromSuperview()
                    adView.translatesAutoresizingMaskIntoConstraints = false
                    view.addSubview(adView)
                    NSLayoutConstraint.activate([
                        adView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
                        adView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
                        adView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
                        adView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0)
                        
                    ])
                }
                completion(idRequested ?? "", true, nativeAdView)
            }
        }
        
        AdMobManager.shared.blockClickAdsNative = {
            onClickAds()
        }
        AdMobManager.shared.addAdNative(unitId: adId,
                                        view: view,
                                        refreshAd: refreshAd,
                                        type: nativeAdType,
                                        ratio: ratio)
    }
    
    
    public func loadNativeWithoutView(_ id: AdConfigId,
                                      refreshAd: Bool = false,
                                      nativeAdType: NativeAdType,
                                      ratio: GADMediaAspectRatio = .landscape,
                                      _ completion: @escaping ((_ adId: String,
                                                                _ success: Bool,
                                                                _ nativeAdView: NativeAdProtocol?) -> Void)) {
        var adId = id.adUnitId
        if isTestMode {
            adId = SampleAdUnitID.adFormatNativeAdvancedVideo
        }
        guard id.isEnableAd else {
            completion(id.adId, false, nil)
            return
        }
        AdMobManager.shared.blockNativeFailed = { adId in
            BBLLogging.d("ADMANAGER: NATIVE LOAD FAILED: \(adId)")
            completion(adId, false, nil)
        }
        AdMobManager.shared.blockLoadNativeSuccess = { idRequested, nativeAdView in
            BBLLogging.d("ADMANAGER: NATIVE LOAD SUCCESS: \(idRequested ?? "")")
            if idRequested?.elementsEqual(adId.rawValue) == true {
                completion(idRequested ?? "", true, nativeAdView)
            }
        }
        AdMobManager.shared.addAdNativeWithoutView(unitId: adId,
                                                   refreshAd: refreshAd,
                                                   type: nativeAdType,
                                                   ratio: ratio)
    }
    
    public func showNativeFull(_ adId: AdConfigId,
                               refreshAd: Bool = false,
                               config: AdNativeFullConfig = AdNativeFullConfig.default,
                               nativeAdType: NativeAdType = .nativeAdFull,
                               _ completion: @escaping ((_ result: AdvertResult) -> Void)) {
        BBLLogging.d("ADMANAGER: FULL \(adId.name) with id: \(adId.adUnitId.rawValue)")
        guard adId.isEnableAd else {
            BBLLogging.d("ADMANAGER: FULL REMOTE CLOSE")
            completion(.closed)
            return
        }
        if isShowingAd {
            BBLLogging.d("ADMANAGER: FULL HAS AD SHOWING")
            completion(.showed)
            return
        }
        self.isShowingAd = true
        AdResumeManager.shared.isShowingAd = true
        BBLLogging.d("ADMANAGER: FULL Loading")
        _ = AdNativeFullView.show(adId,
                                  refreshAd: refreshAd,
                                  nativeAdType: nativeAdType,
                                  config: config,
                                  completion: completion)
    }
    
}

// MARK: - New Force Native load
extension ADManager {
    
    public func forcePreLoadNative(_ id: AdConfigId,
                              refreshAd: Bool = false,
                              nativeAdType: NativeAdType = .smallMedia,
                              ratio: GADMediaAspectRatio = .any,
                              completion: ((_ adId: String,
                                            _ success: Bool) -> Void)? = nil) {
        var adId = id.adUnitId
        if isTestMode {
            adId = SampleAdUnitID.adFormatNativeAdvancedVideo
        }
        AdMobManager.shared.blockNativeFailed = { adId in
            BBLLogging.d("ADMANAGER: NATIVE LOAD FAILED: \(adId)")
            completion?(adId, false)
        }
        AdMobManager.shared.blockLoadNativeSuccess = { idRequested, nativeAdView in
            BBLLogging.d("ADMANAGER: NATIVE LOAD SUCCESS: \(idRequested ?? "")")
            completion?(idRequested ?? "", idRequested?.elementsEqual(adId.rawValue) ?? true)
        }
        AdMobManager.shared.preloadAdNative(unitId: adId,
                                            refreshAd: refreshAd,
                                            type: nativeAdType,
                                            ratio: ratio)
    }
    
    public func forcePreLoadNative(_ id: AdConfigId,
                              refreshAd: Bool = false,
                              nativeAdType: NativeAdType = .smallMedia,
                              ratio: GADMediaAspectRatio = .any) {
        var adId = id.adUnitId
        if isTestMode {
            adId = SampleAdUnitID.adFormatNativeAdvancedVideo
        }
        AdMobManager.shared.preloadAdNative(unitId: adId,
                                            refreshAd: refreshAd,
                                            type: nativeAdType,
                                            ratio: ratio)
    }
    
    public func forceLoadNative(_ id: AdConfigId,
                           to view: UIView,
                           refreshAd: Bool = false,
                           nativeAdType: NativeAdType,
                           ratio: GADMediaAspectRatio = .landscape,
                           _ completion: @escaping ((_ adId: String,
                                                     _ success: Bool,
                                                     _ nativeAdView: NativeAdProtocol?) -> Void)) {
        var adId = id.adUnitId
        if isTestMode {
            adId = SampleAdUnitID.adFormatNativeAdvancedVideo
        }
        AdMobManager.shared.blockNativeFailed = { adId in
            BBLLogging.d("ADMANAGER: NATIVE LOAD FAILED: \(adId)")
            completion(adId, false, nil)
        }
        AdMobManager.shared.blockLoadNativeSuccess = { idRequested, nativeAdView in
            BBLLogging.d("ADMANAGER: NATIVE LOAD SUCCESS: \(idRequested ?? "")")
            if idRequested?.elementsEqual(adId.rawValue) == true {
                if let adView = nativeAdView?.getGADView() {
                    adView.removeFromSuperview()
                    adView.translatesAutoresizingMaskIntoConstraints = false
                    view.addSubview(adView)
                    NSLayoutConstraint.activate([
                        adView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
                        adView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
                        adView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
                        adView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0)
                        
                    ])
                }
                completion(idRequested ?? "", true, nativeAdView)
            }
        }
        AdMobManager.shared.addAdNative(unitId: adId,
                                        view: view,
                                        refreshAd: refreshAd,
                                        type: nativeAdType,
                                        ratio: ratio)
    }
    
    public func forceLoadNativeWithoutView(_ id: AdConfigId,
                                      refreshAd: Bool = false,
                                      nativeAdType: NativeAdType,
                                      ratio: GADMediaAspectRatio = .landscape,
                                      _ completion: @escaping ((_ adId: String,
                                                                _ success: Bool,
                                                                _ nativeAdView: NativeAdProtocol?) -> Void)) {
        var adId = id.adUnitId
        if isTestMode {
            adId = SampleAdUnitID.adFormatNativeAdvancedVideo
        }
        AdMobManager.shared.blockNativeFailed = { adId in
            BBLLogging.d("ADMANAGER: NATIVE LOAD FAILED: \(adId)")
            completion(adId, false, nil)
        }
        AdMobManager.shared.blockLoadNativeSuccess = { idRequested, nativeAdView in
            BBLLogging.d("ADMANAGER: NATIVE LOAD SUCCESS: \(idRequested ?? "")")
            if idRequested?.elementsEqual(adId.rawValue) == true {
                completion(idRequested ?? "", true, nativeAdView)
            }
        }
        AdMobManager.shared.addAdNativeWithoutView(unitId: adId,
                                                   refreshAd: refreshAd,
                                                   type: nativeAdType,
                                                   ratio: ratio)
    }
    
}

// Loading New single Banner
extension ADManager {
    
    public func loadSingleBanner(_ id: AdConfigId, viewBanner: UIView, completion: @escaping ((_ success: Bool) -> Void)) {
        var adId = id.adUnitId
        if isTestMode {
            adId = SampleAdUnitID.adFormatBanner
        }
        BBLLogging.d("ADMANAGER: BANNER  \(adId)")
        guard id.isEnableAd,
              let viewController = UIApplication.getTopViewController() else {
            completion(false)
            BBLLogging.d("ADMANAGER: BANNER REMOTE CLOSE")
            return
        }
        BannerLoader.shared.addAdBanner(unitId: adId, rootVC: viewController, view: viewBanner, completion: { unitId, success in
            completion(success)
        }, clickBanner: { unitId in
            self.loadSingleBanner(id, viewBanner: viewBanner, completion: completion)
        })
    }
    
    public func loadSingleBannerAdaptive(_ id: AdConfigId, viewBanner: UIView, completion: @escaping ((_ success: Bool) -> Void)) {
        var adId = id.adUnitId
        if isTestMode {
            adId = SampleAdUnitID.adFormatBanner_2
        }
        BBLLogging.d("ADMANAGER: BANNER")
        guard id.isEnableAd,
              let viewController = UIApplication.getTopViewController() else {
            completion(false)
            BBLLogging.d("ADMANAGER: BANNER REMOTE CLOSE")
            return
        }
        BannerLoader.shared.addAdBannerAdaptive(unitId: adId, rootVC: viewController, view: viewBanner, completion: { unitId, success in
            completion(success)
        }, clickBanner: { unitId in
            self.loadBannerAdaptive(id, viewBanner: viewBanner, completion: completion)
        })
    }
    
    public func loadSingleCollapsibleBannerAdaptive(_ id: AdConfigId,
                                                    viewBanner: UIView,
                                                    isCollapsible: Bool = false,
                                                    isTop: Bool = false,
                                                    completion: @escaping ((_ success: Bool) -> Void)) {
        var adId = id.adUnitId
        if isTestMode {
            adId = SampleAdUnitID.adFormatCollapsibleBanner
        }
        BBLLogging.d("ADMANAGER: BANNER")
        guard id.isEnableAd,
              let viewController = UIApplication.getTopViewController() else {
            completion(false)
            BBLLogging.d("ADMANAGER: BANNER REMOTE CLOSE")
            return
        }
        BannerLoader.shared
            .addAdCollapsibleBannerAdaptive(unitId: adId,
                                            rootVC: viewController,
                                            view: viewBanner,
                                            isCollapsibleBanner: isCollapsible,
                                            isTop: isTop, completion: { unitId, success in
                completion(success)
            }, clickBanner: { unitId in
                self.loadSingleCollapsibleBannerAdaptive(id, viewBanner: viewBanner, completion: completion)
            })
    }
    
}
// Force Load Banner
extension ADManager {
    
    public func forceLoadSingleBanner(_ id: AdConfigId,
                                      isTest: Bool = false,
                                      viewBanner: UIView,
                                      completion: @escaping ((_ success: Bool) -> Void)) {
        var adId = id.adUnitId
        if isTest {
            adId = SampleAdUnitID.adFormatBanner
        }
        BBLLogging.d("ADMANAGER: BANNER  \(adId)")
        guard let viewController = UIApplication.getTopViewController() else {
            completion(false)
            BBLLogging.d("ADMANAGER: BANNER REMOTE CLOSE")
            return
        }
        BannerLoader.shared.addAdBanner(unitId: adId, rootVC: viewController, view: viewBanner, completion: { unitId, success in
            completion(success)
        }, clickBanner: { _ in })
    }
    
    public func forceLoadSingleBannerAdaptive(_ id: AdConfigId,
                                              isTest: Bool = false,
                                              viewBanner: UIView,
                                              completion: @escaping ((_ success: Bool) -> Void)) {
        var adId = id.adUnitId
        if isTest {
            adId = SampleAdUnitID.adFormatBanner_2
        }
        BBLLogging.d("ADMANAGER: FORCE BANNER")
        guard let viewController = UIApplication.getTopViewController() else {
            completion(false)
            BBLLogging.d("ADMANAGER: FORCE BANNER REMOTE CLOSE")
            return
        }
        BannerLoader.shared.addAdBannerAdaptive(unitId: adId, rootVC: viewController, view: viewBanner, completion: { unitId, success in
            completion(success)
        }, clickBanner: { unitId in
        })
    }
    
    public func forceLoadSingleCollapsibleBannerAdaptive(_ id: AdConfigId,
                                                         isTest: Bool = false,
                                                         viewBanner: UIView,
                                                         isCollapsible: Bool = false,
                                                         isTop: Bool = false,
                                                         completion: @escaping ((_ success: Bool) -> Void)) {
        var adId = id.adUnitId
        if isTest {
            adId = SampleAdUnitID.adFormatCollapsibleBanner
        }
        BBLLogging.d("ADMANAGER: FORCE BANNER")
        guard let viewController = UIApplication.getTopViewController() else {
            completion(false)
            BBLLogging.d("ADMANAGER: FORCE BANNER REMOTE CLOSE")
            return
        }
        BannerLoader.shared
            .addAdCollapsibleBannerAdaptive(unitId: adId,
                                            rootVC: viewController,
                                            view: viewBanner,
                                            isCollapsibleBanner: isCollapsible,
                                            isTop: isTop, completion: { unitId, success in
                completion(success)
            }, clickBanner: { unitId in
            })
    }
    
}

// Loading New Refresh Banner
extension ADManager {
    
    public func loadRefreshBanner(_ id: AdConfigId,
                                  refreshRateSec: Int = 15,
                                  cbFetchIntervalSec: Int = 20,
                                  viewBanner: UIView,
                                  type: BannerType = .Standard,
                                  completion: @escaping ((_ success: Bool) -> Void)) {
        var adId = id.adUnitId
        if isTestMode {
            adId = SampleAdUnitID.adFormatBanner
        }
        BBLLogging.d("ADMANAGER: BANNER  \(adId)")
        guard id.isEnableAd,
              let viewController = UIApplication.getTopViewController() else {
            BBLLogging.d("ADMANAGER: BANNER REMOTE CLOSE")
            completion(false)
            return
        }
        
        let bannerConfig = BannerPlugin.Config(defaultAdUnitId: id.adId,
                                               defaultBannerType: type)
        bannerConfig.defaultRefreshRateSec = refreshRateSec
        if [.CollapsibleTop, .CollapsibleBottom].contains(where: {type == $0}) {
            bannerConfig.defaultCBFetchIntervalSec = cbFetchIntervalSec
        }
        BannerRefreshLoader.shared.loadRefreshBanner(config: bannerConfig,
                                                     viewBanner: viewBanner,
                                                     viewController: viewController,
                                                     onBannerFailed: { adUnitId in
            if !ADManager.shared.isTestMode {
                if adUnitId != adId.rawValue { return }
            }
            BBLLogging.d("ADMANAGER: BANNER LOAD FAILED!")
            completion(false)
        }, onLoadBannerSuccess: { adUnitId in
            if !ADManager.shared.isTestMode {
                if adUnitId != adId.rawValue { return }
            }
            BBLLogging.d("ADMANAGER: BANNER LOAD SUCCESS!")
            completion(true)
        })
    }
    
    public func loadRefreshBanner(with key: KeyRemote,
                                  viewBanner: UIView,
                                  completion: @escaping ((_ success: Bool) -> Void)) {
        let adConfigKey = key.key
        guard let keyConfig = RemoteConfigManager.shared.getBannerConfig(key: adConfigKey) else {
            BBLLogging.d("ADMANAGER: BANNER REMOTE KEY NOT EXISTED!")
            completion(false)
            return
        }
        BBLLogging.d("ADMANAGER: BANNER CONFIG KEY \(key)")
        guard !IAPState.isUserVip,
              ADManager.shared.isShowBanner,
              var adUnitId = keyConfig.adUnitId,
              !adUnitId.isEmpty,
              let viewController = UIApplication.getTopViewController() else {
            completion(false)
            BBLLogging.d("ADMANAGER: BANNER REMOTE CLOSE")
            return
        }
        
        guard let type = keyConfig.bannerType else {
            BBLLogging.d("ADMANAGER: BANNER REMOTE KEY NOT EXISTED!")
            completion(false)
            return
        }
        if isTestMode {
            adUnitId = SampleAdUnitID.adFormatBanner.rawValue
        }
        
        let bannerConfig = BannerPlugin.Config(defaultAdUnitId: adUnitId,
                                               defaultBannerType: type)
        bannerConfig.configKey = adConfigKey
        BannerRefreshLoader.shared.loadRefreshBanner(config: bannerConfig,
                                                     viewBanner: viewBanner,
                                                     viewController: viewController,
                                                     onBannerFailed: { adId in
            if !ADManager.shared.isTestMode {
                if adUnitId != adId { return }
            }
            BBLLogging.d("ADMANAGER: BANNER LOAD FAILED!")
            completion(false)
        },
                                                     onLoadBannerSuccess: { adId in
            if !ADManager.shared.isTestMode {
                if adUnitId != adId { return }
            }
            BBLLogging.d("ADMANAGER: BANNER LOAD SUCCESS!")
            completion(true)
        })
    }
    
}
