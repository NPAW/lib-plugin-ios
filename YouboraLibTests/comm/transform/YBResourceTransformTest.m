//
//  YBResourceTransformTest.m
//  YouboraLib
//
//  Created by Joan on 05/04/2017.
//  Copyright © 2017 NPAW. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "YBResourceTransform.h"
#import "YBRequest.h"
#import "YBCdnParser.h"
#import "YBHlsParser.h"
#import "YBPlugin.h"
#import "YBRequestBuilder.h"

#import "YBTestableResourceTransform.h"

#import <OCHamcrest/OCHamcrest.h>
#import <OCMockito/OCMockito.h>
#import "YouboraLib/YouboraLib-Swift.h"

@interface YBResourceTransformTest : XCTestCase

@property(nonatomic, strong) YBPlugin * mockPlugin;

@end

@implementation YBResourceTransformTest

- (void)setUp {
    [super setUp];
    
    self.mockPlugin = mock([YBPlugin class]);
    
}

- (void)testDefaultValues {
    YBResourceTransform * resourceTransform = [[YBResourceTransform alloc] initWithPlugin:self.mockPlugin];
    
    // Assert default values
    XCTAssertNil([resourceTransform getCdnName]);
    XCTAssertNil([resourceTransform getNodeHost]);
    XCTAssertNil([resourceTransform getNodeType]);
    XCTAssertNil([resourceTransform getNodeTypeString]);
    XCTAssertNil([resourceTransform getResource]);
}

- (void)testFullFlow {
    
    // Mocks
    [given([self.mockPlugin isParseHls]) willReturnBool:YES];
    [given([self.mockPlugin isParseCdnNode]) willReturnBool:YES];
    [given([self.mockPlugin getParseCdnNodeList]) willReturn:@[@"cdn1", @"cdn2"]];
    [given([self.mockPlugin getParseCdnNameHeader]) willReturn:@"header-name"];
    
    // Resource transform to test
    YBTestableResourceTransform * resourceTransform = [[YBTestableResourceTransform alloc] initWithPlugin:self.mockPlugin];
    
    XCTAssertFalse([resourceTransform isBlocking:nil]);
    
    // Prepare mocks for the cdn
    YBCdnParser * mockCdnParser1 = mock([YBCdnParser class]);
    YBCdnParser * mockCdnParser2 = mock([YBCdnParser class]);
    resourceTransform.mockCdnParsers = @{@"cdn1":mockCdnParser1, @"cdn2":mockCdnParser2};
    
    // Begin, this should start hls parsing
    [resourceTransform begin:@"resource"];
    
    XCTAssertTrue([resourceTransform isBlocking:nil]);
    
    [verify(resourceTransform.mockHlsParser) parse:@"resource" parentResource:nil];
    
    // Capture callback
    HCArgumentCaptor * captor = [HCArgumentCaptor new];
    [verify(resourceTransform.mockHlsParser) addHlsTransformDoneDelegate:(id)captor];
    id<HlsTransformDoneDelegate> hlsDelegate = captor.value;
    
    // Invoke callback
    [hlsDelegate hlsTransformDone:@"parsed-resource" fromHlsParser:resourceTransform.mockHlsParser];
    
    // Resource must now have been updated
    XCTAssertEqualObjects(@"parsed-resource", [resourceTransform getResource]);
    
    // Mock cdn values
    stubProperty(mockCdnParser2, cdnName, @"parsedCdnName");
    stubProperty(mockCdnParser2, cdnNodeHost, @"parsedNodeHost");
    stubProperty(mockCdnParser2, cdnNodeType, @(YBCdnTypeHit));
    stubProperty(mockCdnParser2, cdnNodeTypeString, @"HIT");
    
    // Capture cdn parser callback
    [verify(mockCdnParser1) addCdnTransformDelegate:(id)captor];
    
    id<CdnTransformDoneDelegate> cdnDelegate = captor.value;
    
    // Invoke callback. As this cdn won't return any info (all nil), the second cdn will be used
    [cdnDelegate cdnTransformDone:mockCdnParser1];

    // Capture callback for mockCdnParser2
    [verify(mockCdnParser2) addCdnTransformDelegate:(id)captor];
    
    // Invoke callback. This time, cdn2 has info so parsing will be completed
    cdnDelegate = captor.value;
    [cdnDelegate cdnTransformDone:mockCdnParser2];
    
    XCTAssertFalse([resourceTransform isBlocking:nil]);
    
    // Check parsed values
    XCTAssertEqualObjects(@"parsedCdnName", [resourceTransform getCdnName]);
    XCTAssertEqualObjects(@"parsedNodeHost", [resourceTransform getNodeHost]);
    XCTAssertEqualObjects(@"1", [resourceTransform getNodeType]);
    XCTAssertEqualObjects(@"HIT", [resourceTransform getNodeTypeString]);
    XCTAssertEqualObjects(@"parsed-resource", [resourceTransform getResource]);
    
    // Check parse start request
    YBRequest * mockRequest = mock([YBRequest class]);
    stubProperty(mockRequest, service, ConstantsYouboraService.start);
    
    // Mocks
    NSDictionary * lastSent = [NSMutableDictionary dictionary];
    YBRequestBuilder * mockBuilder = mock([YBRequestBuilder class]);
    stubProperty(mockBuilder, lastSent, lastSent);
    stubProperty(self.mockPlugin, requestBuilder, mockBuilder);
    
    [resourceTransform parse:mockRequest];
    
    //We don't modify the mediaResource anymore, any mod is done on the parsedResource
    //[verifyCount(mockRequest, times(1)) setParam:@"parsed-resource" forKey:@"mediaResource"];
    [verifyCount(mockRequest, times(1)) setParam:@"parsedCdnName" forKey:@"cdn"];
    [verifyCount(mockRequest, times(1)) setParam:@"parsedNodeHost" forKey:@"nodeHost"];
    [verifyCount(mockRequest, times(1)) setParam:@"1" forKey:@"nodeType"];
    [verifyCount(mockRequest, times(1)) setParam:@"HIT" forKey:@"nodeTypeString"];
    
    XCTAssertEqualObjects(nil, lastSent[@"mediaResource"]);
    XCTAssertEqualObjects(@"parsedCdnName", lastSent[@"cdn"]);
    XCTAssertEqualObjects(@"parsedNodeHost", lastSent[@"nodeHost"]);
    XCTAssertEqualObjects(@"1", lastSent[@"nodeType"]);
    XCTAssertEqualObjects(@"HIT", lastSent[@"nodeTypeString"]);
    
}

- (void)testNotingEnabled {
    [given([self.mockPlugin isParseHls]) willReturnBool:NO];
    [given([self.mockPlugin isParseCdnNode]) willReturnBool:NO];
    
    YBResourceTransform * resourceTransform = [[YBResourceTransform alloc] initWithPlugin:self.mockPlugin];
    
    XCTAssertFalse([resourceTransform isBlocking:nil]);
    
    [resourceTransform begin:@"resource"];

    XCTAssertFalse([resourceTransform isBlocking:nil]);
}

- (void)testStopOnTimeout {
    // Mocks
    [given([self.mockPlugin isParseHls]) willReturnBool:YES];
    [given([self.mockPlugin isParseCdnNode]) willReturnBool:YES];
    
    // Resource transform to test
    YBTestableResourceTransform * resourceTransform = [[YBTestableResourceTransform alloc] initWithPlugin:self.mockPlugin];
    
    XCTAssertFalse([resourceTransform isBlocking:nil]);
    
    [resourceTransform begin:@"resource"];

    XCTAssertTrue([resourceTransform isBlocking:nil]);
    
    // Mock timeout
    [resourceTransform performSelector:@selector(parseTimeout:) withObject:resourceTransform.mockTimer];
    XCTAssertFalse([resourceTransform isBlocking:nil]);
}

// Keep compiler happy
- (void) parseTimeout:(NSTimer *) timer {
}

@end
