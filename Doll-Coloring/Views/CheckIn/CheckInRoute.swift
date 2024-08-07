//
//  HomeRoute.swift
//  Doll-Coloring
//
//  Created by Việt Anh Nguyễn on 08/04/2024.
//
//

import Foundation
import UIKit

enum CheckInRoute: Route {
    case main
    case gitPopup(name: String)
    
    var screen: UIViewController {
        switch self {
        case .main:
            guard let main = R.storyboard.checkIn.checkInController() else {
                return UIViewController()
            }
            main.viewModel = DalyMonthVM()
            return main
        case let .gitPopup(name):
            let main = GitViewController.loadController()
            main.name = name
            return main
        }
    }
}
