//
//  CollectionsRoute.swift
//  Doll-Coloring
//
//  Created by Việt Anh Nguyễn on 10/04/2024.
//  
//

import Foundation
import UIKit

enum CollectionsRoute: Route {
    case main(navigate: Bool = true)

    var screen: UIViewController {
        switch self {
        case let .main(navigate):
            guard let main = R.storyboard.collections.collectionsController() else {
              return UIViewController()
            }
            main.navigate = navigate
            main.viewModel = CollectionsVM()
            return main
        }
    }
}
