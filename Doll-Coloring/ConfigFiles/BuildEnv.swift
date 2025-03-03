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
let privacyUrl: String = "https://sites.google.com/binarybridge.dev/suunguyen-privacy-policy/home"
let termsUrl: String = "https://sites.google.com/binarybridge.dev/terms-conditions-binary-bridge/home"
var newApiBaseURL: String = "https://storage.bunnycdn.com/bblprivate%5Cdoll-coloring%5Cjson/output.json"
var baseURLImage: String = "https://storage.bunnycdn.com/bblprivate/doll-coloring/doll-data/"
var apiAccessKey: String = "03d01bc4-2cec-4d16-92ca5d0d2ca5-3eae-4cb8"
var sharedSecret = "240a2be04f014eefb263692845d17b10"

let isDev = false

var isWarchAds: [String] = []

enum IAPIdType: String, Decodable, CaseIterable, IAPType {
    case weekly = "weekly.discount_1.99"
    case monthly = "DollColoring_Monthly"
    case yearly = "monthly.discount_7.99"
    case weeklySale = "weekly.sub_0.99"
    
    var title: String {
        switch self {
        case .weekly:
            return LocalizableUtils.iapWeekly()
        case .yearly:
            return LocalizableUtils.iapYearly()
        case .monthly:
            return LocalizableUtils.iapMonthly()
        case .weeklySale:
            return LocalizableUtils.iapWeekly()
        }
    }
    
    var numberDay: Int {
        switch self {
        case .weekly, .weeklySale:
            return 7
        case .yearly:
            return 365
        case .monthly:
            return 30
        }
    }
    
    var unit: String {
        switch self {
        case .weekly, .weeklySale:
            return LocalizableUtils.iapWeek()
        case .yearly:
            return LocalizableUtils.iapYear()
        case .monthly:
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
    case appopen_splash = "appopen_splash"
    case native_language = "native_language"
    case native_language_high = "native_language_high"
    case native_onboarding_high = "native_onboarding_high"
    case native_onboarding = "native_onboarding"
    case native_home = "native_home"
    case inter_alltopic = "inter_alltopic"
    case reward_alltopic = "reward_alltopic"
    case banner_coloring = "banner_coloring"
    case inter_save = "inter_save"
    case banner_collection = "banner_collection"
    case appopen_resume = "appopen_resume"
    case native_result = "native_result"
    case reward_save = "reward_save"
    case banner_home = "banner_home"
    case inter_back = "inter_back"
    case reward_color = "reward_color"
    case inter_color = "inter_color"
    case native_dialog = "native_dialog"
    case native_language_2nd = "native_language_2nd"
    case inter_edit_collection = "inter_edit_collection"
    case appopen_allprice = "appopen_allprice"
    case reward_dailygift = "reward_dailygift"
    case inter_dailygift = "inter_dailygift"
    case naitve_fullscreen_onboarding = "naitve_fullscreen_onboarding"
    case nativefull_afterinter = "nativefull_afterinter"
    
    var name: String { return self.rawValue }
    
    var adType: AdType {
        switch self
        {
        case .inter_splash:
            return .Interstitial
        case .appopen_splash:
            return .OpenApp
        case .native_language:
            return .Native
        case .native_language_high:
            return .Native
        case .native_onboarding_high:
            return .Native
        case .native_onboarding:
            return .Native
        case .native_home:
            return .Native
        case .inter_alltopic:
            return .Interstitial
        case .reward_alltopic:
            return .Reward
        case .banner_coloring:
            return .Banner
        case .inter_save:
            return .Interstitial
        case .banner_collection:
            return .Banner
        case .appopen_resume:
            return .OpenApp
        case .native_result:
            return .Native
        case .reward_save:
            return .Reward
        case .banner_home:
            return .Banner
        case .inter_back:
            return .Interstitial
        case .reward_color:
            return .Reward
        case .inter_color:
            return .Interstitial
        case .inter_edit_collection:
            return .Interstitial
        case .native_dialog:
            return .Native
        case .native_language_2nd:
            return .Native
        case .appopen_allprice:
            return .OpenApp
        case .reward_dailygift:
            return .Reward
        case .inter_dailygift:
            return .Interstitial
        case .naitve_fullscreen_onboarding:
            return .Native
        case .nativefull_afterinter:
            return .Native
        }
    }
    
    var adId: String {
        switch self {
        case .inter_splash:
            return "ca-app-pub-3850749456614322/7931400606"
        case .appopen_splash:
            return "ca-app-pub-3850749456614322/8346333570"
        case .native_language:
            return "ca-app-pub-3850749456614322/2112097713"
        case .native_language_high:
            return "ca-app-pub-3850749456614322/3038166573"
        case .native_onboarding_high:
            return "ca-app-pub-3850749456614322/8796532669"
        case .native_onboarding:
            return "ca-app-pub-3850749456614322/1141403928"
        case .native_home:
            return "ca-app-pub-3850749456614322/1533513213"
        case .inter_alltopic:
            return "ca-app-pub-3850749456614322/7325952838"
        case .reward_alltopic:
            return "ca-app-pub-3850749456614322/2663095192"
        case .banner_coloring:
            return "ca-app-pub-3850749456614322/9214838285"
        case .inter_save:
            return "ca-app-pub-3850749456614322/8973019537"
        case .banner_collection:
            return "ca-app-pub-3850749456614322/7392677691"
        case .appopen_resume:
            return "ca-app-pub-3850749456614322/5033774529"
        case .native_result:
            return "ca-app-pub-3850749456614322/2299115185"
        case .reward_save:
            return "ca-app-pub-3850749456614322/1262025796"
        case .banner_home:
            return "ca-app-pub-3850749456614322/9959855034"
        case .inter_back:
            return "ca-app-pub-3850749456614322/9636453221"
        case .reward_color:
            return "ca-app-pub-3850749456614322/6174562817"
        case .inter_color:
            return "ca-app-pub-3850749456614322/1161909288"
        case .inter_edit_collection:
            return "ca-app-pub-3850749456614322/6375170531"
        case .native_dialog:
            return "ca-app-pub-3850749456614322/7845820837"
        case .native_language_2nd:
            return "ca-app-pub-3850749456614322/8443377784"
        case .appopen_allprice:
            return "ca-app-pub-3850749456614322/5998498061"
        case .reward_dailygift:
            return "ca-app-pub-3850749456614322/3958607753"
        case .inter_dailygift:
            return "ca-app-pub-3850749456614322/2525535769"
        case .naitve_fullscreen_onboarding:
            return "ca-app-pub-3850749456614322/6376413141"
        case .nativefull_afterinter:
            return "ca-app-pub-3850749456614322/3767567265"
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
