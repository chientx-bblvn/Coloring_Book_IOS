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
        viewContainer.layer.borderWidth = selected ? 1.5 : 1
        viewContainer.layer.borderColor = UIColor(hexString: selected ? "FF5D8F" : "FFC3D2").cgColor
        viewContainer.layer.shadowColor = UIColor(hexString: "C13F68").cgColor
        viewContainer.layer.shadowOpacity = 0.06
        viewContainer.layer.shadowRadius = 3
        viewContainer.layer.shadowOffset = CGSize(width: 0, height: 1)
        lbName.textColor = UIColor(hexString: "5B5056")
        imgSelect.contentMode = .scaleAspectFit
        if selected {
            viewContainer.backgroundColor = UIColor(hexString: "FFB8CC")
            imgSelect.image = UIImage(systemName: "checkmark.circle.fill")
            imgSelect.tintColor = .white
        } else {
            viewContainer.backgroundColor = UIColor(hexString: "FFF1F5")
            imgSelect.image = UIImage(systemName: "circle")
            imgSelect.tintColor = UIColor(hexString: "A9A1A5")
        }
    }
}
