//
//  SettingsView.swift
//  Doll-Coloring
//

import SwiftUI
import StoreKit

struct SettingsView: View {
    @EnvironmentObject private var navigator: AppNavigator
    @ObservedObject private var iap = IAPStatusStore.shared
    @State private var soundBrushOn = !UserDefaultManager.disableSound

    var body: some View {
        VStack(spacing: 0) {
            CrayoLogoHeader.tabBar {
                SubcriptionViewController.show(checkTime: true, handler: {}, onClickCLose: {})
            }

            ScrollView {
                VStack(spacing: 16) {
                    if !iap.isVip {
                        premiumBanner
                    }

                    soundBrushRow

                    settingsRow(title: LocalizableUtils.commonLanguage(), icon: "globe") {
                        navigator.push(.settingsLanguage)
                    }
                    settingsRow(title: LocalizableUtils.settingRateApp(), icon: "star.fill") {
                        if #available(iOS 14.0, *) {
                            if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                                SKStoreReviewController.requestReview(in: scene)
                            }
                        }
                    }
                    settingsRow(title: LocalizableUtils.settingPolicy(), icon: "doc.text") {
                        privacyUrl.openLink()
                    }
                    settingsRow(title: LocalizableUtils.settingShareApp(), icon: "square.and.arrow.up") {
                        shareApp()
                    }
                    settingsRow(title: LocalizableUtils.settingFeedBack(), icon: "envelope") {
                        if let top = UIApplication.topViewController() {
                            top.sendMail(email: "dental.taydo@gmail.com")
                        }
                    }
                }
                .padding(16)
                .padding(.bottom, 24)
            }
        }
        .background(Color.appBackground.ignoresSafeArea())
        .onAppear {
            soundBrushOn = !UserDefaultManager.disableSound
        }
    }

    private var soundBrushRow: some View {
        HStack {
            Image(systemName: "speaker.wave.2.fill")
                .foregroundStyle(Color.appPrimary)
                .frame(width: 28)
            Text(LocalizableUtils.commonSoundBrush())
                .font(.system(size: 17, weight: .medium))
                .foregroundStyle(Color.appText)
            Spacer()
            Toggle("", isOn: $soundBrushOn)
                .labelsHidden()
                .tint(Color.appPrimary)
                .onChange(of: soundBrushOn) { isOn in
                    UserDefaultManager.currentAccessDisableSound = !isOn
                }
        }
        .padding(16)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(Color.black.opacity(0.08), lineWidth: 1)
        )
    }

    private func settingsRow(title: String, icon: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .foregroundStyle(Color.appPrimary)
                    .frame(width: 28)
                Text(title)
                    .font(.system(size: 17, weight: .medium))
                    .foregroundStyle(Color.appText)
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundStyle(Color.black.opacity(0.3))
            }
            .padding(16)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(Color.black.opacity(0.08), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }

    private var premiumBanner: some View {
        Button {
            SubcriptionViewController.show(checkTime: true, handler: {}, onClickCLose: {})
        } label: {
            ZStack(alignment: .leading) {
                GeometryReader { geometry in
                    Image("settings_iap_banner")
                        .resizable()
                        .scaledToFill()
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .clipped()
                }

                VStack(alignment: .leading, spacing: 6) {
                    Label("Crayo Premium", systemImage: "crown.fill")
                        .font(.system(size: 17, weight: .bold, design: .rounded))
                        .foregroundStyle(Color.appText)

                    Text("Unlock all coloring pages")
                        .font(.system(size: 12, weight: .medium, design: .rounded))
                        .foregroundStyle(Color.appTextSecondary)

                    Text("Explore Premium  ›")
                        .font(.system(size: 12, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.appPrimary)
                        .clipShape(Capsule())
                }
                .padding(.leading, 18)
                .padding(.vertical, 12)
            }
            .frame(height: 120)
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .stroke(Color.white.opacity(0.9), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Crayo Premium. Unlock all coloring pages.")
    }

    private func shareApp() {
        guard let url = URL(string: appStoreURL),
              let top = UIApplication.topViewController() else { return }
        let vc = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        if let pop = vc.popoverPresentationController {
            pop.sourceView = top.view
        }
        top.present(vc, animated: true)
    }
}
