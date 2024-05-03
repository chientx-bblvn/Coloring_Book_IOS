//
//  FillterColorCell.swift
//  Doll-Coloring
//
//  Created by Việt Anh Nguyễn on 18/4/24.
//

import UIKit
import Reusable

enum ImageFilterCell: CaseIterable {
    case Bling
    case Butterfly
    case BlingBling
    case SnowFlakes
    case Bling3
    case Bubble
    case Snow
    
    var image: UIImage? {
        switch self {
        case .Bling:
           return R.image.ic_Bling()
        case .Butterfly:
            return R.image.ic_Butterfly()
        case .BlingBling:
            return R.image.ic_BlingBling()
        case .SnowFlakes:
            return R.image.ic_SnowFlakes()
        case .Bling3:
            return R.image.ic_Bling3()
        case .Bubble:
            return R.image.ic_Bubble()
        case .Snow:
            return R.image.ic_Snow()
        }
    }
}

class FillterColorCell: UICollectionViewCell, NibReusable {

    @IBOutlet weak var viewContent: UIView!
    @IBOutlet weak var imageView: UIImageView!
    
    let images = ImageFilterCell.allCases
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imageView.layer.cornerRadius = 15
        viewContent.layer.cornerRadius = 22
    }
    
    func setupData(_ index: Int, isSelect: Bool) {
        imageView.image = images[index].image
        imageView.backgroundColor = isSelect ? UIColor(hexString: "C3A0F1") : .clear
        imageView.layer.borderWidth = isSelect ? 0 : 1
        imageView.layer.borderColor = UIColor(hexString: "C3A0F1").cgColor
        viewContent.layer.borderWidth = isSelect ? 7 : 0
        viewContent.layer.borderColor = isSelect ? UIColor(hexString: "A968FF").cgColor : nil
    }

}
