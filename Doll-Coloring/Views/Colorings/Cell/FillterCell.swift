//
//  FillterCell.swift
//  Doll-Coloring
//
//  Created by Việt Anh Nguyễn on 15/4/24.
//

import UIKit
import Reusable

class FillterCell: UICollectionViewCell, NibReusable {

    
    @IBOutlet weak var viewContent: UIView!
    
    @IBOutlet weak var lbTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func setupView(title: String?, isSelected: Bool) {
        lbTitle.text = title?.replacingOccurrences(of: "_", with: " ").capitalized
        lbTitle.textColor = isSelected ? .white : R.color.colorTextTopBar()
        lbTitle.font = UIFont.systemFont(ofSize: 14, weight: isSelected ? .bold : .regular)
        viewContent.backgroundColor = isSelected ? R.color.colorTextTopBar() : .clear
    }

}
