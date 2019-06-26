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
    
    XCTAssertLessThan(-1, [self.chrono stop]);
    XCTAssertLessThan(-1, [self.chrono getDeltaTime]);
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
