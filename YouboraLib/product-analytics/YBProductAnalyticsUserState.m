//
//  YBProductAnalyticsUserState.m
//  YouboraLib iOS
//
//  Created by Francisco Expósito NPAW on 06/02/2024.
//  Copyright © 2024 NPAW. All rights reserved.
//

#import "YBProductAnalyticsUserState.h"
#import "YBLog.h"

// Private method definition

@interface YBProductAnalyticsUserState ()

-(void)fireEvent:(States)state eventName:(NSString *)eventName;
-(void)storeState:(States)state;
-(void)timerStart;
-(void)timerStop;
-(void)timerFired:(NSTimer *)timer;
-(NSString *)getStateName:(States)state;

@end

// Class implementation

@implementation YBProductAnalyticsUserState

/**
 * This class handles Product Analytics user state management.
 *
 * @param activeStateDimension Custom dimension where to store the user state.
 * @param activeStateTimeout Interval (in ms) to transition from active to passive state.
 * @param fireEventAdapter Handler for firing adapter events
 * @param options Plugin options
 */

- (instancetype)initWithActiveStateDimension:(NSInteger)activeStateDimension activeStateTimeout:(NSInteger)activeStateTimeout fireEventAdapter:(FireEvent)fireEventAdapter options:(YBOptions *)options {
    self = [super init];
    if (self) {
        _fireEventAdapter = fireEventAdapter;
        _options = options;
        _timer = nil;
        _timerInterval = activeStateTimeout;
        _dimension = [NSString stringWithFormat:@"contentCustomDimension%ld", activeStateDimension];
        [self storeState:StatesPassive];
    }
    return self;
}

-(void)destroy{
    self.fireEventAdapter  = nil;
    self.options           = nil;
    self.timerInterval     = 0;
    self.dimension         = nil;
    self.state             = StatesPassive;

    [self timerStop];
}

// ------------------------------------------------------------------------------------------------------------------------------
// STATE MANAGEMENT
// ------------------------------------------------------------------------------------------------------------------------------

 /**
   * Set active state
   * @param eventName Name of the event switching the state to active
   */

-(void)setActive:(NSString *)eventName {
    States state = StatesActive;

    if (self.state != state) {
        [self fireEvent:state eventName:eventName];
        [self storeState:state];
    }

    [self timerStart];
}

/**
  * Fire switch state event
  * @param state State to assign
  * @param eventName Name of the event switching the state
  */

-(void)fireEvent:(States)state eventName:(NSString *)eventName {
    NSString * stateNamePrev;
    NSString * stateNameNext;

    stateNamePrev = [self getStateName:self.state];
    stateNameNext = [self getStateName:state];

    [YBLog notice: [NSString stringWithFormat:@"User changing from state %@ to %@", stateNamePrev, stateNameNext]];

    NSMutableDictionary *dimensions = [NSMutableDictionary dictionary];
    dimensions[@"eventType"]    = @"ContentPlayback";
    dimensions[@"newState"]     = stateNameNext;
    dimensions[@"triggerEvent"] = eventName;
    dimensions[@"stateFromTo"]  = [NSString stringWithFormat:@"%@ to %@", stateNamePrev, stateNameNext];
    
    switch (state) {
        case StatesActive:
            self.fireEventAdapter(@"[PLAYBACK STATE] Switch to Active", dimensions, [NSMutableDictionary dictionary], [NSMutableDictionary dictionary]);
            break;
        case StatesPassive:
            self.fireEventAdapter(@"[PLAYBACK STATE] Switch to Passive", dimensions, [NSMutableDictionary dictionary], [NSMutableDictionary dictionary]);
            break;
    }
}

/**
  * Store state
  * @param state State to assign
  * @private
  */

-(void)storeState:(States)state {
    self.state = state;
    
    @try {
        if ( self.options == nil ){
            [YBLog warn: @"Cannot track User State since options are unavailable."];
        } else {
            [self.options setValue:[self getStateName: self.state] forKey:self.dimension];
        }
    }
    @catch (NSException *exception) {
        [YBLog warn: [NSString stringWithFormat:@"Invalid attribute name: %@", self.dimension]];
    }
}

/**
 * Get state name
 * @param state State whose name is needed
 * @private
 */

-(NSString *)getStateName:(States)state {
    return (state == StatesActive ? @"active" : @"passive" );
}

// ------------------------------------------------------------------------------------------------------------------------------
// TIMER MANAGEMENT
// ------------------------------------------------------------------------------------------------------------------------------

/**
  * Starts interaction monitor timer
  * @private
  */

-(void)timerStart {

    float interval = self.timerInterval / 1000.0;
    
    [self timerStop];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(timerFired:) userInfo:nil repeats:NO];
}

/**
  * Stops interaction monitor timer
  * @private
  */

-(void)timerStop {
    if ( self.timer != nil ){
        [self.timer invalidate];
        self.timer = nil;
    }
}

/**
  * Triggers events after an automatic user state switch to "Passive"
  * @private
  */

-(void)timerFired:(NSTimer *)timer {
    [self fireEvent:StatesPassive eventName:@"timer"];
    [self storeState:StatesPassive];
}

@end
