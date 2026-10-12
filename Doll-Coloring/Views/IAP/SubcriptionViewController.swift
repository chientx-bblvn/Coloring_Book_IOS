//
//  SubcriptionViewController.swift
//  Doll-Coloring
//
//  Thin UIKit entry point — UI lives in SwiftUI `SubscriptionView`.
//

import Foundation

enum SubcriptionViewController {
    static func show(
        checkTime: Bool,
        handler: (() -> Void)? = nil,
        onClickCLose: (() -> Void)? = nil
    ) {
        Task { @MainActor in
            SubscriptionPresenter.show(
                checkTime: checkTime,
                handler: handler,
                onClickCLose: onClickCLose
            )
        }
    }
}
