//
//  AdNativeFullView.swift
//  AdmobSDK
//
//  Created by Lê Minh Sơn on 5/12/24.
//

import UIKit
import GoogleMobileAds

public struct AdNativeFullConfig {
    var bgColor: UIColor? = .white
    var indicatorColor: UIColor? = .darkGray
    var timeToShowClose: Int = 3
    var closeButton: UIImage? = UIImage(systemName: "xmark.circle.fill")
    
    public init(bgColor: UIColor?,
         indicatorColor: UIColor?,
         closeButton: UIImage?) {
        self.bgColor = bgColor
        self.indicatorColor = indicatorColor
        self.timeToShowClose = RemoteConfigManager.shared.getValue(by: DefaultRemoteKey.timeShowCloseNativeFull)?.numberValue.intValue ?? 3
        self.closeButton = closeButton
    }
    
    public static let `default` = AdNativeFullConfig(bgColor: .white,
                                              indicatorColor: .darkGray,
                                              closeButton: UIImage(systemName: "xmark.circle.fill"))
    
}

class AdNativeFullView: UIView {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet private weak var viewAds: UIView!
    @IBOutlet private weak var loadingView: UIActivityIndicatorView!
    @IBOutlet private weak var btnClose: UIButton!
    
    private var config: AdNativeFullConfig = AdNativeFullConfig.default {
        didSet {
            self.updateStyleAd()
        }
    }
    private var refreshAd: Bool = true
    private var nativeAdType: NativeAdType = .nativeAdFull
    private var adId: AdConfigId?
    private var onCompletion: ((_ state: AdvertResult) -> Void)?
    private var timeoutChecker: TimeoutChecker?
    
    class func newInstance(_ adId: AdConfigId,
                           completion: @escaping ((_ state: AdvertResult) -> Void)) -> AdNativeFullView {
        let adNativeView = AdNativeFullView(frame: UIScreen.main.bounds)
        adNativeView.adId = adId
        adNativeView.onCompletion = completion
        return adNativeView
    }
    
    // options
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    private func setup() {
        Bundle(for: type(of: self)).loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)
        addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            self.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
            self.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            self.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0)
        ])
        self.isUserInteractionEnabled = true
        self.frame = UIScreen.main.bounds
        self.updateStyleAd()
    }
    
    private func updateStyleAd() {
        self.backgroundColor = config.bgColor
        self.btnClose.setImage(config.closeButton, for: .normal)
        self.btnClose.isHidden = config.closeButton == nil
    }
    
    @IBAction private func closeAds(_ sender: Any) {
        hide(success: true)
    }
    
    private func loadAd() {
        guard let ad = self.adId else {
            loadingView.isHidden = true
            loadingView.stopAnimating()
            showToast(self, duration: 3.0, position: .center) { [weak self] didTap in
                self?.hide(success: false)
            }
            return
        }
        btnClose.isHidden = true
        loadingView.isHidden = false
        loadingView.startAnimating()
        var aspectRatio: GADMediaAspectRatio = .portrait
        if (UIDevice.current.orientation == .landscapeRight)
        || (UIDevice.current.orientation == .landscapeLeft) {
            aspectRatio = .landscape
        }
        ADManager.shared.loadNative(ad, to: viewAds,
                                    refreshAd: refreshAd,
                                    nativeAdType: nativeAdType,
                                    ratio: aspectRatio) { [weak self] adId, success, nativeAdView in
            if !ADManager.shared.isTestMode {
                if ad.adId != adId { return }
            }
            self?.btnClose.isHidden = !success
            self?.loadingView.isHidden = true
            self?.loadingView.stopAnimating()
            if !success {
                if let weakSelf = self {
                    weakSelf.showToast(weakSelf, duration: 3.0, position: .center) { [weak self] didTap in
                        self?.hide(success: false)
                    }
                }
            } else {
                
            }
        }
    }
    
    private func show() {
        self.isHidden = false
        self.loadAd()
        self.fadeIn { [weak self] _ in
            self?.startTimeShowClose()
        }
    }
    
    private func hide(success: Bool) {
        onCompletion?(.showed)
        AdResumeManager.shared.isShowingAd = false
        DispatchQueue.main.asyncSafety { [weak self] in
            self?.fadeOut()
            self?.isHidden = true
            self?.removeFromSuperview()
            self?.onCompletion?(success ? .closed : .error)
        }
    }
    
    public class func show(_ adId: AdConfigId,
                           refreshAd: Bool,
                           nativeAdType: NativeAdType = .nativeAdFull,
                           config: AdNativeFullConfig = AdNativeFullConfig.default,
                           completion: @escaping ((_ state: AdvertResult) -> Void)) -> AdNativeFullView {
        let progressHUD = AdNativeFullView.newInstance(adId, completion: completion)
        progressHUD.translatesAutoresizingMaskIntoConstraints = false
        progressHUD.config = config
        progressHUD.refreshAd = refreshAd
        progressHUD.nativeAdType = nativeAdType
        if let window = UIApplication.shared.keyWindow {
            window.addSubview(progressHUD)
            NSLayoutConstraint.activate([
                window.topAnchor.constraint(equalTo: progressHUD.topAnchor,
                                            constant: 0),
                window.bottomAnchor.constraint(equalTo: progressHUD.bottomAnchor,
                                               constant: 0),
                window.leadingAnchor.constraint(equalTo: progressHUD.leadingAnchor,
                                                constant: 0),
                window.trailingAnchor.constraint(equalTo: progressHUD.trailingAnchor,
                                                 constant: 0)
            ])
        }
        progressHUD.show()
        return progressHUD
    }
    
    private func fadeIn(_ duration: TimeInterval = 1.0,
                        delay: TimeInterval = 0.0,
                        completion: ((Bool) -> Void)? = nil) {
        self.alpha = 0
        UIView.animate(withDuration: duration, delay: delay, options: .curveEaseInOut, animations: {
            self.alpha = 1.0
        }, completion: completion)
    }
    
    private func fadeOut(_ duration: TimeInterval = 1.0,
                         delay: TimeInterval = 0.0,
                         completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: duration, delay: delay, options: .curveEaseIn, animations: {
            self.alpha = 0.0
        }, completion: completion)
    }
    
    private func startTimeShowClose() {
        stopCheckTimmer()
        self.btnClose.isHidden = false
        self.btnClose.isUserInteractionEnabled = false
        UIView.setAnimationsEnabled(false)
        if config.timeToShowClose > 0 {
            self.btnClose.isHidden = false
            self.btnClose.setImage(nil, for: .normal)
            self.btnClose.setTitle("\(config.timeToShowClose)s", for: .normal)
        } else {
            self.btnClose.setTitle(nil, for: .normal)
            self.btnClose.setImage(self.config.closeButton, for: .normal)
            self.btnClose.isUserInteractionEnabled = true
            return
        }
        UIView.setAnimationsEnabled(true)
        timeoutChecker = TimeoutChecker.createChecker(timeout: TimeInterval(config.timeToShowClose),
                                                      onTick: { time in
            DispatchQueue.main.asyncSafety { [weak self] in
                UIView.setAnimationsEnabled(false)
                self?.btnClose.setImage(nil, for: .normal)
                self?.btnClose.setTitle("\(Int(time))s", for: .normal)
                UIView.setAnimationsEnabled(true)
            }
        }, onTimedout: {
            DispatchQueue.main.asyncSafety { [weak self] in
                self?.btnClose.setTitle(nil, for: .normal)
                self?.btnClose.setImage(self?.config.closeButton, for: .normal)
                self?.btnClose.isUserInteractionEnabled = true
            }
        })
        timeoutChecker?.startChecker()
    }
    
    private func stopCheckTimmer() {
        self.timeoutChecker?.stopChecker()
        self.timeoutChecker = nil
    }
}
