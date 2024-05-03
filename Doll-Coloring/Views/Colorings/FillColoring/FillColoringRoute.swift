//
//  FillColoringRoute.swift
//  Doll-Coloring
//
//  Created by Việt Anh Nguyễn on 22/4/24.
//  
//

import Foundation
import UIKit

enum FillColoringRoute: Route {
    case main(coloringLocal: ColoringLocalModel, coloringImage: String)

    var screen: UIViewController {
        switch self {
        case let .main(coloringLocal, coloringImage):
            guard let main = R.storyboard.fillColoring.fillColoringController() else {
              return UIViewController()
            }
            main.viewModel = FillColoringVM(coloringLocal: coloringLocal, coloringImage: coloringImage)
            return main
        }
    }
}
