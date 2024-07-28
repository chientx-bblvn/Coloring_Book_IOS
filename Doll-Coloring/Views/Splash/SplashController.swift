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

class SplashController: BaseViewController {
    @IBOutlet private weak var lbCopyright: UILabel!
    @IBOutlet private weak var animationView: LottieAnimationView!
    @IBOutlet weak var animationColoring: LottieAnimationView!
    
    private var isSetLanguage = false
    private var configLoaded = false
    private var timer: Timer? = nil
    
    // MARK: - Setup controller and IBAction
    override func setup() {
        super.setup()
        requestNotification {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.loadConfigData()
            }
        }
        setupView()
        configIAP()
        loadSavedLanguage()
        
        
        
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
            dispatchGroup.leave()
        }
        dispatchGroup.notify(queue: .main) { [weak self] in
            
            self?.requestGDPRAndATT { [weak self] in
                DispatchQueue.main.asyncSafety {
                    ADManager.shared.initialize(readConfig: self?.configLoaded ?? false) { [weak self] success in
                        self?.processScreen()
                    }
                }
            }
        }
    }
    
    // MARK: - Check IAP config
    private func configIAP() {
        BBLLogging.d("Check:: configIAP")
        let identitiesIAP = Set(IAPIdType.allCases.compactMap({ $0.id }))
        InappManager.share.productIdentifiers = identitiesIAP
        _ = InappManager.share.productInfo(id: identitiesIAP, isShowLoading: false) { [weak self] listProduct in
            BBLLogging.d("Check:: productInfo   ---   \(listProduct.count)")
            if IAPState.isUserVip {
                InappManager.share.checkPurchaseProduct()
                _ = self?.checkIsUserVip()
            }
        }
    }
    
    private func checkIsUserVip() -> InAppRequest? {
        BBLLogging.d("Check:: checkIsUserVip")
        return InappManager.share.veryCheckRegisterPack {
            BBLLogging.d("Check:: veryCheckRegisterPack")
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
                UserDefaultManager.currentAccessABShowIAPColoring = RemoteConfigManager.shared.bool(forKey: KeyRemoteConfig.StateShowIAP)
                UserDefaultManager.currentAccessAB_is_free_trial_US = RemoteConfigManager.shared.bool(forKey: KeyRemoteConfig.is_free_trial_us)
                newApiBaseURL = RemoteConfigManager.shared.string(forKey: KeyRemoteConfig.ApiBaseURL)
                apiAccessKey = RemoteConfigManager.shared.string(forKey: KeyRemoteConfig.APIAccessKey)
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
        self.timer?.invalidate()
        self.timer = nil
        BBLLogging.d("Check:: showAdvert")
        ADManager.shared.loadOpenAsync(DollColoringAdID.appopen_splash) { [weak self] showed in
            if showed {
                DispatchQueue.main.asyncSafety { [weak self] in
                    self?.preloadOpenResumeAd()
                    self?.navigateScreen()
                }
            } else {
                self?.showFullAds()
            }
        }
    }
    
    private func preloadOpenResumeAd() {
        if DollColoringAdID.appopen_resume.isEnableAd {
            ADManager.shared.loadOpen(DollColoringAdID.appopen_resume)
        }
    }
    
    private func showFullAds() {
        self.timer?.invalidate()
        self.timer = nil
        if !DollColoringAdID.appopen_allprice.isEnableAd {
            self.navigateScreen()
            return
        }
        BBLLogging.d("Check:: showFullAds")
        ADManager.shared.loadOpenAsync(DollColoringAdID.appopen_allprice) {[weak self] showed in
            self?.preloadOpenResumeAd()
            self?.navigateScreen()
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
            AppRouter.shared.navigate(to: TabbarViewRoute.main, with: .changeRoot)
        }
    }
    
}

// MARK: - Setup view
extension SplashController {
    
    private func setupView() {
        FirebaseEventManager.logEvent(with: RMBGEventTracking.splashScr)
//        animationView.loadAnimation(file: "animation_splash_new", loopMode: .loop, autoPlay: true)
        animationColoring.loadAnimation(file: "animation_splash_new", loopMode: .loop, autoPlay: true, animationSpeed: 2)
        let style = ThemeStyleAds
            .custom(backgroundColor: UIColor.white.withAlphaComponent(0.8),
                    titleColor: R.color.textColor()!,
                    vertiserColor: .yellow,
                    contenColor: R.color.textColor()!,
                    actionColor: R.color.textColor()!,
                    backgroundAction: [R.color.colorTextTopBar()!])
        let testIds =     [
            "1999dafded8682859eeec95e2482fbe9",
            "9b689f03a451ea6278b47db3210f81d8"
        ]
        ADManager.shared.startAds(style: style, testIds: testIds)
        
    }
    
    private func loadText() {
        lbCopyright.text = LocalizableUtils.splashCopyright()
    }
    
    private func loadSavedLanguage() {
        let currLang = UserDefaults.standard.string(forKey: UserDefault.languageKey.rawValue) ?? ""
        if !currLang.isEmpty {
            Constants.currentLanguage = Language(key: currLang)
            isSetLanguage = true
            ADManager.shared.preLoadNative(DollColoringAdID.native_language_high)
            return
        }
        Constants.currentLanguage = .english
        isSetLanguage = false
    }
    
    private func requestNotification(complection: @escaping () -> Void) {
        BBLLogging.d("Check:: requestNotification")
        appDelegate?.requestNotificationPermission(completion: { success, error in
            BBLLogging.d("Check:: requestNotificationPermission  --   success: \(success)  error: \(error?.localizedDescription ?? "error")")
            complection()
        })
    }
}
