//
//  NetworkDisconnectController.swift
//  Doll-Coloring
//
//  Created by Việt Anh Nguyễn on 21/5/24.
//

import UIKit
import Lottie


class NetworkDisconnectController: BaseViewController {

    @IBOutlet weak var viewContent: UIView!
    
    @IBOutlet weak var viewAnimation: LottieAnimationView!
    @IBOutlet weak var lbDisconnected: UILabel!
    
    
    class func show() {
        let mainStoryboard = UIStoryboard(name: "TabbarView", bundle: nil)
        guard let customView = mainStoryboard.instantiateViewController(withIdentifier: String(describing: self)) as? NetworkDisconnectController else {
            return
        }
        customView.providesPresentationContextTransitionStyle = true
        customView.definesPresentationContext = true
        customView.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        customView.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        if let vc = UIApplication.shared.windows.first?.rootViewController?.presentedViewController {
            vc.present(customView, animated: true)
        } else if let vc = UIApplication.shared.windows.first?.rootViewController {
            vc.present(customView, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(removeView(_ :)), name: NSNotification.Name(rawValue: "network_connection"), object: nil)
        viewAnimation.loadAnimation(file: "animation_dissconnect", loopMode: .loop, autoPlay: true)
        viewContent.layer.backgroundColor = UIColor(hexString: "98A3F3").cgColor
        viewContent.customGenerateOuterShadow(shadowOpacity: 1, shadowRadius: 0, color: UIColor(hexString: "000000"), shadowOffset: CGSize(width: 4, height: 4))
        showAnimate()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
        viewAnimation.stop()
    }
    
    @objc func removeView(_ notifi: Notification) {
        if let noti = notifi.object as? Bool, noti {
            removeAnimate {
                self.dismiss(animated: true)
            }
        }
    }
}

extension NetworkDisconnectController {
    
    private func showAnimate() {
        self.viewContent.transform = .identity.scaledBy(x: 0, y: 0)
        self.view.alpha = 0.0
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       options: .curveEaseInOut,
                       animations: {
            self.view.alpha = 1.0
            self.viewContent.transform = .identity
        })
    }
    
    private func removeAnimate(completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: 0.3,
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
