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
@property BOOL valid;
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
    
    self.valid = true;
    
    [self fetchNewCdn:resource];
}

-(void)fetchNewCdn:(NSString*)resource {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, self.cdnTTL * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        if (self.valid) {
            [self fetchNewCdn:resource];
        }
    });
    
    NSOperation *backgroundOperation = [NSOperation new];
    backgroundOperation.qualityOfService = NSQualityOfServiceBackground;
    backgroundOperation.queuePriority = NSOperationQueuePriorityLow;
    
    
    backgroundOperation.completionBlock = ^{
        YBRequest *request = [self getRequest:resource];
        [request addRequestSuccessListener:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSDictionary<NSString *,id> * _Nullable listenerParams) {
            NSHTTPURLResponse * httpResponse = (NSHTTPURLResponse *) response;
            NSDictionary * responseHeaders = httpResponse.allHeaderFields;
            
            NSString *newCdn = responseHeaders[@CDN_HEADER];
            if (newCdn) {
                self.lastCdnTracked = newCdn;
            }
            
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

-(BOOL)isTimerRunning {
    return self.valid;
}

-(BOOL)isQueueRuning {
    return self.fetchCdnQueue;
}

-(void)invalidate {
    if (self.fetchCdnQueue) {
        [self.fetchCdnQueue cancelAllOperations];
        self.fetchCdnQueue = nil;
    }
    
    self.valid = false;
}
@end
