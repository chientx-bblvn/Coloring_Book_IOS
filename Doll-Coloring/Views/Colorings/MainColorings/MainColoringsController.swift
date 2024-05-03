//
//  MainColoringsController.swift
//  Doll-Coloring
//
//  Created by Việt Anh Nguyễn on 10/04/2024.
//  
//

import Foundation
import RxSwift
import UIKit

class MainColoringsController: BaseViewController {
    
    var viewModel: MainColoringsVM!
    
    @IBOutlet weak var topBarView: TopBarView!
    
    @IBOutlet weak var segmentedView: UISegmentedControl!
    
    @IBOutlet weak var viewContent: UIView!
    
    @IBOutlet weak var viewAds: UIView!
    
    @IBOutlet weak var heightAdsView: NSLayoutConstraint!
    
    private var listTopPicks: ListTopPicksColoringViewController!
    private var listTheme: ListThemeColoringViewController!
    private var pageViewControler = UIPageViewController()
    
    override func setup() {
        super.setup()
        setupSegmentedView()
        setupPageView()
        topBarView.title = LocalizableUtils.commonStartColoring().uppercased()
        topBarView.titleFont = UIFont.systemFont(ofSize: 20, weight: .bold)
        topBarView.onLeftClick = {
            AppRouter.shared.dismissDetail()
        }
        topBarView.onRightClick = {
            self.showSettingView()
        }
        let archiveFiles = ArchiveFileLocal.allCases
        
        for file in archiveFiles {
            if !FileManagerLocal.shared.checkFileExits(typeFile: file, fileName: "") {
                FileManagerLocal.shared.createFolderManager(fileName: file.rawValue)
            }
        }
    }
    
    override func onLanguageChange() {
        topBarView.title = LocalizableUtils.commonStartColoring().uppercased()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadAdsView()
    }

    override func bindingData() {
        super.bindingData()
        viewModel.getColorings {
            self.listTopPicks.reloadData(data: self.viewModel.colorings)
        }
    }
    
    func loadAdsView() {
        heightAdsView.constant = 60
        ADManager.shared.loadCollapsibleBannerAdaptive(DollColoringAdID.banner_coloring, viewBanner: viewAds) {[weak self] success in
            self?.viewAds.isHidden = !success
            self?.heightAdsView.constant = success ? 60 : 0
        }
    }
    
    
    
    private func setupSegmentedView() {
        segmentedView.removeAllSegments()
        segmentedView.insertSegment(withTitle: "All Topics", at: 0, animated: true)
        segmentedView.insertSegment(withTitle: "Theme Album", at: 1, animated: true)
        segmentedView.backgroundColor = R.color.mainPrimary()?.withAlphaComponent(0.45)
        segmentedView.selectedSegmentTintColor = R.color.colorTextTopBar()
        let titleTextAttributesNormal = [NSAttributedString.Key.foregroundColor: UIColor(hexString: "250055")]
        let titleTextAttributesSelected = [NSAttributedString.Key.foregroundColor: UIColor.white]
        segmentedView.setTitleTextAttributes(titleTextAttributesNormal, for: .normal)
        segmentedView.setTitleTextAttributes(titleTextAttributesSelected, for: .selected)
        segmentedView.selectedSegmentIndex = 0
        segmentedView.addTarget(self, action: #selector(onTapSegmented(_:)), for: .valueChanged)
    }
    
    private func setupPageView() {
        self.listTopPicks = ListTopPicksColoringViewController()
        self.listTheme = ListThemeColoringViewController()
        pageViewControler = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        pageViewControler.setViewControllers([listTopPicks], direction: .forward, animated: true)
        addChild(pageViewControler)
        viewContent.addSubview(pageViewControler.view)
        pageViewControler.view.translatesAutoresizingMaskIntoConstraints = false
        pageViewControler.view.topAnchor.constraint(equalTo: viewContent.topAnchor).isActive = true
        pageViewControler.view.trailingAnchor.constraint(equalTo: viewContent.trailingAnchor).isActive = true
        pageViewControler.view.leadingAnchor.constraint(equalTo: viewContent.leadingAnchor).isActive = true
        pageViewControler.view.bottomAnchor.constraint(equalTo: viewContent.bottomAnchor).isActive = true
        pageViewControler.didMove(toParent: self)
    }
    
    
    
    @objc func onTapSegmented(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            pageViewControler.setViewControllers([listTopPicks], direction: .reverse, animated: true)
        case 1:
            pageViewControler.setViewControllers([listTheme], direction: .forward, animated: true)
        default:
            break
        }
    }
}
