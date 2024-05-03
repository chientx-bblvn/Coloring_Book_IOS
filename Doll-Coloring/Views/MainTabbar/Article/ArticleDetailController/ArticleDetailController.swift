//
//  ArticleDetailController.swift
//  PetTranslate-iOS
//
//  Created by P.A.I.Hub on 21/03/2024.
//  Copyright ©2023 P.A.I.Hub. All rights reserved.
//

import Foundation
import RxSwift
import UIKit

class ArticleDetailController: BaseViewController {
    
    // MARK: - Variable and Outlet
    @IBOutlet private weak var topbarView: TopBarView!
    @IBOutlet private weak var tableViewContent: UITableView!
    @IBOutlet private weak var viewBanners: UIView!
    
    var currentArticle: ArticleModel?
    private var adCell: ArticleAdsCell?
    private var heightNativeAd = 190.0
    
    // MARK: - Setup controller and IBAction
    override func setup() {
        super.setup()
        setupView()
    }
    
    override func bindingData() {
        super.bindingData()
        loadText()
    }
   
    // MARK: - Language change event
    override func onLanguageChange() {
        super.onLanguageChange()
        loadText()
    }
    
}

// MARK: - Action view
extension ArticleDetailController {
    
}

// MARK: - Setup view
extension ArticleDetailController {
    
    private func setupView() {
        topbarView.onLeftClick = {
            AppRouter.shared.dismissDetail()
        }
        heightNativeAd = IAPState.isUserVip ? 0.001 : 190
        tableViewContent.register(cellType: DetailArticleCell.self)
        tableViewContent.register(cellType: ArticleAdsCell.self)
        tableViewContent.delegate = self
        tableViewContent.dataSource = self
        settingIAP()
    }
    
    private func settingIAP() {
        InappManager.share.didPaymentSuccess.subscribe(onNext: { [weak self] _ in
            self?.loadAds()
            self?.adCell?.viewAds.isHidden = IAPState.isUserVip
            self?.heightNativeAd = IAPState.isUserVip ? 0.001 : 190
            self?.tableViewContent.reloadData()
        }).disposed(by: disposeBag)
    }
    
    private func loadText() {
        topbarView.title = currentArticle?.title ?? ""
        tableViewContent.reloadData()
    }
    
    private func loadAds() {
        viewBanners.isHidden = true
        if !PetAdID.BannerAll.isEnableAd {
            return
        }
        viewBanners.isHidden = false
        ADManager.shared.loadBanner(PetAdID.BannerAll, viewBanner: viewBanners) { [weak self] success in
            self?.viewBanners.isHidden = !success
        }
    }
}

extension ArticleDetailController: UITableViewDataSource, UITableViewDelegate {
    
    private var listArticle: [SubArticleModel] {
        return currentArticle?.subContent ?? []
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listArticle.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let article = listArticle[row]
        if article.isAd {
            if let adCell = self.adCell {
                return adCell
            }
            let articleAdsCell = tableView.dequeueReusableCell(for: indexPath, cellType: ArticleAdsCell.self)
            if adCell == nil {
                adCell = articleAdsCell
                articleAdsCell.loadAds()
            }
            articleAdsCell.onLoadAd = { [weak self] success in
                if success {
                    self?.heightNativeAd = 190
                } else {
                    self?.heightNativeAd = 0.001
                }
                self?.tableViewContent.reloadData()
            }
            return articleAdsCell
        }
        let detailArticleCell = tableView.dequeueReusableCell(for: indexPath, cellType: DetailArticleCell.self)
        detailArticleCell.loadData(articleDetail: article)
        return detailArticleCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let article = listArticle[indexPath.row]
        if article.isAd {
            return heightNativeAd
        }
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        let article = listArticle[indexPath.row]
        if article.isAd {
            return heightNativeAd
        }
        return 200
    }
    
}
