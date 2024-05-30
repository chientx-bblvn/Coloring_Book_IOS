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
    
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var btnBack: UIButton!
    
    @IBOutlet weak var viewCreate: UIView!
    
    @IBOutlet weak var lbCreate: UILabel!
    
    @IBOutlet weak var viewHistory: UIView!
    
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
        let transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
//        fsPageView.frame.size.applying(transform)
        fsPageView.itemSize = CGSize(width: fsPageView.frame.height, height: fsPageView.frame.height).applying(transform)
        fsPageView.transformer = FSPagerViewTransformer(type: .coverFlow)
        fsPageView.decelerationDistance = FSPagerView.automaticDistance
        fsPageView.register(cellType: HistoryCellCollectionViewCell.self)
        fsPageView.delegate = self
        fsPageView.dataSource = self
        viewCreate.isUserInteractionEnabled = true
        viewCreate.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(actionCreateColoring)))
        loadLanguage()
        
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
        cell.imageView.setLocalImage(with: FileManagerLocal.shared.getFileFoderFileUssing(typeFile: .ColoringSave, file: data).path, placeholder: nil)
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
            self.viewContent.transform = .identity
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
