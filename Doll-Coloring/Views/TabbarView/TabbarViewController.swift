//
//  TabbarViewController.swift
//  Doll-Coloring
//
//  Created by Việt Anh Nguyễn on 17/5/24.
//  
//

import Foundation
import RxSwift
import UIKit

class TabbarViewController: UIViewController, SOTabBarDelegate {

    @IBOutlet weak var viewContent: UIView!
    
    @IBOutlet weak var tabbarView: UIView!
    
    @IBOutlet weak var viewAds: UIView!
    
    @IBOutlet weak var heightContraintAds: NSLayoutConstraint! {
        didSet {
            getCurrentHeightAds()
        }
    }

    public var selectedIndex: Int = 0
    public var previousSelectedIndex = 0
    
    let homeStoryboard = HomeRoute.main.screen
    let chatStoryboard = CollectionsRoute.main(navigate: false).screen
    
    public var viewControllers = [UIViewController]() {
        didSet {
            tabBar.viewControllers = viewControllers
        }
    }
    
    private lazy var tabBar: SOTabBar = {
        let tabBar = SOTabBar()
        tabBar.delegate = self
        tabBar.translatesAutoresizingMaskIntoConstraints = false
        return tabBar
    }()
    
    
    override func loadView() {
        super.loadView()
        SOTabBarSetting.tabBarCircleSize = CGSize(width: 60, height: 60)
        SOTabBarSetting.tabBarAnimationDurationTime = 0.3
        SOTabBarSetting.tabBarSizeSelectedImage = 50
        SOTabBarSetting.tabBarSizeImage = 40
        SOTabBarSetting.tabBarShadowColor = UIColor.clear.cgColor
        SOTabBarSetting.tabBarTintColor = .clear
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabbarView.addSubview(tabBar)
        NSLayoutConstraint.activate([
            tabBar.topAnchor.constraint(equalTo: tabbarView.topAnchor),
            tabBar.leadingAnchor.constraint(equalTo: tabbarView.leadingAnchor),
            tabBar.trailingAnchor.constraint(equalTo: tabbarView.trailingAnchor),
            tabBar.bottomAnchor.constraint(equalTo: tabbarView.bottomAnchor)
        ])
        homeStoryboard.tabBarItem = UITabBarItem(title: LocalizableUtils.commonHome(), image: UIImage(named: "ic_home_tabbar"), selectedImage: UIImage(named: "ic_home_tabbar_select"))
        chatStoryboard.tabBarItem = UITabBarItem(title: LocalizableUtils.commonCollections(), image: UIImage(named: "ic_tabbar_collection"), selectedImage: UIImage(named: "ic_tabbar_collection_select"))
        viewControllers = [homeStoryboard, chatStoryboard]
        loadAdsBanner()
    }
    
    
    func tabBar(_ tabBar: SOTabBar, didSelectTabAt index: Int) {
        let previousVC = viewControllers[index]
        previousVC.willMove(toParent: nil)
        previousVC.view.removeFromSuperview()
        previousVC.removeFromParent()
        previousSelectedIndex = selectedIndex
        let vc = viewControllers[index]
        addChild(vc)
        selectedIndex = index + 1
        vc.view.frame = viewContent.bounds
        viewContent.addSubview(vc.view)
        vc.didMove(toParent: self)
    }
    
    private func getCurrentHeightAds(isSuccess: Bool = true) {
        guard isSuccess else {
            heightContraintAds.constant = 10
            return
        }
        if DeviceInfos.isIpad() {
            heightContraintAds.constant = 90
        } else {
            heightContraintAds.constant = 60
        }
    }
    
    func loadAdsBanner() {
        ADManager.shared.loadBanner(DollColoringAdID.banner_home, viewBanner: viewAds) {[weak self] success in
            self?.getCurrentHeightAds(isSuccess: success)
        }
    }
}
