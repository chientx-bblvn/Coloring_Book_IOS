//
//  UILabelExt.swift
//  BBLabs.
//
//  Created by BBLabs on 1/6/21.
//  Copyright © 2021 BBLabs.All rights reserved.
//

import UIKit

class TextSourceLabel: UILabel {
    
    public var contentInset: UIEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10) {
        didSet {
            sizeToFit()
        }
    }
   
    open override func draw(_ rect: CGRect) {
        super.draw(rect.inset(by: contentInset))
    }
    
}
