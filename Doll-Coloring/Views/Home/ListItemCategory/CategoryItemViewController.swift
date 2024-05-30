//
//  CategoryItemViewController.swift
//  Doll-Coloring
//
//  Created by Việt Anh Nguyễn on 29/5/24.
//

import UIKit

class CategoryItemViewController: BaseViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var isLandscape: Bool = false {
        didSet {
            let rotation = UIApplication.shared.windows.first?.windowScene?.interfaceOrientation
            switch rotation {
            case .unknown:
                break
            case .portrait, .portraitUpsideDown:
                isLandscape = false
            case .landscapeLeft, .landscapeRight:
                isLandscape = true
            default:
                break
            }
        }
    }
    
    var coloring: ColoringModel?
    private var coloringLocal: [ColoringHistoryModel] = []
   
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    convenience init(coloring: ColoringModel) {
        self.init(nibName: "CategoryItemViewController", bundle: nil)
        self.coloring = coloring
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        collectionView.reloadData()
    }
    
    override func updateMorePortrait() {
        super.updateMorePortrait()
        updateLayoutContent()
    }
    
    override func updateMoreLandscape() {
        super.updateMoreLandscape()
        updateLayoutContent()
    }
    
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 20, right: 16)
        collectionView.register(cellType: AllColoringCell.self)
    }
    
    private func updateLayoutContent() {
        let rotation = UIApplication.shared.windows.first?.windowScene?.interfaceOrientation
        switch rotation {
        case .unknown:
            break
        case .portrait, .portraitUpsideDown:
            isLandscape = false
            collectionView.reloadData()
        case .landscapeLeft, .landscapeRight:
            isLandscape = true
            collectionView.reloadData()
        default:
            break
        }
    }
}

extension CategoryItemViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        coloring?.imageUrls?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: AllColoringCell.self)
        let data = coloring?.imageUrls?[indexPath.row]
        cell.setupView(image: data?.filePreview, coloringLocal: coloringLocal, filePath: data?.filePath)
        if data?.isPremium ?? false {
            cell.adsViewAnimation.isHidden = false
            cell.loadAnimationAds()
        } else {
            cell.adsViewAnimation.isHidden = true
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width - 32
        if UIDevice.current.userInterfaceIdiom == .pad {
            if isLandscape {
                return CGSize(width: (Int(width) - 42) / 5, height: Int(width / 5))
            } else {
                return CGSize(width: (Int(width) - 34) / 4, height: Int(width / 4))
            }
        }
        return CGSize(width: (Int(width) - 8) / 2, height: Int(width / 2))
    }
}
