//
//  YBTestableHlsParser.m
//  YouboraLib
//
//  Created by Joan on 03/04/2017.
//  Copyright © 2017 NPAW. All rights reserved.
//

#import "YBTestableHlsParser.h"

#import <OCMockito/OCMockito.h>

#import "YBRequest.h"

@implementation YBTestableHlsParser

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.mockRequest = mock([YBRequest class]);
    }
    return self;
}

- (YBRequest *) createRequestWithHost:(NSString *) host andService:(NSString *) service {
    [self.mockRequest setHost:host];
    [self.mockRequest setService:service];
    
    return self.mockRequest;
}

@end
