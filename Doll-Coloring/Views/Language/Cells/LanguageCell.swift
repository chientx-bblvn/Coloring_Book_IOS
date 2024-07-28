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

    func loadData(country: Language, selected: Bool) {
        imageViewFlag.image = country.icon
        lbName.text = country.name
        if selected {
            viewContainer.backgroundColor = R.color.colorTextTopBar()
        } else {
            viewContainer.backgroundColor = R.color.colorBGAds()
        }
    }
}
