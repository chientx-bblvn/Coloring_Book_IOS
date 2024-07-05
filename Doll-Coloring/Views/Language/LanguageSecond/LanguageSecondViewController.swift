//
//  LanguageSecondViewController.swift
//  Doll-Coloring
//
//  Created by Việt Anh Nguyễn on 3/7/24.
//

import Foundation
import RxSwift
import UIKit
import AdmobSDK

class LanguageSecondViewController: BaseViewController {
    
    @IBOutlet weak var topBarView: TopBarView!
    @IBOutlet weak var tableviewListCountry: UITableView!
    @IBOutlet weak var viewAds: UIView!
    @IBOutlet weak var heightViewAds: NSLayoutConstraint!
    
    private var currentLanguage: Language? = nil {
        didSet {
            if goFrom == .intro {
                topBarView.rightTitleColor = R.color.colorTitle()
            } else {
                topBarView.rightIcon = R.image.iccon_checkmark()?.withTintColor(R.color.colorTitle() ?? .black)
            }
            
            topBarView.rightEnable = currentLanguage != nil
        }
    }
    var goFrom: LanguageGoFrom = .intro

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

// MARK: - Setup view
extension LanguageSecondViewController {
    
    private func setupView() {
        let language = UserDefaults.standard.string(forKey: UserDefault.languageKey.rawValue) ?? ""
        if language.isEmpty {
            FirebaseEventManager.logEvent(with: RMBGEventTracking.languageScr)
            let alpha = CGFloat(RemoteConfigManager.shared
                .getValue(by: RMBGRemoteConfig.alphaLanguageColor)?
                .numberValue.floatValue ?? 0.0)
            if goFrom == .intro {
                topBarView.rightTitleColor = R.color.mainPrimary()?.withAlphaComponent(alpha)
            } else {
                topBarView.rightIcon = R.image.iccon_checkmark()?.withTintColor((R.color.mainPrimary() ?? .black).withAlphaComponent(alpha))
            }
        } else {
            if goFrom == .intro {
                topBarView.rightTitleColor = R.color.mainPrimary()
            } else {
                topBarView.rightIcon = R.image.iccon_checkmark()?.withTintColor(R.color.mainPrimary() ?? .black)
            }
            self.currentLanguage = Constants.currentLanguage
        }
        topBarView.rightEnable = !language.isEmpty
        
        if goFrom == .setting {
            topBarView.leftIcon = R.image.chevronBack()
            topBarView.onLeftClick = {
                AppRouter.shared.dismissDetail()
            }
        }
        topBarView.onRightClick = { [weak self] in
            guard let language = self?.currentLanguage else {
                return
            }
            if self?.goFrom == .setting {
                self?.changeLanguage(language: language)
                AppRouter.shared.dismissDetail()
            } else if self?.goFrom == .intro {
                self?.changeLanguage(language: language)
                let showIntro = UserDefaults.standard.bool(forKey: UserDefault.showedIntro.rawValue)
                if !showIntro {
                    AppRouter.shared.navigate(to: IntroRoute.intro, with: .push)
                    return
                }
//                MainRoute.gotoHome()
            }
        }
        
        tableviewListCountry.register(cellType: LanguageCell.self)
        tableviewListCountry.delegate = self
        tableviewListCountry.dataSource = self
        
        setupListenChangeIAP()
    }
    
    private func setupListenChangeIAP() {
        InappManager.share.didPaymentSuccess.asObservable().subscribe(onNext: { [weak self] _ in
            self?.loadAdsHigh()
        }).disposed(by: disposeBag)
    }
    
    private func loadAdsHigh() {
        viewAds.isHidden = true
        heightViewAds.constant = 0
        viewAds.isHidden = false
        heightViewAds.constant = 190
        ADManager.shared.loadNative(DollColoringAdID.native_language_high,
                                    to: self.viewAds, refreshAd: true , nativeAdType: .smallMedia) { [weak self] idAds, success ,_  in
            guard idAds.contains(DollColoringAdID.native_language_high.adId) else {
                return
            }
            if success {
                self?.viewAds.isHidden = false
                self?.heightViewAds.constant = 190
            } else {
                self?.loadAds()
            }
        }
    }
    
    private func loadAds() {
        ADManager.shared.loadNative(DollColoringAdID.native_language,
                                    to: self.viewAds, refreshAd: true, nativeAdType: .smallMedia) { [weak self] idAds, success ,_  in
            guard idAds.contains(DollColoringAdID.native_language.adId) else {
                return
            }
            if success {
                self?.viewAds.isHidden = false
                self?.heightViewAds.constant = 190
            } else {
                self?.viewAds.isHidden = true
                self?.heightViewAds.constant = 0
            }
        }
    }
    
    private func loadText() {
        if goFrom == .intro {
            topBarView.rightTitle = LocalizableUtils.commonNext()
        } else {
            topBarView.rightIcon = R.image.iccon_checkmark()?.withTintColor(R.color.mainPrimary() ?? .black)
        }
        topBarView.title = LocalizableUtils.languageTitle()
        tableviewListCountry.reloadData()
    }
    
}

extension LanguageSecondViewController: UITableViewDelegate, UITableViewDataSource {
    
    private func getListCountry() -> [Language] {
        return LanguageVM.shared.listCountryCode
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getListCountry().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: LanguageCell.self)
        let country = getListCountry()[indexPath.row]
        cell.loadData(country: country, selected: country == currentLanguage)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let country = getListCountry()[indexPath.row]
        AppRouter.shared.navigate(to: LanguageRoute.language(gofrom: .intro, currentLanguage: country), with: .push, animated: false)
    }
    
}
