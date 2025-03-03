//
//  PremiumFloatingView.swift
//  Doll-Coloring
//
//  Created by BBLabs on 08/12/2023.
//

import UIKit
import Lottie
import AdmobSDK

class PremiumFloatingView: BaseCustomXibView {
    
    private static let keyTimeSessionToday = "KeyTimeSessionToday"
    
    static let shared: PremiumFloatingView = {
        let premiumFloatingView = PremiumFloatingView()
        premiumFloatingView.translatesAutoresizingMaskIntoConstraints = false
        premiumFloatingView.window?.windowLevel = .alert
        premiumFloatingView.alpha = 0
        return premiumFloatingView
    }()
    
    class func show() {
        if isClosed || IAPState.isUserVip || (IAPState.iapState == .unload) || UserDefaultManager.disableSale {
            return
        }
        let premiumFloatingView = PremiumFloatingView.shared
        premiumFloatingView.removeFromSuperview()
        var window: UIWindow!
        if let parent = UIApplication.shared.keyWindow {
            window = parent
            window.addSubview(premiumFloatingView)
        } else if let parent = UIApplication.shared.windows.first {
            window = parent
            window.addSubview(premiumFloatingView)
        } else {
            return
        }
        
        var disY = premiumFloatingView.bounds.origin.y
        let disX = premiumFloatingView.bounds.origin.x
        
        if disY < topBariel {
            disY = topBariel + 30
        }
        
        NSLayoutConstraint.activate([
            premiumFloatingView.topAnchor.constraint(equalTo: window.topAnchor, constant: disY),
            premiumFloatingView.leadingAnchor.constraint(equalTo: window.leadingAnchor, constant: disX),
            premiumFloatingView.heightAnchor.constraint(equalToConstant: 80),
            premiumFloatingView.widthAnchor.constraint(equalToConstant: 80)
        ])
        premiumFloatingView.fadeIn()
    }
    
    class func hide() {
        isClosed = true
        let premiumFloatingView = PremiumFloatingView.shared
        premiumFloatingView.fadeOut { finish in
            if finish {
                premiumFloatingView.removeFromSuperview()
            }
        }
    }
    
    static var isShowToday: Bool {
        get {
            if let currentTime = UserDefaults.standard.string(forKey: keyTimeSessionToday) {
                let currentDate = Date().toMyString(format: "yyyy-MM-dd")
                return currentDate != currentTime
            }
            return true
        }
        set {
            UserDefaults.standard.set(Date().toMyString(format: "yyyy-MM-dd"), forKey: keyTimeSessionToday)
        }
    }
    
    @IBOutlet private weak var imageCloseView: UIImageView!
    @IBOutlet private weak var imageMainPremiumView: UIImageView!
    @IBOutlet private weak var trailingClose: NSLayoutConstraint!
    @IBOutlet private weak var leadingClose: NSLayoutConstraint!
    
    @IBOutlet weak var viewBlur: UIView!
    
    
    private static var isClosed = false
    private static var topBariel: CGFloat {
        return (UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 0) + 60
    }
    private var minX: CGFloat { self.bounds.width / 2.0 }
    private var minY: CGFloat { self.bounds.height / 2.0 }
    private var maxX: CGFloat {
        let screenWidth = UIScreen.main.bounds.width
        
        return screenWidth - (self.bounds.width / 2.0)
    }
    private var maxY: CGFloat {
        let screenHeight = UIScreen.main.bounds.height
        
        return screenHeight - (self.bounds.height / 2.0)
    }
    
    override func didLoadFromNib() {
        super.didLoadFromNib()
        setupView()
    }
    
    private func setupView() {
        imageCloseView.isUserInteractionEnabled = true
        imageCloseView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clickCloseView)))
        imageMainPremiumView.isUserInteractionEnabled = true
        imageMainPremiumView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clickMainPremiumView)))
        
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(onPanGesture(_:))))
        viewBlur.cornerRadiusView = 30
    }
    
    @objc private func clickCloseView() {
        PremiumFloatingView.hide()
    }
    
    @objc private func clickMainPremiumView() {
        DiscountViewController.show()
    }
    
    @objc private func onPanGesture(_ panGesture: UIPanGestureRecognizer) {
        let presentedView = self
        guard let parentView = self.superview else {
            return
        }
        switch panGesture.state {
        case .changed:
            parentView.bringSubviewToFront(presentedView)
            let translation = panGesture.translation(in: parentView)
            let y = presentedView.center.y + translation.y
            let x = presentedView.center.x + translation.x
            
            if x <= maxX, x >= minX, y >= minY, y <= maxY {
                presentedView.center = CGPoint(x: x, y: y)
            }
            panGesture.setTranslation(CGPoint.zero, in: parentView)
        case .ended:
            let screenWidth = UIScreen.main.bounds.width
            
            let nearLeftX = presentedView.center.x
            let nearRightX = screenWidth - nearLeftX
            
            if nearLeftX < nearRightX {
                presentedView.center = CGPoint(x: minX, y: presentedView.center.y)
                _ = leadingClose.deactivate()
                _ = trailingClose.activate()
            } else {
                presentedView.center = CGPoint(x: maxX, y: presentedView.center.y)
                _ = trailingClose.deactivate()
                _ = leadingClose.activate()
            }
            
        default:
            break
        }
    }
    
}
