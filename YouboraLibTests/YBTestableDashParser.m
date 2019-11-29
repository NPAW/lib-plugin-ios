//
//  YBTestableDashParser.m
//  YouboraLib
//
//  Created by nice on 26/11/2019.
//  Copyright © 2019 NPAW. All rights reserved.
//

#import "YBTestableDashParser.h"
#import <OCMockito/OCMockito.h>
#import "YBRequest.h"

@implementation YBTestableDashParser

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
