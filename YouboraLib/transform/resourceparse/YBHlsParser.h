//
//  YBHlsParser.h
//  YouboraLib
//
//  Created by Joan on 31/03/2017.
//  Copyright © 2017 NPAW. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HlsTransformDoneDelegate;

NS_ASSUME_NONNULL_BEGIN;

/**
 * Class that asynchronously parses an HLS resource in order to get to the transport stream URL.
 *
 * The point behind this class is that some customers do not host the HLS manifest in the same host
 * or even CDN where the actual content chunks are located.
 *
 * Since the CDN detection is performed with the resource url, it is essential that this resource
 * url is pointing to the CDN that is actually hosting the chunks.
 *
 * HLS manifests can be multi-level so this class uses a recursive approach to get to the final
 * chunk file.
 */
@interface YBHlsParser : NSObject

/// ---------------------------------
/// @name Public methods
/// ---------------------------------

/**
 * Starts the HLS parsing from the given resource. The first (outside) call should set the
 * parentResource to null.
 * @param resource the resource url to start parsing
 * @param parentResource parent resource, usually null.
 */
- (void) parse:(NSString *) resource parentResource:(nullable NSString *) parentResource;

/**
 * Add a delegate that will be notified once the parsing finishes.
 * @param delegate the delegate to add
 */
- (void) addHlsTransformDoneDelegate:(id<HlsTransformDoneDelegate>) delegate;

/**
 * Remove a delegate
 * @param delegate the delegate to remove
 */
- (void) removeHlsTransformDoneDelegate:(id<HlsTransformDoneDelegate>) delegate;

/**
 * Returns the resource at this point
 * @return the resource
 */
- (NSString *) getResource;

@end

/**
 * Protocol that has to be implemented in order know when the HlsParser has finished.
 */
@protocol HlsTransformDoneDelegate

@required

/**
 * Called upon completion.
 * @param parsedResource the final resource, or nil if couldn't be parsed
 * @param parser the ResourceParser calling this method
 */
- (void) hlsTransformDone:(nullable NSString *) parsedResource fromHlsParser:(YBHlsParser *) parser;

@end

NS_ASSUME_NONNULL_END;
