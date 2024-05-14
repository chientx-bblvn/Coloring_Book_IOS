//
//  FeatureHomeCell.swift
//  Doll-Coloring
//
//  Created by Việt Anh Nguyễn on 6/5/24.
//

import UIKit
import Reusable

class FeatureHomeCell: UICollectionViewCell, NibReusable {
    
    @IBOutlet weak var viewColoring: UIView!
    
    @IBOutlet weak var lbColoring: UILabel!
    
    @IBOutlet weak var viewCollection: UIView!
    
    @IBOutlet weak var lbCollection: UILabel!
    
    var onClickColoring: (() -> Void)?
    var onClickCollections: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        viewColoring.isUserInteractionEnabled = true
        viewCollection.isUserInteractionEnabled = true
        viewColoring.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(actionColoring)))
        viewCollection.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(actionCollections)))
    }
    
    func reloadLanguage() {
        lbColoring.text = LocalizableUtils.commonStartColoring()
        lbCollection.text = LocalizableUtils.commonCollections()
    }
    
    @objc private func actionCollections() {
        onClickCollections?()
    }
    
    @objc private func actionColoring() {
        onClickColoring?()
    }

}
