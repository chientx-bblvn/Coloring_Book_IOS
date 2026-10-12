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
            let build: @MainActor () -> UIViewController = {
                HistoryColoringPresenter.makeHostingController(
                    coloring: coloring,
                    coloringAPI: coloringAPI,
                    typeScreen: typeScreen
                )
            }
            if Thread.isMainThread {
                return MainActor.assumeIsolated(build)
            }
            return DispatchQueue.main.sync {
                MainActor.assumeIsolated(build)
            }
        }
    }
}
