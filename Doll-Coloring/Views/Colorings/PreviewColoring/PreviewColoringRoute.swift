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
    case main(coloring: ColoringImage?, coloringLocal: ColoringHistoryModel?, history: HistoryModel?, typeScreen: BackToScreenType)

    var screen: UIViewController {
        switch self {
        case let .main(coloring, coloringLocal, history: history, typeScreen):
            let viewModel = PreparingDrawingViewModel(
                coloring: coloring,
                coloringLocal: coloringLocal,
                history: history,
                typeScreen: typeScreen
            )
            return PreparingDrawingHostController(viewModel: viewModel)
        }
    }
}
