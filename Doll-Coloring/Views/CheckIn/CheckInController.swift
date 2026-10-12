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
import BmoViewPager
import SDWebImage

class CheckInController: BaseViewController {
    
    var viewModel: DalyMonthVM!
    
    @IBOutlet weak var topbarView: TopBarView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var typeHome = TypeHome.allCases
    private var bannerHome: BannerHome = .iphone
    private var coloringLocal = SQLiteManager.shared.selectionColorings()
    private var currentDay: Int = 0
    
    override func setup() {
        super.setup()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        coloringLocal = SQLiteManager.shared.selectionColorings()
        collectionView.reloadData()
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
    
    override func bindingData() {
        super.bindingData()
        viewModel.getDalyColoring {
            self.collectionView.reloadData()
        }
    }
    
    func setupView() {
        if UIDevice.current.userInterfaceIdiom == .pad {
            bannerHome = .ipad
        }
        topbarView.titleFont = UIFont.systemFont(ofSize: 24, weight: .bold)
        topbarView.titleFont = UIFont.systemFont(ofSize: 24, weight: .bold)
        topbarView.onLeftClick = {
            NotificationCenter.default.post(name: NSNotification.Name("SWIFTUI_POP_CHECKIN"), object: nil)
            if self.navigationController?.presentingViewController != nil {
                self.dismiss(animated: true)
            } else if (self.navigationController?.viewControllers.count ?? 0) > 1 {
                self.navigationController?.popViewController(animated: true)
            } else {
                AppRouter.shared.dismissToSwiftUIHome()
            }
        }
        topbarView.textAlignmentCenter = true
        loadLanguage()
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(cellType: ItemGitDalyCell.self)
        collectionView.register(cellType: GitDaylyCell.self)
        collectionView.register(UINib(nibName: "HeaderDalyView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderDalyView")
        collectionView.register(UINib(nibName: "HeaderDalyView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "HeaderDalyView")

        
        collectionView.contentInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
    
    func loadLanguage() {
        topbarView.title = LocalizableUtils.commonDaily()
    }
    
}

extension CheckInController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.monthsData.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
           return viewModel.monthsData[section - 1].day.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: GitDaylyCell.self)
            if viewModel.totalGitDaly == 0 {
                cell.loadImage(image: viewModel.itemDaly.first?.filePath ?? "")
            } else {
                if viewModel.itemDaly.count > viewModel.totalGitDaly {
                    cell.loadImage(image: viewModel.itemDaly[viewModel.totalGitDaly].filePath ?? "")
                } else {
                    cell.loadImage(image: viewModel.itemDaly.first?.filePath ?? "")
                }
            }
            cell.coloringLocal = coloringLocal
            cell.onclickImage = {[weak self] name in
                if let data = self?.viewModel.itemDaly.first(where: {$0.filePath?.contains(name) ?? false}) {
                    self?.navigateColoring(data)
                }
            }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: ItemGitDalyCell.self)
            let image = viewModel.monthsData[indexPath.section - 1].image.reversed()[indexPath.row]
            if let coloring = coloringLocal.first(where: {$0.filePath.contains(image)}) {
                if let file = coloring.historys.last?.imagePath {
                    let imageUrlString = FileManagerLocal.shared.getFileFoderFileUssing(typeFile: .ColoringSave, file: file)
                    let cacheKey = SDWebImageManager.shared.cacheKey(for: imageUrlString)
                    SDImageCache.shared.removeImage(forKey: cacheKey, withCompletion: nil)
                    cell.imageItem.setLocalImage(with: imageUrlString.path, placeholder: nil)
                } else {
                    cell.imageItem.setImage(with: image)
                }
            } else {
                cell.imageItem.setImage(with: image)
            }
            cell.imageAds.isHidden = true
            cell.lbDate.text = "\(viewModel.monthsData[indexPath.section - 1].day.reversed()[indexPath.row])"
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section != 0 {
            let image = viewModel.monthsData[indexPath.section - 1].image.reversed()[indexPath.row]
            if let data = viewModel.itemDaly.first(where: { $0.filePath?.contains(image) ?? false }) {
                unlockAndNavigate(data)
            }
        }
    }
    
    /// Daily gifts open free once the day has arrived — no reward ads.
    func unlockAndNavigate(_ data: ColoringImage) {
        SQLiteManager.shared.insertTableColoringRew(data: data)
        SQLiteManager.shared.insertTableGitColoring(
            _id: SQLiteManager.shared.selectionGitColorings().count,
            _name: data.filePath ?? ""
        )
        navigateColoring(data)
    }
    
    func navigateColoring(_ data: ColoringImage) {
        let local: ColoringHistoryModel? = {
            guard let path = data.filePath?.components(separatedBy: "/").last else { return nil }
            return SQLiteManager.shared.selectionColorings().first(where: { $0.filePath.contains(path) })
        }()
        AppRouter.shared.navigate(
            to: ColorFlowPresenter.route(api: data, local: local, typeScreen: .home),
            with: .modal
        )
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let cell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderDalyView", for: indexPath) as? HeaderDalyView else {return UICollectionReusableView()}
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMMM"
            if indexPath.section == 0 {
                cell.lbTitle.text = "Gift Today"
            } else {
                let month = dateFormatter.string(from: viewModel.monthsData.reversed()[indexPath.section - 1].month)
                cell.lbTitle.text = month.capitalized
            }
            return cell
        case UICollectionView.elementKindSectionFooter:
            guard let cell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "HeaderDalyView", for: indexPath) as? HeaderDalyView else {return UICollectionReusableView()}
            return cell
        default:
            fatalError("Unexpected element kind")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width - 32, height: 0.001)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width - 32, height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize (width: collectionView.frame.width - 32, height: collectionView.frame.height * 0.5)
        } else {
            let width = (collectionView.frame.width - 32 - (16 * 3)) / 3
            return CGSize(width: width, height: width)
        }
    }
}
