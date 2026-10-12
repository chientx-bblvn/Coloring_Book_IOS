//
//  HistoryColoringView.swift
//  Doll-Coloring
//
//  SwiftUI History popup — Create New + Continue (saved pages).
//  Open canvas Preview to iterate layout in Xcode.
//

import SwiftUI

// MARK: - Display model

struct HistoryPageItem: Identifiable, Equatable {
    let id: Int
    let imagePath: String?
    let previewImage: UIImage?
    /// 0...1
    let progress: Double

    var percentText: String {
        "\(Int((progress * 100).rounded()))%"
    }
}

// MARK: - View

struct HistoryColoringView: View {
    let title: String
    let createTitle: String
    let continueTitle: String
    let pages: [HistoryPageItem]
    var onCreateNew: () -> Void = {}
    var onSelectPage: (Int) -> Void = { _ in }
    var onClose: () -> Void = {}

    @State private var selectedPage: Int = 0

    var body: some View {
        ZStack {
            Color.black.opacity(0.35)
                .ignoresSafeArea()
                .onTapGesture(perform: onClose)

            card
                .padding(.horizontal, 28)
                .padding(.vertical, 40)
        }
    }

    private var card: some View {
        ZStack(alignment: .topTrailing) {
            VStack(spacing: 14) {
                Text(title)
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundStyle(Color.appText)
                    .padding(.top, 22)

                createNewCard

                continueCard
                    .padding(.bottom, 18)
            }
            .padding(.horizontal, 16)

            closeButton
                .padding(12)
                .zIndex(10)
        }
        .frame(maxWidth: 360)
        .background {
            ZStack {
                Color.appBackground
                if let paper = UIImage(named: "history_popup_paper") {
                    Image(uiImage: paper)
                        .resizable()
                        .scaledToFill()
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                }
            }
            .clipped()
        }
        .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .stroke(Color.appBorder, lineWidth: 1)
        )
        .shadow(color: Color.appText.opacity(0.12), radius: 18, y: 8)
    }

    // MARK: - Create New

    private var createNewCard: some View {
        Button(action: onCreateNew) {
            HStack(spacing: 12) {
                Text(createTitle)
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundStyle(Color.appPrimary)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Group {
                    if let bunny = UIImage(named: "history_create_bunny_plus") {
                        Image(uiImage: bunny)
                            .resizable()
                            .scaledToFit()
                    } else {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 44))
                            .foregroundStyle(Color.appPrimary)
                    }
                }
                .frame(width: 78, height: 78)
            }
            .padding(.leading, 18)
            .padding(.trailing, 10)
            .padding(.vertical, 8)
            .background(Color.appPrimarySoft)
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .stroke(Color.appBorder, lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }

    // MARK: - Continue

    private var continueCard: some View {
        ZStack(alignment: .bottomLeading) {
            VStack(spacing: 10) {
                Text(continueTitle)
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundStyle(Color.appPrimary)
                    .padding(.top, 14)

                if pages.isEmpty {
                    emptyContinue
                } else {
                    pageCarousel
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 12)

            if let corner = UIImage(named: "history_corner_bunny") {
                Image(uiImage: corner)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .allowsHitTesting(false)
            }
        }
        .background(Color.appSurface.opacity(0.9))
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(Color.appBorder, lineWidth: 1)
        )
    }

    private var emptyContinue: some View {
        VStack(spacing: 8) {
            Image(systemName: "photo.on.rectangle.angled")
                .font(.system(size: 28))
                .foregroundStyle(Color.appTextSecondary)
            Text("No saved pages yet")
                .font(.system(size: 13, weight: .medium, design: .rounded))
                .foregroundStyle(Color.appTextSecondary)
        }
        .frame(height: 200)
    }

    private var pageCarousel: some View {
        TabView(selection: $selectedPage) {
            ForEach(Array(pages.enumerated()), id: \.element.id) { index, page in
                Button {
                    onSelectPage(index)
                } label: {
                    pageThumb(page)
                }
                .buttonStyle(.plain)
                .tag(index)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: pages.count > 1 ? .automatic : .never))
        .frame(height: 220)
    }

    private func pageThumb(_ page: HistoryPageItem) -> some View {
        ZStack(alignment: .topLeading) {
            Group {
                if let image = page.previewImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                } else if let path = page.imagePath, !path.isEmpty {
                    RemoteImageView(
                        urlString: localSavePath(for: path),
                        contentMode: .scaleAspectFit,
                        backgroundColor: UIColor(hexString: AppTheme.surfaceHex)
                    )
                    .allowsHitTesting(false)
                } else {
                    Color.appPrimarySoft
                        .overlay {
                            Image(systemName: "paintbrush.pointed")
                                .font(.system(size: 28))
                                .foregroundStyle(Color.appPrimary.opacity(0.5))
                        }
                }
            }
            .frame(width: 180, height: 180)
            .background(Color.appSurface)
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .stroke(Color.appPrimary, lineWidth: 2.5)
            )
            .shadow(color: Color.appText.opacity(0.08), radius: 4, y: 2)

            progressBadge(progress: page.progress, text: page.percentText)
                .offset(x: -8, y: -8)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func progressBadge(progress: Double, text: String) -> some View {
        ZStack {
            Circle()
                .fill(Color.appSurface)
                .overlay(
                    Circle()
                        .stroke(Color.appBorder, lineWidth: 1)
                )

            Circle()
                .stroke(Color.appPrimary.opacity(0.16), lineWidth: 4)
                .padding(4)

            Circle()
                .trim(from: 0, to: CGFloat(min(max(progress, 0), 1)))
                .stroke(
                    AngularGradient(
                        colors: [Color.appPrimary.opacity(0.45), Color.appPrimary],
                        center: .center
                    ),
                    style: StrokeStyle(lineWidth: 4, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .padding(4)

            Text(text)
                .font(.system(size: 12, weight: .heavy, design: .rounded))
                .foregroundStyle(Color.appPrimary)
                .minimumScaleFactor(0.7)
                .lineLimit(1)
        }
        .frame(width: 46, height: 46)
        .shadow(color: Color.appText.opacity(0.14), radius: 5, y: 2)
    }

    private var closeButton: some View {
        Button(action: onClose) {
            Image(systemName: "xmark")
                .font(.system(size: 12, weight: .bold))
                .foregroundStyle(Color.appPrimary)
                .frame(width: 44, height: 44)
                .contentShape(Rectangle())
                .background(Color.appPrimarySoft)
                .clipShape(Circle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Close")
    }

    private func localSavePath(for file: String) -> String {
        FileManagerLocal.shared.getFileFoderFileUssing(typeFile: .ColoringSave, file: file).path
    }
}

// MARK: - UIKit bridge (present from HistoryColoringRoute)

enum HistoryColoringPresenter {
    @MainActor
    static func makeHostingController(
        coloring: ColoringHistoryModel,
        coloringAPI: ColoringImage,
        typeScreen: BackToScreenType
    ) -> UIViewController {
        // Skip 0% pages — only show resumable progress under Continue.
        let pages: [HistoryPageItem] = coloring.historys.enumerated().compactMap { index, history in
            guard history.isResumable else { return nil }
            let path = history.imagePath
            let fileURL = FileManagerLocal.shared.getFileFoderFileUssing(typeFile: .ColoringSave, file: path)
            let image = UIImage(contentsOfFile: fileURL.path)
            return HistoryPageItem(
                id: index,
                imagePath: path,
                previewImage: image,
                progress: history.percent_complete ?? 0
            )
        }

        /// Keeps a strong ref to the presented host so close/create can dismiss it
        /// without relying on `AppRouter.currentViewController` (often stale in SwiftUI).
        final class HostBox {
            weak var controller: UIViewController?
        }
        let box = HostBox()

        let dismissHost: (Bool, (() -> Void)?) -> Void = { animated, completion in
            if let host = box.controller {
                host.dismiss(animated: animated, completion: completion)
            } else {
                UIApplication.topViewController()?.dismiss(animated: animated, completion: completion)
            }
        }

        let root = HistoryColoringView(
            title: LocalizableUtils.commonHistory(),
            createTitle: LocalizableUtils.commonCreateNew(),
            continueTitle: "Common.ContinueColoring".localizedString(
                tableName: "Localizable",
                defaultValue: "Continue Coloring",
                comment: "History action to resume coloring"
            ),
            pages: pages,
            onCreateNew: {
                dismissHost(false) {
                    AppRouter.shared.navigate(
                        to: PreviewColoringRoute.main(
                            coloring: coloringAPI,
                            coloringLocal: coloring,
                            history: nil,
                            typeScreen: typeScreen
                        ),
                        with: .push
                    )
                }
            },
            onSelectPage: { displayIndex in
                guard pages.indices.contains(displayIndex) else { return }
                let historyIndex = pages[displayIndex].id
                guard coloring.historys.indices.contains(historyIndex) else { return }
                dismissHost(false) {
                    AppRouter.shared.navigate(
                        to: PreviewColoringRoute.main(
                            coloring: nil,
                            coloringLocal: coloring,
                            history: coloring.historys[historyIndex],
                            typeScreen: typeScreen
                        ),
                        with: .push
                    )
                }
            },
            onClose: {
                dismissHost(true, nil)
            }
        )

        let host = UIHostingController(rootView: root)
        host.modalPresentationStyle = .overFullScreen
        host.view.backgroundColor = .clear
        box.controller = host
        return host
    }
}

// MARK: - Preview

#if DEBUG
private enum HistoryPreviewData {
    static let samplePages: [HistoryPageItem] = [
        HistoryPageItem(
            id: 0,
            imagePath: nil,
            previewImage: UIImage(named: "home_feature_halloween")
                ?? UIImage(systemName: "paintpalette"),
            progress: 0.24
        ),
        HistoryPageItem(
            id: 1,
            imagePath: nil,
            previewImage: UIImage(named: "home_feature_christmas")
                ?? UIImage(systemName: "gift"),
            progress: 0.61
        ),
        HistoryPageItem(
            id: 2,
            imagePath: nil,
            previewImage: UIImage(named: "home_feature_chibi")
                ?? UIImage(systemName: "face.smiling"),
            progress: 0.08
        )
    ]
}

#Preview("History — with pages") {
    HistoryColoringView(
        title: "History",
        createTitle: "Create New",
        continueTitle: "Continue Coloring",
        pages: HistoryPreviewData.samplePages,
        onCreateNew: {},
        onSelectPage: { _ in },
        onClose: {}
    )
}

#Preview("History — empty") {
    HistoryColoringView(
        title: "History",
        createTitle: "Create New",
        continueTitle: "Continue Coloring",
        pages: [],
        onCreateNew: {},
        onSelectPage: { _ in },
        onClose: {}
    )
}
#endif
