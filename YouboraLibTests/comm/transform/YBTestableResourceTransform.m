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

@property NSString *transportFormat;

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

-(void)requestAndParse:(id<YBResourceParser> _Nullable)parser currentResource:(NSString*)resource userDefinedTransportFormat:(NSString* _Nullable)definedTransportFormat{
    if (!self.delegate) {
        [self parse:[self getNextParser:parser] currentResource:resource userDefinedTransportFormat:definedTransportFormat];
        self.iteration ++;
        return;
    }
    
    NSData *data = [self.delegate getDataForIteration:self.iteration];
    NSHTTPURLResponse *response = [self.delegate getResponseForIteration:self.iteration];
    
    if (![parser isSatisfiedWithResource:resource manifest:data]) {
        self.iteration ++;
        [self parse:[self getNextParser:parser] currentResource:resource userDefinedTransportFormat:definedTransportFormat];
    } else {
        NSString *newResource = [parser parseResourceWithData:data response:(NSHTTPURLResponse*)response listenerParents:nil];
        NSString *transportFormat = [parser parseTransportFormatWithData:data response:(NSHTTPURLResponse*)response listenerParents:nil userDefinedTransportFormat: definedTransportFormat];
        
        if (transportFormat) {
            self.transportFormat = transportFormat;
        }
        if (!newResource) {
             self.iteration ++;
            [self parse:[self getNextParser:parser] currentResource:resource userDefinedTransportFormat:definedTransportFormat];
        } else {
             self.iteration ++;
            [self parse:parser currentResource:newResource userDefinedTransportFormat:definedTransportFormat];
        }
    }
}

@end
