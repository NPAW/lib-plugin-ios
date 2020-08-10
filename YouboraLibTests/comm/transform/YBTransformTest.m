//
//  YBTransformTest.m
//  YouboraLib
//
//  Created by Joan on 20/03/2017.
//  Copyright © 2017 NPAW. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "YBTransform.h"
#import "YBTransformSubclass.h" // Category

#import "YBRequest.h"

#import <OCMockito/OCMockito.h>

// YBTransform Category for testing purposes
@implementation YBTransform (YBTransformTestAdditions)
- (void) callDone {
    [self done];
}
@end

@interface YBTransformTest : XCTestCase

@property (nonatomic, strong) YBTransform * t;

/// Instance of YBTransform received in the callback;
@property (nonatomic, strong) YBTransform * callbackTransform;

@end

@implementation YBTransformTest

- (void)setUp {
    [super setUp];
    self.t = [YBTransform new];
    self.callbackTransform = nil;
}

- (void)tearDown {
    self.t = nil;
    [super tearDown];
}

- (void)testBusyInitial {
    XCTAssertTrue([self.t isBlocking:mock([YBRequest class])]);
    XCTAssertTrue([self.t isBlocking:nil]);
}

- (void)testBusyAfterDone {
    [self.t callDone];
    XCTAssertFalse([self.t isBlocking:mock([YBRequest class])]);
    XCTAssertFalse([self.t isBlocking:nil]);
}

- (void)testListenerCalled {
    [self.t addTranformDoneObserver:self andSelector:@selector(transformDone:)];
    
    [self.t callDone];
    
    XCTAssertEqualObjects(self.t, self.callbackTransform);
}

- (void)testListenerNotCalledAfterRemoveListener {
    [self.t addTranformDoneObserver:self andSelector:@selector(transformDone:)];
    [self.t removeTranformDoneObserver:self];
    
    [self.t callDone];
    
    XCTAssertNil(self.callbackTransform);
}

- (void) transformDone:(NSNotification *)notification {
    self.callbackTransform = notification.object;
}


@end
