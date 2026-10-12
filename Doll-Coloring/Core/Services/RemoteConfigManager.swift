//
//  RemoteConfigManager.swift
//  Doll-Coloring
//
//  Firebase temporarily disabled — stubbed defaults only.
//

import Foundation

protocol KeyRemote {
    var key: String { get }
}

protocol EventTracking {
    var key: String { get }
}

enum DefaultRemoteKey: String, KeyRemote {
    case subscriptionList = "subscription_list"
    case stateShowAds = "state_show_ads"
    case skanCValue = "skanCValue"
    case timeRemoteShowAd = "time_remote_show_ads"
    case appLovinKey = "appLovinKey"
    case enableCostCenter = "enableCostCenter"
    case bannerPluginKeyConfig = "bannerPluginKeyConfig"
    case appMintegralId = "appMintegralId"
    case appMintegralKey = "appMintegralKey"
    case adjustToken = "adjustToken"
    case timeoutRequestFullAd = "timeoutRequestFullAd"
    case timeShowCloseNativeFull = "timeShowCloseNativeFull"

    var key: String { return rawValue }
}

/// Stub RemoteConfig value used while Firebase is disabled.
final class StubRemoteConfigValue {
    var boolValue: Bool { false }
    var numberValue: NSNumber { 0 }
    var stringValue: String? { "" }
    var dataValue: Data { Data() }
}

final class RemoteConfigManager: NSObject {
    static let shared = RemoteConfigManager()

    var devMode = false
    var defaultFile: String?
    var timeOutRemoteConfig: TimeInterval = 15
    var onConfigChanged: ((_ keysChanged: Set<String>) -> Void)?

    private override init() {
        super.init()
    }

    func fetchAndActiveConfig(completion: @escaping ((_ success: Bool) -> Void)) {
        completion(true)
    }

    func fetchConfig(completion: @escaping ((_ success: Bool) -> Void)) {
        completion(true)
    }

    func fetchConfigSync(completion: @escaping ((_ success: Bool) -> Void)) {
        completion(true)
    }

    func getValue(by key: KeyRemote) -> StubRemoteConfigValue? {
        return StubRemoteConfigValue()
    }

    func getValue(by key: String) -> StubRemoteConfigValue? {
        return StubRemoteConfigValue()
    }

    func number(forKey key: KeyRemote) -> Int { 0 }
    func bool(forKey key: KeyRemote) -> Bool { false }
    func string(forKey key: KeyRemote) -> String { "" }
    func double(forKey key: KeyRemote) -> Double { 0 }
    func objectJson<T: Decodable>(forKey key: KeyRemote, type: T.Type) -> T? { nil }

    func number(forKey key: String) -> Int { 0 }
    func bool(forKey key: String) -> Bool { false }
    func string(forKey key: String) -> String { "" }
    func double(forKey key: String) -> Double { 0 }
    func objectJson<T: Decodable>(forKey key: String, type: T.Type) -> T? { nil }
}

final class FirebaseEventManager {

    class func logEvent(with name: String, params: [String: Any] = [:]) {
        #if DEBUG
        print("FirebaseEventManager.logEvent: \(name) params: \(params)")
        #endif
    }

    class func logEvent(with event: EventTracking, params: [String: Any] = [:]) {
        #if DEBUG
        var content = params
        content["app_version"] = "\(Bundle.main.infoDictionary?["CFBundleShortVersionString"] ?? "")(\(Bundle.main.infoDictionary?["CFBundleVersion"] ?? ""))"
        print("FirebaseEventManager.logEvent: \(event.key) params: \(content)")
        #endif
    }
}
