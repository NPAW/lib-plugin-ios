//
//  YBPlaybackChronosTest.m
//  YouboraLib
//
//  Created by Joan on 20/03/2017.
//  Copyright © 2017 NPAW. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "YBPlaybackChronos.h"

@interface YBPlaybackChronosTest : XCTestCase

@end

@implementation YBPlaybackChronosTest

- (void)testNonNull {
    YBPlaybackChronos * chronos = [YBPlaybackChronos new];
    
    XCTAssertNotNil(chronos.buffer);
    XCTAssertNotNil(chronos.seek);
    XCTAssertNotNil(chronos.join);
    XCTAssertNotNil(chronos.pause);
    XCTAssertNotNil(chronos.total);
}

- (void)testReset {
    YBPlaybackChronos * chronos = [YBPlaybackChronos new];

    YBChrono * chronobuffer = chronos.buffer;
    YBChrono * chronoseek = chronos.seek;
    YBChrono * chronojoin = chronos.join;
    YBChrono * chronopause = chronos.pause;
    YBChrono * chronototal = chronos.total;
    
    [chronos reset];
        
    XCTAssertNotEqualObjects(chronobuffer, chronos.buffer);
    XCTAssertNotEqualObjects(chronoseek, chronos.seek);
    XCTAssertNotEqualObjects(chronojoin, chronos.join);
    XCTAssertNotEqualObjects(chronopause, chronos.pause);
    XCTAssertNotEqualObjects(chronototal, chronos.total);
}

@end
