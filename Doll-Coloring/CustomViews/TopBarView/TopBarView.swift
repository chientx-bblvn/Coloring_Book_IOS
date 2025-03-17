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
    
    @IBOutlet private weak var btnLeft: UIButton!
    @IBOutlet private weak var btnRight: UIButton!
    @IBOutlet private weak var lbTitle: UILabel!
    @IBOutlet private weak var btnPremium: UIButton!
    @IBOutlet private weak var viewPremium: UIView!
    
    var onRightClick: (() -> Void)?
    var onLeftClick: (() -> Void)?
    var onClickPremium: (() -> Void)?
    
    // Set title for input
    @IBInspectable var title: String {
        get {
            return lbTitle.text ?? ""
        }
        set {
            lbTitle.text = newValue
        }
    }
    
    @IBInspectable var titleColor: UIColor {
        get {
            return lbTitle.textColor ?? .black
        }
        set {
            lbTitle.textColor = newValue
        }
    }
    
    @IBInspectable var backgroundColorView: UIColor {
        get {
            return self.contentView.backgroundColor ?? .black
        }
        set {
            self.contentView.backgroundColor = newValue
        }
    }
    
    var titleFont: UIFont {
        get {
            return lbTitle.font ?? .systemFont(ofSize: 20)
        }
        set {
            lbTitle.font = newValue
        }
    }
    
    @IBInspectable var leftIcon: UIImage? {
        get {
            return btnLeft.image(for: .normal)
        }
        set {
            btnLeft.setImage(newValue, for: .normal)
        }
    }
    
    @IBInspectable var showPremium: Bool = true {
        didSet {
            if IAPState.isUserVip {
                btnLeft.isHidden = true
//                viewPremium.isHidden = true
            } else {
                btnLeft.isHidden = showPremium
//                viewPremium.isHidden = showPremium
            }
        }
    }
    
    @IBInspectable var textAlignmentCenter: Bool = true {
        didSet {
            lbTitle.textAlignment = textAlignmentCenter ? .center : .left
            btnLeft.isHidden = !textAlignmentCenter
        }
    }
    
    @IBInspectable var rightIcon: UIImage? {
        get {
            return btnRight.image(for: .normal)
        }
        set {
            btnRight.setImage(newValue, for: .normal)
        }
    }
    
    var rightImageURL: (imageURL: String?, placeHolder: UIImage?) {
        didSet {
            btnRight.imageView?.setLocalImage(with: rightImageURL.imageURL,
                                              placeholder: rightImageURL.placeHolder)
        }
    }
    
    @IBInspectable var rightTitle: String? {
        get {
            return btnRight.title(for: .normal)
        }
        set {
            btnRight.setTitle(newValue, for: .normal)
        }
    }
    
    @IBInspectable var rightTitleColor: UIColor? {
        get {
            return btnRight.titleColor(for: .normal)
        }
        set {
            btnRight.setTitleColor(newValue, for: .normal)
        }
    }
    
    @IBInspectable var rightEnable: Bool {
        get {
            return btnRight.isUserInteractionEnabled
        }
        set {
            btnRight.isUserInteractionEnabled = newValue
        }
    }
    
    override func didLoadFromNib() {
        super.didLoadFromNib()
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
