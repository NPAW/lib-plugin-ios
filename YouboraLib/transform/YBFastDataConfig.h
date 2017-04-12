//
//  YBFastDataConfig.h
//  YouboraLib
//
//  Created by Joan on 22/03/2017.
//  Copyright © 2017 NPAW. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Container class that has all the info we need from YOUBORA's 'FastData' service.
 */
@interface YBFastDataConfig : NSObject

/// ---------------------------------
/// @name Public properties
/// ---------------------------------

/**
 * The YOUBORA host where to send traces
 */
@property(nonatomic, strong) NSString * host;

/**
 * Unique view identifier.
 */
@property(nonatomic, strong) NSString * code;

/**
 * Ping time; how often should pings be reported. This is per-account configurable
 * although 99% of the time this is 5 seconds.
 */
@property(nonatomic, strong) NSNumber * pingTime;

@end
