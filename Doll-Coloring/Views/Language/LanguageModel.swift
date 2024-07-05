//
//  LanguageModel.swift
//  Doll-Coloring
//
//  Created by BBLabs on 12/08/2023.
//  Copyright ©2023. All rights reserved.
//

import UIKit

enum Language: Int, CaseIterable {
    case english
    case brazil
    case hindi
    case french
    case german
    case spanish
    case japanese
    case portuguese
    case korean
    case rusia
    case vietnam
    
    
    init(key: String) {
        switch key {
        case "en": self = .english
        case "ja": self = .japanese
        case "pt-BR": self = .brazil
        case "hi": self = .hindi
        case "de": self = .german
        case "fr": self = .french
        case "ru": self = .rusia
        case "es": self = .spanish
        case "ko": self = .korean
        case "vi": self = .vietnam
        case "p": self = .portuguese
        default: self = .english
        }
    }
    
    var key: String {
        switch self {
        case .english:
            return "en"
        case .hindi:
            return "hi"
        case .spanish:
            return "es"
        case .french:
            return "fr"
        case .portuguese:
            return "pt-BR"
        case .brazil:
            return "pt-BR"
        case .japanese:
            return "ja"
        case .korean:
            return "ko"
        case .vietnam:
            return "vi"
        case .german:
            return "de"
        case .rusia:
            return "ru"
        }
    }
    
    var name: String {
        switch self {
        case .japanese: return LocalizableUtils.languageJapanese()
        case .english:  return LocalizableUtils.languageEnglish()
        case .brazil:  return LocalizableUtils.languageBrazil()
        case .hindi:  return LocalizableUtils.languageHindi()
        case .german:  return LocalizableUtils.languageGermany()
        case .french:  return LocalizableUtils.languageFrench()
        case .rusia:  return LocalizableUtils.languageRusia()
        case .spanish:  return LocalizableUtils.languageSpanish()
        case .korean:  return LocalizableUtils.languageKorean()
        case .portuguese: return LocalizableUtils.languagePortuguese()
        case .vietnam: return LocalizableUtils.languageVietnam()
        }
    }
    
    var icon: UIImage? {
        switch self {
        case .japanese:
            return R.image.jP()
        case .english:
            return R.image.uS()
        case .brazil:
            return R.image.bR()
        case .hindi:
            return R.image.iN()
        case .german:
            return R.image.dE()
        case .french:
            return R.image.fR()
        case .rusia:
            return R.image.rU()
        case .spanish:
            return R.image.eS()
        case .korean:
            return R.image.kR()
        case .portuguese:
           return R.image.pT()
        case .vietnam:
            return R.image.vN()
        }
    }
    
    var locale: Locale {
        switch self {
        case .japanese:
            return Locale.init(identifier: "ja_JP")
        case .english:
            return Locale.init(identifier: "en_US")
        case .brazil:
            return Locale.init(identifier: "pt_BR")
        case .hindi:
            return Locale.init(identifier: "mr_IN")
        case .german:
            return Locale.init(identifier: "de_DE")
        case .french:
            return Locale.init(identifier: "fr_FR")
        case .rusia:
            return Locale.init(identifier: "ru_RU")
        case .spanish:
            return Locale.init(identifier: "es_ES")
        case .korean:
            return Locale.init(identifier: "ko_KR")
        case .portuguese:
            return Locale.init(identifier: "pt_BR")
        case .vietnam:
            return Locale.init(identifier: "ko_VN")
        }
    }
    
}
