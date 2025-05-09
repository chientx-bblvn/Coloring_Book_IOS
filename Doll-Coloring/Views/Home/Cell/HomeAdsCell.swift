//
//  HomeAdsCell.swift
//  Doll-Coloring
//
//  Created by Việt Anh Nguyễn on 6/5/24.
//

import UIKit
import Reusable

class HomeAdsCell: UICollectionViewCell, NibReusable {

    @IBOutlet weak var adsView: UIView!
    
    var actionAds: ((Bool) -> Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        adsView.layer.borderWidth = 0
        adsView.generateOuterShadow()
        adsView.layer.cornerRadius = 16

    }
    
}
