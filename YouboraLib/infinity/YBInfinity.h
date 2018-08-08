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

@property(nonatomic, strong, nullable) YBPlugin * plugin;
@property(nonatomic, strong, nullable) YBCommunication * communication;
@property (nonatomic, strong) YBViewTransform *viewTransform;

@property(nonatomic, strong) YBInfinityFlags * flags;

@property(nonatomic, strong) NSString * navContext;

+ (id) sharedManager;

- (void) beginWithScreenName: (nullable NSString *) screenName;

- (void) beginWithScreenName: (nullable NSString *) screenName andDimensions:(nullable NSDictionary<NSString *, NSString *> *) dimensions;

- (void) beginWithScreenName: (nullable NSString *) screenName andDimensions:(nullable NSDictionary<NSString *, NSString *> *) dimensions andParentId:(nullable NSString *) parentId;

- (void) fireSessionStartWithScreenName: (nullable NSString *) screenName andDimensions:(nullable NSDictionary<NSString *, NSString *> *) dimensions andParentId:(nullable NSString *) parentId;

- (void) fireNavWithScreenName: (NSString *) screenName;

- (void) fireEvent:(nullable NSDictionary<NSString *, NSString *> *) dimensions values:(nullable NSDictionary<NSString *, NSNumber *> *) values andEventName:(nullable NSString *) eventName;

- (void) fireSessionStop:(nullable NSDictionary<NSString *, NSString *> *) params;

- (void) end;

- (void) end:(nullable NSDictionary<NSString *, NSString *> *) params;

- (NSNumber *) getLastSent;

- (void)addYouboraInfinityDelegate:(id<YBInfinityDelegate>)delegate;

- (void)removeYouboraInfinityDelegate:(id<YBInfinityDelegate>)delegate;

@end

@protocol YBInfinityDelegate

@optional

- (void) youboraInfinityEventSessionStartWithScreenName: (nullable NSString *) screenName andDimensions:(nullable NSDictionary<NSString *, NSString *> *) dimensions andParentId:(nullable NSString *) parentId;

- (void) youboraInfinityEventNavWithScreenName: (NSString *) screenName;

-(void) youboraInfinityEventEventWithDimensions:(nullable NSDictionary<NSString *, NSString *> *) dimensions values:(nullable NSDictionary<NSString *, NSNumber *> *) values andEventName:(nullable NSString *) eventName;

-(void) youboraInfinityEventSessionStop:(nullable NSDictionary<NSString *, NSString *> *) params;

@end
