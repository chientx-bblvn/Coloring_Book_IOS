//
//  SaveColoringRoute.swift
//  Doll-Coloring
//
//  Created by Việt Anh Nguyễn on 10/04/2024.
//  
//

import Foundation
import UIKit

enum SaveColoringRoute: Route {
    case main(imageColoring: UIImage, coloringLocal: ColoringHistoryModel, history: HistoryModel?, typeScreen: BackToScreenType)

    var screen: UIViewController {
        switch self {
        case let .main(imageColoring, coloringLocal, history, typeScreen):
            guard let main = R.storyboard.saveColoring.saveColoringController() else {
              return UIViewController()
            }
            main.viewModel = SaveColoringVM(imageColoring: imageColoring, coloringLocal: coloringLocal, history: history, typeScreen: typeScreen)
            return main
        }
    }
}
