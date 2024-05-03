//
//  String++.swift
// Doll-Coloring
//
//  Created by BBLabs on 3/9/21.
//  Copyright © 2021 BBLabs.All rights reserved.
//

import Foundation
import UIKit

// swiftlint:disable file_length
extension String {

    internal func indexOf(_ sub: String) -> Int? {
        guard let range = self.range(of: sub), !range.isEmpty else {
            return nil
        }
        return self.distance(from: self.startIndex, to: range.lowerBound)
    }

    func urlEncodedString(_ encodeAll: Bool = false) -> String {
        var allowedCharacterSet: CharacterSet = .urlQueryAllowed
        allowedCharacterSet.remove(charactersIn: "\n:#/?@!$&'()*+,;=")
        if !encodeAll {
            allowedCharacterSet.insert(charactersIn: "[]")
        }
        return self.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet)!
    }
    
    var queryStringParameters: [String: String] {
        var parameters = [String: String]()
        guard let url = URLComponents(string: self) else { return [:] }
        for queryItem in url.queryItems ?? [] {
            parameters.updateValue(queryItem.value ?? "", forKey: queryItem.name)
        }
        return parameters
    }
    
    subscript(value: Int) -> Character {
        self[index(at: value)]
    }
    
    subscript(value: NSRange) -> Substring {
        self[value.lowerBound..<value.upperBound]
    }
    
    subscript(value: CountableClosedRange<Int>) -> Substring {
        self[index(at: value.lowerBound)...index(at: value.upperBound)]
    }
    
    subscript(value: CountableRange<Int>) -> Substring {
        self[index(at: value.lowerBound)..<index(at: value.upperBound)]
    }
    
    subscript(value: PartialRangeUpTo<Int>) -> Substring {
        self[..<index(at: value.upperBound)]
    }
    
    subscript(value: PartialRangeThrough<Int>) -> Substring {
        self[...index(at: value.upperBound)]
    }
    
    subscript(value: PartialRangeFrom<Int>) -> Substring {
        self[index(at: value.lowerBound)...]
    }
    
    func index(at offset: Int) -> String.Index {
        index(startIndex, offsetBy: offset)
    }
    
}

extension String? {
    var isNullOrEmpty: Bool {
        self?.isEmpty ?? true
    }
    
    var isNullOrBlank: Bool {
        self?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true
    }
}

extension String {
    var isValidURL: Bool {
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
            if let match = detector.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count)) {
                // it is a link, if the match covers the whole string
                return match.range.length == self.utf16.count
            } else {
                return false
            }
        } catch {
            return false
        }
    }
    
    func hexStringToUIColor (_ alpha: CGFloat = 1.0) -> UIColor {
        var cString: String = self.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }
        
        if (cString.count) != 6 {
            return UIColor.gray
        }
        
        var rgbValue: UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(alpha)
        )
    }
    
    func openLink() {
        if let link = URL.init(string: self) {
            if UIApplication.shared.canOpenURL(link) {
                UIApplication.shared.open(link, options: [:], completionHandler: nil)
            }
        }
    }
    
    func secureEmail(_ secureChar: String = "*") -> String {
        var newEmail = self
        let arr = self.components(separatedBy: "@")
        if arr.count == 2 {
            var newQuery = ""
            let str1 = arr[0]
            if arr[0].count > 4 {
                let countStr = str1.count
                let subCountStr = str1.count >= 8 ? 8 : str1.count
                newQuery = "\(self.prefix(1))\(String(repeating: secureChar, count: (subCountStr - 1 - 3)))\(self[(countStr - 3) ..< countStr])"
            } else {
                newQuery = String(repeating: secureChar, count: 4)
            }
            let arrPFix = arr[1].components(separatedBy: ".")
            if arrPFix.count > 1 {
                newEmail = newQuery + "@" + String(repeating: secureChar, count: arrPFix[0].count) + "." + arrPFix[1]
            } else {
                newEmail = newQuery + arr[1]
            }
        }
        return newEmail
    }
    
    func securePhone(_ secureChar: String = "*") -> String {
        var newPhone = self
        let validate = self.starts(with: "+") || self.starts(with: "0")
        if validate {
            let numberPrefix = self.starts(with: "+") ? 4 : 2
            let countStr = self.count
            newPhone = "\(self.prefix(numberPrefix))-\(String(repeating: secureChar, count: 4))"
                        + "-\(String(repeating: secureChar, count: (countStr - numberPrefix - (self.starts(with: "+") ? 7 : 6))))"
                        + "\(self[(countStr - 2) ..< countStr])"
        }
        return newPhone
    }
    
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .unicode) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data,
                                          options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.unicode.rawValue],
                                          documentAttributes: nil)
            .trimmedAttributedString()
        } catch {
            return NSAttributedString()
        }
    }
    
    func convertDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy年　MM月　dd日"
        
        if let date = dateFormatter.date(from: self) {
            print(date) // if this prints date is valid
            let dateFormatter2 = DateFormatter()
            dateFormatter2.dateFormat = "yyyy-MM-dd"
            return dateFormatter2.string(from: date)
        } else {
            print("Date is Invalid") // if this prints date is invalid
            return ""
        }
    }
    
    var isInt: Bool {
        return Int(self) != nil
    }
    
    func toInt() -> Int {
        return (self as NSString).integerValue
    }
}

extension String {
    func toAttributeString(font: UIFont = .systemFont(ofSize: 14),
                           alignment: NSTextAlignment = .justified,
                           foreground: UIColor? = nil,
                           linespace: CGFloat = 0,
                           lineHeightMultiple: CGFloat = 1.2) -> NSAttributedString {
        let messageAttr = NSMutableAttributedString(string: self)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = alignment
        paragraphStyle.lineHeightMultiple = lineHeightMultiple
        messageAttr.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange.init(location: 0, length: messageAttr.length))
        if let color = foreground {
            messageAttr.addAttribute(.foregroundColor, value: color, 
                                     range: NSRange.init(location: 0,
                                                         length: messageAttr.length))
        }
        messageAttr.addAttribute(.font, value: font,
                                 range: NSRange.init(location: 0,
                                                     length: messageAttr.length))
        return messageAttr
    }
    
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
    
    func extractNumbers() -> String {
        let numberCharacterSet = CharacterSet(charactersIn: "0123456789")
        let numbersArray = components(separatedBy: numberCharacterSet.inverted)
        let numbers = numbersArray.compactMap { Int($0) }
        let stringNumbers = numbers.map { String($0) }.joined(separator: "")
        return stringNumbers
    }
}

extension String {
    
    var floatValue: Float {
        return (self as NSString).floatValue
    }
    
    func convertToDictionary() -> [String: Any]? {
        if let data = self.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                debugPrint(error.localizedDescription)
            }
        }
        return nil
    }
    
    func toKeyValuePair(splittingOn separator: Character) -> (first: String, second: String)? {
        let arr = self.split(separator: separator,
                             maxSplits: 1,
                             omittingEmptySubsequences: false)
        if arr.count < 2 {
            return nil
        } else {
            return (String(arr[0]), String(arr[1]))
        }
    }
    
    func toMyDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        if let date = dateFormatter.date(from: self) {
            let dateFormatter2 = DateFormatter()
            dateFormatter2.dateFormat = "yyyy年　MM月　dd日"
            return dateFormatter2.string(from: date)
        }
        return ""
    }
    
    func toRequestDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormatter.timeZone = TimeZone.init(abbreviation: "UTC")
        dateFormatter.locale = Locale.init(identifier: "ja")
        if let date = dateFormatter.date(from: self) {
            let dateFormatter2 = DateFormatter()
            dateFormatter2.timeZone = TimeZone.current
            dateFormatter2.locale = Locale.current
            dateFormatter2.dateFormat = "yyyy.MM.dd"
            return dateFormatter2.string(from: date)
        }
        return ""
    }
    
    func toScheduleTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormatter.timeZone = TimeZone.init(abbreviation: "UTC")
        dateFormatter.locale = Locale.init(identifier: "ja")
        if let date = dateFormatter.date(from: self) {
            let dateFormatter2 = DateFormatter()
            dateFormatter2.dateFormat = "yyyy.MM.dd（E）"
            dateFormatter2.timeZone = TimeZone.current
            dateFormatter2.locale = Locale.init(identifier: "ja")
            return dateFormatter2.string(from: date)
        }
        return ""
    }
    
    func toLastRequestTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormatter.timeZone = TimeZone.init(abbreviation: "UTC")
        dateFormatter.locale = Locale.init(identifier: "ja")
        if let date = dateFormatter.date(from: self) {
            let dateFormatter2 = DateFormatter()
            dateFormatter2.dateFormat = "HH:mm"
            dateFormatter2.timeZone = TimeZone.current
            dateFormatter2.locale = Locale.current
            return dateFormatter2.string(from: date)
        }
        return ""
    }
    
    func toRequestTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormatter.timeZone = TimeZone.init(abbreviation: "UTC")
        dateFormatter.locale = Locale.init(identifier: "ja")
        if let date = dateFormatter.date(from: self) {
            let dateFormatter2 = DateFormatter()
            dateFormatter2.dateFormat = "HH:mm ～"
            dateFormatter2.timeZone = TimeZone.current
            dateFormatter2.locale = Locale.current
            return dateFormatter2.string(from: date)
        }
        return ""
    }
    
    func toNotifyDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormatter.timeZone = TimeZone.init(abbreviation: "UTC")
        dateFormatter.locale = Locale.init(identifier: "ja")
        if let date = dateFormatter.date(from: self) {
            let dateFormatter2 = DateFormatter()
            dateFormatter2.dateFormat = "yyyy.MM.dd HH:mm"
            dateFormatter2.timeZone = TimeZone.current
            dateFormatter2.locale = Locale.current
            return dateFormatter2.string(from: date)
        }
        return ""
    }
    
    func toChatDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormatter.timeZone = TimeZone.init(abbreviation: "UTC")
        dateFormatter.locale = Locale.init(identifier: "ja")
        if let date = dateFormatter.date(from: self) {
            return date.getTimeAgoSinceNow()
        }
        return ""
    }
    
    func convertToDateServer() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormatter.timeZone = TimeZone.init(abbreviation: "UTC")
        dateFormatter.locale = Locale.init(identifier: "ja")
        return dateFormatter.date(from: self)
    }
    
    func toDateUTC(dateFormat: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        dateFormatter.timeZone = TimeZone.init(abbreviation: "UTC")
        return dateFormatter.date(from: self)
    }
    
    func toDate(dateFormat: String, timeZone: TimeZone = .current) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        dateFormatter.timeZone = timeZone
        return dateFormatter.date(from: self)
    }
    
    func toServerDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        if let date = dateFormatter.date(from: self) {
            let dateFormatter2 = DateFormatter()
            dateFormatter2.timeZone = TimeZone.init(abbreviation: "UTC")
            dateFormatter2.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
            return dateFormatter2.string(from: date)
        }
        return ""
    }
    
    func getDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        return dateFormatter.date(from: self)
    }
    
    func toDateMecard() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-DD"
        dateFormatter.timeZone = TimeZone.init(abbreviation: "UTC")
        dateFormatter.locale = Locale.init(identifier: "ja")
        return dateFormatter.date(from: self)
    }
    
    func removeWhiteSpace() -> String {
        var temp = self.trimmingCharacters(in: .whitespaces)
        let split = temp.split(separator: " ")
        temp = ""
        for each in split {
            temp += each
        }
        return temp
    }
    
    func removingLeadingSpaces() -> String {
        guard let index = firstIndex(where: { !CharacterSet(charactersIn: String($0)).isSubset(of: .whitespaces) }) else {
            return self
        }
        return String(self[index...])
    }

    func lengthHalfWidth() -> Int {
        var length = 0
        self.forEach {
            length += $0.isHalfWidth()
        }
        return length
    }
    
}

extension NSMutableAttributedString {
    func setAsLink(textToFind: String,
                   linkName: String,
                   foreground color1: UIColor = .white,
                   underline color2: UIColor = .white,
                   font: UIFont = UIFont.boldSystemFont(ofSize: 12)) {
        let foundRange = self.mutableString.range(of: textToFind)
        if foundRange.location != NSNotFound {
            self.addAttribute(.link, value: linkName, range: foundRange)
            
            self.addAttribute(.foregroundColor, value: color1, range: foundRange)
            self.addAttribute(.underlineColor, value: color2, range: foundRange)
            self.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: foundRange)
            
            self.addAttribute(.font, value: font, range: foundRange)
        }
    }
}

extension Character {
    
    // isHalfWidth('過'); // return 2 ---> full-width isHalfWidth('ｻ'); // return 1 ---> half-width
    func isHalfWidth() -> Int {
        let code = self.unicodeScalarCodePoint()
        if (code >= 0x0020 && code <= 0x1FFF) || (code >= 0xFF61 && code <= 0xFF9F) {
            return 1
        } else if (code >= 0x2000 && code <= 0xFF60) || (code >= 0xFFA0) {
            return 2
        } else {
            return 0
        }
    }
    
    func unicodeScalarCodePoint() -> UInt32 {
        let characterString = String(self)
        let scalars = characterString.unicodeScalars

        return scalars[scalars.startIndex].value
    }
}

extension NSAttributedString {
    func trimmedAttributedString() -> NSAttributedString {
        let nonNewlines = CharacterSet.whitespacesAndNewlines.inverted
        let startRange = string.rangeOfCharacter(from: nonNewlines)
        let endRange = string.rangeOfCharacter(from: nonNewlines, options: .backwards)
        
        guard let startLocation = startRange?.lowerBound, let endLocation = endRange?.lowerBound else {
            return self
        }
        let range = NSRange(startLocation...endLocation, in: string)
        return attributedSubstring(from: range)
        
    }
}
        
extension String {
    func getReplacementString(range: NSRange, replacementString string: String) -> String {
        let currentString: NSString = self as NSString
        let newString = currentString.replacingCharacters(in: range, with: string)
        return newString
    }
    
    func formatString( _ arguments: CVarArg...) -> String {
        guard !arguments.isEmpty else {
            return self
        }
        return String(format: self, arguments)
    }
}
// swiftlint:enable file_length
