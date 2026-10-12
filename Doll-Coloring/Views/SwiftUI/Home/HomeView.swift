//
//  HomeView.swift
//  Doll-Coloring
//

import SwiftUI
import Combine
import SDWebImage
import RxSwift

struct HomeView: View {
    @EnvironmentObject private var navigator: AppNavigator
    @StateObject private var viewModel = HomeSwiftUIVM()
    @ObservedObject private var iap = IAPStatusStore.shared
    @State private var selectedCategoryIndex: Int = 0
    @State private var homeSlideIndex: Int = 0

    private let homeSlides = HomeFeaturedSlide.all
    private let homeSlideTimer = Timer.publish(every: 3.5, on: .main, in: .common).autoconnect()

    private var isPad: Bool { UIDevice.current.userInterfaceIdiom == .pad }

    private var gridColumns: [GridItem] {
        let count = isPad ? 3 : 2
        let spacing: CGFloat = isPad ? 14 : 12
        return Array(repeating: GridItem(.flexible(), spacing: spacing), count: count)
    }

    var body: some View {
        VStack(spacing: 0) {
            homeHeader
            contentScroll
        }
        .background(Color.appBackground.ignoresSafeArea())
        .onAppear {
            viewModel.loadIfNeeded()
            viewModel.showLaunchIAPIfNeeded()
        }
        .onChange(of: viewModel.colorings.count) { _ in
            if selectedCategoryIndex >= viewModel.colorings.count {
                selectedCategoryIndex = 0
            }
        }
        .onReceive(homeSlideTimer) { _ in
            guard homeSlides.count > 1 else { return }
            withAnimation(.easeInOut(duration: 0.35)) {
                homeSlideIndex = (homeSlideIndex + 1) % homeSlides.count
            }
        }
    }

    // MARK: - Header

    private var homeHeader: some View {
        CrayoLogoHeader.tabBar {
            SubcriptionViewController.show(checkTime: true, handler: {}, onClickCLose: {})
        }
    }

    // MARK: - Category chips

    @ViewBuilder
    private var categoryChips: some View {
        if !viewModel.colorings.isEmpty {
            ScrollViewReader { chipProxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: isPad ? 10 : 8) {
                        ForEach(Array(viewModel.colorings.enumerated()), id: \.offset) { index, category in
                            let title = category.categoryName ?? "Unknown"
                            let selected = index == selectedCategoryIndex
                            Button {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    selectedCategoryIndex = index
                                }
                            } label: {
                                Text(title)
                                    .font(.system(size: isPad ? 18 : 16, weight: selected ? .bold : .semibold, design: .rounded))
                                    .foregroundStyle(selected ? Color.white : Color.appText)
                                    .padding(.horizontal, isPad ? 20 : 16)
                                    .padding(.vertical, isPad ? 12 : 10)
                                    .background(selected ? Color.appPrimary : Color.appSurface)
                                    .clipShape(Capsule())
                                    .overlay(
                                        Capsule()
                                            .stroke(selected ? Color.clear : Color.appBorder, lineWidth: 1)
                                    )
                            }
                            .buttonStyle(.plain)
                            .accessibilityAddTraits(selected ? .isSelected : [])
                            .id(categoryChipID(index))
                        }
                    }
                    .padding(.horizontal, 20)
                }
                .onChange(of: selectedCategoryIndex) { index in
                    withAnimation(.easeInOut(duration: 0.28)) {
                        chipProxy.scrollTo(categoryChipID(index), anchor: .center)
                    }
                }
            }
        }
    }

    private func categoryChipID(_ index: Int) -> String {
        "home-category-chip-\(index)"
    }

    private func selectCategory(for slide: HomeFeaturedSlide, scrollProxy: ScrollViewProxy) {
        guard let index = categoryIndex(for: slide) else { return }
        withAnimation(.easeInOut(duration: 0.28)) {
            selectedCategoryIndex = index
            scrollProxy.scrollTo("home-category-results", anchor: .top)
        }
    }

    // MARK: - Content

    private var contentScroll: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(alignment: .leading, spacing: isPad ? 20 : 16) {
                    featuredCarousel { slide in
                        selectCategory(for: slide, scrollProxy: proxy)
                    }

                    categoryChips

                    if let category = selectedCategory {
                        let title = category.categoryName ?? "Unknown"
                        let items = category.imageUrls ?? []
                        LazyVGrid(columns: gridColumns, spacing: isPad ? 14 : 12) {
                            ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                                gridThumb(
                                    item: item,
                                    categoryName: title,
                                    index: index
                                )
                            }
                        }
                        .padding(.horizontal, 20)
                        .id("home-category-results")
                    } else if viewModel.colorings.isEmpty {
                        emptyState
                    }
                }
                .padding(.top, 12)
                // Leave enough scroll room for the floating tab bar and home indicator.
                .padding(.bottom, 56)
            }
        }
    }

    private func featuredCarousel(onSelect: @escaping (HomeFeaturedSlide) -> Void) -> some View {
        let bannerHeight: CGFloat = isPad ? 240 : 210
        return VStack(spacing: 10) {
            TabView(selection: $homeSlideIndex) {
                ForEach(Array(homeSlides.enumerated()), id: \.offset) { index, slide in
                    Button {
                        onSelect(slide)
                    } label: {
                        ZStack(alignment: .bottomLeading) {
                            GeometryReader { geometry in
                                if let artwork = UIImage(named: slide.imageName) {
                                    Image(uiImage: artwork)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: geometry.size.width, height: geometry.size.height)
                                        .clipped()
                                } else {
                                    Color.appPrimarySoft
                                        .overlay {
                                            Image(systemName: "paintpalette.fill")
                                                .font(.system(size: 28, weight: .medium))
                                                .foregroundStyle(Color.appPrimary.opacity(0.55))
                                        }
                                }
                            }
                            .frame(height: bannerHeight)

                            LinearGradient(
                                colors: [.clear, Color.black.opacity(0.52)],
                                startPoint: .center,
                                endPoint: .bottom
                            )

                            VStack(alignment: .leading, spacing: 4) {
                                Text(slide.title)
                                    .font(.system(size: isPad ? 30 : 24, weight: .bold, design: .rounded))
                                Text(slide.subtitle)
                                    .font(.system(size: isPad ? 17 : 15, weight: .medium, design: .rounded))
                                    .opacity(0.94)
                            }
                            .foregroundStyle(.white)
                            .padding(isPad ? 22 : 16)
                        }
                        .frame(height: bannerHeight)
                        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 22, style: .continuous)
                                .stroke(Color.appBorder.opacity(0.8), lineWidth: 1)
                        )
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("\(slide.title). \(slide.subtitle). Open category.")
                    .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(height: bannerHeight)

            HStack(spacing: 6) {
                ForEach(homeSlides.indices, id: \.self) { index in
                    Capsule()
                        .fill(index == homeSlideIndex ? Color.appPrimary : Color.appTextSecondary.opacity(0.24))
                        .frame(width: index == homeSlideIndex ? 18 : 6, height: 6)
                }
            }
            .accessibilityHidden(true)
        }
        .padding(.horizontal, 16)
    }

    private func categoryIndex(for slide: HomeFeaturedSlide) -> Int? {
        let colorings = viewModel.colorings
        guard !colorings.isEmpty else { return nil }

        let fold: (String) -> String = {
            $0.folding(options: [.diacriticInsensitive, .caseInsensitive], locale: .current)
        }
        let slideTitle = fold(slide.title)

        if let exact = colorings.firstIndex(where: { fold($0.categoryName ?? "") == slideTitle }) {
            return exact
        }
        if let prefixed = colorings.firstIndex(where: {
            fold($0.categoryName ?? "").hasPrefix(slideTitle) || slideTitle.hasPrefix(fold($0.categoryName ?? ""))
        }) {
            return prefixed
        }

        if let keywordMatch = colorings.firstIndex(where: { category in
            let name = fold(category.categoryName ?? "")
            return slide.categoryKeywords.contains { name.contains($0) }
        }) {
            return keywordMatch
        }

        guard colorings.indices.contains(slide.fallbackIndex) else { return 0 }
        return slide.fallbackIndex
    }

    private var selectedCategory: ColoringModel? {
        guard viewModel.colorings.indices.contains(selectedCategoryIndex) else {
            return viewModel.colorings.first
        }
        return viewModel.colorings[selectedCategoryIndex]
    }

    private func gridThumb(item: ColoringImage, categoryName: String, index: Int) -> some View {
        let preview = item.filePreview ?? item.filePath ?? ""
        let aspect: CGFloat = isPad ? 1.2 : 1.28
        return ZStack(alignment: .topTrailing) {
            RemoteImageView(
                urlString: preview,
                contentMode: .scaleAspectFill,
                backgroundColor: UIColor(hexString: AppTheme.primarySoftHex)
            )
            .allowsHitTesting(false)
            .aspectRatio(1 / aspect, contentMode: .fit)
            .frame(maxWidth: .infinity)
            .clipped()

            if item.isPremium == true, !iap.isVip {
                premiumBadge
                    .allowsHitTesting(false)
                    .padding(10)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(Color.appBorder, lineWidth: 1)
        )
        .shadow(color: Color.appText.opacity(0.05), radius: 5, y: 2)
        .contentShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .onTapGesture {
            viewModel.handleTap(item: item, categoryName: categoryName, index: index)
        }
        .accessibilityAddTraits(.isButton)
    }

    private var premiumBadge: some View {
        HStack(spacing: 4) {
            Image(systemName: "sparkles")
                .font(.system(size: isPad ? 11 : 10, weight: .bold))
            Text("PRO")
                .font(.system(size: isPad ? 12 : 11, weight: .heavy, design: .rounded))
        }
        .foregroundStyle(.white)
        .padding(.horizontal, 10)
        .padding(.vertical, 7)
        .background(Color.appPrimary)
        .clipShape(Capsule())
        .shadow(color: Color.appPrimary.opacity(0.24), radius: 3, y: 1)
        .accessibilityLabel("PRO content")
    }

    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "paintpalette")
                .font(.system(size: isPad ? 42 : 36))
                .foregroundStyle(Color.appPrimary.opacity(0.7))
            Text(NSLocalizedString("Loading drawings…", comment: ""))
                .font(.system(size: isPad ? 18 : 16, weight: .medium, design: .rounded))
                .foregroundStyle(Color.appTextSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 80)
    }
}

private struct HomeFeaturedSlide: Identifiable {
    let id: String
    let title: String
    let subtitle: String
    let imageName: String
    let categoryKeywords: [String]
    let fallbackIndex: Int

    static let all = [
        HomeFeaturedSlide(
            id: "halloween",
            title: "Halloween",
            subtitle: "A little spooky, a lot of cute",
            imageName: "home_feature_halloween",
            categoryKeywords: ["halloween", "hallowe'en"],
            fallbackIndex: 0
        ),
        HomeFeaturedSlide(
            id: "christmas",
            title: "Christmas",
            subtitle: "Cozy holiday coloring",
            imageName: "home_feature_christmas",
            categoryKeywords: ["christmas", "xmas", "holiday"],
            fallbackIndex: 1
        ),
        HomeFeaturedSlide(
            id: "chibi",
            title: "Chibi",
            subtitle: "Tiny characters, big smiles",
            imageName: "home_feature_chibi",
            categoryKeywords: ["chibi"],
            fallbackIndex: 2
        )
    ]
}

@MainActor
final class HomeSwiftUIVM: ObservableObject {
    @Published var colorings: [ColoringModel] = []
    private let homeVM = HomeVM()
    private var loaded = false
    private var showedIAP = false
    private let disposeBag = DisposeBag()

    func loadIfNeeded() {
        guard !loaded else { return }
        loaded = true
        homeVM.getNewColorings { [weak self] in
            DispatchQueue.main.async {
                // Daily reward category removed from Home.
                let all = self?.homeVM.colorings ?? []
                self?.colorings = all.filter { !($0.categoryName ?? "").localizedCaseInsensitiveContains("daily") }
            }
        }
        InappManager.share.didPaymentSuccess.subscribe(onNext: { _ in
            if IAPState.isUserVip {
                PremiumFloatingView.hide()
            }
        }).disposed(by: disposeBag)
    }

    func showLaunchIAPIfNeeded() {
        guard !showedIAP else { return }
        showedIAP = true
        guard UserDefaultManager.ABShowIAPColoring, !IAPState.isUserVip else { return }
        SubcriptionViewController.show(checkTime: false, handler: {
            if UserDefaultManager.disableSale { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                PremiumFloatingView.show()
                guard UserDefaultManager.getRemainingCountdownTime() > 0 else { return }
                DiscountViewController.show {}
            }
        }, onClickCLose: {})
    }

    func handleTap(item: ColoringImage, categoryName: String, index: Int) {
        if item.isPremium == true, !IAPState.isUserVip {
            SubcriptionViewController.show(checkTime: true, handler: {}, onClickCLose: {})
            return
        }
        ColorFlowPresenter.shared.openColoring(item)
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}
