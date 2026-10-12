//
//  ColorFlowPresenter.swift
//  Doll-Coloring
//

import UIKit

/// Bridges SwiftUI → existing UIKit coloring routes (Preview / History / StartColoring).
@MainActor
final class ColorFlowPresenter {
    static let shared = ColorFlowPresenter()

    private weak var navigator: AppNavigator?

    private init() {}

    func bind(navigator: AppNavigator) {
        self.navigator = navigator
        AppRouterBridge.shared.navigator = navigator
    }

    func openColoring(_ data: ColoringImage, typeScreen: BackToScreenType = .home) {
        if data.isPremium == true, !IAPState.isUserVip {
            SubcriptionViewController.show(checkTime: true, handler: {}, onClickCLose: {})
            return
        }

        let local: ColoringHistoryModel? = {
            guard let path = data.filePath?.components(separatedBy: "/").last else { return nil }
            return SQLiteManager.shared.selectionColorings().first(where: { $0.filePath.contains(path) })
        }()
        let route = Self.route(api: data, local: local, typeScreen: typeScreen)

        // Present from the visible SwiftUI host — AppRouter modal can no-op if top VC is stale.
        let viewController = route.screen
        viewController.modalPresentationStyle = .overFullScreen
        guard let top = UIApplication.topViewController() else {
            AppRouter.shared.navigate(to: route, with: .modal)
            return
        }
        top.present(viewController, animated: true)
        // Keep AppRouter in sync so Preparing → StartColoring dismiss/navigate still works.
        AppRouter.shared.currentViewController = viewController
    }

    /// History (Continue) only when there is progress > 0%; otherwise start a new drawing.
    static func route(
        api: ColoringImage,
        local: ColoringHistoryModel?,
        typeScreen: BackToScreenType
    ) -> Route {
        if let local, local.hasResumableHistory {
            return HistoryColoringRoute.main(coloring: local, typeScreen: typeScreen, coloringAPI: api)
        }
        return PreviewColoringRoute.main(
            coloring: api,
            coloringLocal: local,
            history: nil,
            typeScreen: typeScreen
        )
    }

    func openHistory(_ coloring: ColoringHistoryModel, history: HistoryModel?, typeScreen: BackToScreenType = .home) {
        AppRouter.shared.navigate(
            to: PreviewColoringRoute.main(coloring: nil, coloringLocal: coloring, history: history, typeScreen: typeScreen),
            with: .modal
        )
    }

    func showComeBackTomorrow() {
        AppRouter.shared.navigate(to: HomeRoute.showCombackTomorrow, with: .modal, animated: false)
    }

    func showGiftPopup(name: String) {
        AppRouter.shared.navigate(to: CheckInRoute.gitPopup(name: name), with: .modal)
    }
}

/// Lets UIKit coloring VCs return to the SwiftUI home shell without MainTabbarViewController.
@MainActor
final class AppRouterBridge {
    static let shared = AppRouterBridge()
    weak var navigator: AppNavigator?

    private init() {}

    func popToHomeShell() {
        dismissAllPresented {
            self.navigator?.popToHome()
        }
    }

    private func dismissAllPresented(completion: @escaping () -> Void) {
        guard let root = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .flatMap({ $0.windows })
            .first(where: { $0.isKeyWindow })?
            .rootViewController else {
            completion()
            return
        }
        if root.presentedViewController != nil {
            root.dismiss(animated: true, completion: completion)
        } else {
            completion()
        }
    }
}
