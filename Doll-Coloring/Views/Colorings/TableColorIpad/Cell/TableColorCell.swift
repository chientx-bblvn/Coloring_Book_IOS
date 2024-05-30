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
    
    @IBOutlet weak var listColor: UICollectionView!
    
    @IBOutlet weak var lblName: UILabel!
    
    private var colors: [ItemColor?] = []
    
    private var width: CGFloat = 0
    
    var selectColor: ((Int) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        listColor.delegate = self
        listColor.dataSource = self
        listColor.register(cellType: ColorCell.self)
    }
    
    func setupData(data: [ItemColor?], width: CGFloat ) {
        colors = data
        self.width = width
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
        let data = colors[indexPath.row]
        if let hex = data?.hex {
            cell.setData(color: UIColor(hexString: hex), isSelect: false)
        } else {
            cell.setData(color: data?.color, isSelect: false)
        }
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectColor?(indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 40, height: 40)
    }
    
}
