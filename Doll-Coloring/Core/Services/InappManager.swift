//
//  InappManager.swift
//  Doll-Coloring
//

import Foundation
import StoreKit
import SwiftyStoreKit
import RxSwift
import SVProgressHUD
import UIKit
import Combine

enum IAPState: String {
    case purchased = "purchased"
    case expired = "expired"
    case notPurchased = "notPurchased"
    case unload = "unload"

    static var isDev = false
    private static let keyIAPState = "KEY_IAP_STATE"

    static var iapState: IAPState {
        get {
            if let state = UserDefaults.standard.string(forKey: keyIAPState) {
                return IAPState(rawValue: state) ?? .notPurchased
            }
            return .notPurchased
        }
        set {
            if iapState != newValue {
                UserDefaults.standard.setValue(newValue.rawValue, forKey: keyIAPState)
                UserDefaults.standard.synchronize()
                print("--> send didPaymentSuccess")
                InappManager.share.didPaymentSuccess.onNext(newValue)
                Task { @MainActor in
                    IAPStatusStore.shared.refresh()
                }
            }
        }
    }

    static var isUserVip: Bool {
        return iapState == .purchased
    }
}

/// SwiftUI-facing VIP flag — PRO chrome observes this after purchase.
@MainActor
final class IAPStatusStore: ObservableObject {
    static let shared = IAPStatusStore()

    @Published private(set) var isVip: Bool = IAPState.isUserVip

    private let disposeBag = DisposeBag()

    private init() {
        refresh()
        InappManager.share.didPaymentSuccess
            .asObservable()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] (_: IAPState) in
                self?.refresh()
            })
            .disposed(by: disposeBag)
    }

    func refresh() {
        let vip = IAPState.isUserVip
        if isVip != vip {
            isVip = vip
        } else {
            // Force publishers that only read `isVip` once at appear to refresh.
            objectWillChange.send()
            isVip = vip
        }
    }
}

typealias ProductIdentifier = String

protocol InappManagerDelegate: AnyObject {
    func purchaseSuccess(id: String)
}

final class InappManager: NSObject {

    static let share = InappManager()
    private let iapPaymentObserver = IAPPaymentTransactionObserver()

    private override init() {
        super.init()
        iapPaymentObserver.onPaymentUpdatedTX = { [weak self] queue, transactions in
            self?.paymentQueue(queue, updatedTransactions: transactions)
        }
        iapPaymentObserver.onPaymentRestoreTxFailed = { [weak self] queue, error in
            self?.paymentQueue(queue, restoreCompletedTransactionsFailedWithError: error)
        }
        iapPaymentObserver.onPaymentRestoreTxFinished = { [weak self] queue in
            self?.paymentQueueRestoreCompletedTransactionsFinished(queue)
        }
        SKPaymentQueue.default().add(iapPaymentObserver)
        SwiftyStoreKit.shouldAddStorePaymentHandler = { (_: SKPayment, _: SKProduct) in
            return true
        }
    }

    var sharedSecret: String = ""
    var productIdentifiers: Set<ProductIdentifier> = Set()
    var listProduct = Set<SKProduct>()
    var didPaymentSuccess = BehaviorSubject<IAPState>(value: .unload)
    var productsInfo = BehaviorSubject<[SKProduct]>(value: [])
    var purchasedProduct: ProductIdentifier?
    var infoPurchaseProduct: ReceiptItem?
    private var needShowRestoreError = false
    weak var delegate: InappManagerDelegate?

    func getFreedaysTrial(id: String) -> Int {
        var freeDay = 0
        if let subcription = InappManager.share.listProduct.first(where: { $0.productIdentifier == id })?.introductoryPrice?.subscriptionPeriod {
            switch subcription.unit {
            case .day:
                freeDay = subcription.numberOfUnits
            case .week:
                freeDay = subcription.numberOfUnits * 7
            default:
                freeDay = 3
            }
        }
        return freeDay
    }

    func getPrice(id: String) -> String {
        if let subscription = InappManager.share.listProduct.first(where: {
            $0.productIdentifier == id
        }) {
            return subscription.regularPrice ?? ""
        }
        return ""
    }

    func getPriceLocale(id: String) -> Locale {
        if let subscription = InappManager.share.listProduct.first(where: {
            $0.productIdentifier == id
        }) {
            return subscription.priceLocale
        }
        return Locale.current
    }

    func getPriceNumb(id: String) -> NSDecimalNumber {
        if let subscription = InappManager.share.listProduct.first(where: {
            $0.productIdentifier == id
        }) {
            return subscription.price
        }
        return 0
    }

    func getDiscountPrice(id: String) -> String {
        if let subscription = InappManager.share.listProduct.first(where: {
            $0.productIdentifier == id
        }) {
            return subscription.introductoryPrice?.regularPrice ?? ""
        }
        return ""
    }

    func getDiscountPriceLocale(id: String) -> Locale {
        if let subscription = InappManager.share.listProduct.first(where: {
            $0.productIdentifier == id
        }) {
            return subscription.discounts.first?.priceLocale ?? Locale.current
        }
        return Locale.current
    }

    func getDiscountPriceNumb(id: String) -> NSDecimalNumber {
        if let subscription = InappManager.share.listProduct.first(where: {
            $0.productIdentifier == id
        }) {
            return subscription.discounts.first?.price ?? 0
        }
        return 0
    }

    func getIntroductoryPriceNumb(id: String) -> NSDecimalNumber {
        if let subscription = InappManager.share.listProduct.first(where: {
            $0.productIdentifier == id
        }) {
            return subscription.introductoryPrice?.price ?? 0
        }
        return 0
    }

    func getDiscountPeriod(id: String) -> TimeInterval {
        if let subscription = InappManager.share.listProduct.first(where: {
            $0.productIdentifier == id
        }) {
            let firstDiscount = subscription.discounts.first
            let periodTime = firstDiscount?.subscriptionPeriod.numberOfUnits ?? 0
            let periodUnit = firstDiscount?.subscriptionPeriod.unit
            var duration: TimeInterval = 0
            switch periodUnit {
            case .day:
                duration = TimeInterval(periodTime * 24 * 60 * 60)
            case .week:
                duration = TimeInterval(7 * periodTime * 24 * 60 * 60)
            case .month:
                duration = TimeInterval(30 * periodTime * 24 * 60 * 60)
            case .year:
                duration = TimeInterval(365 * periodTime * 24 * 60 * 60)
            default: break
            }
            return duration
        }
        return 0
    }

    func checkPurchaseProduct() {
        SwiftyStoreKit.completeTransactions(atomically: true) { [weak self] purchases in
            for purchase in purchases {
                switch purchase.transaction.transactionState {
                case .purchased, .restored:
                    self?.purchasedProduct = purchase.productId
                    if purchase.needsFinishTransaction {
                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                    }
                case .failed, .purchasing, .deferred:
                    break
                @unknown default:
                    break
                }
            }
        }
    }

    func purchaseProduct(withId id: String) {
        guard SKPaymentQueue.canMakePayments() else { return }

        if let product = listProduct.first(where: { $0.productIdentifier == id }) {
            beginPayment(for: product)
            return
        }

        // Product list empty (e.g. StoreKit config not wired yet) — fetch then buy.
        SVProgressHUD.show()
        _ = productInfo(id: productIdentifiers.union([id]), isShowLoading: false) { [weak self] products in
            guard let self else { return }
            if let product = products.first(where: { $0.productIdentifier == id })
                ?? self.listProduct.first(where: { $0.productIdentifier == id }) {
                self.beginPayment(for: product)
            } else {
                SVProgressHUD.dismiss()
                print("IAP: product not found for id \(id). Check App Store Connect product IDs (StoreKit .storekit is Xcode-only).")
                Utils.showToast("Product unavailable (\(id)). Check App Store Connect.")
            }
        }
    }

    private func beginPayment(for product: SKProduct) {
        SVProgressHUD.show()
        SKPaymentQueue.default().add(SKPayment(product: product))
    }

    @discardableResult
    func productInfo(id: Set<String>, isShowLoading: Bool = true,
                     completed: @escaping (Set<SKProduct>) -> Void = { _ in }) -> InAppRequest {
        if isShowLoading {
            SVProgressHUD.show()
        }
        return SwiftyStoreKit.retrieveProductsInfo(id) { [weak self] result in
            SVProgressHUD.dismiss()
            if !result.retrievedProducts.isEmpty {
                self?.listProduct = result.retrievedProducts
                self?.productsInfo.onNext(result.retrievedProducts.map { $0 })
                DispatchQueue.main.async {
                    completed(result.retrievedProducts)
                }
            } else if let invalidProductId = result.invalidProductIDs.first {
                print("Invalid product identifier: \(invalidProductId) with error: \(String(describing: result.error))")
                IAPState.iapState = .unload
                DispatchQueue.main.async {
                    completed([])
                }
            } else {
                IAPState.iapState = .unload
                print("Error: \(String(describing: result.error))")
                DispatchQueue.main.async {
                    completed([])
                }
            }
        }
    }

    func restorePurchases(isShowLoading: Bool = true) {
        if SKPaymentQueue.canMakePayments() {
            if isShowLoading {
                SVProgressHUD.show()
            }
            needShowRestoreError = isShowLoading
            SKPaymentQueue.default().restoreCompletedTransactions()
        }
    }

    @discardableResult
    func veryCheckRegisterPack(completed: @escaping () -> Void) -> InAppRequest? {
        let appleValidator = AppleReceiptValidator(service: IAPState.isDev ? .sandbox : .production, sharedSecret: sharedSecret)
        return SwiftyStoreKit.verifyReceipt(using: appleValidator, forceRefresh: true) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let receipt):
                let purchaseResult = SwiftyStoreKit.verifySubscriptions(ofType: .autoRenewable, productIds: self.productIdentifiers, inReceipt: receipt)
                switch purchaseResult {
                case .purchased(let expireddate, let items):
                    print("==> purchased expireddate \(expireddate)")
                    self.infoPurchaseProduct = items.first
                    self.purchasedProduct = items.first?.productId
                    if let productId = self.purchasedProduct,
                       let product = self.listProduct.first(where: { $0.productIdentifier == productId }) {
                        let isTrial = self.infoPurchaseProduct?.isTrialPeriod == true
                        let isIntro = self.infoPurchaseProduct?.isInIntroOfferPeriod == true
                        let isFirstPurchase = isTrial || isIntro
                        self.logCostAnalytic(value: product.price.doubleValue,
                                             currency: product.priceLocale.currencySymbol,
                                             productId: productId,
                                             renew: !isFirstPurchase)
                    }
                    IAPState.iapState = .purchased
                case .expired(let expireddate, _):
                    print("==> expireddate \(expireddate)")
                    IAPState.iapState = .expired
                case .notPurchased:
                    IAPState.iapState = .notPurchased
                }
                completed()
            case .error:
                IAPState.iapState = .notPurchased
                completed()
            }
        }
    }

    func getInfoPurchasedProduct() {
        let appleValidator = AppleReceiptValidator(service: IAPState.isDev ? .sandbox : .production, sharedSecret: sharedSecret)
        SwiftyStoreKit.verifyReceipt(using: appleValidator, forceRefresh: true) { result in
            switch result {
            case .success(let receipt):
                let purchaseResult = SwiftyStoreKit.verifySubscriptions(ofType: .autoRenewable, productIds: self.productIdentifiers, inReceipt: receipt)
                switch purchaseResult {
                case .purchased(_, let items):
                    self.infoPurchaseProduct = items.first
                default:
                    break
                }
            case .error(let error):
                print("Verify receipt failed: \(error)")
            }
        }
    }

    func updateConversionValue(value: Int) {
        if #available(iOS 14.0, *) {
            SKAdNetwork.updateConversionValue(value)
        } else {
            print("Not support iOS version below iOS 14")
        }
    }

    private func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                SVProgressHUD.dismiss()
                purchasedProduct = transaction.payment.productIdentifier
                IAPState.iapState = .purchased
                SKPaymentQueue.default().finishTransaction(transaction)
            case .failed:
                print("Purchased Failed")
                SVProgressHUD.dismiss()
                SKPaymentQueue.default().finishTransaction(transaction)
            default:
                break
            }
        }
    }

    private func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        if needShowRestoreError {
            Utils.showToast(error.localizedDescription)
        }
        SVProgressHUD.dismiss()
    }

    private func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        let appleValidator = AppleReceiptValidator(service: IAPState.isDev ? .sandbox : .production, sharedSecret: sharedSecret)
        SwiftyStoreKit.verifyReceipt(using: appleValidator) { [weak self] result in
            SVProgressHUD.dismiss()
            guard let self = self else { return }
            switch result {
            case .success(let receipt):
                let purchaseResult = SwiftyStoreKit.verifySubscriptions(ofType: .autoRenewable,
                                                                        productIds: self.productIdentifiers,
                                                                        inReceipt: receipt)
                switch purchaseResult {
                case .purchased(_, let items):
                    self.infoPurchaseProduct = items.first
                    self.purchasedProduct = items.first?.productId
                    if let productId = self.purchasedProduct,
                       let product = self.listProduct.first(where: { $0.productIdentifier == productId }) {
                        let isTrial = self.infoPurchaseProduct?.isTrialPeriod == true
                        let isIntro = self.infoPurchaseProduct?.isInIntroOfferPeriod == true
                        let isFirstPurchase = isTrial || isIntro
                        self.logCostAnalytic(value: product.price.doubleValue,
                                             currency: product.priceLocale.currencySymbol,
                                             productId: productId,
                                             renew: !isFirstPurchase)
                    }
                    IAPState.iapState = .purchased
                    self.delegate?.purchaseSuccess(id: self.purchasedProduct ?? "")
                case .expired(_, _):
                    IAPState.iapState = .expired
                case .notPurchased:
                    IAPState.iapState = .notPurchased
                }
            case .error(let error):
                print("verify failed \(error.localizedDescription)")
            }
        }

        for transaction in queue.transactions {
            SKPaymentQueue.default().finishTransaction(transaction)
        }
    }

    private func logCostAnalytic(value: Double, currency: String?, productId: String, renew: Bool) {
        FirebaseEventManager.logEvent(with: "iap_sdk",
                                      params: ["value": "\(value)",
                                               "currency": "\(currency ?? "")",
                                               "product_id": productId,
                                               "renew": "\(renew)"])
    }
}

private class IAPPaymentTransactionObserver: NSObject, SKPaymentTransactionObserver {
    var onPaymentUpdatedTX: ((_ queue: SKPaymentQueue, _ transactions: [SKPaymentTransaction]) -> Void)?
    var onPaymentRestoreTxFailed: ((_ queue: SKPaymentQueue, _ error: Error) -> Void)?
    var onPaymentRestoreTxFinished: ((_ queue: SKPaymentQueue) -> Void)?

    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        onPaymentUpdatedTX?(queue, transactions)
    }

    func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        onPaymentRestoreTxFailed?(queue, error)
    }

    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        onPaymentRestoreTxFinished?(queue)
    }
}

enum Utils {
    static func showToast(_ message: String, on view: UIView? = nil) {
        DispatchQueue.main.async {
            let top = view ?? UIApplication.shared.windows.first(where: { $0.isKeyWindow })
            guard let top = top else { return }
            let label = UILabel()
            label.text = message
            label.textColor = .white
            label.backgroundColor = UIColor.black.withAlphaComponent(0.75)
            label.textAlignment = .center
            label.numberOfLines = 0
            label.font = .systemFont(ofSize: 14)
            label.layer.cornerRadius = 8
            label.clipsToBounds = true
            label.translatesAutoresizingMaskIntoConstraints = false
            top.addSubview(label)
            NSLayoutConstraint.activate([
                label.centerXAnchor.constraint(equalTo: top.centerXAnchor),
                label.centerYAnchor.constraint(equalTo: top.centerYAnchor),
                label.leadingAnchor.constraint(greaterThanOrEqualTo: top.leadingAnchor, constant: 24),
                label.trailingAnchor.constraint(lessThanOrEqualTo: top.trailingAnchor, constant: -24)
            ])
            label.layoutMargins = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                label.removeFromSuperview()
            }
        }
    }
}
