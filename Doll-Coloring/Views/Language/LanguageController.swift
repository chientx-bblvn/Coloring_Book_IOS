//
//  LanguageController.swift
//  Doll-Coloring
//
//  Created by BBLabs on 12/08/2023.
//  Copyright ©2023. All rights reserved.
//

import Foundation
import RxSwift
import UIKit
import AdmobSDK

enum LanguageGoFrom {
    case intro
    case setting
}

class LanguageController: BaseViewController {
    
    // MARK: - Variable and Outlet
    
    @IBOutlet weak var topBarView: UIView!
    @IBOutlet weak var lbLangguage: UILabel!
    @IBOutlet weak var tableviewListCountry: UITableView!
    @IBOutlet weak var viewAds: UIView!
    @IBOutlet weak var btnNext: UIButton!
    
    internal var currentLanguage: Language? = nil
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
    
    @IBAction func actionNext(_ sender: Any) {
        guard let language = currentLanguage else {
            return
        }
        changeLanguage(language: language)
        if goFrom == .setting {
            AppRouter.shared.dismissDetail()
        } else {
            let showIntro = UserDefaults.standard.bool(forKey: UserDefault.showedIntro.rawValue)
            if !showIntro {
                AppRouter.shared.navigate(to: IntroRoute.intro, with: .changeRoot)
                return
            }
        }
        
    }
    
}

// MARK: - Action view
extension LanguageController {
    
}

// MARK: - Setup view
extension LanguageController {
    
    private func setupView() {
        self.currentLanguage = Constants.currentLanguage
        tableviewListCountry.register(cellType: LanguageCell.self)
        tableviewListCountry.delegate = self
        tableviewListCountry.dataSource = self
        if goFrom == .intro {
            ADManager.shared.preLoadNative(DollColoringAdID.native_onboarding_1,
                                           nativeAdType: .customMediaFixedHeight)
            
            ADManager.shared.preLoadNative(DollColoringAdID.native_onboarding_3,
                                           nativeAdType: .customMediaFixedHeight)
            
        }
        setupListenChangeIAP()
    }
    
    private func setupListenChangeIAP() {
        InappManager.share.didPaymentSuccess.asObservable().subscribe(onNext: { [weak self] _ in
            self?.loadAdsHigh()
        }).disposed(by: disposeBag)
    }
    
    private func loadAdsHigh() {
        viewAds.isHidden = false
        ADManager.shared.loadNative(DollColoringAdID.native_language,
                                    to: self.viewAds, nativeAdType: .customMediaFixedHeight) { [weak self] idAds, success ,_  in
            guard idAds.contains(DollColoringAdID.native_language.adId) else {
                return
            }
            if success {
                self?.viewAds.isHidden = !success
            } else {
                self?.viewAds.isHidden = true
            }
        }
    }
    
    private func loadText() {
        lbLangguage.text = LocalizableUtils.languageSubTitle()
        btnNext.setTitle(goFrom == .intro ? LocalizableUtils.commonNext() : LocalizableUtils.commonDone(), for: .normal)
        tableviewListCountry.reloadData()
    }
    
}

extension LanguageController: UITableViewDelegate, UITableViewDataSource {
    
    private func getListCountry() -> [Language] {
        return LanguageVM.shared.listCountryCode
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
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
        self.currentLanguage = country
        tableView.reloadData()
    }
    
}

extension LanguageController {
    @objc func updateSearchResults(_ textField: UITextField) {
        let content = (textField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        if content.isEmpty {
            tableviewListCountry.reloadData()
            return
        }
        tableviewListCountry.reloadData()
    }
}
