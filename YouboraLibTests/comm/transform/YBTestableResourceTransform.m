//
//  YBTestableResourceTransform.m
//  YouboraLib
//
//  Created by Joan on 05/04/2017.
//  Copyright © 2017 NPAW. All rights reserved.
//

#import "YBTestableResourceTransform.h"

#import <OCMockito/OCMockito.h>

@implementation YBTestableResourceTransform

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.mockCdnParser = mock([YBCdnParser class]);
        self.mockTimer = mock([NSTimer class]);
    }
    return self;
}

- (YBCdnParser *) createCdnParser:(NSString *) cdn {
    self.lastCreatedCdnParser = cdn;
    YBCdnParser * parser = self.mockCdnParsers[cdn];
    if (parser == nil) {
        parser = self.mockCdnParser;
    }
    return parser;
}

- (NSTimer *) createNonRepeatingScheduledTimerWithInterval:(NSTimeInterval) interval {
    return self.mockTimer;
}

@end
