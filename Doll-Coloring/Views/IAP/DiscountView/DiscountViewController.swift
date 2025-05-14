//
//  DiscountViewController.swift
//  Doll-Coloring
//
//  Created by Nguyễn Việt Anh on 6/1/25.
//

import UIKit
import Lottie
import AdmobSDK

class DiscountViewController: BaseViewController {

    @IBOutlet weak var videoView: LottieAnimationView!
    
    @IBOutlet weak var btnClose: UIButton!
    
    @IBOutlet weak var btnClamItNow: UIButton!
    
    @IBOutlet weak var viewCountdown: UIView!
    
    @IBOutlet weak var lbCountdown: UILabel!
    
    
    @IBOutlet weak var lbTitle: UILabel!
    
    @IBOutlet weak var lbPrice: UILabel!
    
    @IBOutlet weak var lbDescription: UILabel!
    
    private var iapId: IAPIdType = .monthlySale
    private var iapIds: [IAPIdType] = []
    
    private var currentTime: Int = 900
    
    private var timer: Timer?
    
    var onCloseScreen:(() -> Void)?
    
    class func show(onCloseScreen:(() -> Void)? = nil) {
        let controller = DiscountViewController.loadController()
        controller.onCloseScreen = onCloseScreen
        controller.modalPresentationStyle = .overFullScreen
        if let vc = UIApplication.shared.windows.first?.rootViewController?.presentedViewController {
            vc.present(controller, animated: true)
        } else if let vc = UIApplication.shared.windows.first?.rootViewController {
            vc.present(controller, animated: true)
        }
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getInfoIAP()
    }
    
    
    override func setup() {
        super.setup()
        if UserDefaultManager.numberOfDaysSinceInstall() >= 7 {
               self.dismiss(animated: true) {
                   self.onCloseScreen?()
               }
            PremiumFloatingView.hide()
               return
           }
        
        viewCountdown.cornerRadiusView = 8
        viewCountdown.customGenerateOuterShadow(shadowOpacity: 1, shadowRadius: 0, color: UIColor(hexString: "000000"), shadowOffset: CGSize(width: 1, height: 1))
        videoView.loadAnimation(file: "flower", loopMode: .loop, contentMode: .scaleAspectFill)
        btnClamItNow.cornerRadiusView = 28
        btnClamItNow.customGenerateOuterShadow(shadowOpacity: 1, shadowRadius: 0, color: UIColor(hexString: "000000"), shadowOffset: CGSize(width: 2, height: 2))
       
        currentTime = UserDefaultManager.getRemainingCountdownTime()
        if UserDefaultManager.countdownEndTime == nil {
            UserDefaultManager.setupCountdownTimer(duration: UserDefaultManager.timeCountdown)
            currentTime = UserDefaultManager.timeCountdown
        }
        
        getInfoIAP()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(onTimer), userInfo: nil, repeats: true)
        lbCountdown.text = formatTime(seconds: currentTime)
        lbDescription.text = LocalizableUtils.iapGetSale()
        lbTitle.text = LocalizableUtils.iapOffSale()
    }
    
    override func bindingData() {
        super.bindingData()
        InappManager.share.didPaymentSuccess.asObserver().subscribe {_ in
            if IAPState.isUserVip {
                FirebaseEventManager.logEvent(with: RMBGEventTracking.iapScreenPurchase_made,
                                              params: [
                                                "iap_name": self.iapId.unit
                                              ])
                self.dismiss(animated: true)
            }
        }.disposed(by: disposeBag)
    }
    
    private func getInfoIAP() {
        loadData()
        iapIds = IAPIdType.getOption()
        if InappManager.share.listProduct.isEmpty {
            LoadingProgressHUD.show()
            _ = InappManager.share.productInfo(id: InappManager.share.productIdentifiers) {[weak self]_ in
                self?.iapIds = IAPIdType.getOption()
                self?.loadData()
                LoadingProgressHUD.dismiss()
            }
        } else {
            iapIds = IAPIdType.getOption()
            loadData()
        }
     }
    
    private func loadData() {
        iapId = .monthlySale
        iapIds.forEach { iap in
            guard UserDefaultManager.numberOfDaysSinceInstall() < 7 else { return }
            if iap == .monthlySale {
                let text = "\(IAPState.iapState == .expired ? IAPIdType.monthlySale.price : IAPIdType.monthlySale.discountPrice)/\(LocalizableUtils.iapMonth())"
                lbPrice.text = text
            }
        }
    }
    
    func formatTime(seconds: Int) -> String {
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        let seconds = seconds % 60
        if hours > 0 {
            return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        }
        if minutes > 0 {
            return String(format: "%02d:%02d", minutes, seconds)
        }
        return String(format: ":%02d", seconds)
    }
    
    @objc func onTimer() {
        currentTime = UserDefaultManager.getRemainingCountdownTime()
        lbCountdown.text = formatTime(seconds: currentTime)
        if currentTime <= 0 {
            timer?.invalidate()
            timer = nil
            UserDefaultManager.countdownEndTime = nil
            PremiumFloatingView.hide()
        }
    }
    
    
    @IBAction func actionClose(_ sender: Any) {
        self.dismiss(animated: false) {
                if let handler = self.onCloseScreen {
                    handler()
                }
            }
    }
    
    @IBAction func actionClamitNow(_ sender: Any) {
        InappManager.share.purchaseProduct(withId: iapId.id)
    }
    
}
