//
//  TableColorIpadController.swift
//  Doll-Coloring
//
//  Created by Việt Anh Nguyễn on 23/5/24.
//  
//

import Foundation
import RxSwift
import UIKit

class TableColorIpadController: BaseViewController {
    
    @IBOutlet var viewFake: [UIView]!
    
    @IBOutlet weak var viewContent: UIView!
    
    @IBOutlet weak var listItemColor: UITableView!
    
    var listColorIpad: [ListColorIpad] = []
    
    var selectColors: (([ItemColor?], _ sectionTable: Int? , _ indexListColor: Int?,_ indexColor: Int?) -> Void)?
    
    var sectionTable: Int? = 0, indexListColor: Int? = 0
    
    class func showView(in parent: UIViewController, sectionTable: Int? = 0, indexListColor: Int? = 0, listColorIpad: [ListColorIpad], selectColors: (([ItemColor?], _ sectionTable: Int? , _ indexListColor: Int?, _ indexColor: Int? ) -> Void)? = nil) {
        let mainStoryboard = UIStoryboard(name: "TableColorIpad", bundle: nil)
        guard let customView = mainStoryboard.instantiateViewController(withIdentifier: String(describing: self)) as? TableColorIpadController else {
            return
        }
        customView.selectColors = selectColors
        customView.listColorIpad = listColorIpad
        customView.sectionTable = sectionTable
        customView.indexListColor = indexListColor
        customView.providesPresentationContextTransitionStyle = true
        customView.definesPresentationContext = true
        customView.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        customView.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        customView.showInView(parent: parent)
    }
    
    override func setup() {
        super.setup()
        setupView()
    }

    override func bindingData() {
        super.bindingData()
    }
    
    func setupView() {
        listItemColor.delegate = self
        listItemColor.dataSource = self
        listItemColor.register(cellType: TableColorCell.self)
        viewContent.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(actionBack)))
        
    }
    
    @objc private func actionBack() {
        removeAnimate()
    }
}

extension TableColorIpadController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return listColorIpad.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listColorIpad[section].listColor.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TableColorCell") as? TableColorCell else {
            return UITableViewCell()
        }
        cell.lblName.text = listColorIpad[indexPath.section].table_name
        cell.setupData(data: listColorIpad[indexPath.section].listColor[indexPath.row], width: (350 / (8 * 7) / 5))
        if indexPath.section == sectionTable && indexPath.row == indexListColor {
            cell.viewContent.borderWidth = 1
        } else {
            cell.viewContent.borderWidth = 0
        }
        cell.selectColor = {[weak self] index in
            self?.selectColors?(self?.listColorIpad[indexPath.section].listColor[indexPath.row] ?? [], indexPath.section, indexPath.row, index)
            self?.removeAnimate()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectColors?(listColorIpad[indexPath.section].listColor[indexPath.row], indexPath.section, indexPath.row, 0)
        removeAnimate()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}

extension TableColorIpadController {
    
    func showInView(parent: UIViewController) {
        self.view.translatesAutoresizingMaskIntoConstraints = false
        parent.addChild(self)
        parent.view.addSubview(self.view)
        updateConstraints(parent.view)
        self.didMove(toParent: parent.parent)
        self.showAnimate()
    }
    
    private func showAnimate() {
        view.showTranformRight(0)
    }
    
    private func removeAnimate(completion: (() -> Void)? = nil) {
        view.hideTranformToRight(0) { finished in
            if finished {
                completion?()
                self.view.alpha = 0.0
                self.willMove(toParent: nil)
                self.view.removeFromSuperview()
                self.removeFromParent()
            }
        }
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
