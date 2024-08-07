//
//  GitViewController.swift
//  Doll-Coloring
//
//  Created by MacBookPro on 6/8/24.
//

import UIKit
import Lottie

class GitViewController: BaseViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var animationView: LottieAnimationView!
    
    var name: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.isUserInteractionEnabled =  true
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onClickCloseView)))
        animationView.loadAnimation(file: "AnimationGitDaly", loopMode: .autoReverse)
        animationView.isUserInteractionEnabled =  true
        animationView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onClickShowGit(_ :))))
        imageView.setImage(with: name)
    }
    
    

    func anmationShowItem() {
        let fromView = animationView.isHidden ? imageView : animationView
        let toView = animationView.isHidden ? animationView : imageView
        
        UIView.transition(from: fromView ?? UIView(), to: toView ?? UIView(), duration: 0.6, options: [.transitionFlipFromLeft, .showHideTransitionViews], completion: { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                DispatchQueue.main.async {
                    AppRouter.shared.dismiss()
                    NotificationCenter.default.post(name: NSNotification.Name("GOTODAILY_TABBAR"), object: nil)
                }
            }
        })
        
    }
    
    @objc func onClickCloseView() {
        AppRouter.shared.dismiss()
    }
    
    @objc private func onClickShowGit(_ gesture: UIGestureRecognizer) {
        anmationShowItem()
        SQLiteManager.shared.insertTableGitColoring(_id: SQLiteManager.shared.selectionGitColorings().count, _name: name)
    }
}
