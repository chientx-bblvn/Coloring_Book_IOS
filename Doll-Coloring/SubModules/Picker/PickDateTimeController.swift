//
//  PickDateTimeController.swift
// Doll-Coloring
//
//  Created by BBLabs on 11/23/21.
//  Copyright © 2021 BBLabs.All rights reserved.
//

import UIKit

class PickDateTimeController: UIViewController {
    @IBOutlet private weak var viewDimer: UIView!
    @IBOutlet private weak var viewContainer: UIStackView!
    @IBOutlet private weak var topView: UIView!
    @IBOutlet private weak var btnCancel: UIButton!
    @IBOutlet private weak var btnDone: UIButton!
    @IBOutlet private weak var pickerView: UIDatePicker!
    
    var currentDate: Date = Date()
    var minDate: Date?
    var maxDate: Date?
    var handlePickItem: ((_ value: Date) -> Void)?
    
    class func show(in parent: UIViewController,
                    currentDate: Date,
                    minDate: Date? = nil,
                    maxDate: Date? = nil,
                    completion: @escaping ((_ value: Date) -> Void)) {
        if let picker = PickerRoute.pickerDate.screen as? PickDateTimeController {
            picker.currentDate = currentDate
            picker.handlePickItem = completion
            picker.minDate = minDate
            picker.maxDate = maxDate
            picker.showInView(parent: parent)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topView.roundCorners(corners: [.layerMinXMinYCorner, .layerMaxXMinYCorner], radius: 16)
        viewDimer.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clickClose(_:))))
        pickerView.date = currentDate
        pickerView.locale = Constants.currentLanguage.locale
        if let minDate = minDate {
            pickerView.minimumDate = minDate
        }
        if let maxDate = maxDate {
            pickerView.maximumDate = maxDate
        }
        btnCancel.setTitle(LocalizableUtils.commonCancel(), for: .normal)
        btnDone.setTitle(LocalizableUtils.commonConfirm(), for: .normal)
    }
    
    @IBAction func clickClose(_ sender: Any) {
        removeAnimate()
    }
    
    @IBAction func clickDone(_ sender: Any) {
        let dateSelected = pickerView.date
        removeAnimate {
            self.handlePickItem?(dateSelected)
        }
    }
    
}

// MARK: - Show/hide view
extension PickDateTimeController {
    
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
