//
//  HistoryColoringController.swift
//  Doll-Coloring
//
//  Created by Việt Anh Nguyễn on 10/04/2024.
//  
//

import Foundation
import RxSwift
import UIKit

class HistoryColoringController: BaseViewController {
    
    var viewModel: HistoryColoringVM!
    
    @IBOutlet weak var viewContent: UIView!

    @IBOutlet weak var imageBackground: UIImageView!
    
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var btnBack: UIButton!
    
    @IBOutlet weak var viewCreate: UIView!
    
    @IBOutlet weak var lbCreate: UILabel!
    
    @IBOutlet weak var viewHistory: UIView!

    @IBOutlet weak var viewHistoryBackground: UIView!

    @IBOutlet weak var imageCreateFrame: UIImageView!

    @IBOutlet weak var createIcon: UIImageView!

    @IBOutlet weak var imageHistoryFrame: UIImageView!

    @IBOutlet weak var separatorLine: UIView!
    
    @IBOutlet weak var lbCurrent: UILabel!
    
    @IBOutlet weak var fsPageView: FSPagerView!
    
    @IBOutlet var contraintView: [NSLayoutConstraint]!
    
    override func setup() {
        super.setup()
        if UIDevice.current.userInterfaceIdiom == .phone {
            contraintView.forEach { contraint in
                contraint.constant = 40
            }
        }
        self.view.alpha = 0.0
        viewContent.transform = .identity.scaledBy(x: 0, y: 0)
        setupView()
        lbCreate.text = LocalizableUtils.commonCreateNew()
        lblTitle.text = LocalizableUtils.commonHistory()
        applyHistoryTheme()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        showAnimate()
        setupView()
    }
    
    override func onLanguageChange() {
        loadLanguage()
    }

    override func bindingData() {
        super.bindingData()
        
    }
    
    func setupView() {
        // Keep the saved page comfortably inside its card instead of letting
        // the pager scale it up to nearly the full history panel.
        fsPageView.itemSize = CGSize(width: fsPageView.frame.height, height: fsPageView.frame.height)
            .applying(CGAffineTransform(scaleX: 0.68, y: 0.68))
        fsPageView.transformer = FSPagerViewTransformer(type: .linear)
        fsPageView.decelerationDistance = FSPagerView.automaticDistance
        fsPageView.register(cellType: HistoryCellCollectionViewCell.self)
        fsPageView.delegate = self
        fsPageView.dataSource = self
        viewCreate.isUserInteractionEnabled = true
        viewCreate.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(actionCreateColoring)))
        loadLanguage()
        
    }

    private func applyHistoryTheme() {
        imageBackground.image = UIImage(named: "history_popup_paper")
        imageBackground.contentMode = .scaleAspectFill
        imageBackground.isHidden = false
        viewContent.backgroundColor = AppTheme.background
        viewContent.layer.cornerRadius = 24
        viewContent.layer.borderWidth = 1
        viewContent.layer.borderColor = AppTheme.border.cgColor
        viewContent.clipsToBounds = true

        // Replace the old dashed-purple frames with soft, app-colored surfaces.
        imageCreateFrame.isHidden = true
        imageHistoryFrame.isHidden = true
        createIcon.widthAnchor.constraint(equalToConstant: 78).isActive = true
        createIcon.heightAnchor.constraint(equalToConstant: 78).isActive = true
        createIcon.image = UIImage(named: "history_create_bunny_plus")
        createIcon.contentMode = .scaleAspectFit

        viewCreate.backgroundColor = AppTheme.primarySoft
        viewCreate.layer.cornerRadius = 18
        viewCreate.layer.borderWidth = 1
        viewCreate.layer.borderColor = AppTheme.border.cgColor
        viewCreate.clipsToBounds = true

        viewHistoryBackground.backgroundColor = AppTheme.surface.withAlphaComponent(0.84)
        viewHistoryBackground.layer.cornerRadius = 18
        viewHistoryBackground.layer.borderWidth = 1
        viewHistoryBackground.layer.borderColor = AppTheme.border.cgColor
        viewHistoryBackground.clipsToBounds = true

        let cornerBunny = UIImageView(image: UIImage(named: "history_corner_bunny"))
        cornerBunny.translatesAutoresizingMaskIntoConstraints = false
        cornerBunny.contentMode = .scaleAspectFit
        cornerBunny.isUserInteractionEnabled = false
        viewHistoryBackground.addSubview(cornerBunny)
        NSLayoutConstraint.activate([
            cornerBunny.leadingAnchor.constraint(equalTo: viewHistoryBackground.leadingAnchor, constant: 6),
            cornerBunny.bottomAnchor.constraint(equalTo: viewHistoryBackground.bottomAnchor, constant: -4),
            cornerBunny.widthAnchor.constraint(equalToConstant: 68),
            cornerBunny.heightAnchor.constraint(equalToConstant: 68)
        ])

        viewHistory.backgroundColor = .clear
        viewHistory.layer.cornerRadius = 18
        viewHistory.clipsToBounds = true
        separatorLine.backgroundColor = AppTheme.border
        lblTitle.textColor = AppTheme.text
        lblTitle.font = .systemFont(ofSize: 24, weight: .bold)
        lbCreate.textColor = AppTheme.primary
        lbCreate.font = .systemFont(ofSize: 18, weight: .bold)
        lbCurrent.textColor = AppTheme.primary
        lbCurrent.font = .systemFont(ofSize: 20, weight: .bold)

        let closeImage = UIImage(systemName: "xmark")?.withConfiguration(
            UIImage.SymbolConfiguration(pointSize: 12, weight: .bold)
        )
        btnBack.setImage(closeImage, for: .normal)
        btnBack.tintColor = AppTheme.primary
        btnBack.backgroundColor = AppTheme.primarySoft
        btnBack.layer.cornerRadius = 18
        btnBack.clipsToBounds = true
    }
    
    func loadLanguage() {
        lbCreate.text = LocalizableUtils.commonCreateNew()
        lblTitle.text = LocalizableUtils.commonHistory()
        lbCurrent.text = LocalizableUtils.commonContinue()
    }
    
    @objc private func actionCreateColoring() {
        AppRouter.shared.dismiss(animated: false)
        AppRouter.shared.navigate(to: PreviewColoringRoute.main(coloring: viewModel.coloringAPI, coloringLocal: viewModel.coloring, history: nil, typeScreen: viewModel.typeScreen), with: .push)
    }
    
    @IBAction func btnDismiss(_ sender: Any) {
        removeAnimate {
            AppRouter.shared.dismiss()
        }
    }
}

extension HistoryColoringController: FSPagerViewDelegate, FSPagerViewDataSource {
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        viewModel.coloring.historys.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(for: index, cellType: HistoryCellCollectionViewCell.self)
        let data = viewModel.coloring.historys[index].imagePath
        cell.customGenerateOuterShadow(shadowOpacity: 1, shadowRadius: 0, color: UIColor(hexString: "000000"), shadowOffset: CGSize(width: 2, height: 2))
        cell.imageView.contentMode = .scaleAspectFit
        cell.imageView.backgroundColor = AppTheme.surface
        cell.imageView.setLocalImage(with: FileManagerLocal.shared.getFileFoderFileUssing(typeFile: .ColoringSave, file: data).path, placeholder: nil)
        cell.progressRing.backgroundColor = AppTheme.surface
        cell.progressRing.layer.cornerRadius = 19
        cell.progressRing.layer.borderWidth = 1
        cell.progressRing.layer.borderColor = AppTheme.border.cgColor
        cell.progressRing.clipsToBounds = true
        cell.progressRing.startColor = AppTheme.primary.withAlphaComponent(0.5)
        cell.progressRing.endColor = AppTheme.primary
        cell.progressRing.grooveColor = AppTheme.border
        cell.lbPercent.textColor = AppTheme.text
        cell.lbPercent.font = .systemFont(ofSize: 10, weight: .bold)
        cell.lbPercent.adjustsFontSizeToFitWidth = true
        let percent = Float(viewModel.coloring.historys[index].percent_complete ?? 0)
        cell.progressRing.isHidden = false
        cell.progressRing.setProgress(percent, animated: true)
        cell.lbPercent.text = "\(Int((percent * 100).rounded()))%"
        return cell
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        pagerView.deselectItem(at: index, animated: true)
        pagerView.scrollToItem(at: index, animated: true)
        AppRouter.shared.dismiss(animated: false)
        AppRouter.shared.navigate(to: PreviewColoringRoute.main(coloring: nil, coloringLocal: viewModel.coloring, history: viewModel.coloring.historys[index], typeScreen: viewModel.typeScreen), with: .push)
    }
    
}

extension HistoryColoringController {
    private func showAnimate() {
        UIView.animate(withDuration: 0.25,
                       delay: 0,
                       options: .curveEaseInOut,
                       animations: {
            self.view.alpha = 1.0
            self.viewContent.transform = .identity.scaledBy(x: 0.94, y: 0.94)
        })
    }

    private func removeAnimate(completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: 0.25,
                       delay: 0,
                       options: .curveEaseInOut,
                       animations: {
            self.viewContent.transform = .identity.scaledBy(x: 0.1, y: 0.1)
        }, completion: {(finished: Bool) in
            if finished {
                completion?()
                self.view.alpha = 0.0
            }
        })
    }
}
