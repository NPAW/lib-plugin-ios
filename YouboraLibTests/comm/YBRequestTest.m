//
//  YBRequestTest.m
//  YouboraLib
//
//  Created by Joan on 16/03/2017.
//  Copyright © 2017 NPAW. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "YBRequest.h"
#import "YBTestableRequest.h"

#import <OCMockito/OCMockito.h>
#import <OCHamcrest/OCHamcrest.h>
#import "YouboraLib/YouboraLib-Swift.h"

typedef void (^DataTaskCompletionCallbackType) (NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error);


@interface YBRequestTest : XCTestCase

@end

@implementation YBRequestTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testGetUrl {
    YBRequest * r = [[YBRequest alloc] initWithHost:@"http://host.com" andService:@"/service"];
    
    XCTAssertEqualObjects(@"http://host.com/service", [r getUrl].absoluteString);
    
    r.params = [@{YBConstantsRequest.param1:@"value1",YBConstantsRequest.param2:@"2",YBConstantsRequest.param3:@"23.5",@"json":@"{\"jsonkey\":\"jsonvalue\",\"jsonkey2\":\"jsonvalue2\"}"} mutableCopy];
    
    // Decode
    NSString * url = [[r getUrl].absoluteString stringByRemovingPercentEncoding];
    
    XCTAssert([url containsString:@"param1=value1"]);
    XCTAssert([url containsString:@"param2=2"]);
    XCTAssert([url containsString:@"param3=23.5"]);
    XCTAssert([url containsString:@"json={"]);
    XCTAssert([url containsString:@"\"jsonkey\":\"jsonvalue\""]);
    XCTAssert([url containsString:@"\"jsonkey2\":\"jsonvalue2\""]);

}

- (void) testRequestParams {
    YBRequest * r = [[YBRequest alloc] initWithHost:@"http://host.com" andService:@"/service"];
    [r setParam:@"value" forKey:@"key"];
    XCTAssertNotNil(r.params[@"key"]);
    [r setParam:@"value2" forKey:@"key2"];
    XCTAssertNotNil(r.params[@"key2"]);
}

- (void)testSendSuccessRequest {
    
    YBTestableRequest * r = [[YBTestableRequest alloc] initWithHost:@"http://host.com" andService:@"/service"];
    r.mockRequest = mock([NSMutableURLRequest class]);
    
    NSString * headerName = @"headerName";
    NSString * headerValue = @"headerValue";
    
    r.requestHeaders = @{headerName:headerValue};
    
    NSData * mockData = [@"Data" dataUsingEncoding:NSUTF8StringEncoding];
    NSURLResponse * mockResponse = mock([NSHTTPURLResponse class]);
    __block int callbacks = 0;
    
    // Set callbacks
    YBRequestSuccessBlock successBlock = ^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSDictionary<NSString *, id> * _Nullable listenerParams) {
        XCTAssertEqualObjects(mockData, data);
        XCTAssertEqualObjects(response, mockResponse);
        callbacks++;
    };
    
    YBRequestErrorBlock errorBlock = ^(NSError * _Nullable error) {
        XCTFail(@"YBRequestErrorBlock called when it shouldn't have.");
    };
    
    [r addRequestSuccessListener:successBlock];
    [YBRequest addEveryRequestSuccessListener:successBlock];
    
    [r addRequestErrorListener:errorBlock];
    [YBRequest addEveryRequestErrorListener:errorBlock];
    
    // Mock session singleton
    __strong Class mockSessionClass = mockClass([NSURLSession class]);
    NSURLSession * mockSession = mock([NSURLSession class]);
    stubSingleton(mockSessionClass, sharedSession);
    [given([NSURLSession sharedSession]) willReturn:mockSession];
    
    // Send request
    [r send];
    
    // Verify request headers are set
    [verify(r.mockRequest) setAllHTTPHeaderFields:equalTo(r.requestHeaders)];
    
    // Capture urlrequest and callback
    HCArgumentCaptor * urlCaptor = [HCArgumentCaptor new];
    HCArgumentCaptor * handlerCaptor = [HCArgumentCaptor new];

    [verifyCount(mockSession, times(1)) dataTaskWithRequest:(id)urlCaptor completionHandler:(id)handlerCaptor];
    
    NSURLRequest * urlrequest = (NSURLRequest *) urlCaptor.value;
    DataTaskCompletionCallbackType callback = (DataTaskCompletionCallbackType) handlerCaptor.value;
    
    XCTAssertEqualObjects(r.mockRequest, urlrequest);
    
    // Simulate request response
    callback(mockData, mockResponse, nil);
    
    XCTAssertEqual(2, callbacks);
    
    // Stop mocking singleton
    stopMocking(mockSessionClass);
    mockSessionClass = nil;
}

- (void)testSendErrorRequest {
    YBTestableRequest * r = [[YBTestableRequest alloc] initWithHost:@"http://host.com" andService:@"/service"];
    r.mockRequest = mock([NSMutableURLRequest class]);
    
    NSError * mockError = mock([NSError class]);
    __block int callbacks = 0;
    
    // Set callbacks
    YBRequestSuccessBlock successBlock = ^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSDictionary<NSString *, id> * _Nullable listenerParams) {
        XCTFail(@"YBRequestSuccessBlock called when it shouldn't have.");
    };
    
    YBRequestErrorBlock errorBlock = ^(NSError * _Nullable error) {
        XCTAssertEqualObjects(mockError, error);
        callbacks++;
    };
    
    [r addRequestSuccessListener:successBlock];
    [YBRequest addEveryRequestSuccessListener:successBlock];
    
    [r addRequestErrorListener:errorBlock];
    [YBRequest addEveryRequestErrorListener:errorBlock];
    
    // Mock session singleton
    __strong Class mockSessionClass = mockClass([NSURLSession class]);
    NSURLSession * mockSession = mock([NSURLSession class]);
    stubSingleton(mockSessionClass, sharedSession);
    [given([NSURLSession sharedSession]) willReturn:mockSession];
    
    // Send request
    [r send];
    
    // Capture urlrequest and callback
    HCArgumentCaptor * urlCaptor = [HCArgumentCaptor new];
    HCArgumentCaptor * handlerCaptor = [HCArgumentCaptor new];
    
    [verifyCount(mockSession, times(1)) dataTaskWithRequest:(id)urlCaptor completionHandler:(id)handlerCaptor];
    
    NSURLRequest * urlrequest = (NSURLRequest *) urlCaptor.value;
    DataTaskCompletionCallbackType callback = (DataTaskCompletionCallbackType) handlerCaptor.value;
    
    XCTAssertEqualObjects(r.mockRequest, urlrequest);
    
    // Simulate request response
    callback(nil, nil, mockError);
    
    XCTAssertEqual(2, callbacks);
    
    // Stop mocking singleton
    stopMocking(mockSessionClass);
    mockSessionClass = nil;
}

- (void)testRequestFields {
    YBRequest * req = [[YBRequest alloc] initWithHost:@"http://example.com" andService:@"/service"];
    
    // Check default values
    XCTAssertEqualObjects(req.host, @"http://example.com");
    XCTAssertEqualObjects(req.service, @"/service");
    XCTAssertEqualObjects(req.method, YouboraHTTPMethodGet);
    XCTAssertEqualObjects(req.params, nil);
    XCTAssertEqualObjects([req getParam:@"a"], nil);
    
    // Change properties
    req.host = @"http://abc.com";
    req.service = @"/anotherService";
    req.method = YouboraHTTPMethodDelete;
    req.maxRetries = 10;
    req.retryInterval = 10000;
    req.params = [@{YBConstantsRequest.param1:@"value1", YBConstantsRequest.param2:@"value2", YBConstantsRequest.param3:@"value3"} mutableCopy];
    [req setParam:@"value4" forKey:YBConstantsRequest.param4];
    req.requestHeaders = @{@"header1":@"valueheader1", @"header2":@"valueheader2"};
    
    // Check new values
    XCTAssertEqualObjects(req.host, @"http://abc.com");
    XCTAssertEqualObjects(req.service, @"/anotherService");
    XCTAssertEqualObjects(req.method, YouboraHTTPMethodDelete);
    XCTAssertEqual(req.maxRetries, 10);
    XCTAssertEqual(req.retryInterval, 10000);
    
    NSDictionary * params = req.params;
    XCTAssertEqual(4, params.count);
    XCTAssertEqualObjects(@"value1", params[YBConstantsRequest.param1]);
    XCTAssertEqualObjects(@"value2", params[YBConstantsRequest.param2]);
    XCTAssertEqualObjects(@"value3", params[YBConstantsRequest.param3]);
    XCTAssertEqualObjects(@"value4", params[YBConstantsRequest.param4]);
    
    NSDictionary * reqHeaders = req.requestHeaders;
    XCTAssertEqualObjects(@"valueheader1", reqHeaders[@"header1"]);
    XCTAssertEqualObjects(@"valueheader2", reqHeaders[@"header2"]);
    
    XCTAssertNil([req getParam:@"unexisting_key"]);
}

- (void)testAddRemoveListeners {
    
    __block int successCallbacks = 0;
    __block int errorCallbacks = 0;
    
    YBRequest * r = [[YBRequest alloc] initWithHost:@"http://host.com" andService:@"/service"];
    
    // Set callbacks
    YBRequestSuccessBlock successBlock1 = ^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSDictionary<NSString *, id> * _Nullable listenerParams) {
        successCallbacks++;
    };
    
    YBRequestSuccessBlock successBlock2 = ^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSDictionary<NSString *, id> * _Nullable listenerParams) {
        XCTFail(@"Unregistered YBRequestSuccessBlock block called");
    };
    
    YBRequestErrorBlock errorBlock1 = ^(NSError * _Nullable error) {
        errorCallbacks++;
    };
    
    YBRequestErrorBlock errorBlock2 = ^(NSError * _Nullable error) {
        XCTFail(@"Unregistered YBRequestErrorBlock block called");
    };
    
    // Success listeners
    [r addRequestSuccessListener:successBlock1];
    [YBRequest addEveryRequestSuccessListener:successBlock1];
    [r addRequestSuccessListener:successBlock2];
    [YBRequest addEveryRequestSuccessListener:successBlock2];
    
    [r removeRequestSuccessListener:successBlock2];
    [YBRequest removeEveryRequestSuccessListener:successBlock2];
    
    // Error listeners
    [r addRequestErrorListener:errorBlock1];
    [YBRequest addEveryRequestErrorListener:errorBlock1];
    [r addRequestErrorListener:errorBlock2];
    [YBRequest addEveryRequestErrorListener:errorBlock2];
    
    [r removeRequestErrorListener:errorBlock2];
    [YBRequest removeEveryRequestErrorListener:errorBlock2];
    
    // Mock session singleton
    __strong Class mockSessionClass = mockClass([NSURLSession class]);
    NSURLSession * mockSession = mock([NSURLSession class]);
    stubSingleton(mockSessionClass, sharedSession);
    [given([NSURLSession sharedSession]) willReturn:mockSession];
    
    // Send request
    [r send];
    
    // Capture callback
    HCArgumentCaptor * handlerCaptor = [HCArgumentCaptor new];
    
    [verifyCount(mockSession, times(1)) dataTaskWithRequest:anything() completionHandler:(id)handlerCaptor];
    
    DataTaskCompletionCallbackType callback = (DataTaskCompletionCallbackType) handlerCaptor.value;
    
    // Success
    callback(nil, nil, nil);
    
    XCTAssertEqual(2, successCallbacks);
    
    // Error
    callback(nil, nil, mock([NSError class]));
    
    XCTAssertEqual(2, errorCallbacks);
}

- (void) testRequestBody {
    YBTestableRequest * r = [[YBTestableRequest alloc] initWithHost:@"http://host.com" andService:@"/service"];
    r.mockRequest = mock([NSMutableURLRequest class]);
    
    r.body = @"body";
    r.method = YouboraHTTPMethodPost;
    
    // Mock session singleton
    __strong Class mockSessionClass = mockClass([NSURLSession class]);
    NSURLSession * mockSession = mock([NSURLSession class]);
    stubSingleton(mockSessionClass, sharedSession);
    [given([NSURLSession sharedSession]) willReturn:mockSession];
    
    // Send request
    [r send];
    
    // Verify request body is not null
    [verify(r.mockRequest) setHTTPBody:equalTo([r.body dataUsingEncoding:NSUTF8StringEncoding])];
    
    
    // Stop mocking singleton
    stopMocking(mockSessionClass);
    mockSessionClass = nil;
}

@end
