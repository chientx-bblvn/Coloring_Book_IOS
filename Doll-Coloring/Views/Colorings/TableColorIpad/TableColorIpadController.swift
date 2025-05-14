//
//  TableColorIpadController.swift
//  Doll-Coloring
//
//  Created by Việt Anh Nguyễn on 23/5/24.
//
//

import Foundation
import RxSwift
import UIKit

class TableColorIpadController: BaseViewController {
    
    @IBOutlet var viewFake: [UIView]!
    
    @IBOutlet weak var viewContent: UIView!
    
    @IBOutlet weak var topBarView: TopBarView!
    
    @IBOutlet weak var viewListBling: UIView!
    
    @IBOutlet weak var viewTexture: UIView!
    
    @IBOutlet weak var imgTexture: UIImageView!
    
    @IBOutlet weak var lbTexture: UILabel!
    
    @IBOutlet weak var viewPlain: UIView!
    
    @IBOutlet weak var imgPlain: UIImageView!
    
    @IBOutlet weak var lbPlain: UILabel!
    
    @IBOutlet weak var listBlingColor: UICollectionView!
    
    @IBOutlet weak var viewBlinkColor: UIView!
    
    @IBOutlet weak var listItemColor: UITableView!
    
    var selectColors: (([ItemColor?],_ indexListColor: Int?,_ indexColorBling: Int?,_ palettes: PalettesColor,_ indexColor: Int?) -> Void)?
    
    var indexListColor: Int? = 0
    
    var indexColorBling: Int?
    
    var palettes: PalettesColor = .Plain
    
    var itemColors: [[ItemColor]] = []
    
    class func showView(in parent: UIViewController,
                        indexListColor: Int? = 0,
                        indexColorBling: Int?,
                        palettes: PalettesColor = .Texture, selectColors: (([ItemColor?],_ indexListColor: Int?,_ indexColorBling: Int?,_ palettes: PalettesColor,_ indexColor: Int?) -> Void)? = nil) {
        let mainStoryboard = UIStoryboard(name: "TableColorIpad", bundle: nil)
        guard let customView = mainStoryboard.instantiateViewController(withIdentifier: String(describing: self)) as? TableColorIpadController else {
            return
        }
        customView.selectColors = selectColors
        customView.indexListColor = indexListColor
        customView.indexColorBling = indexColorBling
        customView.palettes = palettes
        customView.providesPresentationContextTransitionStyle = true
        customView.definesPresentationContext = true
        customView.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        customView.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        customView.showInView(parent: parent)
    }
    
    override func setup() {
        super.setup()
        setupView()
//        ADManager.shared.preLoadReward(DollColoringAdID.reward_color)
    }
    
    override func bindingData() {
        super.bindingData()
    }
    
    func setupView() {
        listItemColor.delegate = self
        listItemColor.dataSource = self
        listItemColor.register(cellType: TableColorCell.self)
        listBlingColor.delegate = self
        listBlingColor.dataSource = self
        listBlingColor.register(cellType: FillterColorCell.self)
        viewBlinkColor.customGenerateOuterShadow(shadowOpacity: 1, shadowRadius: 0, color: UIColor(hexString: "000000"), shadowOffset: CGSize(width: 2, height: 2))
//        listBlingColor.layer.masksToBounds = true
        viewContent.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(actionBack)))
        viewPlain.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(actionPlain)))
        viewTexture.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(actionTexture)))
        topBarView.onLeftClick = {
            self.actionBack()
        }
        topBarView.textAlignmentCenter = true
        topBarView.titleFont = UIFont.systemFont(ofSize: 24, weight: .bold)
        
        changePalettes(true)
    }
    
    private func changePalettes(_ isNew: Bool = false) {
        itemColors = []
        viewPlain.backgroundColor = .clear
        viewTexture.backgroundColor = .clear
        lbPlain.textColor = R.color.colorTitle()
        lbTexture.textColor = R.color.colorTitle()
        lbPlain.font = .systemFont(ofSize: 14)
        lbTexture.font = .systemFont(ofSize: 14)
        imgPlain.isHidden = true
        imgTexture.isHidden = true
        if palettes == .Plain {
            palettes.palettes.forEach { item in
                itemColors.append(contentsOf: item.listColor)
            }
            viewListBling.isHidden = true
            lbPlain.font = .boldSystemFont(ofSize: 14)
            imgPlain.isHidden = true
            viewPlain.backgroundColor = UIColor.white
            lbPlain.textColor = .black
        } else {
            viewListBling.isHidden = false
            imgTexture.isHidden = true
            viewTexture.backgroundColor = UIColor.white
            lbTexture.font = .boldSystemFont(ofSize: 14)
            lbTexture.textColor = .black
            updateThemeColor()
        }
        listItemColor.reloadData()
        if isNew {
            listItemColor.scrollToRow(at: IndexPath(row: indexListColor ?? 0, section: 0), at: .top, animated: false)
        }
    }
    
    func updateThemeColor() {
        itemColors = palettes.palettes[indexColorBling ?? 0].listColor
        listBlingColor.reloadData()
        listItemColor.reloadData()
    }
    
    @objc private func actionBack() {
        removeAnimate()
    }
    
    @objc private func actionPlain() {
        palettes = .Plain
        indexListColor = -1
        indexColorBling = nil
        changePalettes()
    }
    
    @objc private func actionTexture() {
        palettes = .Texture
        indexListColor = -1
        indexColorBling = 0
        changePalettes()
    }
    
    @IBAction func actionClose(_ sender: Any) {
        actionBack()
    }
}

extension TableColorIpadController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemColors.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TableColorCell") as? TableColorCell else {
            return UITableViewCell()
        }
        cell.lblName.text = itemColors[indexPath.row].first?.tableName
        // hiện icon premium ở những thị trường có IAP
        if UserDefaultManager.ABShowIAPColoring {
            /** check tier 1
             - hiện icon premium ở bảng màu isPremium
             - show Watch ADS ở bảng màu thường
             - free_trial cho xem ads để mở khoá bảng màu
             -
             */
            if UserDefaultManager.ABis_free_trial_us {
                cell.btnWatchAds.isHidden = true
                cell.viewWatchADS.isHidden = true
                if !isWarchAds.contains(where: {$0.contains(itemColors[indexPath.row].first?.tableName ?? "")}) {
                    cell.btnWatchAds.isHidden = false
                }
            } else {
                cell.btnWatchAds.isHidden = true
                cell.viewWatchADS.isHidden = true
                if !isWarchAds.contains(where: {$0.contains(itemColors[indexPath.row].first?.tableName ?? "")}) {
                    cell.btnWatchAds.isHidden = !(itemColors[indexPath.row].first?.isPremium ?? true)
                }
            }
        } else {
            // ẩn icon premium dành cho thị trường ko có IAP
            cell.btnWatchAds.isHidden = true
            if !isWarchAds.contains(where: {$0.contains(itemColors[indexPath.row].first?.tableName ?? "")})  {
                cell.viewWatchADS.isHidden = !(itemColors[indexPath.row].first?.isPremium ?? true)
            } else {
                cell.viewWatchADS.isHidden = true
            }
        }
        
        // check đã mua IAP ẩn ic Premium và ic watch ADS
        if IAPState.isUserVip {
            cell.viewWatchADS.isHidden = true
            cell.btnWatchAds.isHidden = true
        }
        
        cell.setupData(data: itemColors[indexPath.row], width: (350 / (8 * 7) / 5))
        if indexPath.row == indexListColor {
            cell.viewColor.borderWidth = 2
        } else {
            cell.viewColor.borderWidth = 0
        }
        cell.selectColor = {[weak self] index in
            guard let self = self else {return}
            
            // nếu đã mua IAP hoặc đã xem quảng cáo bỏ qua quảng cáo
            if IAPState.isUserVip || isWarchAds.contains(where: {$0.contains(self.itemColors[indexPath.row].first?.tableName ?? "")}) {
                selectTableColor(indexPath, index: index)
                return
            }
             //Check có thị trường show IAP
            guard UserDefaultManager.ABShowIAPColoring else {
                if itemColors[indexPath.row].first?.isPremium ?? true {
                    self.showRew(indexPath, index: index)
                } else {
                    selectTableColor(indexPath, index: index)
                }
                return
            }
            if UserDefaultManager.ABis_free_trial_us {
                self.showRew(indexPath, index: index)
            } else {
                if itemColors[indexPath.row].first?.isPremium ?? true {
                    self.showIAP(indexPath, index: index)
                } else {
                    selectTableColor(indexPath, index: index)
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if IAPState.isUserVip || isWarchAds.contains(where: {$0.contains(itemColors[indexPath.row].first?.tableName ?? "")}) {
            selectTableColor(indexPath)
            return
        }
         //Check có thị trường show IAP
        guard UserDefaultManager.ABShowIAPColoring else {
            if itemColors[indexPath.row].first?.isPremium ?? true {
                showRew(indexPath)
            } else {
                selectTableColor(indexPath)
            }
            return
        }
        if UserDefaultManager.ABis_free_trial_us {
            self.showRew(indexPath)
        } else {
            if itemColors[indexPath.row].first?.isPremium ?? true {
                showIAP(indexPath)
            } else {
                showRew(indexPath)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension TableColorIpadController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return PalettesColor.Texture.palettes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: FillterColorCell.self)
        let index = indexPath.row
        cell.setupData(index, isSelect: indexColorBling == index)
        switch PalettesColor.Texture.palettes[index] {
        case .Bling:
            cell.imageView.image = R.image.ic_Bling()
        case .Butterfly:
            cell.imageView.image = R.image.ic_Butterfly()
        case .BlingBling:
            cell.imageView.image = R.image.ic_BlingBling()
        case .SnowFlakes:
            cell.imageView.image = R.image.ic_SnowFlakes()
        case .Bling3:
            cell.imageView.image = R.image.ic_Bling3()
        case .Bubble:
            cell.imageView.image = R.image.ic_Bubble()
        case .Snow:
            cell.imageView.image = R.image.ic_Snow()
        default:
            break
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        indexColorBling = indexPath.row
        updateThemeColor()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.frame.height
        return CGSize(width: height, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func showRew(_ indexPath: IndexPath, index: Int = 0) {
        if IAPState.isUserVip || isWarchAds.contains(where: { $0.contains(self.itemColors[indexPath.row].first?.tableName ?? "") }) {
            selectTableColor(indexPath, index: index)
        } else {
                self.showInter(indexPath, index: index)
        }
    }
    
    func showInter(_ indexPath: IndexPath, index: Int = 0) {
        self.selectTableColor(indexPath, index: index)
    }
    
    func showIAP(_ indexPath: IndexPath, index: Int = 0) {
        if IAPState.isUserVip ||  isWarchAds.contains(where: {$0.contains(self.itemColors[indexPath.row].first?.tableName ?? "")}) {
            selectTableColor(indexPath, index: index)
        } else {
            SubcriptionViewController.show(checkTime: true) {
                if DollColoringAdID.inter_after_iap.isEnableAd {
                    AdLoadingView.show()
                    ADManager.shared.loadFull(DollColoringAdID.inter_after_iap) {_ in
                        AdLoadingView.dismiss()
                    }
                }
            } onClickCLose: {
                self.showRew(indexPath, index: index)
            }
        }
    }
    
    func selectTableColor(_ indexPath: IndexPath, index: Int = 0) {
        selectColors?(self.itemColors[indexPath.row], indexPath.row, self.indexColorBling, self.palettes, index)
        removeAnimate()
    }
}

extension TableColorIpadController {
    
    func showInView(parent: UIViewController) {
        self.view.translatesAutoresizingMaskIntoConstraints = false
        parent.addChild(self)
        parent.view.addSubview(self.view)
        updateConstraints(parent.view)
        self.didMove(toParent: parent.parent)
        self.showAnimate()
    }
    
    private func showAnimate() {
        view.showTranformRight(0)
    }
    
    private func removeAnimate(completion: (() -> Void)? = nil) {
        view.hideTranformToRight(0) { finished in
            if finished {
                completion?()
                self.view.alpha = 0.0
                self.willMove(toParent: nil)
                self.view.removeFromSuperview()
                self.removeFromParent()
            }
        }
    }
    
    private func updateConstraints(_ parentView: UIView) {
        guard let view = self.view else { return }
        let bottomConstraint = NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: parentView, attribute: .bottom, multiplier: 1, constant: 0)
        let leadingConstraint = NSLayoutConstraint(item: view, attribute: .leading, relatedBy: .equal, toItem: parentView, attribute: .leading, multiplier: 1, constant: 0)
        let trailingContraint = NSLayoutConstraint(item: view, attribute: .trailing, relatedBy: .equal, toItem: parentView, attribute: .trailing, multiplier: 1, constant: 0)
        let topConstraint = NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: parentView, attribute: .top, multiplier: 1, constant: 0)
        NSLayoutConstraint.activate([
            topConstraint,
            bottomConstraint,
            leadingConstraint,
            trailingContraint
        ])
    }
}
