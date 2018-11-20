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

- (void)setUp {
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
    
    [[plugin getInfinity] beginWithScreenName:nil];
    
    [[plugin getInfinity] beginWithScreenName:nil];
    
    XCTAssertTrue([plugin getInfinity].flags.started);
}

- (void)testBeginMethodWithParams {
    YBPlugin *plugin = [[YBPlugin alloc] initWithOptions:nil];
    
    id<YBInfinityDelegate> mockDelegate = mockProtocol(@protocol(YBInfinityDelegate));
    
    [[plugin getInfinity] addYouboraInfinityDelegate:mockDelegate];
    
    XCTAssertFalse([plugin getInfinity].flags.started);
    
    HCArgumentCaptor * dimensionsCaptor = [HCArgumentCaptor new];
    HCArgumentCaptor * screenNameCaptor = [HCArgumentCaptor new];
    HCArgumentCaptor * parentIdCaptor = [HCArgumentCaptor new];
    
    NSDictionary *dimensDict = @{ @"key" : @"value" };
    NSString *parentId = @"parentId";
    NSString *screenName = @"some screen name";
    
    //[verify(self.p.mockRequestBuilder) fetchParams:anything() paramList:(id)captor onlyDifferent:false];
    
    [[plugin getInfinity] beginWithScreenName:screenName andDimensions:dimensDict andParentId:parentId];
    
    XCTAssertTrue([plugin getInfinity].flags.started);
    [verifyCount(mockDelegate, times(1)) youboraInfinityEventSessionStartWithScreenName:(id)screenNameCaptor andDimensions:(id)dimensionsCaptor andParentId:(id)parentIdCaptor];
    
    XCTAssertEqual(dimensDict[@"key"], dimensionsCaptor.value[@"key"]);
    
    XCTAssertTrue([screenName isEqualToString:screenNameCaptor.value]);
    
    XCTAssertTrue([parentId isEqualToString:parentIdCaptor.value]);
}

- (void)testBeginMethodWithoutParams {
    YBPlugin *plugin = [[YBPlugin alloc] initWithOptions:nil];
    
    id<YBInfinityDelegate> mockDelegate = mockProtocol(@protocol(YBInfinityDelegate));
    
    [[plugin getInfinity] addYouboraInfinityDelegate:mockDelegate];
    
    XCTAssertFalse([plugin getInfinity].flags.started);
    
    HCArgumentCaptor * dimensionsCaptor = [HCArgumentCaptor new];
    HCArgumentCaptor * screenNameCaptor = [HCArgumentCaptor new];
    HCArgumentCaptor * parentIdCaptor = [HCArgumentCaptor new];
    
    
    //[verify(self.p.mockRequestBuilder) fetchParams:anything() paramList:(id)captor onlyDifferent:false];
    
    [[plugin getInfinity] beginWithScreenName:nil];
    
    XCTAssertTrue([plugin getInfinity].flags.started);
    
    [verifyCount(mockDelegate, times(1)) youboraInfinityEventSessionStartWithScreenName:(id)screenNameCaptor andDimensions:(id)dimensionsCaptor andParentId:(id)parentIdCaptor];
    
    //XCTAssertTrue([((NSDictionary *)dimensionsCaptor.value) containsValueForKey:@"key"]);

    XCTAssertTrue([dimensionsCaptor.value count] == 0);
    XCTAssertTrue([screenNameCaptor.value isEqualToString:@"Unknown"]);
    XCTAssertTrue([parentIdCaptor.value isEqual:[NSNull null]]);
}

- (void)testFireNavMethod {
    YBPlugin *plugin = [[YBPlugin alloc] initWithOptions:nil];
    id<YBInfinityDelegate> mockDelegate = mockProtocol(@protocol(YBInfinityDelegate));
    
    [[plugin getInfinity] addYouboraInfinityDelegate:mockDelegate];
    
    [[plugin getInfinity] beginWithScreenName:nil];
    
    XCTAssertTrue([plugin getInfinity].flags.started);
    
    HCArgumentCaptor * screenNanmeCaptor = [HCArgumentCaptor new];
    
    [[plugin getInfinity] beginWithScreenName:nil];
    
    [verifyCount(mockDelegate, times(1)) youboraInfinityEventNavWithScreenName:(id)screenNanmeCaptor];
    
    XCTAssertTrue([screenNanmeCaptor.value isEqualToString:@"Unknown"]);
    
    screenNanmeCaptor = [HCArgumentCaptor new];
    
    NSString *screenName = @"Whatever";
    
    [[plugin getInfinity] fireNavWithScreenName:screenName];
    
     [verifyCount(mockDelegate, times(1)) youboraInfinityEventNavWithScreenName:(id)screenNanmeCaptor];
    
    XCTAssertTrue([screenName isEqualToString:screenNanmeCaptor.value]);
}

- (void)testFireEventMethod {
    YBPlugin *plugin = [[YBPlugin alloc] initWithOptions:nil];
    id<YBInfinityDelegate> mockDelegate = mockProtocol(@protocol(YBInfinityDelegate));
    
    [[plugin getInfinity] addYouboraInfinityDelegate:mockDelegate];
    
    [[plugin getInfinity] beginWithScreenName:nil];
    
    XCTAssertTrue([plugin getInfinity].flags.started);
    
    HCArgumentCaptor * dimensionsCaptor = [HCArgumentCaptor new];
    HCArgumentCaptor * valuesCaptor = [HCArgumentCaptor new];
    HCArgumentCaptor * eventNameCaptor = [HCArgumentCaptor new];
    
    [[plugin getInfinity] fireEvent:nil values:nil andEventName:nil];
    
    [verifyCount(mockDelegate, times(1)) youboraInfinityEventEventWithDimensions:(id)dimensionsCaptor values:(id)valuesCaptor andEventName:(id)eventNameCaptor];
    
    
    XCTAssertTrue([dimensionsCaptor.value count] == 0);
    XCTAssertTrue([valuesCaptor.value count] == 0);
}

@end
