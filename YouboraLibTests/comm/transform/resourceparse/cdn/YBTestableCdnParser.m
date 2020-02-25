//
//  YBTestableCdnParser.m
//  YouboraLib
//
//  Created by Joan on 04/04/2017.
//  Copyright © 2017 NPAW. All rights reserved.
//

#import "YBTestableCdnParser.h"
#import "YBRequest.h"

#import <OCMockito/OCMockito.h>

@implementation YBTestableCdnParser

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.mockRequest = mock([YBRequest class]);
    }
    return self;
}

- (YBRequest *) createRequestWithHost:(nullable NSString *) host andService:(nullable NSString *) service {
    
    [self.mockRequest setHost:host];
    [self.mockRequest setService:service];
    
    return self.mockRequest;
}

+ (YBCdnParser *)createWithName:(NSString *)cdnName {
    YBCdnConfig * cdnConfig = [YBCdnParser definedCdns][cdnName];
    if (cdnConfig == nil) {
        return nil;
    } else {
        return [[YBTestableCdnParser alloc] initWithCdnConfig:cdnConfig];
    }
}

@end
