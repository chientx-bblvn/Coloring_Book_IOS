//
//  CountryCode.swift
//  Dog translator
//
//  Created by BBLabs on 3/16/23.
//  Copyright © 2021 BBLabs All rights reserved.
//

import UIKit
import Reusable

class LanguageCell: UITableViewCell, NibReusable {
    
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var imageViewFlag: UIImageView!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var imgSelect:UIImageView!

    func loadData(country: Language, selected: Bool) {
        imageViewFlag.image = country.icon
        lbName.text = country.name
        
        let width = imageViewFlag.frame.size.width
        imageViewFlag.layer.cornerRadius = width/2
        imageViewFlag.clipsToBounds = true
        viewContainer.layer.cornerRadius = 16
        viewContainer.customGenerateOuterShadow(shadowOpacity: 1, shadowRadius: 0, color: UIColor(hexString: "000000"), shadowOffset: CGSize(width: 2, height: 2))
        if selected {
            viewContainer.backgroundColor = UIColor(hexString: "FEF05A")
            imgSelect.image = UIImage(named: "ic_select_language")
        } else {
            viewContainer.backgroundColor = UIColor(hexString: "98A3F3")
            imgSelect.image = UIImage(named: "ic_unselect_language")
        }
    }
}
