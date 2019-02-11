//
//  YBPlayerAdapter.h
//  YouboraLib
//
//  Created by Joan on 20/03/2017.
//  Copyright © 2017 NPAW. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class YBPlaybackFlags, YBPlaybackChronos, YBPlugin, YBPlayheadMonitor;
@protocol YBPlayerAdapterEventDelegate;

/**
 * Enum defining the possible Youbora ad positions values. This refers to the timeline position
 * of a particular ad in relation to the content.
 * @see <[YBPlayerAdapter getPosition]>
 */
typedef NS_ENUM(NSUInteger, YBAdPosition) {
    /** Preroll position */
    YBAdPositionPre,
    /** Midroll position */
    YBAdPositionMid,
    /** Postroll position */
    YBAdPositionPost,
    /** Unknown position (default) */
    YBAdPositionUnknown
};

/**
 * Main Adapter class. All specific player adapters should extend this class specifying a player
 * class.
 *
 * The Adapter works as the 'glue' between the player and YOUBORA acting both as event translator
 * and as proxy for the <YBPlugin> to get info from the player.
 *
 * It's a good practice when implementing a new Adapter to create intermediate methods and call those
 * when player events are detected instead of just calling the fire* methods. This will
 * allow future users of the Adapter to customize its behaviour by overriding these methods.
 */
@interface YBPlayerAdapter<__covariant PlayerType> : NSObject

/// ---------------------------------
/// @name Public properties
/// ---------------------------------

/// Player instance
@property(nonatomic, weak) PlayerType player;

/// Playhead monitor
@property(nonatomic, strong, nullable) YBPlayheadMonitor * monitor;

/// Playback flags
@property(nonatomic, strong) YBPlaybackFlags * flags;

/// Chronos
@property(nonatomic, strong) YBPlaybackChronos * chronos;

/// Plugin this Adapter is linked to
@property(nonatomic, strong, nullable) YBPlugin * plugin;

/// ---------------------------------
/// @name Init
/// ---------------------------------

/**
 * Constructor.
 * When overriding it, make sure to call super.
 * Implement the logic to register to the player events in the <registerListeners> method.
 * Usually you will want to call <registerListeners> from the overridden constructor.
 * @param player the player instance this Adapter will be bounded to.
 */
- (instancetype) initWithPlayer:(PlayerType) player;

/// ---------------------------------
/// @name Public methods
/// ---------------------------------

/**
 * Override to set event binders.
 * Call this method from the overridden constructor, or from the client code right after creating
 * the specific adapter instance.
 */
- (void) registerListeners;

/**
 * Override to unset event binders.
 */
- (void) unregisterListeners;

/**
 * Stops view session if applies and clears resources by calling <unregisterListeners>.
 */
- (void) dispose;

/**
 * Creates a <PlayheadMonitor> and configures it.
 * @param monitorBuffers whether to watch for buffers or not
 * @param monitorSeeks whether to watch for seeks or not
 * @param interval the interval at which to perform playhead checks. <getPlayhead> will
 *                 be called once every interval milliseconds.
 */
- (void) monitorPlayheadWithBuffers:(bool) monitorBuffers seeks:(bool) monitorSeeks andInterval:(int) interval;

/**
 * Sets a new player, removes the old listeners if needed.
 *
 * @param player Player to be registered.
 */
- (void) setPlayer:(PlayerType _Nullable)player;

/// ---------------------------------
/// @name Get methods
/// ---------------------------------
// These methods should be overridden by the extending Adapters

/** Override to return current playhead of the video
 *
 * @return the current playhead (position) in seconds
 */
- (nullable NSNumber *) getPlayhead;

/** Override to return current playrate
 *
 * @return the current play rate of the media (0 is paused, 1 is playing at normal speed)
 */
- (NSNumber *) getPlayrate;

/** Override to return Frames Per Second (FPS)
 *
 * @return the current FPS of the media
 */
- (nullable NSNumber *) getFramesPerSecond;

/** Override to return dropped frames since start. This should be an Int
 *
 * @return the total dropped frames
 */
- (nullable NSNumber *) getDroppedFrames;

/** Override to return video duration
 *
 * @return the duration of the media in seconds
 */
- (nullable NSNumber *) getDuration;

/** Override to return current bitrate
 *
 * @return the current real (consumed) bitrate in bits per second
 */
- (nullable NSNumber *) getBitrate;

/** Override to return user bandwidth throughput
 *
 * @return the current throughput in bits per second
 */
- (nullable NSNumber *) getThroughput;

/** Override to return rendition
 * @see <[YBYouboraUtils buildRenditionStringWithWidth:height:andBitrate:]>
 * @return a string that represents the current rendition (quality level)
 */
- (nullable NSString *) getRendition;

/** Override to return title
 *
 * @return the title of the media being played
 */
- (nullable NSString *) getTitle;

/** Override to return title2
 *
 * @return the secondary title. It may be program name, episode, etc.
 */
- (nullable NSString *) getTitle2 __deprecated_msg("Use getProgram instead");

/** Override to return program
 *
 * @return program. It may be program name, episode, etc.
 */
- (nullable NSString *) getProgram;

/** Override to recurn true if live and false if VOD
 *
 * @return whether the currently playing content is a live stream or not
 */
- (nullable NSValue *) getIsLive;

/** Override to return resource URL.
 *
 * @return the currently playing resource (URL)
 */
- (nullable NSString *) getResource;

/** Override to return player latency.
 *
 * @return the current latency
 */
- (nullable NSNumber *)getLatency;

/** Override to return lost packets.
 *
 * @return the current packets being lost
 */
- (nullable NSNumber *)getPacketLost;

/** Override to return sent packets.
 *
 * @return the current packets being sent
 */
- (nullable NSNumber *)getPacketSent;

/** Override to return player version
 *
 * @return the player version
 */
- (nullable NSString *) getPlayerVersion;

/** Override to return player's name
 *
 * @return the player name
 */
- (nullable NSString *) getPlayerName;

/** Override to return adapter version.
 *
 * @return the adapter version
 */
- (NSString *) getVersion;

/**
 * Override to return current ad position (only for ads)
 * @see <YBAdPosition>
 * @return the current ad position
 */
- (YBAdPosition) getPosition;

/**
 * Override to return household id
 *
 * @return housohold player id
 */
- (NSString *) getHouseholdId;

/**
 * Override to return current CDN traffic
 *
 * @return current CDN traffic
 */
-(NSNumber *) getCdnTraffic;

/**
 * Override to return current P2P traffic
 *
 * @return current P2P traffic
 */
-(NSNumber *) getP2PTraffic;

/**
 * Override to return current upload traffic
 *
 * @return current upload traffic
 */
-(NSNumber *) getUploadTraffic;

/**
 * Override to return if p2p mode is enabled
 *
 * @return current p2p state
 */
-(NSValue *) getIsP2PEnabled;

/// ---------------------------------
/// @name Flow methods
/// ---------------------------------

/**
 * Shortcut for <fireStart:> with params = nil.
 */
- (void) fireStart;

/**
 * Emits related event and set flags if current status is valid.
 * @param params Map of key:value pairs to add to the request
 */
- (void) fireStart:(nullable NSDictionary<NSString *, NSString *> *) params;

/**
 * Shortcut for <fireAdInit:> with params = nil.
 */
- (void)fireAdInit;

/**
 * Emits related event and set flags if current status is valid.
 * @param params Map of key:value pairs to add to the request
 */
- (void)fireAdInit:(nullable NSDictionary<NSString *,NSString *> *)params;

/**
 * Shortcut for <fireJoin:> with params = nil.
 */
- (void) fireJoin;

/**
 * Emits related event and set flags if current status is valid.
 * @param params Dictionary of key:value pairs to add to the request
 */
- (void) fireJoin:(nullable NSDictionary<NSString *, NSString *> *) params;

/**
 * Shortcut for <firePause:> with params = nil.
 */
- (void) firePause;

/**
 * Emits related event and set flags if current status is valid.
 * @param params Map of key:value pairs to add to the request
 */
- (void) firePause:(nullable NSDictionary<NSString *, NSString *> *) params;

/**
 * Shortcut for <fireResume:> with params = nil.
 */
- (void) fireResume;

/**
 * Emits related event and set flags if current status is valid.
 * @param params Map of key:value pairs to add to the request
 */
- (void) fireResume:(nullable NSDictionary<NSString *, NSString *> *) params;

/**
 * Shortcut for <fireBufferBegin:> with params = nil and convertFromSeek = false.
 */
- (void) fireBufferBegin;

/**
 * Shortcut for <fireBufferBegin:> with params = nil.
 * @param convertFromSeek whether to convert an existing seek into buffer or not
 */
- (void) fireBufferBegin: (bool) convertFromSeek;
                         
/**
 * Emits related event and set flags if current status is valid.
 * @param params Map of key:value pairs to add to the request
 * @param convertFromSeek whether to convert an existing seek into buffer or not
 */
- (void) fireBufferBegin:(nullable NSDictionary<NSString *, NSString *> *) params convertFromSeek: (bool) convertFromSeek;
                         
/**
 * Shortcut for <fireBufferEnd:> with params = nil.
 */
- (void) fireBufferEnd;
                         
/**
 * Emits related event and set flags if current status is valid.
 * @param params Map of key:value pairs to add to the request
 */
- (void) fireBufferEnd:(nullable NSDictionary<NSString *, NSString *> *) params;
                         
/**
 * Shortcut for <fireSeekBegin:> with params = nil and convertFromBuffer = false.
 */
- (void) fireSeekBegin;
                         
/**
 * Shortcut for <fireSeekBegin:> with params = nil.
 * @param convertFromBuffer whether to convert an existing buffer into seek or not
 */
- (void) fireSeekBegin:(bool) convertFromBuffer;
                                                
/**
 * Emits related event and set flags if current status is valid.
 * @param params Map of key:value pairs to add to the request
 * @param convertFromBuffer whether to convert an existing buffer into seek or not
 */
- (void) fireSeekBegin:(nullable NSDictionary<NSString *, NSString *> *) params convertFromBuffer:(bool) convertFromBuffer;
                                                
/**
 * Shortcut for <fireSeekEnd:> with params = nil.
 */
- (void) fireSeekEnd;
                                                
/**
 * Emits related event and set flags if current status is valid.
 * @param params Map of key:value pairs to add to the request
 */
- (void) fireSeekEnd:(nullable NSDictionary<NSString *, NSString *> *) params;
                                                
/**
 * Shortcut for <fireStop:> with params = nil.
 */
- (void) fireStop;

/**
 * Emits related event and set flags if current status is valid.
 * @param params Map of key:value pairs to add to the request
 */
- (void) fireStop:(nullable NSDictionary<NSString *, NSString *> *) params;

/**
 * Shortcut for <fireStop:> with a param skipped = true
 */
- (void) fireSkip;

/**
 * Shortcut for <fireStop:> with a param casted = true
 */
- (void) fireCast;

/**
 * Shortcut for <fireClick:> with {@code params = null}.
 */
- (void) fireClick;

/**
 * Shortcut for <fireClick:> accepting an url
 * @param adUrl NSString with clicktrough url
 */
- (void) fireClickWithAdUrl:(nullable NSString*) adUrl;

/**
 * Emits related event and set flags if current status is valid. Only for ads
 * @param params Map of key:value pairs to add to the request
 */
- (void) fireClick:(nullable NSDictionary<NSString *, NSString *> *) params;

/**
 * Shortcut for <fireAllAdsCompleted:> with {@code params = null}.
 */
- (void)fireAllAdsCompleted __deprecated_msg("This method is going to be removed on future releases");

/**
 * Let the plugin know that all ads have been played
 * @param params params to add to the request. If it is null default values will be added.
 */
- (void)fireAllAdsCompleted:(nullable NSDictionary<NSString *, NSString *> *) params __deprecated_msg("This method is going to be removed on future releases");
/**
 * Basic error handler. msg, code, errorMetadata and level params can be included in the params
 * argument.
 * @param params params to add to the request. If it is null default values will be added.
 */
- (void) fireError:(nullable NSDictionary<NSString *, NSString *> *) params;
                                                
/**
 * Sends a non-fatal error (with level = "error").
 * @param msg Error message (should be unique for the code)
 * @param code Error code reported
 * @param errorMetadata Extra error info, if available.
 */
- (void) fireErrorWithMessage:(nullable NSString *) msg code:(nullable NSString *) code andMetadata:(nullable NSString *) errorMetadata;

/**
 * Sends a non-fatal error (with level = "error"). It's empty by default, every adapter
 * can override it
 * @param msg Error message (should be unique for the code)
 * @param code Error code reported
 * @param errorMetadata Extra error info, if available.
 * @param exception Exception type crom player
 */
- (void) fireErrorWithMessage:(nullable NSString *) msg code:(nullable NSString *) code andMetadata:(nullable NSString *) errorMetadata andException:(nullable NSException *)exception;

/**
 * Shortcut for <fireError:>.
 * This method will also send a stop after the error.
 * @param params params to add to the request. If it is null default values will be added.
 */
- (void) fireFatalError:(nullable NSDictionary<NSString *, NSString *> *) params;
                                                                   
/**
 * Sends a fatal error.
 * This method will also send a stop after the error.
 * @param msg Error message (should be unique for the code)
 * @param code Error code reported
 * @param errorMetadata Extra error info, if available.
 */
- (void) fireFatalErrorWithMessage:(nullable NSString *) msg code:(nullable NSString *) code andMetadata:(nullable NSString *) errorMetadata;

/**
 * Sends a fatal error. It's empty by default, every adapter
 * can override it.
 * This method will also send a stop after the error.
 * @param msg Error message (should be unique for the code)
 * @param code Error code reported
 * @param errorMetadata Extra error info, if available.
 * @param exception Exception type crom player
 */
- (void) fireFatalErrorWithMessage:(nullable NSString *) msg code:(nullable NSString *) code andMetadata:(nullable NSString *) errorMetadata andException:(nullable NSException *)exception;



/**
 * Adds an adapter delegate that will be called whenever the Adapter
 * fires an event
 * @param delegate the delegate to add
 */
- (void) addYouboraAdapterDelegate:(id<YBPlayerAdapterEventDelegate>) delegate;

/**
 * Removes a previously registered delegate
 * @param delegate the delegate to remove
 */
- (void) removeYouboraAdapterDelegate:(id<YBPlayerAdapterEventDelegate>) delegate;

@end

/**
 * Event Delegate. The methods will be called whenever each corresponding event is fired.
 * These events are listened by the <Plugin> in order to send the corresponding request.
 */
@protocol YBPlayerAdapterEventDelegate

@optional
    
/**
 * Adapter detected an adInit event
 * @param params params to add to the request
 * @param adapter the adapter taht is firing the event
 */
- (void) youboraAdapterEventAdInit:(nullable NSDictionary *) params fromAdapter:(YBPlayerAdapter *) adapter;
    
/**
 * Adapter detected a start event.
 * @param params params to add to the request
 * @param adapter the adapter that is firing the event
 */
- (void) youboraAdapterEventStart:(nullable NSDictionary *) params fromAdapter:(YBPlayerAdapter *) adapter;

/**
 * Adapter detected a join event.
 * @param params params to add to the request
 * @param adapter the adapter that is firing the event
 */
- (void) youboraAdapterEventJoin:(nullable NSDictionary *) params fromAdapter:(YBPlayerAdapter *) adapter;

/**
 * Adapter detected a pause event.
 * @param params params to add to the request
 * @param adapter the adapter that is firing the event
 */
- (void) youboraAdapterEventPause:(nullable NSDictionary *) params fromAdapter:(YBPlayerAdapter *) adapter;

/**
 * Adapter detected a resume event.
 * @param params params to add to the request
 * @param adapter the adapter that is firing the event
 */
- (void) youboraAdapterEventResume:(nullable NSDictionary *) params fromAdapter:(YBPlayerAdapter *) adapter;

/**
 * Adapter detected a stop event.
 * @param params params to add to the request
 * @param adapter the adapter that is firing the event
 */
- (void) youboraAdapterEventStop:(nullable NSDictionary *) params fromAdapter:(YBPlayerAdapter *) adapter;

/**
 * Adapter detected a buffer begin event.
 * @param params params to add to the request
 * @param convertFromSeek whether the buffer has been converted from a seek or not
 * @param adapter the adapter that is firing the event
 */
- (void) youboraAdapterEventBufferBegin:(nullable NSDictionary *) params convertFromSeek:(bool) convertFromSeek fromAdapter:(YBPlayerAdapter *) adapter;;

/**
 * Adapter detected a buffer end event.
 * @param params params to add to the request
 * @param adapter the adapter that is firing the event
 */
- (void) youboraAdapterEventBufferEnd:(nullable NSDictionary *) params fromAdapter:(YBPlayerAdapter *) adapter;

/**
 * Adapter detected a seek begin event.
 * @param params params to add to the request
 * @param convertFromBuffer whether the seek has been converted from a buffer or not
 * @param adapter the adapter that is firing the event
 */
- (void) youboraAdapterEventSeekBegin:(nullable NSDictionary *) params convertFromBuffer:(bool) convertFromBuffer fromAdapter:(YBPlayerAdapter *) adapter;;

/**
 * Adapter detected a seek end event.
 * @param params params to add to the request
 * @param adapter the adapter that is firing the event
 */
- (void) youboraAdapterEventSeekEnd:(nullable NSDictionary *) params fromAdapter:(YBPlayerAdapter *) adapter;

/**
 * Adapter detected an error event.
 * @param params params to add to the request
 * @param adapter the adapter that is firing the event
 */
- (void) youboraAdapterEventError:(nullable NSDictionary *) params fromAdapter:(YBPlayerAdapter *) adapter;

/**
 * Adapter detected ad click
 * @param params params to add to the request
 * @param adapter the adapter that is firing the event
 */
- (void) youboraAdapterEventClick:(nullable NSDictionary *) params fromAdapter:(YBPlayerAdapter *) adapter;

/**
 * Adapter detected when all ads finished playing
 * @param params params to add to the request
 * @param adapter the adapter that is firing the event
 */
- (void) youboraAdapterEventAllAdsCompleted:(nullable NSDictionary *) params fromAdapter:(YBPlayerAdapter *) adapter;
@end

NS_ASSUME_NONNULL_END
