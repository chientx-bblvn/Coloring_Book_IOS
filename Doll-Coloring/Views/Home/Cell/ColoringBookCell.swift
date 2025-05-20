//
//  ColoringBookCell.swift
//  Doll-Coloring
//
//  Created by Tiến Đoàn on 11/3/25.
//

import UIKit
import RxSwift

class ColoringBookCell: UITableViewCell {
    
    @IBOutlet weak var lbCategory: UILabel!
    
    @IBOutlet weak var coloringCollectionView: UICollectionView!
    
    let disposeBag = DisposeBag()
    
    var itemColoring: [ColoringImage] = []
    var categoryName:String?
    var totalDays:Int = 0
    private var hasAd = true
    
    private var nativeAdView: NativeAdProtocol? {
        didSet {
            coloringCollectionView.reloadData()
        }
    }
    private var coloringLocal: [ColoringHistoryModel] = [] {
         didSet {
             coloringCollectionView.reloadData()
         }
     }
    
    var onClickItem: ((ColoringImage, String, Int) -> Void)?
//    var handleScrollView: ((UIScrollView) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpView()
        InappManager.share.didPaymentSuccess.subscribe { _ in
            self.coloringCollectionView.reloadData()
        }.disposed(by: disposeBag)
        prepareForDisplay()
    }

    
    private func setUpView() {
        self.coloringCollectionView.dataSource = self
        self.coloringCollectionView.delegate = self
        self.coloringCollectionView.backgroundColor =  UIColor.clear
        self.lbCategory.backgroundColor = UIColor.clear
        coloringCollectionView.register(cellType: AllColoringCell.self)
        coloringCollectionView.register(cellType: HomeNativeAdsCell.self)
        
        if let layout = coloringCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 8
            layout.minimumInteritemSpacing = 8
        }
    }
//    private func loadNativeAds() {
//        ADManager.shared.loadNativeWithoutView(DollColoringAdID.native_home,
//                                               nativeAdType: .customNativeMediaHorizontal,
//                                               ratio: .portrait,
//                                               { adId, success, nativeAdView in
//            self.hasAd = success
//            self.nativeAdView = nativeAdView
//        })
//    }
    func prepareForDisplay() {
        hasAd = false
//        loadNativeAds()
        coloringLocal = SQLiteManager.shared.selectionColorings()
    }
    

    
    func setupCell(title: String, itemColoring: [ColoringImage],days:Int) {
        self.itemColoring = itemColoring
        let drawingsText = NSLocalizedString("Drawings", comment: "The word 'Drawings' in category label")
        let fullText = "\(title) (\(itemColoring.count) \(drawingsText))"
        let attributedString = NSMutableAttributedString(string: fullText)
        let rangeTitle = (fullText as NSString).range(of: title)
        attributedString.addAttributes([.font: UIFont.boldSystemFont(ofSize: 20)], range: rangeTitle)
        let rangeCount = (fullText as NSString).range(of: "\(itemColoring.count) \(drawingsText)")
        attributedString.addAttributes([.font: UIFont.systemFont(ofSize: 16)], range: rangeCount)
        lbCategory.attributedText = attributedString
        totalDays = days
    }
    
    
}
extension ColoringBookCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard hasAd else {
            return itemColoring.count
        }
        return itemColoring.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard hasAd else {
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: AllColoringCell.self)
            cell.days = totalDays
            let data = itemColoring[indexPath.row]
            if let img = data.filePreview {
                cell.setupView(image: img, coloringLocal: coloringLocal, filePath: data.filePath, isDaily: categoryName?.contains("Daily") ?? false, index: indexPath.row)
            } else {
                cell.setupView(image: data.filePath, coloringLocal: coloringLocal, filePath: data.filePath, isDaily: categoryName?.contains("Daily") ?? false, index: indexPath.row)
            }
            if UserDefaultManager.ABShowIAPColoring {
                if UserDefaultManager.ABis_free_trial_us {
                    if data.isPremium ?? false {
                        cell.viewWatchAds.isHidden = true
                        cell.adsViewAnimation.isHidden = SQLiteManager.shared.selectionColoringsRew().first(where: {$0.filePath == data.filePath}) != nil
                    } else {
                        cell.viewWatchAds.isHidden = true
                        cell.adsViewAnimation.isHidden = SQLiteManager.shared.selectionColoringsRew().first(where: {$0.filePath == data.filePath}) != nil
                    }
                } else {
                    cell.viewWatchAds.isHidden = true
                    if data.isPremium ?? false {
                        cell.adsViewAnimation.isHidden = SQLiteManager.shared.selectionColoringsRew().first(where: {$0.filePath == data.filePath}) != nil
                    } else {
                        cell.adsViewAnimation.isHidden = true
                    }
                }
                if IAPState.isUserVip {
                    cell.adsViewAnimation.isHidden = true
                    cell.viewWatchAds.isHidden = true
                }
            } else {
                cell.adsViewAnimation.isHidden = true
                
                if data.isPremium ?? false {
                    cell.viewWatchAds.isHidden = SQLiteManager.shared.selectionColoringsRew().first(where: {$0.filePath == data.filePath}) != nil
                } else {
                    cell.viewWatchAds.isHidden = true
                }
            }
            return cell
        }
        if indexPath.row == 3 {
            let nativeAdsCell = collectionView.dequeueReusableCell(for: indexPath, cellType: HomeNativeAdsCell.self)
            if hasAd {
                nativeAdsCell.loadAds(nativeAd: nativeAdView)
            }
            return nativeAdsCell
        } else {
            
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: AllColoringCell.self)
            cell.days = totalDays
            var data: ColoringImage
            if indexPath.row <= 2 {
                data = itemColoring[indexPath.row]
            } else {
                data = itemColoring[indexPath.row - 1]
            }
            if let img = data.filePreview {
                cell.setupView(image: img, coloringLocal: coloringLocal, filePath: data.filePath, isDaily: categoryName?.contains("Daily") ?? false, index: indexPath.row)
            } else {
                cell.setupView(image: data.filePath, coloringLocal: coloringLocal, filePath: data.filePath, isDaily: categoryName?.contains("Daily") ?? false, index: indexPath.row)
            }
            if UserDefaultManager.ABShowIAPColoring {
                if UserDefaultManager.ABis_free_trial_us {
                    if data.isPremium ?? false {
                        cell.viewWatchAds.isHidden = true
                        cell.adsViewAnimation.isHidden = SQLiteManager.shared.selectionColoringsRew().first(where: {$0.filePath == data.filePath}) != nil
                    } else {
                        cell.viewWatchAds.isHidden = true
                        cell.adsViewAnimation.isHidden = SQLiteManager.shared.selectionColoringsRew().first(where: {$0.filePath == data.filePath}) != nil
                    }
                } else {
                    cell.viewWatchAds.isHidden = true
                    if data.isPremium ?? false {
                        cell.adsViewAnimation.isHidden = SQLiteManager.shared.selectionColoringsRew().first(where: {$0.filePath == data.filePath}) != nil
                    } else {
                        cell.adsViewAnimation.isHidden = true
                    }
                }
                if IAPState.isUserVip {
                    cell.adsViewAnimation.isHidden = true
                    cell.viewWatchAds.isHidden = true
                }
            } else {
                cell.adsViewAnimation.isHidden = true
                
                if data.isPremium ?? false {
                    cell.viewWatchAds.isHidden = SQLiteManager.shared.selectionColoringsRew().first(where: {$0.filePath == data.filePath}) != nil
                } else {
                    cell.viewWatchAds.isHidden = true
                }
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard hasAd else {
            let data = itemColoring[indexPath.row]
            FirebaseEventManager.logEvent(with: RMBGEventTracking.start_coloring, params: ["category": categoryName?.capitalized ?? "",
                                                                                           "image": data.filePath ?? "",
                                                                                           
                                                                                           "isPremium": data.isPremium ?? false])
            
            onClickItem?(data, categoryName ?? "", indexPath.row)
            return
        }
        var data: ColoringImage
        if indexPath.row <= 2 {
            data = itemColoring[indexPath.row]
        } else if indexPath.row >= 4 {
            data = itemColoring[indexPath.row - 1]
        } else {return}
        FirebaseEventManager.logEvent(with: RMBGEventTracking.start_coloring, params: ["category": categoryName?.capitalized ?? "",
                                                                                       "image": data.filePath ?? "",
                                                                                       
                                                                                       "isPremium": data.isPremium ?? false])
        
        onClickItem?(data, categoryName ?? "", indexPath.row)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width - 32
        let itemWidth = (width - 8) / 2
        return CGSize(width: (itemWidth * 0.8), height: itemWidth)
    }
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        handleScrollView?(scrollView)
//    }
    
}
