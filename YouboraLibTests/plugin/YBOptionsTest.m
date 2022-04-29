//
//  YBOptionsTest.m
//  YouboraLib
//
//  Created by Joan on 17/03/2017.
//  Copyright © 2017 NPAW. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "YBOptions.h"
#import "YouboraLib/YouboraLib-Swift.h"

@interface YBOptionsTest : XCTestCase

@end

@implementation YBOptionsTest

- (void)testOptions {
    YBOptions * options = [YBOptions new];
    
    XCTAssertEqualObjects(@"a-fds.youborafds01.com", options.host);
}

-(void)testParser {
    YBOptions * options = [YBOptions new];
    options.parseHls = true;
    
    XCTAssertEqual(options.parseResource, true);
    
    options.parseResource = false;
    
    XCTAssertEqual(options.parseResource, false);
    
    options.parseHls = false;
    options.parseLocationHeader = true;
    options.parseDash = false;
    
    XCTAssertEqual(options.parseResource, true);
    options.parseResource = false;
    options.parseResource = true;
    XCTAssertEqual(options.parseResource, true);
}

-(void)testInvalidContentStreamingProtocol {
    YBOptions * options = [YBOptions new];
    XCTAssertNil(options.contentStreamingProtocol);
    
    options.contentStreamingProtocol = @"test";
    
    XCTAssertNil(options.contentStreamingProtocol);
}

-(void)testValidContentStreamingProtocol {
    YBOptions * options = [YBOptions new];
    XCTAssertNil(options.contentStreamingProtocol);
    
    options.contentStreamingProtocol = YBConstantsStreamProtocol.dash;
    
    XCTAssertTrue([options.contentStreamingProtocol isEqualToString:YBConstantsStreamProtocol.dash]);
}

-(void)testInvalidContentTransportFormat {
    YBOptions * options = [YBOptions new];
    XCTAssertNil(options.contentTransportFormat);
    
    options.contentTransportFormat = @"test";
    
    XCTAssertNil(options.contentTransportFormat);
}

-(void)testValidContentTransportFormat {
    YBOptions * options = [YBOptions new];
    XCTAssertNil(options.contentTransportFormat);
    
    options.contentTransportFormat = YBConstantsTransportFormat.hlsFmp4;
    
    XCTAssertTrue([options.contentTransportFormat isEqualToString:YBConstantsTransportFormat.hlsFmp4]);
}


- (void) fillOptions:(YBOptions *) opt {
    opt.enabled = false;
    opt.httpSecure = true;
    opt.host = @"host";
    opt.accountCode = @"code";
    opt.username = YBConstantsRequest.username;
    opt.parseResource = true;
    opt.parseLocationHeader = true;
    opt.parseHls = true;
    opt.parseDash = true;
    opt.parseCdnNameHeader = @"nameheader";
    opt.parseCdnNodeHeader = @"nodeheader";
    opt.parseCdnNode = true;
    opt.parseCdnNodeList = [@[@"1", @"2", @"3"] mutableCopy];
    opt.networkIP = @"1.2.3.4";
    opt.networkIsp = YBConstantsRequest.isp;
    opt.networkConnectionType = YBConstantsRequest.connectionType;
    opt.userObfuscateIp = @NO;
    opt.deviceCode = YBConstantsRequest.deviceCode;
    opt.contentResource = @"resource";
    opt.contentIsLive = @YES;
    opt.contentTitle = YBConstantsRequest.title;
    opt.program = @"program";
    opt.contentDuration = @42;
    opt.contentTransactionCode = YBConstantsRequest.transactionCode;
    opt.contentBitrate = @4;
    opt.contentThroughput = @5;
    opt.contentRendition = @"rend";
    opt.contentCdn = YBConstantsRequest.cdn;
    opt.contentFps = @12;
    opt.contentMetadata = @{@"metakey":@"metavalue"};
    opt.adMetadata = @{@"admetakey":@"admetavalue"};
    opt.contentCustomDimension1 = @"extra1";
    opt.contentCustomDimension2 = @"extra2";
    opt.contentCustomDimension3 = @"extra3";
    opt.contentCustomDimension4 = @"extra4";
    opt.contentCustomDimension5 = @"extra5";
    opt.contentCustomDimension6 = @"extra6";
    opt.contentCustomDimension7 = @"extra7";
    opt.contentCustomDimension8 = @"extra8";
    opt.contentCustomDimension9 = @"extra9";
    opt.contentCustomDimension10 = @"extra10";
    opt.contentCustomDimension11 = @"extra11";
    opt.contentCustomDimension12 = @"extra12";
    opt.contentCustomDimension13 = @"extra13";
    opt.contentCustomDimension14 = @"extra14";
    opt.contentCustomDimension15 = @"extra15";
    opt.contentCustomDimension16 = @"extra16";
    opt.contentCustomDimension17 = @"extra17";
    opt.contentCustomDimension18 = @"extra18";
    opt.contentCustomDimension19 = @"extra19";
    opt.contentCustomDimension20 = @"extra20";
    opt.anonymousUser = @"anonymousUser";
    opt.offline = true;
    opt.isInfinity = @(true);
    opt.autoDetectBackground = true;
    opt.forceInit = true;
    opt.userType = @"userType";
    opt.userEmail = @"userEmail";
    opt.experimentIds = @[@"one",@"two"];
    opt.smartswitchConfigCode = @"smartswitchConfigCode";
    opt.smartswitchGroupCode = @"smartswitchGroupCode";
    opt.smartswitchContractCode = @"smartswitchContractCode";
    opt.deviceModel = @"deviceModel";
    opt.deviceBrand = @"deviceBrand";
    opt.deviceType = @"deviceType";
    opt.deviceName = @"deviceName";
    opt.deviceOsName = @"deviceOsName";
    opt.deviceOsVersion = @"deviceOsVersion";
    opt.deviceIsAnonymous = true;
    opt.deviceUUID = @"deviceUUID";
    opt.contentTitle = @"contentTitle";
    opt.contentStreamingProtocol = YBConstantsStreamProtocol.dash;
    opt.contentMetrics = @{@"contentMetrics":@"contentMetrics"};
    opt.contentIsLiveNoSeek = @(true);
    opt.contentIsLiveNoMonitor = @(true);
    opt.contentPackage = @"contentPackage";
    opt.contentSaga = @"contentSaga";
    opt.contentTvShow = @"contentTvShow";
    opt.contentSeason = @"contentSeason";
    opt.contentEpisodeTitle = @"contentEpisodeTitle";
    opt.contentChannel = @"contentChannel";
    opt.contentId = @"contentId";
    opt.contentImdbId = @"contentImdbId";
    opt.contentGracenoteId = @"contentGracenoteId";
    opt.contentType = @"contentType";
    opt.contentGenre = @"contentGenre";
    opt.contentLanguage = @"contentLanguage";
    opt.contentSubtitles = @"contentSubtitles";
    opt.contentContractedResolution = @"contentContractedResolution";
    opt.contentCost = @"contentCost";
    opt.contentPrice = @"contentPrice";
    opt.contentPlaybackType = @"contentPlaybackType";
    opt.contentDrm = @"contentDrm";
    opt.contentEncodingVideoCodec = @"contentEncodingVideoCodec";
    opt.contentEncodingAudioCodec = @"contentEncodingAudioCodec";
    opt.contentEncodingCodecSettings = @{@"contentEncodingCodecSettings":@"contentEncodingCodecSettings"};
    opt.contentEncodingCodecProfile = @"contentEncodingCodecProfile";
    opt.contentEncodingContainerFormat = @"contentEncodingContainerFormat";
    opt.appName = @"appName";
    opt.sessionMetrics = @{
        @"metric1":@"value1",
        @"metric2":@"value2",
    };
    opt.pendingMetadata = @[@"value1",@"value2"];
    opt.linkedViewId = @"linkedViewId";
    opt.waitForMetadata = true;
    opt.adCustomDimension1 = @"adCustomDimension1";
    opt.adCustomDimension2 = @"adCustomDimension2";
    opt.adCustomDimension3 = @"adCustomDimension3";
    opt.adCustomDimension4 = @"adCustomDimension4";
    opt.adCustomDimension5 = @"adCustomDimension5";
    opt.adCustomDimension6 = @"adCustomDimension6";
    opt.adCustomDimension7 = @"adCustomDimension7";
    opt.adCustomDimension8 = @"adCustomDimension8";
    opt.adCustomDimension9 = @"adCustomDimension9";
    opt.adCustomDimension10 = @"adCustomDimension10";
    opt.appReleaseVersion = @"appReleaseVersion";
    opt.adProvider = @"adProvider";
    opt.adCreativeId = @"adCreativeId";
    opt.adGivenAds = [NSNumber numberWithInt:2];
    opt.adBreaksTime = @[@"Value1",@"Value2"];
    opt.adResource = @"adResource";
    opt.adTitle = @"adTitle";
    opt.adCampaign = @"adCampaign";
    opt.adGivenBreaks = [NSNumber numberWithInt:2];
    opt.adExpectedBreaks = [NSNumber numberWithInt:3];
    opt.adExpectedPattern = @{
        YBOptionKeys.adPositionMid: @[
                [NSNumber numberWithInt:2],
                [NSNumber numberWithInt:3]
        ]
    };
    opt.adsAfterStop = [NSNumber numberWithInt:2];
}


- (void)testCoding {
    YBOptions * opt = [YBOptions new];
    
    NSMutableData * data = [[NSMutableData alloc] init];
    
    NSKeyedArchiver * archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    
    [self fillOptions:opt];
    
    [opt encodeWithCoder:archiver];
    
    [NSKeyedArchiver archiveRootObject:opt toFile:@"archive"];
    
    YBOptions * opt2 = [NSKeyedUnarchiver unarchiveObjectWithFile:@"archive"];
    
    XCTAssertEqual(opt.enabled, opt2.enabled);
    XCTAssertEqual(opt.httpSecure, opt2.httpSecure);
    XCTAssertEqualObjects(opt.host, opt2.host);
    XCTAssertEqualObjects(opt.accountCode, opt2.accountCode);
    XCTAssertEqualObjects(opt.username, opt2.username);
    XCTAssertEqual(opt.parseResource, opt2.parseResource);
    XCTAssertEqual(opt.parseLocationHeader, opt2.parseLocationHeader);
    XCTAssertEqual(opt.parseHls, opt2.parseHls);
    XCTAssertEqual(opt.parseDash, opt2.parseDash);
    XCTAssertEqualObjects(opt.parseCdnNameHeader, opt2.parseCdnNameHeader);
    XCTAssertEqualObjects(opt.parseCdnNodeHeader, opt2.parseCdnNodeHeader);
    XCTAssertEqual(opt.parseCdnNode, opt2.parseCdnNode);
    XCTAssertEqualObjects(opt.parseCdnNodeList, opt2.parseCdnNodeList);
    XCTAssertEqualObjects(opt.networkIP, opt2.networkIP);
    XCTAssertEqualObjects(opt.networkIsp, opt2.networkIsp);
    XCTAssertEqualObjects(opt.networkConnectionType, opt2.networkConnectionType);
    XCTAssertEqualObjects(opt.deviceCode, opt2.deviceCode);
    XCTAssertEqualObjects(opt.contentResource, opt2.contentResource);
    XCTAssertEqualObjects(opt.contentIsLive, opt2.contentIsLive);
    XCTAssertEqualObjects(opt.contentTitle, opt2.contentTitle);
    XCTAssertEqualObjects(opt.program, opt2.program);
    XCTAssertEqualObjects(opt.contentDuration, opt2.contentDuration);
    XCTAssertEqualObjects(opt.contentTransactionCode, opt2.contentTransactionCode);
    XCTAssertEqualObjects(opt.contentBitrate, opt2.contentBitrate);
    XCTAssertEqualObjects(opt.contentThroughput, opt2.contentThroughput);
    XCTAssertEqualObjects(opt.contentRendition, opt2.contentRendition);
    XCTAssertEqualObjects(opt.contentCdn, opt2.contentCdn);
    XCTAssertEqualObjects(opt.contentFps, opt2.contentFps);
    XCTAssertEqualObjects(opt.contentMetadata, opt2.contentMetadata);
    XCTAssertEqualObjects(opt.adMetadata, opt2.adMetadata);
    XCTAssertEqualObjects(opt.adProvider, opt2.adProvider);
    XCTAssertEqualObjects(opt.adCreativeId, opt2.adCreativeId);
    XCTAssertEqualObjects(opt.contentCustomDimension1, opt2.contentCustomDimension1);
    XCTAssertEqualObjects(opt.contentCustomDimension2, opt2.contentCustomDimension2);
    XCTAssertEqualObjects(opt.contentCustomDimension3, opt2.contentCustomDimension3);
    XCTAssertEqualObjects(opt.contentCustomDimension4, opt2.contentCustomDimension4);
    XCTAssertEqualObjects(opt.contentCustomDimension5, opt2.contentCustomDimension5);
    XCTAssertEqualObjects(opt.contentCustomDimension6, opt2.contentCustomDimension6);
    XCTAssertEqualObjects(opt.contentCustomDimension7, opt2.contentCustomDimension7);
    XCTAssertEqualObjects(opt.contentCustomDimension8, opt2.contentCustomDimension8);
    XCTAssertEqualObjects(opt.contentCustomDimension9, opt2.contentCustomDimension9);
    XCTAssertEqualObjects(opt.contentCustomDimension10, opt2.contentCustomDimension10);
    XCTAssertEqualObjects(opt.contentCustomDimension11, opt2.contentCustomDimension11);
    XCTAssertEqualObjects(opt.contentCustomDimension12, opt2.contentCustomDimension12);
    XCTAssertEqualObjects(opt.contentCustomDimension13, opt2.contentCustomDimension13);
    XCTAssertEqualObjects(opt.contentCustomDimension14, opt2.contentCustomDimension14);
    XCTAssertEqualObjects(opt.contentCustomDimension15, opt2.contentCustomDimension15);
    XCTAssertEqualObjects(opt.contentCustomDimension16, opt2.contentCustomDimension16);
    XCTAssertEqualObjects(opt.contentCustomDimension17, opt2.contentCustomDimension17);
    XCTAssertEqualObjects(opt.contentCustomDimension18, opt2.contentCustomDimension18);
    XCTAssertEqualObjects(opt.contentCustomDimension19, opt2.contentCustomDimension19);
    XCTAssertEqualObjects(opt.contentCustomDimension20, opt2.contentCustomDimension20);
    XCTAssertEqualObjects(opt.adCustomDimension1, opt2.adCustomDimension1);
    XCTAssertEqualObjects(opt.adCustomDimension2, opt2.adCustomDimension2);
    XCTAssertEqualObjects(opt.adCustomDimension3, opt2.adCustomDimension3);
    XCTAssertEqualObjects(opt.adCustomDimension4, opt2.adCustomDimension4);
    XCTAssertEqualObjects(opt.adCustomDimension5, opt2.adCustomDimension5);
    XCTAssertEqualObjects(opt.adCustomDimension6, opt2.adCustomDimension6);
    XCTAssertEqualObjects(opt.adCustomDimension7, opt2.adCustomDimension7);
    XCTAssertEqualObjects(opt.adCustomDimension8, opt2.adCustomDimension8);
    XCTAssertEqualObjects(opt.adCustomDimension9, opt2.adCustomDimension9);
    XCTAssertEqualObjects(opt.adCustomDimension10, opt2.adCustomDimension10);
    XCTAssertEqualObjects(opt.userObfuscateIp, opt2.userObfuscateIp);
    XCTAssertEqualObjects(opt.anonymousUser, opt2.anonymousUser);
    XCTAssertEqual(opt.offline, opt2.offline);
    XCTAssertEqualObjects(opt.isInfinity, opt2.isInfinity);
    XCTAssertEqual(opt.autoDetectBackground, opt2.autoDetectBackground);
    XCTAssertEqual(opt.forceInit, opt2.forceInit);
    XCTAssertEqualObjects(opt.userType, opt2.userType);
    XCTAssertEqualObjects(opt.userEmail, opt2.userEmail);
    XCTAssertEqualObjects(opt.experimentIds, opt2.experimentIds);
    XCTAssertEqualObjects(opt.smartswitchConfigCode, opt2.smartswitchConfigCode);
    XCTAssertEqualObjects(opt.smartswitchGroupCode, opt2.smartswitchGroupCode);
    XCTAssertEqualObjects(opt.smartswitchContractCode, opt2.smartswitchContractCode);
    XCTAssertEqualObjects(opt.deviceModel, opt2.deviceModel);
    XCTAssertEqualObjects(opt.deviceBrand, opt2.deviceBrand);
    XCTAssertEqualObjects(opt.deviceType, opt2.deviceType);
    XCTAssertEqualObjects(opt.deviceName, opt2.deviceName);
    XCTAssertEqualObjects(opt.deviceOsName, opt2.deviceOsName);
    XCTAssertEqualObjects(opt.deviceOsVersion, opt2.deviceOsVersion);
    XCTAssertEqual(opt.deviceIsAnonymous, opt2.deviceIsAnonymous);
    XCTAssertEqualObjects(opt.deviceUUID, opt2.deviceUUID);
    XCTAssertEqualObjects(opt.contentTitle, opt2.contentTitle);
    XCTAssertEqualObjects(opt.contentStreamingProtocol, opt2.contentStreamingProtocol);
    XCTAssertEqualObjects(opt.contentMetrics, opt2.contentMetrics);
    XCTAssertEqualObjects(opt.contentIsLiveNoSeek, opt2.contentIsLiveNoSeek);
    XCTAssertEqualObjects(opt.contentIsLiveNoMonitor, opt2.contentIsLiveNoMonitor);
    XCTAssertEqualObjects(opt.contentPackage, opt2.contentPackage);
    XCTAssertEqualObjects(opt.contentSaga, opt2.contentSaga);
    XCTAssertEqualObjects(opt.contentTvShow, opt2.contentTvShow);
    XCTAssertEqualObjects(opt.contentSeason, opt2.contentSeason);
    XCTAssertEqualObjects(opt.contentEpisodeTitle, opt2.contentEpisodeTitle);
    XCTAssertEqualObjects(opt.contentChannel, opt2.contentChannel);
    XCTAssertEqualObjects(opt.contentId, opt2.contentId);
    XCTAssertEqualObjects(opt.contentImdbId, opt2.contentImdbId);
    XCTAssertEqualObjects(opt.contentGracenoteId, opt2.contentGracenoteId);
    XCTAssertEqualObjects(opt.contentType, opt2.contentType);
    XCTAssertEqualObjects(opt.contentGenre, opt2.contentGenre);
    XCTAssertEqualObjects(opt.contentLanguage, opt2.contentLanguage);
    XCTAssertEqualObjects(opt.contentSubtitles, opt2.contentSubtitles);
    XCTAssertEqualObjects(opt.contentContractedResolution, opt2.contentContractedResolution);
    XCTAssertEqualObjects(opt.contentCost, opt2.contentCost);
    XCTAssertEqualObjects(opt.contentPrice, opt2.contentPrice);
    XCTAssertEqualObjects(opt.contentPlaybackType, opt2.contentPlaybackType);
    XCTAssertEqualObjects(opt.contentDrm, opt2.contentDrm);
    XCTAssertEqualObjects(opt.contentEncodingVideoCodec, opt2.contentEncodingVideoCodec);
    XCTAssertEqualObjects(opt.contentEncodingAudioCodec, opt2.contentEncodingAudioCodec);
    XCTAssertEqualObjects(opt.contentEncodingCodecSettings, opt2.contentEncodingCodecSettings);
    XCTAssertEqualObjects(opt.contentEncodingCodecProfile, opt2.contentEncodingCodecProfile);
    XCTAssertEqualObjects(opt.contentEncodingContainerFormat, opt2.contentEncodingContainerFormat);
    XCTAssertEqualObjects(opt.appName, opt2.appName);
    XCTAssertEqualObjects(opt.sessionMetrics, opt2.sessionMetrics);
    XCTAssertEqualObjects(opt.pendingMetadata, opt2.pendingMetadata);
    XCTAssertEqualObjects(opt.linkedViewId, opt2.linkedViewId);
    XCTAssertEqual(opt.waitForMetadata, opt2.waitForMetadata);
    XCTAssertEqualObjects(opt.appReleaseVersion, opt2.appReleaseVersion);
    XCTAssertEqualObjects(opt.adProvider, opt2.adProvider);
    XCTAssertEqualObjects(opt.adCreativeId, opt2.adCreativeId);
    XCTAssertEqualObjects(opt.adGivenAds, opt2.adGivenAds);
    XCTAssertEqualObjects(opt.adBreaksTime, opt2.adBreaksTime);
    XCTAssertEqualObjects(opt.adResource, opt2.adResource);
    XCTAssertEqualObjects(opt.adTitle, opt2.adTitle);
    XCTAssertEqualObjects(opt.adCampaign, opt2.adCampaign);
    XCTAssertEqualObjects(opt.adGivenBreaks, opt2.adGivenBreaks);
    XCTAssertEqualObjects(opt.adExpectedBreaks, opt2.adExpectedBreaks);
    XCTAssertEqualObjects(opt.adExpectedPattern, opt2.adExpectedPattern);
    XCTAssertEqualObjects(opt.adsAfterStop, opt2.adsAfterStop);
}

- (void) testDeprecations {
    YBOptions * opt = [YBOptions new];
    
    opt.contentTitle2 = @"a";
    opt.extraparam1 = @"b";
    opt.extraparam2 = @"c";
    opt.extraparam3 = @"d";
    opt.extraparam4 = @"e";
    opt.extraparam5 = @"f";
    opt.extraparam6 = @"g";
    opt.extraparam7 = @"h";
    opt.extraparam8 = @"i";
    opt.extraparam9= @"j";
    opt.extraparam10 = @"k";
    opt.extraparam11 = @"l";
    opt.extraparam12 = @"m";
    opt.extraparam13 = @"n";
    opt.extraparam14 = @"r";
    opt.extraparam15 = @"o";
    opt.extraparam16 = @"p";
    opt.extraparam17 = @"q";
    opt.extraparam18 = @"r";
    opt.extraparam19 = @"s";
    opt.extraparam20 = @"t";
    
    opt.adExtraparam1 = @"a";
    opt.adExtraparam2 = @"b";
    opt.adExtraparam3 = @"c";
    opt.adExtraparam4 = @"d";
    opt.adExtraparam5 = @"e";
    opt.adExtraparam6 = @"f";
    opt.adExtraparam7 = @"g";
    opt.adExtraparam8 = @"h";
    opt.adExtraparam9 = @"i";
    opt.adExtraparam10 = @"j";
    
    opt.networkObfuscateIp = @YES;
    
    XCTAssertEqualObjects(opt.program, @"a");
    XCTAssertEqualObjects(opt.contentCustomDimension1, @"b");
    XCTAssertEqualObjects(opt.contentCustomDimension2, @"c");
    XCTAssertEqualObjects(opt.contentCustomDimension3, @"d");
    XCTAssertEqualObjects(opt.contentCustomDimension4, @"e");
    XCTAssertEqualObjects(opt.contentCustomDimension5, @"f");
    XCTAssertEqualObjects(opt.contentCustomDimension6, @"g");
    XCTAssertEqualObjects(opt.contentCustomDimension7, @"h");
    XCTAssertEqualObjects(opt.contentCustomDimension8, @"i");
    XCTAssertEqualObjects(opt.contentCustomDimension9, @"j");
    XCTAssertEqualObjects(opt.contentCustomDimension10, @"k");
    XCTAssertEqualObjects(opt.contentCustomDimension11, @"l");
    XCTAssertEqualObjects(opt.contentCustomDimension12, @"m");
    XCTAssertEqualObjects(opt.contentCustomDimension13, @"n");
    XCTAssertEqualObjects(opt.contentCustomDimension14, @"r");
    XCTAssertEqualObjects(opt.contentCustomDimension15, @"o");
    XCTAssertEqualObjects(opt.contentCustomDimension16, @"p");
    XCTAssertEqualObjects(opt.contentCustomDimension17, @"q");
    XCTAssertEqualObjects(opt.contentCustomDimension18, @"r");
    XCTAssertEqualObjects(opt.contentCustomDimension19, @"s");
    XCTAssertEqualObjects(opt.contentCustomDimension20, @"t");
    
    XCTAssertEqualObjects(opt.adCustomDimension1, @"a");
    XCTAssertEqualObjects(opt.adCustomDimension2, @"b");
    XCTAssertEqualObjects(opt.adCustomDimension3, @"c");
    XCTAssertEqualObjects(opt.adCustomDimension4, @"d");
    XCTAssertEqualObjects(opt.adCustomDimension5, @"e");
    XCTAssertEqualObjects(opt.adCustomDimension6, @"f");
    XCTAssertEqualObjects(opt.adCustomDimension7, @"g");
    XCTAssertEqualObjects(opt.adCustomDimension8, @"h");
    XCTAssertEqualObjects(opt.adCustomDimension9, @"i");
    XCTAssertEqualObjects(opt.adCustomDimension10, @"j");
    
    XCTAssertEqualObjects(opt.userObfuscateIp, @YES);
}

- (void) testToDictionary {
    YBOptions * opt = [YBOptions new];
    [self fillOptions:opt];
    
    NSDictionary * dict = [opt toDictionary];
    
    XCTAssertEqualObjects(dict[YBOptionKeys.host], opt.host);
}

-(void)testSwitchCdn {
    YBOptions * opt = [YBOptions new];
    
    // Test default values
    XCTAssertFalse(opt.cdnSwitchHeader);
    XCTAssertEqual(opt.cdnTTL, 60);
    
    opt.cdnSwitchHeader = YES;
    opt.cdnTTL = 70;
    
    XCTAssertTrue(opt.cdnSwitchHeader);
    XCTAssertEqual(opt.cdnTTL, 70);
}

@end
