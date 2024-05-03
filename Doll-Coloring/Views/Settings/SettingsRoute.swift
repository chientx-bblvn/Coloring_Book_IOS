//
//  SettingsRoute.swift
//  Doll-Coloring
//
//  Created by Việt Anh Nguyễn on 10/04/2024.
//  
//

import Foundation
import UIKit

enum SettingsRoute: Route {
    case main

    var screen: UIViewController {
        switch self {
        case .main:
            guard let main = R.storyboard.settings.settingsController() else {
              return UIViewController()
            }
            main.viewModel = SettingsVM()
            return main
        }
    }
}
