//
//  NativeFullScreenController.swift
//  Doll-Coloring
//
//  Created by Nguyễn Việt Anh on 1/11/24.
//

import UIKit

class NativeFullScreenController: BaseViewController {
    
    @IBOutlet weak var viewAds: UIView!
    
    @IBOutlet weak var btnClose: UIButton!
    
    var onTapClose: (() -> Void)?
    
    class func show(actionOk: (() -> Void)? = nil) {
        let customView = NativeFullScreenController.loadController()
        customView.providesPresentationContextTransitionStyle = true
        customView.definesPresentationContext = true
        customView.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        customView.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        customView.onTapClose = actionOk
        if let vc = UIApplication.shared.windows.first?.rootViewController?.presentedViewController {
            vc.present(customView, animated: false)
        } else if let vc = UIApplication.shared.windows.first?.rootViewController {
            vc.present(customView, animated: false)
        }
    }
    
    override func setup() {
        super.setup()
        loadAdsNative()
    }
    
    
    func loadAdsNative() {
        ADManager.shared.loadNative(DollColoringAdID.nativefull_afterinter, to: viewAds, nativeAdType: .customFullScreenNative) { adId, success, nativeAdView in
            guard adId.contains(DollColoringAdID.nativefull_afterinter.adId) else {
                return
            }
            if !success {
                self.removeAnimate {
                    self.onTapClose?()
                }
            }
        }
    }

    @IBAction func actionClose(_ sender: Any) {
        self.dismiss(animated: true) {
            self.onTapClose?()
        }
        
    }
}

extension NativeFullScreenController {
    func showInView(parent: UIViewController) {
        self.view.translatesAutoresizingMaskIntoConstraints = false
        parent.addChild(self)
        parent.view.addSubview(self.view)
        updateConstraints(parent.view)
        self.didMove(toParent: parent.parent)
        self.showAnimate()
        
    }
    
    private func showAnimate() {
        self.view.alpha = 0.0
        UIView.animate(withDuration: 0.3,
                       delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 1,
                       options: .curveEaseInOut,
                       animations: {
            self.view.alpha = 1.0
            self.view.transform = .identity
        })
    }
    
    private func removeAnimate(completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: 0.3,
                       delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 1,
                       options: .curveEaseInOut,
                       animations: {
            self.view.alpha = 0.0
        }, completion: {(finished: Bool) in
            if finished {
                completion?()
                self.willMove(toParent: nil)
                self.view.removeFromSuperview()
                self.removeFromParent()
            }
        })
    }
    
    private func updateConstraints(_ parentView: UIView) {
        guard let view = self.view else { return }
        let bottomConstraint = NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: parentView, attribute: .bottom, multiplier: 1, constant: 0)
        let leadingConstraint = NSLayoutConstraint(item: view, attribute: .leading, relatedBy: .equal, toItem: parentView, attribute: .leading, multiplier: 1, constant: 0)
        let trailingContraint = NSLayoutConstraint(item: view, attribute: .trailing, relatedBy: .equal, toItem: parentView, attribute: .trailing, multiplier: 1, constant: 0)
        let topConstraint = NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: parentView, attribute: .top, multiplier: 1, constant: 0)
        NSLayoutConstraint.activate([
            topConstraint,
            bottomConstraint,
            leadingConstraint,
            trailingContraint
        ])
    }
}
