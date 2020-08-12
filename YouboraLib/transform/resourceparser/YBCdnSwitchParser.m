//
//  YBCdnSwitchParser.m
//  YouboraLib
//
//  Created by Tiago Pereira on 11/08/2020.
//  Copyright © 2020 NPAW. All rights reserved.
//

#import "YBCdnSwitchParser.h"
#import "YBRequest.h"

#define KEY_FOR_RESOURCE "userInfoResource"
#define CDN_HEADER "x-cdn"
@interface YBCdnSwitchParser ()

@property BOOL cdnSwitchHeader;
@property NSTimeInterval cdnTTL;

@property NSString *lastCdnTracked;
@property NSTimer *parserTimer;
@property NSOperationQueue *fetchCdnQueue;

@end

@implementation YBCdnSwitchParser

-(instancetype)initWithIsCdnSwitchHeader:(BOOL)cdnSwitchHeader andCdnTTL:(NSTimeInterval)cdnTTL {
    self = [super init];
    
    if (self) {
        self.cdnSwitchHeader = cdnSwitchHeader;
        self.cdnTTL = cdnTTL;
        
    }
    
    return self;
}

-(void)start:(NSString*)resource {
    if (!self.cdnSwitchHeader || !resource) { return; }
    
    self.lastCdnTracked = nil;
    
    self.fetchCdnQueue = [NSOperationQueue new];
    self.fetchCdnQueue.name = @"fetchCdnQueue";
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.parserTimer = [NSTimer scheduledTimerWithTimeInterval:9.0 target:self selector:@selector(fetchNewCdn:) userInfo:@{@KEY_FOR_RESOURCE: resource} repeats:true];
    });
}

-(void)fetchNewCdn:(NSTimer*)timer {
    NSString *resource = timer.userInfo[@KEY_FOR_RESOURCE];
    
  
    NSOperation *backgroundOperation = [NSOperation new];
    backgroundOperation.qualityOfService = NSQualityOfServiceBackground;
    backgroundOperation.queuePriority = NSOperationQueuePriorityLow;
    
    
    backgroundOperation.completionBlock = ^{
        YBRequest *request = [self getRequest:resource];
        [request addRequestSuccessListener:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSDictionary<NSString *,id> * _Nullable listenerParams) {
            NSHTTPURLResponse * httpResponse = (NSHTTPURLResponse *) response;
            NSDictionary * responseHeaders = httpResponse.allHeaderFields;
            
            self.lastCdnTracked = responseHeaders[@CDN_HEADER];
        }];
        
        [request send];
    };
    
    [self.fetchCdnQueue addOperation:backgroundOperation];
}

-(YBRequest*)getRequest:(NSString*)resource {
    return [[YBRequest alloc] initWithHost:resource andService:nil];
}

-(NSString*)getLastKnownCdn {
    return self.lastCdnTracked;
}

-(void)invalidate {
    if (self.fetchCdnQueue) {
        [self.fetchCdnQueue cancelAllOperations];
        self.fetchCdnQueue = nil;
    }
    
    if (self.parserTimer) {
        [self.parserTimer invalidate];
        self.parserTimer = nil;
    }
}
@end
