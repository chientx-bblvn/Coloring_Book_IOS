//
//  SplashRoute.swift
// Doll-Coloring
//
//  Created by BBLabs on 06/07/2023.
//

import UIKit

enum SplashRoute: Route {
    case splash
}

extension SplashRoute {
    var screen: UIViewController {
        switch self {
        case .splash:
            return SplashController.loadController()
        }
    }
}
