//
//  UIKit++.swift
// Doll-Coloring
//
//  Created by BBLabs on 11/04/2023.
//  Copyright © 2024 BBLabs. All rights reserved.
//

#if canImport(UIKit)
import UIKit

// MARK: - UIBarItem extension -
extension UIBarItem {
    var view: UIView? {
        if let item = self as? UIBarButtonItem, let customView = item.customView {
            return customView
        }
        return self.value(forKey: "view") as? UIView
    }
}

// MARK: - UIView extension -
extension UIView {
    
    func hasSuperview(_ superview: UIView) -> Bool {
        return viewHasSuperview(self, superview: superview)
    }
    
    fileprivate func viewHasSuperview(_ view: UIView, superview: UIView) -> Bool {
        if let sview = view.superview {
            if sview === superview {
                return true
            } else {
                return viewHasSuperview(sview, superview: superview)
            }
        } else {
            return false
        }
    }
    
    func mask(maskRect: CGRect,
              radius: CGFloat = 6,
              colorFill: UIColor = UIColor.white) -> UIView {
        self.subviews.forEach { if $0.restorationIdentifier?.elementsEqual("maskView") ?? false { $0.removeFromSuperview() } }
        let viewMask = createOverlay(maskSize: maskRect, color: colorFill)
        viewMask.restorationIdentifier = "maskView"
        viewMask.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(viewMask)
        NSLayoutConstraint.activate([
            viewMask.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            viewMask.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            viewMask.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            viewMask.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0)
        ])
        return viewMask
    }
    
    private func createOverlay(maskSize: CGRect, radius: CGFloat = 6, color: UIColor?) -> UIView {
        let overlayView = UIView(frame: self.frame)
        overlayView.backgroundColor = color

        let path = CGMutablePath()

        path.addRoundedRect(in: maskSize, cornerWidth: radius, cornerHeight: radius)
        path.closeSubpath()
        
        let shape = CAShapeLayer()
        shape.path = path
        shape.lineWidth = 5.0
        shape.strokeColor = UIColor.white.cgColor
        shape.fillColor = UIColor.white.cgColor
        
        overlayView.layer.addSublayer(shape)
        
        path.addRect(CGRect(origin: .zero, size: overlayView.frame.size))

        let maskLayer = CAShapeLayer()
        maskLayer.backgroundColor = UIColor.black.cgColor
        maskLayer.path = path
        maskLayer.fillRule = CAShapeLayerFillRule.evenOdd

        overlayView.layer.mask = maskLayer
        overlayView.clipsToBounds = true
        
        return overlayView
    }
}

// MARK: - CGRect extension -
extension CGRect {
    var x: CGFloat {
        get {
            return self.origin.x
        }
        set {
            self.origin.x = newValue
        }
    }
    
    var y: CGFloat {
        get {
            return self.origin.y
        }
        
        set {
            self.origin.y = newValue
        }
    }
    
    var center: CGPoint {
        return CGPoint(x: self.x + self.width / 2, y: self.y + self.height / 2)
    }
}

// MARK: - Nested types -
public enum ArrowPosition {
    case any
    case top
    case bottom
    case right
    case left
    
    static let allValues = [top, bottom, right, left]
}

public struct Drawing {
    public var cornerRadius        = CGFloat(5)
    public var arrowHeight         = CGFloat(5)
    public var arrowWidth          = CGFloat(10)
    public var foregroundColor     = UIColor.white
    public var backgroundColor     = UIColor.red
    public var arrowPosition       = ArrowPosition.any
    public var textAlignment       = NSTextAlignment.center
    public var borderWidth         = CGFloat(0)
    public var borderColor         = UIColor.clear
    public var font                = UIFont.systemFont(ofSize: 15)
    public var shadowColor         = UIColor.clear
    public var shadowOffset        = CGSize(width: 0.0, height: 0.0)
    public var shadowRadius        = CGFloat(0)
    public var shadowOpacity       = CGFloat(0)
}

public struct Positioning {
    public var bubbleInsets         = UIEdgeInsets(top: 1.0, left: 1.0, bottom: 1.0, right: 1.0)
    public var contentInsets        = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    public var maxWidth             = CGFloat(200)
}

public struct Animating {
    public var dismissTransform     = CGAffineTransform(scaleX: 0.1, y: 0.1)
    public var showInitialTransform = CGAffineTransform(scaleX: 0, y: 0)
    public var showFinalTransform   = CGAffineTransform.identity
    public var springDamping        = CGFloat(0.7)
    public var springVelocity       = CGFloat(0.7)
    public var showInitialAlpha     = CGFloat(0)
    public var dismissFinalAlpha    = CGFloat(0)
    public var showDuration         = 0.7
    public var dismissDuration      = 0.7
    public var dismissOnTap         = true
}

public struct Preferences {
    
    public var drawing      = Drawing()
    public var positioning  = Positioning()
    public var animating    = Animating()
    public var hasBorder: Bool {
        return drawing.borderWidth > 0 && drawing.borderColor != UIColor.clear
    }
    
    public var hasShadow: Bool {
        return drawing.shadowOpacity > 0 && drawing.shadowColor != UIColor.clear
    }
    
    public init() {}
}

public enum Content: CustomStringConvertible {
    
    case text(String)
    case attributedText(NSAttributedString)
    case view(UIView)
    
    public var description: String {
        switch self {
        case .text(let text):
            return "text : '\(text)'"
        case .attributedText(let text):
            return "attributed text : '\(text)'"
        case .view(let contentView):
            return "view : \(contentView)"
        }
    }
}

public protocol EasyTipViewDelegate: AnyObject {
    func easyTipViewDidInit(_ tipView: EasyTipView)
    func easyTipViewDidOpen(_ tipView: EasyTipView)
    func easyTipViewDidTap(_ tipView: EasyTipView)
    func easyTipViewDidDismiss(_ tipView: EasyTipView)
}

#endif
