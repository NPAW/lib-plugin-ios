//
//  YBChronoTest.m
//  YouboraLib
//
//  Created by Joan on 15/03/2017.
//  Copyright © 2017 NPAW. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "YouboraLib/YouboraLib-Swift.h"

@interface YBChronoTest : XCTestCase

@property (nonatomic, strong) YBChrono * chrono;

@end

@implementation YBChronoTest

- (void)setUp {
    [super setUp];
    self.chrono = [YBChrono new];
}

- (void) testStart {
    [self.chrono start];
    XCTAssertNotEqual(0, self.chrono.startTime);
}

- (void)testStop {
    [self.chrono start];
    
    long long stopDiff = [self.chrono stop];
    
    XCTAssertEqual(self.chrono.stopTime - self.chrono.startTime, stopDiff);
    XCTAssertEqual([self.chrono getDeltaTime], stopDiff);
    
    self.chrono.pauseTime = 1;
    [self.chrono stop];
    
    XCTAssertEqual(0, self.chrono.pauseTime);
}

- (void)testPause {
    [self.chrono pause];
    
    XCTAssertTrue(self.chrono.pauseTime > 0);
}

- (void)testResume {
    long long now = [[YBChrono new] now];
    
    [self.chrono resume];

    XCTAssertEqual(self.chrono.offset, -now);

    self.chrono.pauseTime = 1;
    [self.chrono resume];
    
    XCTAssertTrue(self.chrono.offset < 0);
    XCTAssertEqual(self.chrono.pauseTime, 0);
}

- (void)testGetDeltaTime {
    [self.chrono start];
    XCTAssertNotEqual(-1, [self.chrono getDeltaTime:true]);
    XCTAssertNotEqual(-1, [self.chrono getDeltaTime]);
    
    [self.chrono start];
    XCTAssertNotEqual(-1, [self.chrono getDeltaTime:false]);
    
    [self.chrono stop];
    XCTAssertNotEqual(-1, [self.chrono getDeltaTime]);
}

- (void)testGetDeltaTimeWithPause {
    [self.chrono start];
    
    long long pauseTime = 1;
    long long now = [[YBChrono new] now];
    
    [self.chrono stop];
    self.chrono.pauseTime = pauseTime;
    long long stopDiff = [self.chrono getDeltaTime:false];
    
    XCTAssertEqual((self.chrono.stopTime - self.chrono.startTime) - (now - pauseTime), stopDiff);
}

- (void)testStopBeforeStart {
    XCTAssertEqual(-1, [self.chrono stop]);
    XCTAssertEqual(-1, [self.chrono getDeltaTime]);
}

- (void)testClone {
    self.chrono.startTime = 1;
    self.chrono.stopTime = 2;
    self.chrono.offset = 3;
    
    YBChrono * chrono2 = [self.chrono copy];
    
    XCTAssertEqual(self.chrono.startTime, chrono2.startTime);
    XCTAssertEqual(self.chrono.stopTime, chrono2.stopTime);
    XCTAssertEqual(self.chrono.offset, chrono2.offset);
}

- (void)testReset {
    self.chrono.startTime = 1;
    self.chrono.stopTime = 2;
    self.chrono.offset = 3;
    
    [self.chrono reset];
    
    YBChrono * chrono2 = [YBChrono new];
    
    XCTAssertEqual(self.chrono.startTime, chrono2.startTime);
    XCTAssertEqual(self.chrono.stopTime, chrono2.stopTime);
    XCTAssertEqual(self.chrono.offset, chrono2.offset);
}

@end
