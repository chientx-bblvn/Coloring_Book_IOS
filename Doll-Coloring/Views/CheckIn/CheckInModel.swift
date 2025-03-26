//
//  CheckInModel.swift
//  Doll-Coloring
//
//  Created by MacBookPro on 6/8/24.
//

import Foundation
import SVProgressHUD


struct MonthsData {
    var month: Date
    var day: [Int]
    var image: [String]
    
}


class DalyMonthVM {
    
    private let serviceManager = HomeManager()
    var itemDaly: [ColoringImage] = []
    
    var totalGitDaly: Int = 0
    var monthsData: [MonthsData] = []
    
    init() {
        
    }
    
    
    
    func getDalyColoring() {
        SVProgressHUD.show()
        serviceManager.requestAPI(.newList, type: [ColoringModel].self) {[weak self] isSuccess, response in
            self?.itemDaly = response.first(where: {$0.categoryName?.contains("Daily") ?? false})?.imageUrls ?? []
            self?.calculatorDay()
            SVProgressHUD.dismiss()
        } onFailed: { error in
            SVProgressHUD.dismiss()
            debugPrint(error.localizedDescription)
        }
    }
    
    func getDalyColoring(complection: @escaping () -> Void) {
        SVProgressHUD.show()
        serviceManager.requestAPI(.newList, type: [ColoringModel].self) {[weak self] isSuccess, response in
            SVProgressHUD.dismiss()
            self?.itemDaly = response.first(where: {$0.categoryName?.contains("Daily") ?? false})?.imageUrls ?? []
            self?.calculatorDay()
            complection()
        } onFailed: { error in
            SVProgressHUD.dismiss()
            complection()
        }
    }
    
    func calculatorDay() {
        let currentDate = Date()
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        guard let pastDate = dateFormatter.date(from: UserDefaultManager.dateFirstOpenApp) else {
           return
        }
        let components = calendar.dateComponents([.day], from: pastDate, to: currentDate)
        
        if let totalDays = components.day {
            if totalDays >= itemDaly.count {
                totalGitDaly = itemDaly.count - 1
            } else {
                totalGitDaly = totalDays
            }
            getCalendarDaly()
        }
    }
    
    func getCalendarDaly() {
        let calendar = Calendar.current
        var currentMonth: Int?
        var currentMonthData: MonthsData?
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        guard let startDate = dateFormatter.date(from: UserDefaultManager.dateFirstOpenApp) else {
            return
        }
        for i in 0..<totalGitDaly {
            if let newDate = calendar.date(byAdding: .day, value: i, to: startDate) {
                let components = calendar.dateComponents([.month, .day], from: newDate)
                if let month = components.month, let day = components.day {
                    
                    if month != currentMonth {
                        if let monthData = currentMonthData {
                            monthsData.append(monthData)
                        }
                        currentMonth = month
                        currentMonthData = MonthsData(month: newDate, day: [day], image: [itemDaly[i].filePath ?? ""])
                    } else {
                        currentMonthData?.day.append(day)
                        currentMonthData?.image.append(itemDaly[i].filePath ?? "")
                    }
                }
            }
        }
        
        if let monthData = currentMonthData {
            monthsData.append(monthData)
        }
    }
}
