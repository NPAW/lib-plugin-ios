//
//  YBTimerTest.m
//  YouboraLib
//
//  Created by Joan on 16/03/2017.
//  Copyright © 2017 NPAW. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "YBTimer.h"

@interface YBTimerTest : XCTestCase

@end

@implementation YBTimerTest

- (void)testIsRunning {
    YBTimer * t = [[YBTimer alloc] initWithCallback:nil];
    
    XCTAssertFalse(t.isRunning);
    
    [t start];
    
    XCTAssertTrue(t.isRunning);
    
    [t stop];
    
    XCTAssertFalse(t.isRunning);
}

- (void)testTicks {
    
    __block int ticks = 3;
    
    XCTestExpectation * expectation = [self expectationWithDescription:@"callback called"];
    
    TimerCallback callback1 = ^(YBTimer *timer, long long diffTime) {
        ticks--;
        XCTAssertNotEqual(0, diffTime);
        if (ticks == 0) {
            [expectation fulfill];
        }
    };
    
    TimerCallback callback2 = ^(YBTimer *timer, long long diffTime) {
        ticks--;
        XCTAssertNotEqual(0, diffTime);
        if (ticks == 0) {
            [expectation fulfill];
        }
    };
    
    YBTimer * t = [[YBTimer alloc] initWithCallback:callback1 andInterval:10]; // 10ms
    [t addTimerCallback:callback2];
    
    [t start];
    
    [self waitForExpectationsWithTimeout:10 handler:^(NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
        }
    }];
    
}

@end
