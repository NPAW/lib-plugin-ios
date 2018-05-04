//
//  YBPlugin.h
//  YouboraLib
//
//  Created by Joan on 22/03/2017.
//  Copyright © 2017 NPAW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YBTransform.h"
#import "YBPlayerAdapter.h"

@class YBRequestBuilder, YBOptions, YBResourceTransform, YBViewTransform, YBTimer, YBPlayerAdapter, YBCommunication;

@class YBPlugin;

NS_ASSUME_NONNULL_BEGIN;

/**
 * Will send Request block.
 * This callback will be invoked just before an event is sent, to offer the chance to
 * modify the params that will be sent.
 * @param serviceName the service name
 * @param plugin the <Plugin> that is calling this callback
 * @param params a Map of params that will be sent in the Request
 */
typedef void (^YBWillSendRequestBlock) (NSString * serviceName, YBPlugin * plugin, NSMutableDictionary * params);


/**
 * This is the main class of video analytics. You may want one instance for each video you want
 * to track. Will need <YBPlayerAdapter>s for both content and ads, manage options and general flow.
 */
@interface YBPlugin : NSObject<YBTransformDoneListener, YBPlayerAdapterEventDelegate>

/// ---------------------------------
/// @name Public properties
/// ---------------------------------
@property(nonatomic, strong, readonly) YBResourceTransform * resourceTransform;
@property(nonatomic, strong, readonly) YBViewTransform * viewTransform;
@property(nonatomic, strong, readonly) YBRequestBuilder * requestBuilder;
@property(nonatomic, strong, readonly) YBTimer * pingTimer;
@property(nonatomic, strong) YBOptions * options;
@property(nonatomic, strong, nullable) YBPlayerAdapter * adapter;
@property(nonatomic, strong, nullable) YBPlayerAdapter * adsAdapter;

@property(nonatomic, strong, readonly) YBCommunication * comm;

/// ---------------------------------
/// @name Init
/// ---------------------------------

/**
 * Same as calling <initWithOptions:andAdapter:> with a nil adapter
 * @param options instance of <YBOptions>
 */
- (instancetype) initWithOptions:(nullable YBOptions *) options;

/**
 * Initializer
 * @param options instance of <YBOptions>
 * @param adapter instance of a <YBPlayerAdapter>. Can also be specified afterwards with
 * <setAdapter:>
 */
- (instancetype) initWithOptions:(nullable YBOptions *) options andAdapter:(nullable YBPlayerAdapter *) adapter;

- (instancetype) init NS_UNAVAILABLE;

/// ---------------------------------
/// @name Public methods
/// ---------------------------------

/**
 * Sets an adapter for video content.
 *
 * @param adapter The adapter to set
 */
- (void) setAdapter:(YBPlayerAdapter *)adapter;

/**
 * Removes the current adapter. Stopping pings if no ads adapter.
 */
- (void) removeAdapter;

/**
 * Removes the current adapter. Fires stop if needed. Calls <dispose>
 *
 * @param shouldStopPings if pings should stop
 */
- (void) removeAdapter: (BOOL)shouldStopPings;

/**
 * Sets an adapter for ads.
 *
 * @param adsAdapter adapter to set
 */
- (void) setAdsAdapter:(nullable YBPlayerAdapter *)adsAdapter;

/**
 * Removes the current ads adapter. Stopping pings if no adapter.
 */
- (void) removeAdsAdapter;

/**
 * Removes the current ads adapter. Fires stop if needed. Calls <dispose>
 *
 * @param shouldStopPings if pings should stop
 */
- (void) removeAdsAdapter: (BOOL)shouldStopPings;

/**
 * Disable request sending.
 * Same as calling <[YBOptions setEnabled:]> with false
 */
- (void) disable;
/*
 * Re-enable request sending.
 * Same as calling <[YBOptions setEnabled:]> with true
 */
- (void) enable;

/**
 * Starts preloading state and chronos.
 */
- (void) firePreloadBegin;

/**
 * Ends preloading state and chronos.
 */
- (void) firePreloadEnd;

/**
 * Same as calling <fireInitWithParams:> with a nil param
 */
- (void) fireInit;

/**
 * Sends /init. Should be called once the user has requested the content. Does not need
 * a working adapter or player to work. It won't sent start if isInitiated is true.
 *
 * @param params Map of params to add to the request.
 */
- (void) fireInitWithParams:(nullable NSDictionary<NSString *, NSString *> *) params;

/**
 * Basic error handler. msg, code, errorMetadata and level params can be included in the params
 * argument.
 * @param params params to add to the request. If it is null default values will be added.
 */
- (void) fireErrorWithParams:(nullable NSDictionary<NSString *, NSString *> *) params;

/**
 * Sends a non-fatal error (with level = "error").
 * @param msg Error message (should be unique for the code)
 * @param code Error code reported
 * @param errorMetadata Extra error info, if available.
 */
- (void) fireErrorWithMessage:(nullable NSString *) msg code:(nullable NSString *) code andErrorMetadata:(nullable NSString *) errorMetadata;

/**
 * Sends a non-fatal error (with level = "error").
 * @param msg Error message (should be unique for the code)
 * @param code Error code reported
 * @param errorMetadata Extra error info, if available.
 * @param exception Exception raised by the error
 */
- (void) fireFatalErrorWithMessage:(NSString *) msg code:(NSString *) code andErrorMetadata:(NSString *) errorMetadata andException:(nullable NSException*) exception;

/**
 * Shortcut for <fireStop:> with {@code params = null}.
 */
- (void) fireStop;

/**
 * Sends stop in case of no adapter
 * @param params Map of key:value pairs to add to the request
 */
- (void) fireStop:(nullable NSDictionary<NSString *, NSString *> *) params;

/**
 * Sends all stored offline events, doesn't require an adapter
 */
- (void) fireOfflineEvents;
// ------ INFO GETTERS ------

/**
 * Returns the host where all the NQS traces are sent.
 * @return the gost
 */
- (nullable NSString *) getHost;

/**
 * Returns the parse HLS flag
 * @return the parse HLS flag
 */
- (bool) isParseHls;

/**
 * Returns the parse Cdn node flag
 * @return the parse Cdn node flag
 */
- (bool) isParseCdnNode;

/**
 * Returns the list of Cdn names that are enabled for the <YBResourceTransform>.
 * @return the cdn list
 */
- (NSArray<NSString *> *) getParseCdnNodeList;

/**
 * Returns experiments list
 * @return all set experiments
 */
- (NSArray<NSString *> *) getExperimentIds;

/**
 * Returns the Cdn name header. This value is later passed to
 * the cdn parseras BalancerHeaderName
 * @return the cdn name header.
 */
- (nullable NSString *) getParseCdnNameHeader;

/**
 * Returns the content's playhead in seconds
 * @return the content's playhead
 */
- (NSNumber *) getPlayhead;

/**
 * Returns the content's Playrate
 * @return the content's Playrate
 */
- (NSNumber *) getPlayrate;

/**
 * Returns the content's FPS
 * @return the content's FPS
 */
- (nullable NSNumber *) getFramesPerSecond;

/**
 * Returns the content's dropped frames
 * @return the content's dropped frames
 */
- (NSNumber *) getDroppedFrames;

/**
 * Returns the content's duration in seconds
 * @return the content's duration
 */
- (NSNumber *) getDuration;

/**
 * Returns the content's bitrate in bits per second
 * @return the content's bitrate
 */
- (NSNumber *) getBitrate;

/**
 * Returns the content's throughput in bits per second
 * @return the content's throughput
 */
- (NSNumber *) getThroughput;

/**
 * Returns the content's rendition
 * @return the content's rendition
 */
- (nullable NSString *) getRendition;

/**
 * Returns the content's title
 * @return the content's title
 */
- (nullable NSString *) getTitle;

/**
 * Returns the content's title2
 * @return the content's title2
 */
- (nullable NSString *) getTitle2;

/**
 * Returns whether the content is live or not
 * @return whether the content is live or not
 */
- (nullable NSValue *) getIsLive;

/**
 * Returns the content's resource after being parsed by the <YBResourceTransform>
 * @return the content's resource
 */
- (NSString *) getResource;

/**
 * Returns the content's original resource (before being parsed by the <YBResourceTransform>)
 * @return the content's original resource
 */
- (NSString *) getOriginalResource;

/**
 * Returns the transaction code
 * @return the transaction code
 */
- (nullable NSString *) getTransactionCode;

/**
 * Returns the content metadata
 * @return the content metadata
 */
- (nullable NSString *) getContentMetadata;

/**
 * Returns the content streaming protocol
 * @return the content streaming protocol
 */
- (nullable NSString *) getStreamingProtocol;

/**
 * Returns the version of the player that is used to play the content
 * @return the player version
 */
- (NSString *) getPlayerVersion;

/**
 * Returns the name of the player that is used to play the content
 * @return the player name
 */
- (NSString *) getPlayerName;

/**
 * Returns the content cdn
 * @return the content cdn
 */
- (nullable NSString *) getCdn;

/*
 * Returns player latency.
 * @return the current latency
 */
- (nullable NSNumber *)getLatency;

/*
 * Returns lost packets.
 * @return the current packets being lost
 */
- (nullable NSNumber *)getPacketLost;

/*
 * Returns sent packets.
 * @return the current packets being sent
 */
- (nullable NSNumber *)getPacketSent;

/**
 * Returns the PluginVersion
 * @return the PluginVersion
 */
- (NSString *) getPluginVersion;

/**
 * Returns the content <YBPlayerAdapter> version if available
 * @return the content Adapter version
 */
- (nullable NSString *) getAdapterVersion;

/**
 * Returns content's Extraparam1
 * @return extraparam 1 value
 */
- (nullable NSString *) getExtraparam1;

/**
 * Returns content's Extraparam2
 * @return extraparam 2 value
 */
- (nullable NSString *) getExtraparam2;

/**
 * Returns content's Extraparam3
 * @return extraparam 3 value
 */
- (nullable NSString *) getExtraparam3;

/**
 * Returns content's Extraparam4
 * @return extraparam 5 value
 */
- (nullable NSString *) getExtraparam4;

/**
 * Returns content's Extraparam5
 * @return extraparam 5 value
 */
- (nullable NSString *) getExtraparam5;

/**
 * Returns content's Extraparam6
 * @return extraparam 6 value
 */
- (nullable NSString *) getExtraparam6;

/**
 * Returns content's Extraparam7
 * @return extraparam 7 value
 */
- (nullable NSString *) getExtraparam7;

/**
 * Returns content's Extraparam8
 * @return extraparam 8 value
 */
- (nullable NSString *) getExtraparam8;

/**
 * Returns content's Extraparam9
 * @return extraparam 9 value
 */
- (nullable NSString *) getExtraparam9;

/**
 * Returns content's Extraparam10
 * @return extraparam 10 value
 */
- (nullable NSString *) getExtraparam10;

/**
 * Returns content's Extraparam11
 * @return extraparam 11 value
 */
- (nullable NSString *) getExtraparam11;

/**
 * Returns content's Extraparam12
 * @return extraparam 12 value
 */
- (nullable NSString *) getExtraparam12;

/**
 * Returns content's Extraparam13
 * @return extraparam 13 value
 */
- (nullable NSString *) getExtraparam13;

/**
 * Returns content's Extraparam14
 * @return extraparam 14 value
 */
- (nullable NSString *) getExtraparam14;

/**
 * Returns content's Extraparam15
 * @return extraparam 15 value
 */
- (nullable NSString *) getExtraparam15;

/**
 * Returns content's Extraparam16
 * @return extraparam 16 value
 */
- (nullable NSString *) getExtraparam16;

/**
 * Returns content's Extraparam17
 * @return extraparam 17 value
 */
- (nullable NSString *) getExtraparam17;

/**
 * Returns content's Extraparam18
 * @return extraparam 18 value
 */
- (nullable NSString *) getExtraparam18;

/**
 * Returns content's Extraparam19
 * @return extraparam 19 value
 */
- (nullable NSString *) getExtraparam19;

/**
 * Returns content's Extraparam20
 * @return extraparam 20 value
 */
- (nullable NSString *) getExtraparam20;

/**
 * Returns ad's Extraparam1
 * @return extraparam 1 value
 */
- (nullable NSString *) getAdExtraparam1;

/**
 * Returns ad's Extraparam2
 * @return extraparam 2 value
 */
- (nullable NSString *) getAdExtraparam2;

/**
 * Returns ad's Extraparam3
 * @return extraparam 3 value
 */
- (nullable NSString *) getAdExtraparam3;

/**
 * Returns ad's Extraparam4
 * @return extraparam 5 value
 */
- (nullable NSString *) getAdExtraparam4;

/**
 * Returns ad's Extraparam5
 * @return extraparam 5 value
 */
- (nullable NSString *) getAdExtraparam5;

/**
 * Returns ad's Extraparam6
 * @return extraparam 6 value
 */
- (nullable NSString *) getAdExtraparam6;

/**
 * Returns ad's Extraparam7
 * @return extraparam 7 value
 */
- (nullable NSString *) getAdExtraparam7;

/**
 * Returns ad's Extraparam8
 * @return extraparam 8 value
 */
- (nullable NSString *) getAdExtraparam8;

/**
 * Returns ad's Extraparam9
 * @return extraparam 9 value
 */
- (nullable NSString *) getAdExtraparam9;

/**
 * Returns ad's Extraparam10
 * @return extraparam 10 value
 */
- (nullable NSString *) getAdExtraparam10;

/**
 * Returns the version of the player that is used to play the ad(s)
 * @return the player version
 */
- (NSString *) getAdPlayerVersion;

/**
 * Returns the ad position as YOUBORA expects it; "pre", "mid", "post" or "unknown"
 * @return the ad position
 */
- (NSString *) getAdPosition;

/**
 * Returns ad's playhead in seconds
 * @return ad's playhead
 */
- (NSNumber *) getAdPlayhead;

/**
 * Returns ad's duration in seconds
 * @return ad's duration
 */
- (NSNumber *) getAdDuration;

/**
 * Returns ad's bitrate in bits per second
 * @return ad's bitrate
 */
- (NSNumber *) getAdBitrate;

/**
 * Returns ad's title
 * @return ad's title
 */
- (nullable NSString *) getAdTitle;

/**
 * Returns ad's resource
 * @return ad's resource
 */
- (nullable NSString *) getAdResource;

/**
 * Returns the ad adapter version
 * @return the ad adapter version
 */
- (nullable NSString *) getAdAdapterVersion;

/**
 * Returns the ad metadata
 * @return the ad metadata
 */
- (nullable NSString *) getAdMetadata;

/**
 * Returns a json-formatted string with plugin info
 * @return plugin info
 */
- (NSString *) getPluginInfo;

/**
 * Returns the Ip
 * @return the Ip
 */
- (nullable NSString *) getIp;

/**
 * Returns the Isp
 * @return the Isp
 */
- (nullable NSString *) getIsp;

/**
 * Returns the connection type
 * @return the conneciton type
 */
- (nullable NSString *) getConnectionType;

/** Returns if ip should be ofuscated
 *  @return ip obfuscation
 */
-(nullable NSValue *) getNetworkObfuscateIp;

/**
 * Returns the device code
 * @return the device code
 */
- (nullable NSString *) getDeviceCode;

/**
 * Returns the account code
 * @return the account code
 */
- (nullable NSString *) getAccountCode;

/**
 * Returns the username
 * @return the username
 */
- (nullable NSString *) getUsername;

/**
 * Returns the userType
 * @return the userType
 */
- (nullable NSString *) getUserType;

/**
 * Get CDN node
 * @return the CDN node or nil if unknown
 */
- (nullable NSString *) getNodeHost;

/**
 * Get CDN type, parsed from the type string
 * @return the CDN type
 */
- (nullable NSString *) getNodeType;

/**
 * Get CDN type string, as returned in the cdn header response
 * @return the CDN type string
 */
- (nullable NSString *) getNodeTypeString;
// ------ CHRONOS ------

/**
 * Returns preload chrono delta time
 * @return the preload duration
 */
- (long long) getPreloadDuration;

/**
 * Returns init chrono delta time
 * @return the init duration
 */
- (long long) getInitDuration;

/**
 * Returns JoinDuration chrono delta time
 * @return the join duration
 */
- (long long) getJoinDuration;

/**
 * Returns BufferDuration chrono delta time
 * @return the buffer duration
 */
- (long long) getBufferDuration;

/**
 *  Returns SeekDuration chrono delta time
 * @return the seek duration
 */
- (long long) getSeekDuration;

/**
 * Returns pauseDuration chrono delta time
 * @return the pause duration
 */
- (long long) getPauseDuration;

/**
 * Returns AdJoinDuration chrono delta time
 * @return the ad join duration
 */
- (long long) getAdJoinDuration;

/**
 * Returns AdBufferDuration chrono delta time
 * @return the ad buffer duration
 */
- (long long) getAdBufferDuration;

/**
 * Returns AdPauseDuration chrono delta time
 * @return the ad pause duration
 */
- (long long) getAdPauseDuration;

/**
 * Returns total totalAdDuration chrono delta time
 * @return the total ad duration
 */
- (long long) getAdTotalDuration;

/**
 * Returns ad campaign
 * @return Ad campaign
 */
- (NSString *) getAdCampaign;

/**
 * Returns household id
 * @return Household Id
 */
- (NSString *) getHouseholdId;

/**
 * Adds an Init listener
 * @param listener to add
 */
- (void) addWillSendInitListener:(YBWillSendRequestBlock) listener;

/**
 * Adds a Start listener
 * @param listener to add
 */
- (void) addWillSendStartListener:(YBWillSendRequestBlock) listener;

/**
 * Adds a Join listener
 * @param listener to add
 */
- (void) addWillSendJoinListener:(YBWillSendRequestBlock) listener;

/**
 * Adds a Pause listener
 * @param listener to add
 */
- (void) addWillSendPauseListener:(YBWillSendRequestBlock) listener;

/**
 * Adds a Resume listener
 * @param listener to add
 */
- (void) addWillSendResumeListener:(YBWillSendRequestBlock) listener;

/**
 * Adds a Seek listener
 * @param listener to add
 */
- (void) addWillSendSeekListener:(YBWillSendRequestBlock) listener;

/**
 * Adds a Buffer listener
 * @param listener to add
 */
- (void) addWillSendBufferListener:(YBWillSendRequestBlock) listener;

/**
 * Adds a Error listener
 * @param listener to add
 */
- (void) addWillSendErrorListener:(YBWillSendRequestBlock) listener;

/**
 * Adds a Stop listener
 * @param listener to add
 */
- (void) addWillSendStopListener:(YBWillSendRequestBlock) listener;

/**
 * Adds a Ping listener
 * @param listener to add
 */
- (void) addWillSendPingListener:(YBWillSendRequestBlock) listener;

/**
 * Adds an ad Start listener
 * @param listener to add
 */
- (void) addWillSendAdStartListener:(YBWillSendRequestBlock) listener;

/**
 * Adds an ad Join listener
 * @param listener to add
 */
- (void) addWillSendAdJoinListener:(YBWillSendRequestBlock) listener;

/**
 * Adds an ad Pause listener
 * @param listener to add
 */
- (void) addWillSendAdPauseListener:(YBWillSendRequestBlock) listener;

/**
 * Adds an ad Resume listener
 * @param listener to add
 */
- (void) addWillSendAdResumeListener:(YBWillSendRequestBlock) listener;

/**
 * Adds an ad Buffer listener
 * @param listener to add
 */
- (void) addWillSendAdBufferListener:(YBWillSendRequestBlock) listener;

/**
 * Adds an ad Stop listener
 * @param listener to add
 */
- (void) addWillSendAdStopListener:(YBWillSendRequestBlock) listener;

/**
 * Adds an ad Error listener
 * @param listener to add
 */
- (void) addWillSendAdErrorListener:(YBWillSendRequestBlock) listener;

/**
 * Removes an Init listener
 * @param listener to remove
 */
- (void) removeWillSendInitListener:(YBWillSendRequestBlock) listener;

/**
 * Removes a Start listener
 * @param listener to remove
 */
- (void) removeWillSendStartListener:(YBWillSendRequestBlock) listener;

/**
 * Removes a Join listener
 * @param listener to remove
 */
- (void) removeWillSendJoinListener:(YBWillSendRequestBlock) listener;

/**
 * Removes a Pause listener
 * @param listener to remove
 */
- (void) removeWillSendPauseListener:(YBWillSendRequestBlock) listener;

/**
 * Removes a Resume listener
 * @param listener to remove
 */
- (void) removeWillSendResumeListener:(YBWillSendRequestBlock) listener;

/**
 * Removes a Seek listener
 * @param listener to remove
 */
- (void) removeWillSendSeekListener:(YBWillSendRequestBlock) listener;

/**
 * Removes a Buffer listener
 * @param listener to remove
 */
- (void) removeWillSendBufferListener:(YBWillSendRequestBlock) listener;

/**
 * Removes a Error listener
 * @param listener to remove
 */
- (void) removeWillSendErrorListener:(YBWillSendRequestBlock) listener;

/**
 * Removes a Stop listener
 * @param listener to remove
 */
- (void) removeWillSendStopListener:(YBWillSendRequestBlock) listener;

/**
 * Removes a Ping listener
 * @param listener to remove
 */
- (void) removeWillSendPingListener:(YBWillSendRequestBlock) listener;

/**
 * Removes an ad Start listener
 * @param listener to remove
 */
- (void) removeWillSendAdStartListener:(YBWillSendRequestBlock) listener;

/**
 * Removes an ad Join listener
 * @param listener to remove
 */
- (void) removeWillSendAdJoinListener:(YBWillSendRequestBlock) listener;

/**
 * Removes an ad Pause listener
 * @param listener to remove
 */
- (void) removeWillSendAdPauseListener:(YBWillSendRequestBlock) listener;

/**
 * Removes an ad Resume listener
 * @param listener to remove
 */
- (void) removeWillSendAdResumeListener:(YBWillSendRequestBlock) listener;

/**
 * Removes an ad Buffer listener
 * @param listener to remove
 */
- (void) removeWillSendAdBufferListener:(YBWillSendRequestBlock) listener;

/**
 * Removes an ad Stop listener
 * @param listener to remove
 */
- (void) removeWillSendAdStopListener:(YBWillSendRequestBlock) listener;

/**
 * Removes an ad Error listener
 * @param listener to remove
 */
-(void) removeWillSendAdErrorListener:(YBWillSendRequestBlock) listener;

@end

NS_ASSUME_NONNULL_END;
