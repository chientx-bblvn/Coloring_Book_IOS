//
//  CheckInRepresentable.swift
//  Doll-Coloring
//

import SwiftUI

/// Keeps the existing Check-in UIKit screen while the app shell is SwiftUI.
struct CheckInRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        CheckInRoute.main.screen
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}
