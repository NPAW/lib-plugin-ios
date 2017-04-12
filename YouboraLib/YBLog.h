//
//  YBLog.h
//  YouboraLib
//
//  Created by Joan on 16/03/2017.
//  Copyright © 2017 NPAW. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Enum for log levels
 */
typedef NS_ENUM(NSUInteger, YBLogLevel) {
    /** Console won't show logs */
    YBLogLevelSilent = 6,
    /** Console will show errors */
    YBLogLevelError = 5,
    /** Console will show warnings */
    YBLogLevelWarning = 4,
    /** Console will show notices (ie: lifecycle logs) */
    YBLogLevelNotice = 3,
    /** Console will show debug messages (ie: player events) */
    YBLogLevelDebug = 2,
    /** Console will show verbose messages (ie: Http Requests) */
    YBLogLevelVerbose = 1
};

/**
 * Protocol that receives log messages as reported by <YBLog> class.
 */
@protocol YBLogger

/**
 * This will be invoked whenever a log message is created
 * @param message The log message
 * @param logLevel The log level of the message
 */
- (void) logYouboraMessage:(NSString *) message withLogLevel:(YBLogLevel) logLevel;

@end

/**
 * YBLog class
 * Provides a set of convenience methods to ease the logging.
 */
@interface YBLog : NSObject

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
+ (void) reportLogMessageWithLevel:(YBLogLevel) logLevel andMessage:(NSString *) format, ... ;
/**
 * @returns the current debug level
 */
+ (YBLogLevel) debugLevel;
/**
 * Sets the debug level.
 *
 * @param debugLevel the debug level to set
 */
+ (void) setDebugLevel:(YBLogLevel) debugLevel;
/**
 * Log with error level
 * @param format format string
 * @param ... variable length argument list.
 */
+ (void) error:(NSString *) format, ... ;
/**
 * Log with warning level
 * @param format format string
 * @param ... variable length argument list.
 */
+ (void) warn:(NSString *) format, ... ;
/**
 * Log with lifecycle level
 * @param format format string
 * @param ... variable length argument list.
 */
+ (void) notice:(NSString *) format, ... ;
/**
 * Log with debug level
 * @param format format string
 * @param ... variable length argument list.
 */
+ (void) debug:(NSString *) format, ... ;
/**
 * Log with XHR level
 * @param format format string
 * @param ... variable length argument list.
 */
+ (void) requestLog:(NSString *) format, ... ;
/**
 * Log an exception
 * @param exception The exception to log
 */
+ (void) logException:(NSException *) exception;
/**
 * Adds a logger delegate
 *
 * The logger delegate will be called whenever a log method is called passing it the log message and level
 * @param delegate An object that conforms to the YBLogger protocol.
 */
+ (void) addLoggerDelegate:(NSObject<YBLogger> *) delegate;
/**
 * Removes a logger delegate
 *
 * @param delegate An object that conforms to the YBLogger protocol.
 */
+ (void) removeLoggerDelegate:(NSObject<YBLogger> *) delegate;

/**
 * Returns true if the current log level is less or equal than the param.
 * This is useful to avoid calling logging methods when they're not going to be printed, for
 * instance when it's expensive to generate the string to log.
 * @param level The leel to check against.
 * @returns true if the current <debugLevel> is less than or equal to level.
 */
+ (bool) isAtLeastLevel:(YBLogLevel) level;
@end
