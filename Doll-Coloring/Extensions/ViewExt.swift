//
//  ViewExt.swift
//  BBLabs.
//
//  Created by BBLabs on 12/7/20.
//  Copyright © 2020 BBLabs.All rights reserved.
//

import UIKit

extension UIView {
    
    func isClicked(_ isClicked: Bool) {
        if isClicked {
            let scale: CGFloat = 0.985
            UIView.animate(withDuration: 0.25) {
                self.transform = CGAffineTransform(scaleX: scale, y: scale)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                    self.isClicked(false)
                }
            }
        } else {
            UIView.animate(withDuration: 0.25) {
                self.transform = .identity
            }
        }
    }
    
    func imageFromView() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}

extension UIView {
    
    @IBInspectable
    var cornerRadiusView: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
    
    func addShadow(location: VerticalLocation, color: UIColor = .black, opacity: Float = 0.75, radius: CGFloat = 5.0) {
        switch location {
        case .bottom:
            addShadow(offset: CGSize(width: 0, height: 10), color: color, opacity: opacity, radius: radius)
        case .top:
            addShadow(offset: CGSize(width: 0, height: -10), color: color, opacity: opacity, radius: radius)
        }
    }
    
    func addShadow(offset: CGSize, color: UIColor = .black, opacity: Float = 0.75, radius: CGFloat = 5.0) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = offset
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = radius
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    @available(iOS 11.0, *)
    func roundCorners(corners: CACornerMask, radius: CGFloat) {
        layer.cornerRadius = radius
        layer.maskedCorners = corners
    }
    
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
    
    func gradient(startColor: UIColor = "#E2465C".hexStringToUIColor(),
                  endColor: UIColor = "#FFC370".hexStringToUIColor(),
                  cornerRadius: CGFloat = 0,
                  startPoint: GradientDirection = .top,
                  endPoint: GradientDirection = .bottom) {
        let gradient = CAGradientLayer()
        gradient.colors = [startColor.cgColor, endColor.cgColor]
        gradient.startPoint = startPoint.point
        gradient.endPoint = endPoint.point
        gradient.frame = bounds
        gradient.cornerRadius = cornerRadius
        layer.insertSublayer(gradient, at: 0)
        layer.cornerRadius = cornerRadius
    }
    
    func dropShadow(scale: Bool = true) {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 1.0
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowRadius = 4
        
        // Optionally, you can add a corner radius
        self.layer.cornerRadius = 10
        
        // To improve performance, you might want to set the shadow path
        self.layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: layer.cornerRadius).cgPath
    }
    
    public func generateOuterShadow() {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.withAlphaComponent(0.7).cgColor
        self.layer.shadowOffset =  CGSize.zero
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 4
    }
    
    public func customGenerateOuterShadow(shadowOpacity:Float = 0.5, shadowRadius: CGFloat = 4, color: UIColor, shadowOffset: CGSize = CGSize(width: 0, height: 0)) {
        self.layer.borderWidth = 2
        self.layer.borderColor = color.cgColor
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = shadowOffset
        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowRadius = shadowRadius
    }
}

enum GradientDirection {
    case left, topLeft, top, topRight, right, bottomRight, bottom, bottomLeft
    
    var point: CGPoint {
        switch self {
        case .left:
            return .init(x: 0, y: 0.5)
        case .topLeft:
            return .init(x: 0, y: 0)
        case .top:
            return .init(x: 0.5, y: 0)
        case .topRight:
            return .init(x: 1, y: 0)
        case .right:
            return .init(x: 1, y: 0.5)
        case .bottomRight:
            return .init(x: 1, y: 1)
        case .bottom:
            return .init(x: 0.5, y: 1)
        case .bottomLeft:
            return .init(x: 0, y: 1)
        }
    }
}
