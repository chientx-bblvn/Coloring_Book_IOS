//
//  SubscriptionView.swift
//  Doll-Coloring
//

import SwiftUI
import Combine
import RxSwift
import SVProgressHUD

// MARK: - Presenter (UIKit entry points)

enum SubscriptionPresenter {
    /// Holds the presented host so `onClose` can dismiss after `show` returns.
    /// (Capturing `[weak host]` during `UIHostingController(rootView:)` sees `host == nil`.)
    private final class HostBox {
        weak var controller: UIViewController?
    }

    @MainActor
    static func show(
        checkTime: Bool,
        handler: (() -> Void)? = nil,
        onClickCLose: (() -> Void)? = nil
    ) {
        let keyWindow = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap(\.windows)
            .first(where: \.isKeyWindow)
        let box = HostBox()
        _ = onClickCLose // kept for call-site API compatibility
        let host = UIHostingController(
            rootView: SubscriptionView(
                checkTime: checkTime,
                topSafeAreaInset: LayoutChrome.windowTopSafeArea,
                onClose: {
                    guard let controller = box.controller else { return }
                    if let handler {
                        controller.dismiss(animated: false) { handler() }
                    } else {
                        controller.dismiss(animated: true)
                    }
                }
            )
        )
        box.controller = host
        host.modalPresentationStyle = .overFullScreen
        host.view.backgroundColor = UIColor(hexString: AppTheme.backgroundHex)
        let root = keyWindow?.rootViewController

        if let presented = root?.presentedViewController {
            presented.present(host, animated: true)
        } else {
            root?.present(host, animated: true)
        }
    }
}

// MARK: - View

struct SubscriptionView: View {
    @StateObject private var viewModel: SubscriptionViewModel
    private let onClose: () -> Void
    private let topSafeAreaInset: CGFloat

    init(
        checkTime: Bool = false,
        topSafeAreaInset: CGFloat = 0,
        onClose: @escaping () -> Void
    ) {
        _viewModel = StateObject(wrappedValue: SubscriptionViewModel(checkTime: checkTime))
        self.topSafeAreaInset = topSafeAreaInset
        self.onClose = onClose
    }

    var body: some View {
        GeometryReader { geo in
            let bannerHeight = geo.size.height * 0.58

            ZStack(alignment: .top) {
                screenGradient
                    .ignoresSafeArea()

                // Hero image fades into the pink → white screen gradient.
                bannerPager(height: bannerHeight, width: geo.size.width)
                    .frame(height: bannerHeight)
                    .mask(
                        LinearGradient(
                            stops: [
                                .init(color: .black, location: 0),
                                .init(color: .black, location: 0.55),
                                .init(color: .black.opacity(0.55), location: 0.78),
                                .init(color: .clear, location: 1)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .ignoresSafeArea(edges: .top)
                    .allowsHitTesting(false)

                VStack(spacing: 0) {
                    Spacer(minLength: bannerHeight * 0.42)
                    bottomPanel
                }

                topChrome
                    .padding(.top, LayoutChrome.topChromePadding(reportedSafeAreaTop: topSafeAreaInset, extra: 10))
                    .zIndex(10)
            }
        }
        .onAppear {
            viewModel.onPurchaseSuccess = onClose
            viewModel.start()
        }
        .onDisappear {
            viewModel.stop()
        }
        .ignoresSafeArea(edges: .top)
    }

    private var screenGradient: some View {
        LinearGradient(
            stops: [
                .init(color: Color(hex: "FFE0EA"), location: 0),
                .init(color: Color.appBackground, location: 0.35),
                .init(color: Color(hex: "FFF6F8"), location: 0.62),
                .init(color: Color.white, location: 1)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    }

    // MARK: - Banner

    private func bannerPager(height: CGFloat, width: CGFloat) -> some View {
        let images = viewModel.bannerImages
        let index = images.isEmpty ? 0 : viewModel.bannerIndex % images.count

        return ZStack {
            if let name = images[safe: index], UIImage(named: name) != nil {
                Image(name)
                    .resizable()
                    .scaledToFill()
                    .frame(width: width, height: height)
                    .clipped()
                    .transition(.opacity)
            } else {
                Color.appPrimarySoft
            }
        }
        .frame(width: width, height: height)
        .clipped()
        .animation(.easeInOut(duration: 0.35), value: index)
    }

    // MARK: - Top chrome

    private var topChrome: some View {
        HStack {
            Spacer()

            Button(action: onClose) {
                Image(systemName: "xmark")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(Color.appText)
                    .frame(width: 32, height: 32)
                    .background(Color.white)
                    .clipShape(Circle())
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 16)
    }

    // MARK: - Bottom sheet

    private var bottomPanel: some View {
        VStack(spacing: 12) {
            Text("Create more with PRO")
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(Color.appText)
                .frame(maxWidth: .infinity, alignment: .leading)
            featuresRow
            packagesColumn

            Button {
                viewModel.subscribe()
            } label: {
                Text(viewModel.subscribeTitle)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .background(Color.appPrimary)
                    .clipShape(RoundedRectangle(cornerRadius: 26, style: .continuous))
                    .shadow(color: Color.appPrimary.opacity(0.28), radius: 8, y: 4)
            }
            .buttonStyle(.plain)

            Text("Cancel anytime")
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(Color.appTextSecondary)
                .frame(maxWidth: .infinity)

            HStack {
                footerLink(LocalizableUtils.iapPrivacyPolicy()) {
                    privacyUrl.openLink()
                }
                Spacer()
                footerLink(LocalizableUtils.iapTermOfUse()) {
                    termsUrl.openLink()
                }
                Spacer()
                footerLink("Restore") {
                    viewModel.restore()
                }
            }
            .padding(.horizontal, 8)
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
        .padding(.bottom, 8)
        .background(
            // Soft veil upward into the art — no hard white “card” cut.
            LinearGradient(
                stops: [
                    .init(color: Color.white.opacity(0), location: 0),
                    .init(color: Color(hex: "FFF6F8").opacity(0.72), location: 0.18),
                    .init(color: Color.white.opacity(0.96), location: 0.42),
                    .init(color: Color.white, location: 1)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .padding(.top, -72)
            .ignoresSafeArea(edges: .bottom)
        )
    }

    private var featuresRow: some View {
        HStack(spacing: 8) {
            featureItem(image: "img_iap_option2", symbol: "bookmark.fill", title: "Unlimited\nsaves")
            featureItem(image: "img_iap_option3", symbol: "lock.open.fill", title: "Unlock all\ndrawings")
            featureItem(image: "Paint_Palette", symbol: "paintbrush.fill", title: "All PRO\ntools")
            featureItem(image: "img_iap_option1", symbol: "speaker.slash.fill", title: "No ads")
        }
        .frame(height: 94)
    }

    private func featureItem(image: String, symbol: String, title: String) -> some View {
        VStack(spacing: 6) {
            Group {
                if UIImage(named: image) != nil {
                    Image(image)
                        .resizable()
                        .scaledToFit()
                } else {
                    Image(systemName: symbol)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(Color.appPrimary)
                }
            }
            .frame(width: 36, height: 36)
            .padding(.top, 4)

            Text(title)
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(Color.appText)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .minimumScaleFactor(0.85)
                .padding(.horizontal, 4)
                .padding(.bottom, 6)

            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.appPrimarySoft)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    private var packagesColumn: some View {
        VStack(spacing: 12) {
            if viewModel.showYearly {
                packageCard(
                    title: "Yearly",
                    subtitle: viewModel.yearlySaveSubtitle,
                    price: viewModel.yearlyPrice,
                    billingPeriod: "per year",
                    type: .yearly,
                    cornerBadge: "BEST VALUE"
                )
            }
            if viewModel.showMonthly {
                packageCard(
                    title: "Monthly",
                    subtitle: viewModel.monthlySaveSubtitle,
                    price: viewModel.monthlyPrice,
                    billingPeriod: "per month",
                    type: .monthly,
                    cornerBadge: nil
                )
            }
            if viewModel.showWeekly {
                packageCard(
                    title: "Weekly",
                    subtitle: "Billed weekly",
                    price: viewModel.weeklyPrice,
                    billingPeriod: "per week",
                    type: .weekly,
                    cornerBadge: nil
                )
            }
        }
    }

    private func packageCard(
        title: String,
        subtitle: String,
        price: String,
        billingPeriod: String,
        type: IAPIdType,
        cornerBadge: String?
    ) -> some View {
        let selected = viewModel.selectedPackage == type
        return Button {
            withAnimation(.easeInOut(duration: 0.18)) {
                viewModel.select(type)
            }
        } label: {
            HStack {
                VStack(alignment: .leading, spacing: 3) {
                    Text(title)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(Color.appText)
                    Text(subtitle)
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(cornerBadge != nil || type == .monthly ? Color.appPrimary : Color.appTextSecondary)
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 3) {
                    Text(price)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(cornerBadge != nil ? Color.appPrimary : Color.appText)
                    Text(billingPeriod)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(Color.appTextSecondary)
                }
            }
            .padding(.horizontal, 18)
            .frame(height: 64)
            .background(selected ? Color.appPrimarySoft : Color.appSurface)
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .stroke(selected ? Color.appPrimary : Color.appBorder, lineWidth: selected ? 2.5 : 1.5)
            )
            .scaleEffect(selected ? 1.01 : 1)
            .overlay(alignment: .topTrailing) {
                if let cornerBadge {
                    Text("  \(cornerBadge)  ")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 4)
                        .frame(height: 20)
                        .background(Color.appPrimary)
                        .clipShape(Capsule())
                        .offset(x: -12, y: -10)
                }
            }
        }
        .buttonStyle(.plain)
    }

    private func footerLink(_ title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(Color.appText.opacity(0.8))
        }
        .buttonStyle(.plain)
    }
}

// MARK: - ViewModel

@MainActor
final class SubscriptionViewModel: ObservableObject {
    @Published var bannerIndex = 0
    @Published var selectedPackage: IAPIdType = .yearly
    @Published var weeklyPrice = "$2.99"
    @Published var yearlyPrice = "$24.99"
    @Published var yearlySaveSubtitle = "Save 84% per week"
    @Published var monthlyPrice = "$4.99"
    @Published var monthlySaveSubtitle = "Save 58% per week"
    @Published var showWeekly = true
    @Published var showYearly = true
    @Published var showMonthly = true
    @Published var subscribeTitle = LocalizableUtils.commonContinue()

    let bannerImages = BannerHome.iap.images
    var onPurchaseSuccess: (() -> Void)?

    private let checkTime: Bool
    private var iapIds: [IAPIdType] = []
    private var bannerTimer: Timer?
    private let disposeBag = DisposeBag()
    private var started = false
    private var didFinishPurchase = false

    init(checkTime: Bool) {
        self.checkTime = checkTime
    }

    func start() {
        // Already VIP — dismiss instead of showing paywall again.
        if IAPState.isUserVip {
            IAPStatusStore.shared.refresh()
            onPurchaseSuccess?()
            return
        }
        guard !started else { return }
        started = true
        FirebaseEventManager.logEvent(with: RMBGEventTracking.iapScreenViewed)
        startBannerTimer()
        loadProducts()
    }

    func stop() {
        bannerTimer?.invalidate()
        bannerTimer = nil
    }

    func select(_ type: IAPIdType) {
        selectedPackage = type
        updateSubscribeTitle()
    }

    func subscribe() {
        let productId = selectedPackage.id
        Task { @MainActor in
            SVProgressHUD.show()
            let ok = await StoreKitIAPManager.shared.purchase(productId: productId)
            await SVProgressHUD.dismiss()
            if ok {
                finishPurchaseIfNeeded()
            }
        }
    }

    func restore() {
        Task { @MainActor in
            SVProgressHUD.show()
            let ok = await StoreKitIAPManager.shared.restorePurchases()
            await SVProgressHUD.dismiss()
            if ok {
                finishPurchaseIfNeeded()
            }
        }
    }

    /// Single exit path — avoids duplicate `iap_screen_purchase_made` from IAPState / NC / Rx.
    private func finishPurchaseIfNeeded() {
        guard !didFinishPurchase, IAPState.isUserVip else { return }
        didFinishPurchase = true
        IAPStatusStore.shared.refresh()
        FirebaseEventManager.logEvent(
            with: RMBGEventTracking.iapScreenPurchase_made,
            params: ["iap_name": selectedPackage.unit]
        )
        onPurchaseSuccess?()
    }

    private func startBannerTimer() {
        bannerTimer?.invalidate()
        guard bannerImages.count > 1 else { return }
        bannerTimer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { [weak self] _ in
            Task { @MainActor in
                guard let self, !self.bannerImages.isEmpty else { return }
                withAnimation(.easeInOut(duration: 0.35)) {
                    self.bannerIndex = (self.bannerIndex + 1) % self.bannerImages.count
                }
            }
        }
    }

    private func loadProducts() {
        iapIds = IAPIdType.mainPackages
        applyPrices()

        SVProgressHUD.show()
        Task { @MainActor in
            await StoreKitIAPManager.shared.configure(with: Array(IAPIdType.mainProductIdentifiers))
            await SVProgressHUD.dismiss()
            iapIds = IAPIdType.mainPackages
            applyPricesFromStoreKit()
        }
    }

    private func applyPricesFromStoreKit() {
        applyPrices()
    }

    private func applyPrices() {
        // Always show all three packages on the paywall.
        showWeekly = true
        showYearly = true
        showMonthly = true

        weeklyPrice = displayPrice(for: .weekly).amount
        yearlyPrice = displayPrice(for: .yearly).amount
        monthlyPrice = displayPrice(for: .monthly).amount

        let weeklyAmount = resolvedWeeklyAmount()
        let monthlyAmount = resolvedAmount(for: .monthly, fallback: 4.99)
        let yearlyAmount = resolvedAmount(for: .yearly, fallback: 24.99)

        // Save % vs buying the same period as weekly retail.
        yearlySaveSubtitle = savePerWeekSubtitle(paid: yearlyAmount, versusWeeklyRetail: weeklyAmount * 52)
            ?? "Save 84% per week"
        monthlySaveSubtitle = savePerWeekSubtitle(paid: monthlyAmount, versusWeeklyRetail: weeklyAmount * 4)
            ?? "Save 58% per week"

        // Prefer yearly (best save) as the default selection.
        if showYearly {
            selectedPackage = .yearly
        } else if showMonthly {
            selectedPackage = .monthly
        } else if showWeekly {
            selectedPackage = .weekly
        }
        updateSubscribeTitle()
    }

    private func resolvedWeeklyAmount() -> Double {
        if let amount = StoreKitIAPManager.shared.product(for: IAPIdType.weekly.id)?.price {
            return NSDecimalNumber(decimal: amount).doubleValue
        }
        let weekly = IAPIdType.weekly
        if !weekly.price.isEmpty, weekly.priceNumb != 0 {
            return weekly.priceNumb.doubleValue
        }
        return 2.99
    }

    private func resolvedAmount(for id: IAPIdType, fallback: Double) -> Double {
        if let amount = StoreKitIAPManager.shared.product(for: id.id)?.price {
            return NSDecimalNumber(decimal: amount).doubleValue
        }
        if !id.price.isEmpty, id.priceNumb != 0 {
            return id.priceNumb.doubleValue
        }
        return fallback
    }

    private func savePerWeekSubtitle(paid: Double, versusWeeklyRetail: Double) -> String? {
        guard versusWeeklyRetail > 0, paid < versusWeeklyRetail else { return nil }
        let percent = ((versusWeeklyRetail - paid) / versusWeeklyRetail * 100).rounded()
        return "Save \(Int(percent))% per week"
    }

    private func updateSubscribeTitle() {
        let price = displayPrice(for: selectedPackage).amount
        if price.isEmpty {
            subscribeTitle = LocalizableUtils.commonContinue()
        } else {
            subscribeTitle = "Continue · \(price)"
        }
    }

    /// Prefer StoreKit 2 Product prices (works with local .storekit before ASC goes live).
    private func displayPrice(for id: IAPIdType) -> (amount: String, perWeek: String) {
        if let product = StoreKitIAPManager.shared.product(for: id.id) {
            let amount = product.displayPrice
            let value = NSDecimalNumber(decimal: product.price).doubleValue
            switch id {
            case .weekly:
                return (amount, LocalizableUtils.iapPrice_weekly(amount))
            case .monthly:
                let weekly = (value / 4).regularPrice(locale: .current) ?? ""
                return (amount, LocalizableUtils.iapPrice_weekly(weekly))
            case .yearly:
                let weekly = (value / 52).regularPrice(locale: .current) ?? ""
                return (amount, LocalizableUtils.iapPrice_weekly(weekly))
            default:
                break
            }
        }
        if !id.price.isEmpty, id.priceNumb != 0 {
            switch id {
            case .weekly:
                return (id.price, LocalizableUtils.iapPrice_weekly(id.price))
            case .monthly:
                let weekly = (id.priceNumb.doubleValue / 4).regularPrice(locale: id.priceLocale) ?? ""
                return (id.price, LocalizableUtils.iapPrice_weekly(weekly))
            case .yearly:
                let weekly = (id.priceNumb.doubleValue / 52).regularPrice(locale: id.priceLocale) ?? ""
                return (id.price, LocalizableUtils.iapPrice_weekly(weekly))
            default:
                break
            }
        }
        switch id {
        case .weekly:
            return ("$2.99", LocalizableUtils.iapPrice_weekly("$2.99"))
        case .monthly:
            return ("$4.99", LocalizableUtils.iapPrice_weekly("$1.25"))
        case .yearly:
            return ("$24.99", LocalizableUtils.iapPrice_weekly("$0.48"))
        default:
            return ("$2.99", LocalizableUtils.iapPrice_weekly("$2.99"))
        }
    }
}
