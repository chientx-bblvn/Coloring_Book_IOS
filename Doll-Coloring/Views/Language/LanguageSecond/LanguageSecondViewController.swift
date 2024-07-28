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
    
    private var currentLanguage: Language? = nil {
        didSet {
            if goFrom == .intro {
                topBarView.rightIcon = R.image.iccon_checkmark()?.withTintColor(R.color.colorTitle() ?? .black)
            } else {
                topBarView.rightIcon = R.image.iccon_checkmark()?.withTintColor(R.color.colorTitle() ?? .black)
            }
            
            topBarView.rightEnable = true
        }
    }
    var goFrom: LanguageGoFrom = .intro
   
    override func viewDidLoad() {
        super.viewDidLoad()
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
        tableviewListCountry.register(cellType: LanguageCell.self)
        tableviewListCountry.delegate = self
        tableviewListCountry.dataSource = self
        let language = UserDefaults.standard.string(forKey: UserDefault.languageKey.rawValue) ?? ""
        if language.isEmpty {
            FirebaseEventManager.logEvent(with: RMBGEventTracking.languageScr)
            if goFrom == .intro {
                topBarView.rightTitleColor = R.color.mainPrimary()
                topBarView.rightIcon = R.image.iccon_checkmark()?.withTintColor((R.color.colorTextTopBar() ?? .black))
            } else {
                topBarView.rightIcon = R.image.iccon_checkmark()?.withTintColor((R.color.colorTextTopBar() ?? .black))
            }
        } else {
            if goFrom == .intro {
                topBarView.rightIcon = R.image.iccon_checkmark()?.withTintColor((R.color.colorTextTopBar() ?? .black))
            } else {
                topBarView.rightIcon = R.image.iccon_checkmark()?.withTintColor(R.color.colorTextTopBar() ?? .black)
            }
            self.currentLanguage = Constants.currentLanguage
        }
        topBarView.rightEnable = true
        
        if goFrom == .setting {
            topBarView.leftIcon = R.image.chevronBack()
            topBarView.onLeftClick = {
                AppRouter.shared.dismissDetail()
            }
        }
        topBarView.titleFont = .systemFont(ofSize: 20, weight: .bold)
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
            }
        }
        
        ADManager.shared.preLoadNative(DollColoringAdID.native_language_2nd)
        
        setupListenChangeIAP()
    }
    
    private func setupListenChangeIAP() {
        loadAdsHigh()
    }
    
    private func loadAdsHigh() {
        viewAds.isHidden = false
        
        ADManager.shared.loadNative(DollColoringAdID.native_language_2nd,
                                    to: self.viewAds, refreshAd: true , nativeAdType: .customMediaFixedHeight) { [weak self] idAds, success ,_  in
            guard idAds.contains(DollColoringAdID.native_language_2nd.adId) else {
                return
            }
            if success {
                self?.viewAds.isHidden = false
            } else {
                self?.viewAds.isHidden = true
            }
        }
    }
    
    private func loadText() {
        if goFrom == .intro {
            topBarView.rightIcon = R.image.iccon_checkmark()?.withTintColor(R.color.colorTextTopBar() ?? .black)
        } else {
            topBarView.rightIcon = R.image.iccon_checkmark()?.withTintColor(R.color.colorTextTopBar() ?? .black)
        }
        topBarView.title = LocalizableUtils.languageSubTitle()
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
