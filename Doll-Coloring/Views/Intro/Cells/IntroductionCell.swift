//
//  IntroductionCell.swift
//  Doll-Coloring
//
//  Created by BBLabs on 13/08/2023.
//

import UIKit
import Reusable

class IntroductionCell: FSPagerViewCell, NibReusable {
    
    @IBOutlet private weak var imageviewIntro: UIImageView!
    @IBOutlet private weak var lbTitle: UILabel!
    @IBOutlet private weak var lbSubTitle: UILabel!
    
    func loadData(intro: IntroModel) {
        imageviewIntro.image = intro.image
         lbTitle.text = intro.name
         lbSubTitle.text = intro.desc
    }
    
}
