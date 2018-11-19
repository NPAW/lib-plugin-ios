//
//  YBInfinityTest.m
//  YouboraLib
//
//  Created by Enrique Alfonso Burillo on 26/07/2018.
//  Copyright © 2018 NPAW. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "YBPlugin.h"
#import "YBInfinity.h"
#import "YBInfinityFlags.h"
#import "YBLog.h"

#import <OCHamcrest/OCHamcrest.h>
#import <OCMockito/OCMockito.h>

@interface YBInfinityTest : XCTestCase

@property(nonatomic,strong) YBPlugin *plugin;

@end

@implementation YBInfinityTest

/*- (void)setUp {
    [YBLog setDebugLevel:YBLogLevelSilent];
    self.plugin = [[YBPlugin alloc] initWithOptions:nil];
    [super setUp];
}

- (void)tearDown {
    [[self.plugin getInfinity] end];
    [super tearDown];
}

- (void)testBeginMethod {
    YBPlugin *plugin = [[YBPlugin alloc] initWithOptions:nil];
    
    id<YBInfinityDelegate> mockDelegate = mockProtocol(@protocol(YBInfinityDelegate));
    
    [[plugin getInfinity] addYouboraInfinityDelegate:mockDelegate];
    
    XCTAssertFalse([plugin getInfinity].flags.started);
    
    [[plugin getInfinity] begin];
    
    [verify(mockDelegate) youboraInfinityEventSessionStartWithDimensions:anything() values:anything() andParentId:anything()];
    
    XCTAssertTrue([plugin getInfinity].flags.started);
}

- (void)testBeginMethodWithParams {
    YBPlugin *plugin = [[YBPlugin alloc] initWithOptions:nil];
    
    id<YBInfinityDelegate> mockDelegate = mockProtocol(@protocol(YBInfinityDelegate));
    
    [[plugin getInfinity] addYouboraInfinityDelegate:mockDelegate];
    
    XCTAssertFalse([plugin getInfinity].flags.started);
    
    HCArgumentCaptor * dimensionsCaptor = [HCArgumentCaptor new];
    HCArgumentCaptor * valuesCaptor = [HCArgumentCaptor new];
    HCArgumentCaptor * parentIdCaptor = [HCArgumentCaptor new];
    
    NSDictionary *dimensDict = @{ @"key" : @"value" };
    NSDictionary *valuesDict = @{ @"key" : [NSNumber numberWithDouble:1.1] };
    NSString *parentId = @"parentId";
    
    //[verify(self.p.mockRequestBuilder) fetchParams:anything() paramList:(id)captor onlyDifferent:false];
    
    [[plugin getInfinity] beginWithDimensions:dimensDict values:valuesDict andParentId:parentId];
    
    XCTAssertTrue([plugin getInfinity].flags.started);
    
    [verifyCount(mockDelegate, times(1)) youboraInfinityEventSessionStartWithDimensions:(id)dimensionsCaptor values:(id)valuesCaptor andParentId:(id)parentIdCaptor];
    
    //XCTAssertTrue([((NSDictionary *)dimensionsCaptor.value) containsValueForKey:@"key"]);
    XCTAssertEqual(dimensDict[@"key"], dimensionsCaptor.value[@"key"]);
    
    //XCTAssertTrue([valuesCaptor.value containsValueForKey:@"key"]);
    XCTAssertEqual(valuesDict[@"key"], valuesCaptor.value[@"key"]);
    
    XCTAssertTrue([parentId isEqualToString:parentIdCaptor.value]);
}

- (void)testBeginMethodWithoutParams {
    YBPlugin *plugin = [[YBPlugin alloc] initWithOptions:nil];
    
    id<YBInfinityDelegate> mockDelegate = mockProtocol(@protocol(YBInfinityDelegate));
    
    [[plugin getInfinity] addYouboraInfinityDelegate:mockDelegate];
    
    XCTAssertFalse([plugin getInfinity].flags.started);
    
    HCArgumentCaptor * dimensionsCaptor = [HCArgumentCaptor new];
    HCArgumentCaptor * valuesCaptor = [HCArgumentCaptor new];
    HCArgumentCaptor * parentIdCaptor = [HCArgumentCaptor new];
    
    
    //[verify(self.p.mockRequestBuilder) fetchParams:anything() paramList:(id)captor onlyDifferent:false];
    
    [[plugin getInfinity] begin];
    
    XCTAssertTrue([plugin getInfinity].flags.started);
    
    [verifyCount(mockDelegate, times(1)) youboraInfinityEventSessionStartWithDimensions:(id)dimensionsCaptor values:(id)valuesCaptor andParentId:(id)parentIdCaptor];
    
    //XCTAssertTrue([((NSDictionary *)dimensionsCaptor.value) containsValueForKey:@"key"]);

    XCTAssertTrue([dimensionsCaptor.value isEqual:[NSNull null]]);
    XCTAssertTrue([valuesCaptor.value isEqual:[NSNull null]]);
    XCTAssertTrue([parentIdCaptor.value isEqual:[NSNull null]]);
}

- (void)testFireNavMethod {
    YBPlugin *plugin = [[YBPlugin alloc] initWithOptions:nil];
    id<YBInfinityDelegate> mockDelegate = mockProtocol(@protocol(YBInfinityDelegate));
    
    [[plugin getInfinity] addYouboraInfinityDelegate:mockDelegate];
    
    [[plugin getInfinity] begin];
    
    XCTAssertTrue([plugin getInfinity].flags.started);
    
    HCArgumentCaptor * dimensionsCaptor = [HCArgumentCaptor new];
    HCArgumentCaptor * valuesCaptor = [HCArgumentCaptor new];
    
    [[plugin getInfinity] fireNavWithDimensions:nil andValues:nil];
    
    [verifyCount(mockDelegate, times(1)) youboraInfinityEventNavWithDimensions:(id)dimensionsCaptor andValues:(id)valuesCaptor];
    
    XCTAssertTrue([dimensionsCaptor.value isEqual:[NSNull null]]);
    XCTAssertTrue([valuesCaptor.value isEqual:[NSNull null]]);
    
    dimensionsCaptor = [HCArgumentCaptor new];
    valuesCaptor = [HCArgumentCaptor new];
    
    NSDictionary *dimensDict = @{ @"key" : @"value" };
    NSDictionary *valuesDict = @{ @"key" : [NSNumber numberWithDouble:1.1] };
    
    [[plugin getInfinity] fireNavWithDimensions:dimensDict andValues:valuesDict];
    
    [verifyCount(mockDelegate, times(1)) youboraInfinityEventNavWithDimensions:(id)dimensionsCaptor andValues:(id)valuesCaptor];
    
    XCTAssertEqual(dimensDict[@"key"], dimensionsCaptor.value[@"key"]);
    
    XCTAssertEqual(valuesDict[@"key"], valuesCaptor.value[@"key"]);
}

- (void)testFireEventMethod {
    YBPlugin *plugin = [[YBPlugin alloc] initWithOptions:nil];
    id<YBInfinityDelegate> mockDelegate = mockProtocol(@protocol(YBInfinityDelegate));
    
    [[plugin getInfinity] addYouboraInfinityDelegate:mockDelegate];
    
    [[plugin getInfinity] begin];
    
    XCTAssertTrue([plugin getInfinity].flags.started);
    
    HCArgumentCaptor * dimensionsCaptor = [HCArgumentCaptor new];
    HCArgumentCaptor * valuesCaptor = [HCArgumentCaptor new];
    HCArgumentCaptor * eventNameCaptor = [HCArgumentCaptor new];
    
    [[plugin getInfinity] fireEvent:nil values:nil andEventName:nil];
    
    [verifyCount(mockDelegate, times(1)) youboraInfinityEventEventWithDimensions:dimensionsCaptor values:valuesCaptor andEventName:eventNameCaptor];
    
    XCTAssertTrue([dimensionsCaptor.value isEqual:[NSNull null]]);
    XCTAssertTrue([valuesCaptor.value isEqual:[NSNull null]]);
    
    dimensionsCaptor = [HCArgumentCaptor new];
    valuesCaptor = [HCArgumentCaptor new];
    eventNameCaptor = [HCArgumentCaptor new];
    
    NSDictionary *dimensDict = @{ @"key" : @"value" };
    NSDictionary *valuesDict = @{ @"key" : [NSNumber numberWithDouble:1.1] };
    NSString *eventName = @"event";
    
    [[plugin getInfinity] fireNavWithDimensions:dimensDict andValues:valuesDict];
    
    [verifyCount(mockDelegate, times(1)) youboraInfinityEventNavWithDimensions:(id)dimensionsCaptor andValues:(id)valuesCaptor];
    
    XCTAssertEqual(dimensDict[@"key"], dimensionsCaptor.value[@"key"]);
    
    XCTAssertEqual(valuesDict[@"key"], valuesCaptor.value[@"key"]);
}*/

@end
