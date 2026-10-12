//
//  IAPController.swift
//  PrankSound-iOS
//
//  Created by BBLabs on 31/10/2023.
//  Copyright ©2024 BBLabs. All rights reserved.
//

import Foundation
import RxSwift
import UIKit
import SVProgressHUD
import Lottie
import StoreKit

class IAPController: BaseViewController {
    
    // MARK: - Variable and Outlet
    @IBOutlet private weak var imageCloseScreen: UIImageView!
    @IBOutlet private weak var lottieAnimateView: LottieAnimationView!
    @IBOutlet private weak var lbTitle: UILabel!
    @IBOutlet private weak var btnSale1: UIButton!
    @IBOutlet private weak var btnSale2: UIButton!
    @IBOutlet private weak var btnSale3: UIButton!
    
    @IBOutlet private weak var viewFreeTrial: UIView!
    @IBOutlet private weak var lbTitleFreeTrial: UILabel!
    @IBOutlet private weak var switchFreeTrial: UISwitch!
    
    // Weekly Access
    @IBOutlet private weak var viewWeekly: UIView!
    @IBOutlet private weak var imageViewWeekly: UIImageView!
    @IBOutlet private weak var lbTitleWeekly: UILabel!
    @IBOutlet private weak var lbPriceWeekly: UILabel!
    
    // Yearly Access
    @IBOutlet private weak var viewYearly: UIView!
    @IBOutlet private weak var imageViewYearly: UIImageView!
    @IBOutlet private weak var lbTitleYearly: UILabel!
    @IBOutlet private weak var lbPriceYearly: UILabel!
    
    // Enable Free trial
    @IBOutlet private weak var viewDueDate: UIView!
    @IBOutlet private weak var lbTitleDueToday: UILabel!
    @IBOutlet private weak var lbOnlyApplies: UILabel!
    @IBOutlet private weak var lbTitleDueDayFree: UILabel!
    @IBOutlet private weak var lbPriceDueDayFree: UILabel!
    
    @IBOutlet private weak var btnContinue: UIButton!
    @IBOutlet private weak var btnContinueWithFree: UIButton!
    
    @IBOutlet private weak var btnTerm: UIButton!
    @IBOutlet private weak var btnPrivacy: UIButton!
    @IBOutlet private weak var btnRestore: UIButton!
    
    private var iapIds: [IAPIdType] = []
    
    private var freeModeEnable = false {
        didSet {
            if self.freeModeEnable {
//                self.btnContinue.setTitle(LocalizableUtils.iapButtonStartTrial(), for: .normal)
//                self.lbTitleFreeTrial.text = LocalizableUtils.iapDisableTrial()
                
                self.viewWeekly.fadeOut(0.5)
                self.viewYearly.fadeOut(0.5)
                
                self.viewDueDate.fadeIn(0.5)
                self.btnContinueWithFree.fadeIn(0.5)
            } else {
//                self.btnContinue.setTitle(LocalizableUtils.commonContinue(), for: .normal)
//                self.lbTitleFreeTrial.text = LocalizableUtils.iapEnableTrial()
                
                self.viewWeekly.fadeIn(0.5)
                self.viewYearly.fadeIn(0.5)
                
                self.viewDueDate.fadeOut(0.5)
                self.btnContinueWithFree.fadeOut(0.5)
            }
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) { [weak self] in
                guard let `self` = self else { return }
                self.viewWeekly.isHidden = self.freeModeEnable
                self.viewYearly.isHidden = self.freeModeEnable
                self.viewDueDate.isHidden = !self.freeModeEnable
                self.btnContinueWithFree.isHidden = !self.freeModeEnable
            }
        }
    }
    
    private var selectedIndex = -1 {
        didSet {
//            imageViewWeekly.image = selectedIndex == 1 ? R.image.image_iap_selected() : R.image.image_iap_unselected()
//            imageViewYearly.image = selectedIndex == 0 ? R.image.image_iap_selected() : R.image.image_iap_unselected()
        }
    }
    
    private var autoClickPurchase: Bool = false
    var checkTime = false
    var onCloseScreen: (() -> Void)?
    
    class func show(checkTime: Bool, handler: (() -> Void)? = nil) {
        let iapController = IAPController.loadController()
        iapController.onCloseScreen = handler
        iapController.checkTime = checkTime
        iapController.modalPresentationStyle = .overFullScreen
        if let vc = UIApplication.shared.windows.first?.rootViewController?.presentedViewController {
            vc.present(iapController, animated: true)
        } else if let vc = UIApplication.shared.windows.first?.rootViewController {
            vc.present(iapController, animated: true)
        }
    }
    
    // MARK: - Setup controller and IBAction
    override func setup() {
        super.setup()
        setupView()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func bindingData() {
        super.bindingData()
        loadText()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getInfoIAP()
    }
    
    // MARK: - Language change event
    override func onLanguageChange() {
        super.onLanguageChange()
        loadText()
    }
    
}

// MARK: - Action view
extension IAPController {
    
    @IBAction func onChangeFreeMode(_ sender: UISwitch) {
        freeModeEnable = sender.isOn
    }
    
    @IBAction func clickContinueBuyIAP(_ sender: Any) {
        if freeModeEnable {
            if let bestPrice = iapIds.first(where: { idType in
                return idType.isBestPrice
            }) {
                InappManager.share.purchaseProduct(withId: bestPrice.id)
            }
            return
        }
        switch selectedIndex {
        case 0:
            viewWeekly.isClicked(true)
            clickPurchase(selectIndex: 0)
        case 1:
            viewYearly.isClicked(true)
            clickPurchase(selectIndex: 1)
        default:
            break
        }
    }
    
    @IBAction func clickContinueWithFreeTrial(_ sender: Any) {
        if let bestPrice = iapIds.first(where: { idType in
            return idType.isBestPrice
        }) {
            
            switch bestPrice {
//            case .weekly:
//                FirebaseEventManager.logEvent(with: RMBGEventTracking.iapScreenContinueClicked,
//                                              params: ["iap_name" : "yearly"])
            case .yearly:
                FirebaseEventManager.logEvent(with: RMBGEventTracking.iapScreenContinueClicked,
                                              params: ["iap_name" : "weekly"])
            case .monthly:
                FirebaseEventManager.logEvent(with: RMBGEventTracking.iapScreenContinueClicked,
                                              params: ["iap_name" : "month"])
            default: break
            }
            InappManager.share.purchaseProduct(withId: bestPrice.id)
        }
    }
    
    @IBAction func clickOpenTerm(_ sender: Any) {
//        Constants.termOfUse.openLink()
    }
    
    @IBAction func clickOpenPrivacy(_ sender: Any) {
//        Constants.privacyPolicy.openLink()
    }
    
    @IBAction func clickRestore(_ sender: Any) {
        InappManager.share.restorePurchases(isShowLoading: true)
    }
    
    private func getInfoIAP() {
        loadData()
        iapIds = IAPIdType.getOption()
        if InappManager.share.listProduct.isEmpty {
            SVProgressHUD.show()
            _ = InappManager.share.productInfo(id: InappManager.share.productIdentifiers) { [weak self] product in
                self?.iapIds = IAPIdType.getOption()
                self?.loadData()
                SVProgressHUD.dismiss()
            }
        } else {
            iapIds = IAPIdType.getOption()
            loadData()
        }
    }
    
    private func clickPurchase(selectIndex: Int) {
        self.selectedIndex = selectIndex
        let iapType = iapIds[selectIndex]
        InappManager.share.purchaseProduct(withId: iapType.id)
    }
    
    private func loadData() {
//        if let bestPrice = iapIds.first(where: { idType in
//            return idType.isBestPrice
//        }) {
//            lbTitleDueToday.text = LocalizableUtils.iapDueToday("\(Double(0).regularPrice(locale: bestPrice.priceLocale) ?? "0")")
//            viewFreeTrial.isHidden = true
//            if bestPrice.freeday > 0 {
//                var today = Date()
//                today = today.add(day: bestPrice.freeday)
//                lbTitleDueDayFree.text = LocalizableUtils.iapDueFreeDay(today.toMyString(format: "dd MMMM, yyyy"))
//                viewFreeTrial.isHidden = false
//                btnContinueWithFree.setTitle(LocalizableUtils.iapButtonFreeDay(bestPrice.freeday,
//                                                                               bestPrice.price),
//                                             for: .normal)
//            }
//            lbPriceDueDayFree.text = bestPrice.price
//            let priceNumb = (bestPrice.priceNumb.doubleValue / Double(bestPrice.numberDay)).regularPrice(locale: bestPrice.priceLocale) ?? ""
//            if bestPrice == .weekly {
//                lbTitleWeekly.text = bestPrice.title
//                lbPriceWeekly.text = LocalizableUtils.iapOnlyPerdayWeekly(priceNumb, bestPrice.price)
//            } else if bestPrice == .yearly {
//                lbTitleYearly.text = bestPrice.title
//                lbPriceYearly.text = LocalizableUtils.iapOnlyPerdayYearly(priceNumb, bestPrice.price)
//            } else {
//                lbPriceWeekly.text = ""
//                lbPriceYearly.text = ""
//            }
//            selectedIndex = 0
//            let autoPurchase = RemoteConfigManager.shared.getValue(by: RMBGRemoteConfig.autoPurchase)?.boolValue ?? true
//            if autoPurchase, self.autoClickPurchase {
//                clickContinueBuyIAP("")
//            }
//        }
//        
//        if let unBestPrice = iapIds.first(where: { idType in
//            return !idType.isBestPrice
//        }) {
//            lbTitleDueToday.text = LocalizableUtils.iapDueToday("\(Double(0).regularPrice(locale: unBestPrice.priceLocale) ?? "0")")
//            if viewFreeTrial.isHidden {
//                if unBestPrice.freeday > 0 {
//                    var today = Date()
//                    today = today.add(day: unBestPrice.freeday)
//                    lbTitleDueDayFree.text = LocalizableUtils.iapDueFreeDay(today.toMyString(format: "dd MMM, yyyy"))
//                    viewFreeTrial.isHidden = false
//                    btnContinueWithFree.setTitle(LocalizableUtils.iapButtonFreeDay(unBestPrice.freeday,
//                                                                                   unBestPrice.price),
//                                                 for: .normal)
//                }
//            }
//            let priceNumb = (unBestPrice.priceNumb.doubleValue / Double(unBestPrice.numberDay)).regularPrice(locale: unBestPrice.priceLocale) ?? ""
//            if unBestPrice == .weekly {
//                lbTitleWeekly.text = unBestPrice.title
//                lbPriceWeekly.text = LocalizableUtils.iapOnlyPerdayWeekly(priceNumb, unBestPrice.price)
//            } else if unBestPrice == .yearly {
//                lbTitleYearly.text = unBestPrice.title
//                lbPriceYearly.text = LocalizableUtils.iapOnlyPerdayYearly(priceNumb, unBestPrice.price)
//            } else {
//                lbPriceWeekly.text = ""
//                lbPriceYearly.text = ""
//            }
//            if selectedIndex == -1 {
//                selectedIndex = 1
//            }
//        }
    }
}

// MARK: - Setup view
extension IAPController {
    
    private func setupView() {
        freeModeEnable = false
        lottieAnimateView.loadAnimation(file: "iap_animate_full", loopMode: .loop, autoPlay: true)
        FirebaseEventManager.logEvent(with: RMBGEventTracking.iapScreenViewed)
        imageCloseScreen.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                                     action: #selector(clickCloseScreen)))
        
        if checkTime,
           let timeToShowClose = RemoteConfigManager.shared.getValue(by: RMBGRemoteConfig.timeShowIconCloseIap)?.numberValue.intValue,
           timeToShowClose > 0 {
            autoClickPurchase = true
            imageCloseScreen.isHidden = true
            DispatchQueue.main.asyncAfter(deadline: .now() + TimeInterval(timeToShowClose), execute: { [weak self] in
                self?.imageCloseScreen.isHidden = false
                self?.imageCloseScreen.fadeIn()
            })
        } else {
            imageCloseScreen.isHidden = false
        }
        
        setupEventForRegisterIAP()
    }
    
    private func loadText() {
//        lbTitle.text = LocalizableUtils.iapTitle()
//        btnSale1.setTitle(LocalizableUtils.iapSale1(), for: .normal)
//        btnSale2.setTitle(LocalizableUtils.iapSale2(), for: .normal)
//        btnSale3.setTitle(LocalizableUtils.iapSale3(), for: .normal)
//        
//        lbOnlyApplies.text = LocalizableUtils.iapDueTodayOnlyApply()
//        
//        btnContinue.setTitle(LocalizableUtils.commonContinue(), for: .normal)
//        
//        btnTerm.setTitle(LocalizableUtils.iapTermOfUse(), for: .normal)
//        btnPrivacy.setTitle(LocalizableUtils.iapPrivacyPolicy(), for: .normal)
//        btnRestore.setTitle(LocalizableUtils.iapRestorePurchase(), for: .normal)
    }
    
    @objc private func clickBuyBestPrice() {
        selectedIndex = 0
    }
    
    @objc private func clickBuySecondPrice() {
        selectedIndex = 1
    }
    
    @objc
    private func clickCloseScreen() {
        if let handler = onCloseScreen {
            self.dismiss(animated: false)
            handler()
        } else {
            self.dismiss(animated: true)
        }
    }
    
    private func setupEventForRegisterIAP() {
        viewYearly.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clickBuyBestPrice)))
        viewWeekly.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clickBuySecondPrice)))
        InappManager.share.didPaymentSuccess.asObservable().subscribe(onNext: { [weak self] _ in
            if IAPState.isUserVip {
                FirebaseEventManager.logEvent(with: RMBGEventTracking.iapScreenPurchase_made,
                                              params: [
                                                "iap_name": self?.selectedIndex == 0 ? "yearly" : "weekly"
                                              ])
                self?.clickCloseScreen()
            }
        }).disposed(by: disposeBag)
    }
    
}
