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
    case main(coloring: ColoringHistoryModel)

    var screen: UIViewController {
        switch self {
        case let .main(coloring):
            guard let main = R.storyboard.historyColoring.historyColoringController() else {
              return UIViewController()
            }
            main.viewModel = HistoryColoringVM(coloring: coloring)
            return main
        }
    }
}
