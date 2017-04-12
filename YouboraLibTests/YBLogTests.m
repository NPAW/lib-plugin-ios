//
//  YBLogTests.m
//  YouboraLib
//
//  Created by Joan on 16/03/2017.
//  Copyright © 2017 NPAW. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "YBLog.h"

@interface YBLogTests : XCTestCase<YBLogger>

@property(copy) void(^delegateCallback)(NSString * delegateMessage, YBLogLevel delegateLogLevel);

@end

@implementation YBLogTests

- (void)testLogLevel {
    [YBLog setDebugLevel:YBLogLevelError];
    
    XCTAssertEqual(YBLogLevelError, [YBLog debugLevel]);
    
    [YBLog setDebugLevel:YBLogLevelWarning];
    
    XCTAssertEqual(YBLogLevelWarning, [YBLog debugLevel]);
}

- (void)testLogCallbacks {
    
    __block int pendingCallbacks = 6;
    
    [YBLog setDebugLevel:YBLogLevelSilent];
    
    __weak id weakSelf = self;
    self.delegateCallback = ^(NSString * delegateMessage, YBLogLevel delegateLogLevel) {
        pendingCallbacks--;
        id self = weakSelf;
        switch (pendingCallbacks) {
            case 5:
                XCTAssertTrue([delegateMessage containsString:@"requestLog"]);
                XCTAssertEqual(YBLogLevelVerbose, delegateLogLevel);
                break;
            case 4:
                XCTAssertTrue([delegateMessage containsString:@"debug"]);
                XCTAssertEqual(YBLogLevelDebug, delegateLogLevel);
                break;
            case 3:
                XCTAssertTrue([delegateMessage containsString:@"notice"]);
                XCTAssertEqual(YBLogLevelNotice, delegateLogLevel);
                break;
            case 2:
                XCTAssertTrue([delegateMessage containsString:@"warn"]);
                XCTAssertEqual(YBLogLevelWarning, delegateLogLevel);
                break;
            case 1:
                XCTAssertTrue([delegateMessage containsString:@"error"]);
                XCTAssertEqual(YBLogLevelError, delegateLogLevel);
                break;
            case 0:
                XCTAssertTrue([delegateMessage containsString:@"Exception"]);
                XCTAssertEqual(YBLogLevelError, delegateLogLevel);
                break;
            default:
                XCTFail(@"unexpected pendingCallbacks");
                break;
        }
    };
    
    [YBLog addLoggerDelegate:self];
    [YBLog requestLog:@"requestLog"];
    [YBLog debug:@"debug"];
    [YBLog notice:@"notice"];
    [YBLog warn:@"warn"];
    [YBLog error:@"error"];
    [YBLog logException:[NSException exceptionWithName:@"SampleException" reason:nil userInfo:nil]];
    
    XCTAssertEqual(0, pendingCallbacks);
}

- (void)testAddRemoveLogger {
    
    __block int callbackCount = 0;
    
    self.delegateCallback = ^(NSString * delegateMessage, YBLogLevel delegateLogLevel) {
        callbackCount++;
    };
    
    [YBLog addLoggerDelegate:self];
    
    [YBLog debug:@"debug"]; // 1
    
    // This shouldn't do anything
    [YBLog addLoggerDelegate:self];
    
    [YBLog notice:@"notice"]; // 2
    [YBLog warn:@"warn"]; // 3
    
    [YBLog removeLoggerDelegate:self];
    [YBLog removeLoggerDelegate:self];

    [YBLog debug:@"debug"];
    [YBLog notice:@"notice"];
    [YBLog warn:@"warn"];
    
    XCTAssertEqual(3, callbackCount);
}

// Delegate
- (void) logYouboraMessage:(NSString *) message withLogLevel:(YBLogLevel) logLevel {
    if (self.delegateCallback != nil) {
        self.delegateCallback(message, logLevel);
    }
}


@end
