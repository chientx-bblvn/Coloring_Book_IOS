//
//  StartColoringRoute.swift
//  Doll-Coloring
//
//  Created by Việt Anh Nguyễn on 10/04/2024.
//  
//

import Foundation
import UIKit

enum StartColoringRoute: Route {
    case main(coloringLocal: ColoringHistoryModel, history: HistoryModel?, isCollection: Bool)

    var screen: UIViewController {
        switch self {
        case let .main(coloringLocal, history, isCollection):
            guard let main = R.storyboard.startColoring.startColoringController() else {
              return UIViewController()
            }
            main.viewModel = StartColoringVM(coloringLocal: coloringLocal, history: history, isCollection: isCollection)
            return main
        }
    }
}
