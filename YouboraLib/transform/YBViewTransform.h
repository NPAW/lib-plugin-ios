//
//  YBViewTransform.h
//  YouboraLib
//
//  Created by Joan on 22/03/2017.
//  Copyright © 2017 NPAW. All rights reserved.
//

#import "YBTransformSubclass.h"

@class YBPlugin, YBFastDataConfig;

NS_ASSUME_NONNULL_BEGIN;

/**
 * Manages Fastdata service interaction and view codes generation.
 */
@interface YBViewTransform : YBTransform

/// ---------------------------------
/// @name Public properties
/// ---------------------------------

/**
 * Instance of <YBFastDataConfig>
 */
@property(nonatomic, strong) YBFastDataConfig * fastDataConfig;

/// ---------------------------------
/// @name Init
/// ---------------------------------

/**
 * Init
 * @param plugin The <YBPlugin> this View transform is bounded to.
 */
- (instancetype) initWithPlugin:(YBPlugin *) plugin;

- (instancetype) init NS_UNAVAILABLE;

/// ---------------------------------
/// @name Public methods
/// ---------------------------------

/**
 * Starts the 'FastData' fetching. This will send the initial request to YOUBORA in order to get
 * the needed info for the rest of the requests.
 *
 * This is an asynchronous process.
 *
 * When the fetch is complete, <fastDataConfig> will contain the parsed info.
 */
-(void) begin;

/**
 * Increments the view counter and generates a new view code.
 * @return the new view code
 */
- (NSString *) nextView;

/**
 * ViewTransform will set the correct view code to each request and set the pingTime param
 * for the services that need to carry it.
 * @param request Request to parse
 */
- (void)parse:(nullable YBRequest *)request;

/**
 * Method to get current timestamp
 */
- (NSString *) getViewCodeTimeStamp;

/**
 * Method to return current view code
 */

-(NSString *)getCurrentViewCode;

/**
* Method to return session root
*/
-(NSString *)getSessionRoot;

@end

NS_ASSUME_NONNULL_END;
