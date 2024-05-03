//
//  NumberExt.swift
//  BBLabs.
//
//  Created by BBLabs on 12/25/20.
//  Copyright © 2020 BBLabs.All rights reserved.
//

import Foundation

extension Double {
    
    func convertDoubleToCurrency(locale: Locale = .current) -> String {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        currencyFormatter.locale = locale
        currencyFormatter.minimumFractionDigits = 0
        return currencyFormatter.string(from: NSNumber(value: self)) ?? ""
    }
    
}

extension String {
    func stringTocurrency(locale: Locale = .current) -> Double {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        currencyFormatter.locale = locale
        currencyFormatter.minimumFractionDigits = 0
        return currencyFormatter.number(from: self)?.doubleValue ?? 0
    }
    
    func getSymbolForCurrencyCode() -> String {
        let result = Locale.availableIdentifiers.map { Locale(identifier: $0) }.first { $0.currencyCode == self }
        return result?.currencySymbol ?? ""
    }
    
}

extension Float64 {
    func miliSecondsToTimer() -> String{
        
        var finalTimerString = ""
        var minutesString = ""
        var secondsString = ""
        
        let totalSeconds =  self
        let hours = Int(totalSeconds / 3600)
        let minutes = Int((totalSeconds.truncatingRemainder(dividingBy: 3600)) / 60)
        let seconds = Int(totalSeconds.truncatingRemainder(dividingBy: 60))
        // Add hours if there
        
        // Prepending 0 to hours if it is one digit
        if (hours < 10) {
            if hours <= 0 {
                finalTimerString = ""
            } else {
                finalTimerString = "0\(hours):"
            }
        } else {
            finalTimerString = "\(hours):"
        }
        
        // Prepending 0 to minutes if it is one digit
        if (minutes < 10) {
            minutesString = "0\(minutes):"
        } else {
            minutesString = "\(minutes):"
        }
        
        // Prepending 0 to seconds if it is one digit
        if (seconds < 10) {
            secondsString = "0\(seconds):"
        } else {
            secondsString = "\(seconds):"
        }
        
        finalTimerString = "\(finalTimerString)\(minutesString)\(secondsString)"
        
        // return timer string
        return finalTimerString
    }
}

extension Double {
    
    /// Convert time from duration millisecond to text as format: hh:mm:ss
    /// If value less than 10. we are add 0 number before it
    func convertToString() -> String {
        let milliseconds = self
        var finalTimerString = ""
        var minutesString = ""
        var secondsString = ""
        
        // Convert total duration into time
        let hours = milliseconds / (60 * 60)
        let minutes = milliseconds.truncatingRemainder(dividingBy: (60 * 60)) / (60)
        let seconds = milliseconds.truncatingRemainder(dividingBy: (60 * 60)).truncatingRemainder(dividingBy: (60))
        
        // Add hours if there
        
        // Prepending 0 to hours if it is one digit
        if hours < 10 {
            if hours == 0 {
                finalTimerString = ""
            } else {
                finalTimerString = "0\(hours):"
            }
        } else {
            finalTimerString = "\(hours):"
        }
        
        //         Prepending 0 to minutes if it is one digit
        if minutes < 10 {
            minutesString = "0\(minutes):"
        } else {
            minutesString = "\(minutes):"
        }
        
        // Prepending 0 to seconds if it is one digit
        if seconds < 10 {
            secondsString = "0\(seconds)"
        } else {
            secondsString = "\(seconds)"
        }
        
        finalTimerString = "\(finalTimerString)\(minutesString)\(secondsString)"
        
        // return timer string
        return finalTimerString
    }
}

extension Int {
    
    func formatTime() -> String {
        if self < 10 {
            return "0\(self)"
        } else {
            return "\(self)"
        }
    }
    
    func formatNumbDevide() -> String {
        var currency = "\(self)"
        if self < 100 {
            currency = "0\(currency)"
        }
        if self < 10 {
            currency = "0\(currency)"
        }
        return currency
    }
    
    func formatNumber(_ digits: Int = 1) -> String {
        for index in stride(from: (symbolInt.count - 1), through: 0, by: -1) {
            let symbol = symbolInt[index]
            if Double(self) > symbol.key {
                let numb = Double(self) / (symbol.key * 1.0)
                let numbCompare = Double(self).truncatingRemainder(dividingBy: symbol.key * 1.0)
                return String.init(format: "%.\(numbCompare == 0 ? 0 : digits)f\(symbol.value)", numb)
            }
        }
        return "\(self)"
    }
    
    func formatCount() -> String {
        if self >= 100 {
            return "99+"
        }
        return "\(self)"
    }
    
    /// Convert time from duration millisecond to text as format: hh:mm:ss
    /// If value less than 10. we are add 0 number before it
    func convertToString() -> String {
        let milliseconds = self
        var finalTimerString = ""
        var minutesString = ""
        var secondsString = ""
        
        // Convert total duration into time
        let hours = Int(milliseconds / (60 * 60))
        let minutes = Int(milliseconds % (60 * 60)) / (60)
        let seconds = Int((milliseconds % (60 * 60)) % (60))
        // Add hours if there
        if hours > 0 {
            // Prepending 0 to hours if it is one digit
            if hours < 10 {
                if hours == 0 {
                    finalTimerString = ""
                } else {
                    finalTimerString = "0\(hours):"
                }
            } else {
                finalTimerString = "\(hours):"
            }
        }
        
        // Prepending 0 to minutes if it is one digit
        if minutes < 10 {
            minutesString = "0\(minutes):"
        } else {
            minutesString = "\(minutes):"
        }
        
        // Prepending 0 to seconds if it is one digit
        if seconds < 10 {
            secondsString = "0\(seconds)"
        } else {
            secondsString = "\(seconds)"
        }
        
        finalTimerString = "\(finalTimerString)\(minutesString)\(secondsString)"
        
        // return timer string
        return finalTimerString
    }
}

extension NSDecimalNumber {
    
    /// - returns: The cost of the product formatted in the local currency.
    func regularPrice() -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter.string(from: self)
    }
    
}

extension Double {

    /// - returns: The cost of the product formatted in the local currency.
    func regularPrice(locale: Locale) -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = locale
        return formatter.string(from: NSNumber(value: self))
    }
    
}
