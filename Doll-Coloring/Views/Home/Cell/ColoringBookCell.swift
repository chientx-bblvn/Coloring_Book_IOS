//
//  ColoringBookCell.swift
//  Doll-Coloring
//
//  Created by Tiến Đoàn on 11/3/25.
//

import UIKit

class ColoringBookCell: UITableViewCell {
    
    @IBOutlet weak var lbCategory: UILabel!
    
    @IBOutlet weak var coloringCollectionView: UICollectionView!
    
    var itemColoring: [ColoringImage] = [] {
        didSet {
            coloringCollectionView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpView()
    }
    
    private func setUpView() {
        self.coloringCollectionView.dataSource = self
        self.coloringCollectionView.delegate = self
        coloringCollectionView.register(cellType: AllColoringCell.self)
        
        if let layout = coloringCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 8
            layout.minimumInteritemSpacing = 8
        }
    }
    
    func setupCell(title: String, itemColoring: [ColoringImage]) {
        self.itemColoring = itemColoring
        let drawingsText = NSLocalizedString("Drawings", comment: "The word 'Drawings' in category label")
        let fullText = "\(title) (\(itemColoring.count) \(drawingsText))"
        let attributedString = NSMutableAttributedString(string: fullText)
        let rangeTitle = (fullText as NSString).range(of: title)
        attributedString.addAttributes([.font: UIFont.boldSystemFont(ofSize: 20)], range: rangeTitle)
        let rangeCount = (fullText as NSString).range(of: "\(itemColoring.count) \(drawingsText)")
        attributedString.addAttributes([.font: UIFont.systemFont(ofSize: 16)], range: rangeCount)
        lbCategory.attributedText = attributedString
    }
    
    
}
extension ColoringBookCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemColoring.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: AllColoringCell.self)
        let data = itemColoring[indexPath.row]
        cell.setupView(image: data.filePreview, coloringLocal: [], filePath: data.filePath, isDaily: false, index: indexPath.row)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width - 32
        let itemWidth = (Int(width) - 8) / 2
        return CGSize(width: itemWidth, height: itemWidth)
    }
    
}
