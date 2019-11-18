//
//  YBSwiftLog.swift
//  YouboraLib
//
//  Created by Enrique Alfonso Burillo on 18/11/2019.
//  Copyright © 2019 NPAW. All rights reserved.
//

import Foundation

@objc public enum YBSwiftLogLevel: Int {
    case silent = 6
    case error = 5
    case warning = 4
    case notice = 3
    case debug = 2
    case verbose = 1
}

@objc public protocol YBSwiftLogger {
    func logYoubora(message: String, logLevel: YBSwiftLogLevel)
}

@objcMembers open class YBSwiftLog: NSObject {

    public static var debugLevel = YBSwiftLogLevel.error
    fileprivate static var loggers: [YBSwiftLogger] = []

    public static func reportLogMessage(_ level: YBSwiftLogLevel, _ format: String, _ args: CVarArg...) {
        let isAtLeastRequestedLevel = YBSwiftLog.isAtLeastLevel(level)

        if isAtLeastRequestedLevel || (loggers.count > 0) {

            //Build String
            let customformat = String.init(format: "[Youbora: %i] %@", level.rawValue, format)

            // Create formatted string from variable argument list
            let str = String.init(format: customformat, args)

            if isAtLeastRequestedLevel {
                //Log it
                NSLog("%@", str)
            }

            // Call the delegates if any
            for logger in loggers {
                logger.logYoubora(message: str, logLevel: level)
            }
        }
    }

    public static func error(_ format: String, _ args: CVarArg...) {
        YBSwiftLog.reportLogMessage(.error, format, args)
    }

    public static func warn(_ format: String, _ args: CVarArg...) {
        YBSwiftLog.reportLogMessage(.warning, format, args)
    }

    public static func notice(_ format: String, _ args: CVarArg...) {
        YBSwiftLog.reportLogMessage(.notice, format, args)
    }

    public static func debug(_ format: String, _ args: CVarArg...) {
        YBSwiftLog.reportLogMessage(.debug, format, args)
    }

    public static func requestLog(_ format: String, _ args: CVarArg...) {
        YBSwiftLog.reportLogMessage(.verbose, format, args)
    }

    public static func logException(_ exception: NSException) {
        guard let reason = exception.reason else {
            return
        }
        let str = String.init(format: "Exception: %@. Stack trace:\n%@", reason, exception.callStackSymbols)
        YBSwiftLog.error("%@", str)
    }

    public static func addLoggerDelegate(_ delegate: YBSwiftLogger?) {
        guard let delegate = delegate else {
            return
        }
        if (loggers.filter({ $0 === delegate}).count == 0) {
            loggers.append(delegate)
        }
    }

    public static func removeLoggerDelegate(_ delegate: YBSwiftLogger?) {
        guard let delegate = delegate else {
            return
        }
        loggers = loggers.filter { $0 !== delegate }
    }

    public static func isAtLeastLevel(_ level: YBSwiftLogLevel) -> Bool {
        return debugLevel.rawValue <= level.rawValue
    }
}
