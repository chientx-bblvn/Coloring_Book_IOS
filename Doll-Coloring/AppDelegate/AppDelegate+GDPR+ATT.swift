//
//  AppDelegate+GDPR+ATT.swift
//  Doll-Coloring
//
//  Created by Doll-Coloring on 21/12/2023.
//  Copyright © 2024 BBLabs. All rights reserved.
//

import Foundation
import AppTrackingTransparency

extension AppDelegate {
    
    func requestShowUMPForEEAMarket(idx: Int, completion: @escaping ((_ accepted: Bool) -> Void)) {
        let needCallGDPR = RemoteConfigManager.shared.getValue(by: RMBGRemoteConfig.needShowConsent)?.boolValue ?? true
        if !needCallGDPR {
            if #available(iOS 14, *) {
                appDelegate?.requestATTrackingManager(completion: { status in
                })
            }
            completion(true)
            return
        }
        print("requestShowUMPForEEAMarket::consentStatus: \(UMPUtils.shared.consentStatus.self) ---- formStatus: \(UMPUtils.shared.formStatus.self)")
        UMPUtils.shared.showFormGDPR(idx: idx, completion: { accepted in
            if !accepted {
                completion(false)
                return
            }
            if #available(iOS 14, *) {
                appDelegate?.requestATTrackingManager(completion: { status in
                    completion(accepted)
                })
            } else {
                completion(accepted)
            }
        })
    }
    
    func requestNotificationPermission(completion: @escaping ((_ success: Bool, _ error: Error?) -> Void)) {
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { success, err in
                print("Request notify: \(success)   ----- with error: \(err?.localizedDescription ?? "")")
                DispatchQueue.main.asyncSafety {
                    completion(success, err)
                }
            })
    }
    
    @available(iOS 14, *)
    func requestATTrackingManager(completion: @escaping ((_ status: ATTrackingManager.AuthorizationStatus) -> Void)) {
            let status = ATTrackingManager.trackingAuthorizationStatus
            switch status {
            case .notDetermined:
                ATTrackingManager.requestTrackingAuthorization { status in
                    completion(status)
                }
                break
            default:
                completion(status)
            }
    }
    
}
