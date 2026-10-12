//
//  LanguageSecondViewController.swift
//  Doll-Coloring
//
//  Created by Việt Anh Nguyễn on 3/7/24.
//

import Foundation
import RxSwift
import UIKit

class LanguageSecondViewController: BaseViewController {
    
    @IBOutlet weak var topBarView: TopBarView!
    @IBOutlet weak var tableviewListCountry: UITableView!
    @IBOutlet weak var viewAds: UIView!
    
    private var currentLanguage: Language? = nil {
         didSet {
             
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
       }
         topBarView.titleFont = .systemFont(ofSize: 24, weight: .bold)
         topBarView.textAlignmentCenter = false
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
         viewAds?.isHidden = true
         if let height = viewAds?.constraints.first(where: { $0.firstAttribute == .height }) {
             height.constant = 0
         }
     }
     
     private func loadText() {
         topBarView.title = LocalizableUtils.languageSubTitle()
         tableviewListCountry.reloadData()
     }
     
 }

 extension LanguageSecondViewController: UITableViewDelegate, UITableViewDataSource {
     
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
         Constants.currentLanguage = country
         AppRouter.shared.navigate(to: LanguageRoute.language(gofrom: .intro, currentLanguage: country), with: .changeRoot, animated: false)
     }
     
     
 }
