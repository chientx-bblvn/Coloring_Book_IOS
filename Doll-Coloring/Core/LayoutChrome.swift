//
//  LayoutChrome.swift
//  Doll-Coloring
//
//  iPad often reports ~0 top safe area on full-bleed screens, so header
//  controls sit under the status bar. Always keep a status-bar clearance.
//

import UIKit
import SwiftUI

enum LayoutChrome {
    /// Status-bar / notch clearance when the system safe-area top is missing.
    static var minimumTopSafeArea: CGFloat {
        UIDevice.current.userInterfaceIdiom == .pad ? 24 : 20
    }

    /// Best-effort top inset from the key window / status bar.
    static var windowTopSafeArea: CGFloat {
        let scenes = UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }
        let scene = scenes.first(where: { $0.activationState == .foregroundActive }) ?? scenes.first
        let windowTop = scene?.windows.first(where: \.isKeyWindow)?.safeAreaInsets.top
            ?? scene?.windows.first?.safeAreaInsets.top
            ?? 0
        let statusBar = scene?.statusBarManager?.statusBarFrame.height ?? 0
        return max(windowTop, statusBar, minimumTopSafeArea)
    }

    /// Padding above floating top chrome (close / PRO / logo row).
    static func topChromePadding(reportedSafeAreaTop: CGFloat? = nil, extra: CGFloat = 10) -> CGFloat {
        let base = max(reportedSafeAreaTop ?? 0, windowTopSafeArea)
        return base + extra
    }
}

extension View {
    /// Extra top padding on iPad / zero-safe-area layouts so header buttons clear the status bar.
    func crayoTopChromePadding(reportedSafeAreaTop: CGFloat? = nil, extra: CGFloat = 10) -> some View {
        padding(.top, LayoutChrome.topChromePadding(reportedSafeAreaTop: reportedSafeAreaTop, extra: extra))
    }
}
