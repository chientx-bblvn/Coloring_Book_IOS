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

class SettingsController: BaseViewController {
    
    var viewModel: SettingsVM!
    
    @IBOutlet weak var viewContent: UIView!
    
    @IBOutlet weak var lbSettings: UILabel!
    
    @IBOutlet weak var btnClose: UIButton!
    
    @IBOutlet weak var viewSound: UIView!
    
    @IBOutlet weak var imgSound: UIImageView!
    
    @IBOutlet weak var lbSound: UILabel!
    
    @IBOutlet weak var viewMusic: UIView!
    
    @IBOutlet weak var imgMusic: UIImageView!
    
    @IBOutlet weak var lbMusic: UILabel!
    
    @IBOutlet weak var viewLanguage: UIView!
    
    @IBOutlet weak var lbLanguage: UILabel!
    
    @IBOutlet weak var viewRate: UIView!
    
    @IBOutlet weak var lbRate: UILabel!
    
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
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissView)))
        viewSound.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onclickViewSound)))
        viewMusic.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onclickViewMusicBackground)))
        viewLanguage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onclickViewLanguage)))
        viewRate.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onclickViewRate)))
        imgMusic.image = UserDefaultManager.disableMusicBackground ? R.image.ic_off_music_background() : R.image.ic_on_music_background()
        imgSound.image = UserDefaultManager.disableSound ? R.image.ic_off_sound() : R.image.ic_on_sound()
    }
    
    @objc private func dismissView() {
        removeAnimate()
    }
    
    @IBAction func actionDismiss(_ sender: Any) {
        dismissView()
    }
    
    @objc func onclickViewSound() {
        UserDefaultManager.currentAccessDisableSound = !UserDefaultManager.disableSound
        imgSound.image = UserDefaultManager.disableSound ? R.image.ic_off_sound() : R.image.ic_on_sound()
    }
    
    @objc func onclickViewMusicBackground() {
        UserDefaultManager.currentAccessDisableMusicBackground = !UserDefaultManager.disableMusicBackground
        imgMusic.image = UserDefaultManager.disableMusicBackground ? R.image.ic_off_music_background() : R.image.ic_on_music_background()
        enableAudioBackground()
    }
    
    @objc func onclickViewLanguage() {
        AppRouter.shared.navigate(to: LanguageRoute.language(gofrom: .setting), with: .push)
    }
    
    @objc func onclickViewRate() {
        
    }
    
}

extension SettingsController {
    func loadLanguage() {
        lbSettings.text = LocalizableUtils.commonSettings()
        lbSound.text = LocalizableUtils.commonSound()
        lbMusic.text = LocalizableUtils.commonMusic()
        lbLanguage.text = LocalizableUtils.commonLanguage()
        lbRate.text = LocalizableUtils.commonRateApp()
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
