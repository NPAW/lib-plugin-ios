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

- (void) begin;

- (void) beginWithDimensions:(nullable NSDictionary<NSString *, NSString *> *) dimensions values:(nullable NSDictionary<NSString *, NSString *> *) values andParentId:(nullable NSString *) parentId;

- (void) fireSessionStartWithDimensions:(nullable NSDictionary<NSString *, NSString *> *) dimensions values:(nullable NSDictionary<NSString *, NSString *> *) values andParentId:(nullable NSString *) parentId;

- (void) fireNavWithDimensions:(nullable NSDictionary<NSString *, NSString *> *) dimensions andValues:(nullable NSDictionary<NSString *, NSString *> *) values;

- (void) fireEvent:(nullable NSDictionary<NSString *, NSString *> *) dimensions values:(nullable NSDictionary<NSString *, NSString *> *) values andEventName:(nullable NSString *) eventName;

- (void) fireSessionStop:(nullable NSDictionary<NSString *, NSString *> *) params;

- (void) end;

- (void) end:(nullable NSDictionary<NSString *, NSString *> *) params;

- (NSNumber *) getLastSent;

- (void)addYouboraInfinityDelegate:(id<YBInfinityDelegate>)delegate;

- (void)removeYouboraInfinityDelegate:(id<YBInfinityDelegate>)delegate;

@end

@protocol YBInfinityDelegate

@optional

- (void) youboraInfinityEventSessionStartWithDimensions:(nullable NSDictionary<NSString *, NSString *> *) dimensions values:(nullable NSDictionary<NSString *, NSString *> *) values andParentId:(nullable NSString *) parentId;

- (void) youboraInfinityEventNavWithDimensions:(nullable NSDictionary<NSString *, NSString *> *) dimensions andValues:(nullable NSDictionary<NSString *, NSString *> *) values;

-(void) youboraInfinityEventEventWithDimensions:(nullable NSDictionary<NSString *, NSString *> *) dimensions values:(nullable NSDictionary<NSString *, NSString *> *) values andEventName:(nullable NSString *) eventName;

-(void) youboraInfinityEventSessionStop:(nullable NSDictionary<NSString *, NSString *> *) params;

@end
