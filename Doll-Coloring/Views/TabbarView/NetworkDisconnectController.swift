//
//  NetworkDisconnectController.swift
//  Doll-Coloring
//
//  Created by Việt Anh Nguyễn on 21/5/24.
//

import UIKit
import Lottie

class NetworkDisconnectController: UIViewController {

    @IBOutlet weak var viewAnimation: LottieAnimationView!
    
    class func show(in parent: UIViewController) {
        let mainStoryboard = UIStoryboard(name: "TabbarView", bundle: nil)
        guard let customView = mainStoryboard.instantiateViewController(withIdentifier: String(describing: self)) as? NetworkDisconnectController else {
            return
        }
        customView.providesPresentationContextTransitionStyle = true
        customView.definesPresentationContext = true
        customView.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        customView.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        customView.showInView(parent: parent)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewAnimation.loadAnimation(file: "animation_dissconnect", loopMode: .loop, autoPlay: true)
    }
    
    func removeView() {
        removeAnimate()
    }
}

extension NetworkDisconnectController {
    
    func showInView(parent: UIViewController) {
        self.view.translatesAutoresizingMaskIntoConstraints = false
        parent.addChild(self)
        parent.view.addSubview(self.view)
        updateConstraints(parent.view)
        self.didMove(toParent: parent.parent)
        self.showAnimate()
        
    }
    
    private func showAnimate() {
        self.view.transform = .identity.scaledBy(x: 0, y: 0)
        self.view.alpha = 0.0
        UIView.animate(withDuration: 0.25,
                       delay: 0,
                       options: .curveEaseInOut,
                       animations: {
            self.view.alpha = 1.0
            self.view.transform = .identity
        })
    }
    
    private func removeAnimate(completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: 0.25,
                       delay: 0,
                       options: .curveEaseInOut,
                       animations: {
            self.view.transform = .identity.scaledBy(x: 0.1, y: 0.1)
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
