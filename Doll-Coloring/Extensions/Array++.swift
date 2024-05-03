//
//  Array++.swift
// Doll-Coloring
//
//  Created by BBLabs on 05/04/2023.
//  Copyright © 2024 BBLabs. All rights reserved.
//

import Foundation

extension Array {
    
    subscript(safe index: Int) -> Element? {
        if indices.contains(index) {
            return self[index]
        } else {
            return nil
        }
    }
    
    public func toDictionary<Key: Hashable>(with selectKey: (Element) -> Key) -> String {
            var dict = [Key:Element]()
            for element in self {
                dict[selectKey(element)] = element
            }
        return dict.description
    }
}
