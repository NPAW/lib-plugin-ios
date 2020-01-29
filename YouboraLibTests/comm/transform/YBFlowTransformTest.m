//
//  YBFlowTransformTest.m
//  YouboraLib
//
//  Created by Joan on 20/03/2017.
//  Copyright © 2017 NPAW. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "YBFlowTransform.h"

#import "YBRequest.h"

#import <OCMockito/OCMockito.h>
#import "YouboraLib/YouboraLib-Swift.h"

@interface YBFlowTransformTest : XCTestCase

@property (nonatomic, strong) YBFlowTransform * ft;

@end

@implementation YBFlowTransformTest

-(void)setUp {
    self.ft = [YBFlowTransform new];
}

- (void)tearDown {
    self.ft = nil;
}

- (void)testIsBlocking {
    
    // Stub
    YBRequest * blockingRequest = mock([YBRequest class]);
    stubProperty(blockingRequest, service, @"/service");
    
    YBRequest * initRequest = mock([YBRequest class]);
    stubProperty(initRequest, service, YBConstantsYouboraService.sInit);
    
    YBRequest * startRequest = mock([YBRequest class]);
    stubProperty(startRequest, service, YBConstantsYouboraService.start );
    
    YBRequest * errorRequest = mock([YBRequest class]);
    stubProperty(errorRequest, service, YBConstantsYouboraService.error);
    
    // Init and start should unlock the transform, but error only bypass it
    
    // init
    XCTAssertFalse([self.ft isBlocking:initRequest]);
    XCTAssertFalse([self.ft isBlocking:blockingRequest]);
    
    // start
    self.ft = [YBFlowTransform new];
    XCTAssertFalse([self.ft isBlocking:startRequest]);
    XCTAssertFalse([self.ft isBlocking:blockingRequest]);
    
    // error
    self.ft = [YBFlowTransform new];
    XCTAssertFalse([self.ft isBlocking:errorRequest]);
    XCTAssertTrue([self.ft isBlocking:blockingRequest]);
}

- (void)testParseShouldDoNothing {
    
    YBRequest * startRequest = mock([YBRequest class]);
    
    stubProperty(startRequest, service, YBConstantsYouboraService.start);
    
    [self.ft parse:startRequest];
    XCTAssertTrue([self.ft isBlocking:nil]);
    
    [self.ft parse:nil];
    XCTAssertTrue([self.ft isBlocking:nil]);
}

@end
