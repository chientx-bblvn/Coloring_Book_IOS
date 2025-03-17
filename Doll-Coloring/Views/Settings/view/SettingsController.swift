//
//  SettingsController.swift
//  Doll-Coloring
//
//  Created by Việt Anh Nguyễn on 10/04/2024.
//  
//

import Foundation
import RxSwift
import UIKit
import StoreKit

class SettingsController: BaseViewController {
    
    var viewModel: SettingsVM!
    
    @IBOutlet weak var topBarView: TopBarView!
    
    @IBOutlet weak var viewContent: UIView!
    
    @IBOutlet weak var viewLanguage: UIView!
    
    @IBOutlet weak var lbLanguage: UILabel!
    
    @IBOutlet weak var viewRate: UIView!
    
    @IBOutlet weak var lbRate: UILabel!
    
    @IBOutlet weak var viewPolicy: UIView!
    
    @IBOutlet weak var lbPolicy: UILabel!
    
    @IBOutlet weak var viewShare: UIView!
    
    @IBOutlet weak var lbShare: UILabel!
    
    @IBOutlet weak var viewFeedback: UIView!
    
    @IBOutlet weak var lbFeedBack: UILabel!
    
    @IBOutlet weak var viewMoreApp: UIView!
    
    @IBOutlet weak var lbMoreApp: UILabel!
    
    class func show(in parent: UIViewController) {
        let mainStoryboard = UIStoryboard(name: "Settings", bundle: nil)
        guard let customView = mainStoryboard.instantiateViewController(withIdentifier: String(describing: self)) as? SettingsController else {
            return
        }
        customView.providesPresentationContextTransitionStyle = true
        customView.definesPresentationContext = true
        customView.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        customView.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        customView.showInView(parent: parent)
    }
    
    
    override func setup() {
        super.setup()
        loadLanguage()
        setupView()
    }
    

    override func bindingData() {
        super.bindingData()
    }
    
    override func onLanguageChange() {
        super.onLanguageChange()
        loadLanguage()
    }
    
    private func setupView() {
        viewContent.customGenerateOuterShadow(shadowOpacity: 1, shadowRadius: 0, color: UIColor(hexString: "000000"), shadowOffset: CGSize(width: 4, height: 4))
        
        topBarView.titleFont = .systemFont(ofSize: 24, weight: .bold)
        topBarView.textAlignmentCenter = true
        viewLanguage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onclickViewLanguage)))
       viewRate.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onclickViewRate)))
        viewPolicy.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onclickViewPolicy)))
        viewShare.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onclickViewShare)))
        viewFeedback.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onclickViewFeedback)))
        viewMoreApp.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onclickViewMore)))
    }
    
    @objc private func dismissView() {
        removeAnimate()
    }
    
    @objc func onclickViewLanguage() {
        AppRouter.shared.navigate(to: LanguageRoute.language(gofrom: .setting), with: .push)
    }
    
    @objc func onclickViewRate() {
        rateApp()
    }
    
    @objc func onclickViewPolicy() {
        privacyUrl.openLink()
    }
    
    @objc func onclickViewShare() {
       
    }
    
    @objc func onclickViewFeedback() {
        
    }
    
    @objc func onclickViewMore() {
        
    }
    
    func rateApp() {
        if #available(iOS 10.3, *) {
            SKStoreReviewController.requestReview()
        } else if let url = URL(string: "itms-apps://itunes.apple.com/app/" + "6502046149") {
            UIApplication.shared.openURL(url)
        }
    }
    
}

extension SettingsController {
    func loadLanguage() {
        topBarView.title = LocalizableUtils.commonSettings()
        lbLanguage.text = LocalizableUtils.commonLanguage()
        lbRate.text = LocalizableUtils.settingRateApp()
        lbPolicy.text = LocalizableUtils.settingPolicy()
        lbShare.text = LocalizableUtils.settingShareApp()
        lbFeedBack.text = LocalizableUtils.settingFeedBack()
        
    }
    
    func showInView(parent: UIViewController) {
        self.view.translatesAutoresizingMaskIntoConstraints = false
        parent.addChild(self)
        parent.view.addSubview(self.view)
        updateConstraints(parent.view)
        self.didMove(toParent: parent.parent)
        self.showAnimate()
        
    }
    
    private func showAnimate() {
        self.viewContent.transform = .identity.scaledBy(x: 0, y: 0)
        self.view.alpha = 0.0
        UIView.animate(withDuration: 0.25,
                       delay: 0,
                       options: .curveEaseInOut,
                       animations: {
            self.view.alpha = 1.0
            self.viewContent.transform = .identity
        })
    }
    
    private func removeAnimate(completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: 0.25,
                       delay: 0,
                       options: .curveEaseInOut,
                       animations: {
            self.viewContent.transform = .identity.scaledBy(x: 0.1, y: 0.1)
        }, completion: {(finished: Bool) in
            if finished {
                completion?()
                self.view.alpha = 0.0
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
