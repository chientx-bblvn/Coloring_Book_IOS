//
//  ButtonView.swift
//  BBLabs
//
//  Created by BBLabs on 7/20/22.
//  Copyright © 2022 BBLabs.All rights reserved.
//

import UIKit

@IBDesignable
class ButtonView: BaseCustomXibView {
    
    @IBOutlet private weak var viewButton: GradientView!
    @IBOutlet private weak var lbTitle: UILabel!
    @IBOutlet private weak var loadingIndicatorView: UIActivityIndicatorView!
    private var handleClick: (() -> Void)?

    // Config for gradient background
    @IBInspectable
    var enableGradient: Bool = true {
        didSet {
            setupView()
        }
    }
    
    @IBInspectable
    var heightButton: CGFloat = 42.0 {
        didSet {
            setupView()
        }
    }
    
    @IBInspectable
    var startColor: UIColor? = R.color.mainPrimary() {
        didSet {
            setupView()
        }
    }
    @IBInspectable
    var middleColor: UIColor? = R.color.mainPrimary()?.withAlphaComponent(0.5) {
        didSet {
            setupView()
        }
    }
    @IBInspectable
    var endColor: UIColor? = R.color.mainPrimary()?.withAlphaComponent(0.25) {
        didSet {
            setupView()
        }
    }
    
    @IBInspectable
    var diagonalMode: Bool = false {
        didSet {
            setupView()
        }
    }
    
    @IBInspectable
    var startLocation: Double = 0 {
        didSet {
            setupView()
        }
    }
    
    @IBInspectable
    var middleLocation: Double = 0.6407 {
        didSet {
            setupView()
        }
    }
    
    @IBInspectable
    var endLocation: Double = 1.0 {
        didSet {
            setupView()
        }
    }
    
    @IBInspectable
    var horizontalMode: Bool = true {
        didSet {
            setupView()
        }
    }
    
    @IBInspectable
    var backgroudButton: UIColor? = R.color.mainPrimary() {
        didSet {
            setupView()
        }
    }
    
    @IBInspectable
    var title: String = "" {
        didSet {
            setupView()
        }
    }
    
    @IBInspectable
    var titleColor: UIColor? = "#FFFFFF".hexStringToUIColor() {
        didSet {
            setupView()
        }
    }
    
    @IBInspectable
    var fontSize: CGFloat = 14 {
        didSet {
            setupView()
        }
    }
    
    var fontWeight: UIFont.Weight = .bold {
        didSet {
            setupView()
        }
    }
    
    @IBInspectable
    var indicatorColor: UIColor = "#FFFFFF".hexStringToUIColor() {
        didSet {
            setupView()
        }
    }
    
    @IBInspectable
    var indicatorPadding: CGFloat = 15.0 {
        didSet {
            setupView()
        }
    }
    
    @IBInspectable
    var enable: Bool = true {
        didSet {
            setupView()
        }
    }
    
    override func didLoadFromNib() {
        super.didLoadFromNib()
        setupView()
    }
    
    func setupView() {
        if enableGradient {
            viewButton.startColor = startColor ?? .clear
            viewButton.middleColor = middleColor ?? .clear
            viewButton.endColor = endColor ?? .clear
            viewButton.diagonalMode = diagonalMode
            viewButton.startLocation = startLocation
            viewButton.middleLocation = middleLocation
            viewButton.endLocation = endLocation
            viewButton.horizontalMode = horizontalMode
        } else {
            viewButton.startColor = backgroudButton ?? .clear
            viewButton.middleColor = backgroudButton ?? .clear
            viewButton.endColor = backgroudButton ?? .clear
        }
        lbTitle.text = title
        lbTitle.textColor = titleColor
        lbTitle.font = UIFont.systemFont(ofSize: fontSize, weight: fontWeight)
        loadingIndicatorView.color = indicatorColor
        
        self.isUserInteractionEnabled = enable
        self.alpha = enable ? 1 : 0.6
        
        _ = self.heightAnchor.constraint(equalToConstant: heightButton).activate()
    }
    
    func setOnClickListener(click: @escaping (() -> Void)) {
        self.handleClick = click
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clickView)))
    }
    
    @objc private func clickView() {
        self.isClicked(true)
        handleClick?()
    }
    
    // Call to show loading on button
    func setLoading(isLoading: Bool) {
        if isLoading {
            beginLoading()
        } else {
            endLoading()
        }
    }
    
    // Hide title button and show loading indicator
    private func beginLoading() {
        isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: { [weak self] in
            self?.lbTitle.alpha = 0
            self?.lbTitle.isHidden = true
            self?.loadingIndicatorView.startAnimating()
            self?.loadingIndicatorView.isHidden = false
            self?.loadingIndicatorView.alpha = 1
        })
    }
    
    // Show title button and hide loading indicator
    private func endLoading() {
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: { [weak self] in
            self?.isUserInteractionEnabled = true
            self?.loadingIndicatorView.alpha = 0
            self?.loadingIndicatorView.isHidden = true
            self?.lbTitle.isHidden = false
            self?.lbTitle.alpha = 1
            self?.loadingIndicatorView.stopAnimating()
        })
    }
    
}
