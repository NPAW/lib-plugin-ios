//
//  YBDashParseTest.m
//  YouboraLib
//
//  Created by nice on 26/11/2019.
//  Copyright © 2019 NPAW. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCHamcrest/OCHamcrest.h>
#import <OCMockito/OCMockito.h>

#import "YBTestableDashParser.h"
#import "YBRequest.h"
#import "YBParsableResponseHeader.h"

//local url with location
#define INVALID_FILE_URL @"http://192.168.1.101/"
#define WRONG_DASH_FILE_URL @"http://192.168.1.101/asd.mp4"
#define DASH_FILE_URL @"http://192.168.1.101/asd.mpd"
#define EXPECTED_LOCATION @"http://192.168.1.99/actualManifest.mpd"
#define EXPECTED_FINAL_RESOURCE @"https://boltrljDRMTest1-a.akamaihd.net/media/v1/dash/live/cenc/6028583040001/f39ee0f0-72de-479d-9609-2bf6ea95b427/fed9a7f1-499a-469d-bacd-f25a94eac116/"

@interface YBDashParserTest : XCTestCase<DashTransformDoneDelegate>

@property (nonatomic, copy) void (^dashDoneBlock)(NSString * resource, YBDashParser * parser);

@property YBTestableDashParser *parser;
@property YBRequest *mockRequest;
@property NSData *locationResponse;
@property NSData *finalResourceResponse;
@property NSHTTPURLResponse *response;
@end

@implementation YBDashParserTest

-(void)setUp {
    self.parser = [YBTestableDashParser new];
    self.mockRequest = self.parser.mockRequest;
    NSBundle *testBundle = [NSBundle bundleForClass:[self class]];
    self.locationResponse = [[NSData alloc] initWithContentsOfFile:[testBundle pathForResource:@"dashResponse" ofType:@"xml"]];
    self.finalResourceResponse = [[NSData alloc] initWithContentsOfFile:[testBundle pathForResource:@"dashCallbackResponse" ofType:@"xml"]];
    self.response = [[NSHTTPURLResponse alloc] initWithURL:[[NSURL alloc] initWithString:DASH_FILE_URL] statusCode:200 HTTPVersion:nil headerFields:nil];
}

- (void)testInitialValue {
    YBDashParser *dashParser = [YBDashParser new];
    
    XCTAssertNil([dashParser getResource]);
}

-(void)testLocation {
    [self.parser parse:DASH_FILE_URL];
    
    HCArgumentCaptor *captor = [HCArgumentCaptor new];
    [verifyCount(self.mockRequest, times(1)) addRequestSuccessListener:(id)captor];
    
    YBRequestSuccessBlock successBlock = captor.value;
    
    // Invoke callback
    successBlock(self.locationResponse,self.response, [[NSMutableDictionary alloc] init]);
    
    XCTAssertTrue([[self.parser getLocation] isEqualToString:EXPECTED_LOCATION]);
}

-(void)testFinalResource {
    [self.parser parse:DASH_FILE_URL];
    
    HCArgumentCaptor *captor = [HCArgumentCaptor new];
    [verifyCount(self.mockRequest, times(1)) addRequestSuccessListener:(id)captor];
    
    YBRequestSuccessBlock successBlock = captor.value;
    
    // Invoke callback
    successBlock(self.finalResourceResponse,self.response, [[NSMutableDictionary alloc] init]);
    
    XCTAssertTrue([[self.parser getResource] isEqualToString:EXPECTED_FINAL_RESOURCE]);
}

- (void)testListenerSuccess {
    
    static bool callbackInvoked = false;

    self.dashDoneBlock = ^(NSString * resource, YBDashParser *parser) {
        callbackInvoked = true;
    };

    // Add listener
    [self.parser addDashTransformDoneDelegate:self];

    // Start parsing with final resource (doesn't need parsing)
    [self.parser parse:DASH_FILE_URL];
    
    HCArgumentCaptor *captor = [HCArgumentCaptor new];
    [verifyCount(self.mockRequest, times(1)) addRequestSuccessListener:(id)captor];
    
    YBRequestSuccessBlock successBlock = captor.value;
    
    // Invoke callback
    successBlock(self.finalResourceResponse,self.response, [[NSMutableDictionary alloc] init]);

    XCTAssertTrue(callbackInvoked);
}

- (void)testNonHlsUrl {

    static bool callbackInvoked = false;

    self.dashDoneBlock = ^(NSString * resource, YBDashParser *parser) {
        callbackInvoked = true;
    };

    // Add listener
    [self.parser addDashTransformDoneDelegate: self];

    [self.parser parse:WRONG_DASH_FILE_URL];

    XCTAssertTrue(callbackInvoked);
    XCTAssertNil([self.parser getResource]);
}

- (void)testInvalidFileUrl {
    
    static bool callbackInvoked = false;
    
    self.dashDoneBlock = ^(NSString * resource, YBDashParser *parser) {
        callbackInvoked = true;
    };
    
    // Add listener
    [self.parser addDashTransformDoneDelegate: self];
    
    [self.parser parse:INVALID_FILE_URL];
    
    XCTAssertTrue(callbackInvoked);
    XCTAssertNil([self.parser getResource]);
}

- (void)testRemoveCallback {
    
    static bool callbackInvoked = false;
    
    self.dashDoneBlock = ^(NSString * resource, YBDashParser *parser) {
        callbackInvoked = true;
    };
    
    // Add listener
    [self.parser addDashTransformDoneDelegate:self];
    
    // Remove listener
    [self.parser removeDashTransformDoneDelegate:self];
    
    // Start parsing with final resource (doesn't need parsing)
    [self.parser parse:DASH_FILE_URL];
    
    HCArgumentCaptor *captor = [HCArgumentCaptor new];
    [verifyCount(self.mockRequest, times(1)) addRequestSuccessListener:(id)captor];
    
    YBRequestSuccessBlock successBlock = captor.value;
    
    // Invoke callback
    successBlock(self.finalResourceResponse,self.response, [[NSMutableDictionary alloc] init]);
    
    XCTAssertFalse(callbackInvoked);
    XCTAssertTrue([[self.parser getResource] isEqualToString:EXPECTED_FINAL_RESOURCE]);
}

- (void)testErrorListener {
    
    static bool callbackInvoked = false;
    
    self.dashDoneBlock = ^(NSString * resource, YBDashParser *parser) {
        callbackInvoked = true;
    };
    
    // Add listener
    [self.parser addDashTransformDoneDelegate:self];
    
    // Start parsing with final resource (doesn't need parsing)
    [self.parser parse:DASH_FILE_URL];
    
    HCArgumentCaptor *captor = [HCArgumentCaptor new];
    [verifyCount(self.mockRequest, times(1)) addRequestErrorListener:(id)captor];
    
    YBRequestErrorBlock errorBlock = captor.value;
    
    // Invoke callback
    errorBlock(mock([NSError class]));
    
    XCTAssertTrue(callbackInvoked);
    XCTAssertNil([self.parser getResource]);
}

- (void)dashTransformDone:(nullable NSString *)parsedResource fromDashParser:(nonnull YBDashParser *)parser {
    self.dashDoneBlock(parsedResource, parser);
}

@end
