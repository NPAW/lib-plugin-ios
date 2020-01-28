//
//  YBRequest.h
//  YouboraLib
//
//  Created by Joan on 16/03/2017.
//  Copyright © 2017 NPAW. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// Method YBConstants
/** HTTP GET method */
FOUNDATION_EXPORT NSString * const YouboraHTTPMethodGet;
/** HTTP POST method */
FOUNDATION_EXPORT NSString * const YouboraHTTPMethodPost;
/** HTTP HEAD method */
FOUNDATION_EXPORT NSString * const YouboraHTTPMethodHead;
/** HTTP OPTIONS method */
FOUNDATION_EXPORT NSString * const YouboraHTTPMethodOptions;
/** HTTP PUT method */
FOUNDATION_EXPORT NSString * const YouboraHTTPMethodPut;
/** HTTP DELETE method */
FOUNDATION_EXPORT NSString * const YouboraHTTPMethodDelete;
/** HTTP TRACE method */
FOUNDATION_EXPORT NSString * const YouboraHTTPMethodTrace;

/**
 * Type of the success block
 *
 *  - data: (NSData *) the data as returned by the completionHandler.
 *  - response: (NSURLResponse *) the response as returned by the completionHandler.
 */
typedef void (^YBRequestSuccessBlock) (NSData * _Nullable data, NSURLResponse * _Nullable response, NSDictionary<NSString *, id> * _Nullable listenerParams);

/**
 * Type of the error block
 *
 *  - error: (NSError *) error as returned by the completionHandler.
 */
typedef void (^YBRequestErrorBlock) (NSError * _Nullable error);

/**
 * This class encapsulates the http requests. It performs as an inferface against the system http calls.
 * YBRequests are highly customizable via its params and the <setSuccessListener:> and <setErrorListener:> methods.
 */
@interface YBRequest : NSObject

/// ---------------------------------
/// @name Public properties
/// ---------------------------------
/// The host where the YBRequest is performed to
@property (nonatomic, strong, nullable) NSString * host;

/// The service. This will be the "/something" part of the url.
/// For instance the "/start" in "a-fds.youborafds01.com/start"
@property (nonatomic, strong, nullable) NSString * service;

/// NSDictionary with params to add to the http request
@property (nonatomic, strong, nullable) NSMutableDictionary<NSString *, NSString *> * params;

/// NSDictionary with Request Headers to add to the http request
@property (nonatomic, strong, nullable) NSDictionary<NSString *, NSString *> * requestHeaders;

/// The retry interval for this request. In milliseconds. The default value is 5000.
@property(nonatomic, assign) unsigned int retryInterval;

/// The number of retries for this request. The default value is 3.
@property(nonatomic, assign) unsigned int maxRetries;

/// Method of the HTTP request. Default is <YouboraHTTPMethodGet>
@property(nonatomic, strong) NSString * method;

/// In case of wanting some params back. Default empty
@property(nonatomic, strong, nullable) NSDictionary<NSString *, id>* listenerParams;

/// Request body in case of being method POST
@property(nonatomic, strong) NSString * body;


/// ---------------------------------
/// @name Init
/// ---------------------------------

/**
 * YBRequest will generate the URL call.
 *
 * @param host NSString with the URL of the request. Example: a-fds.youborafds01.com
 * @param service NSString with the name of the service. Example: '/start'
 * @returns An instance of YBRequest
 */
- (instancetype) initWithHost:(nullable NSString *) host andService:(nullable NSString *) service;

/// ---------------------------------
/// @name Public methods
/// ---------------------------------
/**
 * Sends this Request over the network.
 */
- (void) send;

/**
 * Builds the url. It consists of the following: <host> + <service> + query params
 * @returns the full query url
 */
- (NSURL *) getUrl;

/**
 * Sets one key-value pair onto the params
 * @param key param key
 * @param value param value
 */
- (void) setParam:(NSString *) value forKey:(NSString *)key;

/**
 * Returns the param value for the given key
 * @param key the key for the desired value
 * @returns the param value
 */
- (nullable NSString *) getParam:(NSString *) key;

/**
 * Adds a success listener.
 * @param successBlock the listener to add.
 */
- (void) addRequestSuccessListener:(YBRequestSuccessBlock) successBlock;

/**
 * In case of sending offline events it sets the offline id to remove them when properly send
 * @param offlineId events id
 */
//- (void) setOfflineId: (nullable NSNumber*) offlineId;

/**
 * Removes a success listener
 * @param successBlock the listener ot remove
 */
- (void) removeRequestSuccessListener:(YBRequestSuccessBlock) successBlock;

/**
 * Adds an error listener. These listeners will be called for each failed retry. If you want to
 * implement you own retry management, do so here and <setMaxRetries:> to 0.
 * @param errorBlock the listener to add
 */
- (void) addRequestErrorListener:(YBRequestErrorBlock) errorBlock;

/**
 * Remove an error listener
 * @param errorBlock the listener to remove
 */
- (void) removeRequestErrorListener:(YBRequestErrorBlock) errorBlock;

/// ---------------------------------
/// @name Static methods
/// ---------------------------------
/**
 * Adds a <b>global</b> success listener. These listeners will be called <b>for all the Requests</b>.
 * @param successBlock the global listener to add.
 */
+ (void) addEveryRequestSuccessListener:(YBRequestSuccessBlock) successBlock;

/**
 * Removes a global success listener.
 * @param successBlock the global listener to remove
 */
+ (void) removeEveryRequestSuccessListener:(YBRequestSuccessBlock) successBlock;

/**
 * Adds a <b>global</b> error listener. These listeners will be called <b>for all the Requests</b>.
 * @param errorBlock the global listener to add.
 */
+ (void) addEveryRequestErrorListener:(YBRequestErrorBlock) errorBlock;

/**
 * Removes a global error listener.
 * @param errorBlock the global listener to remove
 */
+ (void) removeEveryRequestErrorListener:(YBRequestErrorBlock) errorBlock;

@end

NS_ASSUME_NONNULL_END

