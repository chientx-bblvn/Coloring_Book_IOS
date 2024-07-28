//
//  SplashRoute.swift
// Doll-Coloring
//
//  Created by BBLabs on 06/07/2023.
//

import UIKit

enum LanguageRoute: Route {
    case language(gofrom: LanguageGoFrom, currentLanguage: Language? = nil)
    case languageSecond(gofrom: LanguageGoFrom)
}

extension LanguageRoute {
    var screen: UIViewController {
        switch self {
        case let .language(gofrom, currentLanguage):
            let languageController = LanguageController.loadController()
            languageController.goFrom = gofrom
            languageController.currentLanguage = currentLanguage
            return languageController
        case let .languageSecond(gofrom):
            let vc = LanguageSecondViewController.loadController()
            vc.goFrom = gofrom
            return vc
        }
    }
}
