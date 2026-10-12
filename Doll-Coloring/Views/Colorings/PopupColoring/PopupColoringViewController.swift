//
//  PopupColoringViewController.swift
//  Doll-Coloring
//
//  Created by Việt Anh Nguyễn on 14/6/24.
//

import UIKit

class PopupColoringViewController: UIViewController {
    
    @IBOutlet weak var viewContent: UIView!

    @IBOutlet weak var imageIcon: UIImageView!
    
    @IBOutlet weak var viewProgressRing: UIView!
    @IBOutlet weak var lbPercenColoring: UILabel!
    
    @IBOutlet weak var lbTitle: UILabel!
    
    @IBOutlet weak var btnDrawing: UIButton!
    
    @IBOutlet weak var btnCancel: UIButton!
    
//    @IBOutlet weak var viewAds: UIView!
//    
//    @IBOutlet weak var heightAdsView: NSLayoutConstraint!
//    
    var titlePopup: String = ""
    var titleOk: String = ""
    var titleCancel: String = ""
    var actionOk: (() -> Void)?
    var actionCancel: (() -> Void)?
    var percent: Double = 0
    
    class func show(in parent: UIViewController, _percent: Double, _title: String, _titleOk: String, _titleCancel: String, actionOk: (() -> Void)? = nil, actionCancel: (() -> Void)? = nil ) {
        let customView = PopupColoringViewController.loadController()
        customView.providesPresentationContextTransitionStyle = true
        customView.definesPresentationContext = true
        customView.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        customView.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        customView.percent = _percent
        customView.titlePopup = _title
        customView.titleOk = _titleOk
        customView.titleCancel = _titleCancel
        customView.actionOk = actionOk
        customView.actionCancel = actionCancel
        customView.showInView(parent: parent)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyCrayoChrome()
        lbTitle.text = titlePopup
        btnCancel.setTitle(titleCancel, for: .normal)
        btnDrawing.setTitle(titleOk, for: .normal)
        if let textStack = viewProgressRing.subviews.compactMap({ $0 as? UIStackView }).first {
            [lbTitle, lbPercenColoring].forEach {
                textStack.removeArrangedSubview($0)
                $0.removeFromSuperview()
            }
            textStack.axis = .vertical
            textStack.alignment = .fill
            textStack.distribution = .fill
            textStack.spacing = 6
            textStack.addArrangedSubview(lbTitle)
            textStack.addArrangedSubview(lbPercenColoring)
        }
    }

    private func applyCrayoChrome() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.35)
        viewContent.backgroundColor = AppTheme.surface
        viewContent.layer.cornerRadius = 24
        viewContent.clipsToBounds = true
        viewContent.layer.borderWidth = 1
        viewContent.layer.borderColor = AppTheme.border.cgColor

        imageIcon.image = UIImage(named: "exit_coloring_bunny")
        imageIcon.contentMode = .scaleAspectFit
        imageIcon.backgroundColor = AppTheme.primarySoft
        imageIcon.layer.cornerRadius = 32
        imageIcon.clipsToBounds = true

        lbTitle.textColor = AppTheme.text
        lbTitle.font = .systemFont(ofSize: 18, weight: .bold)
        lbTitle.numberOfLines = 0
        lbTitle.textAlignment = .center
        lbPercenColoring.textColor = AppTheme.primary
        lbPercenColoring.font = .systemFont(ofSize: 13, weight: .semibold)
        lbPercenColoring.textAlignment = .center

        stylePopupButton(btnDrawing, filled: true)
        stylePopupButton(btnCancel, filled: false)
    }

    private func stylePopupButton(_ button: UIButton, filled: Bool) {
        button.layer.cornerRadius = 18
        button.clipsToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        if filled {
            button.backgroundColor = AppTheme.primary
            button.setTitleColor(AppTheme.onPrimary, for: .normal)
            button.layer.borderWidth = 0
        } else {
            button.backgroundColor = AppTheme.primarySoft
            button.setTitleColor(AppTheme.text, for: .normal)
            button.layer.borderWidth = 1
            button.layer.borderColor = AppTheme.border.cgColor
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        viewProgressRing.setProgress(Float(percent), animated: true)
        let percentage = Int((percent * 100).rounded())
        let format = "Coloring.ProgressComplete".localizedString(
            tableName: "Localizable",
            defaultValue: "%1$d%% complete",
            comment: "Coloring progress percentage"
        )
        lbPercenColoring.text = String(format: format, locale: Constants.currentLanguage.locale, arguments: [percentage])
    }
    
    

    @IBAction func actionCancel(_ sender: Any) {
        removeAnimate {
            self.actionCancel?()
        }
    }
    
    @IBAction func actionDrawing(_ sender: Any) {
        removeAnimate {
            self.actionOk?()
        }
    }
    
//    func loadAds() {
//        viewAds.isHidden = false
//        heightAdsView.constant = 190
//        ADManager.shared.loadNative(DollColoringAdID.native_dialog, to: viewAds, nativeAdType: .customMediaFixedHeight) {[weak self] adId, success, nativeAdView in
//            self?.viewAds.isHidden = !success
//            self?.heightAdsView.constant = success ? 190 : 0
//        }
//    }
}

extension PopupColoringViewController {
    func showInView(parent: UIViewController) {
        self.view.translatesAutoresizingMaskIntoConstraints = false
        parent.addChild(self)
        parent.view.addSubview(self.view)
        updateConstraints(parent.view)
        self.didMove(toParent: parent.parent)
        self.showAnimate()
        
    }
    
    private func showAnimate() {
        self.viewContent.transform = .identity.scaledBy(x: 0, y: 0)
        self.view.alpha = 0.0
        UIView.animate(withDuration: 0.3,
                       delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 1,
                       options: .curveEaseInOut,
                       animations: {
            self.view.alpha = 1.0
            self.viewContent.transform = .identity
        })
    }
    
    private func removeAnimate(completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: 0.3,
                       delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 1,
                       options: .curveEaseInOut,
                       animations: {
            self.viewContent.transform = .identity.scaledBy(x: 0.7, y: 0.7)
            self.view.alpha = 0.0
        }, completion: {(finished: Bool) in
            if finished {
                completion?()
                self.willMove(toParent: nil)
                self.view.removeFromSuperview()
                self.removeFromParent()
            }
        })
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
