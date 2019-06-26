//
//  YBOptionsTest.m
//  YouboraLib
//
//  Created by Joan on 17/03/2017.
//  Copyright © 2017 NPAW. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "YBOptions.h"

@interface YBOptionsTest : XCTestCase

@end

@implementation YBOptionsTest

- (void)testOptions {
    YBOptions * options = [YBOptions new];
    
    XCTAssertEqualObjects(@"a-fds.youborafds01.com", options.host);
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
    XCTAssertEqual(opt.parseHls, opt2.parseHls);
    XCTAssertEqualObjects(opt.parseCdnNameHeader, opt2.parseCdnNameHeader);
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
    
    XCTAssertEqualObjects(dict[YBOPTIONS_KEY_HOST], opt.host);
}

- (void) fillOptions:(YBOptions *) opt {
    opt.enabled = false;
    opt.httpSecure = true;
    opt.host = @"host";
    opt.accountCode = @"code";
    opt.username = @"username";
    opt.parseHls = true;
    opt.parseCdnNameHeader = @"nameheader";
    opt.parseCdnNode = true;
    opt.parseCdnNodeList = [@[@"1", @"2", @"3"] mutableCopy];
    opt.networkIP = @"1.2.3.4";
    opt.networkIsp = @"isp";
    opt.networkConnectionType = @"connectiontype";
    opt.userObfuscateIp = @NO;
    opt.deviceCode = @"devicecode";
    opt.contentResource = @"resource";
    opt.contentIsLive = @YES;
    opt.contentTitle = @"title";
    opt.program = @"program";
    opt.contentDuration = @42;
    opt.contentTransactionCode = @"transactioncode";
    opt.contentBitrate = @4;
    opt.contentThroughput = @5;
    opt.contentRendition = @"rend";
    opt.contentCdn = @"cdn";
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
}

@end
