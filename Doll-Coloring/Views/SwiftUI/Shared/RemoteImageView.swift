//
//  RemoteImageView.swift
//  Doll-Coloring
//

import SwiftUI
import SDWebImage

struct RemoteImageView: UIViewRepresentable {
    let urlString: String?
    var contentMode: UIView.ContentMode = .scaleAspectFill
    var backgroundColor: UIColor = UIColor(white: 0.95, alpha: 1)

    func makeUIView(context: Context) -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = contentMode
        imageView.clipsToBounds = true
        imageView.backgroundColor = backgroundColor
        // Pass taps through to the SwiftUI Button / onTapGesture parent.
        imageView.isUserInteractionEnabled = false
        // Let SwiftUI `.frame` drive size (default hugging collapses UIImageView).
        imageView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        imageView.setContentHuggingPriority(.defaultLow, for: .vertical)
        imageView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        imageView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        return imageView
    }

    func updateUIView(_ uiView: UIImageView, context: Context) {
        uiView.contentMode = contentMode
        uiView.backgroundColor = backgroundColor
        uiView.isUserInteractionEnabled = false

        // Local file path
        if let urlString, (urlString.hasPrefix("/") || FileManager.default.fileExists(atPath: urlString)),
           !urlString.hasPrefix("http") {
            uiView.sd_cancelCurrentImageLoad()
            uiView.image = UIImage(contentsOfFile: urlString)
            return
        }

        // Same resolution path as UIImageView.setImage(with:)
        SDWebImageDownloader.shared.setValue(apiAccessKey, forHTTPHeaderField: "AccessKey")
        guard let resolved = ColoringCDN.resolveImageURL(urlString) else {
            uiView.sd_cancelCurrentImageLoad()
            uiView.image = nil
            return
        }

        // Avoid reloading the same URL on every SwiftUI refresh.
        if context.coordinator.lastURL == resolved {
            return
        }
        context.coordinator.lastURL = resolved
        uiView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        uiView.sd_setImage(with: resolved, placeholderImage: nil, options: [.retryFailed])
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    final class Coordinator {
        var lastURL: URL?
    }
}
