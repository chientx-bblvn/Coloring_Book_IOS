//
//  MainTabbarViewController.swift
//  Doll-Coloring
//
//  Created by Tiến Đoàn on 10/3/25.
//

import UIKit
import BmoViewPager
import AdmobSDK

class MainTabbarViewController: BaseViewController {
    
    @IBOutlet weak var viewContainer: BmoViewPager!
    
    @IBOutlet weak var viewColoringBooks: UIView!
    
    @IBOutlet weak var imgColoringBook: UIImageView!
    
    @IBOutlet weak var ContraintHeightGame: NSLayoutConstraint!
    
    @IBOutlet weak var lbColoringBooks: UILabel!
    
    @IBOutlet weak var pointColoringBooks: UIView!
    
    @IBOutlet weak var viewCollection: UIView!
    
    @IBOutlet weak var imgCollection: UIImageView!
    
    @IBOutlet weak var contraintHeightEmoji: NSLayoutConstraint!
    
    @IBOutlet weak var lbCollection: UILabel!
    
    @IBOutlet weak var pointCollection: UIView!
    
    @IBOutlet weak var viewSettings: UIView!
    
    @IBOutlet weak var contraintHeightSettings: NSLayoutConstraint!
    
    @IBOutlet weak var imgSetting: UIImageView!
    
    @IBOutlet weak var lbSettings: UILabel!
    
    @IBOutlet weak var pointSettings: UIView!
    
    @IBOutlet weak var tabbarView: UIView!
    
    
    let coloringBookController = HomeRoute.main.screen
    let collectionController = CollectionsRoute.main(navigate: false).screen
    let settingController = SettingsRoute.main.screen
    
    override func setup() {
        super.setup()
        setupView()
    }
    override func onLanguageChange() {
        super.onLanguageChange()
    }
    
    private func setupView() {
        viewContainer.delegate = self
        viewContainer.dataSource = self
        viewContainer.scrollable = false
        viewContainer.presentedPageIndex = 0
        viewColoringBooks.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(changeTabbar(_ :))))
        viewColoringBooks.isUserInteractionEnabled = true
        viewCollection.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(changeTabbar(_ :))))
        viewCollection.isUserInteractionEnabled = true
        viewSettings.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(changeTabbar(_ :))))
        viewSettings.isUserInteractionEnabled = true
        
        tabbarView.layer.backgroundColor = UIColor(hexString: "98A3F3").cgColor
        tabbarView.customGenerateOuterShadow(shadowOpacity: 1, shadowRadius: 0, color: UIColor(hexString: "000000"), shadowOffset: CGSize(width: 4, height: 4))
        loadLanguage()
        pointColoringBooks.isHidden = false
        imgColoringBook.image = R.image.ic_diary_gold()
        lbColoringBooks.textColor = UIColor(hexString: "FEF08A")
        pointCollection.isHidden = true
        imgCollection.image = R.image.ic_collection_dark()
        lbCollection.textColor = UIColor(hexString: "000000")
        
        pointSettings.isHidden = true
        imgSetting.image = R.image.ic_setting_dark()
        lbSettings.textColor = UIColor(hexString: "000000")
        
    }
    private func loadLanguage() {
        lbColoringBooks.text = LocalizableUtils.commonColoringBooks()
        lbCollection.text = LocalizableUtils.commonCollections()
        lbSettings.text = LocalizableUtils.commonSettings()

    }
    
    @objc private func changeTabbar(_ gesture: UIGestureRecognizer) {
        let view = gesture.view
        pointColoringBooks.isHidden = true
        imgColoringBook.image = R.image.ic_diary_dark()
        lbColoringBooks.textColor = UIColor(hexString: "000000")
        pointCollection.isHidden = true
        imgCollection.image = R.image.ic_collection_dark()
        lbCollection.textColor = UIColor(hexString: "000000")
        pointSettings.isHidden = true
        imgSetting.image = R.image.ic_setting_dark()
        lbSettings.textColor = UIColor(hexString: "000000")
        switch view?.restorationIdentifier {
        case viewColoringBooks.restorationIdentifier:
            pointColoringBooks.isHidden = false
            imgColoringBook.image = R.image.ic_diary_gold()
//            ContraintHeightGame.constant = 54
            lbColoringBooks.textColor = UIColor(hexString: "FEF08A")
            viewContainer.presentedPageIndex = 0
            lbColoringBooks.text = LocalizableUtils.commonColoringBooks()
        case viewCollection.restorationIdentifier:
            pointCollection.isHidden = false
            imgCollection.image = R.image.ic_collection_gold()
            lbCollection.textColor = UIColor(hexString: "FEF08A")
//            contraintHeightEmoji.constant = 54
            viewContainer.presentedPageIndex = 1
            lbCollection.text = LocalizableUtils.commonCollections()
        case viewSettings.restorationIdentifier:
            pointSettings.isHidden = false
           
            viewContainer.presentedPageIndex = 2
            lbSettings.textColor = UIColor(hexString: "FEF08A")
            imgSetting.image = R.image.ic_setting_gold()
            lbSettings.text = LocalizableUtils.commonSettings()
        default:
            break
        }
        
    }
}
extension MainTabbarViewController: BmoViewPagerDelegate, BmoViewPagerDataSource {
    func bmoViewPagerDataSourceNumberOfPage(in viewPager: BmoViewPager) -> Int {
        return 3
    }
    
    func bmoViewPagerDataSource(_ viewPager: BmoViewPager, viewControllerForPageAt page: Int) -> UIViewController {
        switch page {
        case 0:
            return coloringBookController
        case 1:
            return collectionController
        case 2:
            return settingController
        default:
            return UIViewController()
        }
    }
    
    
}
