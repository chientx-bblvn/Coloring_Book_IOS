//
//  UIKitHostNavController.swift
//  Doll-Coloring
//

import UIKit
import SwiftUI

/// Holds a UINavigationController that sits under the SwiftUI window for UIKit push flows
/// (StartColoring, DetailCollection, etc.).
@MainActor
final class UIKitHostNavController {
    static let shared = UIKitHostNavController()

    let navigationController: UINavigationController

    private init() {
        let placeholder = UIViewController()
        placeholder.view.backgroundColor = .clear
        navigationController = UINavigationController(rootViewController: placeholder)
        navigationController.isNavigationBarHidden = true
        navigationController.view.isUserInteractionEnabled = false
        navigationController.view.backgroundColor = .clear
    }

    func attachIfNeeded(to window: UIWindow?) {
        guard let window else { return }
        // Ensure AppRouter can push onto a live nav stack that is part of the key window hierarchy.
        if AppRouter.shared.rootViewController !== navigationController {
            AppRouter.shared.rootViewController = navigationController
        }
        // Prefer resolving presentation from the actual SwiftUI root.
        _ = window
    }
}
