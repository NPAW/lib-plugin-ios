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
#import "YBTimestampLastSentTransform.h"
#import "YouboraLib/YouboraLib-Swift.h"

@interface YBInfinity()

@property (nonatomic, strong) YBInfinityLocalManager* infinityStorage;

// Delegates list
@property (nonatomic, strong) NSMutableArray<id<YBInfinityDelegate>> * eventDelegates;

@end

@implementation YBInfinity

- (id)init {
    if (self = [super init]) {
        self.flags = [[YBInfinityFlags alloc] init];
        self.infinityStorage = [[YBInfinityLocalManager alloc] init];
    }
    return self;
}

- (void) beginWithScreenName: (NSString *) screenName {
    [self beginWithScreenName:screenName andDimensions:nil];
}

- (void) beginWithScreenName: (NSString *) screenName andDimensions:(NSDictionary<NSString *, NSString *> *) dimensions {
    if (dimensions == nil) {
        dimensions = @{};
    }
    
    if (!self.flags.started) {
        self.flags.started = true;
        if (self.viewTransform != nil) {
            [self fireSessionStartWithScreenName:screenName andDimensions:dimensions];
        }
    } else {
        [self fireNavWithScreenName:screenName];
    }
}

- (void) fireSessionStartWithScreenName: (NSString *) screenName andDimensions:(NSDictionary<NSString *, NSString *> *) dimensions{
    [self generateNewContext];
    
    for (id<YBInfinityDelegate> delegate in self.eventDelegates) {
        [delegate youboraInfinityEventSessionStartWithScreenName:screenName andDimensions:dimensions];
    }
}

- (void) fireNavWithScreenName: (NSString *) screenName {
    for (id<YBInfinityDelegate> delegate in self.eventDelegates) {
        [delegate youboraInfinityEventNavWithScreenName:screenName];
    }
}

- (void) fireEvent: (NSDictionary<NSString *, NSString *> *) dimensions values: (NSDictionary<NSString *, NSNumber *> *) values andEventName: (NSString *) eventName {
    [self fireEvent:eventName dimensions:dimensions values:values];
}

- (void) fireEvent: (NSString *) eventName dimensions: (NSDictionary<NSString *, NSString *> *) dimensions values: (NSDictionary<NSString *, NSNumber *> *) values {
    if (dimensions == nil) {
        dimensions = @{};
    }
    
    if (values == nil) {
        values = @{};
    }
    
    if (eventName == nil || eventName.length == 0) {
        eventName = @"Unknown";
    }
    
    for (id<YBInfinityDelegate> delegate in self.eventDelegates) {
        [delegate youboraInfinityEventEventWithDimensions:dimensions values:values andEventName:eventName];
    }
}

- (void) fireSessionStop: (NSDictionary<NSString *, NSString *> *) params {
    [self.flags reset];
    for (id<YBInfinityDelegate> delegate in self.eventDelegates) {
        [delegate youboraInfinityEventSessionStop:params];
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

/*- (void) addActiveSession: (nullable NSString *) sessionId {
    if (sessionId == nil)
        return;
    if (self.activeSessions == nil)
        self.activeSessions = [[NSMutableArray alloc] initWithCapacity:1];
    [self.activeSessions addObject:sessionId];
}

- (void) removeActiveSession: (nullable NSString *) sessionId {
    if (sessionId == nil)
        return;
    [self.activeSessions removeObject:sessionId];
}*/

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

-(NSString* _Nonnull) getSessionRoot {
    return [self.viewTransform getSessionRoot];
}

@end
