//
//  HomeRoute.swift
//  Doll-Coloring
//
//  Created by Việt Anh Nguyễn on 08/04/2024.
//  
//

import Foundation
import UIKit

enum HomeRoute: Route {
    case main
    case showCombackTomorrow

    var screen: UIViewController {
        switch self {
        case .main:
            guard let main = R.storyboard.home.homeController() else {
              return UIViewController()
            }
            main.viewModel = HomeVM()
            return main
        case .showCombackTomorrow:
            let vc = PopupTomorrowViewController.loadController()
            return vc
        }
    }
}
