//
//  AppTheme.swift
//  Doll-Coloring
//
//  Single brand palette for UIKit + SwiftUI. Prefer these tokens over raw hex.
//

import UIKit
import SwiftUI

enum AppTheme {

    // MARK: - Brand tokens (hex without #)

    /// Main CTA / selected / accent — matches `MainPrimary` asset (#C13F68)
    static let primaryHex = "C13F68"
    /// Soft fill behind selected chips / packages
    static let primarySoftHex = "FFF0F4"
    /// Screen background (soft pink)
    static let backgroundHex = "FFE5EC"
    /// Primary body / title text
    static let textHex = "38263F"
    /// Secondary / inactive text & icons
    static let textSecondaryHex = "9A8FA3"
    /// Card / surface
    static let surfaceHex = "FFFFFF"
    /// Subtle stroke
    static let borderHex = "E8DFE6"

    // MARK: - UIKit

    static var primary: UIColor { UIColor(hexString: primaryHex) }
    static var primarySoft: UIColor { UIColor(hexString: primarySoftHex) }
    static var background: UIColor { UIColor(hexString: backgroundHex) }
    static var text: UIColor { UIColor(hexString: textHex) }
    static var textSecondary: UIColor { UIColor(hexString: textSecondaryHex) }
    static var surface: UIColor { UIColor(hexString: surfaceHex) }
    static var border: UIColor { UIColor(hexString: borderHex) }
    static var onPrimary: UIColor { .white }

    static var primaryShadow: UIColor {
        primary.withAlphaComponent(0.28)
    }
}

// MARK: - SwiftUI

extension Color {
    static var appPrimary: Color { Color(hex: AppTheme.primaryHex) }
    static var appPrimarySoft: Color { Color(hex: AppTheme.primarySoftHex) }
    static var appBackground: Color { Color(hex: AppTheme.backgroundHex) }
    static var appText: Color { Color(hex: AppTheme.textHex) }
    static var appTextSecondary: Color { Color(hex: AppTheme.textSecondaryHex) }
    static var appSurface: Color { Color(hex: AppTheme.surfaceHex) }
    static var appBorder: Color { Color(hex: AppTheme.borderHex) }
}
