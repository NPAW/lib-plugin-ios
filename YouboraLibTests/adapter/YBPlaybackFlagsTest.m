//
//  YBPlaybackFlagsTest.m
//  YouboraLib
//
//  Created by Joan on 20/03/2017.
//  Copyright © 2017 NPAW. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "YouboraLib/YouboraLib-Swift.h"

@interface YBPlaybackFlagsTest : XCTestCase

@end

@implementation YBPlaybackFlagsTest

- (void)testDefaultValues {
    YBPlaybackFlags * flags = [YBPlaybackFlags new];
    
    XCTAssertFalse(flags.buffering);
    XCTAssertFalse(flags.joined);
    XCTAssertFalse(flags.paused);
    XCTAssertFalse(flags.preloading);
    XCTAssertFalse(flags.seeking);
    XCTAssertFalse(flags.started);
}

- (void)testSetValues {
    YBPlaybackFlags * flags = [YBPlaybackFlags new];

    flags.buffering = true;
    flags.joined = true;
    flags.paused = true;
    flags.preloading = true;
    flags.seeking = true;
    flags.started = true;
    
    XCTAssertTrue(flags.buffering);
    XCTAssertTrue(flags.joined);
    XCTAssertTrue(flags.paused);
    XCTAssertTrue(flags.preloading);
    XCTAssertTrue(flags.seeking);
    XCTAssertTrue(flags.started);
}

- (void)testReset {
    YBPlaybackFlags * flags = [YBPlaybackFlags new];
    
    flags.buffering = true;
    flags.joined = true;
    flags.paused = true;
    flags.preloading = true;
    flags.seeking = true;
    flags.started = true;
    
    [flags reset];
    
    XCTAssertFalse(flags.buffering);
    XCTAssertFalse(flags.joined);
    XCTAssertFalse(flags.paused);
    XCTAssertFalse(flags.preloading);
    XCTAssertFalse(flags.seeking);
    XCTAssertFalse(flags.started);
}

@end
