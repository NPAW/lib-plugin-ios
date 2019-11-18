//
//  YBSwiftLog.swift
//  YouboraLib
//
//  Created by Enrique Alfonso Burillo on 18/11/2019.
//  Copyright © 2019 NPAW. All rights reserved.
//

import Foundation

@objc enum YBSwiftLogLevel: Int {
    case YBLogLevelSilent = 6
    case YBLogLevelError = 5
    case YBLogLevelWarning = 4
    case YBLogLevelNotice = 3
    case YBLogLevelDebug = 2
    case YBLogLevelVerbose = 1
}

@objc protocol YBSwiftLogger {
    func logYoubora(message: String, logLevel: YBSwiftLogLevel)
}

@objcMembers class YBSwiftLog: NSObject {
    
    static var debugLevel = YBSwiftLogLevel.YBLogLevelError
    fileprivate static var loggers: [YBSwiftLogger] = []
    
    
    static func reportLogMessage(_ level :YBSwiftLogLevel, _ format: String, _ args:  CVarArg...) {
        let isAtLeastRequestedLevel = YBSwiftLog.isAtLeastLevel(level)
        
        if (isAtLeastRequestedLevel || (loggers.count > 0)) {
            
            //Build String
            let customformat = String.init(format: "[Youbora: %i] %@", level.rawValue, format)
            
            // Create formatted string from variable argument list
            let str = String.init(format: customformat, args)
            
            if (isAtLeastRequestedLevel) {
                //Log it
                NSLog("%@", str)
            }
            
            // Call the delegates if any
            for logger in loggers {
                logger.logYoubora(message: str, logLevel: level)
            }
        }
    }
    
    static func error(_ format: String, _ args: CVarArg...) {
        YBSwiftLog.reportLogMessage(YBSwiftLogLevel.YBLogLevelError, format, args)
    }
    
    static func warn(_ format: String, _ args:  CVarArg...) {
        YBSwiftLog.reportLogMessage(YBSwiftLogLevel.YBLogLevelWarning, format, args)
    }
    
    static func notice(_ format: String, _ args:  CVarArg...) {
        YBSwiftLog.reportLogMessage(YBSwiftLogLevel.YBLogLevelNotice, format, args)
    }
    
    static func debug(_ format: String, _ args:  CVarArg...) {
        YBSwiftLog.reportLogMessage(YBSwiftLogLevel.YBLogLevelDebug, format, args)
    }
    
    static func requestLog(_ format: String, _ args:  CVarArg...) {
        YBSwiftLog.reportLogMessage(YBSwiftLogLevel.YBLogLevelVerbose, format, args)
    }
    
    static func logException(_ exception: NSException) {
        guard let reason = exception.reason else {
            return
        }
        let str = String.init(format: "Exception: %@. Stack trace:\n%@", reason, exception.callStackSymbols)
        YBSwiftLog.error("%@", str)
    }
    
    static func addLoggerDelegate(_ delegate: YBSwiftLogger?) {
        guard let delegate = delegate else {
            return
        }
        loggers.append(delegate)
    }
    
    static func removeLoggerDelegate(_ delegate: YBSwiftLogger?) {
        guard let delegate = delegate else {
            return
        }
        loggers = loggers.filter { $0 === delegate }
    }
    
    static func isAtLeastLevel(_ level: YBSwiftLogLevel) -> Bool {
        return debugLevel.rawValue <= level.rawValue
    }
}
