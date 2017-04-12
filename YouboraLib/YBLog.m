//
//  YBLog.m
//  YouboraLib
//
//  Created by Joan on 16/03/2017.
//  Copyright © 2017 NPAW. All rights reserved.
//

#import "YBLog.h"

/// Current log level
static YBLogLevel currentLogLevel = YBLogLevelError;
/// Logger delegate instance
static NSMutableArray<NSObject<YBLogger> *> * loggers;

@implementation YBLog

#pragma mark - Public methods
+ (void) reportLogMessageWithLevel:(YBLogLevel) logLevel andMessage:(NSString *) format, ... {

    va_list ap;
    va_start(ap, format);
    [YBLog reportLogMessageWithLevel:logLevel andMessage:format arguments:ap];
    va_end(ap);
}

+ (void) addLoggerDelegate:(NSObject<YBLogger> *) delegate {
    if (delegate != nil) {
        if (loggers == nil) {
            loggers = [NSMutableArray arrayWithObject:delegate];
        } else if (![loggers containsObject:delegate]) {
            [loggers addObject:delegate];
        }
    }
}

+ (void) removeLoggerDelegate:(NSObject<YBLogger> *)delegate {
    if (delegate != nil && loggers != nil) {
        [loggers removeObject:delegate];
    }
}

+ (YBLogLevel) debugLevel {
    return currentLogLevel;
}

+ (void) setDebugLevel:(YBLogLevel) debugLevel {
    currentLogLevel = debugLevel;
}

+ (void) error:(NSString *) format, ... {
    va_list ap;
    va_start(ap, format);
    [YBLog reportLogMessageWithLevel:YBLogLevelError andMessage:format arguments:ap];
    va_end(ap);
}

+ (void) warn:(NSString *) format, ... {
    va_list ap;
    va_start(ap, format);
    [YBLog reportLogMessageWithLevel:YBLogLevelWarning andMessage:format arguments:ap];
    va_end(ap);
}

+ (void) notice:(NSString *) format, ... {
    va_list ap;
    va_start(ap, format);
    [YBLog reportLogMessageWithLevel:YBLogLevelNotice andMessage:format arguments:ap];
    va_end(ap);
}

+ (void) debug:(NSString *) format, ... {
    va_list ap;
    va_start(ap, format);
    [YBLog reportLogMessageWithLevel:YBLogLevelDebug andMessage:format arguments:ap];
    va_end(ap);
}

+ (void) requestLog:(NSString *) format, ... {
    va_list ap;
    va_start(ap, format);
    [YBLog reportLogMessageWithLevel:YBLogLevelVerbose andMessage:format arguments:ap];
    va_end(ap);
}

+ (void) logException:(NSException *) exception {
    // This logs exceptions with the same level as error
    NSString * str = [NSString stringWithFormat:@"Exception: %@. Stack trace:\n%@", exception.reason, exception.callStackSymbols];
    [YBLog error:@"%@", str];
}

+ (bool) isAtLeastLevel:(YBLogLevel) level {
    return currentLogLevel <= level;
}

#pragma mark - Private methods
/// ---------------------------------
/// @name Private methods
/// ---------------------------------
/**
 * Generic logging method
 *
 * @param logLevel the log level to use for this message
 * @param format format string
 * @param args va_list with the arguments to fill the format string
 */
+ (void) reportLogMessageWithLevel:(YBLogLevel) logLevel andMessage:(NSString *) format arguments:(va_list) args {
    
    bool isAtLeastRequestedLevel = [YBLog isAtLeastLevel:logLevel];
    
    if (isAtLeastRequestedLevel || (loggers != nil && loggers.count > 0)) {
    
        // Build string
        NSString * customFormat = [NSString stringWithFormat:@"[Youbora: %i] %@", (int) logLevel, format];
        
        // Create formatted string from variable argument list
        NSString * str = [[NSString alloc] initWithFormat:customFormat arguments:args];
        
        if (isAtLeastRequestedLevel) {
            // Log it
            NSLog(@"%@",str);
        }
        
        // Call the delegates if any
        for (NSObject<YBLogger> * logger in loggers) {
            @try {
                [logger logYouboraMessage:str withLogLevel:logLevel];
            } @catch (NSException *exception) {
                
            }
        }
    }
}

@end
