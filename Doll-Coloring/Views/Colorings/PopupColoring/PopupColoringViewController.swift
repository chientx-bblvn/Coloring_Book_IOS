//
//  PopupColoringViewController.swift
//  Doll-Coloring
//
//  Created by Việt Anh Nguyễn on 14/6/24.
//

import UIKit

class PopupColoringViewController: UIViewController {
    
    @IBOutlet weak var viewContent: UIView!
    
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
//        loadAds()
         viewContent.customGenerateOuterShadow(shadowOpacity: 1, shadowRadius: 0, color: UIColor(hexString: "000000"), shadowOffset: CGSize(width: 4, height: 4))
        lbTitle.text = titlePopup
        btnCancel.setTitle(titleCancel, for: .normal)
        btnCancel.customGenerateOuterShadow(shadowOpacity: 1, shadowRadius: 0, color: UIColor(hexString: "000000"), shadowOffset: CGSize(width: 4, height: 4))
        btnDrawing.setTitle(titleOk, for: .normal)
        btnDrawing.customGenerateOuterShadow(shadowOpacity: 1, shadowRadius: 0, color: UIColor(hexString: "000000"), shadowOffset: CGSize(width: 4, height: 4))
//        viewProgressRing.startColor = UIColor(hexString: "80C4E9").withAlphaComponent(0.5)
//        viewProgressRing.endColor = UIColor(hexString: "80C4E9")
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        viewProgressRing.setProgress(Float(percent), animated: true)
        lbPercenColoring.text = "\(Int((percent * 100).rounded()))%"
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
