//
//  BaseViewController.swift
//  BBLabs.
//
//  Created by BBLabs on 12/14/20.
//  Copyright © 2020 BBLabs.All rights reserved.
//
import RxSwift
import UIKit

class BaseViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    var keyboardShow = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardNotification(notification:)),
                                               name: UIResponder.keyboardWillChangeFrameNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardDidShow(notification:)),
                                               name: UIResponder.keyboardDidShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardDidHide(notification:)),
                                               name: UIResponder.keyboardDidHideNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(languageChange(_:)),
                                               name: .changeLanguage,
                                               object: nil
        )
        self.setup()
        
        self.bindingData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(reachabilityChanged(_:)),
            name: .reachabilityChanged,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(reachabilityChanged(_:)),
            name: .retryInternet,
            object: nil
        )
        
    }
     
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: nil)
        NotificationCenter.default.removeObserver(self, name: .retryInternet, object: nil)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { (_) -> Void in
            self.applyOrientationConstraints()
        }, completion: { (_) -> Void in
            print("rotation completed")
        })
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    @objc func setup() {
        
    }
    
    @objc func bindingData() {
        
    }
    
    @objc func portraitConstrant() -> [NSLayoutConstraint] {
        return []
    }
    
    @objc func landscapeConstrant() -> [NSLayoutConstraint] {
        return []
    }
    
    @objc func updateMorePortrait() {
        
    }
    
    @objc func updateMoreLandscape() {
        
    }
    
    fileprivate func applyOrientationConstraints() {
        let orient = UIApplication.shared.windows.first?.windowScene?.interfaceOrientation
        switch orient {
        case .portrait:
            NSLayoutConstraint.activate(portraitConstrant())
            NSLayoutConstraint.deactivate(landscapeConstrant())
            updateMorePortrait()
        default:
            NSLayoutConstraint.deactivate(portraitConstrant())
            NSLayoutConstraint.activate(landscapeConstrant())
            updateMoreLandscape()
        }
    }
    
    func isPortraitScreen() -> Bool {
        return UIApplication.shared.windows.first?.windowScene?
            .interfaceOrientation.isPortrait ?? false
    }
    
    @objc dynamic func updateWhenReachable(_ reachability: Reachability) {
        
    }
    
    @objc dynamic func updateWhenNotReachable(_ reachability: Reachability) {
        
    }
    
    @objc func reachabilityChanged(_ note: Notification) {
        guard let reachability = note.object as? Reachability else { return }
        
        if reachability.connection != .unavailable {
            updateWhenReachable(reachability)
        } else {
            updateWhenNotReachable(reachability)
        }
    }
    
    // MARK: - Handle keyboard change
    @objc private func keyboardNotification(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        
        let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        let endFrameY = endFrame?.origin.y ?? 0
        let duration: TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
        let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
        let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
        let animationCurve: UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
        
        if endFrameY >= UIScreen.main.bounds.size.height {
            self.onCloseKeyboard()
        } else {
            let bottomArea: CGFloat = self.view.window?.safeAreaInsets.bottom ?? 0
            self.onOpenKeyboard((endFrame?.size.height ?? 0.0) - bottomArea)
        }
        
        UIView.animate(
            withDuration: duration,
            delay: TimeInterval(0),
            options: animationCurve,
            animations: {
                self.view.layoutIfNeeded()
            },
            completion: nil)
    }
    
    @objc private func keyboardDidShow(notification: NSNotification) {
        keyboardShow = true
    }
    
    @objc private func keyboardDidHide(notification: NSNotification) {
        keyboardShow = false
    }
    
    // MARK: - Handle and notice event language change
    internal func changeLanguage(language: Language) {
        UserDefaults.standard.set(language.key, forKey: UserDefault.languageKey.rawValue)
        Constants.currentLanguage = language
        noticeUpdateLanguage()
    }
    
    // MARK: - Handle and notice event language change
    func noticeUpdateLanguage() {
        NotificationCenter.default.post(name: .changeLanguage, object: nil)
    }
    
    @objc func onLanguageChange() {
        
    }
    
    @objc private func languageChange(_ note: Notification) {
        onLanguageChange()
    }
    
    @objc func onOpenKeyboard(_ height: CGFloat) {
        
    }
    
    @objc func onCloseKeyboard() {
        
    }
    
    deinit {
        print("deinit--\(String(describing: self))")
    }
    
    func enableAudioBackground() {
        if UserDefaultManager.disableMusicBackground {
            audioBackground.clearAudioPlayer()
        } else {
            audioBackground.loadAudio(type: .Background, isLoop: true)
        }
    }
    
    func clearAudioBackground() {
        audioBackground.clearAudioPlayer()
    }
    
    func pauseAudioBackground() {
        audioBackground.pauseAudio()
    }
    
    func playAudioBackground() {
        audioBackground.playAudio()
    }
    
    func showSettingView() {
        SettingsController.show(in: self)
    }
    
}
