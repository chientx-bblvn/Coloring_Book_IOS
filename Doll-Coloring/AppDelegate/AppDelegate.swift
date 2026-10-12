//
//  AppDelegate.swift
// Doll-Coloring
//
//  Created by BBLabs on 03/09/2021.
//

import RxSwift
import SVProgressHUD
import UIKit
import SDWebImageSVGNativeCoder
import SDWebImage
import AVFAudio
import Clarity

var appDelegate: AppDelegate? {
    AppDelegate.shared ?? UIApplication.shared.delegate as? AppDelegate
}

class AppDelegate: BaseAppDelegate {

    /// Kept because SwiftUI's UIApplicationDelegateAdaptor wraps the real delegate,
    /// so `UIApplication.shared.delegate as? AppDelegate` often returns nil.
    static weak var shared: AppDelegate?
    
    private var reachability: Reachability?
    internal var alertController: AlertViewController?
    
    override init() {
        super.init()
        AppDelegate.shared = self
    }
    
    override func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        AppDelegate.shared = self
        createAudioSession()
        super.application(application, didFinishLaunchingWithOptions: launchOptions)
        SQLiteManager.shared.connectionDatabase()
        
        // Bunny CDN AccessKey for image downloads
        SDWebImageDownloader.shared.setValue(apiAccessKey, forHTTPHeaderField: "AccessKey")
        
        UITableViewHeaderFooterView.appearance().tintColor = .clear
        UITableView.appearance().showsVerticalScrollIndicator = false
        UITableView.appearance().showsHorizontalScrollIndicator = false
        
        SVProgressHUD.setDefaultMaskType(.black)
        configuarationSDWebImageSVG()
        setupReachability()
        
        let clarityConfig = ClarityConfig(projectId: "priky2anur")
        ClaritySDK.initialize(config: clarityConfig)

        // StoreKit 2 listener + product preload (KeyBoard_IOS pattern).
        StoreKitIAPManager.shared.startAtLaunch()
        
        return true
    }
    
    override func applicationWillEnterForeground(_ application: UIApplication) {
        super.applicationWillEnterForeground(application)
        if !checkForceUpdate() {
        }
    }
    
    private func configuarationSDWebImageSVG() {
        let SVGCoder = SDImageSVGNativeCoder.shared
        SDImageCodersManager.shared.addCoder(SVGCoder)
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
