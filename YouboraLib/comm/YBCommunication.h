//
//  YBCommunication.h
//  YouboraLib
//
//  Created by Joan on 20/03/2017.
//  Copyright © 2017 NPAW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YBRequest.h"
#import "YBTransform.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * Communication implements an abstraction layer over API requests.
 * Internally, Communication implements queues of <YBRequest> objects.
 * This queue can be blocked depending on its <YBTransform>.
 */
@interface YBCommunication : NSObject<YBTransformDoneListener>

/// ---------------------------------
/// @name Public methods
/// ---------------------------------

/**
 * Adds the <YBRequest> to the queue. Doing this will process the pending requests.
 * @param request the request to add to the queue
 * @param callback if not null, added as a success listener to the Request
 */
- (void) sendRequest:(YBRequest *) request withCallback:(nullable YBRequestSuccessBlock) callback;

/**
 * Adds the <YBRequest> to the queue. Doing this will process the pending requests.
 * @param request the request to add to the queue
 * @param callback if not null, added as a success listener to the Request
 * @param listenerParams params to return in case of request success
 */
- (void)sendRequest:(YBRequest *)request withCallback:(nullable YBRequestSuccessBlock)callback andListenerParams:(nullable NSDictionary*) listenerParams;

/**
 * Add a <Transform> to the transforms list
 * @param transform transform to add
 */
- (void) addTransform:(YBTransform *) transform;

/**
 * Remove a <YBTransform> from the transforms list
 * @param transform the transform to remove
 */
- (void) removeTransform:(nullable YBTransform *) transform;

@end

NS_ASSUME_NONNULL_END
