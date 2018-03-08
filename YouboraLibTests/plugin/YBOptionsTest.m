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
    opt.deviceCode = @"devicecode";
    opt.contentResource = @"resource";
    opt.contentIsLive = @YES;
    opt.contentTitle = @"title";
    opt.contentTitle2 = @"title2";
    opt.contentDuration = @42;
    opt.contentTransactionCode = @"transactioncode";
    opt.contentBitrate = @4;
    opt.contentThroughput = @5;
    opt.contentRendition = @"rend";
    opt.contentCdn = @"cdn";
    opt.contentFps = @12;
    opt.contentMetadata = @{@"metakey":@"metavalue"};
    opt.adMetadata = @{@"admetakey":@"admetavalue"};
    opt.extraparam1 = @"extra1";
    opt.extraparam2 = @"extra2";
    opt.extraparam3 = @"extra3";
    opt.extraparam4 = @"extra4";
    opt.extraparam5 = @"extra5";
    opt.extraparam6 = @"extra6";
    opt.extraparam7 = @"extra7";
    opt.extraparam8 = @"extra8";
    opt.extraparam9 = @"extra9";
    opt.extraparam10 = @"extra10";
    opt.extraparam11 = @"extra11";
    opt.extraparam12 = @"extra12";
    opt.extraparam13 = @"extra13";
    opt.extraparam14 = @"extra14";
    opt.extraparam15 = @"extra15";
    opt.extraparam16 = @"extra16";
    opt.extraparam17 = @"extra17";
    opt.extraparam18 = @"extra18";
    opt.extraparam19 = @"extra19";
    opt.extraparam20 = @"extra20";
    
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
    XCTAssertEqualObjects(opt.contentTitle2, opt2.contentTitle2);
    XCTAssertEqualObjects(opt.contentDuration, opt2.contentDuration);
    XCTAssertEqualObjects(opt.contentTransactionCode, opt2.contentTransactionCode);
    XCTAssertEqualObjects(opt.contentBitrate, opt2.contentBitrate);
    XCTAssertEqualObjects(opt.contentThroughput, opt2.contentThroughput);
    XCTAssertEqualObjects(opt.contentRendition, opt2.contentRendition);
    XCTAssertEqualObjects(opt.contentCdn, opt2.contentCdn);
    XCTAssertEqualObjects(opt.contentFps, opt2.contentFps);
    XCTAssertEqualObjects(opt.contentMetadata, opt2.contentMetadata);
    XCTAssertEqualObjects(opt.adMetadata, opt2.adMetadata);
    XCTAssertEqualObjects(opt.extraparam1, opt2.extraparam1);
    XCTAssertEqualObjects(opt.extraparam2, opt2.extraparam2);
    XCTAssertEqualObjects(opt.extraparam3, opt2.extraparam3);
    XCTAssertEqualObjects(opt.extraparam4, opt2.extraparam4);
    XCTAssertEqualObjects(opt.extraparam5, opt2.extraparam5);
    XCTAssertEqualObjects(opt.extraparam6, opt2.extraparam6);
    XCTAssertEqualObjects(opt.extraparam7, opt2.extraparam7);
    XCTAssertEqualObjects(opt.extraparam8, opt2.extraparam8);
    XCTAssertEqualObjects(opt.extraparam9, opt2.extraparam9);
    XCTAssertEqualObjects(opt.extraparam10, opt2.extraparam10);
    XCTAssertEqualObjects(opt.extraparam11, opt2.extraparam11);
    XCTAssertEqualObjects(opt.extraparam12, opt2.extraparam12);
    XCTAssertEqualObjects(opt.extraparam13, opt2.extraparam13);
    XCTAssertEqualObjects(opt.extraparam14, opt2.extraparam14);
    XCTAssertEqualObjects(opt.extraparam15, opt2.extraparam15);
    XCTAssertEqualObjects(opt.extraparam16, opt2.extraparam16);
    XCTAssertEqualObjects(opt.extraparam17, opt2.extraparam17);
    XCTAssertEqualObjects(opt.extraparam18, opt2.extraparam18);
    XCTAssertEqualObjects(opt.extraparam19, opt2.extraparam19);
    XCTAssertEqualObjects(opt.extraparam20, opt2.extraparam20);
}

@end
