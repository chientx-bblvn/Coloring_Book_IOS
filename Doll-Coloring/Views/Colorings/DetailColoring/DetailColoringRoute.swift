//
//  DetailColoringRoute.swift
//  Doll-Coloring
//
//  Created by Việt Anh Nguyễn on 7/5/24.
//  
//

import Foundation
import UIKit

enum DetailColoringRoute: Route {
    case main(coloring: ColoringModel)

    var screen: UIViewController {
        switch self {
        case let .main(coloring):
            guard let main = R.storyboard.detailColoring.detailColoringController() else {
              return UIViewController()
            }
            main.viewModel = DetailColoringVM(coloring: coloring)
            return main
        }
    }
}
