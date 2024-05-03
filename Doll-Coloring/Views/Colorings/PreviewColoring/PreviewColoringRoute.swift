//
//  PreviewColoringRoute.swift
//  Doll-Coloring
//
//  Created by Việt Anh Nguyễn on 10/04/2024.
//  
//

import Foundation
import UIKit

enum PreviewColoringRoute: Route {
    case main(coloring: ColoringImage?, coloringLocal: ColoringHistoryModel?, history: HistoryModel?, isCollection: Bool = false)

    var screen: UIViewController {
        switch self {
        case let .main(coloring, coloringLocal, history: history, isCollection):
            guard let main = R.storyboard.previewColoring.previewColoringController() else {
              return UIViewController()
            }
            main.viewModel = PreviewColoringVM(coloring: coloring, coloringLocal: coloringLocal, history: history, isCollection: isCollection)
            return main
        }
    }
}
