//
//  GestureRecognizerHandler.swift
//  BBLabs.
//
//  Created by BBLabs on 12/21/18.
//  Copyright © 2018 BBLabs.All rights reserved.
//

import Foundation
import UIKit

/**
 Abstraction layer on top of
 Base protocol that defines the basic interface
 that a GestureRecognizerHandler should have
 */
public protocol GestureRecognizerHandler {
    // The type of the GestureRecognizer
    associatedtype RecognizerType: UIGestureRecognizer
    // The view that will contain the GestureRecognizer
    var targetView: UIView { get set }
    // Instance of the GestureRecognizer
    var recognizer: RecognizerType { get set }
    // Basic initializer
    init(with targetView: UIView, and recognizer: RecognizerType)
    // Enables the GestureRecognizer
    func enableHandler()
    // Disables the GestureRecognizer
    func disableHandler()
}

/**
 Base class for any GestureRecognizerHandler
 (we need a class since we are using objc selectors)
 For specific use cases, you only need to sublclass this and override the `handle` function.
 You can optionally implement any UIGestureRecognizerDelegate methods that you wish
 Example:
 ```
 public class PanGestureRecognizerHandler: BaseGestureRecognizerHandler<UIPanGestureRecognizer> {
 public override func handle(_ sender: UIGestureRecognizer) {
 // your code here
 }
 }
 ```
 */
public class BaseGestureRecognizerHandler<T: UIGestureRecognizer>: NSObject, GestureRecognizerHandler, UIGestureRecognizerDelegate {
    public typealias RecognizerType = T
    
    public var targetView: UIView
    
    public var recognizer: T
    /**
     Initializes the class, wiring up the target view with the recognizer
     and setting itself as it's delegate.
     */
    required public init(with targetView: UIView, and recognizer: T) {
        self.targetView = targetView
        self.recognizer = recognizer
        super.init()
        recognizer.addTarget(self, action: #selector(handle(_:)))
        recognizer.delegate = self
        targetView.addGestureRecognizer(recognizer)
    }
    
    public func enableHandler() {
        recognizer.isEnabled = true
    }
    
    public func disableHandler() {
        recognizer.isEnabled = false
    }
    // Handler for the gestureRecognizer, this should be overriden
    @objc public func handle(_ sender: UIGestureRecognizer) {
        assertionFailure("You need to override this method.")
    }
}
