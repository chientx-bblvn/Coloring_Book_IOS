//
//  CalendarMonthCell.swift
//  Doll-Coloring
//
//  Created by MacBookPro on 5/8/24.
//

import UIKit
import Reusable

class CalendarMonthCell: UICollectionViewCell, NibReusable {
    
    
    let cellReuseIdentifier = "CalendarDateRangePickerCell"
    let collectionViewInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
    
    var minimumDate: Date!
    var selectedColor = R.color.mainPrimary()!
    var selectedStartDate: Date?
    var selectedEndDate: Date?
    let itemsPerRow = 7
    var indexCell: Int = 0
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    func setupView(index: Int, selectedStartDate: Date?, selectedEndDate: Date?, minimumDate: Date) {
        indexCell = index
        self.minimumDate = minimumDate
        self.selectedEndDate = selectedEndDate
        self.selectedStartDate = selectedStartDate
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.clear
        collectionView.register(CalendarDateRangePickerCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
        collectionView.contentInset = collectionViewInsets
    }

}

extension CalendarMonthCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let firstDateForSection = getFirstDateForSection(section: indexCell, minimumDate)
        let blankItems = getWeekday(date: firstDateForSection) - 1
        let daysInMonth = getNumberOfDaysInMonth(date: firstDateForSection)
        return blankItems + daysInMonth
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as! CalendarDateRangePickerCell
        cell.selectedColor = self.selectedColor
        cell.reset()
        let blankItems = getWeekday(date: getFirstDateForSection(section: indexCell, minimumDate)) - 1
        if indexPath.item < blankItems {
            cell.label.text = ""
        } else {
            let dayOfMonth = indexPath.item - (blankItems) + 1
            let date = getDate(dayOfMonth: dayOfMonth, section: indexCell, minimumDate)
            cell.date = date
            cell.label.text = "\(dayOfMonth)"
            
            if isBefore(dateA: date, dateB: minimumDate) {
                cell.disable()
            }
            
            if selectedStartDate != nil && selectedEndDate != nil && isBefore(dateA: selectedStartDate ?? Date(), dateB: date) && isBefore(dateA: date, dateB: selectedEndDate ?? Date()) {
                // Cell falls within selected range
                if dayOfMonth == 1 {
                    cell.highlightRight()
                } else if dayOfMonth == getNumberOfDaysInMonth(date: date) {
                    cell.highlightLeft()
                } else {
                    cell.highlight()
                }
            } else if selectedStartDate != nil && areSameDay(dateA: date, dateB: selectedStartDate ?? Date()) {
                // Cell is selected start date
                cell.select()
                if selectedEndDate != nil {
                    cell.highlightRight()
                }
            } else if selectedEndDate != nil && areSameDay(dateA: date, dateB: selectedEndDate ?? Date()) {
                cell.select()
                cell.highlightLeft()
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CalendarDateRangePickerCell
        if cell.date == nil {
            return
        }
        if isBefore(dateA: cell.date ?? Date(), dateB: minimumDate) {
            return
        }
        if selectedStartDate == nil {
            selectedStartDate = cell.date
        } else if selectedEndDate == nil {
            if isBefore(dateA: selectedStartDate ?? Date(), dateB: cell.date ?? Date()) {
                selectedEndDate = cell.date
            } else {
                // If a cell before the currently selected start date is selected then just set it as the new start date
                selectedStartDate = cell.date
            }
        } else {
            selectedStartDate = cell.date
            selectedEndDate = nil
        }
//        delegate?.didPickDateRange(startDate: selectedStartDate, endDate: selectedEndDate)
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding = collectionViewInsets.left + collectionViewInsets.right
        let availableWidth = self.frame.width - padding
        let itemWidth = availableWidth / CGFloat(itemsPerRow)
        let itemHeight: CGFloat = (collectionView.frame.height - 30) / 5
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
