//
//  CategoryColoringCell.swift
//  Doll-Coloring
//
//  Created by Việt Anh Nguyễn on 7/5/24.
//

import UIKit
import Reusable

class CategoryColoringCell: UITableViewCell, NibReusable {
    
    @IBOutlet weak var lbTitle: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var btnSellAll: UIButton!
    private var coloring: [ColoringImage] = []
    private var coloringLocal: [ColoringHistoryModel] = []
    
    var didSelectItemColoring: ((ColoringImage) -> Void)?
    
    var onClickSeeAll: (() -> Void)?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        setupCollectionView()
    }
    
    func setupCollectionView() {
        collectionView.register(cellType: AllColoringCell.self)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    func setupView(coloringLocal: [ColoringHistoryModel], coloringModel: ColoringModel) {
        self.coloringLocal = coloringLocal
        lbTitle.text = coloringModel.categoryName?.capitalized
        coloring = coloringModel.imageUrls ?? []
        collectionView.reloadData()
    }
    
    func reloadCollectionView(coloringLocal: [ColoringHistoryModel]) {
        self.coloringLocal = coloringLocal
        collectionView.reloadData()
    }
    
    @IBAction func actionSeeAll(_ sender: Any) {
        onClickSeeAll?()
    }
}

extension CategoryColoringCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return coloring.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: AllColoringCell.self)
        let data = coloring[indexPath.row]
        if data.isPremium ?? false {
            cell.adsViewAnimation.isHidden = false
            cell.loadAnimationAds()
        } else {
            cell.adsViewAnimation.isHidden = true
        }
        cell.setupView(image: coloring[indexPath.row].filePreview, coloringLocal: coloringLocal, filePath: coloring[indexPath.row].filePath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelectItemColoring?(coloring[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width - 35
        let height = collectionView.frame.height
        return CGSize(width: Int(width) / 3, height: Int(height))
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
