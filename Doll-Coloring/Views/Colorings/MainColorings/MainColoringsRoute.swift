//
//  MainColoringsRoute.swift
//  Doll-Coloring
//
//  Created by Việt Anh Nguyễn on 10/04/2024.
//  
//

import Foundation
import UIKit

enum MainColoringsRoute: Route {
    case main

    var screen: UIViewController {
        switch self {
        case .main:
            guard let main = R.storyboard.mainColorings.mainColoringsController() else {
              return UIViewController()
            }
            main.viewModel = MainColoringsVM()
            return main
        }
    }
}
