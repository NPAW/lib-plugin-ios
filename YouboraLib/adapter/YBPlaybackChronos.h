//
//  YBPlaybackChronos.h
//  YouboraLib
//
//  Created by Joan on 20/03/2017.
//  Copyright © 2017 NPAW. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YBChrono;


/**
 * This class contains all the <YBChrono>s related to view status.
 * Chronos measure time lapses between events.
 * ie: between start and join, between seek-begin and seek-end, etc.
 * Each plugin will have an instance of this class.
 */
@interface YBPlaybackChronos : NSObject

/// ---------------------------------
/// @name Public properties
/// ---------------------------------

/** Chrono between start and joinTime. */
@property (nonatomic, strong) YBChrono * join;

/** Chrono between seek-begin and seek-end. */
@property (nonatomic, strong) YBChrono * seek;

/** Chrono between pause and resume. */
@property (nonatomic, strong) YBChrono * pause;

/** Chrono between buffer-begin and buffer-end. */
@property (nonatomic, strong) YBChrono * buffer;

/** Chrono for the totality of the view. */
@property (nonatomic, strong) YBChrono * total;
    
/** Chrono for the Ad Init duration */
@property (nonatomic, strong) YBChrono * adInit;

/// ---------------------------------
/// @name Public methods
/// ---------------------------------

/**
 * Reset chronos
 */
- (void) reset;

@end
