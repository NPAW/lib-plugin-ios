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
#import "YBChrono.h"
#import "YBOptions.h"
#import "YBLog.h"
#import "YBViewTransform.h"
#import "YBResourceTransform.h"
#import "YBPlayerAdapter.h"
#import "YBRequest.h"
#import "YBCommunication.h"
#import "YBConstants.h"
#import "YBTimer.h"
#import "YBYouboraUtils.h"
#import "YBPlaybackFlags.h"
#import "YBPlaybackChronos.h"
#import "YBFastDataConfig.h"
#import "YBFlowTransform.h"
#import "YBNqs6Transform.h"
#import "YBPlayheadMonitor.h"

@interface YBPluginTest : XCTestCase

@property(nonatomic, strong) YBPlayerAdapter * mockAdapter;
@property(nonatomic, strong) YBPlayerAdapter *mockAdAdapter;
@property(nonatomic, strong) YBOptions * mockOptions;

@property(nonatomic, strong) YBTestablePlugin * p;

@end

@implementation YBPluginTest

- (void)setUp {
    [super setUp];
    
    self.mockAdapter = mock([YBPlayerAdapter class]);
    self.mockAdAdapter = mock([YBPlayerAdapter class]);
    self.mockOptions = mock([YBOptions class]);
    
    self.p = [[YBTestablePlugin alloc] initWithOptions:self.mockOptions andAdapter:self.mockAdapter];
    
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
    [verifyCount(self.p.mockViewTransform, times(1)) addTransformDoneListener:anything()];

    [verifyCount(self.p.mockViewTransform, times(1)) begin];
    
    [verifyCount(self.mockAdapter, times(1)) addYouboraAdapterDelegate:anything()];
}

- (void)testSetOptions {
    stubProperty(self.mockOptions, accountCode, @"a");
    
    YBPlugin * p = [[YBPlugin alloc] initWithOptions:self.mockOptions];
    
    XCTAssertEqualObjects(@"a", p.options.accountCode);
    
    p = [[YBPlugin alloc] initWithOptions:nil];
    
    XCTAssertNotNil(p.options);
    XCTAssertEqualObjects(@"nicetest", p.options.accountCode);
}

- (void)testAddAndRemoveAdapters {
    
    YBPlugin * plugin = [[YBPlugin alloc] initWithOptions:self.mockOptions];
    
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
    YBPlugin * plugin = [[YBPlugin alloc] initWithOptions:self.mockOptions];
    
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

- (void)testEnableDisable {
    [self.p enable];
    [verify(self.mockOptions) setEnabled:true];
    
    [self.p disable];
    [verify(self.mockOptions) setEnabled:false];
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
    stubProperty(self.mockOptions, host, @"http://host.com");
    stubProperty(self.mockOptions, httpSecure, @(true));
    
    XCTAssertEqualObjects(@"https://host.com", [self.p getHost]);
}

- (void)testParseHls {
    stubProperty(self.mockOptions, parseCdnNode, @(true));
    XCTAssertTrue([self.p isParseCdnNode]);
    
    stubProperty(self.mockOptions, parseCdnNode, @(false));
    XCTAssertFalse([self.p isParseCdnNode]);
}

- (void)testCdnNode {
    stubProperty(self.mockOptions, parseHls, @(true));
    XCTAssertTrue([self.p isParseHls]);
    
    stubProperty(self.mockOptions, parseHls, @(false));
    XCTAssertFalse([self.p isParseHls]);
}

- (void)testParseCdnNodeList {
    NSArray * list = @[@"item1", @"item2", @"item3"];
    
    stubProperty(self.mockOptions, parseCdnNodeList, nil);
    XCTAssertNil(self.p.getParseCdnNodeList);
    
    stubProperty(self.mockOptions, parseCdnNodeList, list);
    XCTAssertEqualObjects(list, self.p.getParseCdnNodeList);
}

- (void)testParseCdnNodeHeader {
    stubProperty(self.mockOptions, parseCdnNameHeader, @"x-header");
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
    stubProperty(self.mockOptions, contentFps, @25);
    [given([self.mockAdapter getFramesPerSecond]) willReturn:@15];
    XCTAssertEqualObjects(@25, [self.p getFramesPerSecond]);
    
    stubProperty(self.mockOptions, contentFps, nil);
    [given([self.mockAdapter getFramesPerSecond]) willReturn:@15.5];
    XCTAssertEqualObjects(@15.5, [self.p getFramesPerSecond]);
    
    stubProperty(self.mockOptions, contentFps, nil);
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
    stubProperty(self.mockOptions, contentDuration, @3);
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
    stubProperty(self.mockOptions, contentBitrate, @1000000);
    [given([self.mockAdapter getBitrate]) willReturn:@2000000];
    XCTAssertEqualObjects(@1000000, [self.p getBitrate]);
}

- (void)testThroughput {
    [given([self.mockAdapter getThroughput]) willReturn:@1000000];
    XCTAssertEqualObjects(@1000000, [self.p getThroughput]);
    
    [given([self.mockAdapter getThroughput]) willReturn:@(INFINITY)];
    XCTAssertEqualObjects(@(-1), [self.p getThroughput]);
    
    // Options > adapter
    stubProperty(self.mockOptions, contentThroughput, @2000000);
    
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
    stubProperty(self.mockOptions, contentRendition, @"2Mbps");
    [given([self.mockAdapter getRendition]) willReturn:@"1Mbps"];
    XCTAssertEqualObjects(@"2Mbps", [self.p getRendition]);
    
    // unless its empty
    stubProperty(self.mockOptions, contentRendition, @"");
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
    stubProperty(self.mockOptions, contentTitle, @"iron man");
    [given([self.mockAdapter getTitle]) willReturn:@"batman"];
    XCTAssertEqualObjects(@"iron man", [self.p getTitle]);
    
    // unless empty
    stubProperty(self.mockOptions, contentTitle, @"");
    XCTAssertEqualObjects(@"batman", [self.p getTitle]);
}

- (void)testTitle2 {
    [given([self.mockAdapter getTitle2]) willReturn:@"episode 1"];
    XCTAssertEqualObjects(@"episode 1", [self.p getTitle2]);
    
    [given([self.mockAdapter getTitle2]) willReturn:@""];
    XCTAssertEqualObjects(@"", [self.p getTitle2]);
    
    [given([self.mockAdapter getTitle2]) willReturn:nil];
    XCTAssertEqualObjects(nil, [self.p getTitle2]);
    
    // Options > adapter
    stubProperty(self.mockOptions, contentTitle2, @"episode 2");
    [given([self.mockAdapter getTitle2]) willReturn:@"episode 1"];
    XCTAssertEqualObjects(@"episode 2", [self.p getTitle2]);
    
    // unless empty
    stubProperty(self.mockOptions, contentTitle2, @"");
    XCTAssertEqualObjects(@"episode 1", [self.p getTitle2]);
}

- (void)testLive {
    stubProperty(self.mockOptions, contentIsLive, nil);
    
    [given([self.mockAdapter getIsLive]) willReturn:nil];
    XCTAssertNil([self.p getIsLive]);
    
    [given([self.mockAdapter getIsLive]) willReturn:@NO];
    XCTAssertEqualObjects(@NO, [self.p getIsLive]);
    
    [given([self.mockAdapter getIsLive]) willReturn:@YES];
    XCTAssertEqualObjects(@YES, [self.p getIsLive]);
    
    // Options > adapter
    stubProperty(self.mockOptions, contentIsLive, @NO);
    XCTAssertEqualObjects(@NO, [self.p getIsLive]);
    
    stubProperty(self.mockOptions, contentIsLive, @YES);
    [given([self.mockAdapter getIsLive]) willReturn:@NO];
    XCTAssertEqualObjects(@YES, [self.p getIsLive]);
}

- (void)testGetResource {
    [given([self.p.mockResourceTransform isBlocking:anything()]) willReturn:@YES];
    stubProperty(self.mockOptions, contentResource, @"ResourceFromOptions");
    [given([self.p.mockResourceTransform getResource]) willReturn:@"ResourceFromTransform"];
    [given([self.mockAdapter getResource]) willReturn:@"ResourceFromAdapter"];
    
    XCTAssertEqualObjects(@"ResourceFromOptions", [self.p getResource]);
    
    [given([self.p.mockResourceTransform isBlocking:anything()]) willReturn:@NO];
    XCTAssertEqualObjects(@"ResourceFromTransform", [self.p getResource]);
    
    stubProperty(self.mockOptions, contentResource, nil);
    [given([self.p.mockResourceTransform getResource]) willReturn:nil];

    XCTAssertEqualObjects(@"ResourceFromAdapter", [self.p getResource]);

    [given([self.mockAdapter getResource]) willReturn:nil];
    
    XCTAssertNil([self.p getResource]);
}

- (void)testTransactionCode {
    stubProperty(self.mockOptions, contentTransactionCode, @"transactionCode");
    
    XCTAssertEqualObjects(@"transactionCode", [self.p getTransactionCode]);
    
    stubProperty(self.mockOptions, contentTransactionCode, nil);
    
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
    stubProperty(self.mockOptions, contentCdn, @"CdnFromOptions");
    [given([self.p.mockResourceTransform getCdnName]) willReturn:@"CdnFromTransform"];

    XCTAssertEqualObjects(@"CdnFromOptions", [self.p getCdn]);
    
    [given([self.p.mockResourceTransform isBlocking:anything()]) willReturn:@NO];
    XCTAssertEqualObjects(@"CdnFromTransform", [self.p getCdn]);
    
    [given([self.p.mockResourceTransform getCdnName]) willReturn:nil];
    XCTAssertEqualObjects(@"CdnFromOptions", [self.p getCdn]);
    
    stubProperty(self.mockOptions, contentCdn, nil);
    XCTAssertNil([self.p getCdn]);
}

- (void)testPluginVersion {
    [given([self.mockAdapter getVersion]) willReturn:nil];
    
    XCTAssertEqualObjects([YouboraLibVersion stringByAppendingString:@"-adapterless"], [self.p getPluginVersion]);
    
    [given([self.mockAdapter getVersion]) willReturn:[YouboraLibVersion stringByAppendingString:@"-CustomPlugin"]];
    
    XCTAssertEqualObjects([YouboraLibVersion stringByAppendingString:@"-CustomPlugin"], [self.p getPluginVersion]);
    
    [self.p removeAdapter];
    
    XCTAssertEqualObjects([YouboraLibVersion stringByAppendingString:@"-adapterless"], [self.p getPluginVersion]);
}

- (void)testExtraparams {
    stubProperty(self.mockOptions, extraparam1, @"value-extraparam1");
    stubProperty(self.mockOptions, extraparam2, @"value-extraparam2");
    stubProperty(self.mockOptions, extraparam3, @"value-extraparam3");
    stubProperty(self.mockOptions, extraparam4, @"value-extraparam4");
    stubProperty(self.mockOptions, extraparam5, @"value-extraparam5");
    stubProperty(self.mockOptions, extraparam6, @"value-extraparam6");
    stubProperty(self.mockOptions, extraparam7, @"value-extraparam7");
    stubProperty(self.mockOptions, extraparam8, @"value-extraparam8");
    stubProperty(self.mockOptions, extraparam9, @"value-extraparam9");
    stubProperty(self.mockOptions, extraparam10, @"value-extraparam10");
    
    XCTAssertEqualObjects(@"value-extraparam1", [self.p getExtraparam1]);
    XCTAssertEqualObjects(@"value-extraparam2", [self.p getExtraparam2]);
    XCTAssertEqualObjects(@"value-extraparam3", [self.p getExtraparam3]);
    XCTAssertEqualObjects(@"value-extraparam4", [self.p getExtraparam4]);
    XCTAssertEqualObjects(@"value-extraparam5", [self.p getExtraparam5]);
    XCTAssertEqualObjects(@"value-extraparam6", [self.p getExtraparam6]);
    XCTAssertEqualObjects(@"value-extraparam7", [self.p getExtraparam7]);
    XCTAssertEqualObjects(@"value-extraparam8", [self.p getExtraparam8]);
    XCTAssertEqualObjects(@"value-extraparam9", [self.p getExtraparam9]);
    XCTAssertEqualObjects(@"value-extraparam10", [self.p getExtraparam10]);
    
    stubProperty(self.mockOptions, extraparam1, nil);
    stubProperty(self.mockOptions, extraparam2, nil);
    stubProperty(self.mockOptions, extraparam3, nil);
    stubProperty(self.mockOptions, extraparam4, nil);
    stubProperty(self.mockOptions, extraparam5, nil);
    stubProperty(self.mockOptions, extraparam6, nil);
    stubProperty(self.mockOptions, extraparam7, nil);
    stubProperty(self.mockOptions, extraparam8, nil);
    stubProperty(self.mockOptions, extraparam9, nil);
    stubProperty(self.mockOptions, extraparam10, nil);
    
    XCTAssertNil([self.p getExtraparam1]);
    XCTAssertNil([self.p getExtraparam2]);
    XCTAssertNil([self.p getExtraparam3]);
    XCTAssertNil([self.p getExtraparam4]);
    XCTAssertNil([self.p getExtraparam5]);
    XCTAssertNil([self.p getExtraparam6]);
    XCTAssertNil([self.p getExtraparam7]);
    XCTAssertNil([self.p getExtraparam8]);
    XCTAssertNil([self.p getExtraparam9]);
    XCTAssertNil([self.p getExtraparam10]);
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
    
    [given([self.mockAdAdapter getVersion]) willReturn:[YouboraLibVersion stringByAppendingString:@"-CustomAdapter"]];
    
    XCTAssertEqualObjects([YouboraLibVersion stringByAppendingString:@"-CustomAdapter"], [self.p getAdAdapterVersion]);
    
    [self.p removeAdsAdapter];
    
    XCTAssertNil([self.p getAdAdapterVersion]);
}

- (void)testIp {
    XCTAssertNil([self.p getIp]);
    stubProperty(self.mockOptions, networkIP, @"1.2.3.4");
    XCTAssertEqualObjects(@"1.2.3.4", [self.p getIp]);
}

- (void)testIsp {
    XCTAssertNil([self.p getIsp]);
    stubProperty(self.mockOptions, networkIsp, @"ISP");
    XCTAssertEqualObjects(@"ISP", [self.p getIsp]);
}

- (void)testConnectionType {
    XCTAssertNil([self.p getConnectionType]);
    stubProperty(self.mockOptions, networkConnectionType, @"DSL");
    XCTAssertEqualObjects(@"DSL", [self.p getConnectionType]);
}

- (void)testDeviceCode {
    XCTAssertNil([self.p getDeviceCode]);
    stubProperty(self.mockOptions, deviceCode, @"42");
    XCTAssertEqualObjects(@"42", [self.p getDeviceCode]);
}

- (void)testAccountCode {
    XCTAssertNil([self.p getAccountCode]);
    stubProperty(self.mockOptions, accountCode, @"accountcode");
    XCTAssertEqualObjects(@"accountcode", [self.p getAccountCode]);
}

- (void)testUsername {
    XCTAssertNil([self.p getUsername]);
    stubProperty(self.mockOptions, username, @"username");
    XCTAssertEqualObjects(@"username", [self.p getUsername]);
}

- (void)testNodeHost {
    XCTAssertNil([self.p getIp]);
    [given([self.p.mockResourceTransform getNodeHost]) willReturn:@"nodeHost"];
    XCTAssertEqualObjects(@"nodeHost", [self.p getNodeHost]);
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

- (void)testChronoTimes {
    // Init and preload chronos don't depend on the adapter
    [given([self.p.mockChrono getDeltaTime:false]) willReturn:@100];
    XCTAssertEqual(100, [self.p getInitDuration]);
    
    [given([self.p.mockChrono getDeltaTime:false]) willReturn:@200];
    XCTAssertEqual(200, [self.p getInitDuration]);
    
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

- (void) testWillSendAdStartListener {
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
    
    // Ad Start
    callbackTimes = 0;
    [self.p addWillSendAdStartListener:listener];
    [self.p youboraAdapterEventStart:params fromAdapter:self.mockAdAdapter];
    [self.p removeWillSendAdStartListener:listener];
    [self.p youboraAdapterEventStart:params fromAdapter:self.mockAdAdapter];
    XCTAssertEqual(1, callbackTimes);
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
    stubProperty(self.mockOptions, enabled, @YES);
    
    [given([self.p.mockRequestBuilder buildParams:anything() forService:anything()]) willReturn:[@{@"key":@"value"} mutableCopy]];
    
    [self.p fireInit];
    [verifyCount(self.p.mockRequest, times(1)) setHost:anything()];
    [verifyCount(self.p.mockRequest, times(1)) setService:YouboraServiceInit];
}

// Pings tests
- (void)testPingBasicParams {
    self.p.timerCallback(self.p.mockTimer, 5000);
    
    HCArgumentCaptor * captor = [HCArgumentCaptor new];
    [verify(self.p.mockRequestBuilder) buildParams:anything() forService:YouboraServicePing];
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
    XCTAssertTrue([params containsObject:@"pauseDuration"]);
}

- (void)testPingBuffering {
    self.mockAdapter.flags.buffering = true;
    
    self.p.timerCallback(self.p.mockTimer, 5000);
    
    HCArgumentCaptor * captor = [HCArgumentCaptor new];
    [verify(self.p.mockRequestBuilder) fetchParams:anything() paramList:(id)captor onlyDifferent:false];
    
    NSArray * params = captor.value;
    [self verifyBasicParamsPing:params];
    XCTAssertTrue([params containsObject:@"bufferDuration"]);
}

- (void)testPingSeek {
    self.mockAdapter.flags.seeking = true;
    
    self.p.timerCallback(self.p.mockTimer, 5000);
    
    HCArgumentCaptor * captor = [HCArgumentCaptor new];
    [verify(self.p.mockRequestBuilder) fetchParams:anything() paramList:(id)captor onlyDifferent:false];
    
    NSArray * params = captor.value;
    [self verifyBasicParamsPing:params];
    XCTAssertTrue([params containsObject:@"seekDuration"]);
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
    XCTAssertTrue([params containsObject:@"adBitrate"]);
    XCTAssertTrue([params containsObject:@"adPlayhead"]);
    XCTAssertTrue([params containsObject:@"adBufferDuration"]);
}

- (void) verifyBasicParamsPing:(NSArray *) params {
    XCTAssertTrue([params containsObject:@"bitrate"]);
    XCTAssertTrue([params containsObject:@"throughput"]);
    XCTAssertTrue([params containsObject:@"fps"]);
}

@end
