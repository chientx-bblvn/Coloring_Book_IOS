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
    case startColoring(coloringLocal: ColoringHistoryModel, history: HistoryModel?, typeScreen: BackToScreenType, coloringBookView: ColoringBookView)

    var screen: UIViewController {
        switch self {
        case let .startColoring(coloringLocal, history, typeScreen, coloringBookView):
            guard let main = R.storyboard.startColoring.startColoringIPadViewController() else {
              return UIViewController()
            }
            main.viewModel = StartColoringVM(coloringLocal: coloringLocal, history: history, typeScreen: typeScreen)
            main.coloringBookView = coloringBookView
            return main
        }
    }
}
