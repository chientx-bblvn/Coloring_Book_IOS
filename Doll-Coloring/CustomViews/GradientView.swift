//
//  GradientView.swift
// Doll-Coloring
//
//  Created by BBLabs on 04/04/2023.
//

import Foundation
import UIKit

@IBDesignable
public class GradientView: UIView {
    
    @IBInspectable var startColor: UIColor = "#3E86FA".hexStringToUIColor() { didSet { updateColors() }}
    @IBInspectable var middleColor: UIColor = "#3E86FA".hexStringToUIColor() { didSet { updateColors() }}
    @IBInspectable var endColor: UIColor = "#30C7EC".hexStringToUIColor() { didSet { updateColors() }}
    @IBInspectable var startLocation: Double = 0 { didSet { updateLocations() }}
    @IBInspectable var middleLocation: Double = 0.64 { didSet { updateLocations() }}
    @IBInspectable var endLocation: Double = 1 { didSet { updateLocations() }}
    @IBInspectable var horizontalMode: Bool = false { didSet { updatePoints() }}
    @IBInspectable var diagonalMode: Bool = false { didSet { updatePoints() }}
    
    override public class var layerClass: AnyClass { CAGradientLayer.self }
    
    // swiftlint:disable force_cast
    var gradientLayer: CAGradientLayer { layer as! CAGradientLayer }
    
    func updatePoints() {
        if horizontalMode {
            gradientLayer.startPoint = diagonalMode ? .init(x: 1, y: 0) : .init(x: 0, y: 0.5)
            gradientLayer.endPoint   = diagonalMode ? .init(x: 0, y: 1) : .init(x: 1, y: 0.5)
        } else {
            gradientLayer.startPoint = diagonalMode ? .init(x: 0, y: 0) : .init(x: 0.5, y: 0)
            gradientLayer.endPoint   = diagonalMode ? .init(x: 1, y: 1) : .init(x: 0.5, y: 1)
        }
    }
    func updateLocations() {
        gradientLayer.locations = [startLocation as NSNumber, middleLocation as NSNumber, endLocation as NSNumber]
    }
    func updateColors() {
        gradientLayer.colors = [startColor.cgColor, middleColor.cgColor, endColor.cgColor]
    }
    override public func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updatePoints()
        updateLocations()
        updateColors()
    }
    
}
