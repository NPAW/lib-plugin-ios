//
//  YBSwiftLog.swift
//  YouboraLib
//
//  Created by Enrique Alfonso Burillo on 18/11/2019.
//  Copyright © 2019 NPAW. All rights reserved.
//

import Foundation
/**
* Enum for log levels
*/
@objc public enum YBSwiftLogLevel: Int {
    /** Console won't show logs */
    case silent = 6
    /** Console will show errors */
    case error = 5
    /** Console will show warnings */
    case warning = 4
    /** Console will show notices (ie: lifecycle logs) */
    case notice = 3
    /** Console will show debug messages (ie: player events) */
    case debug = 2
    /** Console will show verbose messages (ie: Http Requests) */
    case verbose = 1
}

/**
* Protocol that receives log messages as reported by <YBLog> class.
*/
@objc public protocol YBSwiftLogger {

    /**
    * This will be invoked whenever a log message is created
    * @param message The log message
    * @param logLevel The log level of the message
    */
    func logYoubora(message: String, logLevel: YBSwiftLogLevel)
}

/**
* YBLog class
* Provides a set of convenience methods to ease the logging.
*/
@objcMembers open class YBSwiftLog: NSObject {
    /// ---------------------------------
    /// @name Private properties
    /// ---------------------------------

    fileprivate static var loggers: [YBSwiftLogger] = []

    /// ---------------------------------
    /// @name Public properties
    /// ---------------------------------

    /**
    * @returns the current debug level
    */
    public static var debugLevel = YBSwiftLogLevel.error

    /// MARK Public methods

    /// ---------------------------------
    /// @name Public methods
    /// ---------------------------------

    /**
    * Generic logging method
    *
    * @param logLevel the log level to use for this message
    * @param format format string
    * @param ... variable length argument list.
    */
    public static func reportLogMessage(_ level: YBSwiftLogLevel, _ format: String, _ args: CVarArg...) {
        let isAtLeastRequestedLevel = YBSwiftLog.isAtLeastLevel(level)

        if isAtLeastRequestedLevel || (loggers.count > 0) {

            //Build String
            let customformat = String(format: "[Youbora: %i] %@", level.rawValue, format)

            // Create formatted string from variable argument list
            let str = String(format: customformat, args)

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

    /**
    * Log with error level
    * @param format format string
    * @param ... variable length argument list.
    */
    public static func error(_ format: String, _ args: CVarArg...) {
        YBSwiftLog.reportLogMessage(.error, format, args)
    }

    /**
    * Log with warning level
    * @param format format string
    * @param ... variable length argument list.
    */
    public static func warn(_ format: String, _ args: CVarArg...) {
        YBSwiftLog.reportLogMessage(.warning, format, args)
    }

    /**
    * Log with lifecycle level
    * @param format format string
    * @param ... variable length argument list.
    */
    public static func notice(_ format: String, _ args: CVarArg...) {
        YBSwiftLog.reportLogMessage(.notice, format, args)
    }

    /**
    * Log with debug level
    * @param format format string
    * @param ... variable length argument list.
    */
    public static func debug(_ format: String, _ args: CVarArg...) {
        YBSwiftLog.reportLogMessage(.debug, format, args)
    }

    /**
    * Log with XHR level
    * @param format format string
    * @param ... variable length argument list.
    */
    public static func requestLog(_ format: String, _ args: CVarArg...) {
        YBSwiftLog.reportLogMessage(.verbose, format, args)
    }

    /**
    * Log an exception
    * @param exception The exception to log
    */
    public static func logException(_ exception: NSException) {
        guard let reason = exception.reason else {
            return
        }
        let str = String(format: "Exception: %@. Stack trace:\n%@", reason, exception.callStackSymbols)
        YBSwiftLog.error("%@", str)
    }

    /**
    * Adds a logger delegate
    *
    * The logger delegate will be called whenever a log method is called passing it the log message and level
    * @param delegate An object that conforms to the YBLogger protocol.
    */
    public static func addLoggerDelegate(_ delegate: YBSwiftLogger?) {
        guard let delegate = delegate else {
            return
        }
        if (loggers.filter({ $0 === delegate}).count == 0) {
            loggers.append(delegate)
        }
    }

    /**
    * Removes a logger delegate
    *
    * @param delegate An object that conforms to the YBLogger protocol.
    */
    public static func removeLoggerDelegate(_ delegate: YBSwiftLogger?) {
        guard let delegate = delegate else {
            return
        }
        loggers = loggers.filter { $0 !== delegate }
    }

    /**
    * Returns true if the current log level is less or equal than the param.
    * This is useful to avoid calling logging methods when they're not going to be printed, for
    * instance when it's expensive to generate the string to log.
    * @param level The leel to check against.
    * @returns true if the current <debugLevel> is less than or equal to level.
    */
    public static func isAtLeastLevel(_ level: YBSwiftLogLevel) -> Bool {
        return debugLevel.rawValue <= level.rawValue
    }
}
