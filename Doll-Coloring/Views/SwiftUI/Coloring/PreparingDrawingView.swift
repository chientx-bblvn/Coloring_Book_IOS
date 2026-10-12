//
//  PreparingDrawingView.swift
//  Doll-Coloring
//

import SwiftUI
import UIKit
import Lottie
import SVGKit
import SDWebImage

// MARK: - Host

final class PreparingDrawingHostController: UIHostingController<PreparingDrawingView> {
    private let viewModel: PreparingDrawingViewModel

    init(viewModel: PreparingDrawingViewModel) {
        self.viewModel = viewModel
        super.init(rootView: PreparingDrawingView(viewModel: viewModel))
        modalPresentationStyle = .fullScreen
        view.backgroundColor = .clear
        viewModel.attach(host: self)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - View

struct PreparingDrawingView: View {
    @ObservedObject var viewModel: PreparingDrawingViewModel

    private let titleText = "Coloring.PreparingDrawing".localizedString(
        tableName: "Localizable",
        defaultValue: "Preparing your drawing…",
        comment: "Preparing coloring page loading title"
    )

    var body: some View {
        ZStack {
            background

            VStack(spacing: 0) {
                Spacer(minLength: 24)

                Text(titleText)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(Color.appPrimary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 28)

                LottieLoopView(name: "animation_loading_preview")
                    .frame(width: 88, height: 72)
                    .padding(.top, 8)

                artworkCard
                    .padding(.top, 16)

                Spacer(minLength: 24)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.horizontal, 48)
        }
        .ignoresSafeArea(edges: .bottom)
        .onAppear { viewModel.start() }
        .onDisappear { viewModel.cancel() }
    }

    private var background: some View {
        Group {
            if UIImage(named: "start_coloring_loading_bg") != nil {
                Image("start_coloring_loading_bg")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
            } else {
                Color.appBackground.ignoresSafeArea()
            }
        }
    }

    @ViewBuilder
    private var artworkCard: some View {
        let shape = RoundedRectangle(cornerRadius: 16, style: .continuous)

        Group {
            if let image = viewModel.previewImage {
                let ratio = image.size.width / max(image.size.height, 1)
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(ratio, contentMode: .fit)
            } else if let url = viewModel.remotePreviewURL {
                RemoteImageView(urlString: url, contentMode: .scaleAspectFit, backgroundColor: .clear)
                    .aspectRatio(3 / 4, contentMode: .fit)
            } else {
                Color.white.opacity(0.35)
                    .aspectRatio(3 / 4, contentMode: .fit)
            }
        }
        .frame(maxWidth: .infinity)
        .overlay {
            ArtworkShimmerOverlay()
                .clipShape(shape)
        }
        .clipShape(shape)
        .compositingGroup()
        .shadow(color: Color.black.opacity(0.08), radius: 8, y: 4)
        .frame(maxWidth: 280)
        .frame(maxWidth: .infinity) // center the compact card
    }
}

// MARK: - Shimmer (clipped by parent)

private struct ArtworkShimmerOverlay: View {
    @State private var move = false

    var body: some View {
        GeometryReader { geo in
            let band = max(geo.size.width * 0.42, 72)
            LinearGradient(
                colors: [
                    .white.opacity(0),
                    .white.opacity(0.55),
                    Color.appPrimarySoft.opacity(0.4),
                    .white.opacity(0.55),
                    .white.opacity(0)
                ],
                startPoint: .leading,
                endPoint: .trailing
            )
            .frame(width: band, height: geo.size.height)
            .offset(x: move ? geo.size.width : -band)
            .onAppear {
                withAnimation(.linear(duration: 1.25).repeatForever(autoreverses: false)) {
                    move = true
                }
            }
        }
        .allowsHitTesting(false)
    }
}

// MARK: - Lottie

private struct LottieLoopView: UIViewRepresentable {
    let name: String

    func makeUIView(context: Context) -> UIView {
        let container = UIView()
        container.backgroundColor = .clear

        let animation = LottieAnimationView()
        animation.backgroundColor = .clear
        animation.contentMode = .scaleAspectFit
        animation.loopMode = .loop
        animation.backgroundBehavior = .pauseAndRestore
        animation.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(animation)

        NSLayoutConstraint.activate([
            animation.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            animation.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            animation.topAnchor.constraint(equalTo: container.topAnchor),
            animation.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])

        animation.loadAnimation(file: name, loopMode: .loop, autoPlay: true, animationSpeed: 1.2)
        context.coordinator.animationView = animation
        return container
    }

    func updateUIView(_ uiView: UIView, context: Context) {}

    func makeCoordinator() -> Coordinator { Coordinator() }

    final class Coordinator {
        var animationView: LottieAnimationView?
    }
}

// MARK: - ViewModel

final class PreparingDrawingViewModel: ObservableObject {
    @Published var previewImage: UIImage?
    @Published var remotePreviewURL: String?

    let coloring: ColoringImage?
    var coloringLocal: ColoringHistoryModel?
    let history: HistoryModel?
    let typeScreen: BackToScreenType

    private weak var host: UIViewController?
    private var downloadManager = DownloadManager()
    private var coloringBookView: ColoringBookView?
    private var didStart = false
    private var isCancelled = false

    init(
        coloring: ColoringImage?,
        coloringLocal: ColoringHistoryModel?,
        history: HistoryModel?,
        typeScreen: BackToScreenType
    ) {
        self.coloring = coloring
        self.coloringLocal = coloringLocal
        self.history = history
        self.typeScreen = typeScreen
    }

    func attach(host: UIViewController) {
        self.host = host
    }

    func start() {
        guard !didStart else { return }
        didStart = true
        isCancelled = false
        downloadManager.processDelegate = self
        resolvePreview()
        beginPrepare()
    }

    func cancel() {
        isCancelled = true
    }

    private func resolvePreview() {
        if let coloringLocal {
            let savePath = FileManagerLocal.shared
                .getFileFoderFileUssing(typeFile: .ColoringSave, file: history?.imagePath ?? "")
                .path
            if let img = UIImage(contentsOfFile: savePath) {
                previewImage = img
                return
            }
            let localPath = FileManagerLocal.shared
                .getFileFoderFileUssing(typeFile: .Coloring, file: coloringLocal.fileLocal)
                .path
            if let img = UIImage(contentsOfFile: localPath) {
                previewImage = img
                return
            }
            if let svg = SVGKImage(contentsOfFile: localPath)?.uiImage {
                previewImage = svg
                return
            }
        }

        if let filePreview = coloring?.filePreview, !filePreview.isEmpty {
            remotePreviewURL = filePreview
        } else if let path = coloring?.filePath, !path.isEmpty {
            remotePreviewURL = path
        }
    }

    private func beginPrepare() {
        if let coloringLocal {
            let localPath = FileManagerLocal.shared
                .getFileFoderFileUssing(typeFile: .Coloring, file: coloringLocal.fileLocal)
                .path
            if let image = UIImage(contentsOfFile: localPath) {
                createColoringBookView(with: image)
                return
            }
            if let svg = SVGKImage(contentsOfFile: localPath)?.uiImage {
                createColoringBookView(with: svg)
                return
            }
        }

        let path = baseURLImage + (coloring?.filePath ?? "")
        downloadImageColor(linkDowload: path)
    }

    private func downloadImageColor(linkDowload: String) {
        downloadManager.coloringLocal = coloringLocal
        downloadManager.isTheme = false
        let fileTo = FileManagerLocal.shared.getFileFoderFileUssing(typeFile: .Coloring)
        let indexName = FileManagerLocal.shared.getFileInDoucment(url: fileTo)
            .sorted(by: {
                ($0 as NSString).deletingPathExtension
                    .compare(($1 as NSString).deletingPathExtension, options: .numeric) == .orderedAscending
            })
            .last?
            .replacingOccurrences(of: ".png", with: "")
            .replacingOccurrences(of: ".svg", with: "")

        let fileName: String
        if linkDowload.contains(".png") {
            fileName = fileTo.lastPathComponent + "\((Int(String(indexName?.extractNumbers() ?? "0")) ?? 0) + 1).png"
        } else {
            fileName = fileTo.lastPathComponent + "\((Int(String(indexName?.extractNumbers() ?? "0")) ?? 0) + 1).svg"
        }
        downloadManager.fileTo = fileTo.appendingPathComponent(fileName)

        let completion = BlockOperation { [weak self] in
            DispatchQueue.main.async {
                guard let self, !self.isCancelled else { return }
                let file = SQLiteManager.shared.selectionColorings().first(where: { $0.fileLocal.contains(fileName) })
                self.coloringLocal = file
                if let coloring = file {
                    let path = FileManagerLocal.shared
                        .getFileFoderFileUssing(typeFile: .Coloring, file: coloring.fileLocal)
                        .path
                    if let img = UIImage(contentsOfFile: path) {
                        self.previewImage = img
                        self.createColoringBookView(with: img)
                        return
                    }
                    if let svg = SVGKImage(contentsOfFile: path)?.uiImage {
                        self.previewImage = svg
                        self.createColoringBookView(with: svg)
                        return
                    }
                }
                self.failAndDismiss()
            }
        }

        guard let url = URL(string: linkDowload) else {
            failAndDismiss()
            return
        }
        let downloadOperation = downloadManager.addDownload(url)
        completion.addDependency(downloadOperation)
        OperationQueue.main.addOperation(completion)
    }

    private func createColoringBookView(with image: UIImage, optimized: Bool = true) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            let coloringImage = ColoringImageBook(from: image, optimized: optimized)
            DispatchQueue.main.async {
                guard let self, !self.isCancelled else { return }
                self.coloringBookView = ColoringBookView(coloringImage: coloringImage)
                self.finishAndOpenColoring()
            }
        }
    }

    private func finishAndOpenColoring() {
        guard let coloringLocal, let coloringBookView else { return }
        let route = StartColoringRoute.startColoring(
            coloringLocal: coloringLocal,
            history: history,
            typeScreen: typeScreen,
            coloringBookView: coloringBookView
        )

        let openColoring: () -> Void = { [weak self] in
            AppRouter.shared.navigate(to: route, with: .push)
            self?.host = nil
        }

        // Prefer dismissing the preparing host directly — AppRouter.currentViewController
        // may be stale when ColorFlowPresenter presents outside AppRouter.navigate.
        if let host {
            host.dismiss(animated: false, completion: openColoring)
        } else if let top = UIApplication.topViewController() {
            top.dismiss(animated: false, completion: openColoring)
        } else {
            AppRouter.shared.dismiss(animated: false, completion: openColoring)
        }
    }

    private func failAndDismiss() {
        guard !isCancelled else { return }
        isCancelled = true
        let message = "Couldn't load this drawing. Please try again."
        let dismissHost = { [weak self] in
            self?.host?.dismiss(animated: true)
            self?.host = nil
        }
        if let host {
            let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in dismissHost() })
            host.present(alert, animated: true)
        } else {
            dismissHost()
        }
    }
}

extension PreparingDrawingViewModel: DownloadProcessProtocol {
    func downloadingProgress(_ percent: Float, fileName: String) {}
    func downloadSucceeded(_ fileName: String) {}
    func downloadWithError(_ error: Error?, fileName: String) {
        DispatchQueue.main.async { [weak self] in
            self?.failAndDismiss()
        }
    }
}
