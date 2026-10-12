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
import SwiftyStoreKit
import SDWebImage

class SplashController: BaseViewController {
    @IBOutlet private weak var animationView: LottieAnimationView!
    @IBOutlet weak var animationColoring: LottieAnimationView!
    
    @IBOutlet weak var viewBannerAds: UIView!
    
    private var isSetLanguage = false
    private var configLoaded = false
    private var timer: Timer?
    
    // MARK: - Setup controller and IBAction
    override func setup() {
        super.setup()
        UserDefaultManager.saveInstallDateIfNeeded()
        loadSavedLanguage()
        viewBannerAds?.isHidden = true
        setupView()
        // Push notifications disabled until Firebase is connected.
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.loadConfigData()
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
        fetchRemoteConfig {
            self.configIAP(completion: {
                self.navigateScreen()
            })
        }
    }
    
    // MARK: - Check IAP config
    private func configIAP(completion: @escaping (() -> Void)) {
        BBLLogging.d("Check:: configIAP")
        InappManager.share.productIdentifiers = IAPIdType.mainProductIdentifiers
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
    
    private func fetchRemoteConfig(completion: @escaping (() -> Void)) {
        DispatchQueue.main.asyncSafety { [weak self] in
            RemoteConfigManager.shared.fetchConfig(completion: { [weak self] isLoaded in
                BBLLogging.d("Check:: fetchConfig \(isLoaded)")
                UserDefaultManager.currentAccessNumberClick = 0
                UserDefaultManager.currentAccessABTestFillColoring = false
                UserDefaultManager.currentAccessABShowIAPColoring = true
                UserDefaultManager.currentAccessAB_is_free_trial_US = false
                
                // Keep Bunny CDN defaults; reject blocked remote overrides
                ColoringCDN.applyRemoteOverride(
                    baseURL: RemoteConfigManager.shared.string(forKey: KeyRemoteConfig.ApiBaseURL),
                    imageURL: RemoteConfigManager.shared.string(forKey: KeyRemoteConfig.ApiURLImage),
                    accessKey: RemoteConfigManager.shared.string(forKey: KeyRemoteConfig.APIAccessKey)
                )
                
                UserDefaultManager.currentTimeCountdown = RemoteConfigManager.shared.number(forKey: KeyRemoteConfig.TimeCountdowntSale)
                
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
    
    private func navigateScreen() {
        BBLLogging.d("Check:: navigateScreen")
        DispatchQueue.main.asyncSafety { [weak self] in
            guard let self = self else { return }
            self.timer?.invalidate()
            self.timer = nil
            // Skip language + onboarding — splash goes straight home.
            if !self.isSetLanguage {
                Constants.currentLanguage = .english
                UserDefaults.standard.set(Language.english.key, forKey: UserDefault.languageKey.rawValue)
            }
            UserDefaults.standard.set(true, forKey: UserDefault.showedIntro.rawValue)
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
