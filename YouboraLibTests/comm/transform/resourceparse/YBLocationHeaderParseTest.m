//
//  YBLocationHeaderParseTest.m
//  YouboraLib
//
//  Created by Tiago Pereira on 24/02/2020.
//  Copyright © 2020 NPAW. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCHamcrest/OCHamcrest.h>
#import <OCMockito/OCMockito.h>
#import "YBTestableLocationHeaderParser.h"
#import "YBRequest.h"

@interface YBLocationHeaderParseTest : XCTestCase

@property YBTestableLocationHeaderParser *parser;
@property YBRequest *mockRequest;
@property NSHTTPURLResponse *response;

@end

@implementation YBLocationHeaderParseTest

-(void)setUp {
    self.parser = [YBTestableLocationHeaderParser new];
    self.mockRequest = self.parser.mockRequest;
   
    
    self.response = [[NSHTTPURLResponse alloc] initWithURL:[[NSURL alloc] initWithString:@""] statusCode:200 HTTPVersion:nil headerFields:nil];
}

- (void)testInitialValue {
    YBTestableLocationHeaderParser *dashParser = [YBTestableLocationHeaderParser new];
    
    XCTAssertNil([dashParser resource]);
}

-(void)testParseLocaiton {
    HCArgumentCaptor *captor = [HCArgumentCaptor new];
    [verifyCount(self.mockRequest, times(1)) addRequestSuccessListener:(id)captor];
    
    YBRequestSuccessBlock successBlock = captor.value;
    
    // Invoke callback
    successBlock([NSData new], self.response, [[NSMutableDictionary alloc] init]);
    
    [self.parser parseResource:@"" completion:^(NSString * _Nonnull finalResource) {
        XCTAssertNil(finalResource);
    } failure:^(NSError * _Nonnull error) {
        XCTAssertNil([self.parser resource]);
    }];
}


@end
