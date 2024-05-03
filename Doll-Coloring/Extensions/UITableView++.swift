//
//  UITableView++.swift
// Doll-Coloring
//
//  Created by BBLabs on 12/7/21.
//  Copyright © 2021 BBLabs.All rights reserved.
//

import Foundation
import UIKit

extension UICollectionView: UIGestureRecognizerDelegate {
    
    typealias HandlerLongPressItem = ((_ indexPath: IndexPath) -> Void)
    fileprivate static var handleItemLongPress: HandlerLongPressItem?
    
    func addLongPressItem(handler: HandlerLongPressItem?) {
        UICollectionView.handleItemLongPress = handler
        let longPressedGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gestureRecognizer:)))
        longPressedGesture.minimumPressDuration = 0.5
        longPressedGesture.delegate = self
        longPressedGesture.delaysTouchesBegan = true
        addGestureRecognizer(longPressedGesture)
    }
    
    @objc func handleLongPress(gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state != .began {
            return
        }
        let point = gestureRecognizer.location(in: self)
        
        if let indexPath = self.indexPathForItem(at: point) {
            print("Long press at item: \(indexPath.row)")
            UICollectionView.handleItemLongPress?(indexPath)
        }
    }
    
}

extension UICollectionView {
    
    func showEmptyData(description: String = "",
                       descriptionColor: UIColor = UIColor(red: 1, green: 1.0, blue: 1.0, alpha: 1.0),
                       font: UIFont = .boldSystemFont(ofSize: 16),
                       title: String = "",
                       onButtonAction: (() -> Void)? = nil) -> EmptyView {
        let emptyView = EmptyView.createViewFromNib() ?? EmptyView()
        emptyView.loadData(description,
                           descriptionColor: descriptionColor,
                           font: font,
                           titleButton: title,
                           actionButton: onButtonAction)
        self.backgroundView = emptyView
        return emptyView
    }
    
    func hideEmptyData() {
        self.backgroundView = nil
    }
    
    func reloadWithXAnimation() {
        self.reloadData()
        let tableViewHeight = self.bounds.size.width
        let cells = self.visibleCells
        var delayCounter = 0
        for cell in cells {
            cell.transform = CGAffineTransform(translationX: tableViewHeight, y: 0)
        }
        for cell in cells {
            UIView.animate(withDuration: 1.0, delay: 0.08 * Double(delayCounter), usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
                cell.transform = CGAffineTransform.identity
            }, completion: nil)
            delayCounter += 1
        }
    }
    
    func reloadWithYAnimation() {
        self.reloadData()
        let tableViewHeight = self.bounds.size.height
        let cells = self.visibleCells
        var delayCounter = 0
        for cell in cells {
            cell.transform = CGAffineTransform(translationX: 0, y: tableViewHeight)
        }
        for cell in cells {
            UIView.animate(withDuration: 1.0, delay: 0.08 * Double(delayCounter), usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
                cell.transform = CGAffineTransform.identity
            }, completion: nil)
            delayCounter += 1
        }
    }
    
    public func scrollToPage(_ itemWidth: CGFloat, section: Int) {
        var currentCellOffset = contentOffset
        currentCellOffset.x += itemWidth / 2
        var path = indexPathForItem(at: currentCellOffset)
        if path == nil {
            let page = Int((contentOffset.x + itemWidth / 2) / itemWidth)
            path = IndexPath(row: page, section: section)
        }
        if path != nil {
            scrollToItem(at: path!, at: .centeredHorizontally, animated: true)
        }
    }
    
    func scrollToNearestVisibleCollectionViewCell() {
        self.decelerationRate = UIScrollView.DecelerationRate.fast
        let visibleCenterPositionOfScrollView = Float(self.contentOffset.x + (self.bounds.size.width / 2))
        var closestCellIndex = -1
        var closestDistance: Float = .greatestFiniteMagnitude
        for index in 0..<self.visibleCells.count {
            let cell = self.visibleCells[index]
            let cellWidth = cell.bounds.size.width
            let cellCenter = Float(cell.frame.origin.x + cellWidth / 2)
            
            // Now calculate closest cell
            let distance: Float = fabsf(visibleCenterPositionOfScrollView - cellCenter)
            if distance < closestDistance {
                closestDistance = distance
                closestCellIndex = self.indexPath(for: cell)!.row
            }
        }
        if closestCellIndex != -1 {
            self.scrollToItem(at: IndexPath(row: closestCellIndex, section: 0), at: .centeredHorizontally, animated: true)
        }
    }
    
    func reloadData(_ completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0, animations: {
            self.reloadData()
        }, completion: { _ in
            completion()
        })
    }
    
    func scrollToBottom(animated: Bool = true) {
        let item = self.numberOfItems(inSection: 0) - 1
        let lastItemIndex = IndexPath(item: item, section: 0)
        self.scrollToItem(at: lastItemIndex, at: .top, animated: animated)
    }
}

extension UITableView {
    
    func showEmptyData(description: String = "",
                       descriptionColor: UIColor = UIColor(red: 1, green: 1.0, blue: 1.0, alpha: 1.0),
                       font: UIFont = .boldSystemFont(ofSize: 16),
                       title: String = "",
                       onButtonAction: (() -> Void)? = nil) -> EmptyView {
        let emptyView = EmptyView.createViewFromNib() ?? EmptyView()
        emptyView.loadData(description,
                           descriptionColor: descriptionColor,
                           font: font,
                           titleButton: title,
                           actionButton: onButtonAction)
        self.backgroundView = emptyView
        return emptyView
    }
    
    func hideEmptyData() {
        self.backgroundView = nil
    }
    
    func reloadWithAnimation() {
        self.reloadData()
        let tableViewHeight = self.bounds.size.height
        let cells = self.visibleCells
        for cell in cells {
            cell.transform = CGAffineTransform(translationX: 0, y: tableViewHeight)
            cell.alpha = 0
        }
        var delayCounter = 0
        for cell in cells {
            UIView.animate(withDuration: 1.0, delay: 0.08 * Double(delayCounter), usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
                cell.transform = CGAffineTransform.identity
                cell.alpha = 1.0
            }, completion: nil)
            delayCounter += 1
        }
    }
    
    func scrollToLastPosition(position: Int) {
//        let lastScrollOffset = contentOffset
        UIView.performWithoutAnimation {
            UIView.setAnimationsEnabled(false)
            beginUpdates()
            reloadSections([position], with: .none)
            endUpdates()
            UIView.setAnimationsEnabled(true)
            layer.removeAllAnimations()
//            setContentOffset(lastScrollOffset, animated: false)
            scrollToRow(at: IndexPath(row: NSNotFound, section: position), at: .none, animated: false)
        }
    }
}
