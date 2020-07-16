//
//  YBPlaybackFlags.h
//  YouboraLib
//
//  Created by Tiago Pereira on 16/07/2020.
//  Copyright © 2020 NPAW. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YBPlaybackFlags : NSObject

/// ---------------------------------
/// @name Public properties
/// ---------------------------------

/// Preloading
@property Boolean preloading;
/// Start is sent
@property Boolean started;
/// Join is sent
@property Boolean joined;
/// Paused
@property Boolean paused;
/// Seeking
@property Boolean seeking;
/// Buffering
@property Boolean buffering;
/// Ended
@property Boolean ended;
/// Stopped
@property Boolean stopped;

/// Ads only

///Ad Manifest file requested
@property Boolean adManifestRequested; //This one doesn't get reset ever, once it changes to true it's kep that way the whole view
/// Only used for ads
@property Boolean adInitiated;
/// Ad break started
@property Boolean adBreakStarted; //This doesn't get reset since an ad may have finished but not it's break


// Reset all values to the defaults ones
-(void)reset;

@end
