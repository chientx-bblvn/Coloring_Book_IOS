//
//  MainTab.swift
//  Doll-Coloring
//

import SwiftUI
import Combine

enum MainTab: String, CaseIterable, Identifiable {
    case coloringBooks
    case collections
    case settings

    var id: String { rawValue }

    var title: String {
        switch self {
        case .coloringBooks: return LocalizableUtils.commonColoringBooks()
        case .collections: return LocalizableUtils.commonCollections()
        case .settings: return LocalizableUtils.commonSettings()
        }
    }

    var iconName: String {
        switch self {
        case .coloringBooks: return "ic_diary_dark"
        case .collections: return "ic_collection_dark"
        case .settings: return "ic_setting_dark"
        }
    }

    var systemImage: String {
        switch self {
        case .coloringBooks: return "paintpalette.fill"
        case .collections: return "square.grid.2x2.fill"
        case .settings: return "gearshape.fill"
        }
    }
}

@MainActor
final class MainTabStore: ObservableObject {
    static let shared = MainTabStore()

    @Published var selectedTab: MainTab = .coloringBooks

    private init() {}

    func select(_ tab: MainTab) {
        guard selectedTab != tab else { return }
        selectedTab = tab
    }
}
