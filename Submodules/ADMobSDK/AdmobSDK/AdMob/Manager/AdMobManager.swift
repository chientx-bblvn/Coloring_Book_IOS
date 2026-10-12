//
//  AdMobManager.swift
//  AdmobSDK
//
//  Created by macbook on 28/08/2021.
//

import Foundation
import UIKit
import GoogleMobileAds
import SkeletonView
import AdjustSdk
import FirebaseAnalytics

//    MARK: - Google-provided demo ad units
public struct SampleAdUnitID {
    public static let adFormatAppOpen              = AdUnitID(rawValue: "ca-app-pub-3940256099942544/5575463023")
    public static let adFormatBanner               = AdUnitID(rawValue: "ca-app-pub-3940256099942544/2934735716")
    public static let adFormatCollapsibleBanner    = AdUnitID(rawValue: "ca-app-pub-3940256099942544/2435281174")
    public static let adFormatBanner_2             = AdUnitID(rawValue: "ca-app-pub-3940256099942544/2934735716")
    public static let adFormatInterstitial         = AdUnitID(rawValue: "ca-app-pub-3940256099942544/4411468910")
    public static let adFormatInterstitialVideo    = AdUnitID(rawValue: "ca-app-pub-3940256099942544/5135589807")
    public static let adFormatRewarded             = AdUnitID(rawValue: "ca-app-pub-3940256099942544/1712485313")
    public static let adFormatRewardedInterstitial = AdUnitID(rawValue: "ca-app-pub-3940256099942544/6978759866")
    public static let adFormatNativeAdvanced       = AdUnitID(rawValue: "ca-app-pub-3940256099942544/3986624511")
    public static let adFormatNativeAdvancedVideo  = AdUnitID(rawValue: "ca-app-pub-3940256099942544/2521693316")
}

//    MARK: - Enum AdUnitID
public struct AdUnitID {
    public var rawValue: String = ""
    
    public init(rawValue: String) {
        self.rawValue = rawValue
    }
    
}

//    MARK: - Enum Theme Style Ads
public enum ThemeStyleAds {
    case origin
    case custom(backgroundColor: UIColor, titleColor: UIColor, vertiserColor: UIColor, contenColor: UIColor, actionColor: UIColor, backgroundAction: [UIColor])
    case setBackground(backgroundColor: UIColor)
    
    public var colors: (backgroundColor: UIColor, titleColor: UIColor, vertiserColor: UIColor, contenColor: UIColor, actionColor: UIColor, backgroundAction: [UIColor]) {
        switch self {
        case .origin:
            return (UIColor(hex: 0xFFFFFF), UIColor(hex: 0x0303B3), UIColor(hex: 0x001868), UIColor(hex: 0x666666), UIColor(hex: 0xFFFFFF), [UIColor(hex: 0x007AFF)])
        case .custom(let backgroundColor, let titleColor, let vertiserColor, let contenColor, let actionColor, let backgroundAction):
            return (backgroundColor, titleColor, vertiserColor, contenColor, actionColor, backgroundAction)
        case .setBackground(let backgroundColor):
            return (backgroundColor, UIColor(hex: 0x0303B3), UIColor(hex: 0x001868), UIColor(hex: 0x666666), UIColor(hex: 0xFFFFFF), [UIColor(hex: 0x007AFF)])
        }
    }
}

class AdMobManager: NSObject {
    
    //    MARK: - Property
    public static let shared = AdMobManager()
    public var timeoutRequestFullAd: Float {
        return RemoteConfigManager.shared.getValue(by: DefaultRemoteKey.timeoutRequestFullAd)?.numberValue.floatValue ?? 20.0
    }
    public var didEarnReward: NSDecimalNumber? = nil
    public var showAdRewardCount = 0
    public var listAd: NSMutableDictionary = NSMutableDictionary()
    public var listLoader: NSMutableDictionary = NSMutableDictionary()
    
    public var listNativeAd: [String: NativeAdProtocol] = [:]
    public var listNativeLoader: [String: GADAdLoader] = [:]
    
    //    MARK: - Type Theme color
    public var adsNativeColor: ThemeStyleAds = .origin
    
    //    MARK: - UI Native
    public var adsNativeCornerRadiusButton:      CGFloat = 8
    public var adsNativeCornerRadius:            CGFloat = 4
    public var adsNativeBorderWidth:             CGFloat = 1
    public var adsNativeSmallWidthButton:        CGFloat = 80
    public var adsNativeMediumHeightButton:      CGFloat = 48
   
    public var adsNativeBorderColor:             UIColor = .clear
    public var adNativeAdsLabelColor:            UIColor = .white
    public var adNativeBackgroundAdsLabelColor: UIColor = UIColor(hex: 0xFDB812)
    
    public var nativeButtonCornerRadius: CGFloat = 16
    public var rewardErrorString: String         = "An error occurred"
    public var adFullScreenLoadingString: String = "Ad is loading"
    public var skeletonGradient = UIColor.clouds
    
    var isSplash = false
    var loadingRewardIds: [String] = []
    
    //    MARK: - Block Ads
    public var blockLoadFullScreenAdSuccess: StringBlockAds?
    public var blockFullScreenAdWillDismiss: VoidBlockAds?
    public var blockFullScreenAdDidDismiss : VoidBlockAds?
    public var blockFullScreenAdWillPresent: StringBlockAds?
    public var blockFullScreenAdDidPresent : StringBlockAds?
    public var blockFullScreenAdFailed      : StringBlockAds?
    public var blockFullScreenAdClick      : VoidBlockAds?
    public var blockCompletionHandeler     : BoolBlockAds?
    public var blockNativeFailed            : StringBlockAds?
    public var blockLoadNativeSuccess      : StringBlockNativeAds?
    public var blockClickAdsNative        : VoidBlockAds?
    public var blockBannerFailed      : ((String) -> Void)?
    public var blockLoadBannerSuccess: ((Bool) -> Void)?
    public var blockBannerClick      : StringBlockAds?
    
    //    MARK: - Remove ID ads
    public func removeAd(unitId: String) {
        listAd.removeObject(forKey: unitId)
        listLoader.removeObject(forKey: unitId)
    }
    
    public func removeNativeAd(unitId: String) {
        listNativeAd.removeValue(forKey: unitId)
        listNativeLoader.removeValue(forKey: unitId)
    }
    
    //    MARK: - Track Ad Revenue
    func trackAdRevenue(format: AdFormatType,
                        value: GADAdValue,
                        unitId: String,
                        adNetwork: String) {
        let rev = value.value.doubleValue
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.checkAndUpdateConversionValue(rev: rev)
        }
        Analytics.logEvent("ad_revenue_sdk",
                           parameters: ["ad_format": format.rawValue,
                                        "value": "\(rev)",
                                        "currency": value.currencyCode,
                                        "placement": unitId,
                                        "precison": "\(String(describing: value.precision.self))",
                                        "ad_network": adNetwork])
        if let adRevenue = ADJAdRevenue(source: "admob_sdk") {
            adRevenue.setRevenue(value.value.doubleValue, currency: value.currencyCode)
            Adjust.trackAdRevenue(adRevenue)
        }
    }
    
    func logEvenClick(id: String) {
        Analytics.logEvent("user_click_ads", parameters: ["adunitid" : id])
    }
    
    private func checkAndUpdateConversionValue(rev: Double) {
        let skanConfig = ADManager.shared.skanConversionConfig
        if skanConfig.isEmpty {
            print("checkAndUpdateConversionValue: Cannot update conversionValue is empty with rev = \(rev)")
            return
        }
        var totalRev = 0.0
        var today = Date()
        let lastTime = UserDefaults.standard.string(forKey: "lastTimeUpdateConversion") ?? ""
        var lastRev = UserDefaults.standard.double(forKey: "lastRevUpdateConversion")
        if lastTime.isEmpty {
            lastRev = 0.0
            let newTime = toString(date: today)
            UserDefaults.standard.set(newTime, forKey: "lastTimeUpdateConversion")
        } else {
            let hour24 = 24 * 60 * 60 * 1000.0
            if let time = getDate(time: lastTime),
               (today.timeIntervalSince1970 - time.timeIntervalSince1970) <= hour24 {
            } else {
                lastRev = 0.0
                let newTime = toString(date: today)
                UserDefaults.standard.set(newTime, forKey: "lastTimeUpdateConversion")
            }
        }
        totalRev = lastRev + rev
        UserDefaults.standard.set(totalRev, forKey: "lastRevUpdateConversion")
        var step = -1
        skanConfig.forEach { config in
            if totalRev >= config.startRev {
                step = config.step
            }
        }
        if step > -1 {
            print("checkAndUpdateConversionValue: totalRev = \(totalRev) at step = \(step) with rev = \(rev)")
            InappManager.share.updateConversionValue(value: step)
        } else {
            print("checkAndUpdateConversionValue: Failed to set totalRev = \(totalRev) at step = -1 with rev = \(rev)")
        }
    }
    
    private func getDate(time: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        return dateFormatter.date(from: time)
    }
    
    private func toString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        return dateFormatter.string(from: date)
    }
}

public enum AdFormatType: String {
    case banner = "banner"
    case adaptive = "adaptive"
    case inter = "inter"
    case reward = "reward"
    case appOpen = "app_open"
    case native = "native"
    case collapsible = "collapsible"
}
