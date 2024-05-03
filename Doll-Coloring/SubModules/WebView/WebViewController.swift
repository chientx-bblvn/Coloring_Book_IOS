//
//  WebViewController.swift
// Doll-Coloring
//
//  Created by BBLabs on 11/04/2023.
//  Copyright ©2023. All rights reserved.
//

import Foundation
import RxSwift
import UIKit
import WebKit

class WebViewController: BaseViewController {
    
    fileprivate var titleView = ""
    fileprivate var contentURL: URL?
    fileprivate var contentHtml: String?
    
    @IBOutlet private weak var topBarView: TopBarView!
    @IBOutlet private weak var webviewContent: WKWebView!
    
    class func showWeb(title: String, url: URL?, html: String? = nil) {
        AppRouter.shared.navigate(to: WebViewRoute.webview(title: title, url: url, html: html), with: .modal)
    }
    
    // MARK: - Setup controller and IBAction
    override func setup() {
        super.setup()
        setupView()
    }
    
    override func bindingData() {
        super.bindingData()
        loadText()
    }
   
    // MARK: - Language change event
    override func onLanguageChange() {
        super.onLanguageChange()
        loadText()
    }
    
}

// MARK: - Action view
extension WebViewController {
    
}

// MARK: - Setup view
extension WebViewController {
    
    private func setupView() {
        topBarView.onRightClick = {
            AppRouter.shared.dismiss()
        }
        
        webviewContent.scrollView.showsVerticalScrollIndicator = false
        webviewContent.scrollView.showsHorizontalScrollIndicator = false
        webviewContent.scrollView.alwaysBounceHorizontal = false
        
        if let url = contentURL {
            webviewContent.load(URLRequest(url: url))
        }
        if let html = contentHtml {
            webviewContent.loadHTMLString(html, baseURL: nil)
        }
    }
    
    private func loadText() {
        topBarView.title = titleView
    }
    
}

enum WebViewRoute: Route {
    case webview(title: String, url: URL?, html: String? = nil)

    var screen: UIViewController {
        switch self {
        case let .webview(title, url, html):
            let webview = WebViewController.loadController()
            webview.titleView = title
            webview.contentURL = url
            webview.contentHtml = html
            return webview
        }
    }
}
