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
        let width = 40
        viewColor.layer.cornerRadius = CGFloat((width - 10) / 2)
        viewContent.layer.cornerRadius = CGFloat(width / 2)
        boderView.layer.cornerRadius = CGFloat(width / 2)
    }
    
    
    func setData(color: UIColor?, isSelect: Bool) {
        viewColor.backgroundColor = color
        viewContent.backgroundColor = color
        boderView.layer.borderColor = color?.cgColor
        viewContent.isHidden = isSelect
        
    }
    
    func setupCornerRadius(_ width: CGFloat = 30) {
        viewColor.layer.cornerRadius = (width - 10) / 2
        viewContent.layer.cornerRadius = width / 2
        boderView.layer.cornerRadius = width / 2
    }
    
    

}
