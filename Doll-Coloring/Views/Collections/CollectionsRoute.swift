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
    case main

    var screen: UIViewController {
        switch self {
        case .main:
            guard let main = R.storyboard.collections.collectionsController() else {
              return UIViewController()
            }
            main.viewModel = CollectionsVM()
            return main
        }
    }
}
