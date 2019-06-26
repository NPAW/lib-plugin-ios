//
//  YBRequestBuilder.h
//  YouboraLib
//
//  Created by Joan on 24/03/2017.
//  Copyright © 2017 NPAW. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YBPlugin;

NS_ASSUME_NONNULL_BEGIN;

/**
 * This class helps building params associated with each event: /start, /joinTime...
 */
@interface YBRequestBuilder : NSObject

@property(nonatomic, strong, readonly) NSMutableDictionary * lastSent;

/// ---------------------------------
/// @name Init
/// ---------------------------------

/**
 * Init
 * @param plugin instance whre to getthe info from
 */
- (instancetype) initWithPlugin:(YBPlugin *) plugin;

/// ---------------------------------
/// @name Public methods
/// ---------------------------------

/**
 * Adds to params dict allt he entities specified that correspond to the given service
 *
 * @param params dict of key:value entries
 * @param service The name of the service
 * @return dict with built params
 */
- (NSMutableDictionary<NSString *, NSString *> *) buildParams:(nullable NSDictionary<NSString *, NSString *> *) params forService:(NSString *) service;

/**
 * Adds to params all the entities specified in paramList, unless they are already set.
 *
 * @param params Map of params key:value.
 * @param paramList A list of params to fetch.
 * @param different If true, only fetches params that have changed since the last
 * @return fetched params
 */
- (NSMutableDictionary<NSString *, NSString *> *) fetchParams:(nullable NSDictionary<NSString *, NSString *> *) params paramList:(NSArray <NSString *> *) paramList onlyDifferent:(bool) different;

/**
 * Return changed entities since last check
 * This is used mainly for ping param construction.
 * @return params
 */
- (NSMutableDictionary *) getChangedEntitites;

/**
 * Creates an adnumber if it does not exist and stores it in lastSent. If it already exists,
 * it is incremented by 1.
 *
 * @return newly created adNumber
 */
- (NSString *) getNewAdNumber;

/**
 Creates a breakNumber if it does not exist and stores it in lastSent. If it already exists,
 * it is incremented by 1.
 */
- (NSString *) getNewAdBreakNumber;

@end

NS_ASSUME_NONNULL_END;
