//
//  TextViewWithPlaceholder.swift
// Doll-Coloring
//
//  Created by BBLabs on 11/04/2023.
//  Copyright © 2024 BBLabs. All rights reserved.
//

import UIKit
@IBDesignable class TextViewWithPlaceholder: UITextView {
    
    override var text: String! { // Ensures that the placeholder text is never returned as the field's text
        get {
            if showingPlaceholder {
                return "" // When showing the placeholder, there's no real text to return
            } else { return super.text }
        }
        set {
            showingPlaceholder = newValue.isEmpty 
            super.text = newValue
                       
        }
    }
    @IBInspectable var placeholderText: String = ""
    @IBInspectable var placeholderTextColor: UIColor? = .lightGray
    private var showingPlaceholder: Bool = true {
        didSet {
            if showingPlaceholder {
                textColor = placeholderTextColor
                super.text = placeholderText
            } else {
                textColor = R.color.textColor()
            }
        }
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        if text.isEmpty {
            showPlaceholderText() // Load up the placeholder text when first appearing, but not if coming back to a view where text was already entered
        }
    }
    
    override func becomeFirstResponder() -> Bool {
        // If the current text is the placeholder, remove it
        if showingPlaceholder {
            text = ""
            showingPlaceholder = false
        }
        return super.becomeFirstResponder()
    }
    
    override func resignFirstResponder() -> Bool {
        // If there's no text, put the placeholder back
        if text.isEmpty {
            showPlaceholderText()
        }
        return super.resignFirstResponder()
    }
    
    private func showPlaceholderText() {
        showingPlaceholder = true
    }
}
