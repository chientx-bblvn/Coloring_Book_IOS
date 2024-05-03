//
//  String+Localizable.swift
// Doll-Coloring
//
//  Created by BBLabs on 11/5/21.
//  Copyright © 2021 BBLabs.All rights reserved.
//

import Foundation

extension String {
    
    func localizedString(tableName: String = "ErrorCode", defaultValue: String = "", comment: String = "") -> String {
        let key = self
        // Fall back to base
        guard
            let path = Bundle.main.path(forResource: Constants.currentLanguage.key, ofType: "lproj"),
            let bundle = Bundle(path: path)
        else { return comment }
        let newvalue = NSLocalizedString(key, tableName: tableName, bundle: bundle,
                                         value: defaultValue, comment: comment)
        return newvalue
    }
    
}
