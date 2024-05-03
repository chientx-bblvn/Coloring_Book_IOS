//
//  Bundle++.swift
//  Doll-Coloring
//
//  Created by BBLabs on 13/08/2023.
//

import Foundation

extension Bundle {
    var releaseVersionNumber: String {
        return (infoDictionary?["CFBundleShortVersionString"] as? String) ?? ""
    }
    var buildVersionNumber: String {
        return (infoDictionary?["CFBundleVersion"] as? String) ?? ""
    }
}
