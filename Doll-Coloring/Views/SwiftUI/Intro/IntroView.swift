//
//  IntroView.swift
//  Doll-Coloring
//

import SwiftUI

struct IntroView: View {
    @EnvironmentObject private var navigator: AppNavigator
    @State private var page = 0

    private var pages: [(title: String, desc: String, image: String, inside: String)] {
        [
            (LocalizableUtils.introIntroTitlePage1(), LocalizableUtils.introIntroContentPage1(), "ic_item_onboading1", "ic_inside_onboading1"),
            (LocalizableUtils.introIntroTitlePage2(), LocalizableUtils.introIntroContentPage2(), "ic_item_onboading2", "ic_inside_onboading2"),
            (LocalizableUtils.introIntroTitlePage3(), LocalizableUtils.introIntroContentPage3(), "ic_item_onboading3", "ic_inside_onboading3")
        ]
    }

    var body: some View {
        VStack(spacing: 0) {
            TabView(selection: $page) {
                ForEach(0..<pages.count, id: \.self) { index in
                    introPage(pages[index])
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .disabled(true)

            Button(action: next) {
                Text(page < pages.count - 1 ? LocalizableUtils.commonNext() : LocalizableUtils.commonStartColoring())
                    .font(.system(size: 17, weight: .bold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.appPrimary)
                    .clipShape(Capsule())
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 32)

            HStack(spacing: 8) {
                ForEach(0..<pages.count, id: \.self) { index in
                    Capsule()
                        .fill(index == page ? Color.appPrimary : Color.black.opacity(0.15))
                        .frame(width: index == page ? 24 : 8, height: 8)
                }
            }
            .padding(.bottom, 24)
        }
        .background(Color.appBackground.ignoresSafeArea())
        .toolbar(.hidden, for: .navigationBar)
        .onChange(of: page) { newValue in
            switch newValue {
            case 0: FirebaseEventManager.logEvent(with: RMBGEventTracking.scrOnboard1)
            case 1: FirebaseEventManager.logEvent(with: RMBGEventTracking.scrOnboard2)
            case 2: FirebaseEventManager.logEvent(with: RMBGEventTracking.scrOnboard3)
            default: break
            }
        }
        .onAppear {
            FirebaseEventManager.logEvent(with: RMBGEventTracking.scrOnboard1)
        }
    }

    private func introPage(_ item: (title: String, desc: String, image: String, inside: String)) -> some View {
        VStack(spacing: 20) {
            Spacer()
            ZStack {
                Image(item.image)
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 320)
                Image(item.inside)
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 180)
            }
            Text(item.title)
                .font(.system(size: 24, weight: .bold))
                .multilineTextAlignment(.center)
                .foregroundStyle(Color.appText)
                .padding(.horizontal, 24)
            Text(item.desc)
                .font(.system(size: 16))
                .multilineTextAlignment(.center)
                .foregroundStyle(Color.appText.opacity(0.7))
                .padding(.horizontal, 32)
            Spacer()
        }
    }

    private func next() {
        if page < pages.count - 1 {
            withAnimation { page += 1 }
        } else {
            UserDefaults.standard.set(true, forKey: UserDefault.showedIntro.rawValue)
            UserDefaultManager.currentDateFirstOpenApp = Date().toMyString(format: "dd/MM/yyyy")
            navigator.replace(with: .home)
        }
    }
}
