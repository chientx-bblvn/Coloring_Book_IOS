//
//  CrayoLogoHeader.swift
//  Doll-Coloring
//

import SwiftUI

/// Shared Crayo wordmark header used on Home / Collections / Settings.
struct CrayoLogoHeader: View {
    private let logoHeight: CGFloat
    private let centered: Bool
    private let trailing: AnyView?

    /// Standard tab header: Crayo logo + yellow PRO pill (Home style).
    static func tabBar(onProTap: @escaping () -> Void) -> some View {
        let height: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 64 : 54
        return CrayoLogoHeader(logoHeight: height) {
            CrayoProHeaderButton(action: onProTap)
        }
    }

    /// Logo leading + trailing actions (Home / Collections / Settings).
    init<Trailing: View>(logoHeight: CGFloat = 40, @ViewBuilder trailing: () -> Trailing) {
        self.logoHeight = logoHeight
        self.centered = false
        self.trailing = AnyView(trailing())
    }

    /// Centered logo bar (legacy / special screens).
    init(centeredLogoHeight: CGFloat = 48) {
        self.logoHeight = centeredLogoHeight
        self.centered = true
        self.trailing = nil
    }

    var body: some View {
        Group {
            if centered {
                HStack {
                    Spacer(minLength: 0)
                    logo
                    Spacer(minLength: 0)
                }
                .padding(.horizontal, 20)
                .padding(.top, headerTopPadding(base: 10))
                .padding(.bottom, 12)
            } else {
                HStack(spacing: 12) {
                    logo
                    Spacer(minLength: 8)
                    if let trailing {
                        trailing
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, headerTopPadding(base: 8))
                .padding(.bottom, 12)
            }
        }
        .background(Color.appBackground)
    }

    /// iPad status bar often isn't reflected in SwiftUI safe area — keep PRO / logo clear.
    private func headerTopPadding(base: CGFloat) -> CGFloat {
        guard UIDevice.current.userInterfaceIdiom == .pad else { return base }
        return base + 12
    }

    private var logo: some View {
        Image("crayo_logo")
            .resizable()
            .scaledToFit()
            .frame(height: logoHeight)
            .saturation(1.16)
            .contrast(1.08)
            .shadow(color: Color(hex: "6B3B58").opacity(0.16), radius: 1.5, y: 1)
            .accessibilityLabel("Crayo")
    }
}

/// Yellow PRO capsule — same control on every main tab. Hidden after purchase.
struct CrayoProHeaderButton: View {
    var action: () -> Void
    @ObservedObject private var iap = IAPStatusStore.shared

    var body: some View {
        if !iap.isVip {
            Button(action: action) {
                HStack(spacing: 6) {
                    Image("premium_crown_sticker")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 22, height: 22)
                    Text("PRO")
                        .font(.system(
                            size: UIDevice.current.userInterfaceIdiom == .pad ? 15 : 13,
                            weight: .heavy,
                            design: .rounded
                        ))
                        .tracking(0.5)
                        .foregroundStyle(Color.appText)
                }
                .padding(.horizontal, UIDevice.current.userInterfaceIdiom == .pad ? 16 : 12)
                .frame(height: UIDevice.current.userInterfaceIdiom == .pad ? 44 : 38)
                .background(
                    LinearGradient(
                        colors: [Color(hex: "FFF4C7"), Color(hex: "FFD95A")],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .clipShape(Capsule())
                .overlay(Capsule().stroke(Color(hex: "4A1547").opacity(0.24), lineWidth: 1.2))
                .shadow(color: Color(hex: "C18A12").opacity(0.20), radius: 5, y: 2)
            }
            .buttonStyle(.plain)
            .accessibilityLabel("PRO membership")
            .transition(.opacity.combined(with: .scale(scale: 0.9)))
        }
    }
}
