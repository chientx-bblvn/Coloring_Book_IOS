//
//  HomeHeaderCell.swift
//  PetTranslate-iOS
//
//  Created by BBLabs on 13/08/2023.
//

import UIKit
import Reusable

class ArticleAdsCell: UITableViewCell, NibReusable {

    @IBOutlet weak var viewAds: UIView!
    var onLoadAd: ((_ loaded: Bool) -> Void)?
    
    func loadAds() {
        self.viewAds.isHidden = true
        if PetAdID.NativeArticle.isEnableAd {
            self.viewAds.isHidden = false
            ADManager.shared.loadNative(PetAdID.NativeArticle, to: self.viewAds, { [weak self] success in
                self?.viewAds.isHidden = !success
                self?.onLoadAd?(success)
                self?.layoutIfNeeded()
            })
        }
        self.layoutIfNeeded()
    }
}
