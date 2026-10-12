//
//  AppDelegate+Notifications.swift
//  Doll-Coloring
//
//  Created by Doll-Coloring on 24/11/2023.
//  Copyright © 2024 BBLabs. All rights reserved.
//

import Foundation
import UserNotifications
import UIKit

extension AppDelegate {
    
    func requestNotificationPermission(completion: @escaping (_ success: Bool, _ error: Error?) -> Void) {
        // Disabled until Firebase is connected — avoid system permission prompt.
        DispatchQueue.main.async {
            completion(false, nil)
        }
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        FirebaseEventManager.logEvent(with: RMBGEventTracking.notiSent)
        if let user = userInfo as? [String: Any] {
            print("UserNotification--didReceiveRemoteNotification: \(user)")
            if let configStr = user["config_update"] as? String,
               let configUpdate = configStr.convertToDictionary() {
                processNotifyConfigApp(configDict: configUpdate)
                completionHandler(.newData)
                return
            }
        }
        completionHandler(.noData)
    }
    
    private func processNotifyConfigApp(configDict: [String: Any]) {
        guard let data = try? JSONSerialization.data(withJSONObject: configDict, options: .prettyPrinted),
              let appVersionResponse = try? JSONDecoder().decode(AppVersionConfigUpdate.self, from: data) else {
            return
        }

        alertController?.dismiss(animated: true)
        alertController = nil
        if let configUpdate = appVersionResponse.ios {
            showUpdateAppAvailable(config: configUpdate)
        }
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        FirebaseEventManager.logEvent(with: RMBGEventTracking.notiClick)
        completionHandler()
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        FirebaseEventManager.logEvent(with: RMBGEventTracking.notiSent)
        if let userInfo = notification.request.content.userInfo as? [String: Any] {
            print("UserNotification: \(userInfo)")
            if let configStr = userInfo["config_update"] as? String {
                let configUpdate = configStr.dictionary
                processNotifyConfigApp(configDict: configUpdate)
            }
        }
        if #available(iOS 14.0, *) {
            completionHandler([.alert, .sound, .banner, .list, .badge])
        } else {
            completionHandler([.alert, .sound, .badge])
        }
    }
    
    internal func checkForceUpdate() -> Bool {
        // Firebase Remote Config disabled — no force-update payload
        return false
    }
    
    @discardableResult
    private func showUpdateAppAvailable(config appVersion: PlatformAppVersion) -> Bool {
        alertController?.dismiss(animated: true)
        alertController = nil
        let updateInfo = appVersion.checkForceUpdate()
        if !updateInfo.ableUpdate {
            return false
        }
        var message = appVersion.description ?? ""
        if message.isEmpty {
            message = LocalizableUtils.forceUpdateDescription()
        }
        let viewController = AppRouter.shared.rootViewController
        if updateInfo.force {
            alertController = viewController?.createMyAlert(title: LocalizableUtils.forceUpdateTitle(),
                                                            message,
                                                            okTitle: LocalizableUtils.commonButtonAgree(), handler: {
                appVersion.link?.openLink()
            })
            return true
        } else {
            alertController = viewController?.createMyQuestion(icon: R.image.alert(),
                                                               title: LocalizableUtils.forceUpdateTitle(),
                                                               message: message,
                                                               positiveTitle: LocalizableUtils.forceUpdateButton(),
                                                               negativeTitle: LocalizableUtils.commonCancel(),
                                                               handler: {
                appVersion.link?.openLink()
            }, cancel: { [weak self] in
                if AppRouter.shared.currentViewController is SplashController {
                    self?.navigateScreen(isSetLanguage: true)
                }
            })
            return true
        }
    }
    
    private func navigateScreen(isSetLanguage: Bool) {
        // Skip language + onboarding — resume into home tab shell.
        if !isSetLanguage {
            Constants.currentLanguage = .english
            UserDefaults.standard.set(Language.english.key, forKey: UserDefault.languageKey.rawValue)
        }
        UserDefaults.standard.set(true, forKey: UserDefault.showedIntro.rawValue)
        AppRouter.shared.navigate(to: MainTabbarViewRoute.tabbar, with: .changeRoot)
    }
}
