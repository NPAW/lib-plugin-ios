//
//  YBInfinity.h
//  YouboraLib
//
//  Created by Enrique Alfonso Burillo on 19/07/2018.
//  Copyright © 2018 NPAW. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YBInfinityFlags, YBViewTransform;
@protocol YBInfinityDelegate;

@interface YBInfinity : NSObject

@property(nonatomic, weak, nullable) YBViewTransform * viewTransform;

@property(nonatomic, strong) YBInfinityFlags * _Nonnull flags;

@property(nonatomic, strong, nullable) NSString * navContext;
@property(nonatomic, strong, nullable) NSMutableArray<NSString *> * activeSessions;

@property(nonatomic, weak, nullable) id<YBInfinityDelegate> delegate;

- (void) beginWithScreenName:(nonnull NSString *)screenName;

- (void) beginWithScreenName:(nonnull NSString *)screenName andDimensions:(nullable NSDictionary<NSString *, NSString *> *)dimensions;

- (void) fireNavWithScreenName:(nullable NSString *)screenName;

- (void) fireEvent:(nullable NSDictionary<NSString *, NSString *> *)dimensions values:(nullable NSDictionary<NSString *, NSNumber *> *)values andEventName:(nullable NSString *)eventName __deprecated_msg("Use fireEvent:dimensions:values:");

- (void) fireEvent: (nonnull NSString *) eventName dimensions: (nullable NSDictionary<NSString *, NSString *> *) dimensions values: (nullable NSDictionary<NSString *, NSNumber *> *) values;

- (void) end;

- (void) end:(nullable NSDictionary<NSString *, NSString *> *)params;

- (nullable NSNumber *)getLastSent;

/*
 * Method to return the session root
 */
-(NSString* _Nonnull) getSessionRoot;

@end

@protocol YBInfinityDelegate

@optional

- (void) youboraInfinityEventSessionStartWithScreenName:(nullable NSString *)screenName andDimensions:(nullable NSDictionary<NSString *, NSString *> *)dimensions;

- (void) youboraInfinityEventNavWithScreenName:(nullable NSString *)screenName;

- (void) youboraInfinityEventEventWithDimensions:(nullable NSDictionary<NSString *, NSString *> *)dimensions values:(nullable NSDictionary<NSString *, NSNumber *> *)values andEventName:(nullable NSString *)eventName;

- (void) youboraInfinityEventSessionStop:(nullable NSDictionary<NSString *, NSString *> *)params;

@end
