//
//  TopBarView.swift
// Doll-Coloring
//
//  Created by BBLabs on 7/20/22.
//  Copyright © 2022 BBLabs.All rights reserved.
//

import UIKit

@IBDesignable
final class TopBarView: BaseCustomXibView {
    
    @IBOutlet private weak var btnLeft: UIButton?
    @IBOutlet private weak var btnRight: UIButton?
    @IBOutlet private weak var lbTitle: UILabel?
    @IBOutlet private weak var ivTitleLogo: UIImageView?
    @IBOutlet private weak var btnPremium: UIButton?
    @IBOutlet private weak var viewPremium: UIView?
    
    var onRightClick: (() -> Void)?
    var onLeftClick: (() -> Void)?
    var onClickPremium: (() -> Void)?
    
    // Set title for input
    @IBInspectable var title: String {
        get {
            return lbTitle?.text ?? ""
        }
        set {
            lbTitle?.text = newValue
            lbTitle?.isHidden = false
            ivTitleLogo?.isHidden = true
        }
    }

    var titleImage: UIImage? {
        get { ivTitleLogo?.image }
        set {
            ivTitleLogo?.image = newValue
            ivTitleLogo?.isHidden = newValue == nil
            lbTitle?.isHidden = newValue != nil
            ivTitleLogo?.accessibilityLabel = newValue == nil ? nil : "Crayo"
            ivTitleLogo?.isAccessibilityElement = newValue != nil
        }
    }
    
    @IBInspectable var titleColor: UIColor {
        get {
            return lbTitle?.textColor ?? .black
        }
        set {
            lbTitle?.textColor = newValue
        }
    }
    
    @IBInspectable var backgroundColorView: UIColor {
        get {
            return self.contentView?.backgroundColor ?? .black
        }
        set {
            self.contentView?.backgroundColor = newValue
        }
    }
    
    var titleFont: UIFont {
        get {
            return lbTitle?.font ?? .systemFont(ofSize: 20)
        }
        set {
            lbTitle?.font = newValue
        }
    }
    
    @IBInspectable var leftIcon: UIImage? {
        get {
            return btnLeft?.image(for: .normal)
        }
        set {
            btnLeft?.setImage(newValue, for: .normal)
        }
    }
    
    @IBInspectable var showPremium: Bool = true {
        didSet {
            if IAPState.isUserVip {
                btnLeft?.isHidden = true
            } else {
                btnLeft?.isHidden = showPremium
            }
        }
    }
    
    @IBInspectable var textAlignmentCenter: Bool = true {
        didSet {
            lbTitle?.textAlignment = textAlignmentCenter ? .center : .left
            btnLeft?.isHidden = !textAlignmentCenter
        }
    }
    
    @IBInspectable var rightIcon: UIImage? {
        get {
            return btnRight?.image(for: .normal)
        }
        set {
            btnRight?.setImage(newValue, for: .normal)
            btnRight?.setTitle(nil, for: .normal)
            btnRight?.contentHorizontalAlignment = .center
            btnRight?.isHidden = newValue == nil && (btnRight?.title(for: .normal)?.isEmpty ?? true)
        }
    }
    
    var rightImageURL: (imageURL: String?, placeHolder: UIImage?) {
        didSet {
            btnRight?.imageView?.setLocalImage(with: rightImageURL.imageURL,
                                              placeholder: rightImageURL.placeHolder)
        }
    }
    
    @IBInspectable var rightTitle: String? {
        get {
            return btnRight?.title(for: .normal)
        }
        set {
            btnRight?.setTitle(newValue, for: .normal)
        }
    }
    
    @IBInspectable var rightTitleColor: UIColor? {
        get {
            return btnRight?.titleColor(for: .normal)
        }
        set {
            btnRight?.setTitleColor(newValue, for: .normal)
        }
    }
    
    @IBInspectable var rightEnable: Bool {
        get {
            return btnRight?.isUserInteractionEnabled ?? false
        }
        set {
            btnRight?.isUserInteractionEnabled = newValue
        }
    }
    var titleLRightFont: UIFont {
        get {
            return btnRight?.titleLabel?.font ?? .systemFont(ofSize: 24)
        }
        set {
            btnRight?.titleLabel?.font = newValue
        }
    }

    
    override func didLoadFromNib() {
        super.didLoadFromNib()
    }

    /// Force the leading control visible (e.g. close on coloring) regardless of VIP / showPremium.
    func setLeftButtonVisible(_ visible: Bool) {
        btnLeft?.isHidden = !visible
    }

    func setRightButtonVisible(_ visible: Bool) {
        btnRight?.isHidden = !visible
    }

    func setTitleHidden(_ hidden: Bool) {
        lbTitle?.isHidden = hidden
        if hidden {
            lbTitle?.text = ""
            ivTitleLogo?.isHidden = true
        }
    }

    private var circularActionSide: CGFloat = 34

    /// Compact solid-white circular action chips (back / save).
    func applyPlainWhiteActionButtons(
        leftImage: UIImage?,
        rightImage: UIImage?,
        tintColor: UIColor = AppTheme.text
    ) {
        prepareStackForCircularActions(horizontalInset: 16)
        stylePlainWhiteActionButton(btnLeft, image: leftImage, tint: tintColor)
        stylePlainWhiteActionButton(btnRight, image: rightImage, tint: tintColor)
        btnLeft?.isHidden = leftImage == nil
        btnRight?.isHidden = rightImage == nil
        setNeedsLayout()
        layoutIfNeeded()
        refreshCircularActionCorners()
    }

    /// Kept for call-site compatibility; same as plain white chips.
    func applyLiquidGlassActionButtons(
        leftImage: UIImage?,
        rightImage: UIImage?,
        tintColor: UIColor = AppTheme.text
    ) {
        applyPlainWhiteActionButtons(leftImage: leftImage, rightImage: rightImage, tintColor: tintColor)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        refreshCircularActionCorners()
    }

    /// Stack was stretching buttons to bar height → rounded squares. Keep them centered circles.
    private func prepareStackForCircularActions(horizontalInset: CGFloat) {
        guard let stack = btnLeft?.superview as? UIStackView else { return }
        stack.alignment = .center
        stack.distribution = .fill
        stack.isLayoutMarginsRelativeArrangement = true
        stack.directionalLayoutMargins = NSDirectionalEdgeInsets(
            top: 0, leading: horizontalInset, bottom: 0, trailing: horizontalInset
        )
        if let container = stack.superview {
            for constraint in container.constraints {
                guard let first = constraint.firstItem as? UIView,
                      let second = constraint.secondItem as? UIView else { continue }
                let touchesStack = first === stack || second === stack
                guard touchesStack else { continue }
                if constraint.firstAttribute == .leading || constraint.secondAttribute == .leading
                    || constraint.firstAttribute == .trailing || constraint.secondAttribute == .trailing {
                    constraint.constant = 0
                }
            }
        }
    }

    private func stylePlainWhiteActionButton(_ button: UIButton?, image: UIImage?, tint: UIColor) {
        guard let button else { return }
        let side = circularActionSide
        button.configuration = nil
        button.setTitle(nil, for: .normal)
        button.setImage(image?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = tint
        button.backgroundColor = .white
        button.clipsToBounds = true
        button.layer.masksToBounds = true
        button.layer.cornerCurve = .circular
        button.layer.borderWidth = 0
        button.layer.shadowOpacity = 0
        button.contentHorizontalAlignment = .center
        button.contentVerticalAlignment = .center
        button.imageView?.contentMode = .scaleAspectFit
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        constrainCompactActionButton(button, side: side)
        button.layer.cornerRadius = side / 2
    }

    private func refreshCircularActionCorners() {
        for button in [btnLeft, btnRight] {
            guard let button, !button.isHidden else { continue }
            let side = min(button.bounds.width, button.bounds.height)
            guard side > 0 else { continue }
            button.layer.cornerRadius = side / 2
            button.layer.masksToBounds = true
        }
    }

    private func constrainCompactActionButton(_ button: UIButton, side: CGFloat) {
        button.setContentHuggingPriority(.required, for: .horizontal)
        button.setContentHuggingPriority(.required, for: .vertical)
        button.setContentCompressionResistancePriority(.required, for: .horizontal)
        button.setContentCompressionResistancePriority(.required, for: .vertical)
        button.translatesAutoresizingMaskIntoConstraints = false

        // Drop prior size constraints (XIB fill / aspect / older compact sizes).
        NSLayoutConstraint.deactivate(
            button.constraints.filter {
                ($0.firstAttribute == .width || $0.firstAttribute == .height)
                    && ($0.firstItem as? UIView) === button
            }
        )

        let width = button.widthAnchor.constraint(equalToConstant: side)
        let height = button.heightAnchor.constraint(equalToConstant: side)
        width.priority = .required
        height.priority = .required
        width.isActive = true
        height.isActive = true
    }
    
    @IBAction func clickRightButton(_ sender: Any) {
        onRightClick?()
    }
    
    @IBAction func clickLeftButton(_ sender: Any) {
        onLeftClick?()
    }
    
    @IBAction func actionPremium(_ sender: Any) {
        onClickPremium?()
    }
    
    
}
