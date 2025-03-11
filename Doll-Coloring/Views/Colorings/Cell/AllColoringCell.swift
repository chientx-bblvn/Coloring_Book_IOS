//
//  AllColoringCell.swift
//  Doll-Coloring
//
//  Created by Việt Anh Nguyễn on 15/4/24.
//

import UIKit
import Reusable
import SDWebImage
import Lottie

class AllColoringCell: UICollectionViewCell, NibReusable {

    @IBOutlet weak var viewContent: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var adsViewAnimation: UIImageView!
    @IBOutlet weak var progessRing: ALProgressRing!
    @IBOutlet weak var lbPercentColoring: UILabel!
    @IBOutlet weak var viewWatchAds: UIButton!
    @IBOutlet weak var showAdsDaily: UIImageView!
    
    var days: Int = 0
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        progessRing.lineWidth = 5
        viewContent.customGenerateOuterShadow(shadowOpacity: 1, shadowRadius: 0, color: UIColor(hexString: "000000"), shadowOffset: CGSize(width: 2, height: 2))
        viewContent.layer.cornerRadius = 16
        imageView.layer.cornerRadius = 16
//        viewContent.clipsToBounds = true
    }
    
    func setupView(image: String?, coloringLocal: [ColoringHistoryModel], filePath: String?, isDaily: Bool = false, index: Int) {
        showAdsDaily.isHidden = true
        if let coloring = coloringLocal.first(where: {$0.filePath.contains(filePath ?? "")}) {
            if let file = coloring.historys.last?.imagePath {
                progessRing.isHidden = false
                let imageUrlString = FileManagerLocal.shared.getFileFoderFileUssing(typeFile: .ColoringSave, file: file)
                let cacheKey = SDWebImageManager.shared.cacheKey(for: imageUrlString)
                SDImageCache.shared.removeImage(forKey: cacheKey, withCompletion: nil)
                imageView.setLocalImage(with: imageUrlString.path, placeholder: nil)
                let percent = Float(coloring.historys.last?.percent_complete ?? 0)
                progessRing.setProgress(percent, animated: true)
                lbPercentColoring.text = "\(Int((percent * 100).rounded()))%"
            } else {
                progessRing.isHidden = true
                SQLiteManager.shared.deleteColorings(id: coloring.id)
                FileManagerLocal.shared.deleteFile(typeFile: .Coloring, fileName: coloring.fileLocal)
                if isDaily {
                    if SQLiteManager.shared.selectionGitColorings().contains(where: {$0.filePath.contains(image ?? "")}) {
                        imageView.setImage(with: image, placeholder: nil)
                    } else {
                        imageView.image = R.image.ic_git_lock()
                    }
                } else {
                    imageView.setImage(with: image, placeholder: nil)
                }
            }
        } else {
            progessRing.isHidden = true
            if isDaily {
                if SQLiteManager.shared.selectionGitColorings().contains(where: {$0.filePath.contains(image ?? "")}) {
                    imageView.setImage(with: image, placeholder: nil)
                } else if index <= days {
                    showAdsDaily.isHidden = false
                    imageView.setImage(with: image, placeholder: nil)
                } else {
                    imageView.image = R.image.ic_git_lock()
                }
            } else {
                imageView.setImage(with: image, placeholder: nil)
            }
        }
    }
    
    func loadAnimationAds() {
//        adsViewAnimation.loadAnimation(file: "animation_ads_video", loopMode: .loop, autoPlay: true)
        
    }
}
