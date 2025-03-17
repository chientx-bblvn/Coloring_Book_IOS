//
//  HistoryCellCollectionViewCell.swift
//  Doll-Coloring
//
//  Created by Việt Anh Nguyễn on 17/4/24.
//

import UIKit
import Reusable

class HistoryCellCollectionViewCell: FSPagerViewCell, NibReusable {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var progressRing: ALProgressRing!
    @IBOutlet weak var lbPercent: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        progressRing.lineWidth = 5
        
    }

}
