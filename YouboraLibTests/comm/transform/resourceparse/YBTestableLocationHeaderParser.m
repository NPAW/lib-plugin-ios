//
//  YBTestableLocationHeaderParser.m
//  YouboraLib
//
//  Created by Tiago Pereira on 24/02/2020.
//  Copyright © 2020 NPAW. All rights reserved.
//

#import "YBTestableLocationHeaderParser.h"
#import <OCMockito/OCMockito.h>
#import "YBRequest.h"

@implementation YBTestableLocationHeaderParser

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.mockRequest = mock([YBRequest class]);
    }
    return self;
}

- (void)createRequestWithHost:(NSString *)host service:(NSString *)service success:(Success)success failure:(Failure)failure {
    [self.mockRequest setHost:host];
    [self.mockRequest setService:service];
    
    [self.mockRequest addRequestSuccessListener:success];
    
    [self.mockRequest addRequestErrorListener:failure];
    
    [self.mockRequest send];
}


@end
