//
//  AppNavigator.swift
//  Doll-Coloring
//

import SwiftUI
import Combine

enum NavigationDestination: Hashable, Identifiable {
    case splash
    case language
    case intro
    case home
    case checkIn
    case settingsLanguage

    var id: String {
        switch self {
        case .splash: return "splash"
        case .language: return "language"
        case .intro: return "intro"
        case .home: return "home"
        case .checkIn: return "checkIn"
        case .settingsLanguage: return "settingsLanguage"
        }
    }
}

@MainActor
final class AppNavigator: ObservableObject {
    @Published var root: NavigationDestination = .splash
    @Published var path: [NavigationDestination] = []

    func replace(with destination: NavigationDestination) {
        path = []
        root = destination
    }

    func push(_ destination: NavigationDestination) {
        path.append(destination)
    }

    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }

    func popToRoot() {
        path.removeAll()
    }

    func popToHome() {
        MainTabStore.shared.selectedTab = .coloringBooks
        replace(with: .home)
    }
}
