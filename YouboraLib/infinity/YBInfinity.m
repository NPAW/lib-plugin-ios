//
//  YBInfinity.m
//  YouboraLib
//
//  Created by Enrique Alfonso Burillo on 19/07/2018.
//  Copyright © 2018 NPAW. All rights reserved.
//

#import "YBInfinity.h"

#import "YBInfinityLocalManager.h"
#import "YBInfinityFlags.h"
#import "YBLog.h"
#import "YBCommunication.h"
#import "YBTimestampLastSent.h"

@interface YBInfinity()

@property (nonatomic, strong) YBInfinityLocalManager* infinityStorage;

// Delegates list
@property (nonatomic, strong) NSMutableArray<id<YBInfinityDelegate>> * eventDelegates;

@end

@implementation YBInfinity

+ (id)sharedManager {
    static YBInfinity *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {
        self.flags = [[YBInfinityFlags alloc] init];
    }
    return self;
}

- (void) begin {
    [self beginWithDimensions:nil values:nil andParentId:nil];
}

- (void) beginWithDimensions:(nullable NSDictionary<NSString *, NSString *> *) dimensions values:(nullable NSDictionary<NSString *, NSNumber *> *) values andParentId:(nullable NSString *) parentId {
    if (self.plugin == nil) {
        [YBLog error:@"Plugin is null, have the plugin been set?"];
        return;
    }
    
    if (!self.flags.started) {
        self.flags.started = true;
        
        self.communication = [[YBCommunication alloc] init];
        if (self.viewTransform != nil) {
            [self.communication addTransform:self.viewTransform];
            [self.communication addTransform:[[YBTimestampLastSent alloc] init]];
            [self fireSessionStartWithDimensions:dimensions values:values andParentId:parentId];
        }
    }
}

- (void) fireSessionStartWithDimensions:(nullable NSDictionary<NSString *, NSString *> *) dimensions values:(nullable NSDictionary<NSString *, NSNumber *> *) values andParentId:(nullable NSString *) parentId {
    self.infinityStorage = [[YBInfinityLocalManager alloc] init];
    [self generateNewContext];
    
    for (id<YBInfinityDelegate> delegate in self.eventDelegates) {
        [delegate youboraInfinityEventSessionStartWithDimensions:dimensions values:values andParentId:parentId];
    }
}

- (void) fireNavWithDimensions:(nullable NSDictionary<NSString *, NSString *> *) dimensions andValues:(nullable NSDictionary<NSString *, NSNumber *> *) values {
    for (id<YBInfinityDelegate> delegate in self.eventDelegates) {
        [delegate youboraInfinityEventNavWithDimensions:dimensions andValues:values];
    }
}

- (void) fireEvent:(nullable NSDictionary<NSString *, NSString *> *) dimensions values:(nullable NSDictionary<NSString *, NSNumber *> *) values andEventName:(nullable NSString *) eventName {
    for (id<YBInfinityDelegate> delegate in self.eventDelegates) {
        [delegate youboraInfinityEventEventWithDimensions:dimensions values:values andEventName:eventName];
    }
}

- (void) fireSessionStop:(nullable NSDictionary<NSString *, NSString *> *) params {
    if (self.flags.started) {
        [self.flags reset];
        for (id<YBInfinityDelegate> delegate in self.eventDelegates) {
            [delegate youboraInfinityEventSessionStop:params];
        }
    }
}

- (void) end {
    [self end:nil];
}

- (void) end:(nullable NSDictionary<NSString *, NSString *> *) params {
    if (self.flags.started) {
        [self fireSessionStop:params];
    }
}

- (void) generateNewContext {
    [self.infinityStorage saveContextWithContext:[YBYouboraUtils getAppName]];
    self.navContext = [YBYouboraUtils getAppName];
}

- (NSNumber *) getLastSent {
    return [self.infinityStorage getLastActive];
}

- (void)addYouboraInfinityDelegate:(id<YBInfinityDelegate>)delegate {
    if (delegate != nil) {
        if (self.eventDelegates == nil) {
            self.eventDelegates = [NSMutableArray arrayWithObject:delegate];
        } else if (![self.eventDelegates containsObject:delegate]) {
            [self.eventDelegates addObject:delegate];
        }
    }
}

- (void)removeYouboraInfinityDelegate:(id<YBInfinityDelegate>)delegate {
    if (delegate != nil && self.eventDelegates != nil) {
        [self.eventDelegates removeObject:delegate];
    }
}

@end
