//
//  YBViewTransformTest.m
//  YouboraLib
//
//  Created by Joan on 24/03/2017.
//  Copyright © 2017 NPAW. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "YBTestableViewTransform.h"
#import "YBPlugin.h"
#import "YBViewTransform.h"
#import "YBRequest.h"
#import "YBLog.h"
#import "YBRequestBuilder.h"
#import "YBConstants.h"
#import "YBFastDataConfig.h"

#import <OCMockito/OCMockito.h>
#import <OCHamcrest/OCHamcrest.h>

@interface YBViewTransformTest : XCTestCase

@property (nonatomic, strong) YBPlugin * mockPlugin;
@property (nonatomic, strong) YBTestableViewTransform * viewTransform;
@property (nonatomic, strong) NSObject<YBLogger> * mockLogger;

@end

@implementation YBViewTransformTest

- (void)setUp {
    [super setUp];
    
    // Log listener
    self.mockLogger = mockProtocol(@protocol(YBLogger));
    [YBLog addLoggerDelegate:self.mockLogger];
    
    self.mockPlugin = mock([YBPlugin class]);

    YBRequestBuilder * mockBuilder = mock([YBRequestBuilder class]);
    
    [given([mockBuilder buildParams:anything() forService:YouboraServiceData]) willReturn:[NSMutableDictionary dictionary]];
    
    stubProperty(self.mockPlugin, requestBuilder, mockBuilder);
    
    self.viewTransform = [[YBTestableViewTransform alloc] initWithPlugin:self.mockPlugin];
 
}

- (void)tearDown {
    self.mockPlugin = nil;
    self.viewTransform = nil;
    [super tearDown];
}

- (void)testGetCodeWithoutBegin {
    XCTAssertNil([self.viewTransform nextView]);
    XCTAssertNil([self.viewTransform nextView]);
}

- (void)testEmptyResponse {
    HCArgumentCaptor * argumentCaptor = [HCArgumentCaptor new];
    
    [self.viewTransform begin];
    
    // Capture callback
    [verifyCount(self.viewTransform.mockRequest, times(1)) addRequestSuccessListener:(id) argumentCaptor];
    YBRequestSuccessBlock successBlock = argumentCaptor.value;
    
    successBlock([@"" dataUsingEncoding:NSUTF8StringEncoding], mock([NSURLResponse class]));
    
    [verifyCount(self.mockLogger, times(1)) logYouboraMessage:anything() withLogLevel:YBLogLevelError];
}

- (void)testNilResponse {
    HCArgumentCaptor * argumentCaptor = [HCArgumentCaptor new];
    
    [self.viewTransform begin];
    
    // Capture callback
    [verifyCount(self.viewTransform.mockRequest, times(1)) addRequestSuccessListener:(id) argumentCaptor];
    YBRequestSuccessBlock successBlock = argumentCaptor.value;
    
    successBlock(nil, mock([NSURLResponse class]));
    
    [verifyCount(self.mockLogger, times(1)) logYouboraMessage:anything() withLogLevel:YBLogLevelError];
}

- (void)testErrorResponse {
    HCArgumentCaptor * argumentCaptor = [HCArgumentCaptor new];
    
    [self.viewTransform begin];
    
    // Capture callback
    [verifyCount(self.viewTransform.mockRequest, times(1)) addRequestErrorListener:(id) argumentCaptor];
    YBRequestErrorBlock errorBlock = argumentCaptor.value;
    
    errorBlock(mock([NSError class]));
    
    [verifyCount(self.mockLogger, times(1)) logYouboraMessage:anything() withLogLevel:YBLogLevelError];
}

- (void)testRequestData {
    HCArgumentCaptor * argumentCaptor = [HCArgumentCaptor new];
    
    [self.viewTransform begin];
    
    // Capture callback
    [verifyCount(self.viewTransform.mockRequest, times(1)) addRequestSuccessListener:(id) argumentCaptor];
    YBRequestSuccessBlock successBlock = argumentCaptor.value;
    
    NSString * response = @"fjsonp({\"q\":{\"h\":\"debug-nqs-lw2.nice264.com\",\"t\":\"\",\"pt\":\"5\",\"c\":\"U_19487_4uv9wa43215qq55y\",\"tc\":\"\",\"b\":\"0\"}})";
    
    successBlock([response dataUsingEncoding:NSUTF8StringEncoding], mock([NSURLResponse class]));
    
    // Shouldn't block anymore
    XCTAssertFalse([self.viewTransform isBlocking:nil]);
    
    YBFastDataConfig * fastDataConfig = self.viewTransform.fastDataConfig;
    
    // Assert config params
    XCTAssertNotNil(fastDataConfig);
    XCTAssertEqualObjects(@5, fastDataConfig.pingTime);
    XCTAssertEqualObjects(@"U_19487_4uv9wa43215qq55y", fastDataConfig.code);
    XCTAssertEqualObjects(@"http://debug-nqs-lw2.nice264.com", fastDataConfig.host);
}

- (void)testParseRequests {
    
    // Fill fastData responses
    self.viewTransform.fastDataConfig = [YBFastDataConfig new];
    self.viewTransform.fastDataConfig.host = @"http://host.com";
    self.viewTransform.fastDataConfig.pingTime = @5;
    self.viewTransform.fastDataConfig.code = @"viewCode";
    
    // Create first view code
    [self.viewTransform nextView];
    
    // Mock /start
    YBRequest * mockStart = mock([YBRequest class]);
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    stubProperty(mockStart, params, dict);
    stubProperty(mockStart, service, YouboraServiceStart);
    
    // Parse requests
    [self.viewTransform parse:mockStart];
    
    XCTAssertEqualObjects(@"viewCode_0", dict[@"code"]);
    XCTAssertEqualObjects(@"5", dict[@"pingTime"]);
    [verifyCount(mockStart, times(1)) setHost:@"http://host.com"];
    
    // increment view code
    [self.viewTransform nextView];
    
    // Mock /ping
    YBRequest * mockPing = mock([YBRequest class]);
    dict = [NSMutableDictionary dictionary];
    stubProperty(mockPing, params, dict);
    stubProperty(mockPing, service, YouboraServicePing);
    
    [self.viewTransform parse:mockPing];
    
    XCTAssertEqualObjects(@"viewCode_1", dict[@"code"]);
    XCTAssertEqualObjects(@"5", dict[@"pingTime"]);
    [verifyCount(mockPing, times(1)) setHost:@"http://host.com"];
}

@end
