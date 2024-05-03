//
//  DetailArticleCell.swift
//  PetTranslate
//
//  Created by Lê Minh Sơn on 22/03/2024.
//

import UIKit
import Reusable

class DetailArticleCell: UITableViewCell, NibReusable {
    @IBOutlet private weak var lbTitle: UILabel!
    @IBOutlet private weak var lbDescription: UILabel!
    
    func loadData(articleDetail: SubArticleModel) {
        lbTitle.isHidden = articleDetail.title.isEmpty
        lbTitle.attributedText = articleDetail.titleLocalize
            .toAttributeString(font: R.font.fredokaSemiBold(size: 14)!,
                               alignment: .left,
                               foreground: R.color.textColor(),
                               linespace: 1.2,
                               lineHeightMultiple: 1.25)
        
        lbDescription.isHidden = articleDetail.description.isEmpty
        lbDescription.attributedText = articleDetail.descriptionLocalize
            .toAttributeString(font: R.font.rubikRegular(size: 12)!,
                               alignment: .justified,
                               foreground: R.color.textColorSecondary(),
                               linespace: 1.2,
                               lineHeightMultiple: 1.25)
    }
    
}
