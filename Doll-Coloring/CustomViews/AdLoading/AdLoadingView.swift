//
//  AdLoadingController.swift
//  AnimalTranslate-iOS
//
//  Created by P.A.I.Hub on 01/10/2023.
//  Copyright ©2023 P.A.I.Hub. All rights reserved.
//

import Foundation
import Lottie
import RxSwift
import UIKit

class AdLoadingView: BaseCustomXibView {
    
    // MARK: - Variable and Outlet
    @IBOutlet private weak var viewAnimation: LottieAnimationView!
    @IBOutlet private weak var lbLoading: UILabel!
    
    private static let shared = AdLoadingView()
    
    override func didLoadFromNib() {
        super.didLoadFromNib()
        self.frame = UIScreen.main.bounds
        lbLoading.text = "Loading Ads ..."
    }
    
    func show() {
        self.isHidden = false
        self.viewAnimation.loadAnimation(file: "AdLoading", loopMode: .loop, autoPlay: true)
        self.fadeIn(0.25)
    }
    
    func hide() {
        DispatchQueue.main.asyncSafety{
            self.viewAnimation.stop()
            self.fadeOut(0.25)
            self.isHidden = true
            self.removeFromSuperview()
        }
    }
    
    class func isVisible() -> Bool {
        return !AdLoadingView.shared.isHidden && (AdLoadingView.shared.superview != nil)
    }
    
    class func show(delay: TimeInterval = 0.5, nextAction: (() -> Void)? = nil) {
        DispatchQueue.main.asyncSafety {
            let progressHUD = AdLoadingView.shared
            if isVisible() { return }
            if let currentController = AppRouter.shared.rootViewController {
                currentController.view.addSubview(progressHUD)
            } else {
                if let window = UIApplication.shared.keyWindow {
                    window.addSubview(progressHUD)
                }
            }
            progressHUD.show()
            if delay > 0 {
                DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
                  nextAction?()
                })
            } else {
                nextAction?()
            }
        }
    }
    
    class func dismiss() {
        DispatchQueue.main.asyncSafety{
            AdLoadingView.shared.hide()
        }
    }
    
}
