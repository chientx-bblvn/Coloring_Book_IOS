//
//  TableColor.swift
//  Doll-Coloring
//
//  Created by Việt Anh Nguyễn on 11/4/24.
//

import Foundation

enum TableColor: CaseIterable {
    case Skin_Color
    case Basic_Color
    case Vivid_Color
    case Hot_Color
    case Natural_Color
    case Sky_Color
    case Purple_Color
    case Gradient_Color2
    case Gradient_Color1
    case Galaxy_Color
    case Pastel_Color
    case Sweet_Color
    case Mystical_Color
    
    var title: String {
        switch self {
        case .Skin_Color:
            return LocalizableUtils.tableSkin_color()
        case .Basic_Color:
            return LocalizableUtils.tableBasic_color()
        case .Vivid_Color:
            return LocalizableUtils.tableVivid_color()
        case .Hot_Color:
            return LocalizableUtils.tableHot_color()
        case .Natural_Color:
            return LocalizableUtils.tableNatural_color()
        case .Sky_Color:
            return LocalizableUtils.tableSky_color()
        case .Purple_Color:
            return LocalizableUtils.tableSky_color()
        case .Gradient_Color1:
            return LocalizableUtils.tableGradient_color(1)
        case .Gradient_Color2:
            return LocalizableUtils.tableGradient_color(2)
        case .Galaxy_Color:
            return LocalizableUtils.tableGalaxy_color()
        case .Pastel_Color:
            return LocalizableUtils.tablePastel_color()
        case .Sweet_Color:
            return LocalizableUtils.tableSweet_color()
        case .Mystical_Color:
            return LocalizableUtils.tableMystical_color()
        }
    }
    
    var listColor: [ItemColor] {
        switch self {
        case .Skin_Color:
            return [ItemColor(hex: "FFE6E3", name: "FFE6E3"), ItemColor(hex: "FFBCAA", name: "FFBCAA"), ItemColor(hex: "F5BC9D", name: "F5BC9D"), ItemColor(hex: "F79E85", name: "F79E85"),
                    ItemColor(hex: "FFAEA3", name: "FFAEA3"), ItemColor(hex: "DC8776", name: "DC8776"), ItemColor(hex: "EDBD91", name: "EDBD91"), ItemColor(hex: "69281B", name: "69281B"),
                    ItemColor(hex: "FFC9BE", name: "FFC9BE"), ItemColor(hex: "F0AC99", name: "F0AC99"), ItemColor(hex: "E99586", name: "E99586"), ItemColor(hex: "D28873", name: "D28873"),
                    ItemColor(hex: "F28F6F", name: "F28F6F"), ItemColor(hex: "B05937", name: "B05937"), ItemColor(hex: "A25E53", name: "A25E53"), ItemColor(hex: "BC594E", name: "BC594E")]
        case .Basic_Color:
            return [ItemColor(hex: "000000", name: "000000"), ItemColor(hex: "D63131", name: "D63131"), ItemColor(hex: "DE8900", name: "DE8900"), ItemColor(hex: "68BD00", name: "68BD00"),
                    ItemColor(hex: "026850", name: "026850"), ItemColor(hex: "007AA3", name: "007AA3"), ItemColor(hex: "0E189E", name: "0E189E"), ItemColor(hex: "DECBE0", name: "DECBE0"),
                    ItemColor(hex: "FFFFFF", name: "FFFFFF"), ItemColor(hex: "B34A00", name: "B34A00"), ItemColor(hex: "F0B000", name: "F0B000"), ItemColor(hex: "058708", name: "058708"),
                    ItemColor(hex: "009FAD", name: "009FAD"), ItemColor(hex: "004F8C", name: "004F8C"), ItemColor(hex: "54119C", name: "54119C"), ItemColor(hex: "D92768", name: "D92768")]
        case .Vivid_Color:
            return [ItemColor(hex: "E5ACBF", name: "E5ACBF"), ItemColor(hex: "F0939B", name: "F0939B"), ItemColor(hex: "ED6EA5", name: "ED6EA5"), ItemColor(hex: "C85179", name: "C85179"),
                    ItemColor(hex: "F76F86", name: "F76F86"), ItemColor(hex: "E70034", name: "E70034"), ItemColor(hex: "CA2F35", name: "CA2F35"), ItemColor(hex: "A22044", name: "A22044"),
                    ItemColor(hex: "FFABAB", name: "FFABAB"), ItemColor(hex: "EE857F", name: "EE857F"), ItemColor(hex: "ED6F8B", name: "ED6F8B"), ItemColor(hex: "C8475D", name: "C8475D"),
                    ItemColor(hex: "D04747", name: "D04747"), ItemColor(hex: "C7465B", name: "C7465B"), ItemColor(hex: "A12B0B", name: "A12B0B"), ItemColor(hex: "730000", name: "730000")]
        case .Hot_Color:
            return [ItemColor(hex: "FFF6A1", name: "FFF6A1"), ItemColor(hex: "EDC98F", name: "EDC98F"), ItemColor(hex: "FBCA4E", name: "FBCA4E"), ItemColor(hex: "F08302", name: "F08302"),
                    ItemColor(hex: "EDB400", name: "EDB400"), ItemColor(hex: "D9A72E", name: "D9A72E"), ItemColor(hex: "844F07", name: "844F07"), ItemColor(hex: "B55210", name: "B55210"),
                    ItemColor(hex: "FFD977", name: "FFD977"), ItemColor(hex: "FFDA00", name: "FFDA00"), ItemColor(hex: "FAB14F", name: "FAB14F"), ItemColor(hex: "B27400", name: "B27400"),
                    ItemColor(hex: "E39210", name: "E39210"), ItemColor(hex: "E55E31", name: "E55E31"), ItemColor(hex: "AD7D4C", name: "AD7D4C"), ItemColor(hex: "5E3805", name: "5E3805"),]
        case .Natural_Color:
            return [ItemColor(hex: "E8EBB0", name: "E8EBB0"), ItemColor(hex: "ADCA67", name: "ADCA67"), ItemColor(hex: "AFCCA1", name: "AFCCA1"), ItemColor(hex: "66CA32", name: "66CA32"),
                    ItemColor(hex: "9DFF68", name: "9DFF68"), ItemColor(hex: "7FDF4D", name: "7FDF4D"), ItemColor(hex: "3AB56E", name: "3AB56E"), ItemColor(hex: "006852", name: "006852"),
                    ItemColor(hex: "CBDA8D", name: "CBDA8D"), ItemColor(hex: "B8DA1B", name: "B8DA1B"), ItemColor(hex: "9CAD51", name: "9CAD51"), ItemColor(hex: "6B841D", name: "6B841D"),
                    ItemColor(hex: "9FDA67", name: "9FDA67"), ItemColor(hex: "4EC349", name: "4EC349"), ItemColor(hex: "038962", name: "038962"), ItemColor(hex: "275E3A", name: "275E3A"),]
        case .Sky_Color:
            return[ItemColor(hex: "D2FFF0", name: "D2FFF0"), ItemColor(hex: "AFFFE2", name: "AFFFE2"), ItemColor(hex: "2BD9C2", name: "2BD9C2"), ItemColor(hex: "6DC8C5", name: "6DC8C5"),
                   ItemColor(hex: "1CA5AD", name: "1CA5AD"), ItemColor(hex: "085872", name: "085872"), ItemColor(hex: "3964B2", name: "3964B2"), ItemColor(hex: "002A47", name: "002A47"),
                   ItemColor(hex: "B5F0FF", name: "B5F0FF"), ItemColor(hex: "73F8F7", name: "73F8F7"), ItemColor(hex: "88C6F2", name: "88C6F2"), ItemColor(hex: "0097DA", name: "0097DA"),
                   ItemColor(hex: "39C1D7", name: "39C1D7"), ItemColor(hex: "649DED", name: "649DED"), ItemColor(hex: "207FAD", name: "207FAD"), ItemColor(hex: "242670", name: "242670")]
        case .Purple_Color:
            return [ItemColor(hex: "F0CAFF", name: "F0CAFF"), ItemColor(hex: "CD80B2", name: "CD80B2"), ItemColor(hex: "CEBAEF", name: "CEBAEF"), ItemColor(hex: "A03DF2", name: "A03DF2"),
                    ItemColor(hex: "AD7FFB", name: "AD7FFB"), ItemColor(hex: "6E4CDF", name: "6E4CDF"), ItemColor(hex: "C331F7", name: "C331F7"), ItemColor(hex: "7C55BF", name: "7C55BF"),
                    ItemColor(hex: "C5A3BF", name: "C5A3BF"), ItemColor(hex: "AD69C0", name: "AD69C0"), ItemColor(hex: "9079AF", name: "9079AF"), ItemColor(hex: "6A20A5", name: "6A20A5"),
                    ItemColor(hex: "754C82", name: "754C82"), ItemColor(hex: "611A87", name: "611A87"), ItemColor(hex: "892299", name: "892299"), ItemColor(hex: "360E46", name: "360E46")]
        case .Gradient_Color1:
            return [ ItemColor(color: UIColor(patternImage: R.image.color_gradient_one0() ?? UIImage()), name:"color_gradient_one0" ),
                     ItemColor(color: UIColor(patternImage: R.image.color_gradient_one1() ?? UIImage()), name:"color_gradient_one1" ),
                     ItemColor(color: UIColor(patternImage: R.image.color_gradient_one2() ?? UIImage()), name:"color_gradient_one2" ),
                     ItemColor(color: UIColor(patternImage: R.image.color_gradient_one3() ?? UIImage()), name:"color_gradient_one3" ),
                     ItemColor(color: UIColor(patternImage: R.image.color_gradient_one4() ?? UIImage()), name:"color_gradient_one4" ),
                     ItemColor(color: UIColor(patternImage: R.image.color_gradient_one5() ?? UIImage()), name:"color_gradient_one5" ),
                     ItemColor(color: UIColor(patternImage: R.image.color_gradient_one6() ?? UIImage()), name:"color_gradient_one6" ),
                     ItemColor(color: UIColor(patternImage: R.image.color_gradient_one7() ?? UIImage()), name:"color_gradient_one7" ),
                     ItemColor(color: UIColor(patternImage: R.image.color_gradient_one8() ?? UIImage()), name:"color_gradient_one8" ),
                     ItemColor(color: UIColor(patternImage: R.image.color_gradient_one9() ?? UIImage()), name:"color_gradient_one9" ),
                     ItemColor(color: UIColor(patternImage: R.image.color_gradient_one10() ?? UIImage()), name:"color_gradient_one10"),
                     ItemColor(color: UIColor(patternImage: R.image.color_gradient_one11() ?? UIImage()), name:"color_gradient_one11"),
                     ItemColor(color: UIColor(patternImage: R.image.color_gradient_one12() ?? UIImage()), name:"color_gradient_one12"),
                     ItemColor(color: UIColor(patternImage: R.image.color_gradient_one13() ?? UIImage()), name:"color_gradient_one13"),
                     ItemColor(color: UIColor(patternImage: R.image.color_gradient_one14() ?? UIImage()), name:"color_gradient_one14"),
                     ItemColor(color: UIColor(patternImage: R.image.color_gradient_one15() ?? UIImage()), name:"color_gradient_one15")]
        case .Gradient_Color2:
            return [ItemColor(color: UIColor(patternImage: R.image.color_gradient_two0() ?? UIImage()), name: "color_gradient_two0"),
                    ItemColor(color: UIColor(patternImage: R.image.color_gradient_two1() ?? UIImage()), name: "color_gradient_two1"),
                    ItemColor(color: UIColor(patternImage: R.image.color_gradient_two2() ?? UIImage()), name: "color_gradient_two2"),
                    ItemColor(color: UIColor(patternImage: R.image.color_gradient_two3() ?? UIImage()), name: "color_gradient_two3"),
                    ItemColor(color: UIColor(patternImage: R.image.color_gradient_two4() ?? UIImage()), name: "color_gradient_two4"),
                    ItemColor(color: UIColor(patternImage: R.image.color_gradient_two5() ?? UIImage()), name: "color_gradient_two5"),
                    ItemColor(color: UIColor(patternImage: R.image.color_gradient_two6() ?? UIImage()), name: "color_gradient_two6"),
                    ItemColor(color: UIColor(patternImage: R.image.color_gradient_two7() ?? UIImage()), name: "color_gradient_two7"),
                    ItemColor(color: UIColor(patternImage: R.image.color_gradient_two8() ?? UIImage()), name: "color_gradient_two8"),
                    ItemColor(color: UIColor(patternImage: R.image.color_gradient_two9() ?? UIImage()), name: "color_gradient_two9"),
                    ItemColor(color: UIColor(patternImage: R.image.color_gradient_two10() ?? UIImage()), name: "color_gradient_two10"),
                    ItemColor(color: UIColor(patternImage: R.image.color_gradient_two11() ?? UIImage()), name: "color_gradient_two11"),
                    ItemColor(color: UIColor(patternImage: R.image.color_gradient_two12() ?? UIImage()), name: "color_gradient_two12"),
                    ItemColor(color: UIColor(patternImage: R.image.color_gradient_two13() ?? UIImage()), name: "color_gradient_two13"),
                    ItemColor(color: UIColor(patternImage: R.image.color_gradient_two14() ?? UIImage()), name: "color_gradient_two14"),
                    ItemColor(color: UIColor(patternImage: R.image.color_gradient_two15() ?? UIImage()), name: "color_gradient_two15")]
        case .Galaxy_Color:
            return [ItemColor(color: UIColor(patternImage: R.image.color_gradient_galaxy0() ?? UIImage()), name: "color_gradient_galaxy0"),
                    ItemColor(color: UIColor(patternImage: R.image.color_gradient_galaxy1() ?? UIImage()), name: "color_gradient_galaxy1"),
                    ItemColor(color: UIColor(patternImage: R.image.color_gradient_galaxy2() ?? UIImage()), name: "color_gradient_galaxy2"),
                    ItemColor(color: UIColor(patternImage: R.image.color_gradient_galaxy3() ?? UIImage()), name: "color_gradient_galaxy3"),
                    ItemColor(color: UIColor(patternImage: R.image.color_gradient_galaxy4() ?? UIImage()), name: "color_gradient_galaxy4"),
                    ItemColor(color: UIColor(patternImage: R.image.color_gradient_galaxy5() ?? UIImage()), name: "color_gradient_galaxy5"),
                    ItemColor(color: UIColor(patternImage: R.image.color_gradient_galaxy6() ?? UIImage()), name: "color_gradient_galaxy6"),
                    ItemColor(color: UIColor(patternImage: R.image.color_gradient_galaxy7() ?? UIImage()), name: "color_gradient_galaxy7"),
                    ItemColor(color: UIColor(patternImage: R.image.color_gradient_galaxy8() ?? UIImage()), name: "color_gradient_galaxy8"),
                    ItemColor(color: UIColor(patternImage: R.image.color_gradient_galaxy9() ?? UIImage()), name: "color_gradient_galaxy9"),
                    ItemColor(color: UIColor(patternImage: R.image.color_gradient_galaxy10() ?? UIImage()), name: "color_gradient_galaxy10"),
                    ItemColor(color: UIColor(patternImage: R.image.color_gradient_galaxy11() ?? UIImage()), name: "color_gradient_galaxy11"),
                    ItemColor(color: UIColor(patternImage: R.image.color_gradient_galaxy12() ?? UIImage()), name: "color_gradient_galaxy12"),
                    ItemColor(color: UIColor(patternImage: R.image.color_gradient_galaxy13() ?? UIImage()), name: "color_gradient_galaxy13"),
                    ItemColor(color: UIColor(patternImage: R.image.color_gradient_galaxy14() ?? UIImage()), name: "color_gradient_galaxy14"),
                    ItemColor(color: UIColor(patternImage: R.image.color_gradient_galaxy15() ?? UIImage()), name: "color_gradient_galaxy15")]
        case .Pastel_Color:
            return []
        case .Sweet_Color:
            return []
        case .Mystical_Color:
            return []
        }
    }
    
    var lisTheme: ListFillterColor? {
        switch self {
        case .Pastel_Color:
            return .Pastel
        case .Sweet_Color:
            return .Sweet
        case .Mystical_Color:
            return .Mystical
        default: return nil
        }
    }
}

struct ItemColor {
    var hex: String?
    var color: UIColor?
    var name: String?
}

enum ListFillterColor: CaseIterable {
    case Pastel
    case Sweet
    case Mystical
    
    var listColor: [ThemeColor] {
        switch self {
        case .Pastel:
            return [.BlingPastel,
                    .ButterflyPastel,
                    .BlingBlingPastel,
                    .SnowFlakesPastel,
                    .Bling3Pastel,
                    .BubblePastel,
                    .SnowPastel]
        case .Sweet:
            return [.BlingSweet,
                    .ButterflySweet,
                    .BlingBlingSweet,
                    .SnowFlakesSweet,
                    .Bling3Sweet,
                    .BubbleSweet,
                    .SnowSweet]
        case .Mystical:
            return [.BlingMystical,
                    .ButterflyMystical,
                    .BlingBlingMystical,
                    .SnowFlakesMystical,
                    .Bling3Mystical,
                    .BubbleMystical,
                    .SnowMystical]
        }
    }
}

enum ThemeColor: CaseIterable {
    case BlingPastel
    case ButterflyPastel
    case BlingBlingPastel
    case SnowFlakesPastel
    case Bling3Pastel
    case BubblePastel
    case SnowPastel
    case BlingSweet
    case ButterflySweet
    case BlingBlingSweet
    case SnowFlakesSweet
    case Bling3Sweet
    case BubbleSweet
    case SnowSweet
    case BlingMystical
    case ButterflyMystical
    case BlingBlingMystical
    case SnowFlakesMystical
    case Bling3Mystical
    case BubbleMystical
    case SnowMystical
    
    var listColor: [ItemThemeColor] {
        switch self {
        case .BlingPastel:
            return [.BlingPastel0, .BlingPastel1, .BlingPastel2, .BlingPastel3, .BlingPastel4, .BlingPastel5, .BlingPastel6, .BlingPastel7, .BlingPastel8, .BlingPastel9, .BlingPastel10, .BlingPastel11, .BlingPastel12, .BlingPastel13, .BlingPastel14, .BlingPastel15]
        case .ButterflyPastel:
            return [.ButterflyPastel0, .ButterflyPastel1, .ButterflyPastel2, .ButterflyPastel3, .ButterflyPastel4, .ButterflyPastel5, .ButterflyPastel6, .ButterflyPastel7, .ButterflyPastel8, .ButterflyPastel9, .ButterflyPastel10, .ButterflyPastel11, .ButterflyPastel12, .ButterflyPastel13, .ButterflyPastel14, .ButterflyPastel15]
        case .BlingBlingPastel:
            return [.BlingBlingPastel0, .BlingBlingPastel1, .BlingBlingPastel2, .BlingBlingPastel3, .BlingBlingPastel4, .BlingBlingPastel5, .BlingBlingPastel6, .BlingBlingPastel7, .BlingBlingPastel8, .BlingBlingPastel9, .BlingBlingPastel10, .BlingBlingPastel11, .BlingBlingPastel12, .BlingBlingPastel13, .BlingBlingPastel14, .BlingBlingPastel15]
        case .SnowFlakesPastel:
            return [.SnowFlakesPastel0, .SnowFlakesPastel1, .SnowFlakesPastel2, .SnowFlakesPastel3, .SnowFlakesPastel4, .SnowFlakesPastel5, .SnowFlakesPastel6, .SnowFlakesPastel7, .SnowFlakesPastel8, .SnowFlakesPastel9, .SnowFlakesPastel10, .SnowFlakesPastel11, .SnowFlakesPastel12, .SnowFlakesPastel13, .SnowFlakesPastel14, .SnowFlakesPastel15]
        case .Bling3Pastel:
            return [.Bling3Pastel0, .Bling3Pastel1, .Bling3Pastel2, .Bling3Pastel3, .Bling3Pastel4, .Bling3Pastel5, .Bling3Pastel6, .Bling3Pastel7, .Bling3Pastel8, .Bling3Pastel9, .Bling3Pastel10, .Bling3Pastel11, .Bling3Pastel12, .Bling3Pastel13, .Bling3Pastel14, .Bling3Pastel15]
        case .BubblePastel:
            return [.BubblePastel0, .BubblePastel1, .BubblePastel2, .BubblePastel3, .BubblePastel4, .BubblePastel5, .BubblePastel6, .BubblePastel7, .BubblePastel8, .BubblePastel9, .BubblePastel10, .BubblePastel11, .BubblePastel12, .BubblePastel13, .BubblePastel14, .BubblePastel15]
        case .SnowPastel:
            return [
                .SnowPastel0,
                .SnowPastel1,
                .SnowPastel2,
                .SnowPastel3,
                .SnowPastel4,
                .SnowPastel5,
                .SnowPastel6,
                .SnowPastel7,
                .SnowPastel8,
                .SnowPastel9,
                .SnowPastel10,
                .SnowPastel11,
                .SnowPastel12,
                .SnowPastel13,
                .SnowPastel14,
                .SnowPastel15]
        case .BlingSweet:
            return [
                .BlingSweet0,
                .BlingSweet1,
                .BlingSweet2,
                .BlingSweet3,
                .BlingSweet4,
                .BlingSweet5,
                .BlingSweet6,
                .BlingSweet7,
                .BlingSweet8,
                .BlingSweet9,
                .BlingSweet10,
                .BlingSweet11,
                .BlingSweet12,
                .BlingSweet13,
                .BlingSweet14,
                .BlingSweet15]
        case .ButterflySweet:
            return [
                .ButterflySweet0,
                .ButterflySweet1,
                .ButterflySweet2,
                .ButterflySweet3,
                .ButterflySweet4,
                .ButterflySweet5,
                .ButterflySweet6,
                .ButterflySweet7,
                .ButterflySweet8,
                .ButterflySweet9,
                .ButterflySweet10,
                .ButterflySweet11,
                .ButterflySweet12,
                .ButterflySweet13,
                .ButterflySweet14,
                .ButterflySweet15]
        case .BlingBlingSweet:
            return [
                .BlingBlingSweet0,
                .BlingBlingSweet1,
                .BlingBlingSweet2,
                .BlingBlingSweet3,
                .BlingBlingSweet4,
                .BlingBlingSweet5,
                .BlingBlingSweet6,
                .BlingBlingSweet7,
                .BlingBlingSweet8,
                .BlingBlingSweet9,
                .BlingBlingSweet10,
                .BlingBlingSweet11,
                .BlingBlingSweet12,
                .BlingBlingSweet13,
                .BlingBlingSweet14,
                .BlingBlingSweet15]
        case .SnowFlakesSweet:
            return [
                .SnowFlakesSweet0,
                .SnowFlakesSweet1,
                .SnowFlakesSweet2,
                .SnowFlakesSweet3,
                .SnowFlakesSweet4,
                .SnowFlakesSweet5,
                .SnowFlakesSweet6,
                .SnowFlakesSweet7,
                .SnowFlakesSweet8,
                .SnowFlakesSweet9,
                .SnowFlakesSweet10,
                .SnowFlakesSweet11,
                .SnowFlakesSweet12,
                .SnowFlakesSweet13,
                .SnowFlakesSweet14,
                .SnowFlakesSweet15]
        case .Bling3Sweet:
            return [
                .Bling3Sweet0,
                .Bling3Sweet1,
                .Bling3Sweet2,
                .Bling3Sweet3,
                .Bling3Sweet4,
                .Bling3Sweet5,
                .Bling3Sweet6,
                .Bling3Sweet7,
                .Bling3Sweet8,
                .Bling3Sweet9,
                .Bling3Sweet10,
                .Bling3Sweet11,
                .Bling3Sweet12,
                .Bling3Sweet13,
                .Bling3Sweet14,
                .Bling3Sweet15]
        case .BubbleSweet:
            return [
                .BubbleSweet0,
                .BubbleSweet1,
                .BubbleSweet2,
                .BubbleSweet3,
                .BubbleSweet4,
                .BubbleSweet5,
                .BubbleSweet6,
                .BubbleSweet7,
                .BubbleSweet8,
                .BubbleSweet9,
                .BubbleSweet10,
                .BubbleSweet11,
                .BubbleSweet12,
                .BubbleSweet13,
                .BubbleSweet14,
                .BubbleSweet15]
        case .SnowSweet:
            return [
                .SnowSweet0,
                .SnowSweet1,
                .SnowSweet2,
                .SnowSweet3,
                .SnowSweet4,
                .SnowSweet5,
                .SnowSweet6,
                .SnowSweet7,
                .SnowSweet8,
                .SnowSweet9,
                .SnowSweet10,
                .SnowSweet11,
                .SnowSweet12,
                .SnowSweet13,
                .SnowSweet14,
                .SnowSweet15]
        case .BlingMystical:
            return [
                .BlingMystical0,
                .BlingMystical1,
                .BlingMystical2,
                .BlingMystical3,
                .BlingMystical4,
                .BlingMystical5,
                .BlingMystical6,
                .BlingMystical7,
                .BlingMystical8,
                .BlingMystical9,
                .BlingMystical10,
                .BlingMystical11,
                .BlingMystical12,
                .BlingMystical13,
                .BlingMystical14,
                .BlingMystical15]
        case .ButterflyMystical:
            return [
                .ButterflyMystical0,
                .ButterflyMystical1,
                .ButterflyMystical2,
                .ButterflyMystical3,
                .ButterflyMystical4,
                .ButterflyMystical5,
                .ButterflyMystical6,
                .ButterflyMystical7,
                .ButterflyMystical8,
                .ButterflyMystical9,
                .ButterflyMystical10,
                .ButterflyMystical11,
                .ButterflyMystical12,
                .ButterflyMystical13,
                .ButterflyMystical14,
                .ButterflyMystical15]
        case .BlingBlingMystical:
            return [
                .BlingBlingMystical0,
                .BlingBlingMystical1,
                .BlingBlingMystical2,
                .BlingBlingMystical3,
                .BlingBlingMystical4,
                .BlingBlingMystical5,
                .BlingBlingMystical6,
                .BlingBlingMystical7,
                .BlingBlingMystical8,
                .BlingBlingMystical9,
                .BlingBlingMystical10,
                .BlingBlingMystical11,
                .BlingBlingMystical12,
                .BlingBlingMystical13,
                .BlingBlingMystical14,
                .BlingBlingMystical15]
        case .SnowFlakesMystical:
            return [
                .SnowFlakesMystical0,
                .SnowFlakesMystical1,
                .SnowFlakesMystical2,
                .SnowFlakesMystical3,
                .SnowFlakesMystical4,
                .SnowFlakesMystical5,
                .SnowFlakesMystical6,
                .SnowFlakesMystical7,
                .SnowFlakesMystical8,
                .SnowFlakesMystical9,
                .SnowFlakesMystical10,
                .SnowFlakesMystical11,
                .SnowFlakesMystical12,
                .SnowFlakesMystical13,
                .SnowFlakesMystical14,
                .SnowFlakesMystical15]
        case .Bling3Mystical:
            return [
                .Bling3Mystical0,
                .Bling3Mystical1,
                .Bling3Mystical2,
                .Bling3Mystical3,
                .Bling3Mystical4,
                .Bling3Mystical5,
                .Bling3Mystical6,
                .Bling3Mystical7,
                .Bling3Mystical8,
                .Bling3Mystical9,
                .Bling3Mystical10,
                .Bling3Mystical11,
                .Bling3Mystical12,
                .Bling3Mystical13,
                .Bling3Mystical14,
                .Bling3Mystical15]
        case .BubbleMystical:
            return [
                .BubbleMystical0,
                .BubbleMystical1,
                .BubbleMystical2,
                .BubbleMystical3,
                .BubbleMystical4,
                .BubbleMystical5,
                .BubbleMystical6,
                .BubbleMystical7,
                .BubbleMystical8,
                .BubbleMystical9,
                .BubbleMystical10,
                .BubbleMystical11,
                .BubbleMystical12,
                .BubbleMystical13,
                .BubbleMystical14,
                .BubbleMystical15]
        case .SnowMystical:
            return [
                .SnowMystical0,
                .SnowMystical1,
                .SnowMystical2,
                .SnowMystical3,
                .SnowMystical4,
                .SnowMystical5,
                .SnowMystical6,
                .SnowMystical7,
                .SnowMystical8,
                .SnowMystical9,
                .SnowMystical10,
                .SnowMystical11,
                .SnowMystical12,
                .SnowMystical13,
                .SnowMystical14,
                .SnowMystical15]
        }
    }
}


enum ItemThemeColor: CaseIterable {
    
    case BlingPastel0
    case BlingPastel1
    case BlingPastel2
    case BlingPastel3
    case BlingPastel4
    case BlingPastel5
    case BlingPastel6
    case BlingPastel7
    case BlingPastel8
    case BlingPastel9
    case BlingPastel10
    case BlingPastel11
    case BlingPastel12
    case BlingPastel13
    case BlingPastel14
    case BlingPastel15
    case ButterflyPastel0
    case ButterflyPastel1
    case ButterflyPastel2
    case ButterflyPastel3
    case ButterflyPastel4
    case ButterflyPastel5
    case ButterflyPastel6
    case ButterflyPastel7
    case ButterflyPastel8
    case ButterflyPastel9
    case ButterflyPastel10
    case ButterflyPastel11
    case ButterflyPastel12
    case ButterflyPastel13
    case ButterflyPastel14
    case ButterflyPastel15
    case BlingBlingPastel0
    case BlingBlingPastel1
    case BlingBlingPastel2
    case BlingBlingPastel3
    case BlingBlingPastel4
    case BlingBlingPastel5
    case BlingBlingPastel6
    case BlingBlingPastel7
    case BlingBlingPastel8
    case BlingBlingPastel9
    case BlingBlingPastel10
    case BlingBlingPastel11
    case BlingBlingPastel12
    case BlingBlingPastel13
    case BlingBlingPastel14
    case BlingBlingPastel15
    case SnowFlakesPastel0
    case SnowFlakesPastel1
    case SnowFlakesPastel2
    case SnowFlakesPastel3
    case SnowFlakesPastel4
    case SnowFlakesPastel5
    case SnowFlakesPastel6
    case SnowFlakesPastel7
    case SnowFlakesPastel8
    case SnowFlakesPastel9
    case SnowFlakesPastel10
    case SnowFlakesPastel11
    case SnowFlakesPastel12
    case SnowFlakesPastel13
    case SnowFlakesPastel14
    case SnowFlakesPastel15
    case Bling3Pastel0
    case Bling3Pastel1
    case Bling3Pastel2
    case Bling3Pastel3
    case Bling3Pastel4
    case Bling3Pastel5
    case Bling3Pastel6
    case Bling3Pastel7
    case Bling3Pastel8
    case Bling3Pastel9
    case Bling3Pastel10
    case Bling3Pastel11
    case Bling3Pastel12
    case Bling3Pastel13
    case Bling3Pastel14
    case Bling3Pastel15
    case BubblePastel0
    case BubblePastel1
    case BubblePastel2
    case BubblePastel3
    case BubblePastel4
    case BubblePastel5
    case BubblePastel6
    case BubblePastel7
    case BubblePastel8
    case BubblePastel9
    case BubblePastel10
    case BubblePastel11
    case BubblePastel12
    case BubblePastel13
    case BubblePastel14
    case BubblePastel15
    case SnowPastel0
    case SnowPastel1
    case SnowPastel2
    case SnowPastel3
    case SnowPastel4
    case SnowPastel5
    case SnowPastel6
    case SnowPastel7
    case SnowPastel8
    case SnowPastel9
    case SnowPastel10
    case SnowPastel11
    case SnowPastel12
    case SnowPastel13
    case SnowPastel14
    case SnowPastel15
    case BlingSweet0
    case BlingSweet1
    case BlingSweet2
    case BlingSweet3
    case BlingSweet4
    case BlingSweet5
    case BlingSweet6
    case BlingSweet7
    case BlingSweet8
    case BlingSweet9
    case BlingSweet10
    case BlingSweet11
    case BlingSweet12
    case BlingSweet13
    case BlingSweet14
    case BlingSweet15
    case ButterflySweet0
    case ButterflySweet1
    case ButterflySweet2
    case ButterflySweet3
    case ButterflySweet4
    case ButterflySweet5
    case ButterflySweet6
    case ButterflySweet7
    case ButterflySweet8
    case ButterflySweet9
    case ButterflySweet10
    case ButterflySweet11
    case ButterflySweet12
    case ButterflySweet13
    case ButterflySweet14
    case ButterflySweet15
    case BlingBlingSweet0
    case BlingBlingSweet1
    case BlingBlingSweet2
    case BlingBlingSweet3
    case BlingBlingSweet4
    case BlingBlingSweet5
    case BlingBlingSweet6
    case BlingBlingSweet7
    case BlingBlingSweet8
    case BlingBlingSweet9
    case BlingBlingSweet10
    case BlingBlingSweet11
    case BlingBlingSweet12
    case BlingBlingSweet13
    case BlingBlingSweet14
    case BlingBlingSweet15
    case SnowFlakesSweet0
    case SnowFlakesSweet1
    case SnowFlakesSweet2
    case SnowFlakesSweet3
    case SnowFlakesSweet4
    case SnowFlakesSweet5
    case SnowFlakesSweet6
    case SnowFlakesSweet7
    case SnowFlakesSweet8
    case SnowFlakesSweet9
    case SnowFlakesSweet10
    case SnowFlakesSweet11
    case SnowFlakesSweet12
    case SnowFlakesSweet13
    case SnowFlakesSweet14
    case SnowFlakesSweet15
    case Bling3Sweet0
    case Bling3Sweet1
    case Bling3Sweet2
    case Bling3Sweet3
    case Bling3Sweet4
    case Bling3Sweet5
    case Bling3Sweet6
    case Bling3Sweet7
    case Bling3Sweet8
    case Bling3Sweet9
    case Bling3Sweet10
    case Bling3Sweet11
    case Bling3Sweet12
    case Bling3Sweet13
    case Bling3Sweet14
    case Bling3Sweet15
    case BubbleSweet0
    case BubbleSweet1
    case BubbleSweet2
    case BubbleSweet3
    case BubbleSweet4
    case BubbleSweet5
    case BubbleSweet6
    case BubbleSweet7
    case BubbleSweet8
    case BubbleSweet9
    case BubbleSweet10
    case BubbleSweet11
    case BubbleSweet12
    case BubbleSweet13
    case BubbleSweet14
    case BubbleSweet15
    case SnowSweet0
    case SnowSweet1
    case SnowSweet2
    case SnowSweet3
    case SnowSweet4
    case SnowSweet5
    case SnowSweet6
    case SnowSweet7
    case SnowSweet8
    case SnowSweet9
    case SnowSweet10
    case SnowSweet11
    case SnowSweet12
    case SnowSweet13
    case SnowSweet14
    case SnowSweet15
    case BlingMystical0
    case BlingMystical1
    case BlingMystical2
    case BlingMystical3
    case BlingMystical4
    case BlingMystical5
    case BlingMystical6
    case BlingMystical7
    case BlingMystical8
    case BlingMystical9
    case BlingMystical10
    case BlingMystical11
    case BlingMystical12
    case BlingMystical13
    case BlingMystical14
    case BlingMystical15
    case ButterflyMystical0
    case ButterflyMystical1
    case ButterflyMystical2
    case ButterflyMystical3
    case ButterflyMystical4
    case ButterflyMystical5
    case ButterflyMystical6
    case ButterflyMystical7
    case ButterflyMystical8
    case ButterflyMystical9
    case ButterflyMystical10
    case ButterflyMystical11
    case ButterflyMystical12
    case ButterflyMystical13
    case ButterflyMystical14
    case ButterflyMystical15
    case BlingBlingMystical0
    case BlingBlingMystical1
    case BlingBlingMystical2
    case BlingBlingMystical3
    case BlingBlingMystical4
    case BlingBlingMystical5
    case BlingBlingMystical6
    case BlingBlingMystical7
    case BlingBlingMystical8
    case BlingBlingMystical9
    case BlingBlingMystical10
    case BlingBlingMystical11
    case BlingBlingMystical12
    case BlingBlingMystical13
    case BlingBlingMystical14
    case BlingBlingMystical15
    case SnowFlakesMystical0
    case SnowFlakesMystical1
    case SnowFlakesMystical2
    case SnowFlakesMystical3
    case SnowFlakesMystical4
    case SnowFlakesMystical5
    case SnowFlakesMystical6
    case SnowFlakesMystical7
    case SnowFlakesMystical8
    case SnowFlakesMystical9
    case SnowFlakesMystical10
    case SnowFlakesMystical11
    case SnowFlakesMystical12
    case SnowFlakesMystical13
    case SnowFlakesMystical14
    case SnowFlakesMystical15
    case Bling3Mystical0
    case Bling3Mystical1
    case Bling3Mystical2
    case Bling3Mystical3
    case Bling3Mystical4
    case Bling3Mystical5
    case Bling3Mystical6
    case Bling3Mystical7
    case Bling3Mystical8
    case Bling3Mystical9
    case Bling3Mystical10
    case Bling3Mystical11
    case Bling3Mystical12
    case Bling3Mystical13
    case Bling3Mystical14
    case Bling3Mystical15
    case BubbleMystical0
    case BubbleMystical1
    case BubbleMystical2
    case BubbleMystical3
    case BubbleMystical4
    case BubbleMystical5
    case BubbleMystical6
    case BubbleMystical7
    case BubbleMystical8
    case BubbleMystical9
    case BubbleMystical10
    case BubbleMystical11
    case BubbleMystical12
    case BubbleMystical13
    case BubbleMystical14
    case BubbleMystical15
    case SnowMystical0
    case SnowMystical1
    case SnowMystical2
    case SnowMystical3
    case SnowMystical4
    case SnowMystical5
    case SnowMystical6
    case SnowMystical7
    case SnowMystical8
    case SnowMystical9
    case SnowMystical10
    case SnowMystical11
    case SnowMystical12
    case SnowMystical13
    case SnowMystical14
    case SnowMystical15
    
    var name: String {
        switch self {
        case .BlingPastel0:
            return "BlingPastel0"
        case .BlingPastel1:
            return "BlingPastel1"
        case .BlingPastel2:
            return "BlingPastel2"
        case .BlingPastel3:
            return "BlingPastel3"
        case .BlingPastel4:
            return "BlingPastel4"
        case .BlingPastel5:
            return "BlingPastel5"
        case .BlingPastel6:
            return "BlingPastel6"
        case .BlingPastel7:
            return "BlingPastel7"
        case .BlingPastel8:
            return "BlingPastel8"
        case .BlingPastel9:
            return "BlingPastel9"
        case .BlingPastel10:
            return "BlingPastel10"
        case .BlingPastel11:
            return "BlingPastel11"
        case .BlingPastel12:
            return "BlingPastel12"
        case .BlingPastel13:
            return "BlingPastel13"
        case .BlingPastel14:
            return "BlingPastel14"
        case .BlingPastel15:
            return "BlingPastel15"
        case .ButterflyPastel0:
            return "ButterflyPastel0"
        case .ButterflyPastel1:
            return "ButterflyPastel1"
        case .ButterflyPastel2:
            return "ButterflyPastel2"
        case .ButterflyPastel3:
            return "ButterflyPastel3"
        case .ButterflyPastel4:
            return "ButterflyPastel4"
        case .ButterflyPastel5:
            return "ButterflyPastel5"
        case .ButterflyPastel6:
            return "ButterflyPastel6"
        case .ButterflyPastel7:
            return "ButterflyPastel7"
        case .ButterflyPastel8:
            return "ButterflyPastel8"
        case .ButterflyPastel9:
            return "ButterflyPastel9"
        case .ButterflyPastel10:
            return "ButterflyPastel10"
        case .ButterflyPastel11:
            return "ButterflyPastel11"
        case .ButterflyPastel12:
            return "ButterflyPastel12"
        case .ButterflyPastel13:
            return "ButterflyPastel13"
        case .ButterflyPastel14:
            return "ButterflyPastel14"
        case .ButterflyPastel15:
            return "ButterflyPastel15"
        case .BlingBlingPastel0:
            return "BlingBlingPastel0"
        case .BlingBlingPastel1:
            return "BlingBlingPastel1"
        case .BlingBlingPastel2:
            return "BlingBlingPastel2"
        case .BlingBlingPastel3:
            return "BlingBlingPastel3"
        case .BlingBlingPastel4:
            return "BlingBlingPastel4"
        case .BlingBlingPastel5:
            return "BlingBlingPastel5"
        case .BlingBlingPastel6:
            return "BlingBlingPastel6"
        case .BlingBlingPastel7:
            return "BlingBlingPastel7"
        case .BlingBlingPastel8:
            return "BlingBlingPastel8"
        case .BlingBlingPastel9:
            return "BlingBlingPastel9"
        case .BlingBlingPastel10:
            return "BlingBlingPastel10"
        case .BlingBlingPastel11:
            return "BlingBlingPastel11"
        case .BlingBlingPastel12:
            return "BlingBlingPastel12"
        case .BlingBlingPastel13:
            return "BlingBlingPastel13"
        case .BlingBlingPastel14:
            return "BlingBlingPastel14"
        case .BlingBlingPastel15:
            return "BlingBlingPastel15"
        case .SnowFlakesPastel0:
            return "SnowFlakesPastel0"
        case .SnowFlakesPastel1:
            return "SnowFlakesPastel1"
        case .SnowFlakesPastel2:
            return "SnowFlakesPastel2"
        case .SnowFlakesPastel3:
            return "SnowFlakesPastel3"
        case .SnowFlakesPastel4:
            return "SnowFlakesPastel4"
        case .SnowFlakesPastel5:
            return "SnowFlakesPastel5"
        case .SnowFlakesPastel6:
            return "SnowFlakesPastel6"
        case .SnowFlakesPastel7:
            return "SnowFlakesPastel7"
        case .SnowFlakesPastel8:
            return "SnowFlakesPastel8"
        case .SnowFlakesPastel9:
            return "SnowFlakesPastel9"
        case .SnowFlakesPastel10:
            return "SnowFlakesPastel10"
        case .SnowFlakesPastel11:
            return "SnowFlakesPastel11"
        case .SnowFlakesPastel12:
            return "SnowFlakesPastel12"
        case .SnowFlakesPastel13:
            return "SnowFlakesPastel13"
        case .SnowFlakesPastel14:
            return "SnowFlakesPastel14"
        case .SnowFlakesPastel15:
            return "SnowFlakesPastel15"
        case .Bling3Pastel0:
            return "Bling3Pastel0"
        case .Bling3Pastel1:
            return "Bling3Pastel1"
        case .Bling3Pastel2:
            return "Bling3Pastel2"
        case .Bling3Pastel3:
            return "Bling3Pastel3"
        case .Bling3Pastel4:
            return "Bling3Pastel4"
        case .Bling3Pastel5:
            return "Bling3Pastel5"
        case .Bling3Pastel6:
            return "Bling3Pastel6"
        case .Bling3Pastel7:
            return "Bling3Pastel7"
        case .Bling3Pastel8:
            return "Bling3Pastel8"
        case .Bling3Pastel9:
            return "Bling3Pastel9"
        case .Bling3Pastel10:
            return "Bling3Pastel10"
        case .Bling3Pastel11:
            return "Bling3Pastel11"
        case .Bling3Pastel12:
            return "Bling3Pastel12"
        case .Bling3Pastel13:
            return "Bling3Pastel13"
        case .Bling3Pastel14:
            return "Bling3Pastel14"
        case .Bling3Pastel15:
            return "Bling3Pastel15"
        case .BubblePastel0:
            return "BubblePastel0"
        case .BubblePastel1:
            return "BubblePastel1"
        case .BubblePastel2:
            return "BubblePastel2"
        case .BubblePastel3:
            return "BubblePastel3"
        case .BubblePastel4:
            return "BubblePastel4"
        case .BubblePastel5:
            return "BubblePastel5"
        case .BubblePastel6:
            return "BubblePastel6"
        case .BubblePastel7:
            return "BubblePastel7"
        case .BubblePastel8:
            return "BubblePastel8"
        case .BubblePastel9:
            return "BubblePastel9"
        case .BubblePastel10:
            return "BubblePastel10"
        case .BubblePastel11:
            return "BubblePastel11"
        case .BubblePastel12:
            return "BubblePastel12"
        case .BubblePastel13:
            return "BubblePastel13"
        case .BubblePastel14:
            return "BubblePastel14"
        case .BubblePastel15:
            return "BubblePastel15"
        case .SnowPastel0:
            return "SnowPastel0"
        case .SnowPastel1:
            return "SnowPastel1"
        case .SnowPastel2:
            return "SnowPastel2"
        case .SnowPastel3:
            return "SnowPastel3"
        case .SnowPastel4:
            return "SnowPastel4"
        case .SnowPastel5:
            return "SnowPastel5"
        case .SnowPastel6:
            return "SnowPastel6"
        case .SnowPastel7:
            return "SnowPastel7"
        case .SnowPastel8:
            return "SnowPastel8"
        case .SnowPastel9:
            return "SnowPastel9"
        case .SnowPastel10:
            return "SnowPastel10"
        case .SnowPastel11:
            return "SnowPastel11"
        case .SnowPastel12:
            return "SnowPastel12"
        case .SnowPastel13:
            return "SnowPastel13"
        case .SnowPastel14:
            return "SnowPastel14"
        case .SnowPastel15:
            return "SnowPastel15"
        case .BlingSweet0:
            return "BlingSweet0"
        case .BlingSweet1:
            return "BlingSweet1"
        case .BlingSweet2:
            return "BlingSweet2"
        case .BlingSweet3:
            return "BlingSweet3"
        case .BlingSweet4:
            return "BlingSweet4"
        case .BlingSweet5:
            return "BlingSweet5"
        case .BlingSweet6:
            return "BlingSweet6"
        case .BlingSweet7:
            return "BlingSweet7"
        case .BlingSweet8:
            return "BlingSweet8"
        case .BlingSweet9:
            return "BlingSweet9"
        case .BlingSweet10:
            return "BlingSweet10"
        case .BlingSweet11:
            return "BlingSweet11"
        case .BlingSweet12:
            return "BlingSweet12"
        case .BlingSweet13:
            return "BlingSweet13"
        case .BlingSweet14:
            return "BlingSweet14"
        case .BlingSweet15:
            return "BlingSweet15"
        case .ButterflySweet0:
            return "ButterflySweet0"
        case .ButterflySweet1:
            return "ButterflySweet1"
        case .ButterflySweet2:
            return "ButterflySweet2"
        case .ButterflySweet3:
            return "ButterflySweet3"
        case .ButterflySweet4:
            return "ButterflySweet4"
        case .ButterflySweet5:
            return "ButterflySweet5"
        case .ButterflySweet6:
            return "ButterflySweet6"
        case .ButterflySweet7:
            return "ButterflySweet7"
        case .ButterflySweet8:
            return "ButterflySweet8"
        case .ButterflySweet9:
            return "ButterflySweet9"
        case .ButterflySweet10:
            return "ButterflySweet10"
        case .ButterflySweet11:
            return "ButterflySweet11"
        case .ButterflySweet12:
            return "ButterflySweet12"
        case .ButterflySweet13:
            return "ButterflySweet13"
        case .ButterflySweet14:
            return "ButterflySweet14"
        case .ButterflySweet15:
            return "ButterflySweet15"
        case .BlingBlingSweet0:
            return "BlingBlingSweet0"
        case .BlingBlingSweet1:
            return "BlingBlingSweet1"
        case .BlingBlingSweet2:
            return "BlingBlingSweet2"
        case .BlingBlingSweet3:
            return "BlingBlingSweet3"
        case .BlingBlingSweet4:
            return "BlingBlingSweet4"
        case .BlingBlingSweet5:
            return "BlingBlingSweet5"
        case .BlingBlingSweet6:
            return "BlingBlingSweet6"
        case .BlingBlingSweet7:
            return "BlingBlingSweet7"
        case .BlingBlingSweet8:
            return "BlingBlingSweet8"
        case .BlingBlingSweet9:
            return "BlingBlingSweet9"
        case .BlingBlingSweet10:
            return "BlingBlingSweet10"
        case .BlingBlingSweet11:
            return "BlingBlingSweet11"
        case .BlingBlingSweet12:
            return "BlingBlingSweet12"
        case .BlingBlingSweet13:
            return "BlingBlingSweet13"
        case .BlingBlingSweet14:
            return "BlingBlingSweet14"
        case .BlingBlingSweet15:
            return "BlingBlingSweet15"
        case .SnowFlakesSweet0:
            return "SnowFlakesSweet0"
        case .SnowFlakesSweet1:
            return "SnowFlakesSweet1"
        case .SnowFlakesSweet2:
            return "SnowFlakesSweet2"
        case .SnowFlakesSweet3:
            return "SnowFlakesSweet3"
        case .SnowFlakesSweet4:
            return "SnowFlakesSweet4"
        case .SnowFlakesSweet5:
            return "SnowFlakesSweet5"
        case .SnowFlakesSweet6:
            return "SnowFlakesSweet6"
        case .SnowFlakesSweet7:
            return "SnowFlakesSweet7"
        case .SnowFlakesSweet8:
            return "SnowFlakesSweet8"
        case .SnowFlakesSweet9:
            return "SnowFlakesSweet9"
        case .SnowFlakesSweet10:
            return "SnowFlakesSweet10"
        case .SnowFlakesSweet11:
            return "SnowFlakesSweet11"
        case .SnowFlakesSweet12:
            return "SnowFlakesSweet12"
        case .SnowFlakesSweet13:
            return "SnowFlakesSweet13"
        case .SnowFlakesSweet14:
            return "SnowFlakesSweet14"
        case .SnowFlakesSweet15:
            return "SnowFlakesSweet15"
        case .Bling3Sweet0:
            return "Bling3Sweet0"
        case .Bling3Sweet1:
            return "Bling3Sweet1"
        case .Bling3Sweet2:
            return "Bling3Sweet2"
        case .Bling3Sweet3:
            return "Bling3Sweet3"
        case .Bling3Sweet4:
            return "Bling3Sweet4"
        case .Bling3Sweet5:
            return "Bling3Sweet5"
        case .Bling3Sweet6:
            return "Bling3Sweet6"
        case .Bling3Sweet7:
            return "Bling3Sweet7"
        case .Bling3Sweet8:
            return "Bling3Sweet8"
        case .Bling3Sweet9:
            return "Bling3Sweet9"
        case .Bling3Sweet10:
            return "Bling3Sweet10"
        case .Bling3Sweet11:
            return "Bling3Sweet11"
        case .Bling3Sweet12:
            return "Bling3Sweet12"
        case .Bling3Sweet13:
            return "Bling3Sweet13"
        case .Bling3Sweet14:
            return "Bling3Sweet14"
        case .Bling3Sweet15:
            return "Bling3Sweet15"
        case .BubbleSweet0:
            return "BubbleSweet0"
        case .BubbleSweet1:
            return "BubbleSweet1"
        case .BubbleSweet2:
            return "BubbleSweet2"
        case .BubbleSweet3:
            return "BubbleSweet3"
        case .BubbleSweet4:
            return "BubbleSweet4"
        case .BubbleSweet5:
            return "BubbleSweet5"
        case .BubbleSweet6:
            return "BubbleSweet6"
        case .BubbleSweet7:
            return "BubbleSweet7"
        case .BubbleSweet8:
            return "BubbleSweet8"
        case .BubbleSweet9:
            return "BubbleSweet9"
        case .BubbleSweet10:
            return "BubbleSweet10"
        case .BubbleSweet11:
            return "BubbleSweet11"
        case .BubbleSweet12:
            return "BubbleSweet12"
        case .BubbleSweet13:
            return "BubbleSweet13"
        case .BubbleSweet14:
            return "BubbleSweet14"
        case .BubbleSweet15:
            return "BubbleSweet15"
        case .SnowSweet0:
            return "SnowSweet0"
        case .SnowSweet1:
            return "SnowSweet1"
        case .SnowSweet2:
            return "SnowSweet2"
        case .SnowSweet3:
            return "SnowSweet3"
        case .SnowSweet4:
            return "SnowSweet4"
        case .SnowSweet5:
            return "SnowSweet5"
        case .SnowSweet6:
            return "SnowSweet6"
        case .SnowSweet7:
            return "SnowSweet7"
        case .SnowSweet8:
            return "SnowSweet8"
        case .SnowSweet9:
            return "SnowSweet9"
        case .SnowSweet10:
            return "SnowSweet10"
        case .SnowSweet11:
            return "SnowSweet11"
        case .SnowSweet12:
            return "SnowSweet12"
        case .SnowSweet13:
            return "SnowSweet13"
        case .SnowSweet14:
            return "SnowSweet14"
        case .SnowSweet15:
            return "SnowSweet15"
        case .BlingMystical0:
            return "BlingMystical0"
        case .BlingMystical1:
            return "BlingMystical1"
        case .BlingMystical2:
            return "BlingMystical2"
        case .BlingMystical3:
            return "BlingMystical3"
        case .BlingMystical4:
            return "BlingMystical4"
        case .BlingMystical5:
            return "BlingMystical5"
        case .BlingMystical6:
            return "BlingMystical6"
        case .BlingMystical7:
            return "BlingMystical7"
        case .BlingMystical8:
            return "BlingMystical8"
        case .BlingMystical9:
            return "BlingMystical9"
        case .BlingMystical10:
            return "BlingMystical10"
        case .BlingMystical11:
            return "BlingMystical11"
        case .BlingMystical12:
            return "BlingMystical12"
        case .BlingMystical13:
            return "BlingMystical13"
        case .BlingMystical14:
            return "BlingMystical14"
        case .BlingMystical15:
            return "BlingMystical15"
        case .ButterflyMystical0:
            return "ButterflyMystical0"
        case .ButterflyMystical1:
            return "ButterflyMystical1"
        case .ButterflyMystical2:
            return "ButterflyMystical2"
        case .ButterflyMystical3:
            return "ButterflyMystical3"
        case .ButterflyMystical4:
            return "ButterflyMystical4"
        case .ButterflyMystical5:
            return "ButterflyMystical5"
        case .ButterflyMystical6:
            return "ButterflyMystical6"
        case .ButterflyMystical7:
            return "ButterflyMystical7"
        case .ButterflyMystical8:
            return "ButterflyMystical8"
        case .ButterflyMystical9:
            return "ButterflyMystical9"
        case .ButterflyMystical10:
            return "ButterflyMystical10"
        case .ButterflyMystical11:
            return "ButterflyMystical11"
        case .ButterflyMystical12:
            return "ButterflyMystical12"
        case .ButterflyMystical13:
            return "ButterflyMystical13"
        case .ButterflyMystical14:
            return "ButterflyMystical14"
        case .ButterflyMystical15:
            return "ButterflyMystical15"
        case .BlingBlingMystical0:
            return "BlingBlingMystical0"
        case .BlingBlingMystical1:
            return "BlingBlingMystical1"
        case .BlingBlingMystical2:
            return "BlingBlingMystical2"
        case .BlingBlingMystical3:
            return "BlingBlingMystical3"
        case .BlingBlingMystical4:
            return "BlingBlingMystical4"
        case .BlingBlingMystical5:
            return "BlingBlingMystical5"
        case .BlingBlingMystical6:
            return "BlingBlingMystical6"
        case .BlingBlingMystical7:
            return "BlingBlingMystical7"
        case .BlingBlingMystical8:
            return "BlingBlingMystical8"
        case .BlingBlingMystical9:
            return "BlingBlingMystical9"
        case .BlingBlingMystical10:
            return "BlingBlingMystical10"
        case .BlingBlingMystical11:
            return "BlingBlingMystical11"
        case .BlingBlingMystical12:
            return "BlingBlingMystical12"
        case .BlingBlingMystical13:
            return "BlingBlingMystical13"
        case .BlingBlingMystical14:
            return "BlingBlingMystical14"
        case .BlingBlingMystical15:
            return "BlingBlingMystical15"
        case .SnowFlakesMystical0:
            return "SnowFlakesMystical0"
        case .SnowFlakesMystical1:
            return "SnowFlakesMystical1"
        case .SnowFlakesMystical2:
            return "SnowFlakesMystical2"
        case .SnowFlakesMystical3:
            return "SnowFlakesMystical3"
        case .SnowFlakesMystical4:
            return "SnowFlakesMystical4"
        case .SnowFlakesMystical5:
            return "SnowFlakesMystical5"
        case .SnowFlakesMystical6:
            return "SnowFlakesMystical6"
        case .SnowFlakesMystical7:
            return "SnowFlakesMystical7"
        case .SnowFlakesMystical8:
            return "SnowFlakesMystical8"
        case .SnowFlakesMystical9:
            return "SnowFlakesMystical9"
        case .SnowFlakesMystical10:
            return "SnowFlakesMystical10"
        case .SnowFlakesMystical11:
            return "SnowFlakesMystical11"
        case .SnowFlakesMystical12:
            return "SnowFlakesMystical12"
        case .SnowFlakesMystical13:
            return "SnowFlakesMystical13"
        case .SnowFlakesMystical14:
            return "SnowFlakesMystical14"
        case .SnowFlakesMystical15:
            return "SnowFlakesMystical15"
        case .Bling3Mystical0:
            return "Bling3Mystical0"
        case .Bling3Mystical1:
            return "Bling3Mystical1"
        case .Bling3Mystical2:
            return "Bling3Mystical2"
        case .Bling3Mystical3:
            return "Bling3Mystical3"
        case .Bling3Mystical4:
            return "Bling3Mystical4"
        case .Bling3Mystical5:
            return "Bling3Mystical5"
        case .Bling3Mystical6:
            return "Bling3Mystical6"
        case .Bling3Mystical7:
            return "Bling3Mystical7"
        case .Bling3Mystical8:
            return "Bling3Mystical8"
        case .Bling3Mystical9:
            return "Bling3Mystical9"
        case .Bling3Mystical10:
            return "Bling3Mystical10"
        case .Bling3Mystical11:
            return "Bling3Mystical11"
        case .Bling3Mystical12:
            return "Bling3Mystical12"
        case .Bling3Mystical13:
            return "Bling3Mystical13"
        case .Bling3Mystical14:
            return "Bling3Mystical14"
        case .Bling3Mystical15:
            return "Bling3Mystical15"
        case .BubbleMystical0:
            return "BubbleMystical0"
        case .BubbleMystical1:
            return "BubbleMystical1"
        case .BubbleMystical2:
            return "BubbleMystical2"
        case .BubbleMystical3:
            return "BubbleMystical3"
        case .BubbleMystical4:
            return "BubbleMystical4"
        case .BubbleMystical5:
            return "BubbleMystical5"
        case .BubbleMystical6:
            return "BubbleMystical6"
        case .BubbleMystical7:
            return "BubbleMystical7"
        case .BubbleMystical8:
            return "BubbleMystical8"
        case .BubbleMystical9:
            return "BubbleMystical9"
        case .BubbleMystical10:
            return "BubbleMystical10"
        case .BubbleMystical11:
            return "BubbleMystical11"
        case .BubbleMystical12:
            return "BubbleMystical12"
        case .BubbleMystical13:
            return "BubbleMystical13"
        case .BubbleMystical14:
            return "BubbleMystical14"
        case .BubbleMystical15:
            return "BubbleMystical15"
        case .SnowMystical0:
            return "SnowMystical0"
        case .SnowMystical1:
            return "SnowMystical1"
        case .SnowMystical2:
            return "SnowMystical2"
        case .SnowMystical3:
            return "SnowMystical3"
        case .SnowMystical4:
            return "SnowMystical4"
        case .SnowMystical5:
            return "SnowMystical5"
        case .SnowMystical6:
            return "SnowMystical6"
        case .SnowMystical7:
            return "SnowMystical7"
        case .SnowMystical8:
            return "SnowMystical8"
        case .SnowMystical9:
            return "SnowMystical9"
        case .SnowMystical10:
            return "SnowMystical10"
        case .SnowMystical11:
            return "SnowMystical11"
        case .SnowMystical12:
            return "SnowMystical12"
        case .SnowMystical13:
            return "SnowMystical13"
        case .SnowMystical14:
            return "SnowMystical14"
        case .SnowMystical15:
            return "SnowMystical15"
        }
    }
    
    var color: UIColor {
        switch self {
        case .BlingPastel0: return UIColor(patternImage: R.image.color_bling_pastel0() ?? UIImage())
        case .BlingPastel1: return UIColor(patternImage: R.image.color_bling_pastel1() ?? UIImage())
        case .BlingPastel2: return UIColor(patternImage: R.image.color_bling_pastel2() ?? UIImage())
        case .BlingPastel3: return UIColor(patternImage: R.image.color_bling_pastel3() ?? UIImage())
        case .BlingPastel4: return UIColor(patternImage: R.image.color_bling_pastel4() ?? UIImage())
        case .BlingPastel5: return UIColor(patternImage: R.image.color_bling_pastel5() ?? UIImage())
        case .BlingPastel6: return UIColor(patternImage: R.image.color_bling_pastel6() ?? UIImage())
        case .BlingPastel7: return UIColor(patternImage: R.image.color_bling_pastel7() ?? UIImage())
        case .BlingPastel8: return UIColor(patternImage: R.image.color_bling_pastel8() ?? UIImage())
        case .BlingPastel9: return UIColor(patternImage: R.image.color_bling_pastel9() ?? UIImage())
        case .BlingPastel10: return UIColor(patternImage: R.image.color_bling_pastel10() ?? UIImage())
        case .BlingPastel11: return UIColor(patternImage: R.image.color_bling_pastel11() ?? UIImage())
        case .BlingPastel12: return UIColor(patternImage: R.image.color_bling_pastel12() ?? UIImage())
        case .BlingPastel13: return UIColor(patternImage: R.image.color_bling_pastel13() ?? UIImage())
        case .BlingPastel14: return UIColor(patternImage: R.image.color_bling_pastel14() ?? UIImage())
        case .BlingPastel15: return UIColor(patternImage: R.image.color_bling_pastel5() ?? UIImage())
        case .ButterflyPastel0: return UIColor(patternImage: R.image.color_butterfly_pastel0() ?? UIImage())
        case .ButterflyPastel1: return UIColor(patternImage: R.image.color_butterfly_pastel1() ?? UIImage())
        case .ButterflyPastel2: return UIColor(patternImage: R.image.color_butterfly_pastel2() ?? UIImage())
        case .ButterflyPastel3: return UIColor(patternImage: R.image.color_butterfly_pastel3() ?? UIImage())
        case .ButterflyPastel4: return UIColor(patternImage: R.image.color_butterfly_pastel4() ?? UIImage())
        case .ButterflyPastel5: return UIColor(patternImage: R.image.color_butterfly_pastel5() ?? UIImage())
        case .ButterflyPastel6: return UIColor(patternImage: R.image.color_butterfly_pastel6() ?? UIImage())
        case .ButterflyPastel7: return UIColor(patternImage: R.image.color_butterfly_pastel7() ?? UIImage())
        case .ButterflyPastel8: return UIColor(patternImage: R.image.color_butterfly_pastel8() ?? UIImage())
        case .ButterflyPastel9: return UIColor(patternImage: R.image.color_butterfly_pastel9() ?? UIImage())
        case .ButterflyPastel10: return UIColor(patternImage: R.image.color_butterfly_pastel10() ?? UIImage())
        case .ButterflyPastel11: return UIColor(patternImage: R.image.color_butterfly_pastel11() ?? UIImage())
        case .ButterflyPastel12: return UIColor(patternImage: R.image.color_butterfly_pastel12() ?? UIImage())
        case .ButterflyPastel13: return UIColor(patternImage: R.image.color_butterfly_pastel13() ?? UIImage())
        case .ButterflyPastel14: return UIColor(patternImage: R.image.color_butterfly_pastel14() ?? UIImage())
        case .ButterflyPastel15: return UIColor(patternImage: R.image.color_butterfly_pastel15() ?? UIImage())
        case .BlingBlingPastel0: return UIColor(patternImage: R.image.color_bling_bling_pastel0() ?? UIImage())
        case .BlingBlingPastel1: return UIColor(patternImage: R.image.color_bling_bling_pastel1() ?? UIImage())
        case .BlingBlingPastel2: return UIColor(patternImage: R.image.color_bling_bling_pastel2() ?? UIImage())
        case .BlingBlingPastel3: return UIColor(patternImage: R.image.color_bling_bling_pastel3() ?? UIImage())
        case .BlingBlingPastel4: return UIColor(patternImage: R.image.color_bling_bling_pastel4() ?? UIImage())
        case .BlingBlingPastel5: return UIColor(patternImage: R.image.color_bling_bling_pastel5() ?? UIImage())
        case .BlingBlingPastel6: return UIColor(patternImage: R.image.color_bling_bling_pastel6() ?? UIImage())
        case .BlingBlingPastel7: return UIColor(patternImage: R.image.color_bling_bling_pastel7() ?? UIImage())
        case .BlingBlingPastel8: return UIColor(patternImage: R.image.color_bling_bling_pastel8() ?? UIImage())
        case .BlingBlingPastel9: return UIColor(patternImage: R.image.color_bling_bling_pastel9() ?? UIImage())
        case .BlingBlingPastel10: return UIColor(patternImage: R.image.color_bling_bling_pastel10() ?? UIImage())
        case .BlingBlingPastel11: return UIColor(patternImage: R.image.color_bling_bling_pastel11() ?? UIImage())
        case .BlingBlingPastel12: return UIColor(patternImage: R.image.color_bling_bling_pastel12() ?? UIImage())
        case .BlingBlingPastel13: return UIColor(patternImage: R.image.color_bling_bling_pastel13() ?? UIImage())
        case .BlingBlingPastel14: return UIColor(patternImage: R.image.color_bling_bling_pastel14() ?? UIImage())
        case .BlingBlingPastel15: return UIColor(patternImage: R.image.color_bling_bling_pastel15() ?? UIImage())
        case .SnowFlakesPastel0: return UIColor(patternImage: R.image.color_snowflakes_pastel0() ?? UIImage())
        case .SnowFlakesPastel1: return UIColor(patternImage: R.image.color_snowflakes_pastel1() ?? UIImage())
        case .SnowFlakesPastel2: return UIColor(patternImage: R.image.color_snowflakes_pastel2() ?? UIImage())
        case .SnowFlakesPastel3: return UIColor(patternImage: R.image.color_snowflakes_pastel3() ?? UIImage())
        case .SnowFlakesPastel4: return UIColor(patternImage: R.image.color_snowflakes_pastel4() ?? UIImage())
        case .SnowFlakesPastel5: return UIColor(patternImage: R.image.color_snowflakes_pastel5() ?? UIImage())
        case .SnowFlakesPastel6: return UIColor(patternImage: R.image.color_snowflakes_pastel6() ?? UIImage())
        case .SnowFlakesPastel7: return UIColor(patternImage: R.image.color_snowflakes_pastel7() ?? UIImage())
        case .SnowFlakesPastel8: return UIColor(patternImage: R.image.color_snowflakes_pastel8() ?? UIImage())
        case .SnowFlakesPastel9: return UIColor(patternImage: R.image.color_snowflakes_pastel9() ?? UIImage())
        case .SnowFlakesPastel10: return UIColor(patternImage: R.image.color_snowflakes_pastel10() ?? UIImage())
        case .SnowFlakesPastel11: return UIColor(patternImage: R.image.color_snowflakes_pastel11() ?? UIImage())
        case .SnowFlakesPastel12: return UIColor(patternImage: R.image.color_snowflakes_pastel12() ?? UIImage())
        case .SnowFlakesPastel13: return UIColor(patternImage: R.image.color_snowflakes_pastel13() ?? UIImage())
        case .SnowFlakesPastel14: return UIColor(patternImage: R.image.color_snowflakes_pastel14() ?? UIImage())
        case .SnowFlakesPastel15: return UIColor(patternImage: R.image.color_snowflakes_pastel15() ?? UIImage())
        case .Bling3Pastel0: return UIColor(patternImage: R.image.color_bling3_pastel0() ?? UIImage())
        case .Bling3Pastel1: return UIColor(patternImage: R.image.color_bling3_pastel1() ?? UIImage())
        case .Bling3Pastel2: return UIColor(patternImage: R.image.color_bling3_pastel2() ?? UIImage())
        case .Bling3Pastel3: return UIColor(patternImage: R.image.color_bling3_pastel3() ?? UIImage())
        case .Bling3Pastel4: return UIColor(patternImage: R.image.color_bling3_pastel4() ?? UIImage())
        case .Bling3Pastel5: return UIColor(patternImage: R.image.color_bling3_pastel5() ?? UIImage())
        case .Bling3Pastel6: return UIColor(patternImage: R.image.color_bling3_pastel6() ?? UIImage())
        case .Bling3Pastel7: return UIColor(patternImage: R.image.color_bling3_pastel7() ?? UIImage())
        case .Bling3Pastel8: return UIColor(patternImage: R.image.color_bling3_pastel8() ?? UIImage())
        case .Bling3Pastel9: return UIColor(patternImage: R.image.color_bling3_pastel9() ?? UIImage())
        case .Bling3Pastel10: return UIColor(patternImage: R.image.color_bling3_pastel10() ?? UIImage())
        case .Bling3Pastel11: return UIColor(patternImage: R.image.color_bling3_pastel11() ?? UIImage())
        case .Bling3Pastel12: return UIColor(patternImage: R.image.color_bling3_pastel12() ?? UIImage())
        case .Bling3Pastel13: return UIColor(patternImage: R.image.color_bling3_pastel13() ?? UIImage())
        case .Bling3Pastel14: return UIColor(patternImage: R.image.color_bling3_pastel14() ?? UIImage())
        case .Bling3Pastel15: return UIColor(patternImage: R.image.color_bling3_pastel5() ?? UIImage())
        case .BubblePastel0: return UIColor(patternImage: R.image.color_bubble_pastel0() ?? UIImage())
        case .BubblePastel1: return UIColor(patternImage: R.image.color_bubble_pastel1() ?? UIImage())
        case .BubblePastel2: return UIColor(patternImage: R.image.color_bubble_pastel2() ?? UIImage())
        case .BubblePastel3: return UIColor(patternImage: R.image.color_bubble_pastel3() ?? UIImage())
        case .BubblePastel4: return UIColor(patternImage: R.image.color_bubble_pastel4() ?? UIImage())
        case .BubblePastel5: return UIColor(patternImage: R.image.color_bubble_pastel5() ?? UIImage())
        case .BubblePastel6: return UIColor(patternImage: R.image.color_bubble_pastel6() ?? UIImage())
        case .BubblePastel7: return UIColor(patternImage: R.image.color_bubble_pastel7() ?? UIImage())
        case .BubblePastel8: return UIColor(patternImage: R.image.color_bubble_pastel8() ?? UIImage())
        case .BubblePastel9: return UIColor(patternImage: R.image.color_bubble_pastel9() ?? UIImage())
        case .BubblePastel10: return UIColor(patternImage: R.image.color_bubble_pastel10() ?? UIImage())
        case .BubblePastel11: return UIColor(patternImage: R.image.color_bubble_pastel11() ?? UIImage())
        case .BubblePastel12: return UIColor(patternImage: R.image.color_bubble_pastel12() ?? UIImage())
        case .BubblePastel13: return UIColor(patternImage: R.image.color_bubble_pastel13() ?? UIImage())
        case .BubblePastel14: return UIColor(patternImage: R.image.color_bubble_pastel14() ?? UIImage())
        case .BubblePastel15: return UIColor(patternImage: R.image.color_bubble_pastel15() ?? UIImage())
        case .SnowPastel0: return UIColor(patternImage: R.image.color_snow_pastel0() ?? UIImage())
        case .SnowPastel1: return UIColor(patternImage: R.image.color_snow_pastel1() ?? UIImage())
        case .SnowPastel2: return UIColor(patternImage: R.image.color_snow_pastel2() ?? UIImage())
        case .SnowPastel3: return UIColor(patternImage: R.image.color_snow_pastel3() ?? UIImage())
        case .SnowPastel4: return UIColor(patternImage: R.image.color_snow_pastel4() ?? UIImage())
        case .SnowPastel5: return UIColor(patternImage: R.image.color_snow_pastel5() ?? UIImage())
        case .SnowPastel6: return UIColor(patternImage: R.image.color_snow_pastel6() ?? UIImage())
        case .SnowPastel7: return UIColor(patternImage: R.image.color_snow_pastel7() ?? UIImage())
        case .SnowPastel8: return UIColor(patternImage: R.image.color_snow_pastel8() ?? UIImage())
        case .SnowPastel9: return UIColor(patternImage: R.image.color_snow_pastel9() ?? UIImage())
        case .SnowPastel10: return UIColor(patternImage: R.image.color_snow_pastel10() ?? UIImage())
        case .SnowPastel11: return UIColor(patternImage: R.image.color_snow_pastel11() ?? UIImage())
        case .SnowPastel12: return UIColor(patternImage: R.image.color_snow_pastel12() ?? UIImage())
        case .SnowPastel13: return UIColor(patternImage: R.image.color_snow_pastel13() ?? UIImage())
        case .SnowPastel14: return UIColor(patternImage: R.image.color_snow_pastel14() ?? UIImage())
        case .SnowPastel15: return UIColor(patternImage: R.image.color_snow_pastel15() ?? UIImage())
        case .BlingSweet0: return UIColor(patternImage: R.image.color_bling_sweet0() ?? UIImage())
        case .BlingSweet1: return UIColor(patternImage: R.image.color_bling_sweet1() ?? UIImage())
        case .BlingSweet2: return UIColor(patternImage: R.image.color_bling_sweet2() ?? UIImage())
        case .BlingSweet3: return UIColor(patternImage: R.image.color_bling_sweet3() ?? UIImage())
        case .BlingSweet4: return UIColor(patternImage: R.image.color_bling_sweet4() ?? UIImage())
        case .BlingSweet5: return UIColor(patternImage: R.image.color_bling_sweet5() ?? UIImage())
        case .BlingSweet6: return UIColor(patternImage: R.image.color_bling_sweet6() ?? UIImage())
        case .BlingSweet7: return UIColor(patternImage: R.image.color_bling_sweet7() ?? UIImage())
        case .BlingSweet8: return UIColor(patternImage: R.image.color_bling_sweet8() ?? UIImage())
        case .BlingSweet9: return UIColor(patternImage: R.image.color_bling_sweet9() ?? UIImage())
        case .BlingSweet10: return UIColor(patternImage: R.image.color_bling_sweet10() ?? UIImage())
        case .BlingSweet11: return UIColor(patternImage: R.image.color_bling_sweet11() ?? UIImage())
        case .BlingSweet12: return UIColor(patternImage: R.image.color_bling_sweet12() ?? UIImage())
        case .BlingSweet13: return UIColor(patternImage: R.image.color_bling_sweet13() ?? UIImage())
        case .BlingSweet14: return UIColor(patternImage: R.image.color_bling_sweet14() ?? UIImage())
        case .BlingSweet15: return UIColor(patternImage: R.image.color_bling_sweet15() ?? UIImage())
        case .ButterflySweet0: return UIColor(patternImage: R.image.color_butterfly_sweet0() ?? UIImage())
        case .ButterflySweet1: return UIColor(patternImage: R.image.color_butterfly_sweet1() ?? UIImage())
        case .ButterflySweet2: return UIColor(patternImage: R.image.color_butterfly_sweet2() ?? UIImage())
        case .ButterflySweet3: return UIColor(patternImage: R.image.color_butterfly_sweet3() ?? UIImage())
        case .ButterflySweet4: return UIColor(patternImage: R.image.color_butterfly_sweet4() ?? UIImage())
        case .ButterflySweet5: return UIColor(patternImage: R.image.color_butterfly_sweet5() ?? UIImage())
        case .ButterflySweet6: return UIColor(patternImage: R.image.color_butterfly_sweet6() ?? UIImage())
        case .ButterflySweet7: return UIColor(patternImage: R.image.color_butterfly_sweet7() ?? UIImage())
        case .ButterflySweet8: return UIColor(patternImage: R.image.color_butterfly_sweet8() ?? UIImage())
        case .ButterflySweet9: return UIColor(patternImage: R.image.color_butterfly_sweet9() ?? UIImage())
        case .ButterflySweet10: return UIColor(patternImage: R.image.color_butterfly_sweet10() ?? UIImage())
        case .ButterflySweet11: return UIColor(patternImage: R.image.color_butterfly_sweet11() ?? UIImage())
        case .ButterflySweet12: return UIColor(patternImage: R.image.color_butterfly_sweet12() ?? UIImage())
        case .ButterflySweet13: return UIColor(patternImage: R.image.color_butterfly_sweet13() ?? UIImage())
        case .ButterflySweet14: return UIColor(patternImage: R.image.color_butterfly_sweet14() ?? UIImage())
        case .ButterflySweet15: return UIColor(patternImage: R.image.color_butterfly_sweet15() ?? UIImage())
        case .BlingBlingSweet0: return UIColor(patternImage: R.image.color_bling_bling_sweet0() ?? UIImage())
        case .BlingBlingSweet1: return UIColor(patternImage: R.image.color_bling_bling_sweet1() ?? UIImage())
        case .BlingBlingSweet2: return UIColor(patternImage: R.image.color_bling_bling_sweet2() ?? UIImage())
        case .BlingBlingSweet3: return UIColor(patternImage: R.image.color_bling_bling_sweet3() ?? UIImage())
        case .BlingBlingSweet4: return UIColor(patternImage: R.image.color_bling_bling_sweet4() ?? UIImage())
        case .BlingBlingSweet5: return UIColor(patternImage: R.image.color_bling_bling_sweet5() ?? UIImage())
        case .BlingBlingSweet6: return UIColor(patternImage: R.image.color_bling_bling_sweet6() ?? UIImage())
        case .BlingBlingSweet7: return UIColor(patternImage: R.image.color_bling_bling_sweet7() ?? UIImage())
        case .BlingBlingSweet8: return UIColor(patternImage: R.image.color_bling_bling_sweet8() ?? UIImage())
        case .BlingBlingSweet9: return UIColor(patternImage: R.image.color_bling_bling_sweet9() ?? UIImage())
        case .BlingBlingSweet10: return UIColor(patternImage: R.image.color_bling_bling_sweet10() ?? UIImage())
        case .BlingBlingSweet11: return UIColor(patternImage: R.image.color_bling_bling_sweet11() ?? UIImage())
        case .BlingBlingSweet12: return UIColor(patternImage: R.image.color_bling_bling_sweet12() ?? UIImage())
        case .BlingBlingSweet13: return UIColor(patternImage: R.image.color_bling_bling_sweet13() ?? UIImage())
        case .BlingBlingSweet14: return UIColor(patternImage: R.image.color_bling_bling_sweet14() ?? UIImage())
        case .BlingBlingSweet15: return UIColor(patternImage: R.image.color_bling_bling_sweet15() ?? UIImage())
        case .SnowFlakesSweet0: return UIColor(patternImage: R.image.color_snowflakes_sweet0() ?? UIImage())
        case .SnowFlakesSweet1: return UIColor(patternImage: R.image.color_snowflakes_sweet1() ?? UIImage())
        case .SnowFlakesSweet2: return UIColor(patternImage: R.image.color_snowflakes_sweet2() ?? UIImage())
        case .SnowFlakesSweet3: return UIColor(patternImage: R.image.color_snowflakes_sweet3() ?? UIImage())
        case .SnowFlakesSweet4: return UIColor(patternImage: R.image.color_snowflakes_sweet4() ?? UIImage())
        case .SnowFlakesSweet5: return UIColor(patternImage: R.image.color_snowflakes_sweet5() ?? UIImage())
        case .SnowFlakesSweet6: return UIColor(patternImage: R.image.color_snowflakes_sweet6() ?? UIImage())
        case .SnowFlakesSweet7: return UIColor(patternImage: R.image.color_snowflakes_sweet7() ?? UIImage())
        case .SnowFlakesSweet8: return UIColor(patternImage: R.image.color_snowflakes_sweet8() ?? UIImage())
        case .SnowFlakesSweet9: return UIColor(patternImage: R.image.color_snowflakes_sweet9() ?? UIImage())
        case .SnowFlakesSweet10: return UIColor(patternImage: R.image.color_snowflakes_sweet10() ?? UIImage())
        case .SnowFlakesSweet11: return UIColor(patternImage: R.image.color_snowflakes_sweet11() ?? UIImage())
        case .SnowFlakesSweet12: return UIColor(patternImage: R.image.color_snowflakes_sweet12() ?? UIImage())
        case .SnowFlakesSweet13: return UIColor(patternImage: R.image.color_snowflakes_sweet13() ?? UIImage())
        case .SnowFlakesSweet14: return UIColor(patternImage: R.image.color_snowflakes_sweet14() ?? UIImage())
        case .SnowFlakesSweet15: return UIColor(patternImage: R.image.color_snowflakes_sweet15() ?? UIImage())
        case .Bling3Sweet0: return UIColor(patternImage: R.image.color_bling3_sweet0() ?? UIImage())
        case .Bling3Sweet1: return UIColor(patternImage: R.image.color_bling3_sweet1() ?? UIImage())
        case .Bling3Sweet2: return UIColor(patternImage: R.image.color_bling3_sweet2() ?? UIImage())
        case .Bling3Sweet3: return UIColor(patternImage: R.image.color_bling3_sweet3() ?? UIImage())
        case .Bling3Sweet4: return UIColor(patternImage: R.image.color_bling3_sweet4() ?? UIImage())
        case .Bling3Sweet5: return UIColor(patternImage: R.image.color_bling3_sweet5() ?? UIImage())
        case .Bling3Sweet6: return UIColor(patternImage: R.image.color_bling3_sweet6() ?? UIImage())
        case .Bling3Sweet7: return UIColor(patternImage: R.image.color_bling3_sweet7() ?? UIImage())
        case .Bling3Sweet8: return UIColor(patternImage: R.image.color_bling3_sweet8() ?? UIImage())
        case .Bling3Sweet9: return UIColor(patternImage: R.image.color_bling3_sweet9() ?? UIImage())
        case .Bling3Sweet10: return UIColor(patternImage: R.image.color_bling3_sweet10() ?? UIImage())
        case .Bling3Sweet11: return UIColor(patternImage: R.image.color_bling3_sweet11() ?? UIImage())
        case .Bling3Sweet12: return UIColor(patternImage: R.image.color_bling3_sweet12() ?? UIImage())
        case .Bling3Sweet13: return UIColor(patternImage: R.image.color_bling3_sweet13() ?? UIImage())
        case .Bling3Sweet14: return UIColor(patternImage: R.image.color_bling3_sweet14() ?? UIImage())
        case .Bling3Sweet15: return UIColor(patternImage: R.image.color_bling3_sweet15() ?? UIImage())
        case .BubbleSweet0: return UIColor(patternImage: R.image.color_bubble_sweet0() ?? UIImage())
        case .BubbleSweet1: return UIColor(patternImage: R.image.color_bubble_sweet1() ?? UIImage())
        case .BubbleSweet2: return UIColor(patternImage: R.image.color_bubble_sweet2() ?? UIImage())
        case .BubbleSweet3: return UIColor(patternImage: R.image.color_bubble_sweet3() ?? UIImage())
        case .BubbleSweet4: return UIColor(patternImage: R.image.color_bubble_sweet4() ?? UIImage())
        case .BubbleSweet5: return UIColor(patternImage: R.image.color_bubble_sweet5() ?? UIImage())
        case .BubbleSweet6: return UIColor(patternImage: R.image.color_bubble_sweet6() ?? UIImage())
        case .BubbleSweet7: return UIColor(patternImage: R.image.color_bubble_sweet7() ?? UIImage())
        case .BubbleSweet8: return UIColor(patternImage: R.image.color_bubble_sweet8() ?? UIImage())
        case .BubbleSweet9: return UIColor(patternImage: R.image.color_bubble_sweet9() ?? UIImage())
        case .BubbleSweet10: return UIColor(patternImage: R.image.color_bubble_sweet10() ?? UIImage())
        case .BubbleSweet11: return UIColor(patternImage: R.image.color_bubble_sweet11() ?? UIImage())
        case .BubbleSweet12: return UIColor(patternImage: R.image.color_bubble_sweet12() ?? UIImage())
        case .BubbleSweet13: return UIColor(patternImage: R.image.color_bubble_sweet13() ?? UIImage())
        case .BubbleSweet14: return UIColor(patternImage: R.image.color_bubble_sweet14() ?? UIImage())
        case .BubbleSweet15: return UIColor(patternImage: R.image.color_bubble_sweet15() ?? UIImage())
        case .SnowSweet0: return UIColor(patternImage: R.image.color_snow_sweet0() ?? UIImage())
        case .SnowSweet1: return UIColor(patternImage: R.image.color_snow_sweet1() ?? UIImage())
        case .SnowSweet2: return UIColor(patternImage: R.image.color_snow_sweet2() ?? UIImage())
        case .SnowSweet3: return UIColor(patternImage: R.image.color_snow_sweet3() ?? UIImage())
        case .SnowSweet4: return UIColor(patternImage: R.image.color_snow_sweet4() ?? UIImage())
        case .SnowSweet5: return UIColor(patternImage: R.image.color_snow_sweet5() ?? UIImage())
        case .SnowSweet6: return UIColor(patternImage: R.image.color_snow_sweet6() ?? UIImage())
        case .SnowSweet7: return UIColor(patternImage: R.image.color_snow_sweet7() ?? UIImage())
        case .SnowSweet8: return UIColor(patternImage: R.image.color_snow_sweet8() ?? UIImage())
        case .SnowSweet9: return UIColor(patternImage: R.image.color_snow_sweet9() ?? UIImage())
        case .SnowSweet10: return UIColor(patternImage: R.image.color_snow_sweet10() ?? UIImage())
        case .SnowSweet11: return UIColor(patternImage: R.image.color_snow_sweet11() ?? UIImage())
        case .SnowSweet12: return UIColor(patternImage: R.image.color_snow_sweet12() ?? UIImage())
        case .SnowSweet13: return UIColor(patternImage: R.image.color_snow_sweet13() ?? UIImage())
        case .SnowSweet14: return UIColor(patternImage: R.image.color_snow_sweet14() ?? UIImage())
        case .SnowSweet15: return UIColor(patternImage: R.image.color_snow_sweet15() ?? UIImage())
        case .BlingMystical0: return UIColor(patternImage: R.image.color_bling_mystical0() ?? UIImage())
        case .BlingMystical1: return UIColor(patternImage: R.image.color_bling_mystical1() ?? UIImage())
        case .BlingMystical2: return UIColor(patternImage: R.image.color_bling_mystical2() ?? UIImage())
        case .BlingMystical3: return UIColor(patternImage: R.image.color_bling_mystical3() ?? UIImage())
        case .BlingMystical4: return UIColor(patternImage: R.image.color_bling_mystical4() ?? UIImage())
        case .BlingMystical5: return UIColor(patternImage: R.image.color_bling_mystical5() ?? UIImage())
        case .BlingMystical6: return UIColor(patternImage: R.image.color_bling_mystical6() ?? UIImage())
        case .BlingMystical7: return UIColor(patternImage: R.image.color_bling_mystical7() ?? UIImage())
        case .BlingMystical8: return UIColor(patternImage: R.image.color_bling_mystical8() ?? UIImage())
        case .BlingMystical9: return UIColor(patternImage: R.image.color_bling_mystical9() ?? UIImage())
        case .BlingMystical10: return UIColor(patternImage: R.image.color_bling_mystical10() ?? UIImage())
        case .BlingMystical11: return UIColor(patternImage: R.image.color_bling_mystical11() ?? UIImage())
        case .BlingMystical12: return UIColor(patternImage: R.image.color_bling_mystical12() ?? UIImage())
        case .BlingMystical13: return UIColor(patternImage: R.image.color_bling_mystical13() ?? UIImage())
        case .BlingMystical14: return UIColor(patternImage: R.image.color_bling_mystical14() ?? UIImage())
        case .BlingMystical15: return UIColor(patternImage: R.image.color_bling_mystical15() ?? UIImage())
        case .ButterflyMystical0: return UIColor(patternImage: R.image.color_butterfly_mystical0() ?? UIImage())
        case .ButterflyMystical1: return UIColor(patternImage: R.image.color_butterfly_mystical1() ?? UIImage())
        case .ButterflyMystical2: return UIColor(patternImage: R.image.color_butterfly_mystical2() ?? UIImage())
        case .ButterflyMystical3: return UIColor(patternImage: R.image.color_butterfly_mystical3() ?? UIImage())
        case .ButterflyMystical4: return UIColor(patternImage: R.image.color_butterfly_mystical4() ?? UIImage())
        case .ButterflyMystical5: return UIColor(patternImage: R.image.color_butterfly_mystical5() ?? UIImage())
        case .ButterflyMystical6: return UIColor(patternImage: R.image.color_butterfly_mystical6() ?? UIImage())
        case .ButterflyMystical7: return UIColor(patternImage: R.image.color_butterfly_mystical7() ?? UIImage())
        case .ButterflyMystical8: return UIColor(patternImage: R.image.color_butterfly_mystical8() ?? UIImage())
        case .ButterflyMystical9: return UIColor(patternImage: R.image.color_butterfly_mystical9() ?? UIImage())
        case .ButterflyMystical10: return UIColor(patternImage: R.image.color_butterfly_mystical10() ?? UIImage())
        case .ButterflyMystical11: return UIColor(patternImage: R.image.color_butterfly_mystical11() ?? UIImage())
        case .ButterflyMystical12: return UIColor(patternImage: R.image.color_butterfly_mystical12() ?? UIImage())
        case .ButterflyMystical13: return UIColor(patternImage: R.image.color_butterfly_mystical13() ?? UIImage())
        case .ButterflyMystical14: return UIColor(patternImage: R.image.color_butterfly_mystical14() ?? UIImage())
        case .ButterflyMystical15: return UIColor(patternImage: R.image.color_butterfly_mystical15() ?? UIImage())
        case .BlingBlingMystical0: return UIColor(patternImage: R.image.color_bling_bling_sweet0() ?? UIImage())
        case .BlingBlingMystical1: return UIColor(patternImage: R.image.color_bling_bling_sweet1() ?? UIImage())
        case .BlingBlingMystical2: return UIColor(patternImage: R.image.color_bling_bling_sweet2() ?? UIImage())
        case .BlingBlingMystical3: return UIColor(patternImage: R.image.color_bling_bling_sweet3() ?? UIImage())
        case .BlingBlingMystical4: return UIColor(patternImage: R.image.color_bling_bling_sweet4() ?? UIImage())
        case .BlingBlingMystical5: return UIColor(patternImage: R.image.color_bling_bling_sweet5() ?? UIImage())
        case .BlingBlingMystical6: return UIColor(patternImage: R.image.color_bling_bling_sweet6() ?? UIImage())
        case .BlingBlingMystical7: return UIColor(patternImage: R.image.color_bling_bling_sweet7() ?? UIImage())
        case .BlingBlingMystical8: return UIColor(patternImage: R.image.color_bling_bling_sweet8() ?? UIImage())
        case .BlingBlingMystical9: return UIColor(patternImage: R.image.color_bling_bling_sweet9() ?? UIImage())
        case .BlingBlingMystical10: return UIColor(patternImage: R.image.color_bling_bling_sweet10() ?? UIImage())
        case .BlingBlingMystical11: return UIColor(patternImage: R.image.color_bling_bling_sweet11() ?? UIImage())
        case .BlingBlingMystical12: return UIColor(patternImage: R.image.color_bling_bling_sweet12() ?? UIImage())
        case .BlingBlingMystical13: return UIColor(patternImage: R.image.color_bling_bling_sweet13() ?? UIImage())
        case .BlingBlingMystical14: return UIColor(patternImage: R.image.color_bling_bling_sweet14() ?? UIImage())
        case .BlingBlingMystical15: return UIColor(patternImage: R.image.color_bling_bling_sweet15() ?? UIImage())
        case .SnowFlakesMystical0: return UIColor(patternImage: R.image.color_snowflakes_mystical0() ?? UIImage())
        case .SnowFlakesMystical1: return UIColor(patternImage: R.image.color_snowflakes_mystical1() ?? UIImage())
        case .SnowFlakesMystical2: return UIColor(patternImage: R.image.color_snowflakes_mystical2() ?? UIImage())
        case .SnowFlakesMystical3: return UIColor(patternImage: R.image.color_snowflakes_mystical3() ?? UIImage())
        case .SnowFlakesMystical4: return UIColor(patternImage: R.image.color_snowflakes_mystical4() ?? UIImage())
        case .SnowFlakesMystical5: return UIColor(patternImage: R.image.color_snowflakes_mystical5() ?? UIImage())
        case .SnowFlakesMystical6: return UIColor(patternImage: R.image.color_snowflakes_mystical6() ?? UIImage())
        case .SnowFlakesMystical7: return UIColor(patternImage: R.image.color_snowflakes_mystical7() ?? UIImage())
        case .SnowFlakesMystical8: return UIColor(patternImage: R.image.color_snowflakes_mystical8() ?? UIImage())
        case .SnowFlakesMystical9: return UIColor(patternImage: R.image.color_snowflakes_mystical9() ?? UIImage())
        case .SnowFlakesMystical10: return UIColor(patternImage: R.image.color_snowflakes_mystical10() ?? UIImage())
        case .SnowFlakesMystical11: return UIColor(patternImage: R.image.color_snowflakes_mystical11() ?? UIImage())
        case .SnowFlakesMystical12: return UIColor(patternImage: R.image.color_snowflakes_mystical12() ?? UIImage())
        case .SnowFlakesMystical13: return UIColor(patternImage: R.image.color_snowflakes_mystical13() ?? UIImage())
        case .SnowFlakesMystical14: return UIColor(patternImage: R.image.color_snowflakes_mystical14() ?? UIImage())
        case .SnowFlakesMystical15: return UIColor(patternImage: R.image.color_snowflakes_mystical15() ?? UIImage())
        case .Bling3Mystical0: return UIColor(patternImage: R.image.color_bling3_mystical0() ?? UIImage())
        case .Bling3Mystical1: return UIColor(patternImage: R.image.color_bling3_mystical1() ?? UIImage())
        case .Bling3Mystical2: return UIColor(patternImage: R.image.color_bling3_mystical2() ?? UIImage())
        case .Bling3Mystical3: return UIColor(patternImage: R.image.color_bling3_mystical3() ?? UIImage())
        case .Bling3Mystical4: return UIColor(patternImage: R.image.color_bling3_mystical4() ?? UIImage())
        case .Bling3Mystical5: return UIColor(patternImage: R.image.color_bling3_mystical5() ?? UIImage())
        case .Bling3Mystical6: return UIColor(patternImage: R.image.color_bling3_mystical6() ?? UIImage())
        case .Bling3Mystical7: return UIColor(patternImage: R.image.color_bling3_mystical7() ?? UIImage())
        case .Bling3Mystical8: return UIColor(patternImage: R.image.color_bling3_mystical8() ?? UIImage())
        case .Bling3Mystical9: return UIColor(patternImage: R.image.color_bling3_mystical9() ?? UIImage())
        case .Bling3Mystical10: return UIColor(patternImage: R.image.color_bling3_mystical10() ?? UIImage())
        case .Bling3Mystical11: return UIColor(patternImage: R.image.color_bling3_mystical11() ?? UIImage())
        case .Bling3Mystical12: return UIColor(patternImage: R.image.color_bling3_mystical12() ?? UIImage())
        case .Bling3Mystical13: return UIColor(patternImage: R.image.color_bling3_mystical13() ?? UIImage())
        case .Bling3Mystical14: return UIColor(patternImage: R.image.color_bling3_mystical14() ?? UIImage())
        case .Bling3Mystical15: return UIColor(patternImage: R.image.color_bling3_mystical15() ?? UIImage())
        case .BubbleMystical0: return UIColor(patternImage: R.image.color_bubble_mystical0() ?? UIImage())
        case .BubbleMystical1: return UIColor(patternImage: R.image.color_bubble_mystical1() ?? UIImage())
        case .BubbleMystical2: return UIColor(patternImage: R.image.color_bubble_mystical2() ?? UIImage())
        case .BubbleMystical3: return UIColor(patternImage: R.image.color_bubble_mystical3() ?? UIImage())
        case .BubbleMystical4: return UIColor(patternImage: R.image.color_bubble_mystical4() ?? UIImage())
        case .BubbleMystical5: return UIColor(patternImage: R.image.color_bubble_mystical5() ?? UIImage())
        case .BubbleMystical6: return UIColor(patternImage: R.image.color_bubble_mystical6() ?? UIImage())
        case .BubbleMystical7: return UIColor(patternImage: R.image.color_bubble_mystical7() ?? UIImage())
        case .BubbleMystical8: return UIColor(patternImage: R.image.color_bubble_mystical8() ?? UIImage())
        case .BubbleMystical9: return UIColor(patternImage: R.image.color_bubble_mystical9() ?? UIImage())
        case .BubbleMystical10: return UIColor(patternImage: R.image.color_bubble_mystical10() ?? UIImage())
        case .BubbleMystical11: return UIColor(patternImage: R.image.color_bubble_mystical11() ?? UIImage())
        case .BubbleMystical12: return UIColor(patternImage: R.image.color_bubble_mystical12() ?? UIImage())
        case .BubbleMystical13: return UIColor(patternImage: R.image.color_bubble_mystical13() ?? UIImage())
        case .BubbleMystical14: return UIColor(patternImage: R.image.color_bubble_mystical14() ?? UIImage())
        case .BubbleMystical15: return UIColor(patternImage: R.image.color_bubble_mystical15() ?? UIImage())
        case .SnowMystical0: return UIColor(patternImage: R.image.color_snow_mystical0() ?? UIImage())
        case .SnowMystical1: return UIColor(patternImage: R.image.color_snow_mystical1() ?? UIImage())
        case .SnowMystical2: return UIColor(patternImage: R.image.color_snow_mystical2() ?? UIImage())
        case .SnowMystical3: return UIColor(patternImage: R.image.color_snow_mystical3() ?? UIImage())
        case .SnowMystical4: return UIColor(patternImage: R.image.color_snow_mystical4() ?? UIImage())
        case .SnowMystical5: return UIColor(patternImage: R.image.color_snow_mystical5() ?? UIImage())
        case .SnowMystical6: return UIColor(patternImage: R.image.color_snow_mystical6() ?? UIImage())
        case .SnowMystical7: return UIColor(patternImage: R.image.color_snow_mystical7() ?? UIImage())
        case .SnowMystical8: return UIColor(patternImage: R.image.color_snow_mystical8() ?? UIImage())
        case .SnowMystical9: return UIColor(patternImage: R.image.color_snow_mystical9() ?? UIImage())
        case .SnowMystical10: return UIColor(patternImage: R.image.color_snow_mystical10() ?? UIImage())
        case .SnowMystical11: return UIColor(patternImage: R.image.color_snow_mystical11() ?? UIImage())
        case .SnowMystical12: return UIColor(patternImage: R.image.color_snow_mystical12() ?? UIImage())
        case .SnowMystical13: return UIColor(patternImage: R.image.color_snow_mystical13() ?? UIImage())
        case .SnowMystical14: return UIColor(patternImage: R.image.color_snow_mystical14() ?? UIImage())
        case .SnowMystical15: return UIColor(patternImage: R.image.color_snow_mystical15() ?? UIImage())
        }
    }
}



