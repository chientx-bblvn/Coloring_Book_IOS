//
//  TabbarViewRoute.swift
//  Doll-Coloring
//
//  Created by Việt Anh Nguyễn on 17/5/24.
//  
//

import Foundation
import UIKit

//enum TabbarViewRoute: Route {
//    case main
//
//    var screen: UIViewController {
//        switch self {
//        case .main:
//            guard let main = R.storyboard.tabbarView.tabbarViewController() else {
//              return UIViewController()
//            }
//            return main
//        }
//    }
//}
enum MainTabbarViewRoute: Route {
    case tabbar

    var screen: UIViewController {
        switch self {
        case .tabbar:
            guard let tabbar = R.storyboard.tabbarView.mainTabbarViewController() else {
              return UIViewController()
            }
            return tabbar
        }
    }
}
