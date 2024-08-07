//
//  DetailColoringController.swift
//  Doll-Coloring
//
//  Created by Việt Anh Nguyễn on 7/5/24.
//  
//

import Foundation
import RxSwift
import UIKit
import SDWebImage
import AVFoundation

enum BackToScreenType {
    case home
    case coloring
    case detailColoring
    case collection
}

class DetailColoringController: BaseViewController {
    
    @IBOutlet weak var topBarView: TopBarView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var adsView: UIView!
    
    @IBOutlet weak var heightAds: NSLayoutConstraint!
    
    let sectionInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    
    var viewModel: DetailColoringVM!
    private var numberClick: Int = 3
    private var coloringLocal: [ColoringHistoryModel] = []
    
    
    override func setup() {
        super.setup()
        setupView()
    }

    override func bindingData() {
        super.bindingData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        coloringLocal = SQLiteManager.shared.selectionColorings()
        collectionView.reloadData()
    }
    
    func setupView() {
        topBarView.title = viewModel.coloring.categoryName?.capitalized ?? ""
        topBarView.titleFont = UIFont.systemFont(ofSize: 20, weight: .bold)
        topBarView.onLeftClick = {
            AppRouter.shared.dismissDetail()
        }
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.contentInset = sectionInsets
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(cellType: AllColoringCell.self)
    }
}

extension DetailColoringController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.coloring.imageUrls?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: AllColoringCell.self)
        let data = viewModel.coloring.imageUrls?[indexPath.row]
        if data?.isPremium ?? false {
            cell.adsViewAnimation.isHidden = false
            cell.loadAnimationAds()
        } else {
            cell.adsViewAnimation.isHidden = true
        }
        cell.setupView(image: data?.filePreview, coloringLocal: coloringLocal, filePath: data?.filePath, index: indexPath.row)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let data = viewModel.coloring.imageUrls?[indexPath.row] else {return}
        guard !(data.isPremium ?? false) else {
            guard SQLiteManager.shared.selectionColoringsRew().first(where: {$0.filePath == data.filePath}) == nil else {
                if let colorLocal = SQLiteManager.shared.selectionColorings().first(where: {$0.filePath == data.filePath}) {
                    AppRouter.shared.navigate(to: HistoryColoringRoute.main(coloring: colorLocal, typeScreen: .detailColoring, coloringAPI: data), with: .modal)
                } else {
                    AppRouter.shared.navigate(to: PreviewColoringRoute.main(coloring: data, coloringLocal: nil, history: nil, typeScreen: .detailColoring), with: .modal)
                }
                return
            }
            ADManager.shared.loadReward(DollColoringAdID.reward_alltopic) { status in
                switch status {
                case .closed:
                    SQLiteManager.shared.insertTableColoringRew(data: data)
                    if let colorLocal = SQLiteManager.shared.selectionColorings().first(where: {$0.filePath == data.filePath}) {
                        AppRouter.shared.navigate(to: HistoryColoringRoute.main(coloring: colorLocal, typeScreen: .detailColoring, coloringAPI: data), with: .modal)
                    } else {
                        AppRouter.shared.navigate(to: PreviewColoringRoute.main(coloring: data, coloringLocal: nil, history: nil, typeScreen: .detailColoring), with: .modal)
                    }
                case .error:
                    if let colorLocal = SQLiteManager.shared.selectionColorings().first(where: {$0.filePath == data.filePath}) {
                        AppRouter.shared.navigate(to: HistoryColoringRoute.main(coloring: colorLocal, typeScreen: .detailColoring, coloringAPI: data), with: .modal)
                    } else {
                        AppRouter.shared.navigate(to: PreviewColoringRoute.main(coloring: data, coloringLocal: nil, history: nil, typeScreen: .detailColoring), with: .modal)
                    }
                default:
                    break
                }
            }
            return
        }
        numberClick += 1
        guard numberClick >= UserDefaultManager.numberClickItemAllTopic  else {
            if let colorLocal = SQLiteManager.shared.selectionColorings().first(where: {$0.filePath == data.filePath}) {
                AppRouter.shared.navigate(to: HistoryColoringRoute.main(coloring: colorLocal, typeScreen: .detailColoring, coloringAPI: data ), with: .modal)
            } else {
                AppRouter.shared.navigate(to: PreviewColoringRoute.main(coloring: data, coloringLocal: nil, history: nil, typeScreen: .detailColoring), with: .modal)
            }
            return
        }
        ADManager.shared.loadFull(DollColoringAdID.inter_alltopic, isSplash: true) { status in
            switch status {
            case .closed, .error:
                self.numberClick = 0
                if let colorLocal = SQLiteManager.shared.selectionColorings().first(where: {$0.filePath == data.filePath}) {
                    AppRouter.shared.navigate(to: HistoryColoringRoute.main(coloring: colorLocal, typeScreen: .detailColoring, coloringAPI: data), with: .modal)
                } else {
                    AppRouter.shared.navigate(to: PreviewColoringRoute.main(coloring: data, coloringLocal: nil, history: nil, typeScreen: .detailColoring), with: .modal)
                }
            default:
                break
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = ((UIScreen.main.bounds.width - 40) / 2)
        return CGSize(width: width, height: width * 1.2)
    }
}
