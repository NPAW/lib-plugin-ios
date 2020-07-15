//
//  YBTestableCdnParser.m
//  YouboraLib
//
//  Created by Joan on 04/04/2017.
//  Copyright © 2017 NPAW. All rights reserved.
//

#import "YBTestableCdnParser.h"
#import "YouboraLib/YouboraLib-Swift.h"

#import <OCMockito/OCMockito.h>

@implementation YBTestableCdnParser


- (YBRequest *) createRequestWithHost:(nullable NSString *) host andService:(nullable NSString *) service {
    
    self.mockRequest = [[YBTestableRequest alloc] initWithHost:host service:service];
    
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
