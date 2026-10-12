//
//  BuildEnv.swift
// Doll-Coloring
//
//  Created by BBLabs on 10/04/2023.
//  Copyright © 2024 BBLabs. All rights reserved.
//

import Foundation

/**
 * Check env config for base url request
 */
var privacyUrl: String = "https://doc-hosting.flycricket.io/crayo-coloring-book-studio-privacy-policy/87c925a9-b718-4dc5-9766-a8619975905e/privacy"
var termsUrl: String = "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/"
/// Bunny Storage catalog JSON (replaces dead ico.binarybridge.dev).
var newApiBaseURL: String = "https://storage.bunnycdn.com/bblprivate/doll-coloring/json/output.json"
var baseURLImage: String = "https://storage.bunnycdn.com/bblprivate/doll-coloring/doll-data/"
var apiAccessKey: String = "03d01bc4-2cec-4d16-92ca5d0d2ca5-3eae-4cb8"
var sharedSecret = "240a2be04f014eefb263692845d17b10"

/// Short label under the home-screen icon (iPhone truncates long names).
let appHomeScreenName: String = "Crayo"
/// Full marketing name — in-app UI, share sheets, App Store listing, etc.
let appDisplayName: String = "Crayo: Coloring Book Studio"
let appSubtitle: String = "Mandala, Relax & Paint Games"
let appStoreURL: String = "https://apps.apple.com/app/id6820407650"

let isDev = false

enum ColoringCDN {
    private static let blockedHosts = ["ico.binarybridge.dev", "b-cdn.net"]

    static func resolveImageURL(_ path: String?) -> URL? {
        guard let path = path, !path.isEmpty else { return nil }
        if path.hasPrefix("http://") || path.hasPrefix("https://") {
            guard let url = URL(string: path), let host = url.host?.lowercased() else { return nil }
            if blockedHosts.contains(where: { host == $0 || host.hasSuffix(".\($0)") }) {
                return nil
            }
            return url
        }
        let base = baseURLImage.hasSuffix("/") ? baseURLImage : baseURLImage + "/"
        let relative = path.hasPrefix("/") ? String(path.dropFirst()) : path
        return URL(string: base + relative)
    }

    static func applyRemoteOverride(baseURL: String?, imageURL: String?, accessKey: String?) {
        if let base = baseURL, !base.isEmpty,
           let host = URL(string: base)?.host?.lowercased(),
           !blockedHosts.contains(where: { host == $0 || host.hasSuffix(".\($0)") }) {
            newApiBaseURL = base
        }
        if let image = imageURL, !image.isEmpty,
           let host = URL(string: image)?.host?.lowercased(),
           !blockedHosts.contains(where: { host == $0 || host.hasSuffix(".\($0)") }) {
            baseURLImage = image
        }
        if let key = accessKey, !key.isEmpty {
            apiAccessKey = key
        }
    }
}

enum IAPIdType: String, Decodable, CaseIterable, IAPType {
    /// App Store Connect product IDs (must match ASC exactly).
    case weekly = "crayo_weekly_2.99"
    case monthly = "crayo_monthly_4.99"
    case yearly = "crayo_yearly_24.99"
    case monthlySale = "monthly.sub_1.49"

    /// The three packages shown on the main IAP screen.
    static let mainPackages: [IAPIdType] = [.yearly, .monthly, .weekly]

    static var mainProductIdentifiers: Set<String> {
        Set(mainPackages.map(\.rawValue))
    }

    var title: String {
        switch self {
        case .weekly:
            return LocalizableUtils.iapWeekly()
        case .yearly:
            return LocalizableUtils.iapYearly()
        case .monthly:
            return LocalizableUtils.iapMonthly()
        case .monthlySale:
            return LocalizableUtils.iapMonthly()
        }
    }

    var numberDay: Int {
        switch self {
        case .weekly:
            return 7
        case .yearly:
            return 365
        case .monthly, .monthlySale:
            return 30
        }
    }

    var unit: String {
        switch self {
        case .weekly:
            return LocalizableUtils.iapWeek()
        case .yearly:
            return LocalizableUtils.iapYear()
        case .monthly, .monthlySale:
            return LocalizableUtils.iapMonth()
        }
    }

    var id: String {
        return rawValue
    }
}

extension IAPIdType {

    static func getOption() -> [IAPIdType] {
        let ids = getIdsOption().compactMap({ IAPIdType(rawValue: $0) })
            .filter { mainPackages.contains($0) }
        if ids.isEmpty {
            return mainPackages
        }
        // Keep Yearly → Monthly → Weekly order on the paywall.
        return mainPackages.filter { ids.contains($0) }
    }
}

enum RMBGEventTracking: String, EventTracking {
    case splashScr = "splash_scr"
    case languageScr = "language_scr"
    case scrOnboard1 = "scr_onboard_1"
    case scrOnboard2 = "scr_onboard_2"
    case scrOnboard3 = "scr_onboard_3"
    case iapScreenViewed = "iap_screen_viewed"
    case iapScreenContinueClicked = "iap_screen_continue_clicked"
    case iapScreenTrialClicked = "iap_screen_trial_clicked"
    case iapScreenPurchase_made = "iap_screen_purchase_made"
    case notiSent = "noti_sent"
    case notiClick = "noti_click"
    case table_color = "table_color"
    case start_coloring = "picture_choose"
    case item_color = "item_color"
    case category_name = "category_name"
    case collection_start_coloring = "collections_start_coloring"
    case collection_detail = "collections_detail"
    case collection_detele = "collections_delete"
    case collection_save = "collections_save"
    case collection_edit = "collections_edit"
    case collection_share = "collection_share"
    case color_fill_click = "color_fill_click"
    case color_draw_click = "color_draw_click"
    case tool_click = "tool_click"
    case color_click = "color_click"
    case save_coloring_screen = "save_coloring_screen"
    case delete_coloring_screen = "delete_coloring_screen"
    case colletion_coloring_screen = "colletion_coloring_screen"
    case share_coloring_screen = "share_coloring_screen"

    var key: String { return rawValue }
}

enum KeyRemoteConfig: String, KeyRemote {
    case NumberClickItemAllTopic = "number_click_item_all_topic"
    case ABTestFillColoring = "ABTestFillColoring"
    case StateShowIAP = "state_show_iap"
    case is_free_trial_us = "is_free_trial_us"
    case APIAccessKey = "Api_Access_Key"
    case ApiBaseURL = "Api_Base_URL"
    case ApiURLImage = "URlImageKey"
    case IsDisableSale = "is_disable_sale"
    case TimeCountdowntSale = "time_countdownt_sale"
    case time_reload_collap_native = "time_reload_collap_native"

    var key: String { return self.rawValue }
}
