//
//  AppDelegate.swift
//  BBLabs.
//
//  Created by BBLabs on 3/12/18.
//  Copyright © 2018 BBLabs.All rights reserved.
//

import IQKeyboardManagerSwift
#if canImport(netfox)
import netfox
#endif
import KeychainAccess
import SVProgressHUD
import UIKit

open class BaseAppDelegate: UIResponder, UIApplicationDelegate {
    public var window: UIWindow?
    
    @discardableResult
    open func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // SwiftUI `DollColoringApp` owns the window via WindowGroup.
        // Keep AppRouter available for UIKit coloring / modal presentation.
        _ = AppRouter.shared
        if #available(iOS 13.0, *) {
            // Prefer light mode when a window becomes available.
        }
        SVProgressHUD.setDefaultMaskType(.clear)
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.toolbarPreviousNextAllowedClasses.append(UIStackView.self)
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        UIView.appearance().isExclusiveTouch = true
        
        return true
    }
    
    open func applicationWillEnterForeground(_ application: UIApplication) {
        
    }
    
    open func applicationDidBecomeActive(_ application: UIApplication) {

    }
}
