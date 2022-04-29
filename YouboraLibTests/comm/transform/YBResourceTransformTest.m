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
#import "YBPlugin.h"
#import "YBRequestBuilder.h"

#import "YBTestableResourceTransform.h"

#import <OCHamcrest/OCHamcrest.h>
#import <OCMockito/OCMockito.h>
#import "YouboraLib/YouboraLib-Swift.h"

typedef enum {
    dashFlow,
    hlsFlow,
    locationFlow,
    fullFlow
} FlowType;

@interface YBResourceTransformTest : XCTestCase <YBTestableResourceTransformProtocol>

@property(nonatomic, strong) YBPlugin * mockPlugin;
@property(nonatomic) FlowType currentFlow;

@end

@implementation YBResourceTransformTest

- (void)setUp {
    [super setUp];
    self.mockPlugin = mock([YBPlugin class]);
    [given([self.mockPlugin isParseResource]) willReturnBool:TRUE];
}

- (void)testDefaultValues {
    YBResourceTransform * resourceTransform = [[YBResourceTransform alloc] initWithPlugin: self.mockPlugin];
    
    // Assert default values
    XCTAssertNil([resourceTransform getCdnName]);
    XCTAssertNil([resourceTransform getNodeHost]);
    XCTAssertNil([resourceTransform getNodeType]);
    XCTAssertNil([resourceTransform getNodeTypeString]);
    XCTAssertNil([resourceTransform getResource]);
}

-(void)testFinalLocationFlow {
    NSString *expectedFinalResource = @"http://www.example1.com/file.mp4";
    
    YBTestableResourceTransform * resourceTransform = [[YBTestableResourceTransform alloc] initWithPlugin: self.mockPlugin];
    
    resourceTransform.delegate = self;
    
    [resourceTransform begin:expectedFinalResource userDefinedTransportFormat:nil];
    
    NSString *transformedResource = [resourceTransform getResource];
    
    
    XCTAssertTrue([transformedResource isEqualToString:expectedFinalResource]);
}

-(void)testLocationFlow {
    self.currentFlow = locationFlow;
    NSString *expectedFinalResource = @"http://example1.com";
    
    YBTestableResourceTransform * resourceTransform = [[YBTestableResourceTransform alloc] initWithPlugin: self.mockPlugin];
    
    resourceTransform.delegate = self;
    
    [resourceTransform begin:@"http://example.com" userDefinedTransportFormat:nil];
    
    XCTAssertTrue([[resourceTransform getResource] isEqualToString:expectedFinalResource]);
}

-(void)testDashFlowNoDefinedTransport {
    self.currentFlow = dashFlow;
    NSString *expectedFinalResource = @"https://boltrljDRMTest1-a.akamaihd.net/media/v1/dash/live/cenc/6028583040001/f39ee0f0-72de-479d-9609-2bf6ea95b427/fed9a7f1-499a-469d-bacd-f25a94eac116/";
    
    YBTestableResourceTransform * resourceTransform = [[YBTestableResourceTransform alloc] initWithPlugin: self.mockPlugin];
    
    resourceTransform.delegate = self;
    
    [resourceTransform begin:@"http://example.com" userDefinedTransportFormat:nil];
    
    XCTAssertTrue([[resourceTransform getResource] isEqualToString:expectedFinalResource]);
    XCTAssertTrue([[resourceTransform getTransportFormat] isEqualToString:YBConstantsTransportFormat.hlsFmp4]);
}

-(void)testDashFlowDefinedTransport {
    self.currentFlow = dashFlow;
    NSString *expectedFinalResource = @"https://boltrljDRMTest1-a.akamaihd.net/media/v1/dash/live/cenc/6028583040001/f39ee0f0-72de-479d-9609-2bf6ea95b427/fed9a7f1-499a-469d-bacd-f25a94eac116/";
    
    YBTestableResourceTransform * resourceTransform = [[YBTestableResourceTransform alloc] initWithPlugin: self.mockPlugin];
    
    resourceTransform.delegate = self;
    
    [resourceTransform begin:@"http://example.com" userDefinedTransportFormat:YBConstantsTransportFormat.hlsFmp4];
    
    XCTAssertTrue([[resourceTransform getResource] isEqualToString:expectedFinalResource]);
    XCTAssertNil([resourceTransform getTransportFormat]);
}

-(void)testHlsFlowNoDefinedTransport {
    self.currentFlow = hlsFlow;
    NSString *expectedFinalResource = @"http://qthttp.apple.com.edgesuite.net/1010qwoeiuryfg/0640/06400.ts";
    
    YBTestableResourceTransform * resourceTransform = [[YBTestableResourceTransform alloc] initWithPlugin: self.mockPlugin];
    
    resourceTransform.delegate = self;
    
    [resourceTransform begin:@"http://example.com" userDefinedTransportFormat:nil];
    
    XCTAssertTrue([[resourceTransform getResource] isEqualToString:expectedFinalResource]);
    XCTAssertTrue([[resourceTransform getTransportFormat] isEqualToString:YBConstantsTransportFormat.hlsTs]);
}

-(void)testHlsFlowDefinedTransport {
    self.currentFlow = hlsFlow;
    NSString *expectedFinalResource = @"http://qthttp.apple.com.edgesuite.net/1010qwoeiuryfg/0640/06400.ts";
    
    YBTestableResourceTransform * resourceTransform = [[YBTestableResourceTransform alloc] initWithPlugin: self.mockPlugin];
    
    resourceTransform.delegate = self;
    
    [resourceTransform begin:@"http://example.com" userDefinedTransportFormat:YBConstantsTransportFormat.hlsTs];
    
    XCTAssertTrue([[resourceTransform getResource] isEqualToString:expectedFinalResource]);
    XCTAssertNil([resourceTransform getTransportFormat] );
}

- (void)testFullFlow {
    self.currentFlow = fullFlow;
    
    // Mocks
    [given([self.mockPlugin isParseResource]) willReturnBool:YES];
    [given([self.mockPlugin isParseCdnNode]) willReturnBool:YES];
    [given([self.mockPlugin getParseCdnNodeList]) willReturn:@[@"cdn1", @"cdn2"]];
    [given([self.mockPlugin getParseCdnNameHeader]) willReturn:@"header-name"];
    [given([self.mockPlugin getParseCdnNodeHeader]) willReturn:@"node-header"];

    // Resource transform to test
    YBTestableResourceTransform * resourceTransform = [[YBTestableResourceTransform alloc] initWithPlugin: self.mockPlugin];
    resourceTransform.delegate = self;
    
    XCTAssertFalse([resourceTransform isBlocking:nil]);
    
    // Prepare mocks for the cdn
    YBCdnParser * mockCdnParser1 = mock([YBCdnParser class]);
    YBCdnParser * mockCdnParser2 = mock([YBCdnParser class]);
    resourceTransform.mockCdnParsers = @{@"cdn1":mockCdnParser1, @"cdn2":mockCdnParser2};
    
    // Begin, this should start hls parsing
    [resourceTransform begin:@"resource" userDefinedTransportFormat:nil];
    
    XCTAssertTrue([resourceTransform isBlocking:nil]);
    
    // Capture callback
    HCArgumentCaptor * captor = [HCArgumentCaptor new];
    
    // Resource must now have been updated
    XCTAssertTrue([[resourceTransform getResource] isEqualToString:@"parsed-resource"]);
    
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
    XCTAssertTrue([[resourceTransform getResource] isEqualToString:@"parsed-resource"]);
    
    // Check parse start request
    YBRequest * mockRequest = mock([YBRequest class]);
    stubProperty(mockRequest, service, YBConstantsYouboraService.start);
    
    // Mocks
    NSDictionary * lastSent = [NSMutableDictionary dictionary];
    YBRequestBuilder * mockBuilder = mock([YBRequestBuilder class]);
    stubProperty(mockBuilder, lastSent, lastSent);
    stubProperty(self.mockPlugin, requestBuilder, mockBuilder);
    
    [resourceTransform parse:mockRequest];
    
    //We don't modify the mediaResource anymore, any mod is done on the parsedResource
    //[verifyCount(mockRequest, times(1)) setParam:@"parsed-resource" forKey:YBConstantsRequest.mediaResource];
    [verifyCount(mockRequest, times(1)) setParam:@"parsedCdnName" forKey:YBConstantsRequest.cdn];
    [verifyCount(mockRequest, times(1)) setParam:@"parsedNodeHost" forKey:YBConstantsRequest.nodeHost];
    [verifyCount(mockRequest, times(1)) setParam:@"1" forKey:YBConstantsRequest.nodeType];
    [verifyCount(mockRequest, times(1)) setParam:@"HIT" forKey:YBConstantsRequest.nodeTypeString];
    
    XCTAssertEqualObjects(nil, lastSent[YBConstantsRequest.mediaResource]);
    XCTAssertEqualObjects(@"parsedCdnName", lastSent[YBConstantsRequest.cdn]);
    XCTAssertEqualObjects(@"parsedNodeHost", lastSent[YBConstantsRequest.nodeHost]);
    XCTAssertEqualObjects(@"1", lastSent[YBConstantsRequest.nodeType]);
    XCTAssertEqualObjects(@"HIT", lastSent[YBConstantsRequest.nodeTypeString]);
}

- (void)testNotingEnabled {
    [given([self.mockPlugin isParseResource]) willReturnBool:NO];
    [given([self.mockPlugin isParseHls]) willReturnBool:NO];
    [given([self.mockPlugin isParseCdnNode]) willReturnBool:NO];
    [given([self.mockPlugin getParseCdnNodeList]) willReturn:@[@"Akamai", @"Cloudfront", @"Level3", @"Fastly", @"Highwinds"]];
    
    YBResourceTransform * resourceTransform = [[YBResourceTransform alloc] initWithPlugin: self.mockPlugin];
    
    XCTAssertFalse([resourceTransform isBlocking:nil]);
    
    [resourceTransform begin:@"resource" userDefinedTransportFormat:nil];
    
    XCTAssertFalse([resourceTransform isBlocking:nil]);
}

- (void)testStopOnTimeout {
    // Mocks
    [given([self.mockPlugin isParseResource]) willReturnBool:YES];
    [given([self.mockPlugin isParseCdnNode]) willReturnBool:YES];
    [given([self.mockPlugin getParseCdnNodeList]) willReturn:@[@"cdn1", @"cdn2"]];
    
    // Resource transform to test
    YBTestableResourceTransform * resourceTransform = [[YBTestableResourceTransform alloc] initWithPlugin:self.mockPlugin];
    
    XCTAssertFalse([resourceTransform isBlocking:nil]);
    
    [resourceTransform begin:@"resource" userDefinedTransportFormat:nil];
    
    XCTAssertTrue([resourceTransform isBlocking:nil]);
    
    // Mock timeout
    [resourceTransform performSelector:@selector(parseTimeout:) withObject:resourceTransform.mockTimer];
    XCTAssertFalse([resourceTransform isBlocking:nil]);
}

// Keep compiler happy
- (void) parseTimeout:(NSTimer *) timer {
}

- (NSData * _Nullable)getDataForIteration:(NSInteger)iteration {
    switch (self.currentFlow) {
        case dashFlow:
            return [self getDashFlowData:iteration];
        case hlsFlow:
            return [self getHlsFlowData:iteration];
        default:
            return [[NSString stringWithFormat:@""] dataUsingEncoding:NSUTF8StringEncoding];
    }
}

- (NSHTTPURLResponse * _Nullable)getResponseForIteration:(NSInteger)iteration {
    switch (self.currentFlow) {
        case dashFlow:
            return [self getDashFlowResponseForIteration:iteration];
        case hlsFlow:
            return [self getHlsFlowResponseForIteration:iteration];
        case locationFlow:
            return [self getLocationFlowResponseForIteration:iteration];
        case fullFlow:
            return [self getFullFlowResponseForIteration:iteration];
        default:
            return nil;
    }
}

#pragma mark Full flow Section
- (NSHTTPURLResponse * _Nullable)getFullFlowResponseForIteration:(NSInteger)iteration {
    if (iteration == 0) {
        return [[NSHTTPURLResponse alloc] initWithURL:@"" statusCode:200 HTTPVersion:nil headerFields:@{@"Location":@"parsed-resource"}];
    }
    
    return [[NSHTTPURLResponse alloc] initWithURL:@"" statusCode:200 HTTPVersion:nil headerFields:nil];
}

#pragma mark Location Section

- (NSHTTPURLResponse * _Nullable)getLocationFlowResponseForIteration:(NSInteger)iteration {
    if (iteration == 0) {
        return [[NSHTTPURLResponse alloc] initWithURL:@"" statusCode:200 HTTPVersion:nil headerFields:@{@"Location":@"http://example1.com"}];
    }
    
    return [[NSHTTPURLResponse alloc] initWithURL:@"" statusCode:200 HTTPVersion:nil headerFields:nil];
}

#pragma mark Hls Section

-(NSData* _Nullable)getHlsFlowData:(NSInteger)iteration {
    if (iteration == 2) {
        NSString *stringToReturn = @"\
        #EXTM3U\n\
        #EXT-X-STREAM-INF:PROGRAM-ID=1, BANDWIDTH=688301\n\
        http://qthttp.apple.com.edgesuite.net/1010qwoeiuryfg/0640_vod.m3u8\n\
        #EXT-X-STREAM-INF:PROGRAM-ID=1, BANDWIDTH=165135\n\
        http://qthttp.apple.com.edgesuite.net/1010qwoeiuryfg/0150_vod.m3u8\n";
        
        return [stringToReturn dataUsingEncoding:NSUTF8StringEncoding];
    }
    
    if (iteration == 3) {
        NSString *stringToReturn = @"\
        #EXTM3U\n\
        #EXT-X-TARGETDURATION:10\n\
        #EXT-X-MEDIA-SEQUENCE:0\n\
        #EXTINF:10,\n\
        0640/06400.ts\n\
        #EXTINF:10,\n\
        0640/06401.ts\n";
        return [stringToReturn dataUsingEncoding:NSUTF8StringEncoding];
    }
    
    return nil;
}

- (NSHTTPURLResponse * _Nullable)getHlsFlowResponseForIteration:(NSInteger)iteration {
    if (iteration == 0) {
        return [[NSHTTPURLResponse alloc] initWithURL:@"" statusCode:200 HTTPVersion:nil headerFields:@{@"Location":@"http://example.m3u8"}];
    }
    
    return [[NSHTTPURLResponse alloc] initWithURL:@"" statusCode:200 HTTPVersion:nil headerFields:nil];
}

#pragma mark Dash Section
-(NSData* _Nullable)getDashFlowData:(NSInteger)iteration {
    NSBundle *bundle = [NSBundle bundleForClass:self.classForCoder];
    
    if (iteration == 2) {
        return [NSData dataWithContentsOfFile:[bundle pathForResource:@"dashResponse" ofType:@"xml"]];
    }
    
    if (iteration == 3) {
        return [NSData dataWithContentsOfFile:[bundle pathForResource:@"dashCallbackResponse" ofType:@"xml"]];
    }
    
    return nil;
}

- (NSHTTPURLResponse * _Nullable)getDashFlowResponseForIteration:(NSInteger)iteration {
    if (iteration == 0) {
        return [[NSHTTPURLResponse alloc] initWithURL:@"" statusCode:200 HTTPVersion:nil headerFields:@{@"Location":@"http://example.mpd"}];
    }
    
    return [[NSHTTPURLResponse alloc] initWithURL:@"" statusCode:200 HTTPVersion:nil headerFields:nil];
}

@end
