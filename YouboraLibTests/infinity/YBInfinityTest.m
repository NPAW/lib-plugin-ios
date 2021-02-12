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
    
    [plugin getInfinity].delegate = mockDelegate;
    
    XCTAssertFalse([plugin getInfinity].flags.started);
    
    [[plugin getInfinity] beginWithScreenName:@"Unknown"];
    
    [[plugin getInfinity] beginWithScreenName:@"Unknown"];
    
    XCTAssertTrue([plugin getInfinity].flags.started);
}

- (void)testBeginMethodWithParams {
    YBPlugin *plugin = [[YBPlugin alloc] initWithOptions:nil];
    
    id<YBInfinityDelegate> mockDelegate = mockProtocol(@protocol(YBInfinityDelegate));
    
    [plugin getInfinity].delegate = mockDelegate;
    
    XCTAssertFalse([plugin getInfinity].flags.started);
    
    HCArgumentCaptor * dimensionsCaptor = [HCArgumentCaptor new];
    HCArgumentCaptor * screenNameCaptor = [HCArgumentCaptor new];
    
    NSDictionary *dimensDict = @{ @"key" : @"value" };
    NSString *screenName = @"some screen name";
    
    //[verify(self.p.mockRequestBuilder) fetchParams:anything() paramList:(id)captor onlyDifferent:false];
    
    [[plugin getInfinity] beginWithScreenName:screenName andDimensions:dimensDict];
    
    XCTAssertTrue([plugin getInfinity].flags.started);
    [verifyCount(mockDelegate, times(1)) youboraInfinityEventSessionStartWithScreenName:(id)screenNameCaptor andDimensions:(id)dimensionsCaptor];
    
    XCTAssertEqual(dimensDict[@"key"], dimensionsCaptor.value[@"key"]);
    
    XCTAssertTrue([screenName isEqualToString:screenNameCaptor.value]);
}

- (void)testBeginMethodWithoutParams {
    YBPlugin *plugin = [[YBPlugin alloc] initWithOptions:nil];
    
    id<YBInfinityDelegate> mockDelegate = mockProtocol(@protocol(YBInfinityDelegate));
    
    [plugin getInfinity].delegate = mockDelegate;
    
    XCTAssertFalse([plugin getInfinity].flags.started);
    
    HCArgumentCaptor * dimensionsCaptor = [HCArgumentCaptor new];
    HCArgumentCaptor * screenNameCaptor = [HCArgumentCaptor new];
    HCArgumentCaptor * parentIdCaptor = [HCArgumentCaptor new];
    
    
    //[verify(self.p.mockRequestBuilder) fetchParams:anything() paramList:(id)captor onlyDifferent:false];
    
    [[plugin getInfinity] beginWithScreenName:@"Unknown"];
    
    XCTAssertTrue([plugin getInfinity].flags.started);
    
    [verifyCount(mockDelegate, times(1)) youboraInfinityEventSessionStartWithScreenName:(id)screenNameCaptor andDimensions:(id)dimensionsCaptor];
    
    //XCTAssertTrue([((NSDictionary *)dimensionsCaptor.value) containsValueForKey:@"key"]);

    XCTAssertTrue([dimensionsCaptor.value count] == 0);
    XCTAssertTrue([screenNameCaptor.value isEqualToString:@"Unknown"]);
}

- (void)testFireNavMethod {
    YBPlugin *plugin = [[YBPlugin alloc] initWithOptions:nil];
    id<YBInfinityDelegate> mockDelegate = mockProtocol(@protocol(YBInfinityDelegate));
    
    [plugin getInfinity].delegate = mockDelegate;
    
    [[plugin getInfinity] beginWithScreenName:@"Unknown"];
    
    XCTAssertTrue([plugin getInfinity].flags.started);
    
    HCArgumentCaptor * screenNanmeCaptor = [HCArgumentCaptor new];
    
    [[plugin getInfinity] beginWithScreenName:@"Unknown"];
    
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
    
    [plugin getInfinity].delegate = mockDelegate;
    
    [[plugin getInfinity] beginWithScreenName:@"Unknown"];
    
    XCTAssertTrue([plugin getInfinity].flags.started);
    
    HCArgumentCaptor * topLevelDimensionsCaptor = [HCArgumentCaptor new];
    HCArgumentCaptor * dimensionsCaptor = [HCArgumentCaptor new];
    HCArgumentCaptor * valuesCaptor = [HCArgumentCaptor new];
    HCArgumentCaptor * eventNameCaptor = [HCArgumentCaptor new];
    
    [[plugin getInfinity] fireEvent:@"Unknown" dimensions:nil values:nil topLevelDimensions:nil];
    
    [verifyCount(mockDelegate, times(1)) youboraInfinityEventEventWithDimensions:(id)dimensionsCaptor values:(id)valuesCaptor andEventName:(id)eventNameCaptor andTopLevelDimensions:(id)topLevelDimensionsCaptor];
    
    XCTAssertTrue([topLevelDimensionsCaptor.value count] == 0);
    XCTAssertTrue([dimensionsCaptor.value count] == 0);
    XCTAssertTrue([valuesCaptor.value count] == 0);
}

@end
