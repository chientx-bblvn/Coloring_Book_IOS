//
//  AppDelegate.swift
// Doll-Coloring
//
//  Created by BBLabs on 03/09/2021.
//

import FirebaseCore
import FirebaseMessaging
import FirebaseRemoteConfig
import RxSwift
import SVProgressHUD
import UIKit
import AppTrackingTransparency
import AdmobSDK
import FBAudienceNetwork

var appDelegate: AppDelegate? {
    return  UIApplication.shared.delegate as? AppDelegate
}

@UIApplicationMain

class AppDelegate: BaseAppDelegate {
    
    private var reachability: Reachability?
    internal var alertController: AlertViewController?
    
    override init() {
        super.init()
        //        UIFont.overrideInitialize()
    }
    
    override func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        //        UIFont.overrideInitialize()
        createAudioSession()
        super.application(application, didFinishLaunchingWithOptions: launchOptions)
        SQLiteManager.shared.connectionDatabase()
        configurationFirebase(application, launchOptions)
        configurationFB()
        
        UITableViewHeaderFooterView.appearance().tintColor = .clear
        UITableView.appearance().showsVerticalScrollIndicator = false
        UITableView.appearance().showsHorizontalScrollIndicator = false
        
        SVProgressHUD.setDefaultMaskType(.black)
        
        setupReachability()
        
        return true
    }
    
    override func applicationWillEnterForeground(_ application: UIApplication) {
        super.applicationWillEnterForeground(application)
        if !DollColoringAdID.appopen_resume.isEnableAd { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            ADManager.shared.loadOpen(DollColoringAdID.appopen_resume)
        }
        if !checkForceUpdate() {
        }
    }
    
    private func configurationFB() {
       
    }
    
    fileprivate func createAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.soloAmbient)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
        }
    }
    
}

// MARK: - For config network change
extension AppDelegate {
    
    func isConnected() -> Bool {
        return reachability?.connection != .unavailable
    }
    
    func setupReachability() {
        let reachability: Reachability?
        reachability = try? Reachability()
        self.reachability = reachability
        
        reachability?.whenReachable = { _ in
            print("Network connected")
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "network_connection"), object: true)
        }
        reachability?.whenUnreachable = { _ in
            print("Network disconnected")
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "network_connection"), object: false)
        }
        
        startNotifier()
    }
    
    func startNotifier() {
        print("--- start notifier")
        do {
            try reachability?.startNotifier()
        } catch {
            return
        }
    }
    
    func stopNotifier() {
        print("--- stop notifier")
        reachability?.stopNotifier()
        reachability = nil
    }
}
