//
//  PreviewColoringController.swift
//  Doll-Coloring
//
//  Legacy storyboard entry — preparing UI now lives in PreparingDrawingView (SwiftUI).
//  Kept so R.storyboard / old refs still compile; prefer PreviewColoringRoute.
//

import UIKit

/// Prefer `PreparingDrawingHostController` via `PreviewColoringRoute`.
class PreviewColoringController: BaseViewController {
    var viewModel: PreviewColoringVM!

    override func setup() {
        super.setup()
        // Redirect any accidental storyboard instantiation to the SwiftUI host.
        let host = PreparingDrawingHostController(
            viewModel: PreparingDrawingViewModel(
                coloring: viewModel?.coloring,
                coloringLocal: viewModel?.coloringLocal,
                history: viewModel?.history,
                typeScreen: viewModel?.typeScreen ?? .home
            )
        )
        addChild(host)
        view.addSubview(host.view)
        host.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            host.view.topAnchor.constraint(equalTo: view.topAnchor),
            host.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            host.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            host.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        host.didMove(toParent: self)
    }
}
