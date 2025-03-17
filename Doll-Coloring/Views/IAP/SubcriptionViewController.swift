//
//  SubcriptionViewController.swift
//  Doll-Coloring
//
//  Created by Việt Anh Nguyễn on 3/6/24.
//

import UIKit
import RxSwift
import RxCocoa

class SubcriptionViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var btnClose: UIButton!
    
    @IBOutlet weak var fsPageView: FSPagerView! {
        didSet {
            self.fsPageView.register(cellType: HistoryCellCollectionViewCell.self)
            self.fsPageView.itemSize = FSPagerView.automaticSize
            self.fsPageView.automaticSlidingInterval = 2
            self.fsPageView.isInfinite = true
            self.fsPageView.decelerationDistance = 2
            self.fsPageView.delegate = self
            self.fsPageView.dataSource = self
        }
    }
    
    
    @IBOutlet weak var viewIAPShow: UIView!
    
    @IBOutlet weak var viewWeekly: UIView!
    
    @IBOutlet weak var viewMonthly: UIView!
    
    
    @IBOutlet weak var viewYearly: UIView!
    
    
    @IBOutlet weak var lbRemoveAds: UILabel!
    
    @IBOutlet weak var viewPremiumBanner: UIView!
    
    @IBOutlet weak var lbUnlimitted: UILabel!
    
    @IBOutlet weak var lbUnlockFeature: UILabel!
    
    @IBOutlet var lb_subcription_week: UILabel!
    @IBOutlet var lb_subcription_month: UILabel!
    @IBOutlet var lb_subcription_year: UILabel!
    
    @IBOutlet var lbPrice_week: UILabel!
    @IBOutlet var lbPrice_month: UILabel!
    @IBOutlet var lbPrice_year: UILabel!
    
    @IBOutlet var lb_price_package_week: UILabel!
    @IBOutlet var lb_price_package_month: UILabel!
    @IBOutlet var lb_price_package_year: UILabel!
    
    @IBOutlet var icSelectPackage: [UIImageView]!
    
    @IBOutlet var viewPackage: [UIView]!
    
    @IBOutlet var contraintHeightPackage: [NSLayoutConstraint]!
    
    @IBOutlet weak var btnSubscribe: UIButton!
    
    @IBOutlet weak var btnPrivacy: UIButton!
    
    @IBOutlet weak var btnTerms: UIButton!
    
    @IBOutlet weak var btnRestore: UIButton!
    
    var onCloseScreen:(() -> Void)?
    var onClickCLoseIAP: (() -> Void)?
    var checkTime = false
    
    private var bannerHome: BannerHome = .iap
    
    private var iapIds: [IAPIdType] = []
    
    private var packageIds: IAPIdType = .weekly
    
    class func show(checkTime: Bool, handler: (() -> Void)? = nil, onClickCLose: (() -> Void)? = nil) {
        let controller = SubcriptionViewController.loadController()
        controller.onCloseScreen = handler
        controller.checkTime = checkTime
        controller.onClickCLoseIAP = onClickCLose
        controller.modalPresentationStyle = .overFullScreen
        if let vc = UIApplication.shared.windows.first?.rootViewController?.presentedViewController {
            vc.present(controller, animated: true)
        } else if let vc = UIApplication.shared.windows.first?.rootViewController {
            vc.present(controller, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewPackage.forEach({$0.isUserInteractionEnabled = true})
        viewPackage.forEach { view in
            view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onClickViewIAP(_:))))
        }
        InappManager.share.didPaymentSuccess.asObservable().subscribe(onNext: { [weak self] _ in
            if IAPState.isUserVip {
                FirebaseEventManager.logEvent(with: RMBGEventTracking.iapScreenPurchase_made,
                                              params: [
                                                "iap_name": self?.packageIds.unit ?? ""
                                              ])
                self?.clickCloseScreen()
            }
        }).disposed(by: disposeBag)
        loadLanguage()
        
        viewIAPShow.customGenerateOuterShadow(shadowOpacity: 1, shadowRadius: 0, color: UIColor(hexString: "000000"), shadowOffset: CGSize(width: 2, height: 2))
        viewWeekly.customGenerateOuterShadow(shadowOpacity: 1, shadowRadius: 0, color: UIColor(hexString: "000000"), shadowOffset: CGSize(width: 2, height: 2))
        viewMonthly.customGenerateOuterShadow(shadowOpacity: 1, shadowRadius: 0, color: UIColor(hexString: "000000"), shadowOffset: CGSize(width: 2, height: 2))
        viewYearly.customGenerateOuterShadow(shadowOpacity: 1, shadowRadius: 0, color: UIColor(hexString: "000000"), shadowOffset: CGSize(width: 2, height: 2))
        btnSubscribe.customGenerateOuterShadow(shadowOpacity: 1, shadowRadius: 0, color: UIColor(hexString: "000000"), shadowOffset: CGSize(width: 2, height: 2))
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getInfoIAP()
    }
    
    private func getInfoIAP() {
        loadData()
        iapIds = IAPIdType.getOption()
        if InappManager.share.listProduct.isEmpty {
            LoadingProgressHUD.show()
            _ = InappManager.share.productInfo(id: InappManager.share.productIdentifiers) { [weak self] product in
                self?.iapIds = IAPIdType.getOption()
                LoadingProgressHUD.dismiss()
                self?.loadData()
            }
        } else {
            iapIds = IAPIdType.getOption()
            loadData()
        }
    }
    
    func loadData() {
        iapIds.enumerated().forEach {index, id in
            switch id {
            case .weekly:
                lb_subcription_week.text = id.title
                lbPrice_week.text = id.price
                lb_price_package_week.text = LocalizableUtils.iapPrice_weekly(id.price)
            case .monthly:
                let price = (id.priceNumb.doubleValue / 4 ).regularPrice(locale: id.priceLocale) ?? ""
                lb_subcription_month.text = id.title
                lbPrice_month.text = id.price
                lb_price_package_month.text = LocalizableUtils.iapPrice_weekly(price)
            case .yearly:
                let price = (id.priceNumb.doubleValue / 52 ).regularPrice(locale: id.priceLocale) ?? ""
                lb_subcription_year.text = id.title
                lbPrice_year.text = id.price
                lb_price_package_year.text = LocalizableUtils.iapPrice_weekly(price)
            default: break
            }
        }
    }
    
    @objc private func onClickViewIAP(_ gesture: UIGestureRecognizer) {
        if let view = gesture.view,  let index = viewPackage.firstIndex(of: view), let packageIAP = iapIds.first(where: {$0.id == view.restorationIdentifier}){
            viewPackage.forEach { v in
                if v == view {
                    v.backgroundColor = UIColor(hexString: "FEF08A", alpha: 1)
                } else {
                    v.backgroundColor = .white
                }
            }
            icSelectPackage.enumerated().forEach { i, image in
                if i == index {
                    image.image = R.image.ic_select_language()
                } else {
                    image.image = R.image.ic_unselect_language()
                }
            }
            lb_price_package_week.isHidden = true
            lb_price_package_year.isHidden = true
            lb_price_package_month.isHidden = true
            switch packageIAP {
            case .weekly:
                lb_price_package_week.isHidden = false
            case .monthly:
                lb_price_package_month.isHidden = false
            case .yearly:
                lb_price_package_year.isHidden = false
            default: break
            }
           packageIds = packageIAP
        }
    }
    
    @objc
    private func clickCloseScreen() {
        if let handler = onCloseScreen {
            self.dismiss(animated: false) {
                handler()
            }
        } else {
            self.dismiss(animated: true)
        }
    }
    
    
    @IBAction func actionClose(_ sender: Any) {
//        if !UserDefaultManager.ABis_free_trial_us  {
//            onClickCLoseIAP?()
//        }
        clickCloseScreen()
    }
    
    @IBAction func actionSubcribe(_ sender: Any) {
        InappManager.share.purchaseProduct(withId: packageIds.id)
    }
    
    @IBAction func actionPrivacy(_ sender: Any) {
        privacyUrl.openLink()
    }
    
    @IBAction func actionTerms(_ sender: Any) {
        termsUrl.openLink()
    }
    
    @IBAction func actionRestone(_ sender: Any) {
        InappManager.share.restorePurchases(isShowLoading: true)
    }
}

extension SubcriptionViewController {
    func loadLanguage() {
        btnSubscribe.setTitle(LocalizableUtils.commonContinue(), for: .normal)
        btnPrivacy.setTitle(LocalizableUtils.iapPrivacyPolicy(), for: .normal)
        btnRestore.setTitle(LocalizableUtils.iapRestorePurchase(), for: .normal)
        btnTerms.setTitle(LocalizableUtils.iapTermOfUse(), for: .normal)
    }
}

extension SubcriptionViewController: FSPagerViewDataSource,FSPagerViewDelegate {
    public func numberOfItems(in pagerView: FSPagerView) -> Int {
        return bannerHome.images.count
    }
    
    public func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(for: index, cellType: HistoryCellCollectionViewCell.self)
        cell.imageView?.image = UIImage(named: bannerHome.images[index])
        cell.imageView?.contentMode = .scaleAspectFill
        cell.imageView.layer.borderWidth = 0
        cell.imageView.layer.cornerRadius = 0
        cell.imageView?.clipsToBounds = true
        return cell
    }
    
    // MARK:- FSPagerView Delegate
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        pagerView.deselectItem(at: index, animated: true)
        pagerView.scrollToItem(at: index, animated: true)
    }
}
