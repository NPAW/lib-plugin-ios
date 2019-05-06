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
    
    /*XCTAssertEqualObjects(opt.contentCustomDimension1, opt2.customDimension1);
    XCTAssertEqualObjects(opt.contentCustomDimension2, opt2.customDimension2);
    XCTAssertEqualObjects(opt.contentCustomDimension3, opt2.customDimension3);
    XCTAssertEqualObjects(opt.contentCustomDimension4, opt2.customDimension4);
    XCTAssertEqualObjects(opt.contentCustomDimension5, opt2.customDimension5);
    XCTAssertEqualObjects(opt.contentCustomDimension6, opt2.customDimension6);
    XCTAssertEqualObjects(opt.contentCustomDimension7, opt2.customDimension7);
    XCTAssertEqualObjects(opt.contentCustomDimension8, opt2.customDimension8);
    XCTAssertEqualObjects(opt.contentCustomDimension9, opt2.customDimension9);
    XCTAssertEqualObjects(opt.contentCustomDimension10, opt2.customDimension10);
    XCTAssertEqualObjects(opt.contentCustomDimension11, opt2.customDimension11);
    XCTAssertEqualObjects(opt.contentCustomDimension12, opt2.customDimension12);
    XCTAssertEqualObjects(opt.contentCustomDimension13, opt2.customDimension13);
    XCTAssertEqualObjects(opt.contentCustomDimension14, opt2.customDimension14);
    XCTAssertEqualObjects(opt.contentCustomDimension15, opt2.customDimension15);
    XCTAssertEqualObjects(opt.contentCustomDimension16, opt2.customDimension16);
    XCTAssertEqualObjects(opt.contentCustomDimension17, opt2.customDimension17);
    XCTAssertEqualObjects(opt.contentCustomDimension18, opt2.customDimension18);
    XCTAssertEqualObjects(opt.contentCustomDimension19, opt2.customDimension19);
    XCTAssertEqualObjects(opt.contentCustomDimension20, opt2.customDimension20);*/
    
    //XCTAssertEqualObjects(opt.userObfuscateIp, opt2.networkObfuscateIp);
}

@end
