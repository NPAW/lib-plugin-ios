//
//  YBChrono.h
//  YouboraLib
//
//  Created by Joan on 15/03/2017.
//  Copyright © 2017 NPAW. All rights reserved.
//
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * Utility class that provides chronometer like functionality.
 * Used to calculate the elapsed time between <start> and <stop> calls.
 */
@interface YBChrono : NSObject

/// ---------------------------------
/// @name Public properties
/// ---------------------------------

/// Start time
@property (nonatomic, assign) long long startTime;
/// Stop time
@property (nonatomic, assign) long long stopTime;
/// Offset to be added to deltaTime and stop. in ms.
@property (nonatomic, assign) long long offset;

/// ---------------------------------
/// @name Public methods
/// ---------------------------------
/**
 * Returns the time between start and the last stop in ms. Returns -1 if start wasn't called.
 * @param stop If true, it will force a stop if it wasn't sent before.
 * @return Time lapse in ms or -1 if start was not called.
 */
- (long long) getDeltaTime:(bool) stop;
/**
 * Same as calling <getDeltaTime:> with stop = false
 * @returns the elapsed time in ms since the start call.
 */
- (long long) getDeltaTime;
/**
 * Starts timing
 */
- (void) start;
/**
 * Stop the timer and returns the difference since it <start>ed
 * @returns the difference since it <start>ed
 */
- (long long) stop;

/**
 * Creates and returns a copy of the current Chrono.
 * @returns a copy of the Chrono
 */
- (YBChrono *) copy;

/**
 * Reset the Chrono to its initial state.
 */
- (void) reset;

/// ---------------------------------
/// @name Static methods
/// ---------------------------------
/**
 * Returns the current time in milliseconds
 * @returns the current time in milliseconds
 */
+ (long long) getNow;

@end

NS_ASSUME_NONNULL_END
