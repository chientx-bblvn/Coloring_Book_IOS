//
//  EmptyView.swift
// Doll-Coloring
//
//  Created by BBLabs on 12/15/19.
//  Copyright © 2019 BBLabs.All rights reserved.
//

import Reusable
import UIKit

class EmptyView: UITableViewCell, NibReusable {
   
    @IBOutlet private weak var labelDescription: UILabel!
    @IBOutlet private weak var btnView: ButtonView!
    var onClickButton: (() -> Void)?
    
    class func createViewFromNib() -> EmptyView? {
        let bundle = Bundle(for: EmptyView.self)
        let nib = UINib(nibName: "EmptyView", bundle: bundle)
        return nib.instantiate(withOwner: EmptyView.self, options: nil).first as? EmptyView
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        btnView.setOnClickListener {
            self.onClickButton?()
        }
    }
    
    func loadData(_ description: String = "",
                  descriptionColor: UIColor = "#9DB2CE".hexStringToUIColor(),
                  font: UIFont = .systemFont(ofSize: 14),
                  titleButton: String = "",
                  actionButton: (() -> Void)? = nil) {
        self.btnView.isHidden = titleButton.isEmpty
        self.btnView.title = titleButton
        self.onClickButton = actionButton
        if !description.isEmpty {
            labelDescription.font = font
            labelDescription.isHidden = false
            labelDescription.text = description
            labelDescription.textColor = .black
            labelDescription.textColor = descriptionColor
        } else {
            labelDescription.isHidden = true
        }
        self.layoutIfNeeded()
    }
    
}
