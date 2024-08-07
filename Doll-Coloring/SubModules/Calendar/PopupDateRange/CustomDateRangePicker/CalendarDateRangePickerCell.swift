//
//  CalendarDateRangePickerCell.swift
//  CalendarDateRangePickerViewController
//
//  Created by Miraan on 15/10/2017.
//  Copyright © 2017 Miraan. All rights reserved.
//

import UIKit

class CalendarDateRangePickerCell: UICollectionViewCell {
    
    private let defaultTextColor = UIColor.black
    private let highlightedColor = R.color.mainPrimary()
    private let disabledColor = UIColor.black.withAlphaComponent(0.5)
    
    var selectedColor: UIColor!
    
    var date: Date?
    var selectedView: UIView?
    var halfBackgroundView: UIView?
    var roundHighlightView: UIView?
    var showImage = false {
        didSet {
            self.imageView.isHidden = !self.showImage
            self.label.isHidden = self.showImage
        }
    }
    var imageView: UIImageView!
    var label: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func initLabel() {
        label = UILabel(frame: frame)
        label.center = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
        label.font = .systemFont(ofSize: 16)
        label.textColor = R.color.textColor()
        label.textAlignment = NSTextAlignment.center
        self.addSubview(label)
    }
    
    func initImageView() {
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        imageView?.center = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
        imageView?.contentMode = .scaleAspectFit
        self.addSubview(imageView)
    }
    
    func commonInit() {
        initLabel()
        initImageView()
        self.showImage = false
    }
    
    func reset() {
        self.backgroundColor = UIColor.clear
        label.textColor = defaultTextColor
        self.showImage = false
        label.backgroundColor = UIColor.clear
        if selectedView != nil {
            selectedView?.removeFromSuperview()
            selectedView = nil
        }
        if halfBackgroundView != nil {
            halfBackgroundView?.removeFromSuperview()
            halfBackgroundView = nil
        }
        if roundHighlightView != nil {
            roundHighlightView?.removeFromSuperview()
            roundHighlightView = nil
        }
    }
    
    func select() {
        let width = self.frame.size.width
        let height = self.frame.size.height
        selectedView = UIView(frame: CGRect(x: (width - height) / 2, y: 0, width: height, height: height))
        selectedView?.backgroundColor = selectedColor
        selectedView?.layer.cornerRadius = 4
        self.addSubview(selectedView ?? UIView())
        self.sendSubviewToBack(selectedView ?? UIView())
        label.textColor = UIColor.white
    }
    
    func highlightRight() {
        // This is used instead of highlight() when we need to highlight cell with a rounded edge on the left
        let width = self.frame.size.width
        let height = self.frame.size.height
        halfBackgroundView = UIView(frame: CGRect(x: width / 2, y: 0, width: width / 2, height: height))
        halfBackgroundView?.backgroundColor = highlightedColor
        self.addSubview(halfBackgroundView ?? UIView())
        self.sendSubviewToBack(halfBackgroundView ?? UIView())
        addRoundHighlightView()
        label.textColor = UIColor.white
    }
    
    func highlightLeft() {
        // This is used instead of highlight() when we need to highlight the cell with a rounded edge on the right
        let width = self.frame.size.width
        let height = self.frame.size.height
        halfBackgroundView = UIView(frame: CGRect(x: 0, y: 0, width: width / 2, height: height))
        halfBackgroundView?.backgroundColor = highlightedColor
        self.addSubview(halfBackgroundView ?? UIView())
        self.sendSubviewToBack(halfBackgroundView ?? UIView())
        addRoundHighlightView()
        label.textColor = UIColor.white
    }
    
    func addRoundHighlightView() {
        let width = self.frame.size.width
        let height = self.frame.size.height
        roundHighlightView = UIView(frame: CGRect(x: (width - height) / 2, y: 0, width: height, height: height))
        roundHighlightView?.backgroundColor = highlightedColor
        roundHighlightView?.layer.cornerRadius = 4
        self.addSubview(roundHighlightView ?? UIView())
        self.sendSubviewToBack(roundHighlightView ?? UIView())
    }
    
    func highlight() {
        self.backgroundColor = highlightedColor
        label.textColor = UIColor.white
    }
    
    func disable() {
        label.textColor = disabledColor
    }
    
}
