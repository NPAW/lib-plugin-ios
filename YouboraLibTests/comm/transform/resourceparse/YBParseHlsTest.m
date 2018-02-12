//
//  YBParseHlsTest.m
//  YouboraLib
//
//  Created by Joan on 03/04/2017.
//  Copyright © 2017 NPAW. All rights reserved.
//

#import <XCTest/XCTest.h>

#import <OCMockito/OCMockito.h>
#import <OCHamcrest/OCHamcrest.h>

#import "YBTestableHlsParser.h"
#import "YBRequest.h"

#define TOP_LEVEL_MANIFEST @"http://qthttp.apple.com.edgesuite.net/1010qwoeiuryfg/sl.m3u8"
#define EXPECTED_FINAL_RESOURCE @"http://qthttp.apple.com.edgesuite.net/1010qwoeiuryfg/0640/06400.ts"

@interface YBParseHlsTest : XCTestCase<HlsTransformDoneDelegate>

@property (nonatomic, copy) void (^hlsDoneBlock)(NSString * resource, YBHlsParser * parser);

@end

@implementation YBParseHlsTest

- (void)testInitialValue {
    YBHlsParser * hlsParser = [YBHlsParser new];
    
    XCTAssertNil([hlsParser getResource]);
}

- (void)testFlow {
    YBTestableHlsParser * parser = [YBTestableHlsParser new];
    
    // Get mock request
    YBRequest * mockRequest = parser.mockRequest;
    
    // Start parsing
    [parser parse:TOP_LEVEL_MANIFEST parentResource:nil];
    
    // Capture request callback
    HCArgumentCaptor * captor = [HCArgumentCaptor new];
    [verifyCount(mockRequest, times(1)) addRequestSuccessListener:(id)captor];
    
    YBRequestSuccessBlock successBlock = captor.value;
    
    NSString * responseString = @"#EXTM3U\n\
                                #EXT-X-STREAM-INF:PROGRAM-ID=1, BANDWIDTH=688301\n\
                                http://qthttp.apple.com.edgesuite.net/1010qwoeiuryfg/0640_vod.m3u8\n\
                                #EXT-X-STREAM-INF:PROGRAM-ID=1, BANDWIDTH=165135\n\
                                http://qthttp.apple.com.edgesuite.net/1010qwoeiuryfg/0150_vod.m3u8\n";
    
    // Invoke callback
    successBlock([responseString dataUsingEncoding:NSUTF8StringEncoding], mock([NSURLResponse class]), [[NSMutableDictionary alloc] init]);
    
    // Recursive call has been performed, capture again
    [verifyCount(mockRequest, times(1)) addRequestSuccessListener:(id)captor];

    successBlock = captor.value;
    
    responseString = @"#EXTM3U\n\
                #EXT-X-TARGETDURATION:10\n\
                #EXT-X-MEDIA-SEQUENCE:0\n\
                #EXTINF:10,\n\
                0640/06400.ts\n\
                #EXTINF:10,\n\
                0640/06401.ts\n";
    
    // Invoke callback
    successBlock([responseString dataUsingEncoding:NSUTF8StringEncoding], mock([NSURLResponse class]), [[NSMutableDictionary alloc] init]);
    
    XCTAssertEqualObjects(EXPECTED_FINAL_RESOURCE, [parser getResource]);

}

- (void)testListenerSuccess {
    YBHlsParser * parser = [YBHlsParser new];
    
    static bool callbackInvoked = false;
    
    self.hlsDoneBlock = ^(NSString * resource, YBHlsParser * parser) {
        callbackInvoked = true;
    };
    
    // Add listener
    [parser addHlsTransformDoneDelegate:self];

    // Start parsing with final resource (doesn't need parsing)
    [parser parse:EXPECTED_FINAL_RESOURCE parentResource:nil];
    
    XCTAssertTrue(callbackInvoked);
    XCTAssertEqualObjects(EXPECTED_FINAL_RESOURCE, [parser getResource]);
}

- (void)testNonHlsUrl {
    YBTestableHlsParser * parser = [YBTestableHlsParser new];
    
    static bool callbackInvoked = false;
    
    self.hlsDoneBlock = ^(NSString * resource, YBHlsParser * parser) {
        callbackInvoked = true;
    };
    
    // Add listener
    [parser addHlsTransformDoneDelegate:self];
    
    // Start parsing
    NSString * mp4Url = @"http://www.example.com/path/resource.mp4";
    [parser parse:mp4Url parentResource:nil];
    
    XCTAssertTrue(callbackInvoked);
    XCTAssertEqualObjects(mp4Url, [parser getResource]);

}

- (void)testInvalidResource {
    YBTestableHlsParser * parser = [YBTestableHlsParser new];
    
    static bool callbackInvoked = false;
    
    self.hlsDoneBlock = ^(NSString * resource, YBHlsParser * parser) {
        callbackInvoked = true;
    };
    
    // Add listener
    [parser addHlsTransformDoneDelegate:self];
    
    // Start parsing
    NSString * mp4Url = @"http://www.example.com/path/resourcewithnoextension";
    [parser parse:mp4Url parentResource:nil];
    
    XCTAssertTrue(callbackInvoked);
    XCTAssertNil([parser getResource]);
}

- (void)testRemoveCallback {
    YBTestableHlsParser * parser = [YBTestableHlsParser new];
    
    static bool callbackInvoked = false;
    
    self.hlsDoneBlock = ^(NSString * resource, YBHlsParser * parser) {
        callbackInvoked = true;
    };
    
    // Add listener
    [parser addHlsTransformDoneDelegate:self];
    // Remove
    [parser removeHlsTransformDoneDelegate:self];
    
    // Start parsing
    NSString * mp4Url = @"http://www.example.com/path/resource.mp4";
    [parser parse:mp4Url parentResource:nil];
    
    XCTAssertFalse(callbackInvoked);
    XCTAssertEqualObjects(mp4Url, [parser getResource]);
}

- (void)testErrorListener {
    static bool callbackInvoked = false;

    YBTestableHlsParser * parser = [YBTestableHlsParser new];

    // Add listener
    self.hlsDoneBlock = ^(NSString * resource, YBHlsParser * parser) {
        callbackInvoked = true;
    };
    [parser addHlsTransformDoneDelegate:self];

    // Get mock request
    YBRequest * mockRequest = parser.mockRequest;

    // Start parsing
    [parser parse:TOP_LEVEL_MANIFEST parentResource:nil];
    
    // Capture request error callback
    HCArgumentCaptor * captor = [HCArgumentCaptor new];
    [verifyCount(mockRequest, times(1)) addRequestErrorListener:(id)captor];
    
    YBRequestErrorBlock errorBlock = captor.value;
    
    // Mock callback
    errorBlock(mock([NSError class]));
    
    XCTAssertTrue(callbackInvoked);
    
    XCTAssertNil([parser getResource]);
}

// HLS done delegate
- (void) hlsTransformDone:(nullable NSString *) parsedResource fromHlsParser:(YBHlsParser *) parser {
    self.hlsDoneBlock(parsedResource, parser);
}


@end
