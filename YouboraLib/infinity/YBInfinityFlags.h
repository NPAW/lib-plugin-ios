//
//  YBInfinityFlags.h
//  YouboraLib
//
//  Created by Enrique Alfonso Burillo on 22/07/2018.
//  Copyright © 2018 NPAW. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YBInfinityFlags : NSObject

/// Start is sent
@property(nonatomic, assign) bool started;

/// ---------------------------------
/// @name Public methods
/// ---------------------------------

/**
 * Reset all flag values to false.
 */
- (void) reset;
@end
