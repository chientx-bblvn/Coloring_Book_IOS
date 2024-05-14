//
//  DetailCollectionRoute.swift
//  Doll-Coloring
//
//  Created by Việt Anh Nguyễn on 6/5/24.
//  
//

import Foundation
import UIKit

enum DetailCollectionRoute: Route {
    case main(coloringLocal: ColoringHistoryModel, history: HistoryModel, isCollection: Bool)

    var screen: UIViewController {
        switch self {
        case let .main(coloringLocal, history, isCollection):
            guard let main = R.storyboard.detailCollection.detailCollectionController() else {
              return UIViewController()
            }
            main.viewModel = DetailCollectionVM(coloringLocal: coloringLocal, history: history, isCollection: isCollection)
            return main
        }
    }
}
