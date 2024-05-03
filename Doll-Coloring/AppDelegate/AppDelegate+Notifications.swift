//
//  AppDelegate+Notifications.swift
//  Doll-Coloring
//
//  Created by Doll-Coloring on 24/11/2023.
//  Copyright © 2024 BBLabs. All rights reserved.
//

import Foundation
import FirebaseCore
import FirebaseMessaging
import FirebaseRemoteConfig
import FirebaseAnalytics

extension AppDelegate {
    
    internal func configurationFirebase(_ application: UIApplication, _ launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        application.applicationIconBadgeNumber = 0
        FirebaseApp.configure()
        // For iOS 10 display notification (sent via APNS)
        UNUserNotificationCenter.current().delegate = self
        application.registerForRemoteNotifications()
        Messaging.messaging().delegate = self
        Messaging.messaging().isAutoInitEnabled = true
        
        #if canImport(FirebaseAnalytics)
        Analytics.setAnalyticsCollectionEnabled(true)
        #endif
        
        // Listen for config key changed
        RemoteConfigManager.shared.onConfigChanged = { keys in
            if keys.contains(RMBGRemoteConfig.dataConfigUpdate.rawValue) {
                DispatchQueue.main.asyncSafety { [weak self] in
                    _ = self?.checkForceUpdate()
                }
            }
        }
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        FirebaseEventManager.logEvent(with: RMBGEventTracking.notiSent)
        if let user = userInfo as? [String: Any] {
            print("UserNotification--didReceiveRemoteNotification: \(user)")
            do {
                if let configStr = user["config_update"] as? String,
                   let configUpdate = configStr.convertToDictionary() {
                    processNotifyConfigApp(configDict: configUpdate)
                    return
                }
                if UIApplication.shared.applicationState == .active {
                    print("App is active")
                }
            } catch let error {
                print("Error: \(error)")
            }
        }
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

extension AppDelegate: MessagingDelegate, UNUserNotificationCenterDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(String(describing: fcmToken))")
    }

    // handle for click open notification
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        FirebaseEventManager.logEvent(with: RMBGEventTracking.notiClick)
//        do {
//            if let userInfo = response.notification.request.content.userInfo as? [String: Any],
//               let content = userInfo["content"] as? String,
//               let data = content.data(using: .utf8) {
//                print("UserNotification: \(userInfo)")
//                NotificationCenter.default.post(name: .notificationClicked, object: nil)
//            }
//        } catch let error {
//            print("Error: \(error)")
//        }
        completionHandler()
    }

    // handle for show notification and direction screen
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        FirebaseEventManager.logEvent(with: RMBGEventTracking.notiSent)
        do {
            if let userInfo = notification.request.content.userInfo as? [String: Any] {
                print("UserNotification: \(userInfo)")
                if let configStr = userInfo["config_update"] as? String {
                    let configUpdate = configStr.dictionary
                    processNotifyConfigApp(configDict: configUpdate)
                    return
                }
                if UIApplication.shared.applicationState == .active {
                    print("App is active")
                }
            }
        } catch let error {
            print("Error: \(error)")
        }
        if #available(iOS 14.0, *) {
            completionHandler([.alert, .sound, .banner, .list, .badge])
        } else {
            completionHandler([.alert, .sound, .badge])
        }
    }
    
    internal func checkForceUpdate() -> Bool {
        guard let jsonStr = RemoteConfigManager.shared.getValue(by: RMBGRemoteConfig.dataConfigUpdate.rawValue)?.stringValue,
              !jsonStr.isEmpty,
              let jsonData = jsonStr.data(using: .utf8) else {
            return false
        }
        guard let appVersionResponse = try? JSONDecoder().decode(AppVersionModel.self,
                                                     from: jsonData) else {
            return false
        }
        if let configUpdate = appVersionResponse.configUpdate?.ios {
            return showUpdateAppAvailable(config: configUpdate)
        }
        return false
    }
    
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
        let showIntro = UserDefaults.standard.bool(forKey: UserDefault.showedIntro.rawValue)
        if !isSetLanguage {
            AppRouter.shared.navigate(to: LanguageRoute.language(gofrom: .intro), with: .push)
            return
        }
        if !showIntro {
            AppRouter.shared.navigate(to: IntroRoute.intro, with: .push)
            return
        }
//        MainRoute.gotoHome()
    }
    
}
