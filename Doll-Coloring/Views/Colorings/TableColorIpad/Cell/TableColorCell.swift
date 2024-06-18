//
//  TableColorCell.swift
//  Doll-Coloring
//
//  Created by Việt Anh Nguyễn on 27/5/24.
//

import UIKit
import Reusable

class TableColorCell: UITableViewCell, NibReusable {
    
    @IBOutlet weak var viewContent: UIView!
    
    @IBOutlet weak var viewColor: UIView!
    
    @IBOutlet weak var listColor: UICollectionView!
    
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var btnWatchAds: UIImageView!
    
    @IBOutlet weak var viewWatchADS: UIButton!
    
    private var colors: [ItemColor?] = []
    
    private var width: CGFloat = 0
    
    var isColoring: Bool = false
    
    var selectColor: ((Int) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        listColor.delegate = self
        listColor.dataSource = self
        listColor.register(cellType: ColorCell.self)
        viewContent.generateOuterShadow()
        viewColor.layer.borderColor = R.color.colorTextTopBar()?.cgColor
    }
    
    func setupData(data: [ItemColor?], width: CGFloat, isColoring: Bool = true ) {
        colors = data
        self.width = width
        self.isColoring = isColoring
        listColor.reloadData()
    }

}

extension TableColorCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorCell", for: indexPath) as? ColorCell else {
            return UICollectionViewCell()
        }
        
        let width = isColoring ? (collectionView.frame.width - 56) / 8 : (collectionView.frame.width - 16) / 3
        let data = colors[indexPath.row]
        if let hex = data?.hex {
            cell.setData(color: UIColor(hexString: hex), isSelect: false, width: Int(width))
        } else {
            cell.setData(color: data?.color, isSelect: false, width: Int(width))
        }
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectColor?(indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = isColoring ? (collectionView.frame.width - 56) / 8 : (collectionView.frame.width - 16) / 3
        return CGSize(width: width, height: width)
    }
    
}
