//
//  CategoryMenuCell.swift
//  Doll-Coloring
//
//  Created by Việt Anh Nguyễn on 20/5/24.
//

import UIKit
import Reusable

class CategoryMenuCell: UICollectionViewCell, NibReusable {
    
    @IBOutlet weak var viewContent: UIView!
    
    @IBOutlet weak var lbContent: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupData(isSelect: Bool, title: String?) {
        lbContent.textColor = isSelect ? .white : R.color.colorTitle()
        viewContent.backgroundColor = isSelect ? R.color.mainPrimary() : .clear
        lbContent.text = title
    }

}
