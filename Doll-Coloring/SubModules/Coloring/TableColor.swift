//
//  TableColor.swift
//  Doll-Coloring
//
//  Created by Việt Anh Nguyễn on 11/4/24.
//

import Foundation

struct ListColorIpad {
    var table_name: String?
    var listColor: [[ItemColor?]]
}

struct ItemColor {
    var isPremium: Bool = true
    var tableName: String?
    var hex: String?
    var color: UIColor?
    var name: String?
}

enum BannerHome {
    case iphone
    case ipad
    case iap
    
    var images: [String] {
        switch self {
        case .iphone:
            return ["banner2_IP", "banner1_IP", "banner3_IP"]
        case .ipad:
            return ["banner2_Ipad", "banner1_Ipad", "banner3_ipad"]
        case .iap:
            return ["Banner_IAP0", "Banner_IAP1", "Banner_IAP2", "Banner_IAP3", "Banner_IAP4"]
        }
    }
}

enum PalettesColor: String{
    case Texture = "Texture"
    case Plain = "Plain"
    
    var palettes: [TableColor] {
        switch self {
        case .Texture:
            return [.Bling, .Butterfly, .BlingBling, .SnowFlakes, .Bling3, .Bubble, .Snow]
        case .Plain:
            return [.Neon, .Vintage, .Warm, .Summer, .Cold, .Happy, .Basic_Color, .Hot_Color, .Skin_Color, .Vivid_Color, .Natural_Color, .Sky_Color, .Purple_Color]
        }
    }
    
    var icon: UIImage? {
        switch self {
        case .Texture:
            return R.image.blingbling_palettes()
        case .Plain:
            return R.image.color_palettes()
        }
    }
}


enum TableColor: CaseIterable {
    
    case Bling
    case Butterfly
    case BlingBling
    case SnowFlakes
    case Bling3
    case Bubble
    case Snow
    case Vintage
    case Neon
    case Warm
    case Summer
    case Cold
    case Happy
    case Basic_Color
    case Skin_Color
    case Vivid_Color
    case Hot_Color
    case Natural_Color
    case Sky_Color
    case Purple_Color
    
    var title: String {
        switch self {
        case .Vintage:
            return "Vintage"
        case .Neon:
            return "Neon"
        case .Warm:
            return "Warm"
        case .Summer:
            return "Summer"
        case .Cold:
            return "Cold"
        case .Basic_Color:
            return "Basic_Color"
        case .Skin_Color:
            return "Skin_Color"
        case .Vivid_Color:
            return "Vivid_Color"
        case .Hot_Color:
            return "Hot_Color"
        case .Natural_Color:
            return "Natural_Color"
        case .Sky_Color:
            return "Sky_Color"
        case .Purple_Color:
            return "Purple_Color"
        case .Bling:
            return "Bling"
        case .Butterfly:
            return "Butterfly"
        case .BlingBling:
            return "BlingBling"
        case .SnowFlakes:
            return "SnowFlakes"
        case .Bling3:
            return "Bling3"
        case .Bubble:
            return "Bubbl"
        case .Snow:
            return "Snow"
        case .Happy:
            return "Happy"
        }
    }
    
    var listColor: [[ItemColor]] {
        switch self {
        case .Basic_Color:
            return [ItemThemeColor.Basic_Color.itemColors]
        case .Skin_Color:
            return [ItemThemeColor.Skin_Color.itemColors]
        case .Vivid_Color:
            return [ItemThemeColor.Vivid_Color.itemColors]
        case .Hot_Color:
            return [ItemThemeColor.Hot_Color.itemColors]
        case .Natural_Color:
            return [ItemThemeColor.Natural_Color.itemColors]
        case .Sky_Color:
            return [ItemThemeColor.Sky_Color.itemColors]
        case .Purple_Color:
            return [ItemThemeColor.Purple_Color.itemColors]
        case .Bling:
            return [ItemThemeColor.BlingSweet.itemColors,
                    ItemThemeColor.BlingPastel.itemColors,
                    ItemThemeColor.BlingMystical.itemColors]
        case .Butterfly:
            return [ItemThemeColor.ButterflySweet.itemColors,
                    ItemThemeColor.ButterflyPastel.itemColors,
                    ItemThemeColor.ButterflyMystical.itemColors]
        case .BlingBling:
            return [ItemThemeColor.BlingBlingSweet.itemColors,
                    ItemThemeColor.BlingBlingPastel.itemColors,
                    ItemThemeColor.BlingBlingMystical.itemColors]
        case .SnowFlakes:
            return [ItemThemeColor.SnowFlakesSweet.itemColors,
                    ItemThemeColor.SnowFlakesPastel.itemColors,
                    ItemThemeColor.SnowFlakesMystical.itemColors]
        case .Bling3:
            return [ItemThemeColor.Bling3Sweet.itemColors,
                    ItemThemeColor.Bling3Pastel.itemColors,
                    ItemThemeColor.Bling3Mystical.itemColors]
        case .Bubble:
            return [ItemThemeColor.BubbleSweet.itemColors,
                    ItemThemeColor.BubblePastel.itemColors,
                    ItemThemeColor.BubbleMystical.itemColors]
        case .Snow:
            return [ItemThemeColor.SnowSweet.itemColors,
                    ItemThemeColor.SnowPastel.itemColors,
                    ItemThemeColor.SnowMystical.itemColors]
        case .Vintage:
            return [ItemThemeColor.Vintage.itemColors]
        case .Neon:
            return [ItemThemeColor.Neon.itemColors]
        case .Warm:
            return [ItemThemeColor.Warm.itemColors]
        case .Summer:
            return [ItemThemeColor.Summer.itemColors]
        case .Cold:
            return [ItemThemeColor.Cold.itemColors]
        case .Happy:
            return [ItemThemeColor.Happy.itemColors]
        }
    }
}

enum ItemThemeColor: CaseIterable {
    case Vintage
    case Neon
    case Warm
    case Summer
    case Cold
    case Happy
    case BlingPastel
    case BlingSweet
    case BlingMystical
    case ButterflyPastel
    case ButterflySweet
    case ButterflyMystical
    case BlingBlingPastel
    case BlingBlingSweet
    case BlingBlingMystical
    case SnowFlakesPastel
    case SnowFlakesSweet
    case SnowFlakesMystical
    case Bling3Pastel
    case Bling3Sweet
    case Bling3Mystical
    case BubblePastel
    case BubbleSweet
    case BubbleMystical
    case SnowPastel
    case SnowSweet
    case SnowMystical
    case Basic_Color
    case Skin_Color
    case Vivid_Color
    case Hot_Color
    case Natural_Color
    case Sky_Color
    case Purple_Color
    case ClearColor
    
    var itemColors: [ItemColor] {
        switch self {
        case .BlingPastel:
            return [ ItemColor(tableName: "Bling Pastel", color: UIColor(patternImage: R.image.color_bling_pastel0() ?? UIImage()), name:"color_bling_pastel0"),
                     ItemColor(tableName: "Bling Pastel", color: UIColor(patternImage: R.image.color_bling_pastel1() ?? UIImage()), name:"color_bling_pastel1"),
                     ItemColor(tableName: "Bling Pastel", color: UIColor(patternImage: R.image.color_bling_pastel2() ?? UIImage()), name:"color_bling_pastel2"),
                     ItemColor(tableName: "Bling Pastel", color: UIColor(patternImage: R.image.color_bling_pastel3() ?? UIImage()), name:"color_bling_pastel3"),
                     ItemColor(tableName: "Bling Pastel", color: UIColor(patternImage: R.image.color_bling_pastel4() ?? UIImage()), name:"color_bling_pastel4"),
                     ItemColor(tableName: "Bling Pastel", color: UIColor(patternImage: R.image.color_bling_pastel5() ?? UIImage()), name:"color_bling_pastel5"),
                     ItemColor(tableName: "Bling Pastel", color: UIColor(patternImage: R.image.color_bling_pastel6() ?? UIImage()), name:"color_bling_pastel6"),
                     ItemColor(tableName: "Bling Pastel", color: UIColor(patternImage: R.image.color_bling_pastel7() ?? UIImage()), name:"color_bling_pastel7"),
                     ItemColor(tableName: "Bling Pastel", color: UIColor(patternImage: R.image.color_bling_pastel8() ?? UIImage()), name:"color_bling_pastel8"),
                     ItemColor(tableName: "Bling Pastel", color: UIColor(patternImage: R.image.color_bling_pastel9() ?? UIImage()), name:"color_bling_pastel9"),
                     ItemColor(tableName: "Bling Pastel", color: UIColor(patternImage: R.image.color_bling_pastel10() ?? UIImage()), name:"color_bling_pastel10"),
                     ItemColor(tableName: "Bling Pastel", color: UIColor(patternImage: R.image.color_bling_pastel11() ?? UIImage()), name:"color_bling_pastel11"),
                     ItemColor(tableName: "Bling Pastel", color: UIColor(patternImage: R.image.color_bling_pastel12() ?? UIImage()), name:"color_bling_pastel12"),
                     ItemColor(tableName: "Bling Pastel", color: UIColor(patternImage: R.image.color_bling_pastel13() ?? UIImage()), name:"color_bling_pastel13"),
                     ItemColor(tableName: "Bling Pastel", color: UIColor(patternImage: R.image.color_bling_pastel14() ?? UIImage()), name:"color_bling_pastel14"),
                     ItemColor(tableName: "Bling Pastel", color: UIColor(patternImage: R.image.color_bling_pastel15() ?? UIImage()), name:"color_bling_pastel15")]
        case .BlingSweet:
            return [ ItemColor(tableName: "Bling Sweet", color: UIColor(patternImage: R.image.color_bling_sweet0() ?? UIImage()), name:"color_bling_sweet0"),
                     ItemColor(tableName: "Bling Sweet", color: UIColor(patternImage: R.image.color_bling_sweet1() ?? UIImage()), name:"color_bling_sweet1"),
                     ItemColor(tableName: "Bling Sweet", color: UIColor(patternImage: R.image.color_bling_sweet2() ?? UIImage()), name:"color_bling_sweet2"),
                     ItemColor(tableName: "Bling Sweet", color: UIColor(patternImage: R.image.color_bling_sweet3() ?? UIImage()), name:"color_bling_sweet3"),
                     ItemColor(tableName: "Bling Sweet", color: UIColor(patternImage: R.image.color_bling_sweet4() ?? UIImage()), name:"color_bling_sweet4"),
                     ItemColor(tableName: "Bling Sweet", color: UIColor(patternImage: R.image.color_bling_sweet5() ?? UIImage()), name:"color_bling_sweet5"),
                     ItemColor(tableName: "Bling Sweet", color: UIColor(patternImage: R.image.color_bling_sweet6() ?? UIImage()), name:"color_bling_sweet6"),
                     ItemColor(tableName: "Bling Sweet", color: UIColor(patternImage: R.image.color_bling_sweet7() ?? UIImage()), name:"color_bling_sweet7"),
                     ItemColor(tableName: "Bling Sweet", color: UIColor(patternImage: R.image.color_bling_sweet8() ?? UIImage()), name:"color_bling_sweet8"),
                     ItemColor(tableName: "Bling Sweet", color: UIColor(patternImage: R.image.color_bling_sweet9() ?? UIImage()), name:"color_bling_sweet9"),
                     ItemColor(tableName: "Bling Sweet", color: UIColor(patternImage: R.image.color_bling_sweet10() ?? UIImage()), name:"color_bling_sweet10"),
                     ItemColor(tableName: "Bling Sweet", color: UIColor(patternImage: R.image.color_bling_sweet11() ?? UIImage()), name:"color_bling_sweet11"),
                     ItemColor(tableName: "Bling Sweet", color: UIColor(patternImage: R.image.color_bling_sweet12() ?? UIImage()), name:"color_bling_sweet12"),
                     ItemColor(tableName: "Bling Sweet", color: UIColor(patternImage: R.image.color_bling_sweet13() ?? UIImage()), name:"color_bling_sweet13"),
                     ItemColor(tableName: "Bling Sweet", color: UIColor(patternImage: R.image.color_bling_sweet14() ?? UIImage()), name:"color_bling_sweet14"),
                     ItemColor(tableName: "Bling Sweet", color: UIColor(patternImage: R.image.color_bling_sweet15() ?? UIImage()), name:"color_bling_sweet15")]
        case .BlingMystical:
            return [ ItemColor(tableName: "Bling Mystical", color: UIColor(patternImage: R.image.color_bling_mystical0() ?? UIImage()), name:"color_bling_mystical0"),
                     ItemColor(tableName: "Bling Mystical", color: UIColor(patternImage: R.image.color_bling_mystical1() ?? UIImage()), name:"color_bling_mystical1"),
                     ItemColor(tableName: "Bling Mystical", color: UIColor(patternImage: R.image.color_bling_mystical2() ?? UIImage()), name:"color_bling_mystical2"),
                     ItemColor(tableName: "Bling Mystical", color: UIColor(patternImage: R.image.color_bling_mystical3() ?? UIImage()), name:"color_bling_mystical3"),
                     ItemColor(tableName: "Bling Mystical", color: UIColor(patternImage: R.image.color_bling_mystical4() ?? UIImage()), name:"color_bling_mystical4"),
                     ItemColor(tableName: "Bling Mystical", color: UIColor(patternImage: R.image.color_bling_mystical5() ?? UIImage()), name:"color_bling_mystical5"),
                     ItemColor(tableName: "Bling Mystical", color: UIColor(patternImage: R.image.color_bling_mystical6() ?? UIImage()), name:"color_bling_mystical6"),
                     ItemColor(tableName: "Bling Mystical", color: UIColor(patternImage: R.image.color_bling_mystical7() ?? UIImage()), name:"color_bling_mystical7"),
                     ItemColor(tableName: "Bling Mystical", color: UIColor(patternImage: R.image.color_bling_mystical8() ?? UIImage()), name:"color_bling_mystical8"),
                     ItemColor(tableName: "Bling Mystical", color: UIColor(patternImage: R.image.color_bling_mystical9() ?? UIImage()), name:"color_bling_mystical9"),
                     ItemColor(tableName: "Bling Mystical", color: UIColor(patternImage: R.image.color_bling_mystical10() ?? UIImage()), name:"color_bling_mystical10"),
                     ItemColor(tableName: "Bling Mystical", color: UIColor(patternImage: R.image.color_bling_mystical11() ?? UIImage()), name:"color_bling_mystical11"),
                     ItemColor(tableName: "Bling Mystical", color: UIColor(patternImage: R.image.color_bling_mystical12() ?? UIImage()), name:"color_bling_mystical12"),
                     ItemColor(tableName: "Bling Mystical", color: UIColor(patternImage: R.image.color_bling_mystical13() ?? UIImage()), name:"color_bling_mystical13"),
                     ItemColor(tableName: "Bling Mystical", color: UIColor(patternImage: R.image.color_bling_mystical14() ?? UIImage()), name:"color_bling_mystical14"),
                     ItemColor(tableName: "Bling Mystical", color: UIColor(patternImage: R.image.color_bling_mystical15() ?? UIImage()), name:"color_bling_mystical15")]
        case .ButterflyPastel:
            return [ ItemColor(tableName: "Butterfly Pastel", color: UIColor(patternImage: R.image.color_butterfly_pastel0() ?? UIImage()), name:"color_butterfly_pastel0"),
                     ItemColor(tableName: "Butterfly Pastel", color: UIColor(patternImage: R.image.color_butterfly_pastel1() ?? UIImage()), name:"color_butterfly_pastel1"),
                     ItemColor(tableName: "Butterfly Pastel", color: UIColor(patternImage: R.image.color_butterfly_pastel2() ?? UIImage()), name:"color_butterfly_pastel2"),
                     ItemColor(tableName: "Butterfly Pastel", color: UIColor(patternImage: R.image.color_butterfly_pastel3() ?? UIImage()), name:"color_butterfly_pastel3"),
                     ItemColor(tableName: "Butterfly Pastel", color: UIColor(patternImage: R.image.color_butterfly_pastel4() ?? UIImage()), name:"color_butterfly_pastel4"),
                     ItemColor(tableName: "Butterfly Pastel", color: UIColor(patternImage: R.image.color_butterfly_pastel5() ?? UIImage()), name:"color_butterfly_pastel5"),
                     ItemColor(tableName: "Butterfly Pastel", color: UIColor(patternImage: R.image.color_butterfly_pastel6() ?? UIImage()), name:"color_butterfly_pastel6"),
                     ItemColor(tableName: "Butterfly Pastel", color: UIColor(patternImage: R.image.color_butterfly_pastel7() ?? UIImage()), name:"color_butterfly_pastel7"),
                     ItemColor(tableName: "Butterfly Pastel", color: UIColor(patternImage: R.image.color_butterfly_pastel8() ?? UIImage()), name:"color_butterfly_pastel8"),
                     ItemColor(tableName: "Butterfly Pastel", color: UIColor(patternImage: R.image.color_butterfly_pastel9() ?? UIImage()), name:"color_butterfly_pastel9"),
                     ItemColor(tableName: "Butterfly Pastel", color: UIColor(patternImage: R.image.color_butterfly_pastel10() ?? UIImage()), name:"color_butterfly_pastel10"),
                     ItemColor(tableName: "Butterfly Pastel", color: UIColor(patternImage: R.image.color_butterfly_pastel11() ?? UIImage()), name:"color_butterfly_pastel11"),
                     ItemColor(tableName: "Butterfly Pastel", color: UIColor(patternImage: R.image.color_butterfly_pastel12() ?? UIImage()), name:"color_butterfly_pastel12"),
                     ItemColor(tableName: "Butterfly Pastel", color: UIColor(patternImage: R.image.color_butterfly_pastel13() ?? UIImage()), name:"color_butterfly_pastel13"),
                     ItemColor(tableName: "Butterfly Pastel", color: UIColor(patternImage: R.image.color_butterfly_pastel14() ?? UIImage()), name:"color_butterfly_pastel14"),
                     ItemColor(tableName: "Butterfly Pastel", color: UIColor(patternImage: R.image.color_butterfly_pastel15() ?? UIImage()), name:"color_butterfly_pastel15")]
        case .ButterflySweet:
            return [ ItemColor(tableName: "Butterfly Sweet", color: UIColor(patternImage: R.image.color_butterfly_sweet0() ?? UIImage()), name:"color_butterfly_sweet0"),
                     ItemColor(tableName: "Butterfly Sweet", color: UIColor(patternImage: R.image.color_butterfly_sweet1() ?? UIImage()), name:"color_butterfly_sweet1"),
                     ItemColor(tableName: "Butterfly Sweet", color: UIColor(patternImage: R.image.color_butterfly_sweet2() ?? UIImage()), name:"color_butterfly_sweet2"),
                     ItemColor(tableName: "Butterfly Sweet", color: UIColor(patternImage: R.image.color_butterfly_sweet3() ?? UIImage()), name:"color_butterfly_sweet3"),
                     ItemColor(tableName: "Butterfly Sweet", color: UIColor(patternImage: R.image.color_butterfly_sweet4() ?? UIImage()), name:"color_butterfly_sweet4"),
                     ItemColor(tableName: "Butterfly Sweet", color: UIColor(patternImage: R.image.color_butterfly_sweet5() ?? UIImage()), name:"color_butterfly_sweet5"),
                     ItemColor(tableName: "Butterfly Sweet", color: UIColor(patternImage: R.image.color_butterfly_sweet6() ?? UIImage()), name:"color_butterfly_sweet6"),
                     ItemColor(tableName: "Butterfly Sweet", color: UIColor(patternImage: R.image.color_butterfly_sweet7() ?? UIImage()), name:"color_butterfly_sweet7"),
                     ItemColor(tableName: "Butterfly Sweet", color: UIColor(patternImage: R.image.color_butterfly_sweet8() ?? UIImage()), name:"color_butterfly_sweet8"),
                     ItemColor(tableName: "Butterfly Sweet", color: UIColor(patternImage: R.image.color_butterfly_sweet9() ?? UIImage()), name:"color_butterfly_sweet9"),
                     ItemColor(tableName: "Butterfly Sweet", color: UIColor(patternImage: R.image.color_butterfly_sweet10() ?? UIImage()), name:"color_butterfly_sweet10"),
                     ItemColor(tableName: "Butterfly Sweet", color: UIColor(patternImage: R.image.color_butterfly_sweet11() ?? UIImage()), name:"color_butterfly_sweet11"),
                     ItemColor(tableName: "Butterfly Sweet", color: UIColor(patternImage: R.image.color_butterfly_sweet12() ?? UIImage()), name:"color_butterfly_sweet12"),
                     ItemColor(tableName: "Butterfly Sweet", color: UIColor(patternImage: R.image.color_butterfly_sweet13() ?? UIImage()), name:"color_butterfly_sweet13"),
                     ItemColor(tableName: "Butterfly Sweet", color: UIColor(patternImage: R.image.color_butterfly_sweet14() ?? UIImage()), name:"color_butterfly_sweet14"),
                     ItemColor(tableName: "Butterfly Sweet", color: UIColor(patternImage: R.image.color_butterfly_sweet15() ?? UIImage()), name:"color_butterfly_sweet15")]
        case .ButterflyMystical:
            return [ ItemColor(tableName: "Butterfly Mystical", color: UIColor(patternImage: R.image.color_butterfly_mystical0() ?? UIImage()), name:"color_butterfly_mystical0"),
                     ItemColor(tableName: "Butterfly Mystical", color: UIColor(patternImage: R.image.color_butterfly_mystical1() ?? UIImage()), name:"color_butterfly_mystical1"),
                     ItemColor(tableName: "Butterfly Mystical", color: UIColor(patternImage: R.image.color_butterfly_mystical2() ?? UIImage()), name:"color_butterfly_mystical2"),
                     ItemColor(tableName: "Butterfly Mystical", color: UIColor(patternImage: R.image.color_butterfly_mystical3() ?? UIImage()), name:"color_butterfly_mystical3"),
                     ItemColor(tableName: "Butterfly Mystical", color: UIColor(patternImage: R.image.color_butterfly_mystical4() ?? UIImage()), name:"color_butterfly_mystical4"),
                     ItemColor(tableName: "Butterfly Mystical", color: UIColor(patternImage: R.image.color_butterfly_mystical5() ?? UIImage()), name:"color_butterfly_mystical5"),
                     ItemColor(tableName: "Butterfly Mystical", color: UIColor(patternImage: R.image.color_butterfly_mystical6() ?? UIImage()), name:"color_butterfly_mystical6"),
                     ItemColor(tableName: "Butterfly Mystical", color: UIColor(patternImage: R.image.color_butterfly_mystical7() ?? UIImage()), name:"color_butterfly_mystical7"),
                     ItemColor(tableName: "Butterfly Mystical", color: UIColor(patternImage: R.image.color_butterfly_mystical8() ?? UIImage()), name:"color_butterfly_mystical8"),
                     ItemColor(tableName: "Butterfly Mystical", color: UIColor(patternImage: R.image.color_butterfly_mystical9() ?? UIImage()), name:"color_butterfly_mystical9"),
                     ItemColor(tableName: "Butterfly Mystical", color: UIColor(patternImage: R.image.color_butterfly_mystical10() ?? UIImage()), name:"color_butterfly_mystical10"),
                     ItemColor(tableName: "Butterfly Mystical", color: UIColor(patternImage: R.image.color_butterfly_mystical11() ?? UIImage()), name:"color_butterfly_mystical11"),
                     ItemColor(tableName: "Butterfly Mystical", color: UIColor(patternImage: R.image.color_butterfly_mystical12() ?? UIImage()), name:"color_butterfly_mystical12"),
                     ItemColor(tableName: "Butterfly Mystical", color: UIColor(patternImage: R.image.color_butterfly_mystical13() ?? UIImage()), name:"color_butterfly_mystical13"),
                     ItemColor(tableName: "Butterfly Mystical", color: UIColor(patternImage: R.image.color_butterfly_mystical14() ?? UIImage()), name:"color_butterfly_mystical14"),
                     ItemColor(tableName: "Butterfly Mystical", color: UIColor(patternImage: R.image.color_butterfly_mystical15() ?? UIImage()), name:"color_butterfly_mystical15")]
        case .BlingBlingPastel:
            return [ ItemColor(tableName: "Bling Bling Pastel", color: UIColor(patternImage: R.image.color_bling_bling_pastel0() ?? UIImage()), name:"color_bling_bling_pastel0"),
                     ItemColor(tableName: "Bling Bling Pastel", color: UIColor(patternImage: R.image.color_bling_bling_pastel1() ?? UIImage()), name:"color_bling_bling_pastel1"),
                     ItemColor(tableName: "Bling Bling Pastel", color: UIColor(patternImage: R.image.color_bling_bling_pastel2() ?? UIImage()), name:"color_bling_bling_pastel2"),
                     ItemColor(tableName: "Bling Bling Pastel", color: UIColor(patternImage: R.image.color_bling_bling_pastel3() ?? UIImage()), name:"color_bling_bling_pastel3"),
                     ItemColor(tableName: "Bling Bling Pastel", color: UIColor(patternImage: R.image.color_bling_bling_pastel4() ?? UIImage()), name:"color_bling_bling_pastel4"),
                     ItemColor(tableName: "Bling Bling Pastel", color: UIColor(patternImage: R.image.color_bling_bling_pastel5() ?? UIImage()), name:"color_bling_bling_pastel5"),
                     ItemColor(tableName: "Bling Bling Pastel", color: UIColor(patternImage: R.image.color_bling_bling_pastel6() ?? UIImage()), name:"color_bling_bling_pastel6"),
                     ItemColor(tableName: "Bling Bling Pastel", color: UIColor(patternImage: R.image.color_bling_bling_pastel7() ?? UIImage()), name:"color_bling_bling_pastel7"),
                     ItemColor(tableName: "Bling Bling Pastel", color: UIColor(patternImage: R.image.color_bling_bling_pastel8() ?? UIImage()), name:"color_bling_bling_pastel8"),
                     ItemColor(tableName: "Bling Bling Pastel", color: UIColor(patternImage: R.image.color_bling_bling_pastel9() ?? UIImage()), name:"color_bling_bling_pastel9"),
                     ItemColor(tableName: "Bling Bling Pastel", color: UIColor(patternImage: R.image.color_bling_bling_pastel10() ?? UIImage()), name:"color_bling_bling_pastel10"),
                     ItemColor(tableName: "Bling Bling Pastel", color: UIColor(patternImage: R.image.color_bling_bling_pastel11() ?? UIImage()), name:"color_bling_bling_pastel11"),
                     ItemColor(tableName: "Bling Bling Pastel", color: UIColor(patternImage: R.image.color_bling_bling_pastel12() ?? UIImage()), name:"color_bling_bling_pastel12"),
                     ItemColor(tableName: "Bling Bling Pastel", color: UIColor(patternImage: R.image.color_bling_bling_pastel13() ?? UIImage()), name:"color_bling_bling_pastel13"),
                     ItemColor(tableName: "Bling Bling Pastel", color: UIColor(patternImage: R.image.color_bling_bling_pastel14() ?? UIImage()), name:"color_bling_bling_pastel14"),
                     ItemColor(tableName: "Bling Bling Pastel", color: UIColor(patternImage: R.image.color_bling_bling_pastel15() ?? UIImage()), name:"color_bling_bling_pastel15")]
        case .BlingBlingSweet:
            return [ ItemColor(tableName: "Bling Bling Sweet", color: UIColor(patternImage: R.image.color_bling_bling_sweet0() ?? UIImage()), name:"color_bling_bling_sweet0"),
                     ItemColor(tableName: "Bling Bling Sweet", color: UIColor(patternImage: R.image.color_bling_bling_sweet1() ?? UIImage()), name:"color_bling_bling_sweet1"),
                     ItemColor(tableName: "Bling Bling Sweet", color: UIColor(patternImage: R.image.color_bling_bling_sweet2() ?? UIImage()), name:"color_bling_bling_sweet2"),
                     ItemColor(tableName: "Bling Bling Sweet", color: UIColor(patternImage: R.image.color_bling_bling_sweet3() ?? UIImage()), name:"color_bling_bling_sweet3"),
                     ItemColor(tableName: "Bling Bling Sweet", color: UIColor(patternImage: R.image.color_bling_bling_sweet4() ?? UIImage()), name:"color_bling_bling_sweet4"),
                     ItemColor(tableName: "Bling Bling Sweet", color: UIColor(patternImage: R.image.color_bling_bling_sweet5() ?? UIImage()), name:"color_bling_bling_sweet5"),
                     ItemColor(tableName: "Bling Bling Sweet", color: UIColor(patternImage: R.image.color_bling_bling_sweet6() ?? UIImage()), name:"color_bling_bling_sweet6"),
                     ItemColor(tableName: "Bling Bling Sweet", color: UIColor(patternImage: R.image.color_bling_bling_sweet7() ?? UIImage()), name:"color_bling_bling_sweet7"),
                     ItemColor(tableName: "Bling Bling Sweet", color: UIColor(patternImage: R.image.color_bling_bling_sweet8() ?? UIImage()), name:"color_bling_bling_sweet8"),
                     ItemColor(tableName: "Bling Bling Sweet", color: UIColor(patternImage: R.image.color_bling_bling_sweet9() ?? UIImage()), name:"color_bling_bling_sweet9"),
                     ItemColor(tableName: "Bling Bling Sweet", color: UIColor(patternImage: R.image.color_bling_bling_sweet10() ?? UIImage()), name:"color_bling_bling_sweet10"),
                     ItemColor(tableName: "Bling Bling Sweet", color: UIColor(patternImage: R.image.color_bling_bling_sweet11() ?? UIImage()), name:"color_bling_bling_sweet11"),
                     ItemColor(tableName: "Bling Bling Sweet", color: UIColor(patternImage: R.image.color_bling_bling_sweet12() ?? UIImage()), name:"color_bling_bling_sweet12"),
                     ItemColor(tableName: "Bling Bling Sweet", color: UIColor(patternImage: R.image.color_bling_bling_sweet13() ?? UIImage()), name:"color_bling_bling_sweet13"),
                     ItemColor(tableName: "Bling Bling Sweet", color: UIColor(patternImage: R.image.color_bling_bling_sweet14() ?? UIImage()), name:"color_bling_bling_sweet14"),
                     ItemColor(tableName: "Bling Bling Sweet", color: UIColor(patternImage: R.image.color_bling_bling_sweet15() ?? UIImage()), name:"color_bling_bling_sweet15")]
        case .BlingBlingMystical:
            return [ ItemColor(tableName: "Bling Bling Mystical", color: UIColor(patternImage: R.image.color_bling_bling_mystical0() ?? UIImage()), name:"color_bling_bling_mystical0"),
                     ItemColor(tableName: "Bling Bling Mystical", color: UIColor(patternImage: R.image.color_bling_bling_mystical1() ?? UIImage()), name:"color_bling_bling_mystical1"),
                     ItemColor(tableName: "Bling Bling Mystical", color: UIColor(patternImage: R.image.color_bling_bling_mystical2() ?? UIImage()), name:"color_bling_bling_mystical2"),
                     ItemColor(tableName: "Bling Bling Mystical", color: UIColor(patternImage: R.image.color_bling_bling_mystical3() ?? UIImage()), name:"color_bling_bling_mystical3"),
                     ItemColor(tableName: "Bling Bling Mystical", color: UIColor(patternImage: R.image.color_bling_bling_mystical4() ?? UIImage()), name:"color_bling_bling_mystical4"),
                     ItemColor(tableName: "Bling Bling Mystical", color: UIColor(patternImage: R.image.color_bling_bling_mystical5() ?? UIImage()), name:"color_bling_bling_mystical5"),
                     ItemColor(tableName: "Bling Bling Mystical", color: UIColor(patternImage: R.image.color_bling_bling_mystical6() ?? UIImage()), name:"color_bling_bling_mystical6"),
                     ItemColor(tableName: "Bling Bling Mystical", color: UIColor(patternImage: R.image.color_bling_bling_mystical7() ?? UIImage()), name:"color_bling_bling_mystical7"),
                     ItemColor(tableName: "Bling Bling Mystical", color: UIColor(patternImage: R.image.color_bling_bling_mystical8() ?? UIImage()), name:"color_bling_bling_mystical8"),
                     ItemColor(tableName: "Bling Bling Mystical", color: UIColor(patternImage: R.image.color_bling_bling_mystical9() ?? UIImage()), name:"color_bling_bling_mystical9"),
                     ItemColor(tableName: "Bling Bling Mystical", color: UIColor(patternImage: R.image.color_bling_bling_mystical10() ?? UIImage()), name:"color_bling_bling_mystical10"),
                     ItemColor(tableName: "Bling Bling Mystical", color: UIColor(patternImage: R.image.color_bling_bling_mystical11() ?? UIImage()), name:"color_bling_bling_mystical11"),
                     ItemColor(tableName: "Bling Bling Mystical", color: UIColor(patternImage: R.image.color_bling_bling_mystical12() ?? UIImage()), name:"color_bling_bling_mystical12"),
                     ItemColor(tableName: "Bling Bling Mystical", color: UIColor(patternImage: R.image.color_bling_bling_mystical13() ?? UIImage()), name:"color_bling_bling_mystical13"),
                     ItemColor(tableName: "Bling Bling Mystical", color: UIColor(patternImage: R.image.color_bling_bling_mystical14() ?? UIImage()), name:"color_bling_bling_mystical14"),
                     ItemColor(tableName: "Bling Bling Mystical", color: UIColor(patternImage: R.image.color_bling_bling_mystical15() ?? UIImage()), name:"color_bling_bling_mystical15")]
        case .SnowFlakesPastel:
            return [ ItemColor(tableName: "Snow Flakes Pastel", color: UIColor(patternImage: R.image.color_snowflakes_pastel0() ?? UIImage()), name:"color_snowflakes_pastel0"),
                     ItemColor(tableName: "Snow Flakes Pastel", color: UIColor(patternImage: R.image.color_snowflakes_pastel1() ?? UIImage()), name:"color_snowflakes_pastel1"),
                     ItemColor(tableName: "Snow Flakes Pastel", color: UIColor(patternImage: R.image.color_snowflakes_pastel2() ?? UIImage()), name:"color_snowflakes_pastel2"),
                     ItemColor(tableName: "Snow Flakes Pastel", color: UIColor(patternImage: R.image.color_snowflakes_pastel3() ?? UIImage()), name:"color_snowflakes_pastel3"),
                     ItemColor(tableName: "Snow Flakes Pastel", color: UIColor(patternImage: R.image.color_snowflakes_pastel4() ?? UIImage()), name:"color_snowflakes_pastel4"),
                     ItemColor(tableName: "Snow Flakes Pastel", color: UIColor(patternImage: R.image.color_snowflakes_pastel5() ?? UIImage()), name:"color_snowflakes_pastel5"),
                     ItemColor(tableName: "Snow Flakes Pastel", color: UIColor(patternImage: R.image.color_snowflakes_pastel6() ?? UIImage()), name:"color_snowflakes_pastel6"),
                     ItemColor(tableName: "Snow Flakes Pastel", color: UIColor(patternImage: R.image.color_snowflakes_pastel7() ?? UIImage()), name:"color_snowflakes_pastel7"),
                     ItemColor(tableName: "Snow Flakes Pastel", color: UIColor(patternImage: R.image.color_snowflakes_pastel8() ?? UIImage()), name:"color_snowflakes_pastel8"),
                     ItemColor(tableName: "Snow Flakes Pastel", color: UIColor(patternImage: R.image.color_snowflakes_pastel9() ?? UIImage()), name:"color_snowflakes_pastel9"),
                     ItemColor(tableName: "Snow Flakes Pastel", color: UIColor(patternImage: R.image.color_snowflakes_pastel10() ?? UIImage()), name:"color_snowflakes_pastel10"),
                     ItemColor(tableName: "Snow Flakes Pastel", color: UIColor(patternImage: R.image.color_snowflakes_pastel11() ?? UIImage()), name:"color_snowflakes_pastel11"),
                     ItemColor(tableName: "Snow Flakes Pastel", color: UIColor(patternImage: R.image.color_snowflakes_pastel12() ?? UIImage()), name:"color_snowflakes_pastel12"),
                     ItemColor(tableName: "Snow Flakes Pastel", color: UIColor(patternImage: R.image.color_snowflakes_pastel13() ?? UIImage()), name:"color_snowflakes_pastel13"),
                     ItemColor(tableName: "Snow Flakes Pastel", color: UIColor(patternImage: R.image.color_snowflakes_pastel14() ?? UIImage()), name:"color_snowflakes_pastel14"),
                     ItemColor(tableName: "Snow Flakes Pastel", color: UIColor(patternImage: R.image.color_snowflakes_pastel15() ?? UIImage()), name:"color_snowflakes_pastel15")]
        case .SnowFlakesSweet:
            return [ ItemColor(tableName: "Snow Flakes Sweet", color: UIColor(patternImage: R.image.color_snowflakes_sweet0() ?? UIImage()), name:"color_snowflakes_sweet0"),
                     ItemColor(tableName: "Snow Flakes Sweet", color: UIColor(patternImage: R.image.color_snowflakes_sweet1() ?? UIImage()), name:"color_snowflakes_sweet1"),
                     ItemColor(tableName: "Snow Flakes Sweet", color: UIColor(patternImage: R.image.color_snowflakes_sweet2() ?? UIImage()), name:"color_snowflakes_sweet2"),
                     ItemColor(tableName: "Snow Flakes Sweet", color: UIColor(patternImage: R.image.color_snowflakes_sweet3() ?? UIImage()), name:"color_snowflakes_sweet3"),
                     ItemColor(tableName: "Snow Flakes Sweet", color: UIColor(patternImage: R.image.color_snowflakes_sweet4() ?? UIImage()), name:"color_snowflakes_sweet4"),
                     ItemColor(tableName: "Snow Flakes Sweet", color: UIColor(patternImage: R.image.color_snowflakes_sweet5() ?? UIImage()), name:"color_snowflakes_sweet5"),
                     ItemColor(tableName: "Snow Flakes Sweet", color: UIColor(patternImage: R.image.color_snowflakes_sweet6() ?? UIImage()), name:"color_snowflakes_sweet6"),
                     ItemColor(tableName: "Snow Flakes Sweet", color: UIColor(patternImage: R.image.color_snowflakes_sweet7() ?? UIImage()), name:"color_snowflakes_sweet7"),
                     ItemColor(tableName: "Snow Flakes Sweet", color: UIColor(patternImage: R.image.color_snowflakes_sweet8() ?? UIImage()), name:"color_snowflakes_sweet8"),
                     ItemColor(tableName: "Snow Flakes Sweet", color: UIColor(patternImage: R.image.color_snowflakes_sweet9() ?? UIImage()), name:"color_snowflakes_sweet9"),
                     ItemColor(tableName: "Snow Flakes Sweet", color: UIColor(patternImage: R.image.color_snowflakes_sweet10() ?? UIImage()), name:"color_snowflakes_sweet10"),
                     ItemColor(tableName: "Snow Flakes Sweet", color: UIColor(patternImage: R.image.color_snowflakes_sweet11() ?? UIImage()), name:"color_snowflakes_sweet11"),
                     ItemColor(tableName: "Snow Flakes Sweet", color: UIColor(patternImage: R.image.color_snowflakes_sweet12() ?? UIImage()), name:"color_snowflakes_sweet12"),
                     ItemColor(tableName: "Snow Flakes Sweet", color: UIColor(patternImage: R.image.color_snowflakes_sweet13() ?? UIImage()), name:"color_snowflakes_sweet13"),
                     ItemColor(tableName: "Snow Flakes Sweet", color: UIColor(patternImage: R.image.color_snowflakes_sweet14() ?? UIImage()), name:"color_snowflakes_sweet14"),
                     ItemColor(tableName: "Snow Flakes Sweet", color: UIColor(patternImage: R.image.color_snowflakes_sweet15() ?? UIImage()), name:"color_snowflakes_sweet15")]
        case .SnowFlakesMystical:
            return [ ItemColor(tableName: "Snow Flakes Mystical", color: UIColor(patternImage: R.image.color_snowflakes_mystical0() ?? UIImage()), name:"color_snowflakes_mystical0"),
                     ItemColor(tableName: "Snow Flakes Mystical", color: UIColor(patternImage: R.image.color_snowflakes_mystical1() ?? UIImage()), name:"color_snowflakes_mystical1"),
                     ItemColor(tableName: "Snow Flakes Mystical", color: UIColor(patternImage: R.image.color_snowflakes_mystical2() ?? UIImage()), name:"color_snowflakes_mystical2"),
                     ItemColor(tableName: "Snow Flakes Mystical", color: UIColor(patternImage: R.image.color_snowflakes_mystical3() ?? UIImage()), name:"color_snowflakes_mystical3"),
                     ItemColor(tableName: "Snow Flakes Mystical", color: UIColor(patternImage: R.image.color_snowflakes_mystical4() ?? UIImage()), name:"color_snowflakes_mystical4"),
                     ItemColor(tableName: "Snow Flakes Mystical", color: UIColor(patternImage: R.image.color_snowflakes_mystical5() ?? UIImage()), name:"color_snowflakes_mystical5"),
                     ItemColor(tableName: "Snow Flakes Mystical", color: UIColor(patternImage: R.image.color_snowflakes_mystical6() ?? UIImage()), name:"color_snowflakes_mystical6"),
                     ItemColor(tableName: "Snow Flakes Mystical", color: UIColor(patternImage: R.image.color_snowflakes_mystical7() ?? UIImage()), name:"color_snowflakes_mystical7"),
                     ItemColor(tableName: "Snow Flakes Mystical", color: UIColor(patternImage: R.image.color_snowflakes_mystical8() ?? UIImage()), name:"color_snowflakes_mystical8"),
                     ItemColor(tableName: "Snow Flakes Mystical", color: UIColor(patternImage: R.image.color_snowflakes_mystical9() ?? UIImage()), name:"color_snowflakes_mystical9"),
                     ItemColor(tableName: "Snow Flakes Mystical", color: UIColor(patternImage: R.image.color_snowflakes_mystical10() ?? UIImage()), name:"color_snowflakes_mystical10"),
                     ItemColor(tableName: "Snow Flakes Mystical", color: UIColor(patternImage: R.image.color_snowflakes_mystical11() ?? UIImage()), name:"color_snowflakes_mystical11"),
                     ItemColor(tableName: "Snow Flakes Mystical", color: UIColor(patternImage: R.image.color_snowflakes_mystical12() ?? UIImage()), name:"color_snowflakes_mystical12"),
                     ItemColor(tableName: "Snow Flakes Mystical", color: UIColor(patternImage: R.image.color_snowflakes_mystical13() ?? UIImage()), name:"color_snowflakes_mystical13"),
                     ItemColor(tableName: "Snow Flakes Mystical", color: UIColor(patternImage: R.image.color_snowflakes_mystical14() ?? UIImage()), name:"color_snowflakes_mystical14"),
                     ItemColor(tableName: "Snow Flakes Mystical", color: UIColor(patternImage: R.image.color_snowflakes_mystical15() ?? UIImage()), name:"color_snowflakes_mystical15")]
        case .Bling3Pastel:
            return [ ItemColor(tableName: "Bling3 Pastel", color: UIColor(patternImage: R.image.color_bling3_pastel0() ?? UIImage()), name:"color_bling3_pastel0"),
                     ItemColor(tableName: "Bling3 Pastel", color: UIColor(patternImage: R.image.color_bling3_pastel1() ?? UIImage()), name:"color_bling3_pastel1"),
                     ItemColor(tableName: "Bling3 Pastel", color: UIColor(patternImage: R.image.color_bling3_pastel2() ?? UIImage()), name:"color_bling3_pastel2"),
                     ItemColor(tableName: "Bling3 Pastel", color: UIColor(patternImage: R.image.color_bling3_pastel3() ?? UIImage()), name:"color_bling3_pastel3"),
                     ItemColor(tableName: "Bling3 Pastel", color: UIColor(patternImage: R.image.color_bling3_pastel4() ?? UIImage()), name:"color_bling3_pastel4"),
                     ItemColor(tableName: "Bling3 Pastel", color: UIColor(patternImage: R.image.color_bling3_pastel5() ?? UIImage()), name:"color_bling3_pastel5"),
                     ItemColor(tableName: "Bling3 Pastel", color: UIColor(patternImage: R.image.color_bling3_pastel6() ?? UIImage()), name:"color_bling3_pastel6"),
                     ItemColor(tableName: "Bling3 Pastel", color: UIColor(patternImage: R.image.color_bling3_pastel7() ?? UIImage()), name:"color_bling3_pastel7"),
                     ItemColor(tableName: "Bling3 Pastel", color: UIColor(patternImage: R.image.color_bling3_pastel8() ?? UIImage()), name:"color_bling3_pastel8"),
                     ItemColor(tableName: "Bling3 Pastel", color: UIColor(patternImage: R.image.color_bling3_pastel9() ?? UIImage()), name:"color_bling3_pastel9"),
                     ItemColor(tableName: "Bling3 Pastel", color: UIColor(patternImage: R.image.color_bling3_pastel10() ?? UIImage()), name:"color_bling3_pastel10"),
                     ItemColor(tableName: "Bling3 Pastel", color: UIColor(patternImage: R.image.color_bling3_pastel11() ?? UIImage()), name:"color_bling3_pastel11"),
                     ItemColor(tableName: "Bling3 Pastel", color: UIColor(patternImage: R.image.color_bling3_pastel12() ?? UIImage()), name:"color_bling3_pastel12"),
                     ItemColor(tableName: "Bling3 Pastel", color: UIColor(patternImage: R.image.color_bling3_pastel13() ?? UIImage()), name:"color_bling3_pastel13"),
                     ItemColor(tableName: "Bling3 Pastel", color: UIColor(patternImage: R.image.color_bling3_pastel14() ?? UIImage()), name:"color_bling3_pastel14"),
                     ItemColor(tableName: "Bling3 Pastel", color: UIColor(patternImage: R.image.color_bling3_pastel15() ?? UIImage()), name:"color_bling3_pastel15")]
        case .Bling3Sweet:
            return [ ItemColor(tableName: "Bling3 Sweet", color: UIColor(patternImage: R.image.color_bling3_sweet0() ?? UIImage()), name:"color_bling3_sweet0"),
                     ItemColor(tableName: "Bling3 Sweet", color: UIColor(patternImage: R.image.color_bling3_sweet1() ?? UIImage()), name:"color_bling3_sweet1"),
                     ItemColor(tableName: "Bling3 Sweet", color: UIColor(patternImage: R.image.color_bling3_sweet2() ?? UIImage()), name:"color_bling3_sweet2"),
                     ItemColor(tableName: "Bling3 Sweet", color: UIColor(patternImage: R.image.color_bling3_sweet3() ?? UIImage()), name:"color_bling3_sweet3"),
                     ItemColor(tableName: "Bling3 Sweet", color: UIColor(patternImage: R.image.color_bling3_sweet4() ?? UIImage()), name:"color_bling3_sweet4"),
                     ItemColor(tableName: "Bling3 Sweet", color: UIColor(patternImage: R.image.color_bling3_sweet5() ?? UIImage()), name:"color_bling3_sweet5"),
                     ItemColor(tableName: "Bling3 Sweet", color: UIColor(patternImage: R.image.color_bling3_sweet6() ?? UIImage()), name:"color_bling3_sweet6"),
                     ItemColor(tableName: "Bling3 Sweet", color: UIColor(patternImage: R.image.color_bling3_sweet7() ?? UIImage()), name:"color_bling3_sweet7"),
                     ItemColor(tableName: "Bling3 Sweet", color: UIColor(patternImage: R.image.color_bling3_sweet8() ?? UIImage()), name:"color_bling3_sweet8"),
                     ItemColor(tableName: "Bling3 Sweet", color: UIColor(patternImage: R.image.color_bling3_sweet9() ?? UIImage()), name:"color_bling3_sweet9"),
                     ItemColor(tableName: "Bling3 Sweet", color: UIColor(patternImage: R.image.color_bling3_sweet10() ?? UIImage()), name:"color_bling3_sweet10"),
                     ItemColor(tableName: "Bling3 Sweet", color: UIColor(patternImage: R.image.color_bling3_sweet11() ?? UIImage()), name:"color_bling3_sweet11"),
                     ItemColor(tableName: "Bling3 Sweet", color: UIColor(patternImage: R.image.color_bling3_sweet12() ?? UIImage()), name:"color_bling3_sweet12"),
                     ItemColor(tableName: "Bling3 Sweet", color: UIColor(patternImage: R.image.color_bling3_sweet13() ?? UIImage()), name:"color_bling3_sweet13"),
                     ItemColor(tableName: "Bling3 Sweet", color: UIColor(patternImage: R.image.color_bling3_sweet14() ?? UIImage()), name:"color_bling3_sweet14"),
                     ItemColor(tableName: "Bling3 Sweet", color: UIColor(patternImage: R.image.color_bling3_sweet15() ?? UIImage()), name:"color_bling3_sweet15")]
        case .Bling3Mystical:
            return [ ItemColor(tableName: "Bling3 Mystical", color: UIColor(patternImage: R.image.color_bling3_mystical0() ?? UIImage()), name:"color_bling3_mystical0"),
                     ItemColor(tableName: "Bling3 Mystical", color: UIColor(patternImage: R.image.color_bling3_mystical1() ?? UIImage()), name:"color_bling3_mystical1"),
                     ItemColor(tableName: "Bling3 Mystical", color: UIColor(patternImage: R.image.color_bling3_mystical2() ?? UIImage()), name:"color_bling3_mystical2"),
                     ItemColor(tableName: "Bling3 Mystical", color: UIColor(patternImage: R.image.color_bling3_mystical3() ?? UIImage()), name:"color_bling3_mystical3"),
                     ItemColor(tableName: "Bling3 Mystical", color: UIColor(patternImage: R.image.color_bling3_mystical4() ?? UIImage()), name:"color_bling3_mystical4"),
                     ItemColor(tableName: "Bling3 Mystical", color: UIColor(patternImage: R.image.color_bling3_mystical5() ?? UIImage()), name:"color_bling3_mystical5"),
                     ItemColor(tableName: "Bling3 Mystical", color: UIColor(patternImage: R.image.color_bling3_mystical6() ?? UIImage()), name:"color_bling3_mystical6"),
                     ItemColor(tableName: "Bling3 Mystical", color: UIColor(patternImage: R.image.color_bling3_mystical7() ?? UIImage()), name:"color_bling3_mystical7"),
                     ItemColor(tableName: "Bling3 Mystical", color: UIColor(patternImage: R.image.color_bling3_mystical8() ?? UIImage()), name:"color_bling3_mystical8"),
                     ItemColor(tableName: "Bling3 Mystical", color: UIColor(patternImage: R.image.color_bling3_mystical9() ?? UIImage()), name:"color_bling3_mystical9"),
                     ItemColor(tableName: "Bling3 Mystical", color: UIColor(patternImage: R.image.color_bling3_mystical10() ?? UIImage()), name:"color_bling3_mystical10"),
                     ItemColor(tableName: "Bling3 Mystical", color: UIColor(patternImage: R.image.color_bling3_mystical11() ?? UIImage()), name:"color_bling3_mystical11"),
                     ItemColor(tableName: "Bling3 Mystical", color: UIColor(patternImage: R.image.color_bling3_mystical12() ?? UIImage()), name:"color_bling3_mystical12"),
                     ItemColor(tableName: "Bling3 Mystical", color: UIColor(patternImage: R.image.color_bling3_mystical13() ?? UIImage()), name:"color_bling3_mystical13"),
                     ItemColor(tableName: "Bling3 Mystical", color: UIColor(patternImage: R.image.color_bling3_mystical14() ?? UIImage()), name:"color_bling3_mystical14"),
                     ItemColor(tableName: "Bling3 Mystical", color: UIColor(patternImage: R.image.color_bling3_mystical15() ?? UIImage()), name:"color_bling3_mystical15")]
        case .BubblePastel:
            return [ ItemColor(tableName: "Bubble Pastel", color: UIColor(patternImage: R.image.color_bubble_pastel0() ?? UIImage()), name:"color_bubble_pastel0"),
                     ItemColor(tableName: "Bubble Pastel", color: UIColor(patternImage: R.image.color_bubble_pastel1() ?? UIImage()), name:"color_bubble_pastel1"),
                     ItemColor(tableName: "Bubble Pastel", color: UIColor(patternImage: R.image.color_bubble_pastel2() ?? UIImage()), name:"color_bubble_pastel2"),
                     ItemColor(tableName: "Bubble Pastel", color: UIColor(patternImage: R.image.color_bubble_pastel3() ?? UIImage()), name:"color_bubble_pastel3"),
                     ItemColor(tableName: "Bubble Pastel", color: UIColor(patternImage: R.image.color_bubble_pastel4() ?? UIImage()), name:"color_bubble_pastel4"),
                     ItemColor(tableName: "Bubble Pastel", color: UIColor(patternImage: R.image.color_bubble_pastel5() ?? UIImage()), name:"color_bubble_pastel5"),
                     ItemColor(tableName: "Bubble Pastel", color: UIColor(patternImage: R.image.color_bubble_pastel6() ?? UIImage()), name:"color_bubble_pastel6"),
                     ItemColor(tableName: "Bubble Pastel", color: UIColor(patternImage: R.image.color_bubble_pastel7() ?? UIImage()), name:"color_bubble_pastel7"),
                     ItemColor(tableName: "Bubble Pastel", color: UIColor(patternImage: R.image.color_bubble_pastel8() ?? UIImage()), name:"color_bubble_pastel8"),
                     ItemColor(tableName: "Bubble Pastel", color: UIColor(patternImage: R.image.color_bubble_pastel9() ?? UIImage()), name:"color_bubble_pastel9"),
                     ItemColor(tableName: "Bubble Pastel", color: UIColor(patternImage: R.image.color_bubble_pastel10() ?? UIImage()), name:"color_bubble_pastel10"),
                     ItemColor(tableName: "Bubble Pastel", color: UIColor(patternImage: R.image.color_bubble_pastel11() ?? UIImage()), name:"color_bubble_pastel11"),
                     ItemColor(tableName: "Bubble Pastel", color: UIColor(patternImage: R.image.color_bubble_pastel12() ?? UIImage()), name:"color_bubble_pastel12"),
                     ItemColor(tableName: "Bubble Pastel", color: UIColor(patternImage: R.image.color_bubble_pastel13() ?? UIImage()), name:"color_bubble_pastel13"),
                     ItemColor(tableName: "Bubble Pastel", color: UIColor(patternImage: R.image.color_bubble_pastel14() ?? UIImage()), name:"color_bubble_pastel14"),
                     ItemColor(tableName: "Bubble Pastel", color: UIColor(patternImage: R.image.color_bubble_pastel15() ?? UIImage()), name:"color_bubble_pastel15")]
        case .BubbleSweet:
            return [ ItemColor(tableName: "Bubble Sweet", color: UIColor(patternImage: R.image.color_bubble_sweet0() ?? UIImage()), name:"color_bubble_sweet0"),
                     ItemColor(tableName: "Bubble Sweet", color: UIColor(patternImage: R.image.color_bubble_sweet1() ?? UIImage()), name:"color_bubble_sweet1"),
                     ItemColor(tableName: "Bubble Sweet", color: UIColor(patternImage: R.image.color_bubble_sweet2() ?? UIImage()), name:"color_bubble_sweet2"),
                     ItemColor(tableName: "Bubble Sweet", color: UIColor(patternImage: R.image.color_bubble_sweet3() ?? UIImage()), name:"color_bubble_sweet3"),
                     ItemColor(tableName: "Bubble Sweet", color: UIColor(patternImage: R.image.color_bubble_sweet4() ?? UIImage()), name:"color_bubble_sweet4"),
                     ItemColor(tableName: "Bubble Sweet", color: UIColor(patternImage: R.image.color_bubble_sweet5() ?? UIImage()), name:"color_bubble_sweet5"),
                     ItemColor(tableName: "Bubble Sweet", color: UIColor(patternImage: R.image.color_bubble_sweet6() ?? UIImage()), name:"color_bubble_sweet6"),
                     ItemColor(tableName: "Bubble Sweet", color: UIColor(patternImage: R.image.color_bubble_sweet7() ?? UIImage()), name:"color_bubble_sweet7"),
                     ItemColor(tableName: "Bubble Sweet", color: UIColor(patternImage: R.image.color_bubble_sweet8() ?? UIImage()), name:"color_bubble_sweet8"),
                     ItemColor(tableName: "Bubble Sweet", color: UIColor(patternImage: R.image.color_bubble_sweet9() ?? UIImage()), name:"color_bubble_sweet9"),
                     ItemColor(tableName: "Bubble Sweet", color: UIColor(patternImage: R.image.color_bubble_sweet10() ?? UIImage()), name:"color_bubble_sweet10"),
                     ItemColor(tableName: "Bubble Sweet", color: UIColor(patternImage: R.image.color_bubble_sweet11() ?? UIImage()), name:"color_bubble_sweet11"),
                     ItemColor(tableName: "Bubble Sweet", color: UIColor(patternImage: R.image.color_bubble_sweet12() ?? UIImage()), name:"color_bubble_sweet12"),
                     ItemColor(tableName: "Bubble Sweet", color: UIColor(patternImage: R.image.color_bubble_sweet13() ?? UIImage()), name:"color_bubble_sweet13"),
                     ItemColor(tableName: "Bubble Sweet", color: UIColor(patternImage: R.image.color_bubble_sweet14() ?? UIImage()), name:"color_bubble_sweet14"),
                     ItemColor(tableName: "Bubble Sweet", color: UIColor(patternImage: R.image.color_bubble_sweet15() ?? UIImage()), name:"color_bubble_sweet15")]
        case .BubbleMystical:
            return [ ItemColor(tableName: "Bubble Mystical", color: UIColor(patternImage: R.image.color_bubble_mystical0() ?? UIImage()), name:"color_bubble_mystical0"),
                     ItemColor(tableName: "Bubble Mystical", color: UIColor(patternImage: R.image.color_bubble_mystical1() ?? UIImage()), name:"color_bubble_mystical1"),
                     ItemColor(tableName: "Bubble Mystical", color: UIColor(patternImage: R.image.color_bubble_mystical2() ?? UIImage()), name:"color_bubble_mystical2"),
                     ItemColor(tableName: "Bubble Mystical", color: UIColor(patternImage: R.image.color_bubble_mystical3() ?? UIImage()), name:"color_bubble_mystical3"),
                     ItemColor(tableName: "Bubble Mystical", color: UIColor(patternImage: R.image.color_bubble_mystical4() ?? UIImage()), name:"color_bubble_mystical4"),
                     ItemColor(tableName: "Bubble Mystical", color: UIColor(patternImage: R.image.color_bubble_mystical5() ?? UIImage()), name:"color_bubble_mystical5"),
                     ItemColor(tableName: "Bubble Mystical", color: UIColor(patternImage: R.image.color_bubble_mystical6() ?? UIImage()), name:"color_bubble_mystical6"),
                     ItemColor(tableName: "Bubble Mystical", color: UIColor(patternImage: R.image.color_bubble_mystical7() ?? UIImage()), name:"color_bubble_mystical7"),
                     ItemColor(tableName: "Bubble Mystical", color: UIColor(patternImage: R.image.color_bubble_mystical8() ?? UIImage()), name:"color_bubble_mystical8"),
                     ItemColor(tableName: "Bubble Mystical", color: UIColor(patternImage: R.image.color_bubble_mystical9() ?? UIImage()), name:"color_bubble_mystical9"),
                     ItemColor(tableName: "Bubble Mystical", color: UIColor(patternImage: R.image.color_bubble_mystical10() ?? UIImage()), name:"color_bubble_mystical10"),
                     ItemColor(tableName: "Bubble Mystical", color: UIColor(patternImage: R.image.color_bubble_mystical11() ?? UIImage()), name:"color_bubble_mystical11"),
                     ItemColor(tableName: "Bubble Mystical", color: UIColor(patternImage: R.image.color_bubble_mystical12() ?? UIImage()), name:"color_bubble_mystical12"),
                     ItemColor(tableName: "Bubble Mystical", color: UIColor(patternImage: R.image.color_bubble_mystical13() ?? UIImage()), name:"color_bubble_mystical13"),
                     ItemColor(tableName: "Bubble Mystical", color: UIColor(patternImage: R.image.color_bubble_mystical14() ?? UIImage()), name:"color_bubble_mystical14"),
                     ItemColor(tableName: "Bubble Mystical", color: UIColor(patternImage: R.image.color_bubble_mystical15() ?? UIImage()), name:"color_bubble_mystical15")]
        case .SnowPastel:
            return [ ItemColor(tableName: "Snow Pastel", color: UIColor(patternImage: R.image.color_snow_pastel0() ?? UIImage()), name:"color_snow_pastel0" ),
                     ItemColor(tableName: "Snow Pastel", color: UIColor(patternImage: R.image.color_snow_pastel1() ?? UIImage()), name:"color_snow_pastel1" ),
                     ItemColor(tableName: "Snow Pastel", color: UIColor(patternImage: R.image.color_snow_pastel2() ?? UIImage()), name:"color_snow_pastel2" ),
                     ItemColor(tableName: "Snow Pastel", color: UIColor(patternImage: R.image.color_snow_pastel3() ?? UIImage()), name:"color_snow_pastel3" ),
                     ItemColor(tableName: "Snow Pastel", color: UIColor(patternImage: R.image.color_snow_pastel4() ?? UIImage()), name:"color_snow_pastel4" ),
                     ItemColor(tableName: "Snow Pastel", color: UIColor(patternImage: R.image.color_snow_pastel5() ?? UIImage()), name:"color_snow_pastel5" ),
                     ItemColor(tableName: "Snow Pastel", color: UIColor(patternImage: R.image.color_snow_pastel6() ?? UIImage()), name:"color_snow_pastel6" ),
                     ItemColor(tableName: "Snow Pastel", color: UIColor(patternImage: R.image.color_snow_pastel7() ?? UIImage()), name:"color_snow_pastel7" ),
                     ItemColor(tableName: "Snow Pastel", color: UIColor(patternImage: R.image.color_snow_pastel8() ?? UIImage()), name:"color_snow_pastel8" ),
                     ItemColor(tableName: "Snow Pastel", color: UIColor(patternImage: R.image.color_snow_pastel9() ?? UIImage()), name:"color_snow_pastel9" ),
                     ItemColor(tableName: "Snow Pastel", color: UIColor(patternImage: R.image.color_snow_pastel10() ?? UIImage()), name:"color_snow_pastel10"),
                     ItemColor(tableName: "Snow Pastel", color: UIColor(patternImage: R.image.color_snow_pastel11() ?? UIImage()), name:"color_snow_pastel11"),
                     ItemColor(tableName: "Snow Pastel", color: UIColor(patternImage: R.image.color_snow_pastel12() ?? UIImage()), name:"color_snow_pastel12"),
                     ItemColor(tableName: "Snow Pastel", color: UIColor(patternImage: R.image.color_snow_pastel13() ?? UIImage()), name:"color_snow_pastel13"),
                     ItemColor(tableName: "Snow Pastel", color: UIColor(patternImage: R.image.color_snow_pastel14() ?? UIImage()), name:"color_snow_pastel14"),
                     ItemColor(tableName: "Snow Pastel", color: UIColor(patternImage: R.image.color_snow_pastel15() ?? UIImage()), name:"color_snow_pastel15")]
        case .SnowSweet:
            return [ ItemColor(tableName: "Snow Sweet", color: UIColor(patternImage: R.image.color_snow_sweet0() ?? UIImage()), name:"color_snow_sweet0"),
                     ItemColor(tableName: "Snow Sweet", color: UIColor(patternImage: R.image.color_snow_sweet1() ?? UIImage()), name:"color_snow_sweet1"),
                     ItemColor(tableName: "Snow Sweet", color: UIColor(patternImage: R.image.color_snow_sweet2() ?? UIImage()), name:"color_snow_sweet2"),
                     ItemColor(tableName: "Snow Sweet", color: UIColor(patternImage: R.image.color_snow_sweet3() ?? UIImage()), name:"color_snow_sweet3"),
                     ItemColor(tableName: "Snow Sweet", color: UIColor(patternImage: R.image.color_snow_sweet4() ?? UIImage()), name:"color_snow_sweet4"),
                     ItemColor(tableName: "Snow Sweet", color: UIColor(patternImage: R.image.color_snow_sweet5() ?? UIImage()), name:"color_snow_sweet5"),
                     ItemColor(tableName: "Snow Sweet", color: UIColor(patternImage: R.image.color_snow_sweet6() ?? UIImage()), name:"color_snow_sweet6"),
                     ItemColor(tableName: "Snow Sweet", color: UIColor(patternImage: R.image.color_snow_sweet7() ?? UIImage()), name:"color_snow_sweet7"),
                     ItemColor(tableName: "Snow Sweet", color: UIColor(patternImage: R.image.color_snow_sweet8() ?? UIImage()), name:"color_snow_sweet8"),
                     ItemColor(tableName: "Snow Sweet", color: UIColor(patternImage: R.image.color_snow_sweet9() ?? UIImage()), name:"color_snow_sweet9"),
                     ItemColor(tableName: "Snow Sweet", color: UIColor(patternImage: R.image.color_snow_sweet10() ?? UIImage()), name:"color_snow_sweet10"),
                     ItemColor(tableName: "Snow Sweet", color: UIColor(patternImage: R.image.color_snow_sweet11() ?? UIImage()), name:"color_snow_sweet11"),
                     ItemColor(tableName: "Snow Sweet", color: UIColor(patternImage: R.image.color_snow_sweet12() ?? UIImage()), name:"color_snow_sweet12"),
                     ItemColor(tableName: "Snow Sweet", color: UIColor(patternImage: R.image.color_snow_sweet13() ?? UIImage()), name:"color_snow_sweet13"),
                     ItemColor(tableName: "Snow Sweet", color: UIColor(patternImage: R.image.color_snow_sweet14() ?? UIImage()), name:"color_snow_sweet14"),
                     ItemColor(tableName: "Snow Sweet", color: UIColor(patternImage: R.image.color_snow_sweet15() ?? UIImage()), name:"color_snow_sweet15")]
        case .SnowMystical:
            return [ ItemColor(tableName: "Snow Mystical", color: UIColor(patternImage: R.image.color_snow_mystical0() ?? UIImage()), name:"color_snow_mystical0" ),
                     ItemColor(tableName: "Snow Mystical", color: UIColor(patternImage: R.image.color_snow_mystical1() ?? UIImage()), name:"color_snow_mystical1" ),
                     ItemColor(tableName: "Snow Mystical", color: UIColor(patternImage: R.image.color_snow_mystical2() ?? UIImage()), name:"color_snow_mystical2" ),
                     ItemColor(tableName: "Snow Mystical", color: UIColor(patternImage: R.image.color_snow_mystical3() ?? UIImage()), name:"color_snow_mystical3" ),
                     ItemColor(tableName: "Snow Mystical", color: UIColor(patternImage: R.image.color_snow_mystical4() ?? UIImage()), name:"color_snow_mystical4" ),
                     ItemColor(tableName: "Snow Mystical", color: UIColor(patternImage: R.image.color_snow_mystical5() ?? UIImage()), name:"color_snow_mystical5" ),
                     ItemColor(tableName: "Snow Mystical", color: UIColor(patternImage: R.image.color_snow_mystical6() ?? UIImage()), name:"color_snow_mystical6" ),
                     ItemColor(tableName: "Snow Mystical", color: UIColor(patternImage: R.image.color_snow_mystical7() ?? UIImage()), name:"color_snow_mystical7" ),
                     ItemColor(tableName: "Snow Mystical", color: UIColor(patternImage: R.image.color_snow_mystical8() ?? UIImage()), name:"color_snow_mystical8" ),
                     ItemColor(tableName: "Snow Mystical", color: UIColor(patternImage: R.image.color_snow_mystical9() ?? UIImage()), name:"color_snow_mystical9" ),
                     ItemColor(tableName: "Snow Mystical", color: UIColor(patternImage: R.image.color_snow_mystical10() ?? UIImage()), name:"color_snow_mystical10"),
                     ItemColor(tableName: "Snow Mystical", color: UIColor(patternImage: R.image.color_snow_mystical11() ?? UIImage()), name:"color_snow_mystical11"),
                     ItemColor(tableName: "Snow Mystical", color: UIColor(patternImage: R.image.color_snow_mystical12() ?? UIImage()), name:"color_snow_mystical12"),
                     ItemColor(tableName: "Snow Mystical", color: UIColor(patternImage: R.image.color_snow_mystical13() ?? UIImage()), name:"color_snow_mystical13"),
                     ItemColor(tableName: "Snow Mystical", color: UIColor(patternImage: R.image.color_snow_mystical14() ?? UIImage()), name:"color_snow_mystical14"),
                     ItemColor(tableName: "Snow Mystical", color: UIColor(patternImage: R.image.color_snow_mystical15() ?? UIImage()), name:"color_snow_mystical15")]
        case .Basic_Color:
            return [ItemColor(tableName: "Basic Color", hex: "D63131", name: "D63131"),
                    ItemColor(tableName: "Basic Color", hex: "000000", name: "000000"),
                    ItemColor(tableName: "Basic Color", hex: "DE8900", name: "DE8900"),
                    ItemColor(tableName: "Basic Color", hex: "68BD00", name: "68BD00"),
                    ItemColor(tableName: "Basic Color", hex: "026850", name: "026850"),
                    ItemColor(tableName: "Basic Color", hex: "007AA3", name: "007AA3"),
                    ItemColor(tableName: "Basic Color", hex: "0E189E", name: "0E189E"),
                    ItemColor(tableName: "Basic Color", hex: "DECBE0", name: "DECBE0"),
                    ItemColor(tableName: "Basic Color", hex: "FFFFFF", name: "FFFFFF"),
                    ItemColor(tableName: "Basic Color", hex: "B34A00", name: "B34A00"),
                    ItemColor(tableName: "Basic Color", hex: "F0B000", name: "F0B000"),
                    ItemColor(tableName: "Basic Color", hex: "058708", name: "058708"),
                    ItemColor(tableName: "Basic Color", hex: "009FAD", name: "009FAD"),
                    ItemColor(tableName: "Basic Color", hex: "004F8C", name: "004F8C"),
                    ItemColor(tableName: "Basic Color", hex: "54119C", name: "54119C"),
                    ItemColor(tableName: "Basic Color", hex: "D92768", name: "D92768")]
        case .Skin_Color:
            return [ItemColor(tableName: "Skin Color", hex: "FFE6E3", name: "FFE6E3"),
                    ItemColor(tableName: "Skin Color", hex: "FFBCAA", name: "FFBCAA"),
                    ItemColor(tableName: "Skin Color", hex: "F5BC9D", name: "F5BC9D"),
                    ItemColor(tableName: "Skin Color", hex: "F79E85", name: "F79E85"),
                    ItemColor(tableName: "Skin Color", hex: "FFAEA3", name: "FFAEA3"),
                    ItemColor(tableName: "Skin Color", hex: "DC8776", name: "DC8776"),
                    ItemColor(tableName: "Skin Color", hex: "EDBD91", name: "EDBD91"),
                    ItemColor(tableName: "Skin Color", hex: "69281B", name: "69281B"),
                    ItemColor(tableName: "Skin Color", hex: "FFC9BE", name: "FFC9BE"),
                    ItemColor(tableName: "Skin Color", hex: "F0AC99", name: "F0AC99"),
                    ItemColor(tableName: "Skin Color", hex: "E99586", name: "E99586"),
                    ItemColor(tableName: "Skin Color", hex: "D28873", name: "D28873"),
                    ItemColor(tableName: "Skin Color", hex: "F28F6F", name: "F28F6F"),
                    ItemColor(tableName: "Skin Color", hex: "B05937", name: "B05937"),
                    ItemColor(tableName: "Skin Color", hex: "A25E53", name: "A25E53"),
                    ItemColor(tableName: "Skin Color", hex: "BC594E", name: "BC594E")]
        case .Vivid_Color:
            return [ItemColor(tableName: "Vivid Color", hex: "E5ACBF", name: "E5ACBF"),
                    ItemColor(tableName: "Vivid Color", hex: "F0939B", name: "F0939B"),
                    ItemColor(tableName: "Vivid Color", hex: "ED6EA5", name: "ED6EA5"),
                    ItemColor(tableName: "Vivid Color", hex: "C85179", name: "C85179"),
                    ItemColor(tableName: "Vivid Color", hex: "F76F86", name: "F76F86"),
                    ItemColor(tableName: "Vivid Color", hex: "E70034", name: "E70034"),
                    ItemColor(tableName: "Vivid Color", hex: "CA2F35", name: "CA2F35"),
                    ItemColor(tableName: "Vivid Color", hex: "A22044", name: "A22044"),
                    ItemColor(tableName: "Vivid Color", hex: "FFABAB", name: "FFABAB"),
                    ItemColor(tableName: "Vivid Color", hex: "EE857F", name: "EE857F"),
                    ItemColor(tableName: "Vivid Color", hex: "ED6F8B", name: "ED6F8B"),
                    ItemColor(tableName: "Vivid Color", hex: "C8475D", name: "C8475D"),
                    ItemColor(tableName: "Vivid Color", hex: "D04747", name: "D04747"),
                    ItemColor(tableName: "Vivid Color", hex: "C7465B", name: "C7465B"),
                    ItemColor(tableName: "Vivid Color", hex: "A12B0B", name: "A12B0B"),
                    ItemColor(tableName: "Vivid Color", hex: "730000", name: "730000")]
        case .Hot_Color:
            return [ItemColor(tableName: "Hot Color", hex: "FFF6A1", name: "FFF6A1"),
                    ItemColor(tableName: "Hot Color", hex: "EDC98F", name: "EDC98F"),
                    ItemColor(tableName: "Hot Color", hex: "FBCA4E", name: "FBCA4E"),
                    ItemColor(tableName: "Hot Color", hex: "F08302", name: "F08302"),
                    ItemColor(tableName: "Hot Color", hex: "EDB400", name: "EDB400"),
                    ItemColor(tableName: "Hot Color", hex: "D9A72E", name: "D9A72E"),
                    ItemColor(tableName: "Hot Color", hex: "844F07", name: "844F07"),
                    ItemColor(tableName: "Hot Color", hex: "B55210", name: "B55210"),
                    ItemColor(tableName: "Hot Color", hex: "FFD977", name: "FFD977"),
                    ItemColor(tableName: "Hot Color", hex: "FFDA00", name: "FFDA00"),
                    ItemColor(tableName: "Hot Color", hex: "FAB14F", name: "FAB14F"),
                    ItemColor(tableName: "Hot Color", hex: "B27400", name: "B27400"),
                    ItemColor(tableName: "Hot Color", hex: "E39210", name: "E39210"),
                    ItemColor(tableName: "Hot Color", hex: "E55E31", name: "E55E31"),
                    ItemColor(tableName: "Hot Color", hex: "AD7D4C", name: "AD7D4C"),
                    ItemColor(tableName: "Hot Color", hex: "5E3805", name: "5E3805")]
        case .Natural_Color:
            return [ItemColor(tableName: "Natural Color", hex: "E8EBB0", name: "E8EBB0"),
                    ItemColor(tableName: "Natural Color", hex: "ADCA67", name: "ADCA67"),
                    ItemColor(tableName: "Natural Color", hex: "AFCCA1", name: "AFCCA1"),
                    ItemColor(tableName: "Natural Color", hex: "66CA32", name: "66CA32"),
                    ItemColor(tableName: "Natural Color", hex: "9DFF68", name: "9DFF68"),
                    ItemColor(tableName: "Natural Color", hex: "7FDF4D", name: "7FDF4D"),
                    ItemColor(tableName: "Natural Color", hex: "3AB56E", name: "3AB56E"),
                    ItemColor(tableName: "Natural Color", hex: "006852", name: "006852"),
                    ItemColor(tableName: "Natural Color", hex: "CBDA8D", name: "CBDA8D"),
                    ItemColor(tableName: "Natural Color", hex: "B8DA1B", name: "B8DA1B"),
                    ItemColor(tableName: "Natural Color", hex: "9CAD51", name: "9CAD51"),
                    ItemColor(tableName: "Natural Color", hex: "6B841D", name: "6B841D"),
                    ItemColor(tableName: "Natural Color", hex: "9FDA67", name: "9FDA67"),
                    ItemColor(tableName: "Natural Color", hex: "4EC349", name: "4EC349"),
                    ItemColor(tableName: "Natural Color", hex: "038962", name: "038962"),
                    ItemColor(tableName: "Natural Color", hex: "275E3A", name: "275E3A")]
        case .Sky_Color:
            return [ItemColor(tableName: "Sky Color", hex: "D2FFF0", name: "D2FFF0"),
                    ItemColor(tableName: "Sky Color", hex: "AFFFE2", name: "AFFFE2"),
                    ItemColor(tableName: "Sky Color", hex: "2BD9C2", name: "2BD9C2"),
                    ItemColor(tableName: "Sky Color", hex: "6DC8C5", name: "6DC8C5"),
                    ItemColor(tableName: "Sky Color", hex: "1CA5AD", name: "1CA5AD"),
                    ItemColor(tableName: "Sky Color", hex: "085872", name: "085872"),
                    ItemColor(tableName: "Sky Color", hex: "3964B2", name: "3964B2"),
                    ItemColor(tableName: "Sky Color", hex: "002A47", name: "002A47"),
                    ItemColor(tableName: "Sky Color", hex: "B5F0FF", name: "B5F0FF"),
                    ItemColor(tableName: "Sky Color", hex: "73F8F7", name: "73F8F7"),
                    ItemColor(tableName: "Sky Color", hex: "88C6F2", name: "88C6F2"),
                    ItemColor(tableName: "Sky Color", hex: "0097DA", name: "0097DA"),
                    ItemColor(tableName: "Sky Color", hex: "39C1D7", name: "39C1D7"),
                    ItemColor(tableName: "Sky Color", hex: "649DED", name: "649DED"),
                    ItemColor(tableName: "Sky Color", hex: "207FAD", name: "207FAD"),
                    ItemColor(tableName: "Sky Color", hex: "242670", name: "242670")]
        case .Purple_Color:
            return [ItemColor(tableName: "Purple Color", hex: "F0CAFF", name: "F0CAFF"),
                    ItemColor(tableName: "Purple Color", hex: "CD80B2", name: "CD80B2"),
                    ItemColor(tableName: "Purple Color", hex: "CEBAEF", name: "CEBAEF"),
                    ItemColor(tableName: "Purple Color", hex: "A03DF2", name: "A03DF2"),
                    ItemColor(tableName: "Purple Color", hex: "AD7FFB", name: "AD7FFB"),
                    ItemColor(tableName: "Purple Color", hex: "6E4CDF", name: "6E4CDF"),
                    ItemColor(tableName: "Purple Color", hex: "C331F7", name: "C331F7"),
                    ItemColor(tableName: "Purple Color", hex: "7C55BF", name: "7C55BF"),
                    ItemColor(tableName: "Purple Color", hex: "C5A3BF", name: "C5A3BF"),
                    ItemColor(tableName: "Purple Color", hex: "AD69C0", name: "AD69C0"),
                    ItemColor(tableName: "Purple Color", hex: "9079AF", name: "9079AF"),
                    ItemColor(tableName: "Purple Color", hex: "6A20A5", name: "6A20A5"),
                    ItemColor(tableName: "Purple Color", hex: "754C82", name: "754C82"),
                    ItemColor(tableName: "Purple Color", hex: "611A87", name: "611A87"),
                    ItemColor(tableName: "Purple Color", hex: "892299", name: "892299"),
                    ItemColor(tableName: "Purple Color", hex: "360E46", name: "360E46")]
        case .Vintage:
            return [ItemColor(isPremium: false, tableName: "Vintage", hex: "E88D67", name: "E88D67"),
                    ItemColor(isPremium: false, tableName: "Vintage", hex: "F3F7EC", name: "F3F7EC"),
                    ItemColor(isPremium: false, tableName: "Vintage", hex: "3AA6B9", name: "3AA6B9"),
                    ItemColor(isPremium: false, tableName: "Vintage", hex: "005C78", name: "005C78"),
                    ItemColor(isPremium: false, tableName: "Vintage", hex: "FFD0D0", name: "FFD0D0"),
                    ItemColor(isPremium: false, tableName: "Vintage", hex: "FF9EAA", name: "FF9EAA"),
                    ItemColor(isPremium: false, tableName: "Vintage", hex: "254336", name: "254336"),
                    ItemColor(isPremium: false, tableName: "Vintage", hex: "F1E5D1", name: "F1E5D1"),
                    ItemColor(isPremium: false, tableName: "Vintage", hex: "987070", name: "987070"),
                    ItemColor(isPremium: false, tableName: "Vintage", hex: "799351", name: "799351"),
                    ItemColor(isPremium: false, tableName: "Vintage", hex: "A1DD70", name: "A1DD70"),
                    ItemColor(isPremium: false, tableName: "Vintage", hex: "EE4E4E", name: "EE4E4E"),
                    ItemColor(isPremium: false, tableName: "Vintage", hex: "F8D082", name: "F8D082"),
                    ItemColor(isPremium: false, tableName: "Vintage", hex: "EE4E4E", name: "EE4E4E"),
                    ItemColor(isPremium: false, tableName: "Vintage", hex: "F97300", name: "F97300"),
                    ItemColor(isPremium: false, tableName: "Vintage", hex: "FFC470", name: "FFC470")]
        case .Neon:
            return [ItemColor(isPremium: false, tableName: "Neon", hex: "C3FF93", name: "C3FF93"),
                    ItemColor(isPremium: false, tableName: "Neon", hex: "FF76CE", name: "FF76CE"),
                    ItemColor(isPremium: false, tableName: "Neon", hex: "FFDB5C", name: "FFDB5C"),
                    ItemColor(isPremium: false, tableName: "Neon", hex: "FDFFC2", name: "FDFFC2"),
                    ItemColor(isPremium: false, tableName: "Neon", hex: "94FFD8", name: "94FFD8"),
                    ItemColor(isPremium: false, tableName: "Neon", hex: "A3D8FF", name: "A3D8FF"),
                    ItemColor(isPremium: false, tableName: "Neon", hex: "FF70AB", name: "FF70AB"),
                    ItemColor(isPremium: false, tableName: "Neon", hex: "007F73", name: "007F73"),
                    ItemColor(isPremium: false, tableName: "Neon", hex: "26355D", name: "26355D"),
                    ItemColor(isPremium: false, tableName: "Neon", hex: "FF8F00", name: "FF8F00"),
                    ItemColor(isPremium: false, tableName: "Neon", hex: "FF8F00", name: "FF8F00"),
                    ItemColor(isPremium: false, tableName: "Neon", hex: "FFDB00", name: "FFDB00"),
                    ItemColor(isPremium: false, tableName: "Neon", hex: "FFFF80", name: "FFFF80"),
                    ItemColor(isPremium: false, tableName: "Neon", hex: "FFAA80", name: "FFAA80"),
                    ItemColor(isPremium: false, tableName: "Neon", hex: "FF5580", name: "FF5580"),
                    ItemColor(isPremium: false, tableName: "Neon", hex: "FF0080", name: "FF0080")]
        case .Warm:
            return [ItemColor(isPremium: false, tableName: "Warm", hex: "808836", name: "808836"),
                    ItemColor(isPremium: false, tableName: "Warm", hex: "FFBF00", name: "FFBF00"),
                    ItemColor(isPremium: false, tableName: "Warm", hex: "FF9A00", name: "FF9A00"),
                    ItemColor(isPremium: false, tableName: "Warm", hex: "D10363", name: "D10363"),
                    ItemColor(isPremium: false, tableName: "Warm", hex: "DBB5B5", name: "DBB5B5"),
                    ItemColor(isPremium: false, tableName: "Warm", hex: "C39898", name: "C39898"),
                    ItemColor(isPremium: false, tableName: "Warm", hex: "987070", name: "987070"),
                    ItemColor(isPremium: false, tableName: "Warm", hex: "6F4E37", name: "6F4E37"),
                    ItemColor(isPremium: false, tableName: "Warm", hex: "A67B5B", name: "A67B5B"),
                    ItemColor(isPremium: false, tableName: "Warm", hex: "ECB176", name: "ECB176"),
                    ItemColor(isPremium: false, tableName: "Warm", hex: "FFFF80", name: "FFFF80"),
                    ItemColor(isPremium: false, tableName: "Warm", hex: "FFAA80", name: "FFAA80"),
                    ItemColor(isPremium: false, tableName: "Warm", hex: "FF5580", name: "FF5580"),
                    ItemColor(isPremium: false, tableName: "Warm", hex: "FF5580", name: "FF5580"),
                    ItemColor(isPremium: false, tableName: "Warm", hex: "FF0080", name: "FF0080"),
                    ItemColor(isPremium: false, tableName: "Warm", hex: "F3CA52", name: "F3CA52")]
        case .Summer:
            return [ItemColor(tableName: "Summer", hex: "FFC470", name: "FFC470"),
                    ItemColor(tableName: "Summer", hex: "AFD198", name: "AFD198"),
                    ItemColor(tableName: "Summer", hex: "FA7070", name: "FA7070"),
                    ItemColor(tableName: "Summer", hex: "9CAFAA", name: "9CAFAA"),
                    ItemColor(tableName: "Summer", hex: "EE99C2", name: "EE99C2"),
                    ItemColor(tableName: "Summer", hex: "8CB9BD", name: "8CB9BD"),
                    ItemColor(tableName: "Summer", hex: "FF204E", name: "FF204E"),
                    ItemColor(tableName: "Summer", hex: "A0153E", name: "A0153E"),
                    ItemColor(tableName: "Summer", hex: "4CCD99", name: "4CCD99"),
                    ItemColor(tableName: "Summer", hex: "FF3EA5", name: "FF3EA5"),
                    ItemColor(tableName: "Summer", hex: "836FFF", name: "836FFF"),
                    ItemColor(tableName: "Summer", hex: "15F5BA", name: "15F5BA"),
                    ItemColor(tableName: "Summer", hex: "F6E9B2", name: "F6E9B2"),
                    ItemColor(tableName: "Summer", hex: "0A6847", name: "0A6847"),
                    ItemColor(tableName: "Summer", hex: "7ABA78", name: "7ABA78"),
                    ItemColor(tableName: "Summer", hex: "E65C19", name: "E65C19")]
        case .Cold:
            return [ItemColor(tableName: "Cold", hex: "050C9C", name: "050C9C"),
                    ItemColor(tableName: "Cold", hex: "3572EF", name: "3572EF"),
                    ItemColor(tableName: "Cold", hex: "3ABEF9", name: "3ABEF9"),
                    ItemColor(tableName: "Cold", hex: "A7E6FF", name: "A7E6FF"),
                    ItemColor(tableName: "Cold", hex: "615EFC", name: "615EFC"),
                    ItemColor(tableName: "Cold", hex: "7E8EF1", name: "7E8EF1"),
                    ItemColor(tableName: "Cold", hex: "344C64", name: "344C64"),
                    ItemColor(tableName: "Cold", hex: "577B8D", name: "577B8D"),
                    ItemColor(tableName: "Cold", hex: "CDE8E5", name: "CDE8E5"),
                    ItemColor(tableName: "Cold", hex: "EEF7FF", name: "EEF7FF"),
                    ItemColor(tableName: "Cold", hex: "8576FF", name: "8576FF"),
                    ItemColor(tableName: "Cold", hex: "7BC9FF", name: "7BC9FF"),
                    ItemColor(tableName: "Cold", hex: "A3FFD6", name: "A3FFD6"),
                    ItemColor(tableName: "Cold", hex: "98ABEE", name: "98ABEE"),
                    ItemColor(tableName: "Cold", hex: "1D24CA", name: "1D24CA"),
                    ItemColor(tableName: "Cold", hex: "BBE2EC", name: "BBE2EC")]
        case .Happy:
            return [ItemColor(tableName: "Happy", hex: "3AA6B9", name: "3AA6B9"),
                    ItemColor(tableName: "Happy", hex: "FFD0D0", name: "FFD0D0"),
                    ItemColor(tableName: "Happy", hex: "FF9EAA", name: "FF9EAA"),
                    ItemColor(tableName: "Happy", hex: "F9F9E0", name: "F9F9E0"),
                    ItemColor(tableName: "Happy", hex: "FFFDB5", name: "FFFDB5"),
                    ItemColor(tableName: "Happy", hex: "6FDCE3", name: "6FDCE3"),
                    ItemColor(tableName: "Happy", hex: "5C88C4", name: "5C88C4"),
                    ItemColor(tableName: "Happy", hex: "5C2FC2", name: "5C2FC2"),
                    ItemColor(tableName: "Happy", hex: "8E3E63", name: "8E3E63"),
                    ItemColor(tableName: "Happy", hex: "D2649A", name: "D2649A"),
                    ItemColor(tableName: "Happy", hex: "F6FAB9", name: "F6FAB9"),
                    ItemColor(tableName: "Happy", hex: "CAE6B2", name: "CAE6B2"),
                    ItemColor(tableName: "Happy", hex: "FFFF80", name: "FFFF80"),
                    ItemColor(tableName: "Happy", hex: "FFAA80", name: "FFAA80"),
                    ItemColor(tableName: "Happy", hex: "FF5580", name: "FF5580"),
                    ItemColor(tableName: "Happy", hex: "CAF4FF", name: "CAF4FF")]
        case .ClearColor:
            return [ItemColor(tableName: "ClearColor", hex: "FFFFFE", name: "FFFFFE")]
        }
    }
    
}
