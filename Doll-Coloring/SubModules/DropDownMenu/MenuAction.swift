//
//  MenuAction.swift
// Doll-Coloring
//
//  Created by BBLabs on 13/08/2020.
//  Copyright © 2020 BBLabs.All rights reserved.
//

import Foundation

typealias SelectedAction = ((_ action: MenuAction) -> Void)

class MenuAction {
    // MARK: - Properties
    var successHandler: SelectedAction?
    var title: String
    var isEnable: Bool = true
    
    // MARK: - Life Cycle
    init (title: String,
          isEnable: Bool = true,
          handler: @escaping SelectedAction) {
        self.title = title
        self.isEnable = isEnable
        self.successHandler = handler
    }
}
