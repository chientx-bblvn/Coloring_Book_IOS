//
//  ColorCell.swift
//  Doll-Coloring
//
//  Created by Việt Anh Nguyễn on 18/4/24.
//

import UIKit
import Reusable

class ColorCell: UICollectionViewCell, NibReusable {
    
    @IBOutlet weak var viewContent: UIView!
    
    @IBOutlet weak var boderView: UIView!
    
    @IBOutlet weak var viewColor: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        viewColor.layer.cornerRadius = viewColor.frame.height / 2
        viewContent.layer.cornerRadius = viewContent.frame.height / 2
        boderView.layer.cornerRadius = boderView.frame.height / 2
    }
    
    
    func setData(color: UIColor?, isSelect: Bool) {
        viewColor.backgroundColor = color
        viewContent.backgroundColor = color
        boderView.layer.borderColor = color?.cgColor
        viewContent.isHidden = isSelect
    }
    
    

}
