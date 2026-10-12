//
//  NavigationContainer.swift
//  Doll-Coloring
//

import SwiftUI

struct NavigationContainer: View {
    @StateObject private var navigator = AppNavigator()
    @ObservedObject private var tabStore = MainTabStore.shared
    let initialRoot: NavigationDestination

    init(root: NavigationDestination = .splash) {
        self.initialRoot = root
    }

    var body: some View {
        NavigationStack(path: $navigator.path) {
            destinationView(for: navigator.root)
                .id(navigator.root.id)
                .navigationDestination(for: NavigationDestination.self) { destination in
                    destinationView(for: destination)
                        .toolbar(.hidden, for: .navigationBar)
                }
        }
        .environmentObject(navigator)
        .environmentObject(tabStore)
        .toolbar(.hidden, for: .navigationBar)
        .onAppear {
            if navigator.root == .splash, initialRoot != .splash {
                navigator.root = initialRoot
            }
            ColorFlowPresenter.shared.bind(navigator: navigator)
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("SWIFTUI_POP_TO_HOME"))) { _ in
            navigator.popToHome()
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("SWIFTUI_POP_CHECKIN"))) { _ in
            if navigator.path.last == .checkIn {
                navigator.pop()
            }
        }
    }

    @ViewBuilder
    private func destinationView(for destination: NavigationDestination) -> some View {
        switch destination {
        case .splash:
            SplashView()
        case .language:
            LanguageView(goFrom: .intro)
        case .intro:
            IntroView()
        case .home:
            MainTabShellView()
        case .checkIn:
            CheckInRepresentable()
                .ignoresSafeArea()
                .navigationBarHidden(true)
        case .settingsLanguage:
            LanguageView(goFrom: .setting)
        }
    }
}
