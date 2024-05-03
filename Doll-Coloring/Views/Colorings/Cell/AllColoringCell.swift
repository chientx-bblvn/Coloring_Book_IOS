//
//  AllColoringCell.swift
//  Doll-Coloring
//
//  Created by Việt Anh Nguyễn on 15/4/24.
//

import UIKit
import Reusable
import SDWebImage

class AllColoringCell: UICollectionViewCell, NibReusable {

    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupView(image: String?, coloringLocal: [ColoringHistoryModel]) {
        if let coloring = coloringLocal.first(where: {$0.filePath.contains(image ?? "")}) {
            if let file = coloring.historys.first?.imagePath {
                let imageUrlString = FileManagerLocal.shared.getFileFoderFileUssing(typeFile: .ColoringSave, file: file)
                let cacheKey = SDWebImageManager.shared.cacheKey(for: imageUrlString)
                imageView.setLocalImage(with: imageUrlString.path, placeholder: nil)
            } else {
                SQLiteManager.shared.deleteColorings(id: coloring.id)
                FileManagerLocal.shared.deleteFile(typeFile: .Coloring, fileName: coloring.fileLocal)
                imageView.setImage(with: "/doll-coloring/" + (image ?? ""), placeholder: nil)
            }
        } else {
            imageView.setImage(with: "/doll-coloring/" + (image ?? ""), placeholder: nil)
        }
        
    }
}
