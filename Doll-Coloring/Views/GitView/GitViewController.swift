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
    
    @IBOutlet weak var viewButton: UIStackView!
    var name: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        viewButton.isHidden = true
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
            DispatchQueue.main.async {
                self.viewButton.isHidden = false
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
    
    @IBAction func actionClose(_ sender: Any) {
        onClickCloseView()
    }
    
    @IBAction func actionColoring(_ sender: Any) {
        AppRouter.shared.dismiss {
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: NSNotification.Name("GOTODAILY_TABBAR"), object: nil)
            }
        }
    }
}
