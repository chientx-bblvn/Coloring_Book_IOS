//
//  ListTopPicksColoringViewController.swift
//  Doll-Coloring
//
//  Created by Việt Anh Nguyễn on 10/04/2024.
//

import UIKit

class ListTopPicksColoringViewController: UIViewController {
    
    @IBOutlet weak var listFilter: UICollectionView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var colorings: [ColoringModel] = []
    private var listCategory: [String] = []
    private var coloring: [ColoringImage] = []
    private var coloringLocal: [ColoringHistoryModel] = []
    private var indexFillter: Int = 0
    private var numberClick: Int = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        coloringLocal = SQLiteManager.shared.selectionColorings()
        collectionView.reloadData()
    }
    
    public func reloadData(data: [ColoringModel]) {
        colorings = data
        listCategory = []
        coloring = []
        let dispathGroup = DispatchGroup()
        dispathGroup.enter()
        data.enumerated().forEach { (index, image) in
            if index == 0 {
                listCategory.append("All")
            }
            listCategory.append(image.categoryName ?? "")
            coloring.append(contentsOf: image.imageUrls ?? [])
        }
        dispathGroup.leave()
        listFilter.reloadData()
        collectionView.reloadData()
    }
    
    
    private func setupCollectionView() {
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        collectionView.register(cellType: AllColoringCell.self)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        listFilter.register(cellType: FillterCell.self)
        listFilter.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        listFilter.delegate = self
        listFilter.dataSource = self
    }
    
    func fillterCategory(index: Int) {
        coloring = []
        let dispathGroup = DispatchGroup()
        dispathGroup.enter()
        if index == 0 {
            colorings.enumerated().forEach { (index, image) in
                coloring.append(contentsOf: image.imageUrls ?? [])
            }
        } else {
            coloring = colorings.first(where: {$0.categoryName == listCategory[index]})?.imageUrls ?? []
        }
        dispathGroup.leave()
        collectionView.reloadData()
    }
}

extension ListTopPicksColoringViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == listFilter {
            return listCategory.count
        } else {
            return coloring.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == listFilter {
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: FillterCell.self)
            cell.setupView(title: listCategory[indexPath.row], isSelected: indexPath.row == indexFillter)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: AllColoringCell.self)
            cell.setupView(image: coloring[indexPath.row].filePath, coloringLocal: coloringLocal)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == listFilter {
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            indexFillter = indexPath.row
            fillterCategory(index: indexPath.row)
            collectionView.reloadData()
        } else {
            let data = coloring[indexPath.row]
            numberClick += 1
            guard numberClick < UserDefaultManager.numberClickItemAllTopic  else {
                if let colorLocal = SQLiteManager.shared.selectionColorings().first(where: {$0.filePath == data.filePath}) {
                    AppRouter.shared.navigate(to: HistoryColoringRoute.main(coloring: colorLocal), with: .modal)
                } else {
                    AppRouter.shared.navigate(to: PreviewColoringRoute.main(coloring: data, coloringLocal: nil, history: nil), with: .modal)
                }
                return
            }
            ADManager.shared.loadFull(DollColoringAdID.inter_alltopic) { status in
                switch status {
                case .closed, .error:
                    if let colorLocal = SQLiteManager.shared.selectionColorings().first(where: {$0.filePath == data.filePath}) {
                        AppRouter.shared.navigate(to: HistoryColoringRoute.main(coloring: colorLocal), with: .modal)
                    } else {
                        AppRouter.shared.navigate(to: PreviewColoringRoute.main(coloring: data, coloringLocal: nil, history: nil), with: .modal)
                    }
                default:
                    break
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == listFilter {
            let index = indexPath.row
            let item = listCategory[index]
            let widthF = item.trimmingCharacters(in: .whitespaces).width(withConstrainedHeight: 8, font: UIFont.systemFont(ofSize: 14))
            return CGSize(width: 32 + widthF, height: listFilter.frame.height)
        } else {
            let width = (collectionView.frame.width - 40) / 2
            return CGSize(width: width, height: width * 1.2)
        }
    }
}

