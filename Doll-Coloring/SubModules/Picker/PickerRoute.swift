//
//  PickerRoute.swift
// Doll-Coloring
//
//  Created by BBLabs on 11/10/21.
//  Copyright © 2021 BBLabs.All rights reserved.
//

import Foundation
import UIKit

enum PickerRoute: Route {
    case picker
    case pickerDate

    var screen: UIViewController {
        switch self {
        case .picker:
            guard let picker = R.storyboard.picker.pickerController() else {
              return UIViewController()
            }
            return picker
        case .pickerDate:
            guard let picker = R.storyboard.picker.pickDateTimeController() else {
              return UIViewController()
            }
            return picker
        }
    }
}
