//
//  YBLocationHeaderParser.h
//  YouboraLib
//
//  Created by Enrique Alfonso Burillo on 13/03/2019.
//  Copyright © 2019 NPAW. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LocationHeaderTransformDoneDelegate;

NS_ASSUME_NONNULL_BEGIN;

@interface YBLocationHeaderParser : NSObject

/// ---------------------------------
/// @name Public methods
/// ---------------------------------

/**
 * Parses the API request url to find and locate the real resource
 * @param resource the resource url to start parsing
 */
- (void) parse:(NSString *) resource;

/**
 * Add a delegate that will be notified once the parsing finishes.
 * @param delegate the delegate to add
 */
- (void) addLocationHeaderTransformDoneDelegate:(id<LocationHeaderTransformDoneDelegate>) delegate;

/**
 * Remove a delegate
 * @param delegate the delegate to remove
 */
- (void) removeLocationHeaderTransformDoneDelegate:(id<LocationHeaderTransformDoneDelegate>) delegate;

/**
 * Returns the resource at this point
 * @return the resource
 */
- (NSString *) getResource;

@end

/**
 * Protocol that has to be implemented in order know when the LocationHeaderParser has finished.
 */
@protocol LocationHeaderTransformDoneDelegate

@required

/**
 * Called upon completion.
 * @param parsedResource the final resource, or nil if couldn't be parsed
 * @param parser the ResourceParser calling this method
 */
- (void) locationHeaderTransformDone:(nullable NSString *) parsedResource fromLocationHeaderParser:(YBLocationHeaderParser *) parser;

@end

NS_ASSUME_NONNULL_END;
