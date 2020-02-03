//
//  YBFlowTransform.m
//  YouboraLib
//
//  Created by Joan on 20/03/2017.
//  Copyright © 2017 NPAW. All rights reserved.
//

#import "YBFlowTransform.h"
#import "YBRequest.h"
#import "YouboraLib/YouboraLib-Swift.h"

@implementation YBFlowTransform

static NSArray<NSString *> * EXPECTED_SERVICES;

- (instancetype)init
{
    self = [super init];
    if (self) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            EXPECTED_SERVICES = @[ YBConstantsYouboraService.sInit, YBConstantsYouboraService.start, YBConstantsYouboraService.offline, YBConstantsYouboraInfinity.sessionStart];
        });
    }
    return self;
}

/**
 * Blocks all the requests until an /init or a /start is found.
 * The only exception to this logic is the /error, that can be sent at any time
 * @param request request that's about to be sent
 */
- (bool)isBlocking:(YBRequest *)request {
    if (self.isBusy && request != nil) {
        if ([EXPECTED_SERVICES containsObject:request.service]) {
            self.isBusy = false;
        } else if ([YBConstantsYouboraService.error isEqualToString:request.service]) {
            // If it's an error we make an exception and bypass the block
            return false;
        }
    }
    return [super isBlocking:request];
}

@end
