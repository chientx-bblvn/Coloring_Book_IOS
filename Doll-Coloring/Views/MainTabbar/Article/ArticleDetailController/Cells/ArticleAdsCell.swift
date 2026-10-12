//
//  ArticleAdsCell.swift
//  Stub — ads removed
//

import UIKit
import Reusable

class ArticleAdsCell: UITableViewCell, NibReusable {
    @IBOutlet weak var viewAds: UIView!
    var onLoadAd: ((Bool) -> Void)?
    func loadAds() {
        viewAds?.isHidden = true
        onLoadAd?(false)
    }
}
