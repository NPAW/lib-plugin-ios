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
#import "YouboraLib/YouboraLib-Swift.h"

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
        ALL_PARAMS = @[YBConstantsRequest.playhead, YBConstantsRequest.playrate, YBConstantsRequest.fps, YBConstantsRequest.droppedFrames,
                       YBConstantsRequest.mediaDuration, YBConstantsRequest.bitrate, YBConstantsRequest.throughput, YBConstantsRequest.rendition, YBConstantsRequest.title, YBConstantsRequest.title2, YBConstantsRequest.live,
                       YBConstantsRequest.mediaResource, YBConstantsRequest.transactionCode, YBConstantsRequest.properties, YBConstantsRequest.playerVersion, YBConstantsRequest.player, YBConstantsRequest.cdn,
                       YBConstantsRequest.pluginVersion, YBConstantsRequest.param1, YBConstantsRequest.param2, YBConstantsRequest.param3, YBConstantsRequest.param4, YBConstantsRequest.param5, YBConstantsRequest.param6,
                       YBConstantsRequest.param7, YBConstantsRequest.param8, YBConstantsRequest.param9, YBConstantsRequest.param10, YBConstantsRequest.position, YBConstantsRequest.adPlayhead, YBConstantsRequest.adDuration,
                       YBConstantsRequest.adBitrate, YBConstantsRequest.adTitle, YBConstantsRequest.adResource, YBConstantsRequest.adPlayerVersion, YBConstantsRequest.adProperties,
                       YBConstantsRequest.adAdapterVersion, YBConstantsRequest.pluginInfo, YBConstantsRequest.isp, YBConstantsRequest.connectionType, YBConstantsRequest.ip, YBConstantsRequest.deviceCode,
                       YBConstantsRequest.system, YBConstantsRequest.accountCode, YBConstantsRequest.username, YBConstantsRequest.preloadDuration, YBConstantsRequest.joinDuration,
                       YBConstantsRequest.bufferDuration, YBConstantsRequest.seekDuration, YBConstantsRequest.pauseDuration, YBConstantsRequest.adJoinDuration,
                       YBConstantsRequest.adBufferDuration, YBConstantsRequest.adPauseDuration, YBConstantsRequest.adTotalDuration, YBConstantsRequest.nodeHost, YBConstantsRequest.nodeType,
                       YBConstantsRequest.nodeTypeString, YBConstantsRequest.metrics, YBConstantsRequest.sessionMetrics, YBConstantsRequest.adCreativeId, YBConstantsRequest.adProvider, YBConstantsRequest.parentId, YBConstantsRequest.totalBytes, YBConstantsRequest.linkedViewId];
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
    [given([self.mockPlugin getOriginalResource]) willReturn:@"d"];
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
    [given([self.mockPlugin getAdProvider]) willReturn:@"am"];
    [given([self.mockPlugin getAdCreativeId]) willReturn:@"an"];
    [given([self.mockPlugin getVideoMetrics]) willReturn:@"{\"key\":\"value\"}"];
    [given([self.mockPlugin getSessionMetrics]) willReturn:@"{\"value\":\"key\"}"];
    [given([self.mockPlugin getParentId]) willReturn:@"ao"];
    [given([self.mockPlugin getLinkedViewId]) willReturn:@"ap"];
    [given([self.mockPlugin getTotalBytes]) willReturn:@1000];
}

- (void)testBuildParams {
    NSDictionary * params = [self.builder buildParams:nil forService: YBConstantsYouboraService.join];
    
    XCTAssertEqualObjects(@"12", params[YBConstantsRequest.joinDuration]);
}

- (void)testParamsFetchedFromPlugin {
    NSDictionary * params = [self.builder fetchParams:nil paramList:ALL_PARAMS onlyDifferent:false];
    
    XCTAssertEqualObjects(@"1", params[YBConstantsRequest.playhead]);
    XCTAssertEqualObjects(@"2", params[YBConstantsRequest.playrate]);
    XCTAssertEqualObjects(@"3", params[YBConstantsRequest.fps]);
    XCTAssertEqualObjects(@"4", params[YBConstantsRequest.droppedFrames]);
    XCTAssertEqualObjects(@"5", params[YBConstantsRequest.mediaDuration]);
    XCTAssertEqualObjects(@"6", params[YBConstantsRequest.bitrate]);
    XCTAssertEqualObjects(@"7", params[YBConstantsRequest.throughput]);
    XCTAssertEqualObjects(@"a", params[YBConstantsRequest.rendition]);
    XCTAssertEqualObjects(@"b", params[YBConstantsRequest.title]);
    XCTAssertEqualObjects(@"c", params[YBConstantsRequest.title2]);
    XCTAssertEqualObjects(@"true", params[YBConstantsRequest.live]);
    XCTAssertEqualObjects(@"d", params[YBConstantsRequest.mediaResource]);
    XCTAssertEqualObjects(@"e", params[YBConstantsRequest.transactionCode]);
    XCTAssertEqualObjects(@"f", params[YBConstantsRequest.properties]);
    XCTAssertEqualObjects(@"g", params[YBConstantsRequest.playerVersion]);
    XCTAssertEqualObjects(@"h", params[YBConstantsRequest.player]);
    XCTAssertEqualObjects(@"i", params[YBConstantsRequest.cdn]);
    XCTAssertEqualObjects(@"j", params[YBConstantsRequest.pluginVersion]);
    XCTAssertEqualObjects(@"j", params[YBConstantsRequest.param1]);
    XCTAssertEqualObjects(@"l", params[YBConstantsRequest.param2]);
    XCTAssertEqualObjects(@"m", params[YBConstantsRequest.param3]);
    XCTAssertEqualObjects(@"n", params[YBConstantsRequest.param4]);
    XCTAssertEqualObjects(@"o", params[YBConstantsRequest.param5]);
    XCTAssertEqualObjects(@"p", params[YBConstantsRequest.param6]);
    XCTAssertEqualObjects(@"q", params[YBConstantsRequest.param7]);
    XCTAssertEqualObjects(@"r", params[YBConstantsRequest.param8]);
    XCTAssertEqualObjects(@"s", params[YBConstantsRequest.param9]);
    XCTAssertEqualObjects(@"t", params[YBConstantsRequest.param10]);
    XCTAssertEqualObjects(@"u", params[YBConstantsRequest.position]);
    XCTAssertEqualObjects(@"8", params[YBConstantsRequest.adPlayhead]);
    XCTAssertEqualObjects(@"9", params[YBConstantsRequest.adDuration]);
    XCTAssertEqualObjects(@"10", params[YBConstantsRequest.adBitrate]);
    XCTAssertEqualObjects(@"w", params[YBConstantsRequest.adTitle]);
    XCTAssertEqualObjects(@"x", params[YBConstantsRequest.adResource]);
    XCTAssertEqualObjects(@"y", params[YBConstantsRequest.adPlayerVersion]);
    XCTAssertEqualObjects(@"z", params[YBConstantsRequest.adProperties]);
    XCTAssertEqualObjects(@"aa", params[YBConstantsRequest.adAdapterVersion]);
    XCTAssertEqualObjects(@"ab", params[YBConstantsRequest.pluginInfo]);
    XCTAssertEqualObjects(@"ac", params[YBConstantsRequest.isp]);
    XCTAssertEqualObjects(@"ad", params[YBConstantsRequest.connectionType]);
    XCTAssertEqualObjects(@"ae", params[YBConstantsRequest.ip]);
    XCTAssertEqualObjects(@"af", params[YBConstantsRequest.deviceCode]);
    XCTAssertEqualObjects(@"agah", params[YBConstantsRequest.system]);
    XCTAssertEqualObjects(@"agah", params[YBConstantsRequest.accountCode]);
    XCTAssertEqualObjects(@"ai", params[YBConstantsRequest.username]);
    XCTAssertEqualObjects(@"11", params[YBConstantsRequest.preloadDuration]);
    XCTAssertEqualObjects(@"12", params[YBConstantsRequest.joinDuration]);
    XCTAssertEqualObjects(@"13", params[YBConstantsRequest.bufferDuration]);
    XCTAssertEqualObjects(@"14", params[YBConstantsRequest.seekDuration]);
    XCTAssertEqualObjects(@"15", params[YBConstantsRequest.pauseDuration]);
    XCTAssertEqualObjects(@"16", params[YBConstantsRequest.adJoinDuration]);
    XCTAssertEqualObjects(@"17", params[YBConstantsRequest.adBufferDuration]);
    XCTAssertEqualObjects(@"18", params[YBConstantsRequest.adPauseDuration]);
    XCTAssertEqualObjects(@"19", params[YBConstantsRequest.adTotalDuration]);
    XCTAssertEqualObjects(@"aj", params[YBConstantsRequest.nodeHost]);
    XCTAssertEqualObjects(@"ak", params[YBConstantsRequest.nodeType]);
    XCTAssertEqualObjects(@"al", params[YBConstantsRequest.nodeTypeString]);
    XCTAssertEqualObjects(@"am", params[YBConstantsRequest.adProvider]);
    XCTAssertEqualObjects(@"an", params[YBConstantsRequest.adCreativeId]);
    XCTAssertEqualObjects(@"{\"key\":\"value\"}", params[YBConstantsRequest.metrics]);
    XCTAssertEqualObjects(@"{\"value\":\"key\"}", params[YBConstantsRequest.sessionMetrics]);
    XCTAssertEqualObjects(@"ao", params[YBConstantsRequest.parentId]);
    XCTAssertEqualObjects(@"ap", params[YBConstantsRequest.linkedViewId]);
}

- (void)testAdNumber {
    // Prerolls
    [given([self.mockPlugin getAdPosition]) willReturn:@"pre"];
    
    for (int i = 1; i <= 10; i++) {
        NSLog(@"i: %@", @(i));
        XCTAssertEqualObjects(@(i).stringValue, [self.builder getNewAdNumber]);
        [self.builder fetchParams:nil paramList:@[YBConstantsRequest.position] onlyDifferent:false];
    }
    
    // Midrolls
    [given([self.mockPlugin getAdPosition]) willReturn:@"mid"];

    for (int i = 1; i <= 10; i++) {
        XCTAssertEqualObjects(@(i).stringValue, [self.builder getNewAdNumber]);
        [self.builder fetchParams:nil paramList:@[YBConstantsRequest.position] onlyDifferent:false];
    }

    // Postrolls
    [given([self.mockPlugin getAdPosition]) willReturn:@"post"];
    
    for (int i = 1; i <= 10; i++) {
        XCTAssertEqualObjects(@(i).stringValue, [self.builder getNewAdNumber]);
        [self.builder fetchParams:nil paramList:@[YBConstantsRequest.position] onlyDifferent:false];
    }
}

-(void)testStop {
    
}

- (void)testInformedParamsAreNotOverwritten {
    NSDictionary * params = @{YBConstantsRequest.playhead:@"informedPlayhead",
                              YBConstantsRequest.playrate:@"informedPlayrate",
                              YBConstantsRequest.nodeTypeString:@"informedNodeTypeString"};
    
    params = [self.builder fetchParams:params paramList:ALL_PARAMS onlyDifferent:false];
    
    XCTAssertEqualObjects(@"informedPlayhead", params[YBConstantsRequest.playhead]);
    XCTAssertEqualObjects(@"informedPlayrate", params[YBConstantsRequest.playrate]);
    XCTAssertEqualObjects(@"informedNodeTypeString", params[YBConstantsRequest.nodeTypeString]);
}

- (void)testChangedEntities {
    [self.builder fetchParams:nil paramList:ALL_PARAMS onlyDifferent:false];
    
    NSDictionary * params = [self.builder getChangedEntitites];
    
    XCTAssertEqual(0, params.count);
    
    [given([self.mockPlugin getOriginalResource]) willReturn:@"newResource"];
    [given([self.mockPlugin getDuration]) willReturn:@234];
    
    params = [self.builder getChangedEntitites];
    
    XCTAssertEqual(2, params.count);
    
    XCTAssertEqualObjects(@"newResource", params[YBConstantsRequest.mediaResource]);
    XCTAssertEqualObjects(@"234", params[YBConstantsRequest.mediaDuration]);
}

@end
