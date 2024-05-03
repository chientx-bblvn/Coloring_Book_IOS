//
//  SplashRoute.swift
// Doll-Coloring
//
//  Created by BBLabs on 06/07/2023.
//

import UIKit

enum IntroRoute: Route {
    case intro
}

extension IntroRoute {
    var screen: UIViewController {
        switch self {
        case .intro:
            return IntroController.loadController()
        }
    }
}
