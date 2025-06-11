//
//  NewHomeController.swift
//  Doll-Coloring
//
//  Created by Tiến Đoàn on 11/3/25.
//

import UIKit
import SDWebImage
import AdmobSDK

class NewHomeController: BaseViewController {
    
    var viewModel: HomeVM!
    
    @IBOutlet weak var coloringTableView: UITableView!
    
    @IBOutlet weak var topBarView: TopBarView!
    
    
    private var numberClick = 0
    private var timeDistanceShowad: TimeInterval = 5
    private var currentTime: TimeInterval = 0
    private var hasAd = true
    
    override func loadView() {
        super.loadView()
        setupView()
        enableAudioBackground()
        loadLanguage()
        settingIAP()
        requestNotification()
        topBarView.onLeftClick = {
            SubcriptionViewController.show(checkTime: true, handler: {
                if DollColoringAdID.inter_after_iap.isEnableAd {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        AdLoadingView.show()
                        ADManager.shared.loadFull(DollColoringAdID.inter_after_iap) { _ in
                            AdLoadingView.dismiss()
                        }
                    }
                }
            }, onClickCLose: {
                
            })
        }
        topBarView.onRightClick = {
            AppRouter.shared.navigate(to: CheckInRoute.main, with: .push)
        }
        topBarView.titleFont = UIFont.systemFont(ofSize: 24, weight: .bold)
        
    }
        override func setup() {
            super.setup()
            if UserDefaultManager.ABShowIAPColoring, !IAPState.isUserVip {
                SubcriptionViewController.show(checkTime: false,handler: {
                    if UserDefaultManager.disableSale {
                        ADManager.shared.loadFull(DollColoringAdID.inter_after_iap)
                        return
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        PremiumFloatingView.show()
                        guard UserDefaultManager.getRemainingCountdownTime() > 0 else {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                AdLoadingView.show()
                                ADManager.shared.loadFull(DollColoringAdID.inter_after_iap) { _ in
                                    AdLoadingView.dismiss()
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
                                        self.calculatorDay()
                                    }
                                }
                            }
                            return
                        }
                        DiscountViewController.show {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                AdLoadingView.show()
                                ADManager.shared.loadFull(DollColoringAdID.inter_after_iap) { _ in
                                    AdLoadingView.dismiss()
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
                                        self.calculatorDay()
                                    }
                                }
                            }
                        }
                    }
                }, onClickCLose:  {
    
                })
    
            }
            NotificationCenter.default.addObserver(self, selector: #selector(gotoDaily), name: NSNotification.Name("GOTODAILY_TABBAR"), object: nil)
        }

    private func setupView() {
        coloringTableView.delegate = self
        coloringTableView.dataSource = self
        coloringTableView.register(UINib(nibName: "ColoringBookCell", bundle: nil), forCellReuseIdentifier: "ColoringBookCell")
        coloringTableView.contentInset.bottom = 160
        
        timeDistanceShowad = TimeInterval(ADManager.shared.timeRemoteShowFull)
//        numberClick = UserDefaultManager.numberClickItemAllTopic
        
        self.coloringTableView.backgroundColor =  UIColor.clear
        
        
        topBarView.roundCorners(corners: [.layerMinXMaxYCorner, .layerMaxXMaxYCorner], radius: 16)
        
    }
    override func bindingData() {
        super.bindingData()
        viewModel.getNewColorings { [weak self] in
            guard let self = self else {return}
            self.viewModel.colorings.forEach { model in
                self.coloringTableView.reloadData()
            }
        }
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        coloringTableView.reloadData()
//    }
    
    private func loadLanguage() {
        topBarView.title = LocalizableUtils.commonColoringBooks()
    }
    
    private func settingIAP() {
        InappManager.share.didPaymentSuccess.subscribe(onNext: { _ in
            if IAPState.isUserVip {
                PremiumFloatingView.hide()
            }
        }).disposed(by: disposeBag)
    }
    private func requestNotification() {
        BBLLogging.d("Check:: requestNotification")
        appDelegate?.requestNotificationPermission(completion: { success, error in
            BBLLogging.d("Check:: requestNotificationPermission  --   success: \(success)  error: \(error?.localizedDescription ?? "error")")
        })
    }
    override func viewWillDisappear(_ animated: Bool) {
        let local = FileManagerLocal.shared.getFileColoringlocalURL()
        local.forEach { url in
            let cacheKey = SDWebImageManager.shared.cacheKey(for: url)
            SDImageCache.shared.removeImage(forKey: cacheKey, withCompletion: nil)
        }
    }
    override func onLanguageChange() {
        loadLanguage()
    }
    
    @objc private func showPremiumView() {
        SubcriptionViewController.show(checkTime: true) {
            if DollColoringAdID.inter_after_iap.isEnableAd {
                AdLoadingView.show()
                ADManager.shared.loadFull(DollColoringAdID.inter_after_iap) {_ in
                    AdLoadingView.dismiss()
                }
            }
        } onClickCLose: {
            
        }

    }
    
    
    
    
}
extension NewHomeController {
    func navigateColoring(_ data: ColoringImage) {
        if let path = data.filePath?.components(separatedBy: "/").last, let colorLocal = SQLiteManager.shared.selectionColorings().first(where: {$0.filePath.contains(path)}) {
            AppRouter.shared.navigate(to: HistoryColoringRoute.main(coloring: colorLocal, typeScreen: .home, coloringAPI: data), with: .modal)
        } else {
            AppRouter.shared.navigate(to: PreviewColoringRoute.main(coloring: data, coloringLocal: nil, history: nil, typeScreen: .home), with: .modal)
        }
    }
    
    func showRewDaily(_ data: ColoringImage) {
        guard SQLiteManager.shared.selectionColoringsRew().first(where: { $0.filePath == data.filePath }) == nil else {
            navigateColoring(data)
            return
        }

        if IAPState.isUserVip {
            navigateColoring(data)
            return
        }

        if !UserDefaultManager.disableMusicBackground {
            pauseAudioBackground()
        }

        PopupShowAdsViewController.show(in: self, data: data, {
            if !UserDefaultManager.disableMusicBackground {
                self.playAudioBackground()
            }
            SQLiteManager.shared.insertTableColoringRew(data: data)
            SQLiteManager.shared.insertTableGitColoring(
                _id: SQLiteManager.shared.selectionGitColorings().count,
                _name: data.filePath ?? ""
            )
            self.navigateColoring(data)

        }, {
            SubcriptionViewController.show(checkTime: true) {
                if DollColoringAdID.inter_after_iap.isEnableAd {
                    AdLoadingView.show()
                    ADManager.shared.loadFull(DollColoringAdID.inter_after_iap) { _ in
                        AdLoadingView.dismiss()
                    }
                }
            } onClickCLose: {
            }
        })
    }
    func loadInterDaily(_ data: ColoringImage) {
        if !UserDefaultManager.disableMusicBackground {
            self.playAudioBackground()
        }

        SQLiteManager.shared.insertTableGitColoring(
            _id: SQLiteManager.shared.selectionGitColorings().count,
            _name: data.filePath ?? ""
        )

        self.navigateColoring(data)
    }
    @objc private func gotoDaily() {
        let sqliteData = SQLiteManager.shared.selectionGitColorings()
        guard sqliteData.count < viewModel.itemDaly.count else {return}
        let currentDate = Date()
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        guard let pastDate = dateFormatter.date(from: UserDefaultManager.dateFirstOpenApp) else {
            return
        }
        
        let components = calendar.dateComponents([.day], from: pastDate, to: currentDate)
        if let totalDays = components.day {
            if totalDays >= viewModel.itemDaly.count {
                let name = viewModel.itemDaly[(viewModel.itemDaly.count - 1)]
                navigateColoring(name)
            } else {
                let name = viewModel.itemDaly[totalDays]
                navigateColoring(name)
            }
        }
    }
    func calculatorDay() {
        let sqliteData = SQLiteManager.shared.selectionGitColorings()
        guard sqliteData.count < viewModel.itemDaly.count else {return}
        let currentDate = Date()
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        guard let pastDate = dateFormatter.date(from: UserDefaultManager.dateFirstOpenApp) else {
            return
        }
        let components = calendar.dateComponents([.day], from: pastDate, to: currentDate)
        
        if let totalDays = components.day {
            if totalDays >= viewModel.itemDaly.count {
                if let name = viewModel.itemDaly[(viewModel.itemDaly.count - 1)].filePath, !sqliteData.contains(where: {$0.filePath.contains(name)}){
                    AppRouter.shared.navigate(to: CheckInRoute.gitPopup(name: name), with: .modal)
                }
            } else {
                if let name = viewModel.itemDaly[totalDays].filePath, !sqliteData.contains(where: {$0.filePath.contains(name)}){
                    AppRouter.shared.navigate(to: CheckInRoute.gitPopup(name: name), with: .modal)
                }
            }
        }
    }
    func showInter(_ data: ColoringImage) {
        if IAPState.isUserVip {
            navigateColoring(data)
            return
        }

        numberClick += 1
        if numberClick >= UserDefaultManager.numberClickItemAllTopic {
            if !UserDefaultManager.disableMusicBackground {
                pauseAudioBackground()
            }

            AdLoadingView.show()
            ADManager.shared.loadFull(DollColoringAdID.inter_main, isSplash: true) { status in
                AdLoadingView.dismiss()
                switch status {
                case .closed, .error:
                    DispatchQueue.main.async {
                        if !UserDefaultManager.disableMusicBackground {
                            self.playAudioBackground()
                        }
                        self.navigateColoring(data)
                    }
                default:
                    break
                }
            }
        } else {
            navigateColoring(data)
        }
    }
    
    func calculatorDays() -> Int {
        let sqliteData = SQLiteManager.shared.selectionGitColorings()
        guard sqliteData.count < viewModel.itemDaly.count else {return 0}
        let currentDate = Date()
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        guard let pastDate = dateFormatter.date(from: UserDefaultManager.dateFirstOpenApp) else {
            return 0
        }
        let components = calendar.dateComponents([.day], from: pastDate, to: currentDate)
        
        if let totalDays = components.day {
            return totalDays
        }
        return 0
    }
    func showRew(_ data: ColoringImage) {
        guard SQLiteManager.shared.selectionColoringsRew().first(where: { $0.filePath == data.filePath }) == nil else {
            navigateColoring(data)
            return
        }

        if IAPState.isUserVip {
            navigateColoring(data)
            return
        }

        if !UserDefaultManager.disableMusicBackground {
            pauseAudioBackground()
        }

        PopupShowAdsViewController.show(in: self, data: data, {
            if !UserDefaultManager.disableMusicBackground {
                self.playAudioBackground()
            }
            SQLiteManager.shared.insertTableColoringRew(data: data)
            self.navigateColoring(data)
        }, {
            SubcriptionViewController.show(checkTime: true) {
                if DollColoringAdID.inter_after_iap.isEnableAd {
                    AdLoadingView.show()
                    ADManager.shared.loadFull(DollColoringAdID.inter_after_iap) { _ in
                        AdLoadingView.dismiss()
                    }
                }
            } onClickCLose: {
            }
        })
    }
    
    func loadInter(_ data: ColoringImage) {
        DispatchQueue.main.async {
            if !UserDefaultManager.disableMusicBackground {
                self.playAudioBackground()
            }
            self.navigateColoring(data)
        }
    }
    func showIAP(_ data: ColoringImage) {
        guard IAPState.isUserVip else {
            
            if SQLiteManager.shared.selectionColoringsRew().first(where: {$0.filePath == data.filePath}) != nil {
                navigateColoring(data)
                return
            }
            
            SubcriptionViewController.show(checkTime: true) {
                if DollColoringAdID.inter_after_iap.isEnableAd {
                    AdLoadingView.show()
                    ADManager.shared.loadFull(DollColoringAdID.inter_after_iap) {_ in
                        AdLoadingView.dismiss()
                    }
                }
            } onClickCLose: {
                self.showRew(data)
            }
            return
        }
        navigateColoring(data)
    }
}

extension NewHomeController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.colorings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ColoringBookCell", for:  indexPath) as! ColoringBookCell
        let category = viewModel.colorings[indexPath.row]
        let categoryName = category.categoryName ?? "Unknown Category"
        let day = self.calculatorDays()
        cell.setupCell(title: categoryName, itemColoring: category.imageUrls ?? [], days: day)
        cell.layer.backgroundColor =  UIColor.clear.cgColor
        cell.selectionStyle = .none
        
        cell.onClickItem = { item, categoryName, index in
            guard !(categoryName.contains("Daily")) else {
                if SQLiteManager.shared.selectionGitColorings().contains(where: {$0.filePath.contains(item.filePath ?? "")}) {
                    self.navigateColoring(item)
                } else if index <= day {
                    self.showRewDaily(item)
                } else {
                    AppRouter.shared.navigate(to: HomeRoute.showCombackTomorrow, with: .modal, animated: false)
                }
                return
            }
            guard UserDefaultManager.ABShowIAPColoring else {
                if (item.isPremium ?? false) {
                    self.showRew(item)
                } else {
                    self.showInter(item)
                }
                return
            }
            
            if UserDefaultManager.ABis_free_trial_us {
                self.showRew(item)
            } else {
                if (item.isPremium ?? false) {
                    self.showIAP(item)
                } else {
                    self.showInter(item)
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let width = UIScreen.main.bounds.width - 32
        let cellHeight = width * 0.75
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let coloringCell = cell as? ColoringBookCell {
            coloringCell.prepareForDisplay()
        }
    } 
}
