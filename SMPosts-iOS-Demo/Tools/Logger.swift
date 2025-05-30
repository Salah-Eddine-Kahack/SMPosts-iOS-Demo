//
//  Logger.swift
//  SMPosts-iOS-Demo
//
//  Created by Salah Eddine KAHACK on 30/05/2025.
//

import Foundation


enum LogLevel: String {
    case warning = "WARNING ⚠️"
    case error = "ERROR ❌"
    case debug = "DEBUG 🔍"
}


struct Logger {

    static func log(_ message: String,
                    level: LogLevel,
                    file: String = #file,
                    function: String = #function,
                    line: Int = #line) {

        let timestamp = DateFormatter.localizedString(
            from: Date(),
            dateStyle: .none,
            timeStyle: .medium
        )
        
        let thread = Thread.isMainThread ? "Main-Thread" : "Background-Thread"
        let logMessage = "[\(level.rawValue)] [\(timestamp)] [\(thread)] \(message) (\(file):\(line) in \(function))"

        if level == .debug {
            #if DEBUG
                print(logMessage)
            #endif
        }
        else {
            print(logMessage)
        }
    }
}
