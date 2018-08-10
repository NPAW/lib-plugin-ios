//
//  YBInfinityLocalManager.m
//  YouboraLib
//
//  Created by Enrique Alfonso Burillo on 18/07/2018.
//  Copyright © 2018 NPAW. All rights reserved.
//

#import "YBInfinityLocalManager.h"

#import "YBChrono.h"

//Key names
NSString *const PREFERENCES_SESSION_ID_KEY = @"session_id";
NSString *const PREFERENCES_CONTEXT_KEY = @"context_id";
NSString *const PREFERENCES_LAST_ACTIVE_KEY = @"last_active_id";

@interface YBInfinityLocalManager()

@property(nonatomic, strong) NSUserDefaults *userPrefs;

@end

@implementation YBInfinityLocalManager

- (instancetype) init {
    self = [super init];
    if (self) {
        self.userPrefs = [NSUserDefaults standardUserDefaults];
    }
    return self;
}

- (void) saveSessionWithId: (NSString *) sessionId {
    [self saveValueWithKey:PREFERENCES_SESSION_ID_KEY andValue: sessionId];
}

- (NSString *) getSessionId {
    return [self getValueWithKey:PREFERENCES_SESSION_ID_KEY];
}

- (void) saveContextWithContext: (NSString *) context {
    [self saveValueWithKey:PREFERENCES_CONTEXT_KEY andValue:context];
}

- (NSString *) getContext {
    return [self getValueWithKey:PREFERENCES_CONTEXT_KEY];
}

- (void) saveLastActiveDate {
    [self saveNumberWithKey:PREFERENCES_LAST_ACTIVE_KEY andValue:@([YBChrono getNow])];
}

- (NSNumber *) getLastActive {
    return [self getNumberWithKey:PREFERENCES_LAST_ACTIVE_KEY];
}

- (void) saveValueWithKey: (NSString *) key andValue: (NSString *) value{
    [self.userPrefs setValue:value forKey:key];
}

- (NSString *) getValueWithKey: (NSString *) key {
    return [self.userPrefs objectForKey:key];
}

- (void) saveNumberWithKey: (NSString *) key andValue: (NSNumber *) value {
    [self.userPrefs setObject:value forKey:key];
}

- (NSNumber *) getNumberWithKey: (NSString *) key {
    return [self.userPrefs objectForKey:key];
}

@end
