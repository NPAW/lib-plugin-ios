//
//  YBTransform.h
//  YouboraLib
//
//  Created by Joan on 20/03/2017.
//  Copyright © 2017 NPAW. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YBRequest;
@protocol YBTransformDoneListener;

NS_ASSUME_NONNULL_BEGIN

/// Protocol forward declaration, defined at the end of the file
@protocol YBTransformDoneListener;

/**
 * Enum defining the transform states. This refers if a request should be send, blocked or stored
 */
typedef NS_ENUM(NSUInteger, YBTransformState) {
    /** Blocked state */
    YBStateBlocked,
    /** No Blocked state */
    YBStateNoBlocked,
    /** Offline state */
    YBStateOffline,
};

/**
 * Transform classes in YOUBORA help the library parse and work with data.
 *
 * A Transform does some kind of task that may block requests until it's done, or applies changes
 * to the requests right before they're finally sent.
 */
@interface YBTransform : NSObject

/// ---------------------------------
/// @name Public methods
/// ---------------------------------

/**
 * Perform any necessary operations on the request.
 * @param request the request to be transformed.
 */
- (void) parse:(nullable YBRequest *) request;

/**
 * By default this will return true until <done> is called. This can be overridden
 * in order to block <YBRequest>s based on any criteria.
 *
 * @param request request that's about to be sent
 * @return true if this particular request is allowed to be sent by this transform.
 */
- (bool) isBlocking: (nullable YBRequest *) request;

/**
 * By default this will return true. This can be overriden to don't send the request
 * (mostly for offline use)
 * @param request request that's about to be sent
 * @return true if this particular request is allowed to be sent by this transform.
 */
- (bool) hasToSend: (nullable YBRequest *) request;

- (YBTransformState) getState;

/**
 * Add a <YBTransformDoneListener>
 * @param listener the listener to add
 */
- (void) addTransformDoneListener: (id<YBTransformDoneListener>) listener;

/**
 * Remove a <YBTransformDoneListener>
 * @param listener the listener to remove
 */
- (void) removeTransformDoneListener: (id<YBTransformDoneListener>) listener;

@end

/**
 * Protocol to notify observers that any asynchronous work done by this Transform has been
 * completed.
 */
@protocol YBTransformDoneListener

@required

/**
 * Called when a Transform has finished its asynchronous work.
 * @param transform The Transform that has finished.
 */
- (void) transformDone:(YBTransform *) transform;

@end

NS_ASSUME_NONNULL_END
