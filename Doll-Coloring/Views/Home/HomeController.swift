//
//  HomeController.swift
//  Doll-Coloring
//
//  Created by Việt Anh Nguyễn on 08/04/2024.
//  
//

import Foundation
import RxSwift
import UIKit
import AdmobSDK

class HomeController: BaseViewController {
    
    var viewModel: HomeVM!
    
    @IBOutlet weak var topbarView: TopBarView!
    
    @IBOutlet weak var viewColoring: UIView!
    
    @IBOutlet weak var lbColoring: UILabel!
    
    @IBOutlet weak var viewCollection: UIView!
    
    @IBOutlet weak var lbCollection: UILabel!
    
    @IBOutlet weak var viewAds: UIView!
    
    
    override func setup() {
        super.setup()
        viewColoring.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapColoringView(_:))))
        viewCollection.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapCollectionsView(_:))))
        topbarView.titleFont = UIFont.systemFont(ofSize: 24, weight: .bold)
        topbarView.onRightClick = {
            self.showSettingView()
        }
        enableAudioBackground()
        loadLanguage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        ADManager.shared.loadNative(DollColoringAdID.native_home, to: viewAds) {[weak self] adId, success, nativeAdView in
            self?.viewAds.isHidden = !success
        }
    }
    
    override func onLanguageChange() {
        loadLanguage()
    }

    override func bindingData() {
        super.bindingData()
    }
    
    func loadLanguage() {
        lbColoring.text = LocalizableUtils.commonStartColoring()
        lbCollection.text = LocalizableUtils.commonCollections()
        topbarView.title = LocalizableUtils.commonHome().uppercased()
    }
    
    
    @objc func onTapColoringView(_ gesture: UITapGestureRecognizer) {
        viewColoring.isClicked(true)
        AppRouter.shared.navigate(to: MainColoringsRoute.main, with: .push)
    }
    
    @objc func onTapCollectionsView(_ gesture: UITapGestureRecognizer) {
        viewCollection.isClicked(true)
        AppRouter.shared.navigate(to: CollectionsRoute.main, with: .push)
    }
}

extension HomeController {
    func loadAds() {
        ADManager.shared.loadNative(DollColoringAdID.native_home, to: viewAds) {[weak self] adId, success, nativeAdView in
            if adId.contains(DollColoringAdID.native_home.adId) {
                self?.viewAds.isHidden = !success
            }
        }
    }
}
