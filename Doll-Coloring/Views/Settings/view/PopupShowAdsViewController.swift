//
//  PopupShowAdsViewController.swift
//  Doll-Coloring
//
//  Stub to satisfy R.swift / Settings storyboard identifiers after ads cleanup.
//

import UIKit

final class PopupShowAdsViewController: UIViewController {
    static func show(in parent: UIViewController, data: ColoringImage, _ onSuccess: @escaping () -> Void, _ onFail: @escaping () -> Void) {
        onSuccess()
    }
}