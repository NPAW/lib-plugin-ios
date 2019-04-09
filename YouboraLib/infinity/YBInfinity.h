//
//  YBInfinity.h
//  YouboraLib
//
//  Created by Enrique Alfonso Burillo on 19/07/2018.
//  Copyright © 2018 NPAW. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YBPlugin, YBCommunication, YBInfinityFlags, YBViewTransform;
@protocol YBInfinityDelegate;

@interface YBInfinity : NSObject

@property(nonatomic, weak, nullable) YBPlugin * plugin;
@property(nonatomic, weak, nullable) YBViewTransform * viewTransform;

@property(nonatomic, strong, nullable) YBInfinityFlags * flags;

@property(nonatomic, strong, nullable) NSString * navContext;
@property(nonatomic, strong, nullable) NSMutableArray<NSString *> * activeSessions;

+ (nullable id) sharedManager;

- (void) beginWithScreenName:(nullable NSString *)screenName;

- (void) beginWithScreenName:(nullable NSString *)screenName andDimensions:(nullable NSDictionary<NSString *, NSString *> *)dimensions;

- (void) beginWithScreenName:(nullable NSString *)screenName andDimensions:(nullable NSDictionary<NSString *, NSString *> *)dimensions andParentId:(nullable NSString *)parentId;

- (void) fireSessionStartWithScreenName:(nullable NSString *)screenName andDimensions:(nullable NSDictionary<NSString *, NSString *> *)dimensions andParentId:(nullable NSString *)parentId;

- (void) fireNavWithScreenName:(nullable NSString *)screenName;

- (void) fireEvent:(nullable NSDictionary<NSString *, NSString *> *)dimensions values:(nullable NSDictionary<NSString *, NSNumber *> *)values andEventName:(nullable NSString *)eventName;

- (void) fireSessionStop:(nullable NSDictionary<NSString *, NSString *> *)params;

- (void) end;

- (void) end:(nullable NSDictionary<NSString *, NSString *> *)params;

- (nullable NSNumber *)getLastSent;

- (void) addActiveSession:(nullable NSString *)sessionId;

- (void) removeActiveSession:(nullable NSString *)sessionId;

- (void) addYouboraInfinityDelegate:(nullable id<YBInfinityDelegate>)delegate;

- (void) removeYouboraInfinityDelegate:(nullable id<YBInfinityDelegate>)delegate;

@end

@protocol YBInfinityDelegate

@optional

- (void) youboraInfinityEventSessionStartWithScreenName:(nullable NSString *)screenName andDimensions:(nullable NSDictionary<NSString *, NSString *> *)dimensions andParentId:(nullable NSString *)parentId;

- (void) youboraInfinityEventNavWithScreenName:(nullable NSString *)screenName;

- (void) youboraInfinityEventEventWithDimensions:(nullable NSDictionary<NSString *, NSString *> *)dimensions values:(nullable NSDictionary<NSString *, NSNumber *> *)values andEventName:(nullable NSString *)eventName;

- (void) youboraInfinityEventSessionStop:(nullable NSDictionary<NSString *, NSString *> *)params;

@end
