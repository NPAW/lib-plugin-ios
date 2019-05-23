//
//  YBRequestBuilderTest.m
//  YouboraLib
//
//  Created by Joan on 30/03/2017.
//  Copyright © 2017 NPAW. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "YBRequestBuilder.h"
#import "YBPlugin.h"
#import "YBConstants.h"

#import <OCMockito/OCMockito.h>

@interface YBRequestBuilderTest : XCTestCase

@property (nonatomic, strong) YBPlugin * mockPlugin;
@property (nonatomic, strong) YBRequestBuilder * builder;

@end

@implementation YBRequestBuilderTest

static NSArray * ALL_PARAMS;

- (void)setUp {
    [super setUp];

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ALL_PARAMS = @[@"playhead", @"playrate", @"fps", @"droppedFrames",
                       @"mediaDuration", @"bitrate", @"throughput", @"rendition", @"title", @"title2", @"live",
                       @"mediaResource", @"transactionCode", @"properties", @"playerVersion", @"player", @"cdn",
                       @"pluginVersion", @"param1", @"param2", @"param3", @"param4", @"param5", @"param6",
                       @"param7", @"param8", @"param9", @"param10", @"adPosition", @"adPlayhead", @"adDuration",
                       @"adBitrate", @"adTitle", @"adResource", @"adPlayerVersion", @"adProperties",
                       @"adAdapterVersion", @"pluginInfo", @"isp", @"connectionType", @"ip", @"deviceCode",
                       @"system", @"accountCode", @"username", @"preloadDuration", @"joinDuration",
                       @"bufferDuration", @"seekDuration", @"pauseDuration", @"adJoinDuration",
                       @"adBufferDuration", @"adPauseDuration", @"adTotalDuration", @"nodeHost", @"nodeType",
                       @"nodeTypeString", @"metrics", @"sessionMetrics"];
    });

    self.mockPlugin = mock([YBPlugin class]);
    self.builder = [[YBRequestBuilder alloc] initWithPlugin:self.mockPlugin];
    
    // Mocks
    [given([self.mockPlugin getPlayhead]) willReturn:@1];
    [given([self.mockPlugin getPlayrate]) willReturn:@2];
    [given([self.mockPlugin getFramesPerSecond]) willReturn:@3];
    [given([self.mockPlugin getDroppedFrames]) willReturn:@4];
    [given([self.mockPlugin getDuration]) willReturn:@5];
    [given([self.mockPlugin getBitrate]) willReturn:@6];
    [given([self.mockPlugin getThroughput]) willReturn:@7];
    [given([self.mockPlugin getRendition]) willReturn:@"a"];
    [given([self.mockPlugin getTitle]) willReturn:@"b"];
    [given([self.mockPlugin getProgram]) willReturn:@"c"];
    [given([self.mockPlugin getIsLive]) willReturn:@(true)];
    [given([self.mockPlugin getResource]) willReturn:@"d"];
    [given([self.mockPlugin getTransactionCode]) willReturn:@"e"];
    [given([self.mockPlugin getContentMetadata]) willReturn:@"f"];
    [given([self.mockPlugin getPlayerVersion]) willReturn:@"g"];
    [given([self.mockPlugin getPlayerName]) willReturn:@"h"];
    [given([self.mockPlugin getCdn]) willReturn:@"i"];
    [given([self.mockPlugin getPluginVersion]) willReturn:@"j"];
    [given([self.mockPlugin getContentCustomDimension1]) willReturn:@"j"];
    [given([self.mockPlugin getContentCustomDimension2]) willReturn:@"l"];
    [given([self.mockPlugin getContentCustomDimension3]) willReturn:@"m"];
    [given([self.mockPlugin getContentCustomDimension4]) willReturn:@"n"];
    [given([self.mockPlugin getContentCustomDimension5]) willReturn:@"o"];
    [given([self.mockPlugin getContentCustomDimension6]) willReturn:@"p"];
    [given([self.mockPlugin getContentCustomDimension7]) willReturn:@"q"];
    [given([self.mockPlugin getContentCustomDimension8]) willReturn:@"r"];
    [given([self.mockPlugin getContentCustomDimension9]) willReturn:@"s"];
    [given([self.mockPlugin getContentCustomDimension10]) willReturn:@"t"];
    [given([self.mockPlugin getAdPosition]) willReturn:@"u"];
    [given([self.mockPlugin getAdPlayhead]) willReturn:@8];
    [given([self.mockPlugin getAdDuration]) willReturn:@9];
    [given([self.mockPlugin getAdBitrate]) willReturn:@10];
    [given([self.mockPlugin getAdTitle]) willReturn:@"w"];
    [given([self.mockPlugin getAdResource]) willReturn:@"x"];
    [given([self.mockPlugin getAdPlayerVersion]) willReturn:@"y"];
    [given([self.mockPlugin getAdMetadata]) willReturn:@"z"];
    [given([self.mockPlugin getAdAdapterVersion]) willReturn:@"aa"];
    [given([self.mockPlugin getPluginInfo]) willReturn:@"ab"];
    [given([self.mockPlugin getIsp]) willReturn:@"ac"];
    [given([self.mockPlugin getConnectionType]) willReturn:@"ad"];
    [given([self.mockPlugin getIp]) willReturn:@"ae"];
    [given([self.mockPlugin getDeviceCode]) willReturn:@"af"];
    [given([self.mockPlugin getAccountCode]) willReturn:@"agah"];
    [given([self.mockPlugin getUsername]) willReturn:@"ai"];
    [given([self.mockPlugin getPreloadDuration]) willReturn:@11];
    [given([self.mockPlugin getJoinDuration]) willReturn:@12];
    [given([self.mockPlugin getBufferDuration]) willReturn:@13];
    [given([self.mockPlugin getSeekDuration]) willReturn:@14];
    [given([self.mockPlugin getPauseDuration]) willReturn:@15];
    [given([self.mockPlugin getAdJoinDuration]) willReturn:@16];
    [given([self.mockPlugin getAdBufferDuration]) willReturn:@17];
    [given([self.mockPlugin getAdPauseDuration]) willReturn:@18];
    [given([self.mockPlugin getAdTotalDuration]) willReturn:@19];
    [given([self.mockPlugin getNodeHost]) willReturn:@"aj"];
    [given([self.mockPlugin getNodeType]) willReturn:@"ak"];
    [given([self.mockPlugin getNodeTypeString]) willReturn:@"al"];
    [given([self.mockPlugin getVideoMetrics]) willReturn:@"{\"key\":\"value\"}"];
    [given([self.mockPlugin getSessionMetrics]) willReturn:@"{\"value\":\"key\"}"];
}

- (void)testBuildParams {
    NSDictionary * params = [self.builder buildParams:nil forService:YouboraServiceJoin];
    
    XCTAssertEqualObjects(@"12", params[@"joinDuration"]);
}

- (void)testParamsFetchedFromPlugin {
    NSDictionary * params = [self.builder fetchParams:nil paramList:ALL_PARAMS onlyDifferent:false];
    
    XCTAssertEqualObjects(@"1", params[@"playhead"]);
    XCTAssertEqualObjects(@"2", params[@"playrate"]);
    XCTAssertEqualObjects(@"3", params[@"fps"]);
    XCTAssertEqualObjects(@"4", params[@"droppedFrames"]);
    XCTAssertEqualObjects(@"5", params[@"mediaDuration"]);
    XCTAssertEqualObjects(@"6", params[@"bitrate"]);
    XCTAssertEqualObjects(@"7", params[@"throughput"]);
    XCTAssertEqualObjects(@"a", params[@"rendition"]);
    XCTAssertEqualObjects(@"b", params[@"title"]);
    XCTAssertEqualObjects(@"c", params[@"title2"]);
    XCTAssertEqualObjects(@"true", params[@"live"]);
    XCTAssertEqualObjects(@"d", params[@"mediaResource"]);
    XCTAssertEqualObjects(@"e", params[@"transactionCode"]);
    XCTAssertEqualObjects(@"f", params[@"properties"]);
    XCTAssertEqualObjects(@"g", params[@"playerVersion"]);
    XCTAssertEqualObjects(@"h", params[@"player"]);
    XCTAssertEqualObjects(@"i", params[@"cdn"]);
    XCTAssertEqualObjects(@"j", params[@"pluginVersion"]);
    XCTAssertEqualObjects(@"j", params[@"param1"]);
    XCTAssertEqualObjects(@"l", params[@"param2"]);
    XCTAssertEqualObjects(@"m", params[@"param3"]);
    XCTAssertEqualObjects(@"n", params[@"param4"]);
    XCTAssertEqualObjects(@"o", params[@"param5"]);
    XCTAssertEqualObjects(@"p", params[@"param6"]);
    XCTAssertEqualObjects(@"q", params[@"param7"]);
    XCTAssertEqualObjects(@"r", params[@"param8"]);
    XCTAssertEqualObjects(@"s", params[@"param9"]);
    XCTAssertEqualObjects(@"t", params[@"param10"]);
    XCTAssertEqualObjects(@"u", params[@"adPosition"]);
    XCTAssertEqualObjects(@"8", params[@"adPlayhead"]);
    XCTAssertEqualObjects(@"9", params[@"adDuration"]);
    XCTAssertEqualObjects(@"10", params[@"adBitrate"]);
    XCTAssertEqualObjects(@"w", params[@"adTitle"]);
    XCTAssertEqualObjects(@"x", params[@"adResource"]);
    XCTAssertEqualObjects(@"y", params[@"adPlayerVersion"]);
    XCTAssertEqualObjects(@"z", params[@"adProperties"]);
    XCTAssertEqualObjects(@"aa", params[@"adAdapterVersion"]);
    XCTAssertEqualObjects(@"ab", params[@"pluginInfo"]);
    XCTAssertEqualObjects(@"ac", params[@"isp"]);
    XCTAssertEqualObjects(@"ad", params[@"connectionType"]);
    XCTAssertEqualObjects(@"ae", params[@"ip"]);
    XCTAssertEqualObjects(@"af", params[@"deviceCode"]);
    XCTAssertEqualObjects(@"agah", params[@"system"]);
    XCTAssertEqualObjects(@"agah", params[@"accountCode"]);
    XCTAssertEqualObjects(@"ai", params[@"username"]);
    XCTAssertEqualObjects(@"11", params[@"preloadDuration"]);
    XCTAssertEqualObjects(@"12", params[@"joinDuration"]);
    XCTAssertEqualObjects(@"13", params[@"bufferDuration"]);
    XCTAssertEqualObjects(@"14", params[@"seekDuration"]);
    XCTAssertEqualObjects(@"15", params[@"pauseDuration"]);
    XCTAssertEqualObjects(@"16", params[@"adJoinDuration"]);
    XCTAssertEqualObjects(@"17", params[@"adBufferDuration"]);
    XCTAssertEqualObjects(@"18", params[@"adPauseDuration"]);
    XCTAssertEqualObjects(@"19", params[@"adTotalDuration"]);
    XCTAssertEqualObjects(@"aj", params[@"nodeHost"]);
    XCTAssertEqualObjects(@"ak", params[@"nodeType"]);
    XCTAssertEqualObjects(@"al", params[@"nodeTypeString"]);
    XCTAssertEqualObjects(@"{\"key\":\"value\"}", params[@"metrics"]);
    XCTAssertEqualObjects(@"{\"value\":\"key\"}", params[@"sessionMetrics"]);
    
}

- (void)testAdNumber {
    // Prerolls
    [given([self.mockPlugin getAdPosition]) willReturn:@"pre"];
    
    for (int i = 1; i <= 10; i++) {
        NSLog(@"i: %@", @(i));
        XCTAssertEqualObjects(@(i).stringValue, [self.builder getNewAdNumber]);
        [self.builder fetchParams:nil paramList:@[@"adPosition"] onlyDifferent:false];
    }
    
    // Midrolls
    [given([self.mockPlugin getAdPosition]) willReturn:@"mid"];

    for (int i = 1; i <= 10; i++) {
        XCTAssertEqualObjects(@(i).stringValue, [self.builder getNewAdNumber]);
        [self.builder fetchParams:nil paramList:@[@"adPosition"] onlyDifferent:false];
    }

    // Postrolls
    [given([self.mockPlugin getAdPosition]) willReturn:@"post"];
    
    for (int i = 1; i <= 10; i++) {
        XCTAssertEqualObjects(@(i).stringValue, [self.builder getNewAdNumber]);
        [self.builder fetchParams:nil paramList:@[@"adPosition"] onlyDifferent:false];
    }
}

- (void)testInformedParamsAreNotOverwritten {
    NSDictionary * params = @{@"playhead":@"informedPlayhead",
                              @"playrate":@"informedPlayrate",
                              @"nodeTypeString":@"informedNodeTypeString"};
    
    params = [self.builder fetchParams:params paramList:ALL_PARAMS onlyDifferent:false];
    
    XCTAssertEqualObjects(@"informedPlayhead", params[@"playhead"]);
    XCTAssertEqualObjects(@"informedPlayrate", params[@"playrate"]);
    XCTAssertEqualObjects(@"informedNodeTypeString", params[@"nodeTypeString"]);
}

- (void)testChangedEntities {
    [self.builder fetchParams:nil paramList:ALL_PARAMS onlyDifferent:false];
    
    NSDictionary * params = [self.builder getChangedEntitites];
    
    XCTAssertEqual(0, params.count);
    
    [given([self.mockPlugin getResource]) willReturn:@"newResource"];
    [given([self.mockPlugin getDuration]) willReturn:@234];
    
    params = [self.builder getChangedEntitites];
    
    XCTAssertEqual(2, params.count);
    
    XCTAssertEqualObjects(@"newResource", params[@"mediaResource"]);
    XCTAssertEqualObjects(@"234", params[@"mediaDuration"]);
}

@end
