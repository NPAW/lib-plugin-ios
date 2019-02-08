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
    
    XCTAssertEqualObjects(@"nqs.nice264.com", options.host);
}

- (void)testCoding {
    YBOptions * opt = [YBOptions new];
    
    NSMutableData * data = [[NSMutableData alloc] init];
    
    NSKeyedArchiver * archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    
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
    opt.networkObfuscateIp = @NO;
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
    opt.customDimension1 = @"extra1";
    opt.customDimension2 = @"extra2";
    opt.customDimension3 = @"extra3";
    opt.customDimension4 = @"extra4";
    opt.customDimension5 = @"extra5";
    opt.customDimension6 = @"extra6";
    opt.customDimension7 = @"extra7";
    opt.customDimension8 = @"extra8";
    opt.customDimension9 = @"extra9";
    opt.customDimension10 = @"extra10";
    opt.customDimension11 = @"extra11";
    opt.customDimension12 = @"extra12";
    opt.customDimension13 = @"extra13";
    opt.customDimension14 = @"extra14";
    opt.customDimension15 = @"extra15";
    opt.customDimension16 = @"extra16";
    opt.customDimension17 = @"extra17";
    opt.customDimension18 = @"extra18";
    opt.customDimension19 = @"extra19";
    opt.customDimension20 = @"extra20";
    
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
    XCTAssertEqualObjects(opt.customDimension1, opt2.customDimension1);
    XCTAssertEqualObjects(opt.customDimension2, opt2.customDimension2);
    XCTAssertEqualObjects(opt.customDimension3, opt2.customDimension3);
    XCTAssertEqualObjects(opt.customDimension4, opt2.customDimension4);
    XCTAssertEqualObjects(opt.customDimension5, opt2.customDimension5);
    XCTAssertEqualObjects(opt.customDimension6, opt2.customDimension6);
    XCTAssertEqualObjects(opt.customDimension7, opt2.customDimension7);
    XCTAssertEqualObjects(opt.customDimension8, opt2.customDimension8);
    XCTAssertEqualObjects(opt.customDimension9, opt2.customDimension9);
    XCTAssertEqualObjects(opt.customDimension10, opt2.customDimension10);
    XCTAssertEqualObjects(opt.customDimension11, opt2.customDimension11);
    XCTAssertEqualObjects(opt.customDimension12, opt2.customDimension12);
    XCTAssertEqualObjects(opt.customDimension13, opt2.customDimension13);
    XCTAssertEqualObjects(opt.customDimension14, opt2.customDimension14);
    XCTAssertEqualObjects(opt.customDimension15, opt2.customDimension15);
    XCTAssertEqualObjects(opt.customDimension16, opt2.customDimension16);
    XCTAssertEqualObjects(opt.customDimension17, opt2.customDimension17);
    XCTAssertEqualObjects(opt.customDimension18, opt2.customDimension18);
    XCTAssertEqualObjects(opt.customDimension19, opt2.customDimension19);
    XCTAssertEqualObjects(opt.customDimension20, opt2.customDimension20);
    XCTAssertEqualObjects(opt.networkObfuscateIp, opt2.networkObfuscateIp);
}

@end
