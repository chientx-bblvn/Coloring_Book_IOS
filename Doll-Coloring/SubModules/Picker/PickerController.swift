//
//  PickerController.swift
// Doll-Coloring
//
//  Created by BBLabs on 11/10/21.
//  Copyright © 2021 BBLabs.All rights reserved.
//

import Foundation
import RxSwift
import UIKit

class PickerController: BaseViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    @IBOutlet private weak var viewDimer: UIView!
    @IBOutlet private weak var viewContainer: UIStackView!
    @IBOutlet private weak var topView: UIView!
    @IBOutlet private weak var btnCancel: UIButton!
    @IBOutlet private weak var btnDone: UIButton!
    @IBOutlet private weak var pickerView: UIPickerView!
    
    var arrayValue: [(value: String, enable: Bool)] = []
    var currentItemPick = ""
    var handlePickItem: ((_ value: String) -> Void)?
    
    class func show(in parent: UIViewController, current: String, list: [(value: String, enable: Bool)], completion: @escaping ((_ value: String) -> Void)) {
        if let picker = PickerRoute.picker.screen as? PickerController {
            picker.currentItemPick = current
            picker.arrayValue = list
            picker.handlePickItem = completion
            picker.showInView(parent: parent)
        }
    }
    
    override func setup() {
        super.setup()
        topView.roundCorners(corners: [.layerMinXMinYCorner, .layerMaxXMinYCorner], radius: 16)
        viewDimer.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clickClose(_:))))
        pickerView.delegate = self
        if let index = arrayValue.firstIndex(where: { (value, _) in
            value.elementsEqual(self.currentItemPick)
        }) {
            pickerView.selectRow(index, inComponent: 0, animated: true)
        }
    }
    
    override func bindingData() {
        super.bindingData()
        btnCancel.setTitle(LocalizableUtils.commonCancel(), for: .normal)
        btnDone.setTitle(LocalizableUtils.commonConfirm(), for: .normal)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrayValue.count
    }
    
    // return item pick in array
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let item = arrayValue[row]
        guard item.enable else {
            if let lastIndex = arrayValue.lastIndex(where: {
                $0.enable
            }) {
                pickerView.selectRow(lastIndex, inComponent: component, animated: true)
                currentItemPick = arrayValue[lastIndex].value
                return
            }
            currentItemPick = ""
            return
        }
        currentItemPick = item.value
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let labelString = UILabel(frame: CGRect(x: 0, y: 0, width: pickerView.frame.width, height: 44))
        let val = arrayValue[row]
        labelString.textColor = val.enable ? "#131D36".hexStringToUIColor() : "#131D36".hexStringToUIColor(0.5)
        labelString.font = .systemFont(ofSize: 18)
        labelString.text = val.value
        labelString.textAlignment = .center
        return labelString
        
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return pickerView.frame.width
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return arrayValue[row].value
    }
    
    @IBAction func clickClose(_ sender: Any) {
        removeAnimate()
    }
    
    @IBAction func clickDone(_ sender: Any) {
        if currentItemPick.isEmpty { return }
        removeAnimate {
            self.handlePickItem?(self.currentItemPick)
        }
    }
    
}

// MARK: - Show/hide view
extension PickerController {
    
    func showInView(parent: UIViewController) {
        self.view.translatesAutoresizingMaskIntoConstraints = false
        parent.addChild(self)
        parent.view.addSubview(self.view)
        updateConstraints(parent.view)
        self.didMove(toParent: parent.parent)
        self.showAnimate()
        
    }
    
    private func showAnimate() {
        self.viewContainer.transform.ty = self.viewContainer.frame.origin.y + self.viewContainer.frame.height
        self.viewDimer.alpha = 0.0
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       options: .curveEaseInOut,
                       animations: {
                        self.viewDimer.alpha = 1.0
                        self.viewContainer.transform = .identity
                       })
    }
    
    private func removeAnimate(completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       options: .curveEaseInOut,
                       animations: {
                        self.viewContainer.transform.ty = self.viewContainer.frame.origin.y + self.viewContainer.frame.height
                        self.viewDimer.alpha = 0.0
                        completion?()
                       }, completion: {(finished: Bool) in
                        if finished {
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
