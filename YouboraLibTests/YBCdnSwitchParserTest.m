//
//  YBCdnSwitchParserTest.m
//  YouboraLib
//
//  Created by Tiago Pereira on 12/08/2020.
//  Copyright © 2020 NPAW. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "YBPlugin.h"
#import "YBOptions.h"
#import "YBCdnSwitchParser.h"
#import <OCMockito/OCMockito.h>
#import <OCHamcrest/OCHamcrest.h>
#import "YBTestableCdnSwitchParser.h"
#import "YBRequest.h"

@interface YBCdnSwitchParserTest : XCTestCase

@end

@implementation YBCdnSwitchParserTest

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testParserInitialization {
    YBOptions *options = [YBOptions new];
    
    options.cdnSwitchHeader = YES;
    
    YBPlugin *plugin = [[YBPlugin alloc] initWithOptions:options];
    
    XCTAssertEqual(plugin.cdnSwitchParser.cdnTTL, options.cdnTTL);
    XCTAssertEqual(plugin.cdnSwitchParser.cdnSwitchHeader, options.cdnSwitchHeader);
}

-(void)testValidStartMethod {
    YBCdnSwitchParser *parser = [[YBCdnSwitchParser alloc] initWithIsCdnSwitchHeader:TRUE andCdnTTL:60];
    
    [parser start:@"url"];
    
    XCTAssertTrue([parser isQueueRuning]);
    XCTAssertTrue([parser isTimerRunning]);
    
    [parser invalidate];
    
    XCTAssertFalse([parser isQueueRuning]);
    XCTAssertFalse([parser isTimerRunning]);
    
    [parser start:nil];
    
    XCTAssertFalse([parser isQueueRuning]);
    XCTAssertFalse([parser isTimerRunning]);
    
    [parser start:@"url"];
    
    XCTAssertTrue([parser isQueueRuning]);
    XCTAssertTrue([parser isTimerRunning]);
    
    [parser invalidate];
}

-(void)testInvalidStartMethod {
    YBCdnSwitchParser *parser = [[YBCdnSwitchParser alloc] initWithIsCdnSwitchHeader:TRUE andCdnTTL:60];
       
    [parser start:nil];

    XCTAssertFalse([parser isQueueRuning]);
    XCTAssertFalse([parser isTimerRunning]);
    
    [parser invalidate];
}

-(void)testNoCdnHeader {
    
    YBTestableCdnSwitchParser * parser = [[YBTestableCdnSwitchParser alloc] initWithIsCdnSwitchHeader:TRUE andCdnTTL:60];
    parser.mockRequest = mock([YBRequest class]);
    
    [parser start:@"test"];
    
    HCArgumentCaptor * argumentCaptor = [HCArgumentCaptor new];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
         [verifyCount(parser.mockRequest, times(1)) addRequestSuccessListener:(id) argumentCaptor];
           YBRequestSuccessBlock successBlock = argumentCaptor.value;
           
           NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc]
                                          initWithURL:mock([NSURL class])
                                          statusCode:200
                                          HTTPVersion:@""
                                          headerFields:@{
                                          }];
           
           
           successBlock(nil, response, [[NSMutableDictionary alloc] init]);
    });
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Testing cdn"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        XCTAssertNil([parser getLastKnownCdn]);
        [expectation fulfill];
    });
    
    
    [self waitForExpectationsWithTimeout:2.0 handler:nil];
}

-(void)testCdnHeader {
    NSString *testCdn = @"testCdn";
    
    YBTestableCdnSwitchParser * parser = [[YBTestableCdnSwitchParser alloc] initWithIsCdnSwitchHeader:TRUE andCdnTTL:60];
    parser.mockRequest = mock([YBRequest class]);
    
    [parser start:@"test"];
    
    HCArgumentCaptor * argumentCaptor = [HCArgumentCaptor new];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
         [verifyCount(parser.mockRequest, times(1)) addRequestSuccessListener:(id) argumentCaptor];
           
           YBRequestSuccessBlock successBlock = argumentCaptor.value;
           
           NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc]
                                          initWithURL:mock([NSURL class])
                                          statusCode:200
                                          HTTPVersion:@""
                                          headerFields:@{
                                              @"x-cdn":testCdn
                                          }];
           
           
           successBlock(nil, response, [[NSMutableDictionary alloc] init]);
    });
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Testing cdn"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        XCTAssertTrue([[parser getLastKnownCdn] isEqualToString:testCdn]);
        [expectation fulfill];
    });
    
    
    [self waitForExpectationsWithTimeout:2.0 handler:nil];
}

-(void)testCdnSwitchHeader {
    NSString *testCdn = @"testCdn";
    NSString *testCdnLast = @"testCdnLast";
    
    YBTestableCdnSwitchParser * parser = [[YBTestableCdnSwitchParser alloc] initWithIsCdnSwitchHeader:TRUE andCdnTTL:2];
    parser.mockRequest = mock([YBRequest class]);
    
    [parser start:@"test"];
    
    HCArgumentCaptor * argumentCaptor = [HCArgumentCaptor new];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
         [verifyCount(parser.mockRequest, times(1)) addRequestSuccessListener:(id) argumentCaptor];
           
           YBRequestSuccessBlock successBlock = argumentCaptor.value;
           
           NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc]
                                          initWithURL:mock([NSURL class])
                                          statusCode:200
                                          HTTPVersion:@""
                                          headerFields:@{
                                              @"x-cdn":testCdn
                                          }];
           
           
           successBlock(nil, response, [[NSMutableDictionary alloc] init]);
    });
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Testing cdn"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        XCTAssertTrue([[parser getLastKnownCdn] isEqualToString:testCdn]);
        YBRequestSuccessBlock successBlock = argumentCaptor.value;
        NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc]
                                       initWithURL:mock([NSURL class])
                                       statusCode:200
                                       HTTPVersion:@""
                                       headerFields:@{
                                           @"x-cdn":testCdnLast
                                       }];
        
        
        successBlock(nil, response, [[NSMutableDictionary alloc] init]);
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2.0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        XCTAssertTrue([[parser getLastKnownCdn] isEqualToString:testCdnLast]);
        [expectation fulfill];
    });
    
    
    [self waitForExpectationsWithTimeout:3.0 handler:nil];
}

-(void)testNoUpdateCdnSwitchHeaderCaseNoCdn {
    NSString *testCdn = @"testCdn";
    
    YBTestableCdnSwitchParser * parser = [[YBTestableCdnSwitchParser alloc] initWithIsCdnSwitchHeader:TRUE andCdnTTL:2];
    parser.mockRequest = mock([YBRequest class]);
    
    [parser start:@"test"];
    
    HCArgumentCaptor * argumentCaptor = [HCArgumentCaptor new];
    
   dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
         [verifyCount(parser.mockRequest, times(1)) addRequestSuccessListener:(id) argumentCaptor];
           
           YBRequestSuccessBlock successBlock = argumentCaptor.value;
           
           NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc]
                                          initWithURL:mock([NSURL class])
                                          statusCode:200
                                          HTTPVersion:@""
                                          headerFields:@{
                                              @"x-cdn":testCdn
                                          }];
           
           
           successBlock(nil, response, [[NSMutableDictionary alloc] init]);
    });
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Testing cdn"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        XCTAssertTrue([[parser getLastKnownCdn] isEqualToString:testCdn]);
        
        YBRequestSuccessBlock successBlock = argumentCaptor.value;
        
        NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc]
                                       initWithURL:mock([NSURL class])
                                       statusCode:200
                                       HTTPVersion:@""
                                       headerFields:@{}];
        
        
        successBlock(nil, response, [[NSMutableDictionary alloc] init]);
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2.0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        XCTAssertTrue([[parser getLastKnownCdn] isEqualToString:testCdn]);
        [expectation fulfill];
    });
    
    
    [self waitForExpectationsWithTimeout:3.0 handler:nil];
}


@end
