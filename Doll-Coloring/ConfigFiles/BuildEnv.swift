//
//  BuildEnv.swift
// Doll-Coloring
//
//  Created by BBLabs on 10/04/2023.
//  Copyright © 2024 BBLabs. All rights reserved.
//

import Foundation
import AdmobSDK

/**
 * Check env config for base url request
 */
let apiBaseUrl: String = "https://ico.binarybridge.dev"
let privacyUrl: String = "https://sites.google.com/view/suu-nguyen"
let termsUrl: String = "https://sites.google.com/view/suunguyen"
var newApiBaseURL: String = "https://storage.bunnycdn.com/bblprivate%5Cdoll-coloring%5Cjson/output.json"
var baseURLImage: String = "https://storage.bunnycdn.com/bblprivate/doll-coloring/doll-data/"
var apiAccessKey: String = "03d01bc4-2cec-4d16-92ca5d0d2ca5-3eae-4cb8"
var sharedSecret = "240a2be04f014eefb263692845d17b10"


let isDev = false

var isWarchAds: [String] = []

enum IAPIdType: String, Decodable, CaseIterable, IAPType {
    case weekly = "DollColoring_weekly"
    case monthly = "monthly.sub_2.99"
    case yearly = "yearly.sub_10.99"
    case monthlySale = "monthly.sub_1.49"
    
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
        return getIdsOption().compactMap({
            IAPIdType(rawValue: $0)
        })
    }
}
enum DollColoringAdID: String, CaseIterable, AdConfigId {
    case inter_splash = "inter_splash"
    case inter_splash_high = "inter_splash_high"
    case native_language = "native_language"
    case native_language_2nd = "native_language_2nd"
    case native_onboarding_1 = "native_onboarding_1"
    case native_onboarding_3 = "native_onboarding_3"
    case inter_after_iap = "inter_after_iap"
    case inter_main = "inter_main"
    case reward_draw = "reward_draw"
    case banner_coloring = "banner_coloring"
    case reward_save = "reward_save"
    case appopen_resume = "appopen_resume"
    case native_result = "native_result"
    case inter_back = "inter_back"
    case banner_splash = "banner_splash"
    
    var name: String { return self.rawValue }
    
    var adType: AdType {
        switch self {
        case .inter_splash:
            return .Interstitial
        case .inter_after_iap:
            return .Interstitial
        case .inter_main:
            return .Interstitial
        case .inter_back:
            return .Interstitial

        case .native_language:
            return .Native
        case .native_language_2nd:
            return .Native
        case .native_onboarding_1:
            return .Native
        case .native_onboarding_3:
            return .Native
        case .native_result:
            return .Native
        case .reward_draw:
            return .Reward
        case .reward_save:
            return .Reward

        case .banner_coloring:
            return .Banner
        case .banner_splash:
            return .Banner

        case .appopen_resume:
            return .OpenApp

        case .inter_splash_high:
            return .Interstitial
        }
    }
    
    var adId: String {
        switch self {
        case .inter_splash:
            return "ca-app-pub-3850749456614322/1686824052"
        case .native_language:
            return "ca-app-pub-3850749456614322/7314555257"
        case .native_language_2nd:
            return "ca-app-pub-3850749456614322/9749146907"
        case .native_onboarding_1:
            return "ca-app-pub-3850749456614322/8436065238"
        case .native_onboarding_3:
            return "ca-app-pub-3850749456614322/2502284109"
        case .inter_after_iap:
            return "ca-app-pub-3850749456614322/3183738554"
        case .inter_main:
            return "ca-app-pub-3850749456614322/1711677116"
        case .reward_draw:
            return "ca-app-pub-3850749456614322/6772432101"
        case .banner_coloring:
            return "ca-app-pub-3850749456614322/7687162171"
        case .reward_save:
            return "ca-app-pub-3850749456614322/4146268760"
        case .appopen_resume:
            return "ca-app-pub-3850749456614322/8684549077"
        case .native_result:
            return "ca-app-pub-3850749456614322/6827470097"
        case .inter_back:
            return "ca-app-pub-3850749456614322/4305248538"
        case .banner_splash:
            return "ca-app-pub-3850749456614322/7722821195"
        case .inter_splash_high:
            return "ca-app-pub-3850749456614322/4660494808"
        }
    }
}
enum RMBGEventTracking: String, EventTracking {
    // Splash
    case splashScr = "splash_scr"
    
    // Language
    case languageScr = "language_scr"
    
    // Onboarding
    case scrOnboard1 = "scr_onboard_1"
    case scrOnboard2 = "scr_onboard_2"
    case scrOnboard3 = "scr_onboard_3"
    
    // IAP
    case iapScreenViewed = "iap_screen_viewed"
    case iapScreenContinueClicked = "iap_screen_continue_clicked"
    case iapScreenTrialClicked = "iap_screen_trial_clicked"
    case iapScreenPurchase_made = "iap_screen_purchase_made"
    
    // Notify
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
    
    var key: String {return self.rawValue}
}
