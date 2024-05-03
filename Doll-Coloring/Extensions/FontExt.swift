//
//  FontExt.swift
//  BBLabs.
//
//  Created by BBLabs on 6/11/20.
//  Copyright © 2020 BBLabs.All rights reserved.
//

import Foundation
import UIKit

extension UIFontDescriptor.AttributeName {
    static let nsctFontUIUsage = UIFontDescriptor.AttributeName(rawValue: "NSCTFontUIUsageAttribute")
}

extension UIFont {
    static var isOverrided: Bool = false

    @objc class func mySystemFont(ofSize size: CGFloat) -> UIFont {
        return .systemFont(ofSize: size) // TODO: - R.font.mulishRegular(size: size)!
    }

    @objc class func myBoldSystemFont(ofSize size: CGFloat) -> UIFont {
        return .boldSystemFont(ofSize: size) // TODO: - R.font.mulishBold(size: size)!
    }
    
    @objc class func mySemiboldSystemFont(ofSize size: CGFloat, weight: UIFont.Weight) -> UIFont {
//        if weight == .bold {
//            return R.font.mulishBold(size: size)!
//        } else {
//            return R.font.mulishRegular(size: size)!
//        }
        return .systemFont(ofSize: size, weight: .semibold) // TODO:
    }

    @objc convenience init(myCoder aDecoder: NSCoder) {
//        guard
//            let fontDescriptor = aDecoder.decodeObject(forKey: "UIFontDescriptor") as? UIFontDescriptor,
//            let fontAttribute = fontDescriptor.fontAttributes[.nsctFontUIUsage] as? String else {
                self.init(myCoder: aDecoder)
//                return
//        }
//        let fontSize = fontDescriptor.pointSize
//        var fontName = ""
////        switch fontAttribute {
////        case "CTFontRegularUsage":
////            fontName = .systemFont(ofSize: fontSize)?.fontName ?? "" // TODO: - R.font.mulishRegular(size: fontSize)?.fontName ?? ""
////        case "CTFontEmphasizedUsage", "CTFontBoldUsage":
////            fontName = .boldSystemFont(ofSize: fontSize)?.fontName ?? "" // TODO: - R.font.mulishBold(size: fontSize)?.fontName ?? ""
////        default:
////            fontName = .systemFont(ofSize: fontSize)?.fontName ?? "" // TODO: - R.font.mulishRegular(size: fontSize)?.fontName ?? ""
////        }
//        self.init(name: fontName, size: fontSize)!
    }

    class func overrideInitialize() {
        guard self == UIFont.self, !isOverrided else { return }

        // Avoid method swizzling run twice and revert to original initialize function
        isOverrided = true

        if let systemFontMethod = class_getClassMethod(self, #selector(systemFont(ofSize:))),
            let mySystemFontMethod = class_getClassMethod(self, #selector(mySystemFont(ofSize:))) {
            method_exchangeImplementations(systemFontMethod, mySystemFontMethod)
        }

        if let boldSystemFontMethod = class_getClassMethod(self, #selector(boldSystemFont(ofSize:))),
            let myBoldSystemFontMethod = class_getClassMethod(self, #selector(myBoldSystemFont(ofSize:))) {
            method_exchangeImplementations(boldSystemFontMethod, myBoldSystemFontMethod)
        }
        
        if let initCoderMethod = class_getInstanceMethod(self, #selector(UIFontDescriptor.init(coder:))), // Trick to get over the lack of UIFont.init(coder:))
            let myInitCoderMethod = class_getInstanceMethod(self, #selector(UIFont.init(myCoder:))) {
            method_exchangeImplementations(initCoderMethod, myInitCoderMethod)
        }
    }
    
    // swiftlint:disable cyclomatic_complexity
    func getFontWeight() -> UIFont.Weight {
        let fontAttributeKey = UIFontDescriptor.AttributeName.init(rawValue: "NSCTFontUIUsageAttribute")
        if let fontWeight = self.fontDescriptor.fontAttributes[fontAttributeKey] as? String {
            switch fontWeight {
            case "CTFontBoldUsage":         return UIFont.Weight.bold
            case "CTFontBlackUsage":        return UIFont.Weight.black
            case "CTFontHeavyUsage":        return UIFont.Weight.heavy
            case "CTFontUltraLightUsage":   return UIFont.Weight.ultraLight
            case "CTFontThinUsage":         return UIFont.Weight.thin
            case "CTFontLightUsage":        return UIFont.Weight.light
            case "CTFontMediumUsage":       return UIFont.Weight.medium
            case "CTFontDemiUsage":         return UIFont.Weight.semibold
            case "CTFontRegularUsage":      return UIFont.Weight.regular
            default:                        return UIFont.Weight.regular
            }
        }

        return UIFont.Weight.regular
    }
    // swiftlint:enable cyclomatic_complexity
}

enum FontTraitError: Error {
    case fontNotSet
}

// MARK: - For add/remove bold, italic, normal font
extension UIFont {
    
    // Add Traits
    func withTraits(traits: UIFontDescriptor.SymbolicTraits) throws -> UIFont {
        let symTraits = fontDescriptor.symbolicTraits
        if let descriptor = fontDescriptor.withSymbolicTraits(UIFontDescriptor.SymbolicTraits(arrayLiteral: symTraits, traits)) {
            return UIFont(descriptor: descriptor, size: 0) // size 0 means keep the size as it is
        }
        throw FontTraitError.fontNotSet
    }
    
    func bold() throws -> UIFont {
        return try withTraits(traits: .traitBold)
    }
    
    func italic() throws -> UIFont {
        return try withTraits(traits: .traitItalic)
    }
    
    // remove traits
    func withoutTraits(traits: UIFontDescriptor.SymbolicTraits) -> UIFont {
        var symTraits = fontDescriptor.symbolicTraits
        symTraits.remove([traits])
        let fontDescriptorVar = fontDescriptor.withSymbolicTraits(symTraits)
        return UIFont(descriptor: fontDescriptorVar!, size: 0)
    }
    
    func removeBold() -> UIFont {
        return withoutTraits(traits: .traitBold)
    }
    
    func removeItalic() -> UIFont {
        return withoutTraits(traits: .traitItalic)
    }
    
}
