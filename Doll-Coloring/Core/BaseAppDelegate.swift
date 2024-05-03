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
        window = UIWindow(frame: UIScreen.main.bounds)
        let rootVC = AppRouter.shared.rootViewController
        window?.rootViewController = rootVC
        window?.makeKeyAndVisible()
        if #available(iOS 13.0, *) {
            window?.overrideUserInterfaceStyle = .light
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
