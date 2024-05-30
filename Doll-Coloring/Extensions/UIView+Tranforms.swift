//
//  UIView+Tranforms.swift
//  BBLabs
//
//  Created by Sơn Lê on 4/22/21.
//  Copyright © 2021 BBLabs. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func fadeIn(_ duration: TimeInterval = 1.0, delay: TimeInterval = 0.0, completion: ((Bool) -> Void)? = nil) {
        self.alpha = 0
        UIView.animate(withDuration: duration, delay: delay, options: .curveEaseInOut, animations: {
            self.alpha = 1.0
        }, completion: completion)
    }
    
    func fadeOut(_ duration: TimeInterval = 1.0, delay: TimeInterval = 0.0, completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: duration, delay: delay, options: .curveEaseIn, animations: {
            self.alpha = 0.0
        }, completion: completion)
    }
    
    func showTranform(duration: TimeInterval = 1, _ delay: Int, completion: ((_ finished: Bool) -> Void)? = nil) {
        self.transform.ty = self.frame.origin.y - self.frame.size.height
        self.alpha = 1
        UIView.animate(withDuration: duration, delay: 0.08 * Double(delay), options: .curveEaseInOut, animations: {
            self.transform = .identity
            self.alpha = 1
        }, completion: { (finished) in
            if completion != nil {
                completion!(finished)
            }
        })
    }
    
    func showTranformFromBottom(duration: TimeInterval = 0, _ delay: Int, completion: ((_ finished: Bool) -> Void)? = nil) {
        self.transform.ty = self.frame.origin.y + self.frame.size.height
        self.alpha = 1
        UIView.animate(withDuration: duration, delay: 0.08 * Double(delay), options: .curveEaseInOut, animations: {
            self.transform = .identity
            self.alpha = 1
        }, completion: { (finished) in
            if completion != nil {
                completion!(finished)
            }
        })
    }
    
    func showTranformLeft(duration: TimeInterval = 0.5, _ delay: Int, completion: ((_ finished: Bool) -> Void)? = nil) {
        self.transform = .identity
        self.transform.tx = self.frame.origin.x - self.frame.size.width
        self.alpha = 1
        UIView.animate(withDuration: duration, delay: 0.08 * Double(delay), options: .curveEaseInOut, animations: {
            self.transform = .identity
            self.alpha = 1
        }, completion: { (finished) in
            if completion != nil {
                completion!(finished)
            }
        })
    }
    
    func showTranformRight(duration: TimeInterval = 0.5, _ delay: Int, completion: ((_ finished: Bool) -> Void)? = nil) {
        self.transform = .identity
        self.transform.tx = self.frame.origin.x + self.frame.size.width
        self.alpha = 1
        UIView.animate(withDuration: duration, delay: 0.08 * Double(delay), options: .curveEaseInOut, animations: {
            self.transform = .identity
            self.alpha = 1
        }, completion: { (finished) in
            if completion != nil {
                completion!(finished)
            }
        })
    }
    
    func hideTranform(duration: TimeInterval = 0, _ delay: Int, completion: ((_ finished: Bool) -> Void)? = nil) {
        self.alpha = 1
        UIView.animate(withDuration: duration, delay: 0.08 * Double(delay), options: .curveEaseInOut, animations: {
            self.transform.ty = self.frame.origin.y - self.frame.size.height
            self.alpha = 1
        }, completion: { (finished) in
            if completion != nil {
                completion!(finished)
            }
        })
    }
    
    func showTranformToBottom(duration: TimeInterval = 1, _ delay: Int, completion: ((_ finished: Bool) -> Void)? = nil) {
        self.alpha = 1
        UIView.animate(withDuration: duration, delay: 0.08 * Double(delay), options: .curveEaseInOut, animations: {
            self.transform.ty = self.frame.origin.y + self.frame.size.height
            self.alpha = 1
        }, completion: { (finished) in
            if completion != nil {
                completion!(finished)
            }
        })
    }
    
    func hideTranformToLeft(duration: TimeInterval = 1, _ delay: Int, completion: ((_ finished: Bool) -> Void)? = nil) {
        self.alpha = 1
        self.transform = .identity
        UIView.animate(withDuration: duration, delay: 0.08 * Double(delay), options: .curveEaseInOut, animations: {
            self.transform.tx = self.frame.origin.x - self.frame.size.width
            self.alpha = 0
        }, completion: { (finished) in
            completion?(finished)
            self.transform = .identity
        })
    }
    
    func hideTranformToRight(duration: TimeInterval = 0.5, _ delay: Int, completion: ((_ finished: Bool) -> Void)? = nil) {
        self.alpha = 1
        self.transform = .identity
        UIView.animate(withDuration: duration, delay: 0.08 * Double(delay), options: .curveEaseInOut, animations: {
            self.transform.tx = self.frame.origin.x + self.frame.size.width
            self.alpha = 0
        }, completion: { (finished) in
            completion?(finished)
            self.transform = .identity
        })
    }
    
    func hideTranformToTop(duration: TimeInterval = 1, _ delay: Int, completion: ((_ finished: Bool) -> Void)? = nil) {
        self.alpha = 1
        UIView.animate(withDuration: duration, delay: 0.08 * Double(delay), options: .curveEaseInOut, animations: {
            self.transform.ty = self.frame.origin.y - self.frame.size.height
            self.alpha = 1
        }, completion: { (finished) in
            if completion != nil {
                completion!(finished)
            }
        })
    }
    func hideTranformToBottom(duration: TimeInterval = 1, _ delay: Int, completion: ((_ finished: Bool) -> Void)? = nil) {
        self.alpha = 1
        UIView.animate(withDuration: duration, delay: 0.08 * Double(delay), options: .curveEaseInOut, animations: {
            self.transform.ty = self.frame.origin.y + self.frame.size.height
            self.alpha = 1
        }, completion: { (finished) in
            if completion != nil {
                completion!(finished)
            }
        })
    }
    @IBInspectable var rotateBy: CGFloat {
        get {
            return self.rotateBy
        }
        set {
            let degree = (newValue / 30) * .pi
            self.transform = CGAffineTransform(rotationAngle: degree)
            setNeedsLayout()
        }
    }
    
    func showTranformAnimationFrameView(position: Int, padding: Int, completion: ((_ finished: Bool) -> Void)? = nil) {
        UIView.animate(withDuration: 0.3, delay: 0.08, options: .curveEaseInOut, animations: {
            self.frame = CGRect(x: 0, y: self.frame.origin.y - (CGFloat(position) * self.frame.size.height) + CGFloat(padding), width: self.frame.size.width, height: self.frame.size.height)
            self.layoutSubviews()
        }, completion: { (finished) in
            if completion != nil {
                completion!(finished)
            }
        })
    }
    
    func hideTranformAnimationFrameView(position: Int, padding: Int, completion: ((_ finished: Bool) -> Void)? = nil) {
        UIView.animate(withDuration: 0.3, delay: 0.08, options: .curveEaseInOut, animations: {
            self.frame = CGRect(x: 0, y: self.frame.origin.y + (CGFloat(position) * self.frame.size.height) + CGFloat(padding), width: self.frame.size.width, height: self.frame.size.height)
            self.layoutSubviews()
        }, completion: { (finished) in
            if completion != nil {
                completion!(finished)
            }
        })
    }
    
    func blink(reverse: Bool = false, completion: @escaping (() -> Void)) {
        if reverse {
            self.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
        } else {
            transform = CGAffineTransform(scaleX: 1, y: 1)
        }
        UIView.animate(withDuration: 0.45,
                       delay: 0,
                       options: .curveEaseInOut,
                       animations: { [weak self] in
            if reverse {
                self?.transform = CGAffineTransform(scaleX: 1, y: 1)
            } else {
                self?.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
            }
        }, completion: { _ in
            completion()
        })
    }
    
    func stopBlink() {
        transform = CGAffineTransform(scaleX: 1, y: 1)
    }
}
