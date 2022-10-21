//
//  YBCommunication.m
//  YouboraLib
//
//  Created by Joan on 20/03/2017.
//  Copyright © 2017 NPAW. All rights reserved.
//

#import "YBCommunication.h"
#import "YBLog.h"
#import "YBRequest.h"
#import "YBTransform.h"
#import "YBConstants.h"
#import "YBPlugin.h"
#import "YBOptions.h"
#import "YBSwift.h"

@interface YBCommunication()

@property (nonatomic, strong) NSMutableArray<YBTransform *> * transforms;

@property (nonatomic, strong) NSMutableArray<YBRequest *> * requests;

@property (nonatomic, strong) NSLock * requestsLock;

@property(nonatomic, strong, nullable) YBPlugin * plugin;

@end

@implementation YBCommunication

#pragma mark - Init
- (instancetype)init {
    self = [super init];
    if (self) {
        self.plugin = nil;
        self.transforms = [NSMutableArray array];
        self.requests = [NSMutableArray array];
        self.requestsLock = [[NSLock alloc] init];
    }
    return self;
}

- (instancetype)initWithPlugin:(id)plugin {
    self = [self init];
    self.plugin = plugin;
    return self;
}

#pragma mark - Public methods
- (void)sendRequest:(YBRequest *)request withCallback:(nullable YBRequestSuccessBlock)callback{
    [self sendRequest:request withCallback:callback andListenerParams:nil];
}

- (void)sendRequest:(YBRequest *)request withCallback:(nullable YBRequestSuccessBlock)callback andListenerParams:(nullable NSDictionary*) listenerParams{
    if (request != nil) {
        if (callback != nil) {
            if(listenerParams != nil){
                request.listenerParams = listenerParams;
            }
            [request addRequestSuccessListener:callback];
        }
        [self registerRequest:request];
    }
}

- (void)addTransform:(YBTransform *)transform {
    if (transform != nil) {
        [transform addTranformDoneObserver:self andSelector:@selector(transformDone:)];
        [self.transforms addObject:transform];
    } else {
        [YBLog warn:@"Transform is nil in addTransform"];
    }
}

- (void)removeTransform:(nullable YBTransform *)transform {
    if (transform != nil) {
        [self.transforms removeObject:transform];
    }
}

#pragma mark - Private methods
- (void) registerRequest:(YBRequest *) request {
    if (self.plugin) {
        YBOptions * options = self.plugin.options;
        if (options.authToken) {
            if (request.requestHeaders == nil) {
                request.requestHeaders = [NSMutableDictionary dictionaryWithObject:[NSString stringWithFormat:@"%@ %@",options.authType, options.authToken] forKey:@"Authorization"];
            } else {
                [request.requestHeaders setValue:[NSString stringWithFormat:@"%@ %@",options.authType, options.authToken] forKey:@"Authorization"];
            }
        }

    }
    // Lock
    [self.requestsLock lock];
    [self.requests addObject:request];
    // Unlock
    [self.requestsLock unlock];
    [self processRequests];
    
    
}

- (void) processRequests {
    // Lock
    [self.requestsLock lock];
    for (int i = (int) self.requests.count - 1; i >= 0; i--) {
        
        YBRequest * request = self.requests[i];
        YBTransformState transformState = [self transform:request];
        if (transformState == YBStateOffline) {
            [self.requests removeObjectAtIndex:i];
        } else {
            if (transformState == YBStateNoBlocked) {
                [self.requests removeObjectAtIndex:i];
                if (self.plugin) {
                    YBOptions * options = self.plugin.options;
                    if (options.method && options.method == YBRequestMethodPOST && request.body == nil) {
                        request.body = [YBYouboraUtils stringifyDictionary:request.params];
                        request.params = [self getParamsForPostMessages:request.params];
                    }
                }
                [request send];
            }
        }
        /*if ([self transform:request]) {
            [self.requests removeObjectAtIndex:i];
            [request send];
        }*/
    }
    [self.requestsLock unlock];
    // Unlock
}

- (NSMutableDictionary<NSString *, NSString *> *) getParamsForPostMessages: (NSDictionary<NSString *, NSString *> *) params {
    NSMutableDictionary * mutParams = [NSMutableDictionary dictionary];
    
    // Get previous params
    if (params[@"timemark"] != nil) {
        mutParams[@"timemark"] = params[@"timemark"];
    }
    if (params[@"code"] != nil) {
        mutParams[@"code"] = params[@"code"];
    }
    if (params[@"sessionRoot"] != nil) {
        mutParams[@"sessionRoot"] = params[@"sessionRoot"];
    }
    if (params[@"sessionId"] != nil) {
        mutParams[@"sessionId"] = params[@"sessionId"];
    }
    
    return mutParams;
}

- (YBTransformState) transform: (YBRequest *) request {
    for(YBTransform * transform in self.transforms){
        if([transform isBlocking:request]){
            return YBStateBlocked;
        } else {
            [transform parse:request];
        }
        if([transform getState] == YBStateOffline){
            return YBStateOffline;
        }
    }
    return YBStateNoBlocked;
    /*for (YBTransform * transform in self.transforms) {
        if ([transform isBlocking:request]) {
            return false;
        } else {
            [transform parse:request];
        }
    }
    
    return true;*/
}

- (void)transformDone:(NSNotification *)transform {
    [self processRequests];
}


@end
