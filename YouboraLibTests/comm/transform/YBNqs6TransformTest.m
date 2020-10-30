//
//  YBNqs6TransformTest.m
//  YouboraLib
//
//  Created by Joan on 19/04/2017.
//  Copyright © 2017 NPAW. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "YBNqs6Transform.h"

#import "YBRequest.h"

#import <OCMockito/OCMockito.h>
#import "YouboraLib/YouboraLib-Swift.h"

@interface YBNqs6TransformTest : XCTestCase

@property (nonatomic, strong) YBNqs6Transform * transform;

@end

@implementation YBNqs6TransformTest

- (void)setUp {
    [super setUp];
    
    self.transform = [YBNqs6Transform new];
}

- (void)tearDown {
    
    self.transform = nil;
    
    [super tearDown];
}

- (void)testParamCloneNil {
    YBRequest * mockRequest = mock([YBRequest class]);
    stubProperty(mockRequest, service, nil);
    
    [self.transform parse:mockRequest];
    
    stubProperty(mockRequest, service, @"");
    
    [self.transform parse:mockRequest];
    
    [((YBRequest *) verifyCount(mockRequest, times(2))) service];
}

- (void)testParamCloneStart {
    YBRequest * mockRequest = mock([YBRequest class]);
    stubProperty(mockRequest, service, YBConstantsYouboraService.start);
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[YBConstantsRequest.mediaDuration] = @"1";
    
    stubProperty(mockRequest, params, params);
    
    [self.transform parse:mockRequest];
    XCTAssertEqualObjects(@"1", params[@"duration"]);
}

- (void)testParamCloneJoin {
    YBRequest * mockRequest = mock([YBRequest class]);
    stubProperty(mockRequest, service, YBConstantsYouboraService.join);
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[YBConstantsRequest.joinDuration] = @"1";
    params[YBConstantsRequest.playhead] = @"2";
    
    stubProperty(mockRequest, params, params);
    
    [self.transform parse:mockRequest];
    
    XCTAssertEqualObjects(@"1", params[@"time"]);
    XCTAssertEqualObjects(@"2", params[@"eventTime"]);
}

- (void)testParamCloneSeek {
    YBRequest * mockRequest = mock([YBRequest class]);
    stubProperty(mockRequest, service, YBConstantsYouboraService.seek);
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[YBConstantsRequest.seekDuration] = @"1";
    
    stubProperty(mockRequest, params, params);
    
    [self.transform parse:mockRequest];
    
    XCTAssertEqualObjects(@"1", params[@"duration"]);
}

- (void)testParamCloneBuffer {
    YBRequest * mockRequest = mock([YBRequest class]);
    stubProperty(mockRequest, service, YBConstantsYouboraService.buffer);
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[YBConstantsRequest.bufferDuration] = @"1";
    
    stubProperty(mockRequest, params, params);
    
    [self.transform parse:mockRequest];
    
    XCTAssertEqualObjects(@"1", params[@"duration"]);
}

- (void)testParamClonePing {
    YBRequest * mockRequest = mock([YBRequest class]);
    stubProperty(mockRequest, service, YBConstantsYouboraService.ping);
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"entities"] = @"{\"entity1\":\"value1\",\"entity2\":\"value2\"}";
    
    stubProperty(mockRequest, params, params);
    
    [self.transform parse:mockRequest];
    
    XCTAssertEqualObjects(@"entity1", params[@"entityType"]);
    XCTAssertEqualObjects(@"value1", params[@"entityValue"]);
}
@end
