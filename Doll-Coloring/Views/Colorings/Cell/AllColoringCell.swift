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

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var adsViewAnimation: UIButton!
    
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupView(image: String?, coloringLocal: [ColoringHistoryModel], filePath: String?) {
        if let coloring = coloringLocal.first(where: {$0.filePath.contains(filePath ?? "")}) {
            if let file = coloring.historys.last?.imagePath {
                let imageUrlString = FileManagerLocal.shared.getFileFoderFileUssing(typeFile: .ColoringSave, file: file)
                let cacheKey = SDWebImageManager.shared.cacheKey(for: imageUrlString)
                SDImageCache.shared.removeImage(forKey: cacheKey, withCompletion: nil)
                imageView.setLocalImage(with: imageUrlString.path, placeholder: nil)
            } else {
                SQLiteManager.shared.deleteColorings(id: coloring.id)
                FileManagerLocal.shared.deleteFile(typeFile: .Coloring, fileName: coloring.fileLocal)
                imageView.setImage(with: "/doll-coloring2/canvas/" + (image ?? ""), placeholder: nil)
            }
        } else {
            imageView.setImage(with: "/doll-coloring2/canvas/" + (image ?? ""), placeholder: nil)
        }
    }
    
    func loadAnimationAds() {
//        adsViewAnimation.loadAnimation(file: "animation_ads_video", loopMode: .loop, autoPlay: true)
        
    }
}
