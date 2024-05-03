//
//  Extension.swift
//  BBLabs.
//
//  Created by BBLabs on 7/19/19.
//  Copyright © 2019 BBLabs.All rights reserved.
//

import Foundation
import MapKit
import Photos
import UIKit

struct Symbol {
    var key: Double = 0
    var value = ""
}

let symbolInt = [
    Symbol(key: 1, value: ""),
    Symbol(key: 1E3, value: "K"),
    Symbol(key: 1E6, value: "M"),
    Symbol(key: 1E9, value: "G"),
    Symbol(key: 1E12, value: "T"),
    Symbol(key: 1E15, value: "P"),
    Symbol(key: 1E18, value: "E")
]

func color(_ rgbColor: Int, _ alpha: Float = 1) -> UIColor {
    return UIColor(
        red: CGFloat((rgbColor & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbColor & 0x00FF00) >> 8 ) / 255.0,
        blue: CGFloat((rgbColor & 0x0000FF) >> 0 ) / 255.0,
        alpha: CGFloat(alpha)
    )
}

func getQueryStringParameter(url: String, param: String) -> String? {
    guard let url = URLComponents(string: url) else { return nil }
    return url.queryItems?.first(where: { $0.name == param })?.value
}

func parseAddress(_ placeMark: CLPlacemark) -> String {
    let numberStreet = placeMark.subThoroughfare ?? ""
    let streetName = placeMark.thoroughfare ?? ""
    let subCity = placeMark.subLocality ?? ""
    let city = placeMark.locality ?? ""
    let country = placeMark.country ?? ""
    
    var address = numberStreet
    if address.isEmpty {
        address += "\(streetName)"
    } else {
        address += streetName.isEmpty ? "" : ", \(streetName)"
    }
    if address.isEmpty {
        address += "\(subCity)"
    } else {
        address += subCity.isEmpty ? "" : ", \(subCity)"
    }
    if address.isEmpty {
        address += "\(city)"
    } else {
        address += city.isEmpty ? "" : ", \(city)"
    }
    if address.isEmpty {
        address += "\(country)"
    } else {
        address += country.isEmpty ? "" : ", \(country)"
    }
    return address
}

func drawDottedLine(start: CGPoint, end: CGPoint, view: UIView) {
    let shapeLayer = CAShapeLayer()
    shapeLayer.strokeColor = color(0xEBEBEB).cgColor
    shapeLayer.lineWidth = 2
    shapeLayer.lineDashPattern = [10, 5]
    
    let path = CGMutablePath()
    path.addLines(between: [start, end])
    shapeLayer.path = path
    view.layer.addSublayer(shapeLayer)
}

func hasLocationPermission() -> Int {
    var hasPermission = 0
    if CLLocationManager.locationServicesEnabled() {
        switch CLLocationManager.authorizationStatus() {
        case .restricted, .denied:
            hasPermission = 0
        case .authorizedAlways, .authorizedWhenInUse:
            hasPermission = 1
        case .notDetermined:
            hasPermission = 2
        @unknown default:
            hasPermission = 0
        }
    } else {
        hasPermission = 0
    }
    
    return hasPermission
}

func localDate() -> Date {
    let nowUTC = Date()
    let timeZoneOffset = Double(TimeZone.current.secondsFromGMT(for: nowUTC))
    guard let localDate = Calendar.current.date(byAdding: .second, value: Int(timeZoneOffset), to: nowUTC) else {return Date()}
    
    return localDate
}

func utcDate() -> Date {
    let nowUTC = localDate()
    let timeZoneOffset = Double(TimeZone.current.secondsFromGMT(for: nowUTC))
    guard let localDate = Calendar.current.date(byAdding: .second, value: -Int(timeZoneOffset), to: nowUTC) else {return Date()}
    
    return localDate
}

enum VerticalLocation: String {
    case bottom
    case top
}

extension Date {
    
    func getTimeString(format: String = "HH:mm", locale: Locale = Locale(identifier: "en_US_POSIX")) -> String {
        toMyString(format: format, locale: locale)
    }
    
    func toMyString(format: String, locale: Locale = Locale(identifier: "en_US_POSIX")) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = locale
        return dateFormatter.string(from: self)
    }
    
//    func toJPString(format: String = "yyyy/MM/dd") -> String {
//        let dateFormatter = DateFormatter()
//        dateFormatter.timeZone = TimeZone.init(abbreviation: "UTC")
//        dateFormatter.locale = Locale.init(identifier: "ja")
//        dateFormatter.dateFormat = format
//        return dateFormatter.string(from: self)
//    }
    /// Convert String to Date
    func toStringUTC(dateFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        dateFormatter.timeZone = TimeZone.init(abbreviation: "UTC")
        return dateFormatter.string(from: self)
    }
    
    func getTimeAgoSinceNow() -> String {
//        let interval = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self, to: Date())
        let dateFormatter2 = DateFormatter()
        dateFormatter2.timeZone = TimeZone.current
        dateFormatter2.locale = Locale.current
//        if let year = interval.year, year > 0 {
            dateFormatter2.dateFormat = "yyyy.MM.dd HH:mm"
            return dateFormatter2.string(from: self)
//        } else if let month = interval.month, month > 0 {
//            dateFormatter2.dateFormat = "yyyy.MM.dd HH:mm"
//            return dateFormatter2.string(from: self)
//        } else if let day = interval.day, day > 0 {
//            dateFormatter2.dateFormat = "yyyy.MM.dd HH:mm"
//            return dateFormatter2.string(from: self)
//        } else if let hour = interval.hour, hour > 0 {
////            return "\(hour) 時間前"
//            dateFormatter2.dateFormat = "HH:mm"
//            return dateFormatter2.string(from: self)
//        } else if let minute = interval.minute, minute > 0 {
////            return "\(minute) 分前"
//            dateFormatter2.dateFormat = "HH:mm"
//            return dateFormatter2.string(from: self)
//        } else if let second = interval.second, second > 0 {
////            return "\(second) 秒前"
//            dateFormatter2.dateFormat = "HH:mm"
//            return dateFormatter2.string(from: self)
//        } else {
////            return "今"
//            dateFormatter2.dateFormat = "HH:mm"
//            return dateFormatter2.string(from: self)
//        }
    }
}

extension Date {
    
    func tomorrowDate() -> Date {
        add(day: 1)
    }
    
    func add(year: Int) -> Date {
        add(component: .year, value: year)
    }
    
    func add(month: Int) -> Date {
        add(component: .month, value: month)
    }
    
    func add(week: Int) -> Date {
        add(component: .weekdayOrdinal, value: week)
    }
    
    func add(day: Int) -> Date {
        add(component: .day, value: day)
    }
    
    func add(hour: Int) -> Date {
        add(component: .hour, value: hour)
    }
    
    func add(minute: Int) -> Date {
        add(component: .minute, value: minute)
    }
    
    func add(second: Int) -> Date {
        add(component: .second, value: second)
    }
    
    private func add(component: Calendar.Component, value: Int) -> Date {
        let calendar = Calendar.current
        let newDate = calendar.date(byAdding: component, value: value, to: self)
        guard let date = newDate else {
            fatalError()
        }
        return date
    }
    
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay)!
    }
    
    func isSameDate(as date: Date) -> Bool {
        Calendar.current.isDate(date, inSameDayAs: self)
    }
    
    func get(component: Calendar.Component) -> Int {
        Calendar.current.component(component, from: self)
    }
    
    func setRoundTime(hour: Int? = nil, minute: Int? = nil) -> Date {
        return Calendar.current.date(bySettingHour: hour ?? self.get(component: .hour), minute: minute ?? 0, second: 0, of: self) ?? self
    }
    
}

extension Calendar {
    func numberOfYearsBetween(startDate: Date, endDate: Date = localDate()) -> Int {
        let numberOfYears = dateComponents([.year, .month, .day], from: startDate, to: endDate)
        return numberOfYears.year ?? 0
    }
    
    func numberOfTimeBetween(startDate: Date, endDate: Date = localDate()) -> DateComponents {
        let numberOfYears = dateComponents([.year, .month, .day, .hour, .minute], from: startDate, to: endDate)
        return numberOfYears
    }
}

extension PHAsset {
    func getThumbnailImage(_ targetSize: CGSize, _ options: PHImageRequestOptions? = nil, _ completion: @escaping (UIImage?) -> Void ) {
        let imageManager = PHImageManager()
        imageManager.requestImage(for: self, targetSize: targetSize, contentMode: .aspectFill, options: options, resultHandler: { image, _ in
            completion(image)
        })
    }
    
    func requestAVURLAsset(completion: ((_ url: String?) -> Void)?) {
        if self.mediaType != .video {
            completion?("")
            return
        }
        let options = PHVideoRequestOptions()
        options.deliveryMode = .highQualityFormat
        options.isNetworkAccessAllowed = true
        PHCachingImageManager().requestAVAsset(forVideo: self, options: options) { (assets, _, _) in
            guard let asset = assets as? AVURLAsset else {
                DispatchQueue.main.asyncSafety{
                    completion?("")
                }
                return
            }
            DispatchQueue.main.asyncSafety{
                completion?(asset.url.absoluteString)
            }
        }
    }
    
}

extension UIColor {
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        if hexString.hasPrefix("#") {
            if #available(iOS 13, *) {
                scanner.currentIndex = hexString.index(at: 0)
            } else {
                scanner.scanLocation = 1
            }
        }
        var color: UInt64 = 0
        scanner.scanHexInt64(&color)
        let mask = 0x000000FF
        let red = CGFloat(Int(color >> 16) & mask) / 255.0
        let green = CGFloat(Int(color >> 8) & mask) / 255.0
        let blue = CGFloat(Int(color) & mask) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    // swiftlint:disable identifier_name
    func toHexString() -> String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb: Int = (Int)(r * 255) << 16 | (Int)(g * 255) << 8 | (Int)(b * 255) << 0
        return String(format: "#%06x", rgb)
    }
    // swiftlint:enable identifier_name
    
    func getAlpha() -> CGFloat {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return alpha
    }
    
}

extension UINavigationController {
    func open(viewController: UIViewController) {
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromTop
        self.view.layer.add(transition, forKey: kCATransition)
        self.pushViewController(viewController, animated: false)
    }
    
    func close() {
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.fade
        transition.subtype = CATransitionSubtype.fromBottom
        self.view.layer.add(transition, forKey: kCATransition)
        self.popViewController(animated: false)
    }
}

extension UITextField {
    
    @IBInspectable
    var placeholderColor: UIColor {
        get {
            if let placeHolderColor = self.attributedPlaceholder?.attributes(at: 0, effectiveRange: nil).filter({
                if $0.key == .foregroundColor {
                    return true
                }
                return false
            }) {
                return (placeHolderColor[.foregroundColor] as? UIColor) ?? .white.withAlphaComponent(0.5)
            } else {
                return UIColor.white.withAlphaComponent(0.5)
            }
        }
        set {
            placeholderColor(newValue)
        }
    }
    
    func placeholderColor(_ color: UIColor) {
        var placeholderText = ""
        if self.placeholder != nil {
            placeholderText = self.placeholder!
        }
        self.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: [NSAttributedString.Key.foregroundColor: color])
        self.layoutIfNeeded()
    }
    
    @IBInspectable
    var linespace: CGFloat {
        get {
            if let paragraph = self.attributedPlaceholder?.attributes(at: 0, effectiveRange: nil).filter({
                if $0.key == .paragraphStyle {
                    return true
                }
                return false
            }) {
                return (paragraph[.paragraphStyle] as? NSMutableParagraphStyle)?.lineSpacing ?? 1
            } else {
                return 1
            }
        }
        set {
            setLinespace(newValue)
        }
    }
    
    func setLinespace(_ space: CGFloat) {
        if let paragraph = self.attributedPlaceholder?.attributes(at: 0, effectiveRange: nil).filter({
            if $0.key == .paragraphStyle {
                return true
            }
            return false
        }) {
            (paragraph[.paragraphStyle] as? NSMutableParagraphStyle)?.lineSpacing = space
        }
        self.layoutIfNeeded()
    }
    
}

extension UILabel {
    
    @IBInspectable
    var linespace: CGFloat {
        get {
            if let paragraph = self.attributedText?.attributes(at: 0, effectiveRange: nil).filter({
                if $0.key == .paragraphStyle {
                    return true
                }
                return false
            }) {
                return (paragraph[.paragraphStyle] as? NSMutableParagraphStyle)?.lineSpacing ?? 1
            } else {
                return 1
            }
        }
        set {
            setLinespace(newValue)
        }
    }
    
    func setLinespace(_ space: CGFloat) {
        if let paragraph = self.attributedText?.attributes(at: 0, effectiveRange: nil).filter({
            if $0.key == .paragraphStyle {
                return true
            }
            return false
        }) {
            (paragraph[.paragraphStyle] as? NSMutableParagraphStyle)?.lineSpacing = space
        }
        self.layoutIfNeeded()
    }
    
}

func getGlobalCache<T: Codable>(type: T.Type, key: String) -> T? {
    
    guard let jsonStr = UserDefaults.standard.string(forKey: key) else {
        return nil
    }
    guard let data = jsonStr.data(using: .utf8) else {
        return nil
    }
    do {
        guard let dataJSON = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any?] else {
            return nil
        }
        let jData = try JSONSerialization.data(withJSONObject: dataJSON, options: .prettyPrinted)
        return try JSONDecoder().decode(type, from: jData)
        
    } catch {
    }
    return nil
}

extension Dictionary {
    
    func cache(key: String) -> Bool {
        do {
            let data = try JSONSerialization.data(withJSONObject: self)
            if let string = String(data: data, encoding: .utf8) {
                UserDefaults.standard.set(string, forKey: key)
                return true
            }
        } catch {}
        UserDefaults.standard.set("", forKey: key)
        return false
    }
    
}

extension Encodable {
    var dictionary: [String: Any] {
        guard let data = try? JSONEncoder().encode(self) else { return [:] }
        let dict = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
        return dict ?? [:]
    }
}

extension NSArray {
    @objc var isEmpty: Bool {
        // swiftlint:disable empty_count implicit_getter
        get { return self.count <= 0 }
        // swiftlint:enable empty_count implicit_getter
    }
}

extension Array {
    mutating func mapInPlace(transform: (inout Element) -> Void) {
        for index in 0 ..< self.count {
            transform(&self[index])
        }
    }
}

extension URL {
    public var queryParameters: [String: String] {
        guard
            let components = URLComponents(url: self, resolvingAgainstBaseURL: true),
            let queryItems = components.queryItems else { return [:] }
        return queryItems.reduce(into: [String: String]()) { (result, item) in
            result[item.name] = item.value
        }
    }
    
    func absoluteStringByTrimmingQuery() -> String? {
        if var urlcomponents = URLComponents(url: self, resolvingAgainstBaseURL: false) {
            urlcomponents.query = nil
            return urlcomponents.string
        }
        return nil
    }
}

extension UIStackView {
    
    func removeAllArrangedSubviews() {
        arrangedSubviews.forEach { (view) in
            removeArrangedSubview(view)
            view.removeFromSuperview()
        }
    }
    
}

extension DispatchQueue {
    
    func asyncSafety(_ closure: @escaping () -> Void) {
        guard self === DispatchQueue.main && Thread.isMainThread else {
            DispatchQueue.main.async(execute: closure)
            return
        }
        closure()
    }
    
    func asyncSafety(execute: DispatchWorkItem) {
        guard self === DispatchQueue.main && Thread.isMainThread else {
            DispatchQueue.main.async(execute: execute)
            return
        }
        execute.perform()
    }
    
}
