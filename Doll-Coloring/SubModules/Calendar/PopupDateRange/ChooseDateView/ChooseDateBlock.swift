//
//  ChooseDateBlock.swift
//  BloodPresure
//
//  Created by BloodPresure on 12/30/19.
//  Copyright © 2019 BloodPresure. All rights reserved.
//

import UIKit

protocol ChooseDateBlockDelegate: AnyObject {
    func didCancelPickingDateRange()
    func didPickDateRange(startDate: Date!, endDate: Date?)
}

class ChooseDateBlock: UIView {
    
    @IBOutlet weak var viewDatePicker: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var dayOfWeeks: UICollectionView!
    
    let cellReuseIdentifier = "CalendarDateRangePickerCell"
    
    weak var delegate: ChooseDateBlockDelegate!
    
    let itemsPerRow = 7
    let collectionViewInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
    
    var minimumDate: Date!
    var maximumDate: Date!
    
    var selectedStartDate: Date?
    var selectedEndDate: Date?
    
    var selectedColor = R.color.mainPrimary()!
    let nibName: String = "ChooseDateBlock"
    var view: UIView!
    var viewModel: ChooseDateVM!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetUp()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetUp()
    }
    
    func xibSetUp() {
        view = loadViewFromNib()
        view.frame = self.bounds
        view.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        addSubview(view)
        commonInit()
    }
    
    func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
    func commonInit() {
        viewModel = ChooseDateVM()
        // collectionview
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.clear
        collectionView.register(cellType: CalendarMonthCell.self)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        //day of week
        dayOfWeeks.dataSource = self
        dayOfWeeks.delegate = self
        dayOfWeeks.register(CalendarDateRangePickerCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
        dayOfWeeks.contentInset = collectionViewInsets
        
        if minimumDate == nil {
            minimumDate = Calendar.current.date(byAdding: .year, value: -10, to: Date())
        }
        if maximumDate == nil {
            maximumDate = Calendar.current.date(byAdding: .year, value: 10, to: Date())
        }
    }
    
    func scrollToSelectedDate() {
        if let startDate = selectedStartDate {
            let monthSelectStart = Calendar.current.dateComponents([.month], from: minimumDate, to: startDate).month ?? 0
            let daySelectStart = Calendar.current.dateComponents([.day], from: startDate).day ?? 0
            let firstDateForSection = getFirstDateForSection(section: monthSelectStart, startDate)
            let blankItems = getWeekday(date: firstDateForSection) - 1
            var position = blankItems + daySelectStart
            let daysInMonth = getNumberOfDaysInMonth(date: firstDateForSection)
            if position >= daysInMonth {
                position = daysInMonth - 1
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                self.collectionView.scrollToItem(at: IndexPath(row: position, section: monthSelectStart), at: .centeredHorizontally, animated: false)
            }
        }
    }
}

extension ChooseDateBlock: UICollectionViewDataSource, UICollectionViewDelegate {
    
    //     UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.dayOfWeeks {
            return 7
        }
        let difference = Calendar.current.dateComponents([.month], from: minimumDate, to: maximumDate)
        return (difference.month ?? 0) + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.dayOfWeeks {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CalendarDateRangePickerCell", for: indexPath) as! CalendarDateRangePickerCell
            cell.label.text = getWeekdayLabel(weekday: indexPath.item + 1).uppercased()
            cell.label.textColor = R.color.textColor()
            cell.label.font = .systemFont(ofSize: 14, weight: .bold)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: CalendarMonthCell.self)
            cell.selectedColor = self.selectedColor
            cell.setupView(index: indexPath.row, selectedStartDate: selectedStartDate, selectedEndDate: selectedEndDate, minimumDate: minimumDate)
            return cell
        }
    }
    
    func getMonthLabelChooseDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        dateFormatter.locale = Constants.currentLanguage.locale
        return dateFormatter.string(from: date)
    }
}
extension ChooseDateBlock: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding = collectionViewInsets.left + collectionViewInsets.right
        let availableWidth = view.frame.width - padding
        let itemWidth = availableWidth / CGFloat(itemsPerRow)
        let itemHeight: CGFloat = collectionView.frame.height
        if collectionView == self.dayOfWeeks {
            return CGSize(width: itemWidth, height: 40)
        } else {
            return CGSize(width: collectionView.frame.width, height: itemHeight)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
