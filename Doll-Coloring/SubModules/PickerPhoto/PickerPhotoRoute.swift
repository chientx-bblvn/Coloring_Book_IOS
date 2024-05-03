//
//  PickerPhotoRoute.swift
// Doll-Coloring
//
//  Created by BBLabs on 11/20/21.
//  Copyright © 2021 BBLabs.All rights reserved.
//

import Foundation
import UIKit

enum PickerPhotoRoute: Route {
    case main

    var screen: UIViewController {
        switch self {
        case .main:
            guard let main = R.storyboard.pickerPhoto.pickerPhotoController() else {
              return UIViewController()
            }
            return main
        }
    }
}
