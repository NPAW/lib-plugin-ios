//
//  YBPluginTest.m
//  YouboraLib
//
//  Created by Joan on 28/03/2017.
//  Copyright © 2017 NPAW. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMockito/OCMockito.h>
#import <OCHamcrest/OCHamcrest.h>

#import "YBPlugin.h"
#import "YBTestablePlugin.h"

#import "YBRequestBuilder.h"
#import "YBOptions.h"
#import "YBLog.h"
#import "YBViewTransform.h"
#import "YBResourceTransform.h"
#import "YBPlayerAdapter.h"
#import "YBRequest.h"
#import "YBCommunication.h"
#import "YBTimer.h"
#import "YBPlaybackChronos.h"
#import "YBFastDataConfig.h"
#import "YBFlowTransform.h"
#import "YBPlayheadMonitor.h"
#import "YBInfinityFlags.h"


#import "YouboraLib/YouboraLib-Swift.h"

@interface YBPluginTest : XCTestCase

@property(nonatomic, strong) YBPlayerAdapter * mockAdapter;
@property(nonatomic, strong) YBPlayerAdapter *mockAdAdapter;
@property(nonatomic, strong) YBOptions *options;
@property(nonatomic, strong) YBOptions *defaultOptions;

@property(nonatomic, strong) YBTestablePlugin * p;

@end

@implementation YBPluginTest

- (void)setUp {
    [super setUp];
    
    self.mockAdapter = mock([YBPlayerAdapter class]);
    self.mockAdAdapter = mock([YBPlayerAdapter class]);
    self.defaultOptions = [YBOptionsFactory createOptions];
    self.options = [YBOptionsFactory createOptions];
    
    self.p = [[YBTestablePlugin alloc] initWithOptions:self.options andAdapter:self.mockAdapter];
    
    // Adapters will use real flags and chronos
    YBPlaybackFlags * adapterFlags = [YBPlaybackFlags new];
    YBPlaybackChronos * adapterChronos = [YBPlaybackChronos new];
    
    stubProperty(self.mockAdapter, flags, adapterFlags);
    stubProperty(self.mockAdapter, chronos, adapterChronos);
    
    YBPlaybackFlags * adAdapterFlags = [YBPlaybackFlags new];
    YBPlaybackChronos * adAdapterChronos = [YBPlaybackChronos new];
    
    stubProperty(self.mockAdAdapter, flags, adAdapterFlags);
    stubProperty(self.mockAdAdapter, chronos, adAdapterChronos);
}

- (void)tearDown {
    
    [super tearDown];
}

- (void)testInitOperations {
    [verifyCount(self.p.mockViewTransform, times(1)) addTranformDoneObserver:anything() andSelector:@selector(transformDone:)];

    [verifyCount(self.p.mockViewTransform, times(1)) begin: nil];
    
    [verifyCount(self.mockAdapter, times(1)) addYouboraAdapterDelegate:anything()];
}

- (void)testSetOptions {
    self.options.accountCode = @"a";
    
    YBPlugin * p = [[YBPlugin alloc] initWithOptions:self.options];
    
    XCTAssertEqualObjects(@"a", p.options.accountCode);
    
    p = [[YBPlugin alloc] initWithOptions:nil];
    
    XCTAssertNotNil(p.options);
    XCTAssertEqualObjects(@"nicetest", p.options.accountCode);
}

- (void)testAddAndRemoveAdapters {
    
    YBPlugin * plugin = [[YBPlugin alloc] initWithOptions:self.options];
    
    YBPlayerAdapter * adapter = mock([YBPlayerAdapter class]);
    YBPlayerAdapter * adapter2 = mock([YBPlayerAdapter class]);

    plugin.adapter = adapter;
    
    XCTAssertEqualObjects(adapter, plugin.adapter);
    [verifyCount(adapter, times(1)) addYouboraAdapterDelegate:anything()];
    
    plugin.adapter = adapter2;
    XCTAssertEqualObjects(adapter2, plugin.adapter);
    
    [verifyCount(adapter, times(1)) dispose];
    [verifyCount(adapter, times(1)) removeYouboraAdapterDelegate:anything()];
    
    [verifyCount(adapter2, times(1)) addYouboraAdapterDelegate:anything()];
    
    [plugin removeAdapter];
    [verifyCount(adapter2, times(1)) dispose];
    [verifyCount(adapter2, times(1)) removeYouboraAdapterDelegate:anything()];
}

- (void)testAddAndRemoveAdsAdapters {
    YBPlugin * plugin = [[YBPlugin alloc] initWithOptions:self.options];
    
    YBPlayerAdapter * adapter = mock([YBPlayerAdapter class]);
    YBPlayerAdapter * adapter2 = mock([YBPlayerAdapter class]);
    
    plugin.adsAdapter = adapter;
    
    XCTAssertEqualObjects(adapter, plugin.adsAdapter);
    [verifyCount(adapter, times(1)) addYouboraAdapterDelegate:anything()];
    
    plugin.adsAdapter = adapter2;
    XCTAssertEqualObjects(adapter2, plugin.adsAdapter);
    
    [verifyCount(adapter, times(1)) dispose];
    [verifyCount(adapter, times(1)) removeYouboraAdapterDelegate:anything()];
    
    [verifyCount(adapter2, times(1)) addYouboraAdapterDelegate:anything()];
    
    [plugin removeAdsAdapter];
    [verifyCount(adapter2, times(1)) dispose];
    [verifyCount(adapter2, times(1)) removeYouboraAdapterDelegate:anything()];
}

- (void)testAddInvalidAdAdapters {
    YBPlugin * plugin = [[YBPlugin alloc] initWithOptions:self.options];
    YBPlugin * plugin2 = [[YBPlugin alloc] initWithOptions:self.options];
    
    YBPlayerAdapter * adapter = [YBPlayerAdapter new];
    YBPlayerAdapter * adapter2 = [YBPlayerAdapter new];
    
    plugin.adsAdapter = nil;
    XCTAssertNil(plugin.adsAdapter);
    
    plugin.adsAdapter = adapter;
    plugin2.adsAdapter = adapter2;
    
    plugin.adsAdapter = adapter2;
    
    XCTAssertEqualObjects(plugin.adsAdapter, adapter);
}

- (void)testEnableDisable {
    [self.p enable];
    XCTAssertTrue(self.options.enabled);
    
    [self.p disable];
    XCTAssertFalse(self.options.enabled);
}

- (void)testPreloads {
    [self.p firePreloadBegin];
    [self.p firePreloadBegin];
    [(YBChrono *) verifyCount(self.p.mockChrono, times(1)) start];
    
    [self.p firePreloadEnd];
    [self.p firePreloadEnd];
    [(YBChrono *) verifyCount(self.p.mockChrono, times(1)) stop];
}

// Test get info
- (void)testGetHost {
    self.options.host = @"http://host.com";
    self.options.httpSecure = true;
    
    XCTAssertEqualObjects(@"https://host.com", [self.p getHost]);
}

- (void)testParseHls {
    self.options.parseCdnNode = true;
    XCTAssertTrue([self.p isParseCdnNode]);
    
    self.options.parseCdnNode = false;
    XCTAssertFalse([self.p isParseCdnNode]);
}

- (void)testCdnNode {
    self.options.parseHls = true;
    XCTAssertTrue([self.p isParseHls]);
    
    self.options.parseResource = false;
    XCTAssertFalse([self.p isParseHls]);
}

- (void)testParseCdnNodeList {
    NSArray *list = @[@"item1", @"item2", @"item3"];
    
    XCTAssertNotNil(self.p.getParseCdnNodeList);
    
    self.options.parseCdnNodeList = list;
    XCTAssertEqualObjects(list, self.p.getParseCdnNodeList);
}

- (void)testParseCdnNodeHeader {
    self.options.parseCdnNameHeader = @"x-header";
    XCTAssertEqualObjects(@"x-header", [self.p getParseCdnNameHeader]);
}

- (void)testPlayhead {
    [given([self.mockAdapter getPlayhead]) willReturn:@(-10.0)];
    XCTAssertEqualObjects(@(-10.0), [self.p getPlayhead]);
    
    [given([self.mockAdapter getPlayhead]) willReturn:@(10.0)];
    XCTAssertEqualObjects(@(10.0), [self.p getPlayhead]);
    
    [given([self.mockAdapter getPlayhead]) willReturn:@(INFINITY)];
    XCTAssertEqualObjects(@0, [self.p getPlayhead]);
}

- (void)testPlayrate {
    [given([self.mockAdapter getPlayrate]) willReturn:@(-10.0)];
    XCTAssertEqualObjects(@(-10.0), [self.p getPlayrate]);
    
    [given([self.mockAdapter getPlayrate]) willReturn:@(10.0)];
    XCTAssertEqualObjects(@(10.0), [self.p getPlayrate]);
    
    [given([self.mockAdapter getPlayrate]) willReturn:@(INFINITY)];
    XCTAssertEqualObjects(@1, [self.p getPlayrate]);
}

- (void)testFps {
    self.options.contentFps = @25;
    [given([self.mockAdapter getFramesPerSecond]) willReturn:@15];
    XCTAssertEqualObjects(@25, [self.p getFramesPerSecond]);
    
    self.options.contentFps = nil;
    [given([self.mockAdapter getFramesPerSecond]) willReturn:@15.5];
    XCTAssertEqualObjects(@15.5, [self.p getFramesPerSecond]);
    
    self.options.contentFps = nil;
    [given([self.mockAdapter getFramesPerSecond]) willReturn:nil];
    XCTAssertEqualObjects(nil, [self.p getFramesPerSecond]);
}

- (void)testDroppedFrames {
    [given([self.mockAdapter getDroppedFrames]) willReturn:@10];
    XCTAssertEqualObjects(@10, [self.p getDroppedFrames]);
    
    [given([self.mockAdapter getDroppedFrames]) willReturn:@(NAN)];
    XCTAssertEqualObjects(@0, [self.p getDroppedFrames]);
}

- (void)testDuration {
    [given([self.mockAdapter getDuration]) willReturn:@10];
    XCTAssertEqualObjects(@10, [self.p getDuration]);
    
    [given([self.mockAdapter getDuration]) willReturn:@0.5];
    XCTAssertEqualObjects(@0.5, [self.p getDuration]);
    
    [given([self.mockAdapter getDuration]) willReturn:@(INFINITY)];
    XCTAssertEqualObjects(@0, [self.p getDuration]);
    
    // Test options prevalence over adapter
    self.options.contentDuration = @3;
    [given([self.mockAdapter getDuration]) willReturn:@2];
    XCTAssertEqualObjects(@3, [self.p getDuration]);
}

- (void)testBitrate {
    [given([self.mockAdapter getBitrate]) willReturn:@1000000];
    XCTAssertEqualObjects(@1000000, [self.p getBitrate]);
    
    [given([self.mockAdapter getBitrate]) willReturn:nil];
    XCTAssertEqualObjects(@(-1), [self.p getBitrate]);
    
    [given([self.mockAdapter getBitrate]) willReturn:@(INFINITY)];
    XCTAssertEqualObjects(@(-1), [self.p getBitrate]);
    
    // Test options prevalence over adapter
    self.options.contentBitrate = @1000000;
    [given([self.mockAdapter getBitrate]) willReturn:@2000000];
    XCTAssertEqualObjects(@1000000, [self.p getBitrate]);
}

- (void)testTotalBytes {
    NSNumber *totalBytes = [NSNumber numberWithInt:1000];
    XCTAssertNil([self.p getTotalBytes]);
    
    [given([self.mockAdapter getTotalBytes]) willReturn:totalBytes];
    XCTAssertNil([self.p getTotalBytes]);
    
    self.options.sendTotalBytes = @(true);
    XCTAssertEqualObjects(totalBytes, [self.p getTotalBytes]);
    
    self.options.sendTotalBytes = @(false);
    XCTAssertNil([self.p getTotalBytes]);
}

- (void)testThroughput {
    [given([self.mockAdapter getThroughput]) willReturn:@1000000];
    XCTAssertEqualObjects(@1000000, [self.p getThroughput]);
    
    [given([self.mockAdapter getThroughput]) willReturn:@(INFINITY)];
    XCTAssertEqualObjects(@(-1), [self.p getThroughput]);
    
    // Options > adapter
    self.options.contentThroughput = @2000000;
    
    [given([self.mockAdapter getThroughput]) willReturn:@1000000];
    XCTAssertEqualObjects(@2000000, [self.p getThroughput]);
}

- (void)testRendition {
    [given([self.mockAdapter getRendition]) willReturn:@"1Mbps"];
    XCTAssertEqualObjects(@"1Mbps", [self.p getRendition]);
    
    [given([self.mockAdapter getRendition]) willReturn:@""];
    XCTAssertEqualObjects(@"", [self.p getRendition]);
    
    [given([self.mockAdapter getRendition]) willReturn:nil];
    XCTAssertEqualObjects(nil, [self.p getRendition]);
    
    // Options > adapter
    self.options.contentRendition = @"2Mbps";
    [given([self.mockAdapter getRendition]) willReturn:@"1Mbps"];
    XCTAssertEqualObjects(@"2Mbps", [self.p getRendition]);
    
    // unless its empty
    self.options.contentRendition = @"";
    XCTAssertEqualObjects(@"1Mbps", [self.p getRendition]);
}

- (void)testTitle {
    [given([self.mockAdapter getTitle]) willReturn:@"batman"];
    XCTAssertEqualObjects(@"batman", [self.p getTitle]);
    
    [given([self.mockAdapter getTitle]) willReturn:@""];
    XCTAssertEqualObjects(@"", [self.p getTitle]);
    
    [given([self.mockAdapter getTitle]) willReturn:nil];
    XCTAssertEqualObjects(nil, [self.p getTitle]);
    
    // Options > adapter
    self.options.contentTitle = @"iron man";
    [given([self.mockAdapter getTitle]) willReturn:@"batman"];
    XCTAssertEqualObjects(@"iron man", [self.p getTitle]);
    
    // unless empty
    self.options.contentTitle = @"";
    XCTAssertEqualObjects(@"batman", [self.p getTitle]);
}

- (void)testProgram {
    [given([self.mockAdapter getProgram]) willReturn:@"episode 1"];
    XCTAssertEqualObjects(@"episode 1", [self.p getProgram]);
    
    [given([self.mockAdapter getProgram]) willReturn:@""];
    XCTAssertEqualObjects(@"", [self.p getProgram]);
    
    [given([self.mockAdapter getProgram]) willReturn:nil];
    XCTAssertEqualObjects(nil, [self.p getProgram]);
    
    // Options > adapter
    self.options.program = @"episode 2";
    [given([self.mockAdapter getProgram]) willReturn:@"episode 1"];
    XCTAssertEqualObjects(@"episode 2", [self.p getProgram]);
    
    // unless empty
    self.options.program = @"";
    XCTAssertEqualObjects(@"episode 1", [self.p getProgram]);
}

- (void)testLive {
    self.options.contentIsLive = nil;
    
    [given([self.mockAdapter getIsLive]) willReturn:nil];
    XCTAssertNil([self.p getIsLive]);
    
    [given([self.mockAdapter getIsLive]) willReturn:@NO];
    XCTAssertEqualObjects(@NO, [self.p getIsLive]);
    
    [given([self.mockAdapter getIsLive]) willReturn:@YES];
    XCTAssertEqualObjects(@YES, [self.p getIsLive]);
    
    // Options > adapter
    self.options.contentIsLive = @NO;
    XCTAssertEqualObjects(@NO, [self.p getIsLive]);
    
    self.options.contentIsLive = @YES;
    [given([self.mockAdapter getIsLive]) willReturn:@NO];
    XCTAssertEqualObjects(@YES, [self.p getIsLive]);
}

- (void)testGetResource {
    [given([self.p.mockResourceTransform isBlocking:anything()]) willReturn:@YES];
    self.options.contentResource = @"ResourceFromOptions";
    [given([self.p.mockResourceTransform getResource]) willReturn:@"ResourceFromTransform"];
    [given([self.mockAdapter getResource]) willReturn:@"ResourceFromAdapter"];
    
    XCTAssertEqualObjects(@"ResourceFromOptions", [self.p getOriginalResource]);
    
    [given([self.p.mockResourceTransform isBlocking:anything()]) willReturn:@NO];
    XCTAssertEqualObjects(@"ResourceFromTransform", [self.p getParsedResource]);
    
    self.options.contentResource = nil;
    [given([self.p.mockResourceTransform getResource]) willReturn:nil];

    XCTAssertEqualObjects(@"ResourceFromAdapter", [self.p getOriginalResource]);

    [given([self.mockAdapter getResource]) willReturn:nil];
    
    XCTAssertNil([self.p getOriginalResource]);
}

- (void)testTransactionCode {
    self.options.contentTransactionCode = YBConstantsRequest.transactionCode;
    
    XCTAssertEqualObjects(YBConstantsRequest.transactionCode, [self.p getTransactionCode]);
    
    self.options.contentTransactionCode = nil;
    
    XCTAssertNil([self.p getTransactionCode]);
}

- (void)testPlayerVersion {
    [given([self.mockAdapter getPlayerVersion]) willReturn:nil];
    
    XCTAssertEqualObjects(@"", [self.p getPlayerVersion]);
    
    [given([self.mockAdapter getPlayerVersion]) willReturn:@"1.2.3"];
    
    XCTAssertEqualObjects(@"1.2.3", [self.p getPlayerVersion]);
}

- (void)testPlayerName {
    [given([self.mockAdapter getPlayerName]) willReturn:nil];
    
    XCTAssertEqualObjects(@"", [self.p getPlayerName]);
    
    [given([self.mockAdapter getPlayerName]) willReturn:@"player-name"];
    
    XCTAssertEqualObjects(@"player-name", [self.p getPlayerName]);
}

- (void)testCdn {
    [given([self.p.mockResourceTransform isBlocking:anything()]) willReturn:@YES];
    self.options.contentCdn = @"CdnFromOptions";
    [given([self.p.mockResourceTransform getCdnName]) willReturn:@"CdnFromTransform"];

    XCTAssertEqualObjects(@"CdnFromOptions", [self.p getCdn]);
    
    [given([self.p.mockResourceTransform isBlocking:anything()]) willReturn:@NO];
    XCTAssertEqualObjects(@"CdnFromTransform", [self.p getCdn]);
    
    [given([self.p.mockResourceTransform getCdnName]) willReturn:nil];
    XCTAssertEqualObjects(@"CdnFromOptions", [self.p getCdn]);
    
    self.options.contentCdn = nil;
    XCTAssertNil([self.p getCdn]);
}

- (void)testPluginVersion {
    [given([self.mockAdapter getVersion]) willReturn:nil];
    
    XCTAssertEqualObjects([YBConstants.youboraLibVersion stringByAppendingString:@"-adapterless-ios"], [self.p getPluginVersion]);
    
    [given([self.mockAdapter getVersion]) willReturn:[YBConstants.youboraLibVersion stringByAppendingString:@"-CustomPlugin"]];
    
    XCTAssertEqualObjects([YBConstants.youboraLibVersion stringByAppendingString:@"-CustomPlugin"], [self.p getPluginVersion]);
    
    [self.p removeAdapter];
    
    XCTAssertEqualObjects([YBConstants.youboraLibVersion stringByAppendingString:@"-adapterless-ios"], [self.p getPluginVersion]);
}

- (void)testCustomDimensions {
    self.options.contentCustomDimension1 = @"value-custom-dimension1";
    self.options.contentCustomDimension2 = @"value-custom-dimension2";
    self.options.contentCustomDimension3 = @"value-custom-dimension3";
    self.options.contentCustomDimension4 = @"value-custom-dimension4";
    self.options.contentCustomDimension5 = @"value-custom-dimension5";
    self.options.contentCustomDimension6 = @"value-custom-dimension6";
    self.options.contentCustomDimension7 = @"value-custom-dimension7";
    self.options.contentCustomDimension8 = @"value-custom-dimension8";
    self.options.contentCustomDimension9 = @"value-custom-dimension9";
    self.options.contentCustomDimension10 = @"value-custom-dimension10";
    self.options.contentCustomDimension11 = @"value-custom-dimension11";
    self.options.contentCustomDimension12 = @"value-custom-dimension12";
    self.options.contentCustomDimension13 = @"value-custom-dimension13";
    self.options.contentCustomDimension14 = @"value-custom-dimension14";
    self.options.contentCustomDimension15 = @"value-custom-dimension15";
    self.options.contentCustomDimension16 = @"value-custom-dimension16";
    self.options.contentCustomDimension17 = @"value-custom-dimension17";
    self.options.contentCustomDimension18 = @"value-custom-dimension18";
    self.options.contentCustomDimension19 = @"value-custom-dimension19";
    self.options.contentCustomDimension20 = @"value-custom-dimension20";
    
    XCTAssertEqualObjects(@"value-custom-dimension1", [self.p getContentCustomDimension1]);
    XCTAssertEqualObjects(@"value-custom-dimension2", [self.p getContentCustomDimension2]);
    XCTAssertEqualObjects(@"value-custom-dimension3", [self.p getContentCustomDimension3]);
    XCTAssertEqualObjects(@"value-custom-dimension4", [self.p getContentCustomDimension4]);
    XCTAssertEqualObjects(@"value-custom-dimension5", [self.p getContentCustomDimension5]);
    XCTAssertEqualObjects(@"value-custom-dimension6", [self.p getContentCustomDimension6]);
    XCTAssertEqualObjects(@"value-custom-dimension7", [self.p getContentCustomDimension7]);
    XCTAssertEqualObjects(@"value-custom-dimension8", [self.p getContentCustomDimension8]);
    XCTAssertEqualObjects(@"value-custom-dimension9", [self.p getContentCustomDimension9]);
    XCTAssertEqualObjects(@"value-custom-dimension10", [self.p getContentCustomDimension10]);
    
    XCTAssertEqualObjects(@"value-custom-dimension11", [self.p getContentCustomDimension11]);
    XCTAssertEqualObjects(@"value-custom-dimension12", [self.p getContentCustomDimension12]);
    XCTAssertEqualObjects(@"value-custom-dimension13", [self.p getContentCustomDimension13]);
    XCTAssertEqualObjects(@"value-custom-dimension14", [self.p getContentCustomDimension14]);
    XCTAssertEqualObjects(@"value-custom-dimension15", [self.p getContentCustomDimension15]);
    XCTAssertEqualObjects(@"value-custom-dimension16", [self.p getContentCustomDimension16]);
    XCTAssertEqualObjects(@"value-custom-dimension17", [self.p getContentCustomDimension17]);
    XCTAssertEqualObjects(@"value-custom-dimension18", [self.p getContentCustomDimension18]);
    XCTAssertEqualObjects(@"value-custom-dimension19", [self.p getContentCustomDimension19]);
    XCTAssertEqualObjects(@"value-custom-dimension20", [self.p getContentCustomDimension20]);
    
    self.options.contentCustomDimension1 = nil;
    self.options.contentCustomDimension2 = nil;
    self.options.contentCustomDimension3 = nil;
    self.options.contentCustomDimension4 = nil;
    self.options.contentCustomDimension5 = nil;
    self.options.contentCustomDimension6 = nil;
    self.options.contentCustomDimension7 = nil;
    self.options.contentCustomDimension8 = nil;
    self.options.contentCustomDimension9 = nil;
    self.options.contentCustomDimension10 = nil;
    self.options.contentCustomDimension11 = nil;
    self.options.contentCustomDimension12 = nil;
    self.options.contentCustomDimension13 = nil;
    self.options.contentCustomDimension14 = nil;
    self.options.contentCustomDimension15 = nil;
    self.options.contentCustomDimension16 = nil;
    self.options.contentCustomDimension17 = nil;
    self.options.contentCustomDimension18 = nil;
    self.options.contentCustomDimension19 = nil;
    self.options.contentCustomDimension20 = nil;
    
    XCTAssertNil([self.p getContentCustomDimension1]);
    XCTAssertNil([self.p getContentCustomDimension2]);
    XCTAssertNil([self.p getContentCustomDimension3]);
    XCTAssertNil([self.p getContentCustomDimension4]);
    XCTAssertNil([self.p getContentCustomDimension5]);
    XCTAssertNil([self.p getContentCustomDimension6]);
    XCTAssertNil([self.p getContentCustomDimension7]);
    XCTAssertNil([self.p getContentCustomDimension8]);
    XCTAssertNil([self.p getContentCustomDimension9]);
    XCTAssertNil([self.p getContentCustomDimension10]);
    XCTAssertNil([self.p getContentCustomDimension11]);
    XCTAssertNil([self.p getContentCustomDimension12]);
    XCTAssertNil([self.p getContentCustomDimension13]);
    XCTAssertNil([self.p getContentCustomDimension14]);
    XCTAssertNil([self.p getContentCustomDimension15]);
    XCTAssertNil([self.p getContentCustomDimension16]);
    XCTAssertNil([self.p getContentCustomDimension17]);
    XCTAssertNil([self.p getContentCustomDimension18]);
    XCTAssertNil([self.p getContentCustomDimension19]);
    XCTAssertNil([self.p getContentCustomDimension20]);
}

- (void)testParseLocationHeader {
    
    XCTAssertFalse([self.p isParseLocationHeader]);
    
    self.options.parseLocationHeader = true;
    
    XCTAssertTrue([self.p isParseLocationHeader]);
}

- (void)testGetExperiments {
    
    XCTAssertTrue([self.p getExperimentIds].count == 0);
    NSArray *experiments = @[@"some-value", @"some-other-value"];
    
    self.options.experimentIds = experiments;
    XCTAssertTrue([[self.p getExperimentIds] count] == 2);
}

- (void) getTitle2 {
    XCTAssertNil([self.p getTitle2]);
    
    [given([self.mockAdapter getTitle2]) willReturn:@"something"];
    
    XCTAssertEqualObjects(@"something", [self.p getTitle2]);
    
    [given([self.mockAdapter getTitle2]) willReturn:nil];
    self.options.contentTitle2 = @"anything";
    
    XCTAssertEqualObjects(@"anything", [self.p getTitle2]);
}

- (void) testGetLatency {
    
    XCTAssertEqualObjects(@(0), [self.p getLatency]);
    
    [given([self.mockAdapter getLatency]) willReturn:@(1)];
    self.options.contentIsLive = @(true);
    
    XCTAssertEqualObjects(@(1), [self.p getLatency]);
    
    self.options.contentIsLive = @(NO);
    XCTAssertEqualObjects(@(0), [self.p getLatency]);
    
    self.options.contentIsLive = @(YES);
    XCTAssertEqualObjects(@(1), [self.p getLatency]);
}

- (void) testGetPacketLost {
    
    XCTAssertEqualObjects(@(0), [self.p getPacketLost]);
    
    [given([self.mockAdapter getPacketLost]) willReturn:@(2)];
    
    XCTAssertEqualObjects(@(2), [self.p getPacketLost]);
}

- (void) testGetPacketSent {
    
    XCTAssertEqualObjects(@(0), [self.p getPacketSent]);
    
    [given([self.mockAdapter getPacketSent]) willReturn:@(3)];
    
    XCTAssertEqualObjects(@(3), [self.p getPacketSent]);
}

- (void) testGetStreamingProtocol {
    XCTAssertNil([self.p getStreamingProtocol]);
    
    self.options.contentStreamingProtocol = YBConstantsStreamProtocol.hls;
    
    XCTAssertEqualObjects(YBConstantsStreamProtocol.hls, [self.p getStreamingProtocol]);
}

- (void) testGetTransportFormat {
    XCTAssertNil([self.p getTransportFormat]);
    
    self.options.contentTransportFormat = YBConstantsTransportFormat.hlsFmp4;
    
    XCTAssertEqualObjects(YBConstantsTransportFormat.hlsFmp4, [self.p getTransportFormat]);
}

- (void) testDeprecatedAdExtraParams {
    self.options.adExtraparam1 = @"1";
    self.options.adExtraparam2 = @"2";
    self.options.adExtraparam3 = @"3";
    self.options.adExtraparam4 = @"4";
    self.options.adExtraparam5 = @"5";
    self.options.adExtraparam6 = @"6";
    self.options.adExtraparam7 = @"7";
    self.options.adExtraparam8 = @"8";
    self.options.adExtraparam9 = @"9";
    self.options.adExtraparam10 = @"10";
    
    XCTAssertEqual(@"1", [self.p getAdExtraparam1]);
    XCTAssertEqual(@"2", [self.p getAdExtraparam2]);
    XCTAssertEqual(@"3", [self.p getAdExtraparam3]);
    XCTAssertEqual(@"4", [self.p getAdExtraparam4]);
    XCTAssertEqual(@"5", [self.p getAdExtraparam5]);
    XCTAssertEqual(@"6", [self.p getAdExtraparam6]);
    XCTAssertEqual(@"7", [self.p getAdExtraparam7]);
    XCTAssertEqual(@"8", [self.p getAdExtraparam8]);
    XCTAssertEqual(@"9", [self.p getAdExtraparam9]);
    XCTAssertEqual(@"10", [self.p getAdExtraparam10]);
}

- (void) testDeprecatedContentDimensions {
    self.options.customDimension1 = @"1";
    self.options.customDimension2 = @"2";
    self.options.customDimension3 = @"3";
    self.options.customDimension4 = @"4";
    self.options.customDimension5 = @"5";
    self.options.customDimension6 = @"6";
    self.options.customDimension7 = @"7";
    self.options.customDimension8 = @"8";
    self.options.customDimension9 = @"9";
    self.options.customDimension10 = @"10";
    self.options.customDimension11 = @"11";
    self.options.customDimension12 = @"12";
    self.options.customDimension13 = @"13";
    self.options.customDimension14 = @"14";
    self.options.customDimension15 = @"15";
    self.options.customDimension16 = @"16";
    self.options.customDimension17 = @"17";
    self.options.customDimension18 = @"18";
    self.options.customDimension19 = @"19";
    self.options.customDimension20 = @"20";
    
    XCTAssertNil([self.p getCustomDimension1]);
    XCTAssertNil([self.p getCustomDimension2]);
    XCTAssertNil([self.p getCustomDimension3]);
    XCTAssertNil([self.p getCustomDimension4]);
    XCTAssertNil([self.p getCustomDimension5]);
    XCTAssertNil([self.p getCustomDimension6]);
    XCTAssertNil([self.p getCustomDimension7]);
    XCTAssertNil([self.p getCustomDimension8]);
    XCTAssertNil([self.p getCustomDimension9]);
    XCTAssertNil([self.p getCustomDimension10]);
    XCTAssertNil([self.p getCustomDimension11]);
    XCTAssertNil([self.p getCustomDimension12]);
    XCTAssertNil([self.p getCustomDimension13]);
    XCTAssertNil([self.p getCustomDimension14]);
    XCTAssertNil([self.p getCustomDimension15]);
    XCTAssertNil([self.p getCustomDimension16]);
    XCTAssertNil([self.p getCustomDimension17]);
    XCTAssertNil([self.p getCustomDimension18]);
    XCTAssertNil([self.p getCustomDimension19]);
    XCTAssertNil([self.p getCustomDimension20]);
}

- (void)testAdPlayerVersion {
    self.p.adsAdapter = self.mockAdAdapter;
    
    [given([self.mockAdAdapter getPlayerVersion]) willReturn:nil];
    XCTAssertEqualObjects(@"", [self.p getAdPlayerVersion]);
    
    [given([self.mockAdAdapter getPlayerVersion]) willReturn:@"player-version"];
    XCTAssertEqualObjects(@"player-version", [self.p getAdPlayerVersion]);
    
    [self.p removeAdsAdapter];
    XCTAssertEqualObjects(@"", [self.p getAdPlayerVersion]);
}

- (void)testAdPosition {
    
    self.p.adsAdapter = self.mockAdAdapter;
    [given([self.mockAdAdapter getPosition]) willReturnUnsignedLong:YBAdPositionPre];
    XCTAssertEqualObjects(@"pre", [self.p getAdPosition]);
    
    [given([self.mockAdAdapter getPosition]) willReturnUnsignedLong:YBAdPositionMid];
    XCTAssertEqualObjects(@"mid", [self.p getAdPosition]);
    
    [given([self.mockAdAdapter getPosition]) willReturnUnsignedLong:YBAdPositionPost];
    XCTAssertEqualObjects(@"post", [self.p getAdPosition]);
    
    // If ad position is unknown, the plugin will try to infer the position depending on
    // the Buffered status of the adapter. This is a workaround and postrolls will be detected
    // as midrolls
    [given([self.mockAdAdapter getPosition]) willReturnUnsignedLong:YBAdPositionUnknown];

    YBPlaybackFlags * flags = [YBPlaybackFlags new];
    flags.joined = false;
    stubProperty(self.mockAdapter, flags, flags);
    
    XCTAssertEqualObjects(@"pre", [self.p getAdPosition]);

    flags.joined = true;
    
    XCTAssertEqualObjects(@"mid", [self.p getAdPosition]);

    // No ads adapter, this should be the sasme as it returning unknown, so "mid" expected again
    [self.p removeAdsAdapter];
    XCTAssertEqualObjects(@"mid", [self.p getAdPosition]);

    // No adapter
    [self.p removeAdapter];
    XCTAssertEqualObjects(@"unknown", [self.p getAdPosition]);
    
}

-(void)testGetExpectedAds {
    self.options.adExpectedPattern = @{
        YBConstants.adPositionPre : @[@1],
        YBConstants.adPositionMid : @[@3,@5],
        YBConstants.adPositionPost : @[@2]
    };
    
    self.p.adsAdapter = self.mockAdAdapter;
    [given([self.mockAdAdapter getAdBreakNumber]) willReturnUnsignedLong:1];
    
    XCTAssertEqualObjects(@"1", [self.p getExpectedAds]);
    
    [given([self.mockAdAdapter getAdBreakNumber]) willReturnUnsignedLong:3];
    
    XCTAssertEqualObjects(@"5", [self.p getExpectedAds]);
    
    [given([self.mockAdAdapter getAdBreakNumber]) willReturnUnsignedLong:4];
    
    XCTAssertEqualObjects(@"2", [self.p getExpectedAds]);
    
    [given([self.mockAdAdapter getAdBreakNumber]) willReturnUnsignedLong:9];
    XCTAssertEqualObjects(@"2", [self.p getExpectedAds]);
}

-(void)testInvalidGetExpectedAds {
    self.p.adsAdapter = self.mockAdAdapter;
    
    self.options.adExpectedPattern = @{ @"INVALID" : @[@1]};
    
    self.p.adsAdapter = self.mockAdAdapter;
    [given([self.mockAdAdapter getAdBreakNumber]) willReturnUnsignedLong:1];
    
    XCTAssertNil([self.p getExpectedAds]);
    self.options.adExpectedPattern = nil;
    
    XCTAssertNil([self.p getExpectedAds]);
}

- (void)testAdPlayhead {
    self.p.adsAdapter = self.mockAdAdapter;
    [given([self.mockAdAdapter getPlayhead]) willReturn:@(-10.0)];
    XCTAssertEqualObjects(@(-10.0), [self.p getAdPlayhead]);
    
    [given([self.mockAdAdapter getPlayhead]) willReturn:@(10.0)];
    XCTAssertEqualObjects(@(10.0), [self.p getAdPlayhead]);
    
    [given([self.mockAdAdapter getPlayhead]) willReturn:@(INFINITY)];
    XCTAssertEqualObjects(@0, [self.p getAdPlayhead]);
}

- (void)testAdDuration {
    self.p.adsAdapter = self.mockAdAdapter;
    [given([self.mockAdAdapter getDuration]) willReturn:@10];
    XCTAssertEqualObjects(@10, [self.p getAdDuration]);
    
    [given([self.mockAdAdapter getDuration]) willReturn:@0.5];
    XCTAssertEqualObjects(@0.5, [self.p getAdDuration]);
    
    [given([self.mockAdAdapter getDuration]) willReturn:@(INFINITY)];
    XCTAssertEqualObjects(@0, [self.p getAdDuration]);
}

- (void)testAdBitrate {
    self.p.adsAdapter = self.mockAdAdapter;
    [given([self.mockAdAdapter getBitrate]) willReturn:@1000000];
    XCTAssertEqualObjects(@1000000, [self.p getAdBitrate]);
    
    [given([self.mockAdAdapter getBitrate]) willReturn:nil];
    XCTAssertEqualObjects(@(-1), [self.p getAdBitrate]);
    
    [given([self.mockAdAdapter getBitrate]) willReturn:@(INFINITY)];
    XCTAssertEqualObjects(@(-1), [self.p getAdBitrate]);
}

- (void)testAdTitle {
    self.p.adsAdapter = self.mockAdAdapter;
    [given([self.mockAdAdapter getTitle]) willReturn:@"batman"];
    XCTAssertEqualObjects(@"batman", [self.p getAdTitle]);
    
    [given([self.mockAdAdapter getTitle]) willReturn:@""];
    XCTAssertEqualObjects(@"", [self.p getAdTitle]);
    
    [given([self.mockAdAdapter getTitle]) willReturn:nil];
    XCTAssertEqualObjects(nil, [self.p getAdTitle]);
}

- (void)testAdResource {
    self.p.adsAdapter = self.mockAdAdapter;

    [given([self.mockAdAdapter getResource]) willReturn:@"AdResourceFromAdapter"];
    
    XCTAssertEqualObjects(@"AdResourceFromAdapter", [self.p getAdResource]);
    
    [given([self.mockAdAdapter getResource]) willReturn:nil];
    
    XCTAssertNil([self.p getAdResource]);
}

- (void)testAdPluginVersion {
    self.p.adsAdapter = self.mockAdAdapter;

    [given([self.mockAdAdapter getVersion]) willReturn:nil];
    
    XCTAssertNil([self.p getAdAdapterVersion]);
    
    [given([self.mockAdAdapter getVersion]) willReturn:[YBConstants.youboraLibVersion stringByAppendingString:@"-CustomAdapter"]];
    
    XCTAssertEqualObjects([YBConstants.youboraLibVersion stringByAppendingString:@"-CustomAdapter"], [self.p getAdAdapterVersion]);
    
    [self.p removeAdsAdapter];
    
    XCTAssertNil([self.p getAdAdapterVersion]);
}

- (void) testAdCampaign {
    XCTAssertNil([self.p getAdCampaign]);
    
    self.options.adCampaign = @"campaign";
    
    XCTAssertEqualObjects(@"campaign", [self.p getAdCampaign]);
}

- (void) testAdMetadata {
    NSString *defaultString = [YBYouboraUtils stringifyDictionary:self.defaultOptions.adMetadata];
    XCTAssertTrue([[self.p getAdMetadata] isEqualToString: defaultString]);
    
    NSDictionary *adMetadataDict = @{
                                 @"key" : @"value"
                                 };
    
    self.options.adMetadata = adMetadataDict;
    
    XCTAssertEqualObjects([YBYouboraUtils stringifyDictionary:adMetadataDict], [self.p getAdMetadata]);
}

- (void) testNilAdapterVersion {
    [given([self.mockAdapter getVersion]) willReturn:nil];
    [given([self.mockAdAdapter getVersion]) willReturn:nil];
    
    NSString *versionString = [self.p getPluginInfo];
    
    XCTAssertTrue([versionString containsString:@"lib"]);
    XCTAssertFalse([versionString containsString:@"adapter"]);
    XCTAssertFalse([versionString containsString:@"adAdapter"]);
}

- (void) testNotNilAdapterVersion {
    
    [self.p setAdsAdapter:self.mockAdAdapter];
    
    [given([self.mockAdapter getVersion]) willReturn:@"288"];
    [given([self.mockAdAdapter getVersion]) willReturn:@"69"];
    
    NSString *versionString = [self.p getPluginInfo];
    
    XCTAssertTrue([versionString containsString:@"lib"]);
    XCTAssertTrue([versionString containsString:@"adapter"]);
    XCTAssertTrue([versionString containsString:@"adAdapter"]);
}

- (void)testIp {
    XCTAssertNil([self.p getIp]);
    self.options.networkIP = @"1.2.3.4";
    XCTAssertEqualObjects(@"1.2.3.4", [self.p getIp]);
}

- (void)testIsp {
    XCTAssertNil([self.p getIsp]);
    self.options.networkIsp = YBConstantsRequest.isp;
    XCTAssertEqualObjects(YBConstantsRequest.isp, [self.p getIsp]);
}

- (void)testConnectionType {
    XCTAssertNil([self.p getConnectionType]);
    self.options.networkConnectionType = @"DSL";
    XCTAssertEqualObjects(@"DSL", [self.p getConnectionType]);
}

- (void) testObfuscateIp {
    self.options.userObfuscateIp = @YES;
    
    XCTAssertTrue([self.p getNetworkObfuscateIp]);
}

- (void)testDeviceCode {
    XCTAssertNil([self.p getDeviceCode]);
    self.options.deviceCode = @"42";
    XCTAssertEqualObjects(@"42", [self.p getDeviceCode]);
}

- (void)testAccountCode {
    XCTAssertTrue([[self.p getAccountCode] isEqualToString: self.defaultOptions.accountCode]);
    self.options.accountCode = YBConstantsRequest.accountCode;
    XCTAssertEqualObjects(YBConstantsRequest.accountCode, [self.p getAccountCode]);
}

- (void)testUsername {
    XCTAssertNil([self.p getUsername]);
    self.options.username = YBConstantsRequest.username;
    XCTAssertEqualObjects(YBConstantsRequest.username, [self.p getUsername]);
}

- (void)testNodeHost {
    XCTAssertNil([self.p getIp]);
    [given([self.p.mockResourceTransform getNodeHost]) willReturn:YBConstantsRequest.nodeHost];
    XCTAssertEqualObjects(YBConstantsRequest.nodeHost, [self.p getNodeHost]);
}

- (void)testNodeType {
    XCTAssertNil([self.p getNodeType]);
    [given([self.p.mockResourceTransform getNodeType]) willReturn:@"type"];
    XCTAssertEqualObjects(@"type", [self.p getNodeType]);
}

- (void)testNodeTypeString {
    XCTAssertNil([self.p getIp]);
    [given([self.p.mockResourceTransform getNodeTypeString]) willReturn:@"typeString"];
    XCTAssertEqualObjects(@"typeString", [self.p getNodeTypeString]);
}

- (void)testContentMetrics {
    XCTAssertNil([self.p getVideoMetrics]);
    self.options.contentMetrics = @{@"key": @"value"};
    XCTAssertEqualObjects(@"{\"key\":{\"value\":\"value\"}}", [self.p getVideoMetrics]);
    
    self.options.contentMetrics = nil;
    
    [given([self.mockAdapter getMetrics]) willReturn:@{@"key": @"value"}];
    XCTAssertEqualObjects(@"{\"key\":\"value\"}", [self.p getVideoMetrics]);
}

- (void)testSessionMetrics {
    XCTAssertNil([self.p getSessionMetrics]);
    
    self.options.sessionMetrics = @{@"key": @"value"};
    
    XCTAssertEqualObjects(@"{\"key\":\"value\"}", [self.p getSessionMetrics]);
}

- (void) testUserType {
    XCTAssertNil([self.p getUserType]);
    self.options.userType = @"type";
    XCTAssertEqualObjects(@"type", [self.p getUserType]);
}

- (void) testUserEmail {
    XCTAssertNil([self.p getUserEmail]);
    self.options.userEmail = YBConstantsRequest.email;
    XCTAssertEqualObjects(YBConstantsRequest.email, [self.p getUserEmail]);
}

- (void) testAnonymoususer {
    XCTAssertNil([self.p getAnonymousUser]);
    self.options.anonymousUser = @"anon";
    XCTAssertEqualObjects(@"anon", [self.p getAnonymousUser]);
}

- (void) testGetHouseHoldId {
    XCTAssertEqualObjects(@"", [self.p getHouseholdId]);
    [given([self.mockAdapter getHouseholdId]) willReturn:@"household"];
    XCTAssertEqualObjects(@"household", [self.p getHouseholdId]);
}

- (void) testGetCdnTraffic {
    XCTAssertEqualObjects(@0, [self.p getCdnTraffic]);
    [given([self.mockAdapter getCdnTraffic]) willReturn:@1];
    XCTAssertEqualObjects(@1, [self.p getCdnTraffic]);
}

- (void) testP2PTraffic {
    XCTAssertEqualObjects(@0, [self.p getP2PTraffic]);
    [given([self.mockAdapter getP2PTraffic]) willReturn:@1];
    XCTAssertEqualObjects(@1, [self.p getP2PTraffic]);
}

- (void) testP2PEnabled {
    XCTAssertNil([self.p getIsP2PEnabled]);
    [given([self.mockAdapter getIsP2PEnabled]) willReturn:@YES];
    XCTAssertEqualObjects(@YES, [self.p getIsP2PEnabled]);
}

- (void) testGetIsInfinity {
    XCTAssertNil([self.p getIsInfinity]);
    self.options.isInfinity = @YES;
    XCTAssertEqualObjects(@YES, [self.p getIsInfinity]);
}

- (void) testParentId {
    
    YBInfinityFlags *flags = [[YBInfinityFlags alloc] init];
    [self.p getInfinity].flags = flags;
    
    YBInfinity *infinity = [self.p getInfinity];
    
    [given([infinity getSessionRoot]) willReturn:@"testId"];
 
    flags.started = true;
    
    XCTAssertTrue([[infinity getSessionRoot] isEqualToString:[self.p getParentId]]);
    
    flags.started = false;
    
    XCTAssertNil([self.p getParentId]);
}

- (void) testGetSmartSwitchConfigCode {
    XCTAssertNil([self.p getSmartSwitchConfigCode]);
    self.options.smartswitchConfigCode = @"config";
    XCTAssertEqualObjects(@"config", [self.p getSmartSwitchConfigCode]);
}

- (void) testGetSmartSwitchGroupCode {
    XCTAssertNil([self.p getSmartSwitchGroupCode]);
    self.options.smartswitchGroupCode = @"code";
    XCTAssertEqualObjects(@"code", [self.p getSmartSwitchGroupCode]);
}

- (void) testGetSmartSwitchContractCode {
    XCTAssertNil([self.p getSmartSwitchContractCode]);
    self.options.smartswitchContractCode = @"contract";
    XCTAssertEqualObjects(@"contract", [self.p getSmartSwitchContractCode]);
}

- (void) testGetPlaybackType {
    XCTAssertNil([self.p getContentPlaybackType]);
    self.options.contentIsLive = @NO;
    XCTAssertEqualObjects(@"VoD", [self.p getContentPlaybackType]);
    
    self.options.contentIsLive = @YES;
    XCTAssertEqualObjects(YBConstantsRequest.live, [self.p getContentPlaybackType]);
    
    self.options.contentPlaybackType = @"content type";
    XCTAssertEqualObjects(@"content type", [self.p getContentPlaybackType]);
}

- (void)testChronoTimes {
    // Init and preload chronos don't depend on the adapter
    [given([self.p.mockChrono getDeltaTime:false]) willReturn:@100];
    XCTAssertEqual(100, [self.p getInitDuration]);
    
    [given([self.p.mockChrono getDeltaTime:false]) willReturn:@200];
    XCTAssertEqual(200, [self.p getPreloadDuration]);
    
    // Adapter chronos
    YBPlaybackChronos * mockChronos = mock([YBPlaybackChronos class]);
    
    stubProperty(mockChronos, buffer, mock([YBChrono class]));
    stubProperty(mockChronos, join, mock([YBChrono class]));
    stubProperty(mockChronos, seek, mock([YBChrono class]));
    stubProperty(mockChronos, pause, mock([YBChrono class]));
    stubProperty(mockChronos, total, mock([YBChrono class]));
    
    [given([mockChronos.buffer getDeltaTime:false]) willReturn:@100];
    [given([mockChronos.join getDeltaTime:false]) willReturn:@200];
    [given([mockChronos.seek getDeltaTime:false]) willReturn:@300];
    [given([mockChronos.pause getDeltaTime:false]) willReturn:@400];
    [given([mockChronos.total getDeltaTime:false]) willReturn:@500];
    
    stubProperty(self.mockAdapter, chronos, mockChronos);
    
    XCTAssertEqual(100, [self.p getBufferDuration]);
    XCTAssertEqual(200, [self.p getJoinDuration]);
    XCTAssertEqual(300, [self.p getSeekDuration]);
    XCTAssertEqual(400, [self.p getPauseDuration]);
    
    // Change values to test the ads
    [given([mockChronos.buffer getDeltaTime:false]) willReturn:@1000];
    [given([mockChronos.join getDeltaTime:false]) willReturn:@2000];
    [given([mockChronos.seek getDeltaTime:false]) willReturn:@3000];
    [given([mockChronos.pause getDeltaTime:false]) willReturn:@4000];
    [given([mockChronos.total getDeltaTime:false]) willReturn:@5000];
    
    stubProperty(self.mockAdAdapter, chronos, mockChronos);
    
    self.p.adsAdapter = self.mockAdAdapter;
    
    XCTAssertEqual(1000, [self.p getAdBufferDuration]);
    XCTAssertEqual(2000, [self.p getAdJoinDuration]);
    XCTAssertEqual(4000, [self.p getAdPauseDuration]);
    XCTAssertEqual(5000, [self.p getAdTotalDuration]);
    
    // No adapters
    [self.p removeAdsAdapter];
    
    XCTAssertEqual(-1, [self.p getAdBufferDuration]);
    XCTAssertEqual(-1, [self.p getAdJoinDuration]);
    XCTAssertEqual(-1, [self.p getAdPauseDuration]);
    XCTAssertEqual(-1, [self.p getAdTotalDuration]);
    
    [self.p removeAdapter];
    
    XCTAssertEqual(-1, [self.p getBufferDuration]);
    XCTAssertEqual(-1, [self.p getJoinDuration]);
    XCTAssertEqual(-1, [self.p getSeekDuration]);
    XCTAssertEqual(-1, [self.p getPauseDuration]);
}

- (void)testRequestBuilderInstance {
    XCTAssertEqualObjects(self.p.mockRequestBuilder, self.p.requestBuilder);
}

// Will send listeners
- (void) testWillSendInitListener {
    static int callbackTimes;
    
    // Make build params return the first argument
    [given([self.p.mockRequestBuilder buildParams:anything() forService:anything()]) willDo:^id _Nonnull(NSInvocation * _Nonnull invocation) {
        return [invocation.mkt_arguments[0] mutableCopy];
    }];
    
    YBWillSendRequestBlock listener = ^(NSString * _Nonnull serviceName, YBPlugin * _Nonnull plugin, NSMutableDictionary * _Nonnull params) {
        callbackTimes++;
        XCTAssertEqualObjects(@"value", params[@"key"]);
    };
    
    NSDictionary * params = @{@"key":@"value"};
    
    // Init
    callbackTimes = 0;
    [self.p addWillSendInitListener:listener];
    [self.p fireInitWithParams:params];
    [self.p removeWillSendInitListener:listener];
    [self.p fireInitWithParams:params];
    XCTAssertEqual(1, callbackTimes);
}

- (void) testWillSendStartListener {
    static int callbackTimes;
    
    // Make build params return the first argument
    [given([self.p.mockRequestBuilder buildParams:anything() forService:anything()]) willDo:^id _Nonnull(NSInvocation * _Nonnull invocation) {
        return [invocation.mkt_arguments[0] mutableCopy];
    }];
    
    [given([self.p getTitle]) willReturn:YBConstantsRequest.title];
    [given([self.p getOriginalResource]) willReturn:@"resource"];
    [given([self.p getIsLive]) willReturn:@NO];
    [given([self.p getDuration]) willReturn:@(288)];
    
    YBWillSendRequestBlock listener = ^(NSString * _Nonnull serviceName, YBPlugin * _Nonnull plugin, NSMutableDictionary * _Nonnull params) {
        callbackTimes++;
        XCTAssertEqualObjects(@"value", params[@"key"]);
    };
    
    NSDictionary * params = @{@"key":@"value"};
    
    // Init
    callbackTimes = 0;
    [self.p addWillSendStartListener:listener];
    [self.p youboraAdapterEventStart:params fromAdapter:self.mockAdapter];
    [self.p removeWillSendStartListener:listener];
    [self.p youboraAdapterEventStart:params fromAdapter:self.mockAdapter];
    XCTAssertEqual(1, callbackTimes);
}

- (void)testWillSendInitWhenStarted {
    static int initCallbackTimes;
    static int startCallbackTimes;
    
    // Make build params return the first argument
    [given([self.p.mockRequestBuilder buildParams:anything() forService:anything()]) willDo:^id _Nonnull(NSInvocation * _Nonnull invocation) {
        return [invocation.mkt_arguments[0] mutableCopy];
    }];
    
    YBWillSendRequestBlock listener = ^(NSString * _Nonnull serviceName, YBPlugin * _Nonnull plugin, NSMutableDictionary * _Nonnull params) {
        if ([serviceName isEqualToString: YBConstantsYouboraService.sInit]) {
            initCallbackTimes++;
        }
        if ([serviceName isEqualToString: YBConstantsYouboraService.start]) {
            startCallbackTimes++;
        }
        XCTAssertEqualObjects(@"value", params[@"key"]);
    };
    
    NSDictionary * params = @{@"key":@"value"};
    
    
    // Init
    [self.p addWillSendInitListener:listener];
    [self.p addWillSendStartListener:listener];
    [self.p youboraAdapterEventStart:params fromAdapter:self.p.adapter];
    [self.p removeWillSendInitListener:listener];
    [self.p removeWillSendStartListener:listener];
    
    [self.p youboraAdapterEventStart:params fromAdapter:self.p.adapter];
    XCTAssertEqual(1, initCallbackTimes);
    XCTAssertEqual(0, startCallbackTimes);
}


- (void) testWillSendJoinListener {
    static int callbackTimes;
    
    // Make build params return the first argument
    [given([self.p.mockRequestBuilder buildParams:anything() forService:anything()]) willDo:^id _Nonnull(NSInvocation * _Nonnull invocation) {
        return [invocation.mkt_arguments[0] mutableCopy];
    }];
    
    YBWillSendRequestBlock listener = ^(NSString * _Nonnull serviceName, YBPlugin * _Nonnull plugin, NSMutableDictionary * _Nonnull params) {
        callbackTimes++;
        XCTAssertEqualObjects(@"value", params[@"key"]);
    };
    
    NSDictionary * params = @{@"key":@"value"};
    
    // Join
    callbackTimes = 0;
    [self.p addWillSendJoinListener:listener];
    [self.p youboraAdapterEventJoin:params fromAdapter:self.mockAdapter];
    [self.p removeWillSendJoinListener:listener];
    [self.p youboraAdapterEventJoin:params fromAdapter:self.mockAdapter];
    XCTAssertEqual(1, callbackTimes);
}

- (void) testWillSendPauseListener {
    static int callbackTimes;
    
    // Make build params return the first argument
    [given([self.p.mockRequestBuilder buildParams:anything() forService:anything()]) willDo:^id _Nonnull(NSInvocation * _Nonnull invocation) {
        return [invocation.mkt_arguments[0] mutableCopy];
    }];
    
    YBWillSendRequestBlock listener = ^(NSString * _Nonnull serviceName, YBPlugin * _Nonnull plugin, NSMutableDictionary * _Nonnull params) {
        callbackTimes++;
        XCTAssertEqualObjects(@"value", params[@"key"]);
    };
    
    NSDictionary * params = @{@"key":@"value"};
    
    // Pause
    callbackTimes = 0;
    [self.p addWillSendPauseListener:listener];
    [self.p youboraAdapterEventPause:params fromAdapter:self.mockAdapter];
    [self.p removeWillSendPauseListener:listener];
    [self.p youboraAdapterEventPause:params fromAdapter:self.mockAdapter];
    XCTAssertEqual(1, callbackTimes);
}

- (void) testWillSendResumeListener {
    static int callbackTimes;
    
    // Make build params return the first argument
    [given([self.p.mockRequestBuilder buildParams:anything() forService:anything()]) willDo:^id _Nonnull(NSInvocation * _Nonnull invocation) {
        return [invocation.mkt_arguments[0] mutableCopy];
    }];
    
    YBWillSendRequestBlock listener = ^(NSString * _Nonnull serviceName, YBPlugin * _Nonnull plugin, NSMutableDictionary * _Nonnull params) {
        callbackTimes++;
        XCTAssertEqualObjects(@"value", params[@"key"]);
    };
    
    NSDictionary * params = @{@"key":@"value"};
    
    // Resume
    callbackTimes = 0;
    [self.p addWillSendResumeListener:listener];
    [self.p youboraAdapterEventResume:params fromAdapter:self.mockAdapter];
    [self.p removeWillSendResumeListener:listener];
    [self.p youboraAdapterEventResume:params fromAdapter:self.mockAdapter];
    XCTAssertEqual(1, callbackTimes);
}

- (void) testWillSendBufferEndListener {
    static int callbackTimes;
    
    // Make build params return the first argument
    [given([self.p.mockRequestBuilder buildParams:anything() forService:anything()]) willDo:^id _Nonnull(NSInvocation * _Nonnull invocation) {
        return [invocation.mkt_arguments[0] mutableCopy];
    }];
    
    YBWillSendRequestBlock listener = ^(NSString * _Nonnull serviceName, YBPlugin * _Nonnull plugin, NSMutableDictionary * _Nonnull params) {
        callbackTimes++;
        XCTAssertEqualObjects(@"value", params[@"key"]);
    };
    
    NSDictionary * params = @{@"key":@"value"};
    
    // BufferEnd
    callbackTimes = 0;
    [self.p addWillSendBufferListener:listener];
    [self.p youboraAdapterEventBufferEnd:params fromAdapter:self.mockAdapter];
    [self.p removeWillSendBufferListener:listener];
    [self.p youboraAdapterEventBufferEnd:params fromAdapter:self.mockAdapter];
    XCTAssertEqual(1, callbackTimes);
}

- (void) testWillSendSeekEndListener {
    static int callbackTimes;
    
    // Make build params return the first argument
    [given([self.p.mockRequestBuilder buildParams:anything() forService:anything()]) willDo:^id _Nonnull(NSInvocation * _Nonnull invocation) {
        return [invocation.mkt_arguments[0] mutableCopy];
    }];
    
    YBWillSendRequestBlock listener = ^(NSString * _Nonnull serviceName, YBPlugin * _Nonnull plugin, NSMutableDictionary * _Nonnull params) {
        callbackTimes++;
        XCTAssertEqualObjects(@"value", params[@"key"]);
    };
    
    NSDictionary * params = @{@"key":@"value"};
    
    // SeekEnd
    callbackTimes = 0;
    [self.p addWillSendSeekListener:listener];
    [self.p youboraAdapterEventSeekEnd:params fromAdapter:self.mockAdapter];
    [self.p removeWillSendSeekListener:listener];
    [self.p youboraAdapterEventSeekEnd:params fromAdapter:self.mockAdapter];
    XCTAssertEqual(1, callbackTimes);
}

- (void) testWillSendErrorListener {
    static int callbackTimes;
    
    // Make build params return the first argument
    [given([self.p.mockRequestBuilder buildParams:anything() forService:anything()]) willDo:^id _Nonnull(NSInvocation * _Nonnull invocation) {
        return [invocation.mkt_arguments[0] mutableCopy];
    }];
    
    YBWillSendRequestBlock listener = ^(NSString * _Nonnull serviceName, YBPlugin * _Nonnull plugin, NSMutableDictionary * _Nonnull params) {
        callbackTimes++;
        XCTAssertEqualObjects(@"value", params[@"key"]);
    };
    
    NSDictionary * params = @{@"key":@"value"};
    
    // Error
    callbackTimes = 0;
    [self.p addWillSendErrorListener:listener];
    [self.p youboraAdapterEventError:params fromAdapter:self.mockAdapter];
    [self.p removeWillSendErrorListener:listener];
    [self.p youboraAdapterEventError:params fromAdapter:self.mockAdapter];
    XCTAssertEqual(1, callbackTimes);
}

- (void) testWillSendStopListener {
    static int callbackTimes;
    
    // Make build params return the first argument
    [given([self.p.mockRequestBuilder buildParams:anything() forService:anything()]) willDo:^id _Nonnull(NSInvocation * _Nonnull invocation) {
        return [invocation.mkt_arguments[0] mutableCopy];
    }];
    
    YBWillSendRequestBlock listener = ^(NSString * _Nonnull serviceName, YBPlugin * _Nonnull plugin, NSMutableDictionary * _Nonnull params) {
        callbackTimes++;
        XCTAssertEqualObjects(@"value", params[@"key"]);
    };
    
    NSDictionary * params = @{@"key":@"value"};
    
    // Stop
    callbackTimes = 0;
    [self.p addWillSendStopListener:listener];
    [self.p youboraAdapterEventStop:params fromAdapter:self.mockAdapter];
    [self.p removeWillSendStopListener:listener];
    [self.p youboraAdapterEventStop:params fromAdapter:self.mockAdapter];
    XCTAssertEqual(1, callbackTimes);
}

- (void) testWillSendAdInitListener {
    static int callbackTimes;
    
    // Make build params return the first argument
    [given([self.p.mockRequestBuilder buildParams:anything() forService:anything()]) willDo:^id _Nonnull(NSInvocation * _Nonnull invocation) {
        return [invocation.mkt_arguments[0] mutableCopy];
    }];
    
    YBWillSendRequestBlock listener = ^(NSString * _Nonnull serviceName, YBPlugin * _Nonnull plugin, NSMutableDictionary * _Nonnull params) {
        callbackTimes++;
        XCTAssertEqualObjects(@"value", params[@"key"]);
    };
    
    NSDictionary * params = @{@"key":@"value"};
    
    self.p.adsAdapter = self.mockAdAdapter;
    
    // Stop
    callbackTimes = 0;
    [self.p addWillSendAdInitListener:listener];
    [self.p youboraAdapterEventAdInit:params fromAdapter:self.mockAdAdapter];
    [self.p removeWillSendAdInitListener:listener];
    [self.p youboraAdapterEventAdInit:params fromAdapter:self.mockAdAdapter];
    XCTAssertEqual(1, callbackTimes);
}

- (void) testWillSendAdInitWhenAdStartedListener {
    static int callbackTimes;
    
    [self.p fireInit];
    
    // Make build params return the first argument
    [given([self.p.mockRequestBuilder buildParams:anything() forService:anything()]) willDo:^id _Nonnull(NSInvocation * _Nonnull invocation) {
        return [invocation.mkt_arguments[0] mutableCopy];
    }];
    
    YBWillSendRequestBlock listener = ^(NSString * _Nonnull serviceName, YBPlugin * _Nonnull plugin, NSMutableDictionary * _Nonnull params) {
        callbackTimes++;
        XCTAssertEqualObjects(@"value", params[@"key"]);
    };
    
    NSDictionary * params = @{@"key":@"value"};
    
    self.p.adsAdapter = self.mockAdAdapter;
    
    // Stop
    callbackTimes = 0;
    [self.p addWillSendAdInitListener:listener];
    [self.p youboraAdapterEventStart:params fromAdapter:self.mockAdAdapter];
    [self.p removeWillSendAdInitListener:listener];
    [self.p youboraAdapterEventStart:params fromAdapter:self.mockAdAdapter];
    XCTAssertEqual(1, callbackTimes);
}

- (void) testWillSendAdStartListener {
    static int callbackTimes;
    
    self.p.options = mock([YBOptions class]);
    
    [given([self.p getAdDuration]) willReturn:@10];
    [given([self.p getAdResource]) willReturn:@"a"];
    [given([self.p getAdTitle]) willReturn:@"b"];
    
    [self.p fireInit];
    
    // Make build params return the first argument
    [given([self.p.mockRequestBuilder buildParams:anything() forService:anything()]) willDo:^id _Nonnull(NSInvocation * _Nonnull invocation) {
        return [invocation.mkt_arguments[0] mutableCopy];
    }];
    
    YBWillSendRequestBlock listener = ^(NSString * _Nonnull serviceName, YBPlugin * _Nonnull plugin, NSMutableDictionary * _Nonnull params) {
        callbackTimes++;
        XCTAssertEqualObjects(@"value", params[@"key"]);
    };
    
    NSDictionary * params = @{@"key":@"value"};
    
    self.p.adsAdapter = self.mockAdAdapter;
    
    // Ad Start
    callbackTimes = 0;
    [self.p addWillSendAdStartListener:listener];
    [self.p youboraAdapterEventStart:params fromAdapter:self.mockAdAdapter];
    [self.p removeWillSendAdStartListener:listener];
    [self.p youboraAdapterEventStart:params fromAdapter:self.mockAdAdapter];
    XCTAssertEqual(1, callbackTimes);
}

- (void) testwillSendAdStartWhenAdInitiatedListener {
    static int callbackTimes;
    
    [self.p fireInit];
    
    // Make build params return the first argument
    [given([self.p.mockRequestBuilder buildParams:anything() forService:anything()]) willDo:^id _Nonnull(NSInvocation * _Nonnull invocation) {
        return [invocation.mkt_arguments[0] mutableCopy];
    }];
    
    YBWillSendRequestBlock listener = ^(NSString * _Nonnull serviceName, YBPlugin * _Nonnull plugin, NSMutableDictionary * _Nonnull params) {
        callbackTimes++;
        XCTAssertEqualObjects(@"value", params[@"key"]);
    };
    
    NSDictionary * params = @{@"key":@"value"};
    
    self.p.adsAdapter = self.mockAdAdapter;
    
    // Ad Start
    callbackTimes = 0;
    [self.p addWillSendAdStartListener:listener];
    [self.p youboraAdapterEventAdInit:params fromAdapter:self.mockAdAdapter];
    [self.p youboraAdapterEventJoin:params fromAdapter:self.mockAdAdapter];
    [self.p removeWillSendAdStartListener:listener];
    [self.p youboraAdapterEventAdInit:params fromAdapter:self.mockAdAdapter];
    [self.p youboraAdapterEventJoin:params fromAdapter:self.mockAdAdapter];
    [self.p youboraAdapterEventStart:params fromAdapter:self.mockAdAdapter];
    XCTAssertEqual(1, callbackTimes);
}

- (void) testWillNotSendInitWhenAdStarted {
    static int callbackTimes;
    
     [self.p fireInit];
    
    // Make build params return the first argument
    [given([self.p.mockRequestBuilder buildParams:anything() forService:anything()]) willDo:^id _Nonnull(NSInvocation * _Nonnull invocation) {
        return [invocation.mkt_arguments[0] mutableCopy];
    }];
    
    YBWillSendRequestBlock listener = ^(NSString * _Nonnull serviceName, YBPlugin * _Nonnull plugin, NSMutableDictionary * _Nonnull params) {
        callbackTimes++;
        XCTAssertEqualObjects(@"value", params[@"key"]);
    };
    
    NSDictionary * params = @{@"key":@"value"};
    
    self.p.adsAdapter = self.mockAdAdapter;
    // Ad Start
    callbackTimes = 0;
    [self.p addWillSendInitListener:listener];
    [self.p youboraAdapterEventStart:params fromAdapter:self.mockAdAdapter];
    [self.p removeWillSendInitListener:listener];
    
    XCTAssertEqual(0, callbackTimes);
    
    [given([self.p getTitle]) willReturn:YBConstantsRequest.title];
    [given([self.p getOriginalResource]) willReturn:@"resource"];
    [given([self.p getIsLive]) willReturn:@NO];
    [given([self.p getDuration]) willReturn:@30];
    
    [self.p addWillSendStartListener:listener];
    [self.p youboraAdapterEventStart:params fromAdapter:self.mockAdapter];
    [self.p youboraAdapterEventStart:params fromAdapter:self.mockAdAdapter];
    [self.p removeWillSendStartListener:listener];
    [self.p youboraAdapterEventStart:params fromAdapter:self.mockAdapter];
    [self.p youboraAdapterEventStart:params fromAdapter:self.mockAdAdapter];
    
    XCTAssertEqual(0, callbackTimes);
}

- (void) testWillSendAdJoinListener {
    static int callbackTimes;
    
    // Make build params return the first argument
    [given([self.p.mockRequestBuilder buildParams:anything() forService:anything()]) willDo:^id _Nonnull(NSInvocation * _Nonnull invocation) {
        return [invocation.mkt_arguments[0] mutableCopy];
    }];
    
    YBWillSendRequestBlock listener = ^(NSString * _Nonnull serviceName, YBPlugin * _Nonnull plugin, NSMutableDictionary * _Nonnull params) {
        callbackTimes++;
        XCTAssertEqualObjects(@"value", params[@"key"]);
    };
    
    NSDictionary * params = @{@"key":@"value"};
    
    self.p.adsAdapter = self.mockAdAdapter;
    
    // Ad Join
    callbackTimes = 0;
    [self.p addWillSendAdJoinListener:listener];
    [self.p youboraAdapterEventJoin:params fromAdapter:self.mockAdAdapter];
    [self.p removeWillSendAdJoinListener:listener];
    [self.p youboraAdapterEventJoin:params fromAdapter:self.mockAdAdapter];
    XCTAssertEqual(1, callbackTimes);
}

- (void) testWillSendAdPauseListener {
    static int callbackTimes;
    
    // Make build params return the first argument
    [given([self.p.mockRequestBuilder buildParams:anything() forService:anything()]) willDo:^id _Nonnull(NSInvocation * _Nonnull invocation) {
        return [invocation.mkt_arguments[0] mutableCopy];
    }];
    
    YBWillSendRequestBlock listener = ^(NSString * _Nonnull serviceName, YBPlugin * _Nonnull plugin, NSMutableDictionary * _Nonnull params) {
        callbackTimes++;
        XCTAssertEqualObjects(@"value", params[@"key"]);
    };
    
    NSDictionary * params = @{@"key":@"value"};
    
    self.p.adsAdapter = self.mockAdAdapter;
    
    // Ad Pause
    callbackTimes = 0;
    [self.p addWillSendAdPauseListener:listener];
    [self.p youboraAdapterEventPause:params fromAdapter:self.mockAdAdapter];
    [self.p removeWillSendAdPauseListener:listener];
    [self.p youboraAdapterEventPause:params fromAdapter:self.mockAdAdapter];
    XCTAssertEqual(1, callbackTimes);
}

- (void) testWillSendAdResumeListener {
    static int callbackTimes;
    
    // Make build params return the first argument
    [given([self.p.mockRequestBuilder buildParams:anything() forService:anything()]) willDo:^id _Nonnull(NSInvocation * _Nonnull invocation) {
        return [invocation.mkt_arguments[0] mutableCopy];
    }];
    
    YBWillSendRequestBlock listener = ^(NSString * _Nonnull serviceName, YBPlugin * _Nonnull plugin, NSMutableDictionary * _Nonnull params) {
        callbackTimes++;
        XCTAssertEqualObjects(@"value", params[@"key"]);
    };
    
    NSDictionary * params = @{@"key":@"value"};
    
    self.p.adsAdapter = self.mockAdAdapter;
    
    // Ad Resume
    callbackTimes = 0;
    [self.p addWillSendAdResumeListener:listener];
    [self.p youboraAdapterEventResume:params fromAdapter:self.mockAdAdapter];
    [self.p removeWillSendAdResumeListener:listener];
    [self.p youboraAdapterEventResume:params fromAdapter:self.mockAdAdapter];
    XCTAssertEqual(1, callbackTimes);
}

- (void) testWillSendAdBufferListener {
    static int callbackTimes;
    
    // Make build params return the first argument
    [given([self.p.mockRequestBuilder buildParams:anything() forService:anything()]) willDo:^id _Nonnull(NSInvocation * _Nonnull invocation) {
        return [invocation.mkt_arguments[0] mutableCopy];
    }];
    
    YBWillSendRequestBlock listener = ^(NSString * _Nonnull serviceName, YBPlugin * _Nonnull plugin, NSMutableDictionary * _Nonnull params) {
        callbackTimes++;
        XCTAssertEqualObjects(@"value", params[@"key"]);
    };
    
    NSDictionary * params = @{@"key":@"value"};
    
    self.p.adsAdapter = self.mockAdAdapter;
    
    // Ad Buffer
    callbackTimes = 0;
    [self.p addWillSendAdBufferListener:listener];
    [self.p youboraAdapterEventBufferEnd:params fromAdapter:self.mockAdAdapter];
    [self.p removeWillSendAdBufferListener:listener];
    [self.p youboraAdapterEventBufferEnd:params fromAdapter:self.mockAdAdapter];
    XCTAssertEqual(1, callbackTimes);
}

- (void) testWillSendAdStopListener {
    static int callbackTimes;
    
    // Make build params return the first argument
    [given([self.p.mockRequestBuilder buildParams:anything() forService:anything()]) willDo:^id _Nonnull(NSInvocation * _Nonnull invocation) {
        return [invocation.mkt_arguments[0] mutableCopy];
    }];
    
    YBWillSendRequestBlock listener = ^(NSString * _Nonnull serviceName, YBPlugin * _Nonnull plugin, NSMutableDictionary * _Nonnull params) {
        callbackTimes++;
        XCTAssertEqualObjects(@"value", params[@"key"]);
    };
    
    NSDictionary * params = @{@"key":@"value"};
    
    self.p.adsAdapter = self.mockAdAdapter;
    
    // Ad Stop
    callbackTimes = 0;
    [self.p addWillSendAdStopListener:listener];
    [self.p youboraAdapterEventStop:params fromAdapter:self.mockAdAdapter];
    [self.p removeWillSendAdStopListener:listener];
    [self.p youboraAdapterEventStop:params fromAdapter:self.mockAdAdapter];
    XCTAssertEqual(1, callbackTimes);
}

// Will send listeners

- (void)testInit {
    self.options.enabled = @YES;
    
    [given([self.p.mockRequestBuilder buildParams:anything() forService:anything()]) willReturn:[@{@"key":@"value"} mutableCopy]];
    
    [self.p fireInit];
    [verifyCount(self.p.mockRequest, times(1)) setHost:anything()];
    [verifyCount(self.p.mockRequest, times(1)) setService:YBConstantsYouboraService.sInit];
}

- (void)testError {
    self.options.enabled = @YES;
    [self.p removeAdapter];
    [given([self.p.mockRequestBuilder buildParams:anything() forService:anything()]) willReturn:[@{@"key":@"value"} mutableCopy]];
    
    [self.p fireErrorWithParams:nil];
    [self.p fireErrorWithMessage:@"" code:@"" andErrorMetadata:@""];
    [self.p fireFatalErrorWithMessage:@"message" code:@"code" andErrorMetadata:@"" andException:nil];
    [verifyCount(self.p.mockRequest, times(3)) setService:YBConstantsYouboraService.error];
}

- (void)testStop {
    self.options.enabled = @YES;
    [self.p removeAdapter];
    
    [given([self.p.mockRequestBuilder buildParams:anything() forService:anything()]) willReturn:[@{@"key":@"value"} mutableCopy]];
    
    [self.p fireInit];
    [verifyCount(self.p.mockRequest, times(1)) setHost:anything()];
    [verifyCount(self.p.mockRequest, times(1)) setService: YBConstantsYouboraService.sInit];
    [self.p fireStop];
    [verifyCount(self.p.mockRequest, times(1)) setHost:anything()];
    [verifyCount(self.p.mockRequest, times(1)) setService: YBConstantsYouboraService.stop];
}

- (void)testStopWithAdapter {
    self.options.enabled = @YES;
    
    [given([self.p.mockRequestBuilder buildParams:anything() forService:anything()]) willReturn:[@{@"key":@"value"} mutableCopy]];
    
    [self.p fireInit];
    [verifyCount(self.p.mockRequest, times(1)) setHost:anything()];
    [verifyCount(self.p.mockRequest, times(1)) setService: YBConstantsYouboraService.sInit];
    YBPlaybackFlags * adapterFlags = [YBPlaybackFlags new];
    adapterFlags.started = true;
    stubProperty(self.mockAdapter, flags, adapterFlags);
    [self.p fireStop];
    [verifyCount(self.mockAdapter, times(1)) fireStop];
}

- (void)testOfflineEventsOfflineOption {
    self.options.enabled = @YES;
    [self.p removeAdapter];
    
    [given([self.p.mockRequestBuilder buildParams:anything() forService:anything()]) willReturn:[@{@"key":@"value"} mutableCopy]];
    
    self.options.offline = @YES;
    
    [self.p fireOfflineEvents];
    XCTAssertNil(self.p.mockRequest);
    
    
}

- (void)testOfflineEventsInitiated {
    self.options.enabled = @YES;
    [self.p removeAdapter];
    
    [given([self.p.mockRequestBuilder buildParams:anything() forService:anything()]) willReturn:[@{@"key":@"value"} mutableCopy]];
    
    [self.p fireInit];
    [self.p fireOfflineEvents];
    [verifyCount(self.p.mockRequest, times(0)) setService: YBConstantsYouboraService.offline];
}

- (void)testOfflineEventsAdapterNotNil {
    self.options.enabled = @YES;
    
    [given([self.p.mockRequestBuilder buildParams:anything() forService:anything()]) willReturn:[@{@"key":@"value"} mutableCopy]];
    
    [self.p fireOfflineEvents];
    XCTAssertNil(self.p.mockRequest);
}

- (void) testStopNotSentTwice {
    self.options.enabled = @YES;
    [self.p removeAdapter];
    
    [given([self.p.mockRequestBuilder buildParams:anything() forService:anything()]) willReturn:[@{@"key":@"value"} mutableCopy]];
    
    [self.p fireInit];
    [verifyCount(self.p.mockRequest, times(1)) setHost:anything()];
    [verifyCount(self.p.mockRequest, times(1)) setService: YBConstantsYouboraService.sInit];
    
    [self.p fireStop];
    [verifyCount(self.p.mockRequest, times(1)) setHost:anything()];
    [verifyCount(self.p.mockRequest, times(1)) setService: YBConstantsYouboraService.stop];
    
    [self.p fireStop];
    [verifyCount(self.p.mockRequest, times(0)) setHost:anything()];
    [verifyCount(self.p.mockRequest, times(0)) setService: YBConstantsYouboraService.stop];
}

- (void) testStopCalledWithoutInit {
    static BOOL stopCalled = false;
    
    self.options.enabled = @YES;
    [self.p removeAdapter];
    
    YBWillSendRequestBlock listener = ^(NSString * _Nonnull serviceName, YBPlugin * _Nonnull plugin, NSMutableDictionary * _Nonnull params) {
        stopCalled = true;
    };
    
    [self.p addWillSendStopListener:listener];
    [self.p fireStop];
    [self.p removeWillSendStopListener:listener];
    XCTAssertFalse(stopCalled);
}

- (void) testStopWhenAdapterNotNull{
    self.options.enabled = @YES;
    //we don't want to mock adapter for this test
    [self.p setAdapter:[YBPlayerAdapter new]];
    id<YBPlayerAdapterEventDelegate> mockDelegate = mockProtocol(@protocol(YBPlayerAdapterEventDelegate));
    
    [self.p.adapter addYouboraAdapterDelegate:mockDelegate];
    [self.p.adapter fireStart];
    [self.p.adapter fireStop];
    [verify(mockDelegate) youboraAdapterEventStop:anything() fromAdapter:self.p.adapter];
}

- (void) testWillForceInit {
    static int initCallbackTimes;
    static int startCallbackTimes;
    
    // Make build params return the first argument
    [given([self.p.mockRequestBuilder buildParams:anything() forService:anything()]) willDo:^id _Nonnull(NSInvocation * _Nonnull invocation) {
        return [invocation.mkt_arguments[0] mutableCopy];
    }];
    
    YBWillSendRequestBlock listener = ^(NSString * _Nonnull serviceName, YBPlugin * _Nonnull plugin, NSMutableDictionary * _Nonnull params) {
        if ([serviceName isEqualToString: YBConstantsYouboraService.sInit]) {
            initCallbackTimes++;
        }
        if ([serviceName isEqualToString: YBConstantsYouboraService.start]) {
            startCallbackTimes++;
        }
        XCTAssertEqualObjects(@"value", params[@"key"]);
    };
    
    NSDictionary * params = @{@"key":@"value"};
    
    [given([self.p getTitle]) willReturn:YBConstantsRequest.title];
    [given([self.p getOriginalResource]) willReturn:@"resource"];
    [given([self.p getIsLive]) willReturn:@NO];
    [given([self.p getDuration]) willReturn:@(288)];
    self.options.forceInit = @(true);
    
    // Init
    [self.p addWillSendInitListener:listener];
    [self.p addWillSendStartListener:listener];
    [self.p youboraAdapterEventStart:params fromAdapter:self.p.adapter];
    [self.p removeWillSendInitListener:listener];
    [self.p removeWillSendStartListener:listener];
    
    [self.p youboraAdapterEventStart:params fromAdapter:self.p.adapter];
    XCTAssertEqual(1, initCallbackTimes);
    XCTAssertEqual(0, startCallbackTimes);
}

- (void) testWillSendStartWhenJoined {
    static int initCallbackTimes;
    static int startCallbackTimes;
    
    // Make build params return the first argument
    [given([self.p.mockRequestBuilder buildParams:anything() forService:anything()]) willDo:^id _Nonnull(NSInvocation * _Nonnull invocation) {
        return [invocation.mkt_arguments[0] mutableCopy];
    }];
    
    YBWillSendRequestBlock listener = ^(NSString * _Nonnull serviceName, YBPlugin * _Nonnull plugin, NSMutableDictionary * _Nonnull params) {
        if ([serviceName isEqualToString: YBConstantsYouboraService.sInit]) {
            initCallbackTimes++;
        }
        if ([serviceName isEqualToString: YBConstantsYouboraService.start]) {
            startCallbackTimes++;
        }
        //Doesn't apply since we want to send this start "blank"
        //XCTAssertEqualObjects(@"value", params[@"key"]);
    };
    
    NSDictionary * params = @{@"key":@"value"};
    
    // Init
    
    [self.p fireInitWithParams:params];
    
    [self.p addWillSendInitListener:listener];
    [self.p addWillSendStartListener:listener];
    self.p.adapter.flags.started = true;
    [self.p youboraAdapterEventJoin:params fromAdapter:self.p.adapter];
    [self.p removeWillSendInitListener:listener];
    [self.p removeWillSendStartListener:listener];
    
    [self.p fireInitWithParams:params];
    [self.p youboraAdapterEventJoin:params fromAdapter:self.p.adapter];
    XCTAssertEqual(0, initCallbackTimes);
    XCTAssertEqual(1, startCallbackTimes);
}

// Pings tests
- (void)testPingBasicParams {
    self.p.timerCallback(self.p.mockTimer, 5000);
    
    HCArgumentCaptor * captor = [HCArgumentCaptor new];
    [verify(self.p.mockRequestBuilder) buildParams:anything() forService:YBConstantsYouboraService.ping];
    [verify(self.p.mockRequestBuilder) fetchParams:anything() paramList:(id)captor onlyDifferent:false];
    
    NSArray * params = captor.value;
    [self verifyBasicParamsPing:params];
}

- (void)testPingPaused {
    self.mockAdapter.flags.paused = true;
    
    self.p.timerCallback(self.p.mockTimer, 5000);
    
    HCArgumentCaptor * captor = [HCArgumentCaptor new];
    [verify(self.p.mockRequestBuilder) fetchParams:anything() paramList:(id)captor onlyDifferent:false];
    
    NSArray * params = captor.value;
    XCTAssertTrue([params containsObject:YBConstantsRequest.pauseDuration]);
}

- (void)testPingBuffering {
    self.mockAdapter.flags.buffering = true;
    
    self.p.timerCallback(self.p.mockTimer, 5000);
    
    HCArgumentCaptor * captor = [HCArgumentCaptor new];
    [verify(self.p.mockRequestBuilder) fetchParams:anything() paramList:(id)captor onlyDifferent:false];
    
    NSArray * params = captor.value;
    [self verifyBasicParamsPing:params];
    XCTAssertTrue([params containsObject:YBConstantsRequest.bufferDuration]);
}

- (void)testPingSeek {
    self.mockAdapter.flags.seeking = true;
    
    self.p.timerCallback(self.p.mockTimer, 5000);
    
    HCArgumentCaptor * captor = [HCArgumentCaptor new];
    [verify(self.p.mockRequestBuilder) fetchParams:anything() paramList:(id)captor onlyDifferent:false];
    
    NSArray * params = captor.value;
    [self verifyBasicParamsPing:params];
    XCTAssertTrue([params containsObject:YBConstantsRequest.seekDuration]);
}

- (void)testAds {
    self.mockAdAdapter.flags.started = true;
    self.mockAdAdapter.flags.buffering = true;

    self.p.adsAdapter = self.mockAdAdapter;
    
    self.p.timerCallback(self.p.mockTimer, 5000);
    
    HCArgumentCaptor * captor = [HCArgumentCaptor new];
    [verify(self.p.mockRequestBuilder) fetchParams:anything() paramList:(id)captor onlyDifferent:false];
    NSArray * params = captor.value;
    [self verifyBasicParamsPing:params];
    XCTAssertTrue([params containsObject:YBConstantsRequest.adBitrate]);
    XCTAssertTrue([params containsObject:YBConstantsRequest.adPlayhead]);
    XCTAssertTrue([params containsObject:YBConstantsRequest.adBufferDuration]);
}

-(void)testVideoCodec {
    YBPlugin * p = [[YBPlugin alloc] initWithOptions:self.options];
    XCTAssertNil([p getContentEncodingVideoCodec]);
    
    NSString *testOptionsVideoCodec = @"OptionsVideoCodec";
    
    self.options.contentEncodingVideoCodec = testOptionsVideoCodec;
    
    XCTAssertTrue([[p getContentEncodingVideoCodec] isEqualToString:testOptionsVideoCodec]);
    
    NSString *testAdapterVideoCodec = @"AdapterVideoCodec";
    
    [given([self.mockAdapter getVideoCodec]) willReturn:testAdapterVideoCodec];
    p.adapter = self.mockAdapter;
    
    XCTAssertTrue([[p getContentEncodingVideoCodec] isEqualToString:testOptionsVideoCodec]);
    
    self.options.contentEncodingVideoCodec = nil;
    
    XCTAssertTrue([[p getContentEncodingVideoCodec] isEqualToString:testAdapterVideoCodec]);
    
}

-(void)testAudioCodec {
    YBPlugin * p = [[YBPlugin alloc] initWithOptions:self.options];
    XCTAssertNil([p getContentEncodingAudioCodec]);
    
    NSString *testOptionsAudioCodec = @"OptionsAudioCodec";
    
    self.options.contentEncodingAudioCodec = testOptionsAudioCodec;
    
    XCTAssertTrue([[p getContentEncodingAudioCodec] isEqualToString:testOptionsAudioCodec]);
    
    NSString *testAdapterAudioCodec = @"AdapterAudioCodec";
    
    [given([self.mockAdapter getAudioCodec]) willReturn:testAdapterAudioCodec];
    p.adapter = self.mockAdapter;
    
    XCTAssertTrue([[p getContentEncodingAudioCodec] isEqualToString:testOptionsAudioCodec]);
    
    self.options.contentEncodingAudioCodec = nil;
    
    XCTAssertTrue([[p getContentEncodingAudioCodec] isEqualToString:testAdapterAudioCodec]);
}


- (void) verifyBasicParamsPing:(NSArray *) params {
    XCTAssertTrue([params containsObject:YBConstantsRequest.bitrate]);
    XCTAssertTrue([params containsObject:YBConstantsRequest.throughput]);
    XCTAssertTrue([params containsObject:YBConstantsRequest.fps]);
}

- (void) transformDone:(NSNotification *)notification {
}

@end
