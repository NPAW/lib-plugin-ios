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

#import <OCMockito/OCMockito.h>
#import "YouboraLib/YouboraLib-Swift.h"

// YBTransform Category for testing purposes
@implementation YBTransform (YBTransformTestAdditions)
- (void) callDone {
    [self done];
}
@end

@interface YBTransformTest : XCTestCase<YBTransformDoneListener>

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
    [self.t addTransformDoneListener:self];
    
    [self.t callDone];
    
    XCTAssertEqualObjects(self.t, self.callbackTransform);
}

- (void)testListenerNotCalledAfterRemoveListener {
    [self.t addTransformDoneListener:self];
    [self.t removeTransformDoneListener:self];
    
    [self.t callDone];
    
    XCTAssertNil(self.callbackTransform);
}

// TransformDoneListener protocol
- (void) transformDone:(YBTransform *)transform {
    self.callbackTransform = transform;
}


@end
