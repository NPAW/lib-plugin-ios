//
//  YBInfinityLocalManager.h
//  YouboraLib
//
//  Created by Enrique Alfonso Burillo on 18/07/2018.
//  Copyright © 2018 NPAW. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YBInfinityLocalManager : NSObject

/**
 * Default init.
 */
- (instancetype) init;

/**
 * Saves new session id on <NSUserDefaults>
 * @param sessionId sessionId to save
 */
- (void) saveSessionWithId: (NSString *) sessionId;

/**
 * Gets saved session id on <NSUserDefaults>
 * @return session id to save
 */
- (NSString *) getSessionId;

/**
 * Saves new context on <NSUserDefaults>
 * @param context to save
 */
- (void) saveContextWithContext: (NSString *) context;

/**
 * Gets saved context on <NSUserDefaults>
 * @return context to save
 */
- (NSString *) getContext;

/**
 * Saves timestamp of last event sent on <NSUserDefaults>
 */
- (void) saveLastActiveDate;

/**
 * Gets saved timestamp on <NSUserDefaults>
 * @return context to save
 */
- (NSNumber *) getLastActive;

@end
