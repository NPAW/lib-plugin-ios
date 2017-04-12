//
//  YBPlayheadMonitor.h
//  YouboraLib
//
//  Created by Joan on 21/03/2017.
//  Copyright © 2017 NPAW. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN;

@class YBPlayerAdapter;

/** Monitor nothing */
FOUNDATION_EXPORT int const YouboraBufferTypeNone;
/** Monitor buffer */
FOUNDATION_EXPORT int const YouboraBufferTypeBuffer;
/** Monitor seek */
FOUNDATION_EXPORT int const YouboraBufferTypeSeek;

/**
 * This class periodically checks the player's playhead in order to infer buffer and/or seek events.
 *
 * The PlayheadMonitor is bounded to a <YBPlayerAdapter> and fires its buffer and seek
 * start and end methods.
 *
 * In order to use this feature, monitorPlayhead should
 * be called from the Adapter's overridden constructor.
 */
@interface YBPlayheadMonitor : NSObject

/// ---------------------------------
/// @name Init
/// ---------------------------------

/**
 * Constructor
 *
 * @param adapter the adapter from where to watch the playhead
 * @param type type of monitoring desired, can be YouboraBufferTypeBuffer, YouboraBufferTypeSeek
 *   or both; YouboraBufferTypeBuffer | YouboraBufferTypeSeek
 * @param interval the interval between playhead checks. If this is negative, no timer will be created
 */
- (instancetype) initWithAdapter:(YBPlayerAdapter *) adapter type:(int) type andInterval:(int) interval NS_DESIGNATED_INITIALIZER;

/**
 * Convenience constructor with a default interval of 800ms
 *
 * @param adapter the adapter from where to watch the playhead
 * @param type type of monitoring desired, can be YouboraBufferTypeBuffer, YouboraBufferTypeSeek
 *   or both; YouboraBufferTypeBuffer | YouboraBufferTypeSeek
 */
- (instancetype) initWithAdapter:(YBPlayerAdapter *) adapter type:(int) type;


- (instancetype) init NS_UNAVAILABLE;


/// ---------------------------------
/// @name Public methods
/// ---------------------------------

/**
 * Start monitoring playhead
 */
- (void) start;

/**
 * Stop monitoring playhead
 */
- (void) stop;

/**
 * Used to ignore the immediate next check after this call. Used when the player resumes
 * playback after a pause or a seek.
 */
- (void) skipNextTick;

/**
 * Get the playhead from the <YBPlayerAdapter>
 * @return the Adapter's current playhead.
 */
- (NSNumber *) getPlayhead;

/**
 * Call this method at every tick of timeupdate/progress.
 * If you defined an interval, do not fire this method manually.
 */
- (void) progress;

@end

NS_ASSUME_NONNULL_END;
