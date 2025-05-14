//
//  AdFullScreenLoadingVC.swift
//  AdmobSDK
//
//  Created by macbook on 28/08/2021.
//

import UIKit

class AdFullScreenLoadingVC: UIViewController {

    @IBOutlet weak var lbLoading: UILabel!
    
    private var timeoutChecker: TimeoutChecker?
    var adUnitId: AdUnitID?
    var adType: AdMobFullScreenType?
    var blockWillDismiss: VoidBlockAds?
    var blockDidDismiss: VoidBlockAds?
    var blockFail: VoidBlockAds?
    var blocWillPresent: VoidBlockAds?

    var needLoadAd = true
    var isOpenAd = false
    var textLoading: String {
        isOpenAd ? AdResumeManager.shared.adResumeLoadingString : AdMobManager.shared.adFullScreenLoadingString
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if needLoadAd {
            loadAd()
        } else {
            DispatchQueue.main.asyncSafety { [weak self] in
                if let self = self {
                    self.showLoadingDotAds(textLoading: self.textLoading)
                }
            }
        }
    }
    
    func loadAd() {
        guard let adUnitId = self.adUnitId, let adType = self.adType else {
            return
        }
        adType.createAd()
        let timeout = TimeInterval(RemoteConfigManager.shared.getValue(by:DefaultRemoteKey.timeoutRequestFullAd)?.numberValue.floatValue ?? 20)
        timeoutChecker = TimeoutChecker.createChecker(timeout: timeout,
                                                      onTimedout: { [weak self] in
            self?.blockDidDismiss?()
        })
        timeoutChecker?.startChecker()
        if adType.isExisted {
            self.stopCheckTimmer()
            showLoadingDotAds(textLoading: textLoading)
            adType.presentAd()
            
            AdMobManager.shared.blockFullScreenAdDidDismiss = { [weak self] in
                AdMobManager.shared.removeAd(unitId: adUnitId.rawValue)
                if !AdMobManager.shared.isSplash {
                    adType.createAd()
                }
                guard let _self = self else {
                    return
                }
                _self.stopCheckTimmer()
                _self.blockDidDismiss?()
            }
            
            AdMobManager.shared.blockFullScreenAdWillPresent =  { [weak self] unitId in
                guard let _self = self, _self.adUnitId?.rawValue == unitId else {
                    return
                }
                _self.blocWillPresent?()
            }
            
            AdMobManager.shared.blockFullScreenAdWillDismiss =  { [weak self]  in
                guard let _self = self else {
                    return
                }
                _self.hideLoading()
                _self.blockWillDismiss?()
            }
            
            AdMobManager.shared.blockFullScreenAdFailed =  { [weak self] unitId in
                guard let _self = self, _self.adUnitId?.rawValue == unitId else {
                    return
                }
                _self.stopCheckTimmer()
                _self.blockFail?()
            }

        } else {
            showLoadingDotAds(textLoading: textLoading)
            AdMobManager.shared.blockLoadFullScreenAdSuccess = { [weak self] unitId in
                guard let _self = self, _self.adUnitId?.rawValue == unitId else {
                    return
                }
                DispatchQueue.main.async {
                    adType.presentAd()
                }

                _self.stopCheckTimmer()
             
            }
            
            AdMobManager.shared.blockFullScreenAdWillDismiss =  { [weak self] in
                guard let _self = self else {
                    return
                }
                _self.stopCheckTimmer()
                _self.hideLoading()
                _self.blockWillDismiss?()
            }
            
            AdMobManager.shared.blockFullScreenAdDidDismiss = { [weak self] in
                AdMobManager.shared.removeAd(unitId: adUnitId.rawValue)
                if !AdMobManager.shared.isSplash {
                    adType.createAd()
                }
                guard let _self = self else {
                    return
                }
                _self.stopCheckTimmer()
                _self.blockDidDismiss?()
            }
            
            AdMobManager.shared.blockFullScreenAdWillPresent =  { [weak self] unitId in
                guard let _self = self, _self.adUnitId?.rawValue == unitId else {
                    return
                }
                _self.blocWillPresent?()
            }
            
            AdMobManager.shared.blockFullScreenAdFailed =  { [weak self] unitId in
                guard let _self = self, _self.adUnitId?.rawValue == unitId else {
                    return
                }
                _self.stopCheckTimmer()
                _self.blockFail?()
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.hideLoading()
            self?.stopCheckTimmer()
        }
    }
    
    private func hideLoading() {
        self.hideLoadingDotAds()
    }
    
    private func stopCheckTimmer() {
        self.timeoutChecker?.stopChecker()
    }
    
    static func createViewController(unitId: AdUnitID, adType: AdMobFullScreenType) -> AdFullScreenLoadingVC {
        let vc = AdFullScreenLoadingVC(nibName: "AdFullScreenLoadingVC", bundle: nil)
        vc.modalPresentationStyle = .fullScreen
        vc.adUnitId = unitId
        vc.adType = adType
        return vc
    }

}
