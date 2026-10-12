//
//  DollColoringApp.swift
//  Doll-Coloring
//

import SwiftUI

@main
struct DollColoringApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            NavigationContainer(root: .splash)
                .preferredColorScheme(.light)
        }
    }
}
