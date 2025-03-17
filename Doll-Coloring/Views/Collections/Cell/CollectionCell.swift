//
//  CollectionCell.swift
//  Doll-Coloring
//
//  Created by Việt Anh Nguyễn on 16/4/24.
//

import UIKit
import Reusable
import SDWebImage

class CollectionCell: UICollectionViewCell, NibReusable {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var viewContent: UIView!
    
    @IBOutlet weak var viewPercent: UIView!
    
    @IBOutlet weak var labelPercent: UILabel!
    
    @IBOutlet weak var viewTrash: UIView!
    
    @IBOutlet weak var imgTrash: UIImageView!
    
    var trashButtonTapped: (() -> Void)?
    var navigateToDetail: (() -> Void)?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setUpView()
    }
    private func setUpView() {
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
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(trashTapped))
        viewTrash.addGestureRecognizer(tapGesture)
        viewTrash.isUserInteractionEnabled = true
        
        let navigateGesture = UITapGestureRecognizer(target: self, action: #selector(navigateGesture))
        imageView.addGestureRecognizer(navigateGesture)
        imageView.isUserInteractionEnabled = true

    }
    
    @objc func trashTapped() {
        trashButtonTapped?()
    }
    
    @objc func navigateGesture() {
        navigateToDetail?()
    }
    
}

