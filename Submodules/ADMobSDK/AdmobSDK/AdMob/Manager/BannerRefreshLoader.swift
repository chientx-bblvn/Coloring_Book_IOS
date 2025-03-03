//
//  BannerLoader.swift
//  AdmobSDK
//
//  Created by BBLabs on 8/6/24.
//

import GoogleMobileAds
import SkeletonView
import FirebaseAnalytics

struct BannerRefreshLoaded {
    var bannerPlugin: BannerPlugin
}

struct BannerRefreshDelegate {
    var onBannerWillDismiss: ((_ adUnitID: String) -> Void)?
    var onBannerFailed: ((_ adUnitID: String) -> Void)?
    var onLoadBannerSuccess: ((_ adUnitID: String) -> Void)?
    var onBannerClick: ((_ adUnitID: String) -> Void)?
    var onBannerPaidAds: ((_ adUnitID: String) -> Void)?
}


// MARK: - GADBannerView
class BannerRefreshLoader: NSObject {
    
    internal static let shared = BannerRefreshLoader()
    private var listBannerCachedAd: [String: BannerRefreshLoaded?] = [:]
    private var listLoadingAd: [String] = []
    public var skeletonGradient = UIColor.clouds
    
    private var listDelegate: [String: BannerRefreshDelegate] = [:]
    
    fileprivate func getBannerPlugin(config: BannerPlugin.Config) -> BannerPlugin? {
        if let bannerLoaded = listBannerCachedAd[config.adUnitId] {
            return bannerLoaded?.bannerPlugin
        }
        return nil
    }
    
    public func createAdBannerIfNeed(config: BannerPlugin.Config,
                                     viewBanner: UIView,
                                     viewController: UIViewController) -> (isNew: Bool,
                                                                           bannerPlugin: BannerPlugin) {
        if let bannerPlugin = self.getBannerPlugin(config: config) {
            return (isNew: false, bannerPlugin: bannerPlugin)
        }
        let bannerPlugin = BannerPlugin(rootViewController: viewController,
                                        adContainer: viewBanner,
                                        config: config)
        return (isNew: true, bannerPlugin: bannerPlugin)
    }
    
    // quảng cáo auto refresh
    func loadRefreshBanner(config: BannerPlugin.Config,
                                  viewBanner: UIView,
                                  viewController: UIViewController,
                                  onBannerWillDismiss: ((_ adUnitID: String) -> Void)? = nil,
                                  onBannerFailed: ((_ adUnitID: String) -> Void)? = nil,
                                  onLoadBannerSuccess: ((_ adUnitID: String) -> Void)? = nil,
                                  onBannerClick: ((_ adUnitID: String) -> Void)? = nil,
                                  onBannerPaidAds: ((_ adUnitID: String) -> Void)? = nil) {
        let adId = config.adUnitId
        let delegate = BannerRefreshDelegate(onBannerWillDismiss: onBannerWillDismiss,
                                             onBannerFailed: onBannerFailed,
                                             onLoadBannerSuccess: onLoadBannerSuccess,
                                             onBannerClick: onBannerClick,
                                             onBannerPaidAds: onBannerPaidAds)
        listDelegate[adId] = delegate
        if listLoadingAd.contains(where: { $0 == adId }) { return}
        let (isNew, bannerPlugin) = self.createAdBannerIfNeed(config: config,
                                                              viewBanner: viewBanner,
                                                              viewController: viewController)
        
        // TODO: - Create view and load banner plugin
        if isNew {
            bannerPlugin.setCallBack(onBannerWillDismiss: { [weak self] adUnitID in
                    print("ad==> bannerView will dismiss \(adUnitID)")
                self?.listBannerCachedAd.removeValue(forKey: adUnitID)
                self?.listBannerCachedAd[adUnitID] = nil
            }, onBannerFailed: { [weak self] adUnitID in
                self?.listLoadingAd.removeAll { $0 == adUnitID }
                self?.listDelegate[adUnitID]?.onBannerFailed?(adUnitID)
            }, onLoadBannerSuccess: { [weak self] adUnitID in
                self?.listBannerCachedAd[adUnitID] = BannerRefreshLoaded(bannerPlugin: bannerPlugin)
                self?.listLoadingAd.removeAll { $0 == adUnitID }
                self?.listDelegate[adUnitID]?.onLoadBannerSuccess?(adUnitID)
            }, onBannerClick: { [weak self] adUnitID in
                AdMobManager.shared.logEvenClick(id: adUnitID)
                self?.listDelegate[adUnitID]?.onBannerClick?(adUnitID)
            }, onBannerPaidAds: { [weak self] adUnitID in
                self?.listDelegate[adUnitID]?.onBannerPaidAds?(adUnitID)
            })

            bannerPlugin.loadAd()
        } else {
            if bannerPlugin.updateView(controller: viewController, viewBanner: viewBanner) {
                self.listDelegate[adId]?.onLoadBannerSuccess?(adId)
            } else {
                self.listDelegate[adId]?.onBannerFailed?(adId)
            }
        }
    }

}
