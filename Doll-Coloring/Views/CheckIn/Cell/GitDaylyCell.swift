//
//  GitDaylyCell.swift
//  Doll-Coloring
//
//  Created by MacBookPro on 6/8/24.
//

import UIKit
import Lottie
import Reusable
import SDWebImage


class GitDaylyCell: UICollectionViewCell, NibReusable {
    
    @IBOutlet weak var viewContainer: UIView!
    
    @IBOutlet weak var imageDaly: UIImageView!
    
    @IBOutlet weak var animationView: LottieAnimationView!
    
    var name: String = ""
    
    var onclickImage: ((String) -> Void)?
    
    var coloringLocal = SQLiteManager.shared.selectionColorings()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        viewContainer.generateOuterShadow()
        viewContainer.layer.cornerRadius = 16
        animationView.loadAnimation(file: "AnimationGitDaly", loopMode: .autoReverse)
        animationView.isUserInteractionEnabled =  true
        animationView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onClickShowGit(_ :))))
        imageDaly.isUserInteractionEnabled =  true
        imageDaly.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onClickShowImage(_ :))))
    }
    
    func loadImage(image: String) {
        if let coloring = coloringLocal.first(where: {$0.filePath.contains(image)}) {
            if let file = coloring.historys.last?.imagePath {
                let imageUrlString = FileManagerLocal.shared.getFileFoderFileUssing(typeFile: .ColoringSave, file: file)
                let cacheKey = SDWebImageManager.shared.cacheKey(for: imageUrlString)
                SDImageCache.shared.removeImage(forKey: cacheKey, withCompletion: nil)
                imageDaly.setLocalImage(with: imageUrlString.path, placeholder: nil)
            } else {
                imageDaly.setImage(with: image)
            }
        } else {
            imageDaly.setImage(with: image)
        }
        name = image
        if SQLiteManager.shared.selectionGitColorings().contains(where: {$0.filePath.contains(image)}), !animationView.isHidden{
            anmationShowItem()
        }
    }
    
    func anmationShowItem() {
        let fromView = animationView.isHidden ? imageDaly : animationView
        let toView = animationView.isHidden ? animationView : imageDaly
        
        UIView.transition(from: fromView ?? UIView(), to: toView ?? UIView(), duration: 0.6, options: [.transitionFlipFromLeft, .showHideTransitionViews], completion: nil)
        
    }
    
    @objc private func onClickShowGit(_ gesture: UIGestureRecognizer) {
        anmationShowItem()
        SQLiteManager.shared.insertTableGitColoring(_id: SQLiteManager.shared.selectionGitColorings().count, _name: name)
    }
    
    @objc private func onClickShowImage(_ gesture: UIGestureRecognizer) {
        onclickImage?(name)
    }
    
}
