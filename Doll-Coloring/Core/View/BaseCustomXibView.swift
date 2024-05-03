//
//  BaseCustomXibView.swift
// Doll-Coloring
//
//  Created by BBLabs on 16/05/2023.
//  Copyright © 2024 BBLabs. All rights reserved.
//

import UIKit

class BaseCustomXibView: UIView {
    
    @IBOutlet var contentView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    fileprivate func xibSetup() {
        Bundle(for: type(of: self)).loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)
        addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            self.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
            self.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            self.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0)
        ])
        didLoadFromNib()
    }
    
    func didLoadFromNib() {}
}
