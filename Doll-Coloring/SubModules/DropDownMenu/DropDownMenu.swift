//
//  DropDownMenu.swift
// Doll-Coloring
//
//  Created by BBLabs on 10/15/19.
//  Copyright © 2021 BBLabs.All rights reserved.
//

import UIKit

class DropDownMenu: UITableViewController {
    var cancelAction: (() -> Void)?
    private var actions: [MenuAction] = []
    internal var width: CGFloat = 150
    internal var height: CGFloat = 350
    
    class func createDropdownMenu(source view: UIView, width: CGFloat = 150,
                                  height: CGFloat = 150, parent: UIViewController,
                                  actions: [MenuAction],
                                  cancel: (() -> Void)? = nil) -> DropDownMenu? {
        let storyboard = UIStoryboard.init(name: "DropDownMenu", bundle: nil)
        guard let actionsMenuVC = storyboard.instantiateViewController(withIdentifier: "DropDownMenu") as? DropDownMenu else {
            return nil
        }
        actionsMenuVC.modalPresentationStyle = .popover
        actionsMenuVC.view.backgroundColor = .white
        actionsMenuVC.definesPresentationContext = true
        actionsMenuVC.providesPresentationContextTransitionStyle = true
        actionsMenuVC.width = width
        actionsMenuVC.height = height
        let presentation = actionsMenuVC.popoverPresentationController
        presentation?.delegate = actionsMenuVC
        presentation?.sourceView = view
        let position = CGRect(x: view.bounds.origin.x, y: view.bounds.origin.y + 55, width: width, height: height)
        presentation?.sourceRect = position
        presentation?.permittedArrowDirections = []
        presentation?.backgroundColor = .white
        
        actionsMenuVC.actions = actions
        actionsMenuVC.cancelAction = {
            cancel?()
        }
        
        parent.present(actionsMenuVC, animated: false)
        return actionsMenuVC
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clear
        tableView.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
        tableView.register(UINib(resource: R.nib.menuActionCell), forCellReuseIdentifier: MenuActionCellConstant.reuseIdentifier)
        tableView.isUserInteractionEnabled = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        cancelAction?()
    }
    
    override func viewWillLayoutSubviews() {
        preferredContentSize = CGSize(width: width, height: height)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return actions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MenuActionCellConstant.reuseIdentifier, for: indexPath) as? MenuActionCell else {
            return UITableViewCell()
        }
        let action = actions[indexPath.row]
        cell.serverName.text = action.title
        cell.serverName.alpha = action.isEnable ? 1.0 : 0.3
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let action = actions[indexPath.row]
        guard action.isEnable else { return }
        DispatchQueue.main.asyncSafety {
            self.dismiss(animated: false) {
                action.successHandler?(action)
                self.cancelAction?()
            }
        }
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

// MARK: - UIPopoverPresentationControllerDelegate
extension DropDownMenu: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
