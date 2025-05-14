//
//  Utilities.swift
//  BBLabs.
//
//  Created by BBLabs on 3/12/18.
//  Copyright © 2018 BBLabs.All rights reserved.
//

import Foundation
import KeychainAccess
import AdmobSDK

func isNetworkConnected() -> Bool {
    return (UIApplication.shared.delegate as? AppDelegate)?.isConnected() ?? false
}

// swiftlint:disable identifier_name
var LocalizableUtils = R.string(locale: Constants.currentLanguage.locale).localizable(preferredLanguages: [Constants.currentLanguage.key])
var ErrorUtils = R.string(locale: Constants.currentLanguage.locale).errorCode(preferredLanguages: [Constants.currentLanguage.key])
// swiftlint:enable identifier_name

enum UserDefault: String {
    case languageKey = "LANGUAGE_KEY"
    case showedIntro = "showedIntro"
    case musicBackgoundDisable = "MUSIC_BACKGOUND_DISABLE"
    case soundDisable = "SOUND_DISABLE"
    case NumberClickItemAllTopic = "number_click_item_all_topic"
    case fill_coloring = "fill_coloring"
    case state_show_iap = "state_show_iap"
    case is_free_trial_US = "is_free_trial_US"
    case date_first_open_app = "date_first_open_app"
    case time_countdownt_sale = "time_countdownt_sale"
    case countdown_end_time = "countdown_end_time"
    case is_disable_sale = "is_disable_sale"
    case date_first_install_app = "date_first_install_app"
}

enum KeyChainKey: String, CaseIterable {
    case uuid = "com.bblabs.rmvbg.uuid"
}

enum RMBGRemoteConfig: String, KeyRemote {
    
    // Application function
    case autoPurchase = "auto_purchase"
    
    case timeShowIconCloseIap = "time_show_icon_close_iap"
    case alphaLanguageColor = "alpha_language_color"
    
    // Version Update
    case dataConfigUpdate = "data_config_update"
    
    // Consent UMP
    case needAcceptConsent = "need_accept_consent"
    case needShowConsent = "need_show_consent"
    
    var key: String {
        return self.rawValue
    }
}

struct Constants {
    
    static let deviceId = DeviceInfos.getUUID()
    
    static let errorCodeTable = "ErrorCode"
    static var currentLanguage: Language = .english {
        didSet {
            LocalizableUtils = R.string(locale: currentLanguage.locale).localizable(preferredLanguages: [Constants.currentLanguage.key])
            ErrorUtils = R.string(locale: currentLanguage.locale).errorCode(preferredLanguages: [Constants.currentLanguage.key])
        }
    }
}
