//
//  AppRouter.swift
//  BBLabs.
//
//  Created by BBLabs on 3/12/18.
//  Copyright © 2018 BBLabs.All rights reserved.
//

import Foundation
import UIKit

class AppRouter: BaseRouter {
    static var shared = AppRouter()

    init() {
        let initialRoute: Route = SplashRoute.splash
        super.init(with: initialRoute)
    }

    required init(with route: Route) {
        super.init(with: route)
    }
}
