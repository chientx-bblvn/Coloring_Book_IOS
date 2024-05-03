//
//  SplashRoute.swift
// Doll-Coloring
//
//  Created by BBLabs on 06/07/2023.
//

import UIKit

enum LanguageRoute: Route {
    case language(gofrom: LanguageGoFrom)
}

extension LanguageRoute {
    var screen: UIViewController {
        switch self {
        case let .language(gofrom):
            let languageController = LanguageController.loadController()
            languageController.goFrom = gofrom
            return languageController
        }
    }
}
