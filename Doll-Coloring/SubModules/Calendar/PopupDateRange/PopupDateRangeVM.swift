//
//  PopupDateRangeVM.swift
//  BloodPresure-iOS
//
//  Created by BBLabs on 04/08/2022.
//  Copyright © 2022 BBLabs. All rights reserved.
//

import RxSwift
import UIKit
import RxCocoa

class PopupDateRangeVM {
    private var disposeBag = DisposeBag()
    
    var startDate = BehaviorRelay<String?>(value: nil)
    
    var endDate = BehaviorRelay<String?>(value: nil)
    
    var dateRange = BehaviorSubject<DateRangeModel>(value: DateRangeModel())
    
    init(dateRange: BehaviorSubject<DateRangeModel>) {
        self.dateRange = dateRange
    }

}

func getFirstDate(_ minimumDate: Date) -> Date {
    var components = Calendar.current.dateComponents([.month, .year], from: minimumDate)
    components.day = 1
    return Calendar.current.date(from: components) ?? Date()
}

func getFirstDateForSection(section: Int, _ minimumDate: Date) -> Date {
    return Calendar.current.date(byAdding: .month, value: section, to: getFirstDate(minimumDate)) ?? Date()
}

func getMonthLabel(date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MMMM - yyyy"
    dateFormatter.locale = Constants.currentLanguage.locale
    var result = dateFormatter.string(from: date)
    let substr1 = String(result[result.startIndex]).uppercased()
    result.replaceSubrange(...result.startIndex, with: substr1)
    return result
}

func getWeekdayLabel(weekday: Int) -> String {
    var components = DateComponents()
    components.calendar = Calendar.current
    components.weekday = weekday
    var currentCalendar = Calendar.current
    currentCalendar.locale = Constants.currentLanguage.locale
    let date = currentCalendar.nextDate(after: Date(), matching: components, matchingPolicy: Calendar.MatchingPolicy.strict)
    if date == nil {
        return "E"
    }
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "E"
    dateFormatter.locale = Constants.currentLanguage.locale
    return dateFormatter.string(from: date ?? Date())
}

func getWeekday(date: Date) -> Int {
    return Calendar.current.dateComponents([.weekday], from: date).weekday ?? 0
}

func getNumberOfDaysInMonth(date: Date) -> Int {
    return (Calendar.current.range(of: .day, in: .month, for: date) ?? (0..<1)).count
}

func getDate(dayOfMonth: Int, section: Int, _ minimumDate: Date) -> Date {
    var components = Calendar.current.dateComponents([.month, .year], from: getFirstDateForSection(section: section, minimumDate))
    components.day = dayOfMonth
    return Calendar.current.date(from: components) ?? Date()
}

func areSameDay(dateA: Date, dateB: Date) -> Bool {
    return Calendar.current.compare(dateA, to: dateB, toGranularity: .day) == ComparisonResult.orderedSame
}

func isBefore(dateA: Date, dateB: Date) -> Bool {
    return Calendar.current.compare(dateA, to: dateB, toGranularity: .day) == ComparisonResult.orderedAscending
}

func isAfter(dateA: Date, dateB: Date) -> Bool {
    return Calendar.current.compare(dateA, to: dateB, toGranularity: .day) == ComparisonResult.orderedDescending
}

func dayInToday(date: Date) -> Bool {
    let dateString = date.toMyString(format: "MMM dd, yyyy")
    let dateToday = Date().toMyString(format: "MMM dd, yyyy")
    
    return dateString == dateToday
}
