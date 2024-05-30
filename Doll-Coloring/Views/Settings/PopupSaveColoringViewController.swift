//
//  PopupSaveColoringViewController.swift
//  Doll-Coloring
//
//  Created by Việt Anh Nguyễn on 30/5/24.
//

import UIKit

class PopupSaveColoringViewController: BaseViewController {
    
    @IBOutlet weak var viewContent: UIView!
    
    @IBOutlet weak var lbTitle: UILabel!
    
    @IBOutlet weak var btnClose: UIButton!
    
    @IBOutlet weak var lbSubTitle: UILabel!
    
    @IBOutlet weak var btnCancel: UIButton!
    
    @IBOutlet weak var btnDelete: UIButton!
    
    var onclickCancel: (() -> Void)?
    var onclickDelete: (() -> Void)?
    
    class func show(in parent: UIViewController, onclickCancel:@escaping (() -> Void), onclickDelete: @escaping (() -> Void) ) {
        let mainStoryboard = UIStoryboard(name: "Settings", bundle: nil)
        guard let customView = mainStoryboard.instantiateViewController(withIdentifier: String(describing: self)) as? PopupSaveColoringViewController else {
            return
        }
        customView.providesPresentationContextTransitionStyle = true
        customView.definesPresentationContext = true
        customView.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        customView.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        customView.onclickCancel = onclickCancel
        customView.onclickDelete = onclickDelete
        customView.showInView(parent: parent)
    }
    
    override func setup() {
        super.setup()
        lbTitle.text = LocalizableUtils.commonSave()
        lbSubTitle.text = LocalizableUtils.save_picture_ads()
        btnCancel.setTitle(LocalizableUtils.commonCancel(), for: .normal)
        btnDelete.setTitle(LocalizableUtils.commonSave(), for: .normal)
    }

    @IBAction func actionClose(_ sender: Any) {
        removeAnimate()
    }
    
    @IBAction func actionCancel(_ sender: Any) {
        onclickCancel?()
        removeAnimate()
    }
    
    @IBAction func actionDelete(_ sender: Any) {
        onclickDelete?()
        removeAnimate()
    }
}

extension PopupSaveColoringViewController {
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
