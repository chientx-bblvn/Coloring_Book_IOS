//
//  SplashController.swift
// Doll-Coloring
//
//  Created by BBLabs on 06/07/2023.
//  Copyright ©2023. All rights reserved.
//

import Foundation
import Lottie
import RxSwift
import UIKit
import GoogleMobileAds
import FBAudienceNetwork
import AdmobSDK
import SwiftyStoreKit
import SDWebImage

class SplashController: BaseViewController {
    @IBOutlet private weak var animationView: LottieAnimationView!
    @IBOutlet weak var animationColoring: LottieAnimationView!
     
    
    @IBOutlet weak var viewBannerAds: UIView!
    
    
    private var isSetLanguage = false
    private var configLoaded = false
    private var timer: Timer? = nil
    
    // MARK: - Setup controller and IBAction
    override func setup() {
        super.setup()
        UserDefaultManager.saveInstallDateIfNeeded()
        loadSavedLanguage()
        setupView()
        requestNotification {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.loadConfigData()
            }
        }

    }
    
    
    override func bindingData() {
        super.bindingData()
        loadText()
    }
    
    // MARK: - Language change event
    override func onLanguageChange() {
        super.onLanguageChange()
        loadText()
    }
}

// MARK: - Action view
extension SplashController {
    
    private func loadConfigData() {
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        fetchRemoteConfig {
            self.configIAP(completion: {
                self.requestGDPRAndATT { [weak self] in
                    DispatchQueue.main.asyncSafety {
                        ADManager.shared.initialize(readConfig: self?.configLoaded ?? false) { [weak self] success in
                            self?.processScreen()
                        }
                    }
                }
            })
        }
    }
    
    private func setUpCountdown() {
        if UserDefaults.standard.string(forKey: UserDefault.date_first_install_app.rawValue) == nil {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            let todayString = formatter.string(from: Date())
            UserDefaults.standard.set(todayString, forKey: UserDefault.date_first_install_app.rawValue)
        }

    }
    
    // MARK: - Check IAP config
    private func configIAP(completion: @escaping (() -> Void)) {
        BBLLogging.d("Check:: configIAP")
        InappManager.share.productIdentifiers = Set(IAPIdType.allCases.compactMap({ $0.rawValue }))
        InappManager.share.checkPurchaseProduct()
        _ = InappManager.share.productInfo(id: InappManager.share.productIdentifiers, isShowLoading: false) { [weak self] listProduct in
            BBLLogging.d("Check:: productInfo   ---   \(listProduct.count)")
            if listProduct.isEmpty {
                IAPState.iapState = .unload
                completion()
            } else {
                InappManager.share.checkPurchaseProduct()
                if IAPState.isUserVip {
                    _ = self?.checkIsUserVip(completion: completion)
                } else {
                    completion()
                }
            }
        }
    }
    
    private func checkIsUserVip(completion: @escaping (() -> Void)) -> InAppRequest? {
        BBLLogging.d("Check:: checkIsUserVip")
        return InappManager.share.veryCheckRegisterPack {
            BBLLogging.d("Check:: veryCheckRegisterPack")
            completion()
        }
    }
    
    // MARK: - Check GDPR
    private func requestGDPRAndATT(completion: @escaping (() -> Void)) {
        BBLLogging.d("Check:: requestGDPRAndATT")
        appDelegate?.requestShowUMPForEEAMarket(idx: 1, completion: { accepted in
            let needAcceptConsent = RemoteConfigManager.shared.getValue(by: RMBGRemoteConfig.needAcceptConsent)?.boolValue ?? true
            BBLLogging.d("Check:: requestShowUMPForEEAMarket   ---  accepted: \(accepted)  needAcceptConsent: \(needAcceptConsent)")
            if !needAcceptConsent {
                FBAdSettings.setAdvertiserTrackingEnabled(true)
                completion()
                return
            }
            if accepted {
                FBAdSettings.setAdvertiserTrackingEnabled(true)
            }
            completion()
        })
    }
    
    private func fetchRemoteConfig(completion: @escaping (() -> Void)) {
        DispatchQueue.main.asyncSafety{ [weak self] in
            RemoteConfigManager.shared.fetchConfig(completion: { [weak self] isLoaded in
                BBLLogging.d("Check:: fetchConfig \(isLoaded)")
                UserDefaultManager.currentAccessNumberClick = RemoteConfigManager.shared.number(forKey: KeyRemoteConfig.NumberClickItemAllTopic)
                
                UserDefaultManager.currentAccessABTestFillColoring = RemoteConfigManager.shared.bool(forKey: KeyRemoteConfig.ABTestFillColoring)
                
                UserDefaultManager.currentAccessABShowIAPColoring = true
                UserDefaultManager.currentAccessAB_is_free_trial_US = false
                
                if !RemoteConfigManager.shared.string(forKey: KeyRemoteConfig.ApiBaseURL).isEmpty {
                    newApiBaseURL = RemoteConfigManager.shared.string(forKey: KeyRemoteConfig.ApiBaseURL)
                }
                
                if !RemoteConfigManager.shared.string(forKey: KeyRemoteConfig.APIAccessKey).isEmpty {
                    apiAccessKey = RemoteConfigManager.shared.string(forKey: KeyRemoteConfig.APIAccessKey)
                }
                
                if !RemoteConfigManager.shared.string(forKey: KeyRemoteConfig.ApiURLImage).isEmpty {
                    baseURLImage = RemoteConfigManager.shared.string(forKey: KeyRemoteConfig.ApiURLImage)
                }
                UserDefaultManager.currentTimeCountdown = RemoteConfigManager.shared.number(forKey: KeyRemoteConfig.TimeCountdowntSale)
                
                // Setup countdown end time if not already set
                if UserDefaultManager.countdownEndTime == nil {
                    UserDefaultManager.setupCountdownTimer(duration: RemoteConfigManager.shared.number(forKey: KeyRemoteConfig.TimeCountdowntSale))
                }
                
                UserDefaultManager.currentAccessDisableSale = RemoteConfigManager.shared.bool(forKey: KeyRemoteConfig.IsDisableSale)
                

                let manager = SDWebImageDownloader.shared
                manager.setValue(apiAccessKey, forHTTPHeaderField: "AccessKey")
                self?.configLoaded = isLoaded
                completion()
            })
        }
    }
    
    private func processScreen() {
        if !IAPState.isUserVip {
            self.showAdvert()
        } else {
            self.navigateScreen()
        }
    }
    
    private func showAdvert() {
        let showIntro = UserDefaults.standard.bool(forKey: UserDefault.showedIntro.rawValue)
        if !isSetLanguage {
            ADManager.shared.preLoadNative(DollColoringAdID.native_language_2nd,
                                           nativeAdType: .customMediaFixedHeight)
            ADManager.shared.preLoadNative(DollColoringAdID.native_language, nativeAdType: .customMediaFixedHeight)
        } else if !showIntro {
            ADManager.shared.preLoadNative(DollColoringAdID.native_onboarding_1,
                                           nativeAdType: .customMediaFixedHeight)
            
            ADManager.shared.preLoadNative(DollColoringAdID.native_onboarding_3,
                                                      nativeAdType: .customMediaFixedHeight)
        }
        BBLLogging.d("Check:: showAdvert")
        self.loadAdsHigh()
        
    }
    
    private func preloadOpenResumeAd() {
        if DollColoringAdID.appopen_resume.isEnableAd {
            ADManager.shared.loadOpen(DollColoringAdID.appopen_resume)
        }
    }
    
    private func loadAdsHigh() {
        BBLLogging.d("Check:: showFullAdsHigh")
        ADManager.shared.loadFull(DollColoringAdID.inter_splash_high, needRefresh: false) { [weak self] adResult in
            guard let self = self else { return }
            BBLLogging.d("Check:: loaded high: \(adResult)")
            switch adResult {
            case .error:
                DispatchQueue.main.asyncSafety {
                    self.loadAds()
                }

            case .closed:
                DispatchQueue.main.asyncSafety {
                    self.navigateScreen()
                }

            default:
                break
            }
        }
    }

    private func loadAds() {
        BBLLogging.d("Check:: showFullAds")
        ADManager.shared.loadFull(DollColoringAdID.inter_splash, needRefresh: false) { [weak self] adResult in
            guard let self = self else { return }
            BBLLogging.d("Check:: loaded normal: \(adResult)")
            switch adResult {
            case .closed, .error:
                DispatchQueue.main.asyncSafety {
                    self.navigateScreen()
                }

            default:
                break
            }
        }
    }

    private func navigateScreen() {
        BBLLogging.d("Check:: navigateScreen")
        DispatchQueue.main.asyncSafety { [weak self] in
            guard let `self` = self else { return }
            self.timer?.invalidate()
            self.timer = nil
            let showIntro = UserDefaults.standard.bool(forKey: UserDefault.showedIntro.rawValue)
            if !self.isSetLanguage {
                BBLLogging.d("Check:: isSetLanguage")
                AppRouter.shared.navigate(to: LanguageRoute.languageSecond(gofrom: .intro), with: .push)
                return
            }
            if !showIntro {
                BBLLogging.d("Check:: showIntro")
                AppRouter.shared.navigate(to: IntroRoute.intro, with: .push)
                return
            }
            BBLLogging.d("Check:: gotoHome")
            AppRouter.shared.navigate(to: MainTabbarViewRoute.tabbar, with: .changeRoot)
        }
    }
    
}

// MARK: - Setup view
extension SplashController {
    
    private func setupView() {
        InappManager.share.sharedSecret = sharedSecret
        FirebaseEventManager.logEvent(with: RMBGEventTracking.splashScr)
        animationColoring.loadAnimation(file: "animation_splash", loopMode: .loop, autoPlay: true)
        let style = ThemeStyleAds
            .custom(backgroundColor: UIColor.white.withAlphaComponent(0.8),
                    titleColor: R.color.textColor()!,
                    vertiserColor: .yellow,
                    contenColor: R.color.textColor()!,
                    actionColor: R.color.textColor()!,
                    backgroundAction: [R.color.colorTextTopBar()!])
        let testIds: [String] = []
        ADManager.shared.startAds(style: style, testIds: testIds)
        if !IAPState.isUserVip {
            viewBannerAds.isHidden = false
            ADManager.shared.forceLoadSingleBanner(DollColoringAdID.banner_splash,
                                                   viewBanner: viewBannerAds) { success in
                self.viewBannerAds.isHidden = !success
            }
        }
        let archiveFiles = ArchiveFileLocal.allCases
        for file in archiveFiles {
            if !FileManagerLocal.shared.checkFileExits(typeFile: file, fileName: "") {
                FileManagerLocal.shared.createFolderManager(fileName: file.rawValue)
            }
        }
    }
    
    private func loadText() {
    }

    private func loadSavedLanguage() {
        let currLang = UserDefaults.standard.string(forKey: UserDefault.languageKey.rawValue) ?? ""
        if !currLang.isEmpty {
            isSetLanguage = true
            Constants.currentLanguage = Language(key: currLang)
            return
        }
        isSetLanguage = false
        Constants.currentLanguage = .english
    }
    private func requestNotification(complection: @escaping () -> Void) {
        BBLLogging.d("Check:: requestNotification")
        appDelegate?.requestNotificationPermission(completion: { success, error in
            BBLLogging.d("Check:: requestNotificationPermission  --   success: \(success)  error: \(error?.localizedDescription ?? "error")")
            complection()
        })
    }
}
