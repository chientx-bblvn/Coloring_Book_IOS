//
//  MyProgressView.swift
// Doll-Coloring
//
//  Created by BBLabs on 11/04/2023.
//  Copyright © 2024 BBLabs. All rights reserved.
//

import UIKit

@IBDesignable
class MyProgressView: UIProgressView {
    
    @IBInspectable var scaleY: CGFloat = 1.15 {
        didSet {
            self.layoutSubviews()
        }
    }
    
    @IBInspectable var scaleX: CGFloat = 1.0 {
        didSet {
            self.layoutSubviews()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        transform = CGAffineTransform(scaleX: scaleX, y: scaleY)
        let cornerRadius = self.bounds.height / 2.0
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
        if let secondaryProgressLayer = self.layer.sublayers?[1] {
            secondaryProgressLayer.cornerRadius = cornerRadius
        }
        self.subviews[1].clipsToBounds = true
    }
}
