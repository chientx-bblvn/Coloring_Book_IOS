//
//  CollectionCell.swift
//  Doll-Coloring
//
//  Created by Việt Anh Nguyễn on 16/4/24.
//

import UIKit
import Reusable

class CollectionCell: UICollectionViewCell, NibReusable {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var viewContent: UIView!
    
    @IBOutlet weak var viewPercent: UIView!
    
    @IBOutlet weak var labelPercent: UILabel!
    
    @IBOutlet weak var viewTrash: UIView!
    
    @IBOutlet weak var imgTrash: UIImageView!
    
    
    override func awakeFromNib() {
        viewContent.customGenerateOuterShadow(shadowOpacity: 1, shadowRadius: 0, color: UIColor(hexString: "000000"), shadowOffset: CGSize(width: 2, height: 2))
        viewContent.layer.cornerRadius = 16
        super.awakeFromNib()
        imageView.layer.cornerRadius = 16
        viewPercent.layer.borderWidth = 1
        viewPercent.layer.borderColor = UIColor.black.cgColor
        viewPercent.roundCorners(corners: [.layerMinXMinYCorner, .layerMaxXMaxYCorner], radius: 16)
        

        
        viewTrash.layer.borderWidth = 1
        viewTrash.layer.borderColor = UIColor.black.cgColor
        viewTrash.roundCorners(corners: [.layerMinXMinYCorner, .layerMaxXMaxYCorner], radius: 16)
//        imgTrash.image = UIImage(named: "ic_trash_collection")
//        imgTrash.contentMode = .scaleAspectFit
    }
    
    func setupView() {
    }
}

