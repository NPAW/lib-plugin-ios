//
//  YBTestableResourceTransform.m
//  YouboraLib
//
//  Created by Joan on 05/04/2017.
//  Copyright © 2017 NPAW. All rights reserved.
//

#import "YBTestableResourceTransform.h"
#import <OCMockito/OCMockito.h>
#import "YouboraLib/YouboraLib-Swift.h"

@interface YBTestableResourceTransform()

@end

@implementation YBTestableResourceTransform

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.mockCdnParser = mock([YBCdnParser class]);
        self.mockTimer = mock([NSTimer class]);
        self.iteration = 0;
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

-(void)requestAndParse:(id<YBResourceParser> _Nullable)parser currentResource:(NSString*)resource {
    if (!self.delegate) {
        [self parse:[self getNextParser:parser] currentResource:resource];
        self.iteration ++;
        return;
    }
    
    NSData *data = [self.delegate getDataForIteration:self.iteration];
    NSHTTPURLResponse *response = [self.delegate getResponseForIteration:self.iteration];
    NSString *newResource = [parser parseResourceWithData:data response:(NSHTTPURLResponse*)response listenerParents:nil];
    
    self.iteration ++;
    if (!newResource) {
        [self parse:[self getNextParser:parser] currentResource:resource];
    } else {
        [self parse:parser currentResource:newResource];
    }
}

@end
