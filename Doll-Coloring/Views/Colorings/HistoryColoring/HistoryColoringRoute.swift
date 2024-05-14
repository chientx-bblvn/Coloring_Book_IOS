//
//  HistoryColoringRoute.swift
//  Doll-Coloring
//
//  Created by Việt Anh Nguyễn on 10/04/2024.
//  
//

import Foundation
import UIKit

enum HistoryColoringRoute: Route {
    case main(coloring: ColoringHistoryModel, typeScreen: BackToScreenType, coloringAPI: ColoringImage)

    var screen: UIViewController {
        switch self {
        case let .main(coloring, typeScreen, coloringAPI):
            guard let main = R.storyboard.historyColoring.historyColoringController() else {
              return UIViewController()
            }
            main.viewModel = HistoryColoringVM(coloring: coloring, typeScreen: typeScreen, coloringAPI: coloringAPI)
            return main
        }
    }
}
