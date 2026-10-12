//
//  SplashView.swift
//  Doll-Coloring
//

import SwiftUI
import Combine
import SDWebImage

struct SplashView: View {
    @EnvironmentObject private var navigator: AppNavigator
    @StateObject private var viewModel = SplashViewModel()

    @State private var heroAppeared = false
    @State private var logoAppeared = false
    @State private var floatUp = false

    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()

            // Soft radial glow behind hero
            Circle()
                .fill(Color.appPrimary.opacity(0.12))
                .frame(width: 340, height: 340)
                .blur(radius: 40)
                .offset(y: -40)
                .scaleEffect(heroAppeared ? 1.05 : 0.85)
                .opacity(heroAppeared ? 1 : 0)

            VStack(spacing: 0) {
                Spacer(minLength: 40)

                heroHeader
                    .padding(.horizontal, 24)

                logoBlock
                    .padding(.top, 28)

                Spacer()

                loadingBlock
                    .padding(.horizontal, 40)
                    .padding(.bottom, 48)
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .onAppear {
            withAnimation(.easeOut(duration: 0.7)) {
                heroAppeared = true
            }
            withAnimation(.easeOut(duration: 0.55).delay(0.25)) {
                logoAppeared = true
            }
            withAnimation(.easeInOut(duration: 2.4).repeatForever(autoreverses: true).delay(0.7)) {
                floatUp = true
            }
            viewModel.start { destination in
                navigator.replace(with: destination)
            }
        }
    }

    // MARK: - Hero

    private var heroHeader: some View {
        Group {
            if UIImage(named: "ic_app_splash") != nil {
                Image("ic_app_splash")
                    .resizable()
                    .scaledToFit()
            } else if UIImage(named: "ic_app_intro") != nil {
                Image("ic_app_intro")
                    .resizable()
                    .scaledToFit()
            } else {
                Image(systemName: "paintpalette.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(Color.appPrimary)
                    .padding(36)
            }
        }
        .frame(width: 160, height: 160)
        .clipShape(RoundedRectangle(cornerRadius: 36, style: .continuous))
        .shadow(color: Color.appPrimary.opacity(0.22), radius: 24, y: 14)
        .overlay(
            RoundedRectangle(cornerRadius: 36, style: .continuous)
                .stroke(Color.white.opacity(0.65), lineWidth: 2)
        )
        .scaleEffect(heroAppeared ? 1 : 0.88)
        .opacity(heroAppeared ? 1 : 0)
        .offset(y: floatUp ? -10 : 8)
        .rotationEffect(.degrees(floatUp ? -1.2 : 1.2))
    }

    private var logoBlock: some View {
        VStack(spacing: 8) {
            if UIImage(named: "crayo_logo") != nil {
                Image("crayo_logo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 54)
            } else {
                Text(appDisplayName)
                    .font(.system(size: 28, weight: .heavy, design: .rounded))
                    .foregroundStyle(Color.appText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
            }
            Text(appSubtitle)
                .font(.system(size: 13, weight: .medium, design: .rounded))
                .foregroundStyle(Color.appTextSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
        }
        .opacity(logoAppeared ? 1 : 0)
        .offset(y: logoAppeared ? 0 : 12)
    }

    // MARK: - Loading

    private var loadingBlock: some View {
        VStack(spacing: 10) {
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color.appPrimary.opacity(0.15))
                    Capsule()
                        .fill(
                            LinearGradient(
                                colors: [Color.appPrimary.opacity(0.85), Color.appPrimary],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: max(8, geo.size.width * viewModel.progress))
                }
            }
            .frame(height: 8)

            Text(viewModel.statusText)
                .font(.system(size: 12, weight: .medium, design: .rounded))
                .foregroundStyle(Color.appTextSecondary)
        }
        .opacity(logoAppeared ? 1 : 0)
    }
}

@MainActor
final class SplashViewModel: ObservableObject {
    @Published var progress: CGFloat = 0.05
    @Published var statusText: String = "loading..."

    private var started = false
    private var didNavigate = false
    private var navigateHandler: ((NavigationDestination) -> Void)?
    private var progressTimer: Timer?

    func start(navigate: @escaping (NavigationDestination) -> Void) {
        guard !started else { return }
        started = true
        navigateHandler = navigate

        UserDefaultManager.saveInstallDateIfNeeded()
        InappManager.share.sharedSecret = sharedSecret
        FirebaseEventManager.logEvent(with: RMBGEventTracking.splashScr)

        for file in ArchiveFileLocal.allCases {
            if !FileManagerLocal.shared.checkFileExits(typeFile: file, fileName: "") {
                FileManagerLocal.shared.createFolderManager(fileName: file.rawValue)
            }
        }

        setProgress(0.15, status: "loading...")

        // Hard timeout — never leave the user stuck on splash.
        DispatchQueue.main.asyncAfter(deadline: .now() + 6) { [weak self] in
            self?.finishIfNeeded(reason: "timeout")
        }

        // Soft crawl while network work runs.
        startSoftProgressCrawl()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.45) { [weak self] in
            self?.loadConfigAndFinish()
        }
    }

    private func startSoftProgressCrawl() {
        progressTimer?.invalidate()
        progressTimer = Timer.scheduledTimer(withTimeInterval: 0.12, repeats: true) { [weak self] _ in
            Task { @MainActor in
                guard let self, !self.didNavigate else { return }
                // Creep toward 0.85 until real finish pushes to 1.
                if self.progress < 0.85 {
                    withAnimation(.easeOut(duration: 0.2)) {
                        self.progress = min(0.85, self.progress + 0.012)
                    }
                }
            }
        }
    }

    private func setProgress(_ value: CGFloat, status: String) {
        statusText = status
        withAnimation(.easeInOut(duration: 0.35)) {
            progress = max(progress, value)
        }
    }

    private func loadConfigAndFinish() {
        setProgress(0.35, status: "loading...")
        RemoteConfigManager.shared.fetchConfig { [weak self] _ in
            DispatchQueue.main.async {
                guard let self else { return }
                UserDefaultManager.currentAccessNumberClick = 0
                UserDefaultManager.currentAccessABTestFillColoring = false
                UserDefaultManager.currentAccessABShowIAPColoring = true
                UserDefaultManager.currentAccessAB_is_free_trial_US = false

                ColoringCDN.applyRemoteOverride(
                    baseURL: RemoteConfigManager.shared.string(forKey: KeyRemoteConfig.ApiBaseURL),
                    imageURL: RemoteConfigManager.shared.string(forKey: KeyRemoteConfig.ApiURLImage),
                    accessKey: RemoteConfigManager.shared.string(forKey: KeyRemoteConfig.APIAccessKey)
                )

                UserDefaultManager.currentTimeCountdown = RemoteConfigManager.shared.number(forKey: KeyRemoteConfig.TimeCountdowntSale)
                if UserDefaultManager.countdownEndTime == nil {
                    UserDefaultManager.setupCountdownTimer(
                        duration: RemoteConfigManager.shared.number(forKey: KeyRemoteConfig.TimeCountdowntSale)
                    )
                }
                UserDefaultManager.currentAccessDisableSale = RemoteConfigManager.shared.bool(forKey: KeyRemoteConfig.IsDisableSale)
                SDWebImageDownloader.shared.setValue(apiAccessKey, forHTTPHeaderField: "AccessKey")

                self.setProgress(0.55, status: "loading...")
                self.configIAPThenFinish()
            }
        }
    }

    private func configIAPThenFinish() {
        // StoreKit 2 (same as KeyBoard_IOS) — works with CrayoProducts.storekit before ASC review.
        InappManager.share.productIdentifiers = IAPIdType.mainProductIdentifiers
        StoreKitIAPManager.shared.startAtLaunch()

        var iapFinished = false
        let done: () -> Void = { [weak self] in
            guard !iapFinished else { return }
            iapFinished = true
            self?.finishIfNeeded(reason: "iap")
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            done()
        }

        Task { @MainActor in
            await StoreKitIAPManager.shared.configure(with: Array(IAPIdType.mainProductIdentifiers))
            if StoreKitIAPManager.shared.products.isEmpty {
                // Fallback to legacy SwiftyStoreKit if StoreKit 2 returns nothing.
                _ = InappManager.share.productInfo(id: InappManager.share.productIdentifiers, isShowLoading: false) { listProduct in
                    if listProduct.isEmpty {
                        IAPState.iapState = .unload
                    } else {
                        InappManager.share.checkPurchaseProduct()
                    }
                    done()
                }
            } else {
                await StoreKitIAPManager.shared.updateSubscriptionStatus()
                IAPStatusStore.shared.refresh()
                done()
            }
        }
    }

    private func finishIfNeeded(reason: String) {
        guard !didNavigate else { return }
        didNavigate = true
        progressTimer?.invalidate()
        progressTimer = nil
        setProgress(1, status: "loading...")
        BBLLogging.d("Splash finish via \(reason)")
        let destination = nextDestination()
        // Brief beat so the bar can reach 100% before transition.
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) { [weak self] in
            self?.navigateHandler?(destination)
            self?.navigateHandler = nil
        }
    }

    private func nextDestination() -> NavigationDestination {
        let languageKey = UserDefaults.standard.string(forKey: UserDefault.languageKey.rawValue) ?? ""
        if languageKey.isEmpty {
            Constants.currentLanguage = .english
            UserDefaults.standard.set(Language.english.key, forKey: UserDefault.languageKey.rawValue)
        } else {
            Constants.currentLanguage = Language(key: languageKey)
        }
        // Intro is skipped — persist first-open date here so daily gift / day counters work.
        if UserDefaultManager.currentDateFirstOpenApp == nil {
            UserDefaultManager.currentDateFirstOpenApp = Date().toMyString(format: "dd/MM/yyyy")
        }
        UserDefaults.standard.set(true, forKey: UserDefault.showedIntro.rawValue)
        return .home
    }
}
