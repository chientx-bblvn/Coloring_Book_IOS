//
//  PopupDateRangeController.swift
//  BloodPresure-iOS
//
//  Created by BloodPresure on 04/08/2022.
//  Copyright © 2022 BloodPresure. All rights reserved.
//

import Foundation
import RxSwift
import UIKit

class PopupDateRangeController: BaseDragViewController {
    
    var viewModel: PopupDateRangeVM!
    
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var viewChooseDate: UIView!
    @IBOutlet weak var lbSelectAsset: UILabel!
    @IBOutlet weak var btnFilterTransactions: UIButton!
    
    var chooseDateBlock: ChooseDateBlock!
    
    var startDate = Date().startOfDay
    var endDate: Date?
    
    var isChange = false
    
    override func setup() {
        super.setup()
        initView()
    }
    
    override func bindingData() {
        super.bindingData()
        loadTextLanguage()
    }
    
    override func isEnableDrag() -> Bool {
        return true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        viewMain.roundCorners(corners: [.topLeft, .topRight], radius: 24)
    }
    
    override func didEndDragController() {
        dismiss(animated: true)
    }
    
    func initView() {
        let dateRange = try? viewModel.dateRange.value()
        self.chooseDateBlock = ChooseDateBlock()
        chooseDateBlock.translatesAutoresizingMaskIntoConstraints = false
        self.viewChooseDate.addSubview(self.chooseDateBlock)
        NSLayoutConstraint.activate([
            self.chooseDateBlock.topAnchor.constraint(equalTo: self.viewChooseDate.topAnchor),
            self.chooseDateBlock.bottomAnchor.constraint(equalTo: self.viewChooseDate.bottomAnchor),
            self.chooseDateBlock.leadingAnchor.constraint(equalTo: self.viewChooseDate.leadingAnchor),
            self.chooseDateBlock.trailingAnchor.constraint(equalTo: self.viewChooseDate.trailingAnchor)
        ])
        chooseDateBlock.delegate = self
        if let minimumDate = dateRange?.minimumDate {
            chooseDateBlock.minimumDate = minimumDate
        } else {
            chooseDateBlock.minimumDate = Calendar.current.date(from: DateComponents(year: 1970 , month: 1, day: 1))
        }
        if let maximumDate = dateRange?.maximumDate {
            chooseDateBlock.maximumDate = maximumDate
        } else {
            chooseDateBlock.maximumDate = Calendar.current.date(from: DateComponents(year: 2999 , month: 12, day: 31))
        }
        
        if let strDate = dateRange?.startDate,
           let enDate = dateRange?.endDate {
            chooseDateBlock.selectedStartDate = strDate.getDate(dateFormat: "MMM dd, yyyy")?.startOfDay
            chooseDateBlock.selectedEndDate = enDate.getDate(dateFormat: "MMM dd, yyyy")?.endOfDay
            self.startDate = (strDate.getDate(dateFormat: "MMM dd, yyyy") ?? Date()).startOfDay
            self.endDate = (enDate.getDate(dateFormat: "MMM dd, yyyy"))?.endOfDay
            isChange = true
        } else {
            let currentDate = Date()
            chooseDateBlock.selectedStartDate = Calendar.current.date( byAdding: .day, value: -1, to: currentDate)?.startOfDay
            chooseDateBlock.selectedEndDate = currentDate.endOfDay
            isChange = false
        }
        chooseDateBlock.selectedColor = R.color.mainPrimary()!
        chooseDateBlock.scrollToSelectedDate()
    }
    
    @IBAction func clickSelectDate(_ button: UIButton) {
        button.isClicked(true)
        var dateRange = (try? viewModel.dateRange.value()) ?? DateRangeModel()
        if self.isChange {
            if let end = endDate {
                dateRange.startDate = self.startDate.toMyString(format: "MMM dd, yyyy")
                dateRange.endDate = end.toMyString(format: "MMM dd, yyyy")
                dateRange.startSelect = startDate
                dateRange.endSelect = end
            } else {
                dateRange.startDate = self.startDate.toMyString(format: "MMM dd yyyy")
                dateRange.endDate = ""
                dateRange.startSelect = startDate
                dateRange.endSelect = nil
            }
        } else {
            let start = Calendar.current.date( byAdding: .day, value: -1, to: Date())?.startOfDay
            let end = Date().endOfDay
            dateRange.startDate = start?.toMyString(format: "MMM dd, yyyy") ?? ""
            dateRange.endDate = end.toMyString(format: "MMM dd, yyyy")
            dateRange.startSelect = start
            dateRange.endSelect = end
        }
        viewModel.dateRange.onNext(dateRange)
        dismiss(animated: true)
    }
    
    override func onLanguageChange() {
        super.onLanguageChange()
        loadTextLanguage()
    }
    
    private func loadTextLanguage() {
        lbSelectAsset.text = "Select Date"
        btnFilterTransactions.setTitle("Apply", for: .normal)
    }
    
}

extension PopupDateRangeController: ChooseDateBlockDelegate {
    func didCancelPickingDateRange() {
    }
    
    func didPickDateRange(startDate: Date!, endDate: Date?) {
        self.startDate = startDate.startOfDay
        self.endDate = endDate?.endOfDay
        self.isChange = true
    }
}
