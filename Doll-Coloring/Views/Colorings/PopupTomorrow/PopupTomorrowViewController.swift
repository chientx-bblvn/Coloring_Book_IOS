//
//  PopupTomorrowViewController.swift
//  Doll-Coloring
//
//  Created by MacBookPro on 7/8/24.
//

import UIKit

class PopupTomorrowViewController: BaseViewController {
    
    
    @IBOutlet weak var viewContent: UIView!
    
    @IBOutlet weak var lbTitle: UILabel!
    
    @IBOutlet weak var btnDone: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
            lbTitle.text = LocalizableUtils.commonCombackTomorrow()
            btnDone.setTitle(LocalizableUtils.commonYes(), for: .normal)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        showAnimate()
    }


    
    @IBAction func actionDone(_ sender: Any) {
        removeAnimate()
    }
    
   
}

extension PopupTomorrowViewController {
    
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
                AppRouter.shared.dismiss(animated: false)
            }
        })
    }
}
