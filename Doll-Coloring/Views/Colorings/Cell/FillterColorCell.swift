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
        imageView.layer.cornerRadius = 19
        viewContent.layer.cornerRadius = 26
    }
    
    func setupData(_ index: Int, isSelect: Bool) {
        imageView.image = images[index].image
        imageView.backgroundColor = UIColor(hexString: "FFFFFF").withAlphaComponent(0.3)
        imageView.layer.borderWidth = isSelect ? 2 : 0
        imageView.layer.borderColor = isSelect ? UIColor(hexString: "8EF3FF").cgColor : nil
//        viewContent.layer.borderWidth = isSelect ? 2 : 0
//        viewContent.layer.borderColor = isSelect ? UIColor(hexString: "8EF3FF").cgColor : nil
    }

}
