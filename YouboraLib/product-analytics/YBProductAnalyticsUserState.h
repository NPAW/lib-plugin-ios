//
//  YBProductAnalyticsUserState.h
//  YouboraLib
//
//  Created by Francisco Expósito on 06/02/2024.
//  Copyright © 2024 NPAW. All rights reserved.

#import <Foundation/Foundation.h>
#import "YouboraLib/YBOptions.h"
#import "YouboraLib/YBPlayerAdapter.h"

@interface YBProductAnalyticsUserState: NSObject

typedef enum {
    StatesActive,
    StatesPassive
} States;

typedef void(^FireEvent)(NSString *eventName, NSMutableDictionary *dimensionsInternal, NSMutableDictionary *dimensionsUser, NSMutableDictionary *metrics);

@property (nonatomic, copy) FireEvent fireEventAdapter;
@property (nonatomic, weak) YBOptions * options;

@property (nonatomic, assign) Boolean started;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) long timerInterval;
@property (nonatomic, strong) NSString *dimension;
@property (nonatomic, assign) States state;

- (instancetype)initWithActiveStateDimension:(NSInteger)activeStateDimension
                        activeStateTimeout:(NSInteger)activeStateTimeout
                           fireEventAdapter:(void (^)(NSString *, NSMutableDictionary *, NSMutableDictionary *, NSMutableDictionary *))fireEventAdapter
                                    options:(YBOptions *)options;
-(void)setActive:(NSString *)eventName playerStarted:(Boolean)playerStarted;
-(void)dispose;

@end	
