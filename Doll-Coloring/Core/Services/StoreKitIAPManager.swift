//
//  StoreKitIAPManager.swift
//  Doll-Coloring
//
//  StoreKit 2 purchase path (same pattern as KeyBoard_IOS).
//  Works with Xcode StoreKit Configuration before the app is live on ASC.
//

import Foundation
import StoreKit
import UIKit
import Combine

@MainActor
final class StoreKitIAPManager: ObservableObject {
    static let shared = StoreKitIAPManager()

    @Published private(set) var products: [Product] = []
    @Published private(set) var isLoading = false
    @Published private(set) var lastErrorMessage: String?

    private var productIds: [String] = Array(IAPIdType.mainProductIdentifiers)
    private var loadingCounter = 0
    private var updatesTask: Task<Void, Never>?

    private init() {
        updatesTask = Task.detached { [weak self] in
            for await result in Transaction.updates {
                await self?.handleTransactionUpdate(result)
            }
        }
        NotificationCenter.default.addObserver(
            forName: UIApplication.willEnterForegroundNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            Task { @MainActor in
                await self?.updateSubscriptionStatus()
            }
        }
    }

    /// Call once at launch (Splash / AppDelegate).
    func startAtLaunch() {
        Task {
            await configure(with: Array(IAPIdType.mainProductIdentifiers))
        }
    }

    func configure(with ids: [String]) async {
        beginLoading()
        defer { endLoading() }
        productIds = ids
        await fetchProducts()
        await updateSubscriptionStatus()
    }

    func fetchProducts() async {
        beginLoading()
        defer { endLoading() }
        do {
            let storeProducts = try await Product.products(for: Set(productIds))
            products = storeProducts.sorted { $0.displayPrice < $1.displayPrice }
            lastErrorMessage = nil
            print("✅ StoreKit2 loaded \(storeProducts.count) products: \(storeProducts.map(\.id))")
        } catch {
            lastErrorMessage = error.localizedDescription
            print("❌ StoreKit2 fetch failed: \(error)")
        }
    }

    func product(for id: String) -> Product? {
        products.first(where: { $0.id == id })
    }

    func displayPrice(for id: String) -> String {
        product(for: id)?.displayPrice ?? ""
    }

    /// Purchase by product id (loads products first if needed).
    @discardableResult
    func purchase(productId: String) async -> Bool {
        beginLoading()
        defer { endLoading() }

        if products.isEmpty {
            await configure(with: Array(IAPIdType.mainProductIdentifiers))
        }
        guard let product = product(for: productId) else {
            lastErrorMessage = "Product unavailable (\(productId))"
            print("❌ StoreKit2 product missing: \(productId)")
            return false
        }
        return await purchase(product)
    }

    @discardableResult
    func purchase(_ product: Product) async -> Bool {
        beginLoading()
        defer { endLoading() }
        do {
            let result = try await product.purchase()
            switch result {
            case .success(let verification):
                switch verification {
                case .verified(let transaction):
                    await transaction.finish()
                    applyPurchased(productId: transaction.productID)
                    print("✅ StoreKit2 purchase OK: \(transaction.productID)")
                    return true
                case .unverified:
                    lastErrorMessage = "Purchase unverified"
                    print("⚠️ StoreKit2 purchase unverified")
                    return false
                }
            case .userCancelled:
                print("🟡 StoreKit2 user cancelled")
                return false
            case .pending:
                lastErrorMessage = "Purchase pending"
                print("⏳ StoreKit2 purchase pending")
                return false
            @unknown default:
                return false
            }
        } catch {
            lastErrorMessage = error.localizedDescription
            print("❌ StoreKit2 purchase error: \(error)")
            return false
        }
    }

    func restorePurchases() async -> Bool {
        beginLoading()
        defer { endLoading() }
        var found = false
        for await result in Transaction.currentEntitlements {
            guard case .verified(let transaction) = result else { continue }
            guard productIds.contains(transaction.productID) else { continue }
            if transaction.revocationDate != nil { continue }
            if let exp = transaction.expirationDate, exp <= Date() { continue }
            applyPurchased(productId: transaction.productID)
            found = true
            print("✅ StoreKit2 restored: \(transaction.productID)")
        }
        if !found {
            applyNotPurchased()
            print("⚠️ StoreKit2 restore: nothing found")
        }
        return found
    }

    func updateSubscriptionStatus() async {
        var activeId: String?
        var sawExpired = false
        for await result in Transaction.currentEntitlements {
            guard case .verified(let transaction) = result else { continue }
            guard productIds.contains(transaction.productID) else { continue }
            if transaction.revocationDate != nil { continue }
            if let exp = transaction.expirationDate, exp <= Date() {
                sawExpired = true
            } else {
                activeId = transaction.productID
            }
        }
        if let activeId {
            applyPurchased(productId: activeId)
        } else if sawExpired {
            IAPState.iapState = .expired
            IAPStatusStore.shared.refresh()
        } else if IAPState.iapState == .unload {
            // Keep unload until first real check finishes without products.
        } else if !IAPState.isUserVip {
            // don't wipe a locally granted VIP mid-session unless entitlements empty after purchase path
        }
    }

    // MARK: - Private

    private func handleTransactionUpdate(_ result: VerificationResult<Transaction>) async {
        switch result {
        case .verified(let transaction):
            guard productIds.contains(transaction.productID) else { return }
            await transaction.finish()
            await updateSubscriptionStatus()
        case .unverified:
            break
        }
    }

    private func applyPurchased(productId: String) {
        IAPState.iapState = .purchased
        IAPStatusStore.shared.refresh()
        NotificationCenter.default.post(name: .crayoIAPStatusDidChange, object: productId)
    }

    private func applyNotPurchased() {
        if IAPState.iapState != .purchased {
            IAPState.iapState = .notPurchased
        } else {
            // Entitlements empty after restore → clear VIP.
            IAPState.iapState = .notPurchased
        }
        IAPStatusStore.shared.refresh()
        NotificationCenter.default.post(name: .crayoIAPStatusDidChange, object: nil)
    }

    private func beginLoading() {
        loadingCounter += 1
        if !isLoading { isLoading = true }
    }

    private func endLoading() {
        loadingCounter = max(0, loadingCounter - 1)
        if loadingCounter == 0 { isLoading = false }
    }
}

extension Notification.Name {
    static let crayoIAPStatusDidChange = Notification.Name("crayoIAPStatusDidChange")
}
