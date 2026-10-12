//
//  MainTabShellView.swift
//  Doll-Coloring
//

import SwiftUI

struct MainTabShellView: View {
    @ObservedObject private var tabStore = MainTabStore.shared

    private let accent = Color.appPrimary

    var body: some View {
        Group {
            if #available(iOS 26.0, *) {
                liquidGlassTabView
            } else {
                legacyTabView
            }
        }
        .tint(accent)
        .toolbar(.hidden, for: .navigationBar)
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("GOTOHOME_TABBAR"))) { _ in
            tabStore.select(.coloringBooks)
        }
    }

    /// Native TabView — Liquid Glass is automatic on iOS 26+.
    @available(iOS 26.0, *)
    private var liquidGlassTabView: some View {
        TabView(selection: $tabStore.selectedTab) {
            Tab(MainTab.coloringBooks.title, systemImage: MainTab.coloringBooks.systemImage, value: .coloringBooks) {
                HomeView()
            }
            Tab(MainTab.collections.title, systemImage: MainTab.collections.systemImage, value: .collections) {
                CollectionsView()
            }
            Tab(MainTab.settings.title, systemImage: MainTab.settings.systemImage, value: .settings) {
                SettingsView()
            }
        }
        .tabBarMinimizeBehavior(.onScrollDown)
    }

    private var legacyTabView: some View {
        TabView(selection: $tabStore.selectedTab) {
            HomeView()
                .tabItem {
                    Label(MainTab.coloringBooks.title, systemImage: MainTab.coloringBooks.systemImage)
                }
                .tag(MainTab.coloringBooks)

            CollectionsView()
                .tabItem {
                    Label(MainTab.collections.title, systemImage: MainTab.collections.systemImage)
                }
                .tag(MainTab.collections)

            SettingsView()
                .tabItem {
                    Label(MainTab.settings.title, systemImage: MainTab.settings.systemImage)
                }
                .tag(MainTab.settings)
        }
    }
}
