//
//  BBLLogging.swift
//  Doll-Coloring
//

import Foundation

@objc
final class BBLLogging: NSObject {

    private enum BBLLoggingLevel {
        case debug
        case error
        case info
        case verbose
        case warning
    }

    private override init() {
        super.init()
    }

    @objc static func d(_ message: @autoclosure () -> String = "",
                        file: String = #file, function: String = #function, line: Int = #line) {
        log(message(), file: file, function: function, line: line, level: .debug)
    }

    @objc static func e(_ message: @autoclosure () -> String = "",
                        file: String = #file, function: String = #function, line: Int = #line) {
        log(message(), file: file, function: function, line: line, level: .error)
    }

    @objc static func i(_ message: @autoclosure () -> String = "",
                        file: String = #file, function: String = #function, line: Int = #line) {
        log(message(), file: file, function: function, line: line, level: .info)
    }

    @objc static func v(_ message: @autoclosure () -> String = "",
                        file: String = #file, function: String = #function, line: Int = #line) {
        log(message(), file: file, function: function, line: line, level: .verbose)
    }

    @objc static func w(_ message: @autoclosure () -> String = "",
                        file: String = #file, function: String = #function, line: Int = #line) {
        log(message(), file: file, function: function, line: line, level: .warning)
    }

    private static func log(_ message: @autoclosure () -> String,
                            file: String = #file, function: String = #function, line: Int = #line,
                            level: BBLLoggingLevel = .debug) {
        switch level {
        case .debug:
            NSLog("🟦 Debug: %@ %@", "\((file as NSString).lastPathComponent).\(function):\(line)", message())
        case .error:
            NSLog("🟥 Error: %@ %@", "\((file as NSString).lastPathComponent).\(function):\(line)", message())
        case .info:
            NSLog("🟩 Info: %@ %@", "\((file as NSString).lastPathComponent).\(function):\(line)", message())
        case .verbose:
            NSLog("🟧 Verbose: %@ %@", "\((file as NSString).lastPathComponent).\(function):\(line)", message())
        case .warning:
            NSLog("🟨 Warning: %@ %@", "\((file as NSString).lastPathComponent).\(function):\(line)", message())
        }
    }
}
