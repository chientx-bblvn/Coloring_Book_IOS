//
//  PageViewSwirlViewController.swift
//  Doll-Coloring
//
//  Created by Việt Anh Nguyễn on 10/7/24.
//

import UIKit

class PageViewSwirlViewController: BaseViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    var itemColoring: [ColoringImage] = []
    var categoryName: String?
    var totalDays: Int = 0
    
    private var coloringLocal: [ColoringHistoryModel] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    private var hasAd = false
    
    var onClickItem: ((ColoringImage, String, Int) -> Void)?
    var handleScrollView: ((UIScrollView) -> Void)?
    
    private var isLandscape: Bool = false
    
    override func setup() {
        super.setup()
        setupView()
        InappManager.share.didPaymentSuccess.subscribe { _ in
            self.collectionView.reloadData()
        }.disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        hasAd = false
//        loadNativeAds()
        coloringLocal = SQLiteManager.shared.selectionColorings()
        
    }
    
    
    
    override func updateMorePortrait() {
        super.updateMorePortrait()
        updateLayoutContent()
    }
    
    override func updateMoreLandscape() {
        super.updateMoreLandscape()
        updateLayoutContent()
    }
    
    func setupView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(cellType: AllColoringCell.self)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 20, right: 16)
        updateLayoutContent()
    }
    
    private func updateLayoutContent() {
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
        collectionView.reloadData()
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
}

extension PageViewSwirlViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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
                        cell.adsViewAnimation.isHidden = true
                    } else {
                        cell.viewWatchAds.isHidden = true
                        cell.adsViewAnimation.isHidden = true
                    }
                } else {
                    cell.viewWatchAds.isHidden = true
                    if data.isPremium ?? false {
                        cell.adsViewAnimation.isHidden = true
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
                    cell.viewWatchAds.isHidden = true
                } else {
                    cell.viewWatchAds.isHidden = true
                }
            }
            return cell
        }
        if indexPath.row == 3 {
            return UICollectionViewCell()
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
                        cell.adsViewAnimation.isHidden = true
                    } else {
                        cell.viewWatchAds.isHidden = true
                        cell.adsViewAnimation.isHidden = true
                    }
                } else {
                    cell.viewWatchAds.isHidden = true
                    if data.isPremium ?? false {
                        cell.adsViewAnimation.isHidden = true
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
                    cell.viewWatchAds.isHidden = true
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
        if UIDevice.current.userInterfaceIdiom == .pad {
            if isLandscape {
                return CGSize(width: (Int(width) - 42) / 5, height: Int(width / 5))
            } else {
                return CGSize(width: (Int(width) - 34) / 4, height: Int(width / 4))
            }
        }
        return CGSize(width: (Int(width) - 8) / 2, height: Int(width * 0.65))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        handleScrollView?(scrollView)
    }
    
}
