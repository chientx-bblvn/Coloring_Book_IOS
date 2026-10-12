//
//  LanguageView.swift
//  Doll-Coloring
//

import SwiftUI

struct LanguageView: View {
    @EnvironmentObject private var navigator: AppNavigator
    let goFrom: LanguageGoFrom

    @State private var selected: Language? = Constants.currentLanguage
    private let languages = Language.allCases

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text(LocalizableUtils.languageSubTitle())
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(Color.appText)
                Spacer()
                Button(action: confirm) {
                    Text(goFrom == .intro ? LocalizableUtils.commonNext() : LocalizableUtils.commonDone())
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(selected == nil ? Color.gray : Color.appPrimary)
                }
                .disabled(selected == nil)
            }
            .padding(.horizontal, 20)
            .padding(.top, UIDevice.current.userInterfaceIdiom == .pad ? 28 : 16)
            .padding(.bottom, 12)

            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(languages, id: \.self) { language in
                        Button {
                            selected = language
                            Constants.currentLanguage = language
                        } label: {
                            HStack(spacing: 16) {
                                if let icon = language.icon {
                                    Image(uiImage: icon)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 40, height: 40)
                                        .clipShape(Circle())
                                }
                                Text(language.name)
                                    .font(.system(size: 17, weight: .medium))
                                    .foregroundStyle(Color.appText)
                                Spacer()
                                if selected == language {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundStyle(Color.appPrimary)
                                }
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 14)
                            .background(
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .fill(Color.white)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                                            .stroke(selected == language ? Color.appPrimary : Color.black.opacity(0.08), lineWidth: 1.5)
                                    )
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
            }
        }
        .background(Color.appBackground.ignoresSafeArea())
        .toolbar(.hidden, for: .navigationBar)
        .onAppear {
            if UserDefaults.standard.string(forKey: UserDefault.languageKey.rawValue)?.isEmpty != false {
                FirebaseEventManager.logEvent(with: RMBGEventTracking.languageScr)
            }
        }
    }

    private func confirm() {
        guard let language = selected else { return }
        UserDefaults.standard.set(language.key, forKey: UserDefault.languageKey.rawValue)
        Constants.currentLanguage = language
        NotificationCenter.default.post(name: .changeLanguage, object: nil)

        if goFrom == .setting {
            navigator.pop()
            return
        }
        let showIntro = UserDefaults.standard.bool(forKey: UserDefault.showedIntro.rawValue)
        navigator.replace(with: showIntro ? .home : .intro)
    }
}
