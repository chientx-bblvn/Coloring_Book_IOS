//
//  AdvertManager.swift
//  Base
//
//  Created by Base on 10/08/2023.
//

import GoogleMobileAds
import UIKit
#if canImport(AppLovinSDK)
import AppLovinSDK
#endif
#if canImport(CostCenterSDK)
import CostCenterSDK
#endif
#if canImport(MTGSDK)
import MTGSDK
#endif
import AdjustSdk

public protocol AdConfigId {
    
    var name: String { get }
    
    var adType: AdType { get }
    
    var adId: String { get }
    
    var isEnableAd: Bool { get }
    
}

public extension AdConfigId {
    
    var adUnitId: AdUnitID {
        return AdUnitID(rawValue: adId)
    }
    
    var isEnableAd: Bool {
        if IAPState.isUserVip {
            return false
        }
        switch adType {
        case .OpenApp:
            if !ADManager.shared.isShowOpen {
                return false
            }
        case .Banner:
            if !ADManager.shared.isShowBanner {
                return false
            }
        case .Reward:
            if !ADManager.shared.isShowReward {
                return false
            }
        case .Interstitial:
            if !ADManager.shared.isShowFull {
                return false
            }
        case .Native:
            if !ADManager.shared.isShowNative {
                return false
            }
        }
        return (RemoteConfigManager.shared.getValue(by: name)?.boolValue ?? false)
    }
    
}

public enum AdType: String {
    case OpenApp = "App Open"
    case Banner = "Banner"
    case Reward = "Reward"
    case Interstitial = "Interstitial"
    case Native = "Native"
}

public enum AdNativeSize: Int {
    case normal = 0
    case small = 1
}

public class ADManager: NSObject {
    
    public static let shared = ADManager()
    
    public var excludeClassAppOpen: [UIViewController.Type] {
        get {
            AdResumeManager.shared.excludeControllers
        }
        set {
            AdResumeManager.shared.excludeControllers = newValue
        }
    }
    
    public var rewardErrorString: String {
        get {
            AdMobManager.shared.rewardErrorString
        } set {
            AdMobManager.shared.rewardErrorString = newValue
        }
    }
    
    public var adFullScreenLoadingString: String {
        get {
            return AdMobManager.shared.adFullScreenLoadingString
        }
        set {
            AdMobManager.shared.adFullScreenLoadingString = newValue
        }
    }
    
    public var adResumeLoadingString: String {
        get {
            return AdResumeManager.shared.adResumeLoadingString
        }
        set {
            AdResumeManager.shared.adResumeLoadingString = newValue
        }
    }
    
    internal var isShowingAd = false // Cờ để check xem đang show quảng cáo hay không. Chỉ cho phép show 1 loại quảng cáo/1 thời điểm
    
    internal var timeShowOpen: Int = 0
    
    internal var showState: AdShowState?
    internal var configTime: AdConfigTime?
    internal var skanConversionConfig: [SKANConversionConfig] = []
    private var adjustToken = ""
    private var appLovinKey = ""
    private var appMintegralId = ""
    private var appMintegralKey = ""
    @objc public var backgroundAdColor: UIColor? = .white {
        didSet {
            AdResumeManager.shared.backgroundAdColor = backgroundAdColor
        }
    }
    @objc public var foregroundAdColor: UIColor? = .black {
        didSet {
            AdResumeManager.shared.foregroundAdColor = foregroundAdColor
        }
    }
    
    override init() {
        super.init()
        self.showState = AdShowState(version: Bundle.main.releaseVersionNumber,
                                     isShowBanner: true,
                                     isShowOpen: true,
                                     isShowFull: true,
                                     isShowReward: true,
                                     isShowNative: true,
                                     isTestMode: false)
        timeShowOpen = 0
    }
    
    public func startAds(style: ThemeStyleAds = ThemeStyleAds.origin,
                         testIds: [String] = []) {
        
        if !testIds.isEmpty {
            GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = testIds
        }
        AdMobManager.shared.adsNativeColor = style
        DispatchQueue.main.asyncSafety {
            GADMobileAds.sharedInstance().start { status in
                status.adapterStatusesByClassName.forEach { (key: String, value: GADAdapterStatus) in
                    print("Adapter: \(key) - status: \(value.description)")
                }
            }
        }
    }
    
    public func startAdjust(token: String = "") {
        var adjustToken = token
        if adjustToken.isEmpty {
            adjustToken = (Bundle.main.object(forInfoDictionaryKey: "adjust_app_token") as? String) ?? ""
            if adjustToken.isEmpty {
                print("Couldn't found `adjust_app_token` from `Info.plist` file.")
            }
        }
        if adjustToken.isEmpty {
            adjustToken = RemoteConfigManager.shared.getValue(by: DefaultRemoteKey.adjustToken)?.stringValue ?? ""
            if adjustToken.isEmpty {
                print("Couldn't found `adjustToken` from Remote config.")
            }
        }
        if !adjustToken.isEmpty {
            self.adjustToken = adjustToken
            BBLLogging.d("AdjustSDK: config initialing")
            DispatchQueue.global(qos: .background).async {
                let environment = ADManager.shared.isTestMode ? ADJEnvironmentSandbox : ADJEnvironmentProduction
                let config = ADJConfig(
                    appToken: adjustToken,
                    environment: environment)
                BBLLogging.d("AdjustSDK: config initialing")
                config?.logLevel = ADManager.shared.isTestMode ? .verbose : .error
                Adjust.initSdk(config)
            }
        }
    }
    
    public func startApplovin(key: String = "") {
        var applovinKey = key
        if applovinKey.isEmpty {
            applovinKey = (Bundle.main.object(forInfoDictionaryKey: "applovin_key") as? String) ?? ""
            if applovinKey.isEmpty {
                print("Couldn't found `applovin_key` from `Info.plist` file.")
            }
        }
        if applovinKey.isEmpty {
            applovinKey = RemoteConfigManager.shared.getValue(by: DefaultRemoteKey.appLovinKey)?.stringValue ?? ""
            if applovinKey.isEmpty {
                print("Couldn't found `appLovinKey` from Remote config.")
            }
        }
#if canImport(AppLovinSDK)
        if !applovinKey.isEmpty {
            self.appLovinKey = applovinKey
            DispatchQueue.global(qos: .background).async {
                let appLovinSetting = ALSdkInitializationConfiguration(sdkKey: applovinKey)
                ALSdk.shared().initialize(with: appLovinSetting,
                                          completionHandler: { config in
                    debugPrint("APLV: config - \(config)")
                })
            }
            BBLLogging.d("APLV: config initialing")
        }
#endif
    }
    
    public func startMintegral(appId: String = "",
                               apiKey: String = "") {
        var appKey = appId
        var apiAppKey = apiKey
        if appKey.isEmpty {
            appKey = (Bundle.main.object(forInfoDictionaryKey: "app_mintegral_id") as? String) ?? ""
            if appKey.isEmpty {
                print("Couldn't found `app_mintegral_id` from `Info.plist` file.")
            }
        }
        if apiAppKey.isEmpty {
            apiAppKey = (Bundle.main.object(forInfoDictionaryKey: "app_mintegral_key") as? String) ?? ""
            if apiAppKey.isEmpty {
                print("Couldn't found `app_mintegral_key` from `Info.plist` file.")
            }
        }
        if appKey.isEmpty {
            appKey = RemoteConfigManager.shared.getValue(by: DefaultRemoteKey.appMintegralId)?.stringValue ?? ""
            if appKey.isEmpty {
                print("Couldn't found `appMintegralKey` from Remote config.")
            }
        }
        if apiAppKey.isEmpty {
            apiAppKey = RemoteConfigManager.shared.getValue(by: DefaultRemoteKey.appMintegralKey)?.stringValue ?? ""
            if apiAppKey.isEmpty {
                print("Couldn't found `apiMintegralKey` from Remote config.")
            }
        }
#if canImport(MTGSDK)
        if !appKey.isEmpty || !apiAppKey.isEmpty {
            self.appMintegralId = appKey
            self.appMintegralKey = apiAppKey
            let mtgSDK = MTGSDK.sharedInstance()
            DispatchQueue.global(qos: .background).async {
                mtgSDK.consentStatus = true
                mtgSDK.setAppID(appKey, apiKey: apiAppKey)
                BBLLogging.d("Mintegral: config initialed")
            }
        }
#endif
    }
    
    public func startCostCenter() {
        #if canImport(CostCenterSDK)
        let costCenterConfig = RemoteConfigManager.shared.objectJson(forKey: DefaultRemoteKey.enableCostCenter, type: CostCenterConfig.self)
        if costCenterConfig?.enable ?? false {
            DispatchQueue.global(qos: .background).async {
                CostCenterSDK.instance.initialize(logger: costCenterConfig?.logger ?? false)
                debugPrint("CostCenter: finish")
            }
        }
        #endif
    }
    
    public func disableAds() {
        self.showState = AdShowState(version: Bundle.main.releaseVersionNumber,
                                     isShowBanner: false,
                                     isShowOpen: false,
                                     isShowFull: false,
                                     isShowReward: false,
                                     isShowNative: false,
                                     isTestMode: false)
    }
    
    public func initialize(readConfig enable: Bool,
                           completion: @escaping ((_ success: Bool) -> Void)) {
        
        BBLLogging.d("ADMANAGER: \(enable)")
        self.startCostCenter()
        self.startAdjust(token: self.adjustToken)
        self.startApplovin(key: self.appLovinKey)
        if !enable {
            self.loadDefaults()
        } else {
            self.initialAdverts()
        }
        BBLLogging.d("ADMANAGER: Init finished \(enable)")
        completion(true)
    }
    
}

public extension DispatchQueue {
    
    func asyncSafety(_ closure: @escaping () -> Void) {
        guard self === DispatchQueue.main && Thread.isMainThread else {
            DispatchQueue.main.async(execute: closure)
            return
        }
        closure()
    }
    
    func asyncSafety(execute: DispatchWorkItem) {
        guard self === DispatchQueue.main && Thread.isMainThread else {
            DispatchQueue.main.async(execute: execute)
            return
        }
        execute.perform()
    }
    
}

public extension Bundle {
    var releaseVersionNumber: String {
        return (infoDictionary?["CFBundleShortVersionString"] as? String) ?? ""
    }
    
    var buildVersionNumber: String {
        return (infoDictionary?["CFBundleVersion"] as? String) ?? ""
    }
}
