//
//  MainTabbarViewController.swift
//  Doll-Coloring
//
//  Created by Tiến Đoàn on 10/3/25.
//

import UIKit
import BmoViewPager

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
    
    private let selectedColor = UIColor(hexString: "C92F68")
    private let normalColor = UIColor(hexString: "9A8FA3")
    private let selectionPill = UIView()
    private var selectionPillConstraints: [NSLayoutConstraint] = []
    
    override func setup() {
        super.setup()
        setupView()
    }
    override func onLanguageChange() {
        super.onLanguageChange()
        loadLanguage()
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
        
        setupTabbarAppearance()
        loadLanguage()
        selectTab(at: 0, animated: false)
    }
    
    private func setupTabbarAppearance() {
        tabbarView.backgroundColor = .white
        tabbarView.layer.cornerRadius = tabbarView.bounds.height / 2
        tabbarView.layer.cornerCurve = .continuous
        tabbarView.layer.borderWidth = 1
        tabbarView.layer.borderColor = UIColor.black.withAlphaComponent(0.05).cgColor
        tabbarView.layer.masksToBounds = false
        tabbarView.layer.shadowColor = UIColor(hexString: "38263F").cgColor
        tabbarView.layer.shadowOpacity = 0.12
        tabbarView.layer.shadowRadius = 18
        tabbarView.layer.shadowOffset = CGSize(width: 0, height: 8)
        
        selectionPill.translatesAutoresizingMaskIntoConstraints = false
        selectionPill.backgroundColor = selectedColor.withAlphaComponent(0.1)
        selectionPill.layer.cornerRadius = (tabbarView.bounds.height - 12) / 2
        selectionPill.layer.cornerCurve = .continuous
        selectionPill.isUserInteractionEnabled = false
        tabbarView.insertSubview(selectionPill, at: 0)
        
        [pointColoringBooks, pointCollection, pointSettings].forEach { $0?.isHidden = true }
        [lbColoringBooks, lbCollection, lbSettings].forEach {
            $0?.adjustsFontSizeToFitWidth = true
            $0?.minimumScaleFactor = 0.8
        }
    }
    
    private func loadLanguage() {
        lbColoringBooks.text = LocalizableUtils.commonColoringBooks()
        lbCollection.text = LocalizableUtils.commonCollections()
        lbSettings.text = LocalizableUtils.commonSettings()
    }
    
    @objc private func changeTabbar(_ gesture: UIGestureRecognizer) {
        switch gesture.view?.restorationIdentifier {
        case viewColoringBooks.restorationIdentifier:
            selectTab(at: 0, animated: true)
        case viewCollection.restorationIdentifier:
            selectTab(at: 1, animated: true)
        case viewSettings.restorationIdentifier:
            selectTab(at: 2, animated: true)
        default:
            break
        }
    }
    
    private func selectTab(at index: Int, animated: Bool) {
        let items: [(view: UIView, image: UIImageView, label: UILabel, icon: UIImage?)] = [
            (viewColoringBooks, imgColoringBook, lbColoringBooks, R.image.ic_diary_dark()),
            (viewCollection, imgCollection, lbCollection, R.image.ic_collection_dark()),
            (viewSettings, imgSetting, lbSettings, R.image.ic_setting_dark())
        ]
        for (i, item) in items.enumerated() {
            let isSelected = i == index
            let color = isSelected ? selectedColor : normalColor
            item.image.image = item.icon?.withRenderingMode(.alwaysTemplate)
            item.image.tintColor = color
            item.label.textColor = color
            item.label.font = .systemFont(ofSize: 12, weight: isSelected ? .semibold : .medium)
        }
        
        let selectedView = items[index].view
        NSLayoutConstraint.deactivate(selectionPillConstraints)
        selectionPillConstraints = [
            selectionPill.centerXAnchor.constraint(equalTo: selectedView.centerXAnchor),
            selectionPill.centerYAnchor.constraint(equalTo: tabbarView.centerYAnchor),
            selectionPill.widthAnchor.constraint(equalTo: selectedView.widthAnchor, constant: -8),
            selectionPill.heightAnchor.constraint(equalTo: tabbarView.heightAnchor, constant: -12)
        ]
        NSLayoutConstraint.activate(selectionPillConstraints)
        
        if animated {
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5) {
                self.tabbarView.layoutIfNeeded()
            }
            UISelectionFeedbackGenerator().selectionChanged()
        }
        viewContainer.presentedPageIndex = index
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
