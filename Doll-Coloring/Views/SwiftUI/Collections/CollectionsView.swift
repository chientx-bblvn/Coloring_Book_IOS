//
//  CollectionsView.swift
//  Doll-Coloring
//

import SwiftUI
import SDWebImage

struct CollectionsView: View {
    @ObservedObject private var tabStore = MainTabStore.shared
    @State private var segment = 0
    @State private var unfinished: [String] = []
    @State private var finished: [String] = []
    @State private var listColoring: [ColoringHistoryModel] = []
    @State private var deleteTarget: String?
    @State private var showDelete = false

    private var currentList: [String] {
        segment == 0 ? unfinished : finished
    }

    private let columns = [
        GridItem(.flexible(), spacing: 8),
        GridItem(.flexible(), spacing: 8)
    ]
    private let collectionBadgeColor = Color(hex: "6B6670")

    var body: some View {
        VStack(spacing: 0) {
            CrayoLogoHeader.tabBar {
                SubcriptionViewController.show(checkTime: true, handler: {}, onClickCLose: {})
            }

            Picker("", selection: $segment) {
                Text(LocalizableUtils.commonUnfinished().capitalized).tag(0)
                Text(LocalizableUtils.commonFinished().capitalized).tag(1)
            }
            .pickerStyle(.segmented)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)

            if currentList.isEmpty {
                emptyState
            } else {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 8) {
                        ForEach(currentList, id: \.self) { fileName in
                            collectionCard(fileName)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 24)
                }
            }
        }
        .background(Color.appBackground.ignoresSafeArea())
        .onAppear(perform: reload)
        .alert(LocalizableUtils.commonDelete(), isPresented: $showDelete) {
            Button(LocalizableUtils.commonCancel(), role: .cancel) {}
            Button(LocalizableUtils.commonDelete(), role: .destructive) {
                if let deleteTarget {
                    deleteColoring(fileName: deleteTarget)
                }
            }
        } message: {
            Text(LocalizableUtils.commonEmptyCollections())
        }
    }

    private var emptyState: some View {
        VStack(spacing: 12) {
            Spacer()
            Image("collections_empty_bunny")
                .resizable()
                .scaledToFit()
                .frame(width: 142, height: 132)
                .accessibilityHidden(true)
            Text(NSLocalizedString("Collections.EmptyTitle", comment: "Collections empty state headline"))
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundStyle(Color.appText)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
            Text(NSLocalizedString("Collections.EmptyMessage", comment: "Collections empty state guidance"))
                .font(.system(size: 15, weight: .medium, design: .rounded))
                .multilineTextAlignment(.center)
                .foregroundStyle(Color.appTextSecondary)
                .padding(.horizontal, 32)
            Button {
                tabStore.select(.coloringBooks)
            } label: {
                Text(NSLocalizedString("Collections.EmptyAction", comment: "Collections empty state action"))
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(Color.appPrimary)
                    .clipShape(Capsule())
            }
            Spacer()
        }
    }

    private func collectionCard(_ fileName: String) -> some View {
        let path = FileManagerLocal.shared.getFileFoderFileUssing(typeFile: .ColoringSave, file: fileName).path
        let percent = percentText(for: fileName)

        return ZStack(alignment: .topTrailing) {
            RemoteImageView(urlString: path)
                .allowsHitTesting(false)
                .aspectRatio(1, contentMode: .fill)
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .stroke(Color(hex: "6B6670"), lineWidth: 1.5)
                )

            Button {
                deleteTarget = fileName
                showDelete = true
            } label: {
                Image(systemName: "trash.fill")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(.white)
                    .padding(8)
                    .contentShape(Rectangle())
                    .background(collectionBadgeColor)
                    .clipShape(Circle())
                    .shadow(color: collectionBadgeColor.opacity(0.24), radius: 3, y: 1)
            }
            .buttonStyle(.plain)
            .padding(8)
            .zIndex(2)

            VStack {
                Spacer()
                HStack {
                    Text(percent)
                        .font(.system(size: 14, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(collectionBadgeColor)
                        .clipShape(Capsule())
                        .shadow(color: collectionBadgeColor.opacity(0.24), radius: 3, y: 1)
                    Spacer()
                }
                .padding(8)
            }
            .allowsHitTesting(false)
        }
        .contentShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .onTapGesture {
            resumeColoring(fileName: fileName)
        }
        .accessibilityAddTraits(.isButton)
    }

    private func reload() {
        listColoring = SQLiteManager.shared.selectionColorings()
        var completed: [String] = []
        var notCompleted: [String] = []
        for coloring in listColoring {
            for history in coloring.historys {
                let percent = ((history.percent_complete ?? 0) * 100).rounded()
                // Hide blank pages — 0% is never shown in Collections.
                guard percent > 0 else { continue }
                if percent >= 100 {
                    completed.append(history.imagePath)
                } else {
                    notCompleted.append(history.imagePath)
                }
            }
        }
        finished = completed
        unfinished = notCompleted
    }

    private func percentText(for fileName: String) -> String {
        if let coloring = listColoring.first(where: { coloring in
            coloring.historys.contains { historyMatches($0.imagePath, fileName) }
        }),
           let history = coloring.historys.first(where: { historyMatches($0.imagePath, fileName) }) {
            let percent = (history.percent_complete ?? 0) * 100
            return "\(Int(percent.rounded()))%"
        }
        return "0%"
    }

    private func resumeColoring(fileName: String) {
        guard let coloring = listColoring.first(where: { coloring in
            coloring.historys.contains { historyMatches($0.imagePath, fileName) }
        }),
        let history = coloring.historys.first(where: { historyMatches($0.imagePath, fileName) }) else {
            return
        }

        AppRouter.shared.navigate(
            to: PreviewColoringRoute.main(
                coloring: nil,
                coloringLocal: coloring,
                history: history,
                typeScreen: .collection
            ),
            with: .push
        )
    }

    private func historyMatches(_ imagePath: String, _ fileName: String) -> Bool {
        imagePath == fileName
            || imagePath.contains(fileName)
            || fileName.contains(imagePath)
            || (imagePath as NSString).lastPathComponent == (fileName as NSString).lastPathComponent
    }

    private func deleteColoring(fileName: String) {
        guard let index = listColoring.firstIndex(where: { coloring in
            coloring.historys.contains { historyMatches($0.imagePath, fileName) }
        }) else { return }
        var coloring = listColoring[index]
        coloring.historys.removeAll { historyMatches($0.imagePath, fileName) }
        // Always remove the saved page; only drop source + SQLite row when nothing left.
        FileManagerLocal.shared.deleteFile(typeFile: .ColoringSave, fileName: fileName)
        if coloring.historys.isEmpty {
            FileManagerLocal.shared.deleteFile(typeFile: .Coloring, fileName: coloring.filePath)
            SQLiteManager.shared.deleteColorings(id: coloring.id)
        } else {
            _ = SQLiteManager.shared.updateColorings(data: coloring)
        }
        reload()
    }
}
