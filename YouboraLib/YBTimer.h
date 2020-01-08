//
//  YBTimer.h
//  YouboraLib
//
//  Created by Joan on 15/03/2017.
//  Copyright © 2017 NPAW. All rights reserved.
//
#import <Foundation/Foundation.h>

// Forward declaration for the TimerCallback
@class YBTimer, YBChrono;

/**
 * Type of the success block
 *
 *  - timer: (YBTimer *) The <YBTimer> from where the callback is being invoked.
 *  - diffTime: (long) the time difference between the previous call.
 */
typedef void (^TimerCallback) (YBTimer * timer, long long diffTime);

/**
 * An Utility class that provides timed events in a defined time interval.
 */
@interface YBTimer : NSObject


/// ---------------------------------
/// @name Public properties
/// ---------------------------------

/** 
 * The period at which to execute the callbacks.
 */
@property(nonatomic, assign) long interval;

/** 
 * Whether the Timer is running or not.
 */
@property(nonatomic, assign, readonly) bool isRunning;

/**
 * Chrono to inform the callback how much time has passed since the previous call.
 */
@property(nonatomic, strong, readonly) YBChrono * chrono;

/// ---------------------------------
/// @name Init
/// ---------------------------------

/**
 * Init
 * Same as calling <initWithCallback:andInterval:> with an interval of 5000
 * @param callback the block to execute every <interval> milliseconds
 * @returns an instance of YBTimer
 */
- (instancetype)initWithCallback:(TimerCallback) callback;
/**
 * Init
 * @param callback the block to execute every <interval> milliseconds
 * @param intervalMillis interval of the timer
 * @returns an instance of YBTimer
 */
- (instancetype)initWithCallback:(TimerCallback) callback andInterval:(double) intervalMillis;

- (instancetype) init NS_UNAVAILABLE;

/// ---------------------------------
/// @name Public methods
/// ---------------------------------

/**
 * Starts the timer.
 */
- (void) start;

/**
 * Stops the timer.
 */
- (void) stop;

/**
 * Adds a new callback to fire on the timer
 * @param callback callback that must conform to type TimerCallback
 */
- (void) addTimerCallback:(TimerCallback) callback;

@end
