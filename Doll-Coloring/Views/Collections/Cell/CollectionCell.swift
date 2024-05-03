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
    
    @IBOutlet weak var btnEdit: UIButton!
    
    @IBOutlet weak var btnDelete: UIButton!
    
    var onclickEdit: (() -> Void)?
    var onclickDelete: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    @IBAction func actionEdit(_ sender: Any) {
        onclickEdit?()
    }
    
    @IBAction func actionDelete(_ sender: Any) {
        onclickDelete?()
    }
    
}
