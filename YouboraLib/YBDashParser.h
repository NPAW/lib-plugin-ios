//
//  YBDashParser.h
//  YouboraLib
//
//  Created by nice on 11/11/2019.
//  Copyright © 2019 NPAW. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol DashTransformDoneDelegate;


/**
 * Class that asynchronously parses an DASH resource in order to get to the location URL.
 *
 * Since the CDN detection is performed with the resource url, it is essential that this
 * resource url is pointing to the CDN that is actually hosting the manifest.
 *
 */
@interface YBDashParser : NSObject

/**
 * Starts the Dash parsing from the given resource. The first (outside) call should set the
 * parentResource to null.
 *
 * @param resource the resource url.
 */
- (void) parse:(NSString *) resource;

/**
 * Add a delegate that will be notified once the parsing finishes.
 * @param delegate the delegate to add
 */
- (void) addDashTransformDoneDelegate:(id<DashTransformDoneDelegate>) delegate;

/**
 * Remove a delegate
 * @param delegate the delegate to remove
 */
- (void) removeDashTransformDoneDelegate:(id<DashTransformDoneDelegate>) delegate;

/**
 * Returns the resource at this point
 * @return the resource
 */
- (NSString *) getResource;

@end

@protocol DashTransformDoneDelegate

@required

/**
 * Called upon completion.
 * @param parsedResource the final resource, or nil if couldn't be parsed
 * @param parser the ResourceParser calling this method
 */
- (void) dashTransformDone:(nullable NSString *) parsedResource fromDashParser:(YBDashParser *) parser;

@end
NS_ASSUME_NONNULL_END
