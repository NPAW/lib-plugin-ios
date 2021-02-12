//
//  YBPlayerAdapterTest.m
//  YouboraLib
//
//  Created by Joan on 21/03/2017.
//  Copyright © 2017 NPAW. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "YBTestablePlayerAdapter.h"
#import "YBPlayheadMonitor.h"
#import "YBPlugin.h"

#import "YouboraLib/YouboraLib-Swift.h"

#import <OCHamcrest/OCHamcrest.h>
#import <OCMockito/OCMockito.h>

@interface YBPlayerAdapterTest : XCTestCase

@end

@implementation YBPlayerAdapterTest

- (void)testRegisterUnregister {
    YBTestablePlayerAdapter * adapter = [[YBTestablePlayerAdapter alloc] initWithPlayer:YBConstantsRequest.player];
    
    XCTAssertEqual(1, adapter.registeredTimes);
    XCTAssertEqual(0, adapter.unregisteredTimes);
    
    [adapter dispose];
    
    XCTAssertEqual(1, adapter.registeredTimes);
    XCTAssertEqual(1, adapter.unregisteredTimes);
    
}

- (void)testDispose {
    
    YBTestablePlayerAdapter * adapter = [[YBTestablePlayerAdapter alloc] initWithPlayer:YBConstantsRequest.player];

    YBPlayheadMonitor * mockMonitor = adapter.mockMonitor;
    
    [adapter monitorPlayheadWithBuffers:true seeks:true andInterval:800];
    
    [adapter dispose];
    
    XCTAssertEqual(1, adapter.stopTimes);
    [(YBPlayheadMonitor*)verifyCount(mockMonitor, times(1)) stop];
    XCTAssertEqual(1, adapter.unregisteredTimes);
    XCTAssertNil(adapter.player);
    
}

- (void)testSettersGetters {
    YBTestablePlayerAdapter * adapter = [[YBTestablePlayerAdapter alloc] initWithPlayer:YBConstantsRequest.player];

    // Plugin
    YBPlugin * mockPlugin = mock([YBPlugin class]);
    [adapter setPlugin:mockPlugin];
    XCTAssertEqualObjects(mockPlugin, adapter.plugin);
    
    // Chronos
    XCTAssertNotNil(adapter.chronos);
    
    // Flags
    XCTAssertNotNil(adapter.flags);
    
    // Monitor nil
    XCTAssertNil(adapter.monitor);
    
    // Monitor not nil
    [adapter monitorPlayheadWithBuffers:true seeks:true andInterval:800];
    XCTAssertEqualObjects(adapter.mockMonitor, adapter.monitor);
}

- (void)testInfoMethodsDefaults {
    YBPlayerAdapter * adapter = [YBPlayerAdapter new];
    
    XCTAssertNil([adapter getPlayhead]);
    XCTAssertEqualObjects(@1, [adapter getPlayrate]);
    XCTAssertNil([adapter getFramesPerSecond]);
    XCTAssertNil([adapter getDroppedFrames]);
    XCTAssertNil([adapter getDuration]);
    XCTAssertNil([adapter getBitrate]);
    XCTAssertNil([adapter getTotalBytes]);
    XCTAssertNil([adapter getThroughput]);
    XCTAssertNil([adapter getRendition]);
    XCTAssertNil([adapter getTitle]);
    XCTAssertNil([adapter getProgram]);
    XCTAssertNil([adapter getIsLive]);
    XCTAssertNil([adapter getResource]);
    XCTAssertNil([adapter getPlayerVersion]);
    XCTAssertNil([adapter getPlayerName]);
    XCTAssertNil([adapter getMetrics]);
    XCTAssertEqual(YBAdPositionUnknown, [adapter getPosition]);

    XCTAssertEqualObjects([YBConstants.youboraLibVersion stringByAppendingString:@"-generic-ios"], [adapter getVersion]);
}

- (void)testFireMethodsFlags {
    YBPlayerAdapter * adapter = [YBPlayerAdapter new];

    YBPlaybackFlags * flags = adapter.flags;
    
    // Initial state
    XCTAssertFalse(flags.preloading);
    XCTAssertFalse(flags.started);
    XCTAssertFalse(flags.joined);
    XCTAssertFalse(flags.buffering);
    XCTAssertFalse(flags.seeking);
    XCTAssertFalse(flags.paused);
    
    // Start
    [adapter fireStart];
    
    XCTAssertFalse(flags.preloading);
    XCTAssertTrue(flags.started);
    XCTAssertFalse(flags.joined);
    XCTAssertFalse(flags.buffering);
    XCTAssertFalse(flags.seeking);
    XCTAssertFalse(flags.paused);
    
    // Join
    [adapter fireJoin];
    
    XCTAssertFalse(flags.preloading);
    XCTAssertTrue(flags.started);
    XCTAssertTrue(flags.joined);
    XCTAssertFalse(flags.buffering);
    XCTAssertFalse(flags.seeking);
    XCTAssertFalse(flags.paused);
    
    // Pause
    [adapter firePause];
    
    XCTAssertFalse(flags.preloading);
    XCTAssertTrue(flags.started);
    XCTAssertTrue(flags.joined);
    XCTAssertFalse(flags.buffering);
    XCTAssertFalse(flags.seeking);
    XCTAssertTrue(flags.paused);
    
    // Resume
    [adapter fireResume];
    
    XCTAssertFalse(flags.preloading);
    XCTAssertTrue(flags.started);
    XCTAssertTrue(flags.joined);
    XCTAssertFalse(flags.buffering);
    XCTAssertFalse(flags.seeking);
    XCTAssertFalse(flags.paused);
    
    // Buffer start
    [adapter fireBufferBegin];
    
    XCTAssertFalse(flags.preloading);
    XCTAssertTrue(flags.started);
    XCTAssertTrue(flags.joined);
    XCTAssertTrue(flags.buffering);
    XCTAssertFalse(flags.seeking);
    XCTAssertFalse(flags.paused);
    
    // Buffer end
    [adapter fireBufferEnd];
    
    XCTAssertFalse(flags.preloading);
    XCTAssertTrue(flags.started);
    XCTAssertTrue(flags.joined);
    XCTAssertFalse(flags.buffering);
    XCTAssertFalse(flags.seeking);
    XCTAssertFalse(flags.paused);
    
    // Seek start
    [adapter fireSeekBegin];
    
    XCTAssertFalse(flags.preloading);
    XCTAssertTrue(flags.started);
    XCTAssertTrue(flags.joined);
    XCTAssertFalse(flags.buffering);
    XCTAssertTrue(flags.seeking);
    XCTAssertFalse(flags.paused);
    
    // Seek end
    [adapter fireSeekEnd];
    
    XCTAssertFalse(flags.preloading);
    XCTAssertTrue(flags.started);
    XCTAssertTrue(flags.joined);
    XCTAssertFalse(flags.buffering);
    XCTAssertFalse(flags.seeking);
    XCTAssertFalse(flags.paused);
    
    // Stop
    [adapter fireStop];
    
    XCTAssertFalse(flags.preloading);
    XCTAssertFalse(flags.started);
    XCTAssertFalse(flags.joined);
    XCTAssertFalse(flags.buffering);
    XCTAssertFalse(flags.seeking);
    XCTAssertFalse(flags.paused);
    
    // Start then error (non fatal)
    [adapter fireStart];
    [adapter fireErrorWithMessage:nil code:nil andMetadata:nil];
    
    XCTAssertFalse(flags.preloading);
    XCTAssertTrue(flags.started);
    XCTAssertFalse(flags.joined);
    XCTAssertFalse(flags.buffering);
    XCTAssertFalse(flags.seeking);
    XCTAssertFalse(flags.paused);
    
    // Start then fatal error
    [adapter fireStart];
    [adapter fireFatalErrorWithMessage:nil code:nil andMetadata:nil];
    
    XCTAssertFalse(flags.preloading);
    XCTAssertFalse(flags.started);
    XCTAssertFalse(flags.joined);
    XCTAssertFalse(flags.buffering);
    XCTAssertFalse(flags.seeking);
    XCTAssertFalse(flags.paused);
}

- (void)testFireMethodsCallbacks {
    YBPlayerAdapter * adapter = [YBPlayerAdapter new];

    id<YBPlayerAdapterEventDelegate> mockDelegate = mockProtocol(@protocol(YBPlayerAdapterEventDelegate));
    
    [adapter addYouboraAdapterDelegate:mockDelegate];
    
    [adapter fireStart];
    [verify(mockDelegate) youboraAdapterEventStart:anything() fromAdapter:adapter];
    
    [adapter fireJoin];
    [verify(mockDelegate) youboraAdapterEventJoin:anything() fromAdapter:adapter];
    
    [adapter firePause];
    [verify(mockDelegate) youboraAdapterEventPause:anything() fromAdapter:adapter];
    
    [adapter fireResume];
    [verify(mockDelegate) youboraAdapterEventResume:anything() fromAdapter:adapter];
    
    [adapter fireBufferBegin];
    [verify(mockDelegate) youboraAdapterEventBufferBegin:anything() convertFromSeek:false fromAdapter:adapter];
    
    [adapter fireBufferEnd];
    [verify(mockDelegate) youboraAdapterEventBufferEnd:anything() fromAdapter:adapter];
    
    [adapter fireSeekBegin];
    [verify(mockDelegate) youboraAdapterEventSeekBegin:anything() convertFromBuffer:true fromAdapter:adapter];
    
    [adapter fireSeekEnd];
    [verify(mockDelegate) youboraAdapterEventSeekEnd:anything() fromAdapter:adapter];
    
    [adapter fireEventWithName:@"name" dimensions:@{} values:@{} topLevelDimensions:@{}];
    [verify(mockDelegate) youboraAdapterEventVideoEvent:anything() fromAdapter:adapter];
    
    [adapter fireStop];
    [verify(mockDelegate) youboraAdapterEventStop:anything() fromAdapter:adapter];
    
    // Error
    HCArgumentCaptor * captor = [HCArgumentCaptor new];
    
    [adapter fireStart];
    [verifyCount(mockDelegate, times(1)) youboraAdapterEventStart:anything() fromAdapter:adapter];
    [adapter fireError:nil];
    [verify(mockDelegate) youboraAdapterEventError:(id) captor fromAdapter:adapter];
    
    // stop should be still only have been called once
    // (so never for OCMockito since the count is reset when verify is called)
    [verifyCount(mockDelegate, never()) youboraAdapterEventStop:anything() fromAdapter:adapter];
    NSDictionary * errorParams = captor.value;
    //XCTAssertEqualObjects(@"error", errorParams[@"errorLevel"]); //Not mandatory anymore, since it's hard to differentiate between error at plugin level only the fatal one is send

    // Fatal error
    captor = [HCArgumentCaptor new];
    [adapter fireFatalErrorWithMessage:@"Message" code:@"Code" andMetadata:nil];
    [verifyCount(mockDelegate, times(1)) youboraAdapterEventError:(id) captor fromAdapter:adapter];
    
    [verifyCount(mockDelegate, times(1)) youboraAdapterEventStop:anything() fromAdapter:adapter];
    errorParams = captor.value;
    //XCTAssertEqualObjects(@"fatal", errorParams[@"errorLevel"]); //Not mandatory anymore, since it's hard to differentiate between error at plugin level only the fatal one is send
}

- (void)testBufferToSeek {
    YBPlayerAdapter * adapter = [YBPlayerAdapter new];

    id<YBPlayerAdapterEventDelegate> mockDelegate = mockProtocol(@protocol(YBPlayerAdapterEventDelegate));
    [adapter addYouboraAdapterDelegate:mockDelegate];
    
    [adapter fireStart];
    [adapter fireJoin];
    
    [adapter fireBufferBegin];
    [adapter fireSeekBegin];
    [adapter fireBufferEnd];
    [adapter fireSeekEnd];
    
    [verifyCount(mockDelegate, times(1)) youboraAdapterEventStart:anything() fromAdapter:adapter];
    [verifyCount(mockDelegate, times(1)) youboraAdapterEventJoin:anything() fromAdapter:adapter];
    [verifyCount(mockDelegate, times(1)) youboraAdapterEventBufferBegin:anything() convertFromSeek:false fromAdapter:adapter];
    [verifyCount(mockDelegate, times(1)) youboraAdapterEventSeekBegin:anything() convertFromBuffer:true fromAdapter:adapter];
    [verifyCount(mockDelegate, times(1)) youboraAdapterEventSeekEnd:anything() fromAdapter:adapter];
    [verifyCount(mockDelegate, never()) youboraAdapterEventBufferEnd:anything() fromAdapter:adapter];
}

- (void)testAddRemoveDelegate {
    YBPlayerAdapter * adapter = [YBPlayerAdapter new];

    id<YBPlayerAdapterEventDelegate> mockDelegate = mockProtocol(@protocol(YBPlayerAdapterEventDelegate));
    
    // Nothing should happen
    [adapter removeYouboraAdapterDelegate:mockDelegate];
    
    // Add twice
    [adapter addYouboraAdapterDelegate:mockDelegate];
    [adapter addYouboraAdapterDelegate:mockDelegate];
    
    [adapter fireStart];
    [adapter fireStop];
    
    // Should have been called only once
    [verifyCount(mockDelegate, times(1)) youboraAdapterEventStart:anything() fromAdapter:adapter];
    [verifyCount(mockDelegate, times(1)) youboraAdapterEventStop:anything() fromAdapter:adapter];
    
    // Remove
    [adapter removeYouboraAdapterDelegate:mockDelegate];
    
    // Fire more events
    [adapter fireStart];
    [adapter fireStop];
    
    // Verify delegate not called
    [verifyCount(mockDelegate, never()) youboraAdapterEventStart:anything() fromAdapter:adapter];
    [verifyCount(mockDelegate, never()) youboraAdapterEventStop:anything() fromAdapter:adapter];
}

- (void)testDefaultPlayrateImplementation {
    YBPlayerAdapter * adapter = [YBPlayerAdapter new];

    XCTAssertEqualObjects(@1, [adapter getPlayrate]);
    
    [adapter fireStart];
    [adapter fireJoin];
    
    XCTAssertEqualObjects(@1, [adapter getPlayrate]);
    
    [adapter firePause];
    
    XCTAssertEqualObjects(@0, [adapter getPlayrate]);
    
    [adapter fireResume];
    
    XCTAssertEqualObjects(@1, [adapter getPlayrate]);
}

- (void) testAdClickWithValidUrl {
    YBPlayerAdapter * adapter = [YBPlayerAdapter new];
    
    id<YBPlayerAdapterEventDelegate> mockDelegate = mockProtocol(@protocol(YBPlayerAdapterEventDelegate));
    [adapter addYouboraAdapterDelegate:mockDelegate];
    
    [adapter fireStart];
    [adapter fireClickWithAdUrl:@"fake"];
    
    HCArgumentCaptor * captor = [HCArgumentCaptor new];
    [verifyCount(mockDelegate, times(1)) youboraAdapterEventClick:(id) captor fromAdapter:adapter];
    XCTAssertTrue(captor.value[YBConstantsRequest.adUrl] != nil);
    NSString *adUrl = [captor.value objectForKey:YBConstantsRequest.adUrl];
    XCTAssertTrue([adUrl isEqualToString:@"fake"]);
    
}

- (void) testAdClickWithInvalidUrl {
    YBPlayerAdapter * adapter = [YBPlayerAdapter new];
    
    id<YBPlayerAdapterEventDelegate> mockDelegate = mockProtocol(@protocol(YBPlayerAdapterEventDelegate));
    [adapter addYouboraAdapterDelegate:mockDelegate];
    
    [adapter fireStart];
    [adapter fireClickWithAdUrl:nil];
    
    HCArgumentCaptor * captor = [HCArgumentCaptor new];
    [verifyCount(mockDelegate, times(1)) youboraAdapterEventClick:(id) captor fromAdapter:adapter];
    XCTAssertTrue(captor.value[YBConstantsRequest.adUrl] == nil);
}

- (void) testFireSkip {
    YBPlayerAdapter * adapter = [YBPlayerAdapter new];
    
    id<YBPlayerAdapterEventDelegate> mockDelegate = mockProtocol(@protocol(YBPlayerAdapterEventDelegate));
    [adapter addYouboraAdapterDelegate:mockDelegate];
    
    [adapter fireStart];
    [adapter fireSkip];
    
    HCArgumentCaptor * captor = [HCArgumentCaptor new];
    [verifyCount(mockDelegate, times(1)) youboraAdapterEventStop:(id) captor fromAdapter:adapter];
    XCTAssertTrue(captor.value[@"skipped"] != nil);
    NSString* skipped = captor.value[@"skipped"];
    XCTAssertTrue([skipped isEqualToString:@"true"]);
}

- (void) testFireCast {
    YBPlayerAdapter * adapter = [YBPlayerAdapter new];
    
    id<YBPlayerAdapterEventDelegate> mockDelegate = mockProtocol(@protocol(YBPlayerAdapterEventDelegate));
    [adapter addYouboraAdapterDelegate:mockDelegate];
    
    [adapter fireStart];
    [adapter fireCast];
    
    HCArgumentCaptor * captor = [HCArgumentCaptor new];
    [verifyCount(mockDelegate, times(1)) youboraAdapterEventStop:(id) captor fromAdapter:adapter];
    XCTAssertTrue(captor.value[@"casted"] != nil);
    NSString* skipped = captor.value[@"casted"];
    XCTAssertTrue([skipped isEqualToString:@"true"]);
}

- (void) testFireVideoEvent {
    YBPlayerAdapter * adapter = [YBPlayerAdapter new];
    
    id<YBPlayerAdapterEventDelegate> mockDelegate = mockProtocol(@protocol(YBPlayerAdapterEventDelegate));
    [adapter addYouboraAdapterDelegate:mockDelegate];
    
    [adapter fireStart];
    [adapter fireEventWithName:@"name" dimensions:@{@"key" : @"value"} values:@{@"key" : @(1)} topLevelDimensions:@{@"topDimKey" : @"value"}];
    HCArgumentCaptor * captor = [HCArgumentCaptor new];
    [verifyCount(mockDelegate, times(1)) youboraAdapterEventVideoEvent:(id) captor fromAdapter:adapter];
    XCTAssertEqual(captor.value[@"name"], @"name");
    XCTAssertEqualObjects(captor.value[@"dimensions"], @{@"key" : @"value"});
    XCTAssertEqualObjects(captor.value[@"values"], @{@"key" : @(1)});
    XCTAssertEqualObjects(captor.value[@"topDimKey"], @"value"); // As it is not inside a dictionary
}

- (void) testFireVideoEventWrongParams {
    YBPlayerAdapter * adapter = [YBPlayerAdapter new];
    
    id<YBPlayerAdapterEventDelegate> mockDelegate = mockProtocol(@protocol(YBPlayerAdapterEventDelegate));
    [adapter addYouboraAdapterDelegate:mockDelegate];
    
    [adapter fireStart];
    [adapter fireEventWithName:@"" dimensions:@{@"key" : @"value"} values:@{@"key" : @(1)} topLevelDimensions:@{@"topDimKey" : @"value"}];
    HCArgumentCaptor * captor = [HCArgumentCaptor new];
    [verifyCount(mockDelegate, times(1)) youboraAdapterEventVideoEvent:(id) captor fromAdapter:adapter];
    XCTAssertEqualObjects(captor.value[@"name"], @"");
    XCTAssertEqualObjects(captor.value[@"dimensions"], @{@"key" : @"value"});
    XCTAssertEqualObjects(captor.value[@"values"], @{@"key" : @(1)});
    XCTAssertEqualObjects(captor.value[@"topDimKey"], @"value"); // As it is not inside a dictionary

    [adapter fireEventWithName:nil dimensions:nil values:nil topLevelDimensions:nil];
    captor = [HCArgumentCaptor new];
    [verifyCount(mockDelegate, times(1)) youboraAdapterEventVideoEvent:(id) captor fromAdapter:adapter];
    XCTAssertEqualObjects(captor.value[@"name"], @"");
    XCTAssertEqualObjects(captor.value[@"dimensions"], @{});
    XCTAssertEqualObjects(captor.value[@"values"], @{});
}

@end
