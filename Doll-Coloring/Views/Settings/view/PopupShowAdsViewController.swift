//
//  PopupShowAdsViewController.swift
//  Doll-Coloring
//
//  Created by Việt Anh Nguyễn on 10/6/24.
//

import UIKit

class PopupShowAdsViewController: BaseViewController {
    
    @IBOutlet weak var viewContent: UIView!
    
    @IBOutlet weak var btnClose: UIButton!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var viewPlayAds: UIView!
    @IBOutlet weak var lbAds: UILabel!
    @IBOutlet weak var lbWatchAds: UILabel!
    
    @IBOutlet weak var viewShowIAP: UIView!
    @IBOutlet weak var lbIAP: UILabel!
    
    @IBOutlet weak var listColor: UITableView!
    
    
    var data: ColoringImage?
    var colors: [ItemColor?] = []
    
    var actionShowADS: (() -> Void)?
    var actionShowIAP: (() -> Void)?
    
    class func show(in parent: UIViewController, data: ColoringImage? = nil, colors: [ItemColor?] = [], _ actionShowADS: (() -> Void)?, _ actionShowIAP: (() -> Void)?) {
        let mainStoryboard = UIStoryboard(name: "Settings", bundle: nil)
        guard let customView = mainStoryboard.instantiateViewController(withIdentifier: String(describing: self)) as? PopupShowAdsViewController else {
            return
        }
        customView.providesPresentationContextTransitionStyle = true
        customView.definesPresentationContext = true
        customView.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        customView.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        customView.data = data
        customView.colors = colors
        customView.actionShowADS = actionShowADS
        customView.actionShowIAP = actionShowIAP
        customView.showInView(parent: parent)
    }
    
    override func setup() {
        super.setup()
        loadLanguage()
        setupView()
    }
    
    @IBAction func actionClose(_ sender: Any) {
        removeAnimate()
    }
    
    @objc private func onclickClose() {
        removeAnimate()
    }
    
    @objc private func onclickShowAds() {
        removeAnimate {
            self.actionShowADS?()
        }
    }
    
    @objc private func onclickShowIAP() {
        removeAnimate {
            self.actionShowIAP?()
        }
    }
}

extension PopupShowAdsViewController {
    
    func setupView() {
        viewShowIAP.isHidden = !UserDefaultManager.ABShowIAPColoring
        viewPlayAds.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onclickShowAds)))
        viewShowIAP.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onclickShowIAP)))
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onclickClose)))
        imageView.setImage(with: "/doll-coloring2/canvas/" + (data?.filePath ?? ""))
        imageView.generateOuterShadow()
        listColor.delegate = self
        listColor.dataSource = self
        listColor.register(cellType: TableColorCell.self)
    }
    
    func loadLanguage() {
        lbIAP.text = LocalizableUtils.commonUnlockColoring()
        lbAds.text = LocalizableUtils.commonUnlockForFree()
        lbWatchAds.text = LocalizableUtils.commonWatchAShortVideo()
    }
    
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

extension PopupShowAdsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if colors.isEmpty {
            return 0
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TableColorCell") as? TableColorCell else {
            return UITableViewCell()
        }
        cell.lblName.text = colors.first??.tableName
        cell.btnWatchAds.isHidden = true
        cell.setupData(data: colors, width: (tableView.frame.width / (4 * 4) / 3), isColoring: false)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height
    }
}
