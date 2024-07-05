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

    let disposeBag = DisposeBag()
    
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func loadView() {
        super.loadView()
        SOTabBarSetting.tabBarCircleSize = CGSize(width: 60, height: 60)
        SOTabBarSetting.tabBarAnimationDurationTime = 0.3
        SOTabBarSetting.tabBarSizeSelectedImage = 50
        SOTabBarSetting.tabBarSizeImage = 40
        SOTabBarSetting.tabBarShadowColor = UIColor.clear.cgColor
        SOTabBarSetting.tabBarTintColor = .clear
        
        settingIAP()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getCurrentHeightAds()
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
        NotificationCenter.default.addObserver(self, selector: #selector(gotoHome), name: NSNotification.Name("GOTOHOME_TABBAR"), object: nil)
        loadAdsBanner()
    }
    
    private func settingIAP() {
        InappManager.share.didPaymentSuccess.subscribe(onNext: { [weak self] _ in
            self?.loadAdsBanner()
        }).disposed(by: disposeBag)
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
    
    @objc private func gotoHome() {
        tabBar.didSelectTab(index: 0)
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
        if DeviceInfos.isIpad() {
            heightContraintAds.constant = 90
        } else {
            heightContraintAds.constant = 60
        }
        viewAds.isHidden = false
        ADManager.shared.loadBanner(DollColoringAdID.banner_home, viewBanner: viewAds) {[weak self] success in
            self?.getCurrentHeightAds(isSuccess: success)
            self?.viewAds.isHidden = !success
        }
    }
}
