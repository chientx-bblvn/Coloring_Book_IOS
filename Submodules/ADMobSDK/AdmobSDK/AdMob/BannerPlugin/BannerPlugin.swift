//
//  BannerPlugin.swift
//  bannerplugin
//
//  Created by Hung Pham on 5/6/23.
//

import Foundation
import UIKit

public enum BannerType: String {
    case Standard = "Standard"
    case MediumRectangle = "MediumRectangle"
    case LargeBanner = "LargeBanner"
    case Adaptive = "Adaptive"
    case CollapsibleTop = "CollapsibleTop"
    case CollapsibleBottom = "CollapsibleBottom"
}

struct BannerConfig: Decodable {
    
    let adUnitId: String?
    let type: String?
    let refreshRateSec: Int?
    let cbFetchIntervalSec: Int?
    
    var bannerType: BannerType? {
        return BannerType(rawValue: type ?? "")
    }
    
    enum CodingKeys: String, CodingKey {
        case adUnitId = "ad_unit_id"
        case type = "type"
        case refreshRateSec = "refresh_rate_sec"
        case cbFetchIntervalSec = "cb_fetch_interval_sec"
    }
    
}

class BannerPlugin {
    
    static let LOG_ENABLED = true
    
    class Config {
        var defaultAdUnitId: String
        var defaultBannerType: BannerType
        
        /**
         * Remote config key to retrieve banner config data remotely
         * */
        var configKey: String? = nil
        
        /**
         * Banner refresh rate, in seconds. Pub are recommended to disable auto refresh from dashboard
         * Most of the case this is used to refresh a collapsible banner manually
         * */
        var defaultRefreshRateSec: Int? = nil
        
        /**
         * In seconds, indicate minimum time b/w 2 collapsible banner requests.
         * Only works with BannerType.CollapsibleTop or BannerType.CollapsibleBottom
         * If it is the time to send ad request but the duration to last request collapsible banner < cbFetchInterval,
         * Adaptive banner will be shown instead.
         * */
        var defaultCBFetchIntervalSec: Int = 180
        
        var loadAdAfterInit = false
        
        required init(defaultAdUnitId: String, defaultBannerType: BannerType) {
            self.defaultAdUnitId = defaultAdUnitId
            self.defaultBannerType = defaultBannerType
        }
        
        var adUnitId: String {
            if let key = configKey {
                let bannerConfig = RemoteConfigManager.shared.getBannerConfig(key: key)
                log(message: "bannerConfig = \(String(describing: bannerConfig))")
                return bannerConfig?.adUnitId ?? defaultAdUnitId
                
            }
            return defaultAdUnitId
        }
    }
    
    private var rootViewController: UIViewController?
    private var adContainer: UIView?
    private let config: Config
    
    private var adViewController: BaseAdViewController? = nil
    
    required init(rootViewController: UIViewController,
                  adContainer: UIView,
                  config: Config) {
        self.rootViewController = rootViewController
        self.adContainer = adContainer
        self.config = config
        
        initViewAndConfig()
        
        if (config.loadAdAfterInit) {
            loadAd()
        }
    }
    
    private func initViewAndConfig() {
        var adUnitId = config.defaultAdUnitId
        var bannerType = config.defaultBannerType
        var cbFetchIntervalSec = config.defaultCBFetchIntervalSec
        var refreshRateSec: Int? = config.defaultRefreshRateSec
        
        if let key = config.configKey {
            let bannerConfig = RemoteConfigManager.shared.getBannerConfig(key: key)
            adUnitId = bannerConfig?.adUnitId ?? adUnitId
            bannerType = bannerConfig?.bannerType ?? bannerType
            refreshRateSec = bannerConfig?.refreshRateSec ?? refreshRateSec
            cbFetchIntervalSec = bannerConfig?.cbFetchIntervalSec ?? cbFetchIntervalSec
            log(message: "bannerConfig = \(String(describing: bannerConfig))")
        }
        
        log(message: "adUnitId = \(adUnitId) " +
            " - bannerType = \(bannerType) " +
            " - refreshRateSec = \(String(describing: refreshRateSec)) " +
            " - cbFetchIntervalSec = \(cbFetchIntervalSec)"
        )
        
        adViewController = BaseAdViewController.Factory.getAdView(
            adUnitId: adUnitId,
            bannerType: bannerType,
            refreshRateSec: refreshRateSec,
            cbFetchIntervalSec: cbFetchIntervalSec
        )
        guard let adViewController = adViewController else {
            return
        }
        
        let adView = adViewController.view!
        
        rootViewController?.addChild(adViewController)
        
        adView.translatesAutoresizingMaskIntoConstraints = false
        adContainer?.addSubview(adView)
        adContainer?.addConstraints([
            NSLayoutConstraint(item: adView,
                               attribute: .top,
                               relatedBy: .equal,
                               toItem: adContainer,
                               attribute: .top, multiplier: 1,
                               constant: 0),
            NSLayoutConstraint(item: adView,
                               attribute: .left,
                               relatedBy: .equal,
                               toItem: adContainer,
                               attribute: .left, multiplier: 1,
                               constant: 0),
            NSLayoutConstraint(item: adView,
                               attribute: .right,
                               relatedBy: .equal,
                               toItem: adContainer,
                               attribute: .right, multiplier: 1,
                               constant: 0),
            NSLayoutConstraint(item: adView,
                               attribute: .bottom,
                               relatedBy: .equal,
                               toItem: adContainer,
                               attribute: .bottom, multiplier: 1,
                               constant: 0),
        ])
        
        adViewController.didMove(toParent: rootViewController)
    }
    
    
    func updateView(controller: UIViewController, viewBanner: UIView) -> Bool {
        removeAdFromParent()
        guard let adController = self.adViewController else { return false }
        let adView = adController.view!
        
        self.rootViewController = controller
        self.adContainer = viewBanner
        
        rootViewController?.addChild(adController)
        
        adView.translatesAutoresizingMaskIntoConstraints = false
        adContainer?.addSubview(adView)
        adContainer?.addConstraints([
            NSLayoutConstraint(item: adView,
                               attribute: .top,
                               relatedBy: .equal,
                               toItem: adContainer,
                               attribute: .top, multiplier: 1,
                               constant: 0),
            NSLayoutConstraint(item: adView,
                               attribute: .left,
                               relatedBy: .equal,
                               toItem: adContainer,
                               attribute: .left, multiplier: 1,
                               constant: 0),
            NSLayoutConstraint(item: adView,
                               attribute: .right,
                               relatedBy: .equal,
                               toItem: adContainer,
                               attribute: .right, multiplier: 1,
                               constant: 0),
            NSLayoutConstraint(item: adView,
                               attribute: .bottom,
                               relatedBy: .equal,
                               toItem: adContainer,
                               attribute: .bottom, multiplier: 1,
                               constant: 0),
        ])
        
        adController.didMove(toParent: rootViewController)
        return true
    }
    
    func removeAdFromParent() {
        guard let controller = adViewController else { return }
        controller.willMove(toParent: nil)
        controller.view.removeFromSuperview()
        controller.removeFromParent()
    }
    
    func setCallBack(onBannerWillDismiss: ((_ adUnitID: String) -> Void)?,
                     onBannerFailed: ((_ adUnitID: String) -> Void)?,
                     onLoadBannerSuccess: ((_ adUnitID: String) -> Void)?,
                     onBannerClick: ((_ adUnitID: String) -> Void)?,
                     onBannerPaidAds: ((_ adUnitID: String) -> Void)?) {
        guard let viewController = adViewController else {
            onBannerFailed?(config.adUnitId)
            return
        }
        viewController.onBannerWillDismiss = onBannerWillDismiss
        viewController.onBannerFailed = onBannerFailed
        viewController.onLoadBannerSuccess = onLoadBannerSuccess
        viewController.onBannerClick = onBannerClick
        viewController.onBannerPaidAds = onBannerPaidAds
    }
    
    func loadAd() {
        adViewController?.loadAd()
    }
}

func getCurrentMillis() -> Int64 {
    return Int64(Date().timeIntervalSince1970 * 1000)
}

func log(message: String) {
    if (BannerPlugin.LOG_ENABLED) {
        print("BannerPlugin: " + message)
    }
}
