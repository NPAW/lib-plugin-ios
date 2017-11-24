//
//  YBPlaybackFlags.h
//  YouboraLib
//
//  Created by Joan on 20/03/2017.
//  Copyright © 2017 NPAW. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * This class contains all the flags related to view status.
 * Each <Plugin> will have an instance of this class.
 */
@interface YBPlaybackFlags : NSObject

/// ---------------------------------
/// @name Public properties
/// ---------------------------------

/// Preloading
@property(nonatomic, assign) bool preloading;

/// Start is sent
@property(nonatomic, assign) bool started;

/// Join is sent
@property(nonatomic, assign) bool joined;

/// Paused
@property(nonatomic, assign) bool paused;

/// Seeking
@property(nonatomic, assign) bool seeking;

/// Buffering
@property(nonatomic, assign) bool buffering;

/// Ended
@property(nonatomic, assign) bool ended;

/// Stopped
@property(nonatomic, assign) bool stopped;
    
/// Only used for ads
@property(nonatomic, assign) bool adInitiated;

/// ---------------------------------
/// @name Public methods
/// ---------------------------------

/**
 * Reset all flag values to false.
 */
- (void) reset;

@end
