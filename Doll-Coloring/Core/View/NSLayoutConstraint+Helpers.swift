//
//  NSLayoutConstraint+Helpers.swift
//  BBLabs.
//
//  Created by BBLabs on 12/20/18.
//  Copyright © 2018 BBLabs.All rights reserved.
//

import Foundation
import UIKit

/**
 NSLayoutConstraints extension to provide helper methods to handle NSLayoutConstraints programatically.
 All functions return self to provide function chaining.
 */
public extension NSLayoutConstraint {
    // Activates the constraint
    func activate() -> NSLayoutConstraint {
        self.isActive = true
        return self
    }
    // Deactivates the constraint
    func deactivate() -> NSLayoutConstraint {
        self.isActive = false
        return self
    }
    
    func constraintWithMultiplier(_ multiplier: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: self.firstItem!, attribute: self.firstAttribute, relatedBy: self.relation, toItem: self.secondItem, attribute: self.secondAttribute, multiplier: multiplier, constant: self.constant)
    }
    
}

extension UIView {
    
    func setMultiplerValue(constraint constraintToChange: NSLayoutConstraint, _ multiplier: CGFloat) -> NSLayoutConstraint {
        let newConstraint = constraintToChange.constraintWithMultiplier(multiplier)
        removeConstraint(constraintToChange)
        addConstraint(newConstraint)
        layoutIfNeeded()
        return newConstraint
    }
    
}
