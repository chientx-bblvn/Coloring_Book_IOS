//
//  ToastView.swift
// Doll-Coloring
//
//  Created by BBLabs on 17/04/2023.
//  Copyright © 2024 BBLabs. All rights reserved.
//

import UIKit

class ToastView: BaseCustomXibView {
    
    static let shared: ToastView = {
        let toastView = ToastView()
        toastView.translatesAutoresizingMaskIntoConstraints = false
        toastView.alpha = 0
        return toastView
    }()
    var work = DispatchWorkItem {
        ToastView.shared.removeFromSuperview()
    }
    
    enum TypeToast {
        case success
        case error
        
        var image: UIImage? {
            switch self {
            case .success:
                return nil// TODO: R.image.checkmarkCircleWhite()
            case .error:
                return nil// TODO: R.image.closeCircleWhite()
            }
        }
        
        var backgroundColor: UIColor? {
            switch self {
            case .success:
                return .systemGreen
            case .error:
                return R.color.systemRed() ?? .systemRed
            }
        }
    }
    
    @IBOutlet private weak var imageView: UIImageView?
    @IBOutlet private weak var lblTitle: UILabel?
    
    var type: TypeToast = .success {
        didSet {
            setupView()
        }
    }
    var titleToast = "" {
        didSet {
            setupView()
        }
    }
    
    override func didLoadFromNib() {
        super.didLoadFromNib()
        setupView()
    }
    
    private func setupView() {
        contentView?.backgroundColor = type.backgroundColor
        imageView?.image = type.image
        lblTitle?.text = titleToast
    }

}
