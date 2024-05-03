//
//  ThemeCell.swift
//  Doll-Coloring
//
//  Created by Việt Anh Nguyễn on 15/4/24.
//

import UIKit
import Reusable

class ThemeCell: UICollectionViewCell, NibReusable {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var lbTitle: UILabel!
    
    @IBOutlet weak var lbTrending: UILabel!
    
    @IBOutlet weak var btnDownload: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    func setupData() {
        
    }
    
    
    @IBAction func actionDownload(_ sender: Any) {
    }
    
    
}
