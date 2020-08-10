//
//  YBCommunicationTest.m
//  YouboraLib
//
//  Created by Joan on 20/03/2017.
//  Copyright © 2017 NPAW. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "YBCommunication.h"

#import "YBTransform.h"
#import "YBTestableTranform.h"

#import <OCMockito/OCMockito.h>
#import <OCHamcrest/OCHamcrest.h>

@interface YBCommunicationTest : XCTestCase

@property(nonatomic, strong) YBCommunication * c;

@end

@implementation YBCommunicationTest

- (void)setUp {
    [super setUp];
    self.c = [YBCommunication new];
}

- (void)tearDown {
    self.c = nil;
    [super tearDown];
}

- (void)testAddTransform {
    YBTransform * mockTransform = mock([YBTransform class]);

    [self.c addTransform:mockTransform];
    
    [verifyCount(mockTransform, times(1)) addTranformDoneObserver:is(self.c) andSelector:@selector(transformDone:)];
}

- (void)testSendRequest {
    YBRequest * mockRequest = mock([YBRequest class]);
    
    [self.c sendRequest:mockRequest withCallback:nil];
    
    [verifyCount(mockRequest, times(1)) send];
}


- (void)testTransformNotBlocking {
    YBTransform * mockTransform = mock([YBTransform class]);
    [self.c addTransform:mockTransform];

    [given([mockTransform isBlocking:anything()]) willReturn:@(false)];
    
    YBRequest * mockRequest = mock([YBRequest class]);
    [self.c sendRequest:mockRequest withCallback:nil];
    
    [verifyCount(mockTransform, times(1)) isBlocking:equalTo(mockRequest)];
    [verifyCount(mockTransform, times(1)) parse:equalTo(mockRequest)];
    [verifyCount(mockRequest, times(1)) send];
}

- (void)testTransformBlocking {
    YBTransform * mockTransform = mock([YBTransform class]);
    [self.c addTransform:mockTransform];
    
    [given([mockTransform isBlocking:anything()]) willReturn:@(true)];
    
    YBRequest * mockRequest = mock([YBRequest class]);
    [self.c sendRequest:mockRequest withCallback:nil];
    
    [verifyCount(mockTransform, times(1)) isBlocking:equalTo(mockRequest)];
    [verifyCount(mockTransform, never()) parse:anything()];
    [verifyCount(mockRequest, never()) send];
}

- (void)testRemoveTransform {
    YBTransform * t = mock([YBTransform class]);
    
    [self.c addTransform:t];
    [self.c removeTransform:t];
    
    // Try to remove non existent transforms, no exception should be risen
    [self.c removeTransform:nil];
    [self.c removeTransform:mock([YBTransform class])];
}

- (void) transformDone:(NSNotification *)notification {
}

- (void)testTransformCallback {
    
    YBTestableTranform * t = [YBTestableTranform new];
    
    XCTAssertTrue([t isBlocking:anything()]);
    
    [self.c addTransform:t]; // Callback set here
    
    XCTAssertFalse([t parseCalled]);
    
    YBRequest * mockRequest = mock([YBRequest class]);
    
    [self.c sendRequest:mockRequest withCallback:nil];
    
    XCTAssertFalse([t parseCalled]);
    
    [t forceDone];
    
    // Transform done
    XCTAssertFalse([t isBlocking:anything()]);

    // Transform done should trigger request processing and thus
    // the transforms parsing
    XCTAssertTrue([t parseCalled]);
}

@end
