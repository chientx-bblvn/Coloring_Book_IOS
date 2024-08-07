//
//  PopupDateRangeRoute.swift
//  BloodPresure-iOS
//
//  Created by BloodPresure on 04/08/2022.
//  Copyright © 2022 BloodPresure. All rights reserved.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

enum PopupDateRangeRoute: Route {
    case popupDateRange(dateRange: BehaviorSubject<DateRangeModel>)

    var screen: UIViewController {
        switch self {
        case let .popupDateRange(dateRange):
            guard let popupDateRange = R.storyboard.popupDate.popupDateRangeController() else {
                return UIViewController()
            }
            let viewModel = PopupDateRangeVM(dateRange: dateRange)
            popupDateRange.height = 543
            popupDateRange.viewModel = viewModel
            popupDateRange.modalPresentationStyle = .custom
            popupDateRange.transitioningDelegate = popupDateRange
            
            return popupDateRange
        }
    }
}
struct DateRangeModel {
    var startDate: String = ""
    var endDate: String = ""
    var minimumDate: Date?
    var maximumDate: Date?
    var startSelect: Date?
    var endSelect: Date?
}
