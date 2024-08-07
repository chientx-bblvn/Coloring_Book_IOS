//
//  UserDefaultManager.swift
//  EmojiMixer-iOS
//
//  Created by PrankSound on 04/03/2024.
//  Copyright © 2024 Ongaeshi. All rights reserved.
//

import Foundation



class UserDefaultManager {
    static var disableMusicBackground: Bool {
        if let isDisable = UserDefaultManager.currentAccessDisableMusicBackground {
            return isDisable
        } else {
            return false
        }
    }
    
    static var currentAccessDisableMusicBackground: Bool? {
        get {
            let isOn = UserDefaults.standard.bool(forKey: UserDefault.musicBackgoundDisable.rawValue)
                return isOn
            
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefault.musicBackgoundDisable.rawValue)
            UserDefaults.standard.synchronize()
        }
    }
    
    static var disableSound: Bool {
        if let isShow = UserDefaultManager.currentAccessDisableSound {
            return isShow
        } else {
           return false
        }
    }
    
    static var currentAccessDisableSound: Bool? {
        get {
            let isShow = UserDefaults.standard.bool(forKey: UserDefault.soundDisable.rawValue)
            return isShow
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefault.soundDisable.rawValue)
            UserDefaults.standard.synchronize()
        }
    }
    
    static var numberClickItemAllTopic: Int {
        if let isShow = UserDefaultManager.currentAccessNumberClick {
            return isShow
        } else {
           return 1
        }
    }
    
    static var currentAccessNumberClick: Int? {
        get {
            let isShow = UserDefaults.standard.integer(forKey: UserDefault.NumberClickItemAllTopic.rawValue)
            return isShow
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefault.NumberClickItemAllTopic.rawValue)
            UserDefaults.standard.synchronize()
        }
    }
    
    static var ABTestFillColoring: Bool {
        if let isShow = UserDefaultManager.currentAccessABTestFillColoring {
            return isShow
        } else {
           return false
        }
    }
    
    static var currentAccessABTestFillColoring: Bool? {
        get {
            let isShow = UserDefaults.standard.bool(forKey: UserDefault.fill_coloring.rawValue)
            return isShow
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefault.fill_coloring.rawValue)
            UserDefaults.standard.synchronize()
        }
    }
    
    static var ABShowIAPColoring: Bool {
        if let isShow = UserDefaultManager.currentAccessABShowIAPColoring {
            return isShow
        } else {
           return false
        }
    }
    
    static var currentAccessABShowIAPColoring: Bool? {
        get {
            let isShow = UserDefaults.standard.bool(forKey: UserDefault.state_show_iap.rawValue)
            return isShow
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefault.state_show_iap.rawValue)
            UserDefaults.standard.synchronize()
        }
    }
    
    static var ABis_free_trial_us: Bool {
        if let isShow = UserDefaultManager.currentAccessAB_is_free_trial_US {
            return isShow
        } else {
           return false
        }
    }
    
    static var currentAccessAB_is_free_trial_US: Bool? {
        get {
            let isShow = UserDefaults.standard.bool(forKey: UserDefault.is_free_trial_US.rawValue)
            return isShow
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefault.is_free_trial_US.rawValue)
            UserDefaults.standard.synchronize()
        }
    }
    
    static var dateFirstOpenApp: String {
        if let isDate = currentDateFirstOpenApp {
            return isDate
        } else {
            return Date().toMyString(format: "dd/MM/yyyy")
        }
    }
    
    static var currentDateFirstOpenApp: String? {
        get {
            let isDate = UserDefaults.standard.string(forKey: UserDefault.date_first_open_app.rawValue)
            return isDate
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefault.date_first_open_app.rawValue)
            UserDefaults.standard.synchronize()
        }
    }
}
