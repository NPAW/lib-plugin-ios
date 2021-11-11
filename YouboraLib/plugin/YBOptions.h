//
//  YBOptions.h
//  YouboraLib
//
//  Created by Joan on 17/03/2017.
//  Copyright © 2017 NPAW. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * This class stores all the Youbora configuration settings.
 * Any value specified in this class, if set, will override the info the plugin is able to get on
 * its own.
 *
 * The only <b>required</b> option is the <accountCode>.
 */

@interface YBOptions : NSObject<NSCoding>

/// ---------------------------------
/// @name Public properties
/// ---------------------------------

///// Option keys
extern NSString * _Nullable const YBOPTIONS_KEY_ENABLED __deprecated_msg("Use [YBOptionKeys enabled] instead");
extern NSString * _Nullable const YBOPTIONS_KEY_HTTP_SECURE  __deprecated_msg("Use YBOptionKeys instead");
extern NSString * _Nullable const YBOPTIONS_KEY_HOST  __deprecated_msg("Use YBOptionKeys instead");
extern NSString * _Nullable const YBOPTIONS_KEY_ACCOUNT_CODE  __deprecated_msg("Use YBOptionKeys instead");
extern NSString * _Nullable const YBOPTIONS_KEY_USERNAME  __deprecated_msg("Use YBOptionKeys instead");
extern NSString * _Nullable const YBOPTIONS_KEY_ANONYMOUS_USER  __deprecated_msg("Use YBOptionKeys instead");
extern NSString * _Nullable const YBOPTIONS_KEY_OFFLINE  __deprecated_msg("Use YBOptionKeys instead");
extern NSString * _Nullable const YBOPTIONS_KEY_IS_INFINITY  __deprecated_msg("Use YBOptionKeys instead");
extern NSString * _Nullable const YBOPTIONS_KEY_BACKGROUND  __deprecated_msg("Use YBOptionKeys instead");
extern NSString * _Nullable const YBOPTIONS_KEY_AUTOSTART  __deprecated_msg("Use YBOptionKeys instead");
extern NSString * _Nullable const YBOPTIONS_KEY_FORCEINIT  __deprecated_msg("Use YBOptionKeys instead");
extern NSString * _Nullable const YBOPTIONS_KEY_USER_TYPE  __deprecated_msg("Use YBOptionKeys instead");
extern NSString * _Nullable const YBOPTIONS_KEY_USER_EMAIL  __deprecated_msg("Use YBOptionKeys instead");
extern NSString * _Nullable const YBOPTIONS_KEY_EXPERIMENT_IDS  __deprecated_msg("Use YBOptionKeys instead");
extern NSString * _Nullable const YBOPTIONS_KEY_SS_CONFIG_CODE  __deprecated_msg("Use YBOptionKeys instead");
extern NSString * _Nullable const YBOPTIONS_KEY_SS_GROUP_CODE  __deprecated_msg("Use YBOptionKeys instead");
extern NSString * _Nullable const YBOPTIONS_KEY_SS_CONTRACT_CODE  __deprecated_msg("Use YBOptionKeys instead");

extern NSString * _Nullable const YBOPTIONS_KEY_PARSE_HLS  __deprecated_msg("Use YBOptionKeys instead");
extern NSString * _Nullable const YBOPTIONS_KEY_PARSE_CDN_NAME_HEADER  __deprecated_msg("Use YBOptionKeys instead");
extern NSString * _Nullable const YBOPTIONS_KEY_PARSE_CDN_NODE  __deprecated_msg("Use YBOptionKeys instead");
extern NSString * _Nullable const YBOPTIONS_KEY_PARSE_CDN_NODE_LIST  __deprecated_msg("Use YBOptionKeys instead");
extern NSString * _Nullable const YBOPTIONS_KEY_PARSE_LOCATION_HEADER  __deprecated_msg("Use YBOptionKeys instead");

extern NSString * _Nullable const YBOPTIONS_KEY_NETWORK_IP  __deprecated_msg("Use YBOptionKeys instead");
extern NSString * _Nullable const YBOPTIONS_KEY_NETWORK_ISP  __deprecated_msg("Use YBOptionKeys instead");
extern NSString * _Nullable const YBOPTIONS_KEY_NETWORK_CONNECTION_TYPE  __deprecated_msg("Use YBOptionKeys instead");
extern NSString * _Nullable const YBOPTIONS_KEY_USER_OBFUSCATE_IP  __deprecated_msg("Use YBOptionKeys instead");

extern NSString * _Nullable const YBOPTIONS_KEY_DEVICE_CODE  __deprecated_msg("Use YBOptionKeys instead");
extern NSString * _Nullable const YBOPTIONS_KEY_DEVICE_MODEL  __deprecated_msg("Use YBOptionKeys instead");
extern NSString * _Nullable const YBOPTIONS_KEY_DEVICE_BRAND  __deprecated_msg("Use YBOptionKeys instead");
extern NSString * _Nullable const YBOPTIONS_KEY_DEVICE_TYPE  __deprecated_msg("Use YBOptionKeys instead");
extern NSString * _Nullable const YBOPTIONS_KEY_DEVICE_NAME  __deprecated_msg("Use YBOptionKeys instead");
extern NSString * _Nullable const YBOPTIONS_KEY_DEVICE_OS_NAME  __deprecated_msg("Use YBOptionKeys instead");
extern NSString * _Nullable const YBOPTIONS_KEY_DEVICE_OS_VERSION  __deprecated_msg("Use YBOptionKeys instead");
extern NSString * _Nullable const YBOPTIONS_KEY_DEVICE_IS_ANONYMOUS  __deprecated_msg("Use YBOptionKeys instead");

extern NSString * _Nullable const YBOPTIONS_KEY_CONTENT_RESOURCE  __deprecated_msg("Use YBOptionKeys instead");
extern NSString * _Nullable const YBOPTIONS_KEY_CONTENT_IS_LIVE __deprecated_msg("Use YBOptionKeys instead");
extern NSString * _Nullable const YBOPTIONS_KEY_CONTENT_TITLE __deprecated_msg("Use YBOptionKeys instead");
extern NSString * _Nullable const YBOPTIONS_KEY_CONTENT_PROGRAM __deprecated_msg("Use YBOptionKeys instead");
extern NSString * _Nullable const YBOPTIONS_KEY_CONTENT_DURATION __deprecated_msg("Use YBOptionKeys instead");
extern NSString * _Nullable const YBOPTIONS_KEY_CONTENT_TRANSACTION_CODE __deprecated_msg("Use YBOptionKeys instead");
extern NSString * _Nullable const YBOPTIONS_KEY_CONTENT_BITRATE __deprecated_msg("Use YBOptionKeys instead");
extern NSString * _Nullable const YBOPTIONS_KEY_CONTENT_THROUGHPUT __deprecated_msg("Use YBOptionKeys instead");
extern NSString * _Nullable const YBOPTIONS_KEY_CONTENT_RENDITION __deprecated_msg("Use YBOptionKeys instead");
extern NSString * _Nullable const YBOPTIONS_KEY_CONTENT_CDN __deprecated_msg("Use YBOptionKeys instead");
extern NSString * _Nullable const YBOPTIONS_KEY_CONTENT_FPS __deprecated_msg("Use YBOptionKeys instead");
extern NSString * _Nullable const YBOPTIONS_KEY_CONTENT_STREAMING_PROTOCOL __deprecated_msg("Use YBOptionKeys instead");
extern NSString * _Nullable const YBOPTIONS_KEY_CONTENT_METADATA __deprecated_msg("Use YBOptionKeys instead");
extern NSString * _Nullable const YBOPTIONS_KEY_CONTENT_METRICS __deprecated_msg("Use YBOptionKeys instead");
extern NSString * _Nullable const YBOPTIONS_KEY_CONTENT_IS_LIVE_NO_SEEK __deprecated_msg("Use YBOptionKeys instead");

extern NSString * _Nullable const YBOPTIONS_KEY_CONTENT_PACKAGE __deprecated_msg("Use YBOptionKeys instead");
extern NSString * _Nullable const YBOPTIONS_KEY_CONTENT_SAGA __deprecated_msg("Use YBOptionKeys instead");
extern NSString * _Nullable const YBOPTIONS_KEY_CONTENT_TV_SHOW __deprecated_msg("Use YBOptionKeys instead");
extern NSString * _Nullable const YBOPTIONS_KEY_CONTENT_SEASON __deprecated_msg("Use YBOptionKeys instead");
extern NSString * _Nullable const YBOPTIONS_KEY_CONTENT_EPISODE_TITLE __deprecated_msg("Use YBOptionKeys instead");
extern NSString * _Nullable const YBOPTIONS_KEY_CONTENT_CHANNEL __deprecated_msg("Use YBOptionKeys instead");
extern NSString * _Nullable const YBOPTIONS_KEY_CONTENT_ID __deprecated_msg("Use YBOptionKeys instead");
extern NSString * _Nullable const YBOPTIONS_KEY_CONTENT_IMDB_ID __deprecated_msg("Use YBOptionKeys instead");
extern NSString * _Nullable const YBOPTIONS_KEY_CONTENT_GRACENOTE_ID __deprecated_msg("Use YBOptionKeys instead");
extern NSString * _Nullable const YBOPTIONS_KEY_CONTENT_TYPE __deprecated_msg("Use YBOptionKeys instead");
extern NSString * _Nullable const YBOPTIONS_KEY_CONTENT_GENRE __deprecated_msg("Use YBOptionKeys instead");
extern NSString * _Nullable const YBOPTIONS_KEY_CONTENT_LANGUAGE __deprecated_msg("Use YBOptionKeys instead");
extern NSString * _Nullable const YBOPTIONS_KEY_CONTENT_SUBTITLES __deprecated_msg("Use YBOptionKeys instead");
extern NSString * _Nullable const YBOPTIONS_KEY_CONTENT_CONTRACTED_RESOLUTION __deprecated_msg("Use YBOptionKeys instead");
extern NSString * _Nullable const YBOPTIONS_KEY_CONTENT_COST __deprecated_msg("Use YBOptionKeys instead");
extern NSString * _Nullable const YBOPTIONS_KEY_CONTENT_PRICE __deprecated_msg("Use YBOptionKeys instead");
extern NSString * _Nullable const YBOPTIONS_KEY_CONTENT_PLAYBACK_TYPE __deprecated_msg("Use YBOptionKeys instead");
extern NSString * _Nullable const YBOPTIONS_KEY_CONTENT_DRM __deprecated_msg("Use YBOptionKeys instead");
extern NSString * _Nullable const YBOPTIONS_KEY_CONTENT_ENCODING_VIDEO_CODEC __deprecated_msg("Use YBOptionKeys instead");
extern NSString * _Nullable const YBOPTIONS_KEY_CONTENT_ENCODING_AUDIO_CODEC __deprecated_msg("Use YBOptionKeys instead");
extern NSString * _Nullable const YBOPTIONS_KEY_CONTENT_ENCODING_CODEC_SETTINGS __deprecated_msg("Use YBOptionKeys instead");
extern NSString * _Nullable const YBOPTIONS_KEY_CONTENT_ENCODING_CODEC_PROFILE __deprecated_msg("Use YBOptionKeys instead");
extern NSString * _Nullable const YBOPTIONS_KEY_CONTENT_ENCODING_CONTAINER_FORMAT __deprecated_msg("Use YBOptionKeys instead");
 
extern NSString * _Nullable const YBOPTIONS_KEY_SESSION_METRICS __deprecated_msg("Use YBOptionKeys instead");

extern NSString * _Nullable const YBOPTIONS_KEY_AD_METADATA __deprecated_msg("Use YBOptionKeys instead");
extern NSString * _Nullable const YBOPTIONS_KEY_AD_IGNORE __deprecated_msg("Use YBOptionKeys instead");
extern NSString * _Nullable const YBOPTIONS_KEY_ADS_AFTERSTOP __deprecated_msg("Use YBOptionKeys instead");
extern NSString * _Nullable const YBOPTIONS_KEY_AD_CAMPAIGN __deprecated_msg("Use YBOptionKeys instead");
extern NSString * _Nullable const YBOPTIONS_KEY_AD_TITLE __deprecated_msg("Use YBOptionKeys instead");
extern NSString * _Nullable const YBOPTIONS_KEY_AD_RESOURCE __deprecated_msg("Use YBOptionKeys instead");
extern NSString * _Nullable const YBOPTIONS_KEY_AD_GIVEN_BREAKS __deprecated_msg("Use YBOptionKeys instead");
extern NSString * _Nullable const YBOPTIONS_KEY_AD_EXPECTED_BREAKS __deprecated_msg("Use YBOptionKeys instead");
extern NSString * _Nullable const YBOPTIONS_KEY_AD_EXPECTED_PATTERN  __deprecated_msg("Use YBOptionKeys instead");
extern NSString * _Nullable const YBOPTIONS_KEY_AD_BREAKS_TIME __deprecated_msg("Use YBOptionKeys instead");
extern NSString * _Nullable const YBOPTIONS_KEY_AD_GIVEN_ADS __deprecated_msg("Use YBOptionKeys instead");
extern NSString * _Nullable const YBOPTIONS_KEY_AD_CREATIVEID __deprecated_msg("Use YBOptionKeys instead");
extern NSString * _Nullable const YBOPTIONS_KEY_AD_PROVIDER __deprecated_msg("Use YBOptionKeys instead");

extern NSString * _Nullable const YBOPTIONS_KEY_CONTENT_CUSTOM_DIMENSION_1 __deprecated_msg("Use YBOptionKeys instead");
extern NSString * _Nullable const YBOPTIONS_KEY_CONTENT_CUSTOM_DIMENSION_2 __deprecated_msg("Use YBOptionKeys instead");
extern NSString * _Nullable const YBOPTIONS_KEY_CONTENT_CUSTOM_DIMENSION_3 __deprecated_msg("Use YBOptionKeys instead");
extern NSString * _Nullable const YBOPTIONS_KEY_CONTENT_CUSTOM_DIMENSION_4 __deprecated_msg("Use YBOptionKeys instead");
extern NSString * _Nullable const YBOPTIONS_KEY_CONTENT_CUSTOM_DIMENSION_5 __deprecated_msg("Use YBOptionKeysinstead");
extern NSString * _Nullable const YBOPTIONS_KEY_CONTENT_CUSTOM_DIMENSION_6 __deprecated_msg("Use YBOptionKeys instead");
extern NSString * _Nullable const YBOPTIONS_KEY_CONTENT_CUSTOM_DIMENSION_7 __deprecated_msg("Use YBOptionKeys instead");
extern NSString * _Nullable const YBOPTIONS_KEY_CONTENT_CUSTOM_DIMENSION_8 __deprecated_msg("Use YBOptionKeys instead");
extern NSString * _Nullable const YBOPTIONS_KEY_CONTENT_CUSTOM_DIMENSION_9 __deprecated_msg("Use YBOptionKeysinstead");
extern NSString * _Nullable const YBOPTIONS_KEY_CONTENT_CUSTOM_DIMENSION_10 __deprecated_msg("Use YBOptionKeys instead");
extern NSString * _Nullable const YBOPTIONS_KEY_CONTENT_CUSTOM_DIMENSION_11 __deprecated_msg("Use YBOptionKeys instead");
extern NSString * _Nullable const YBOPTIONS_KEY_CONTENT_CUSTOM_DIMENSION_12 __deprecated_msg("Use YBOptionKeys instead");
extern NSString * _Nullable const YBOPTIONS_KEY_CONTENT_CUSTOM_DIMENSION_13 __deprecated_msg("Use YBOptionKeys instead");
extern NSString * _Nullable const YBOPTIONS_KEY_CONTENT_CUSTOM_DIMENSION_14 __deprecated_msg("Use YBOptionKeys instead");
extern NSString * _Nullable const YBOPTIONS_KEY_CONTENT_CUSTOM_DIMENSION_15 __deprecated_msg("Use YBOptionKeys instead");
extern NSString * _Nullable const YBOPTIONS_KEY_CONTENT_CUSTOM_DIMENSION_16 __deprecated_msg("Use YBOptionKeys instead");
extern NSString * _Nullable const YBOPTIONS_KEY_CONTENT_CUSTOM_DIMENSION_17 __deprecated_msg("Use YBOptionKeys instead");
extern NSString * _Nullable const YBOPTIONS_KEY_CONTENT_CUSTOM_DIMENSION_18 __deprecated_msg("Use YBOptionKeys instead");
extern NSString * _Nullable const YBOPTIONS_KEY_CONTENT_CUSTOM_DIMENSION_19 __deprecated_msg("Use YBOptionKeys instead");
extern NSString * _Nullable const YBOPTIONS_KEY_CONTENT_CUSTOM_DIMENSION_20 __deprecated_msg("Use YBOptionKeys instead");

extern NSString * _Nullable const YBOPTIONS_KEY_AD_CUSTOM_DIMENSION_1 __deprecated_msg("Use YBOptionKeys instead");
extern NSString * _Nullable const YBOPTIONS_KEY_AD_CUSTOM_DIMENSION_2 __deprecated_msg("Use YBOptionKeys instead");
extern NSString * _Nullable const YBOPTIONS_KEY_AD_CUSTOM_DIMENSION_3 __deprecated_msg("Use YBOptionKeys instead");
extern NSString * _Nullable const YBOPTIONS_KEY_AD_CUSTOM_DIMENSION_4 __deprecated_msg("Use YBOptionKeys instead");
extern NSString * _Nullable const YBOPTIONS_KEY_AD_CUSTOM_DIMENSION_5 __deprecated_msg("Use YBOptionKeys instead");
extern NSString * _Nullable const YBOPTIONS_KEY_AD_CUSTOM_DIMENSION_6 __deprecated_msg("Use YBOptionKeys instead");
extern NSString * _Nullable const YBOPTIONS_KEY_AD_CUSTOM_DIMENSION_7 __deprecated_msg("Use YBOptionKeys instead");
extern NSString * _Nullable const YBOPTIONS_KEY_AD_CUSTOM_DIMENSION_8 __deprecated_msg("Use YBOptionKeys instead");
extern NSString * _Nullable const YBOPTIONS_KEY_AD_CUSTOM_DIMENSION_9 __deprecated_msg("Use YBOptionKeys instead");
extern NSString * _Nullable const YBOPTIONS_KEY_AD_CUSTOM_DIMENSION_10 __deprecated_msg("Use YBOptionKeys instead");

extern NSString * _Nullable const YBOPTIONS_KEY_APP_NAME __deprecated_msg("Use YBOptionKeys instead");
extern NSString * _Nullable const YBOPTIONS_KEY_APP_RELEASE_VERSION __deprecated_msg("Use YBOptionKeys instead");

extern NSString * _Nullable const YBOPTIONS_KEY_LINKED_VIEW_ID __deprecated_msg("Use YBOptionKeys instead");
extern NSString * _Nullable const YBOPTIONS_KEY_WAIT_METADATA __deprecated_msg("Use YBOptionKeys instead");
extern NSString * _Nullable const YBOPTIONS_KEY_PENDING_METADATA __deprecated_msg("Use YBOptionKeys instead");

extern NSString * _Nullable const YBOPTIONS_KEY_SESSION_METRICS __deprecated_msg("Use YBOptionKeys instead");

//Ad position YBConstants
extern NSString * _Nullable const YBOPTIONS_AD_POSITION_PRE __deprecated_msg("Use YBOptionKeys instead");
extern NSString * _Nullable const YBOPTIONS_AD_POSITION_MID __deprecated_msg("Use YBOptionKeys instead");
extern NSString * _Nullable const YBOPTIONS_AD_POSITION_POST __deprecated_msg("Use YBOptionKeys instead");

/// Public methods
- (NSDictionary *_Nullable) toDictionary;

/// Options
/**
 * If enabled the plugin won't send NQS requests.
 * Default: true
 */
@property(nonatomic, assign) bool enabled;

/**
 * Define the security of NQS calls.
 * If true it will use "https://".
 * If false it will use "http://".
 * Default: true
 */
@property(nonatomic, assign) bool httpSecure;

/**
 * Host of the Fastdata service.
 */
@property(nonatomic, strong) NSString * _Nullable host;

/**
 * NicePeopleAtWork account code that indicates the customer account.
 */
@property(nonatomic, strong) NSString * _Nullable accountCode;

/**
 * User ID value inside your system.
 */
@property(nonatomic, strong) NSString * _Nullable username;

/**
 * User type value inside your system.
 */
@property(nonatomic, strong) NSString * _Nullable userType;

/**
 * User email
 */
@property(nonatomic, strong) NSString * _Nullable userEmail;

/**
 * If true the plugin will parse hls, cdn and location
 * It might slow performance down.
 * Default: false
 */
@property(nonatomic, assign) bool parseResource;

/**
 * If true the plugin will parse HLS files to use the first .ts file found as resource.
 * It might slow performance down.
 * Default: false
 */
@property(nonatomic, assign, setter=setResourceParseJoin:) bool parseHls DEPRECATED_MSG_ATTRIBUTE("Use parseResource instead.");

/**
 * If true the plugin will look for the location and segment values inside dash manifest to retrieve the actual resource
 * It might slow performance down.
 * Default: false
 */
@property(nonatomic, assign, setter=setResourceParseJoin:) bool parseDash DEPRECATED_MSG_ATTRIBUTE("Use parseResource instead.");

/**
 * If true the plugin will parse the resource to try and find out the real given resource instead of the API url
 * It might slow performance down.
 * Default: false
 */
@property(nonatomic, assign, setter=setResourceParseJoin:) bool parseLocationHeader DEPRECATED_MSG_ATTRIBUTE("Use parseResource instead.");

/**
 * If defined, resource parse will try to fetch the CDN code from the custom header defined
 * by this property, e.g. "x-cdn-forward"
 */
@property(nonatomic, strong) NSString * _Nullable parseCdnNameHeader;

/**
 * If true the plugin will query the CDN to retrieve the node name.
 * It might slow performance down.
 * Default: false
 */
@property(nonatomic, assign) bool parseCdnNode;

/**
 * List of CDN names to parse. This is only used when <parseCdnNode> is enabled.
 * Order is respected when trying to match against a CDN.
 * Default: ["Akamai", "Cloudfront", "Level3", "Fastly", "Highwinds"].
 */
@property(nonatomic, strong) NSMutableArray<NSString *> * _Nullable parseCdnNodeList;

/*
 Flag indicating if the cdn parser should search for new cdn
 */
@property(nonatomic) BOOL cdnSwitchHeader;

/**
 Interval of time to search for a new cdn
*/
@property(nonatomic) NSTimeInterval cdnTTL;

/**
 * List of experiment ids to use with SmartUsers
 */
@property(nonatomic, strong) NSMutableArray<NSString *> * _Nullable experimentIds;

/**
 * IP of the viewer/user, e.g. "48.15.16.23".
 */
@property(nonatomic, strong) NSString * _Nullable networkIP;

/**
 * Name of the internet service provider of the viewer/user.
 */
@property(nonatomic, strong) NSString * _Nullable networkIsp;

/**
 * See a list of codes in <a href="http://mapi.youbora.com:8081/connectionTypes">http://mapi.youbora.com:8081/connectionTypes</a>.
 */
@property(nonatomic, strong) NSString * _Nullable networkConnectionType;

/**
 * If the ip address should be abfuscated
 */
@property(nonatomic, strong, setter=setNetworkObfuscateIp:) NSValue * _Nullable networkObfuscateIp __deprecated_msg("Use userObfuscateIp instead");

/**
 * If the ip address should be abfuscated
 */
@property(nonatomic, strong) NSValue * _Nullable userObfuscateIp;

/**
 * Youbora's device code. If specified it will rewrite info gotten from user agent.
 * See a list of codes in <a href="http://mapi.youbora.com:8081/devices">http://mapi.youbora.com:8081/devices</a>.
 */
@property(nonatomic, strong) NSString * _Nullable deviceCode;

/**
 * Force init enabled
 */
@property(nonatomic, assign) bool forceInit;

/**
* What will be displayed as the device model on Youbora (provided by default with android.os.Build.MODEL if not set)
*/
@property(nonatomic, strong) NSString * _Nullable deviceModel;

/**
 * What will be displayed as the device brand on Youbora (provided by default with android.os.Build.BRAND if not set)
 */
@property(nonatomic, strong) NSString * _Nullable deviceBrand;

/**
 * What will be displayed as the device type on Youbora (pc, smartphone, stb, tv, etc.)
 */
@property(nonatomic, strong) NSString * _Nullable deviceType;

/**
 * What will be displayed as the device name on Youbora (pc, smartphone, stb, tv, etc.)
 */
@property(nonatomic, strong) NSString * _Nullable deviceName;

/**
 * OS name that will be displayed on Youbora
 */
@property(nonatomic, strong) NSString * _Nullable deviceOsName;

/**
 * OS version that will be displayed on Youbora (provided by default with android.os.Build.VERSION.RELEASE if not set)
 */
@property(nonatomic, strong) NSString * _Nullable deviceOsVersion;

/**
 * Option to not send deviceUUID
 */
@property(nonatomic, assign) BOOL deviceIsAnonymous;

/**
 * Option to send a custom deviceUUID
 */
@property(nonatomic, strong, nullable) NSString* deviceUUID;

/**
 * Option to send HDMI EDID value
 */
@property(nonatomic, strong, nullable) id deviceEDID;

/**
 * URL/path of the current media resource.
 */
@property(nonatomic, strong) NSString * _Nullable contentResource;

/**
 * @YES if the content is Live. @NO if VOD. Default: nil.
 */
@property(nonatomic, strong) NSValue * _Nullable contentIsLive;

/**
 * Title of the media.
 */
@property(nonatomic, strong) NSString * _Nullable contentTitle;

/**
 * Secondary title of the media. This could be program name, season, episode, etc.
 */
@property(nonatomic, strong, setter=setContentTitle2:) NSString * _Nullable contentTitle2 __deprecated_msg("Use program instead");

/**
 * Program title of the media. This could be program name, season, episode, etc.
 */
@property(nonatomic, strong) NSString * _Nullable program;

/**
 * Duration of the media <b>in seconds</b>.
 */
@property(nonatomic, strong) NSNumber * _Nullable contentDuration; // double

/**
 * Custom unique code to identify the view.
 */
@property(nonatomic, strong) NSString * _Nullable contentTransactionCode;

/**
 * Bitrate of the content in bits per second.
 */
@property(nonatomic, strong) NSNumber * _Nullable contentBitrate; // long

/**
 * Total downloaded bytes of the content.
 */
@property NSNumber* _Nullable contentTotalBytes;
/**
 * Flag that indicates if the plugin should send total bytes or not
 */
@property NSNumber* _Nullable sendTotalBytes;


/**
 * Streaming protocol of the content, you can use any of these YBConstantsStreamProtocol:
 YBConstantsStreamProtocol.hds
 YBConstantsStreamProtocol.hls
 YBConstantsStreamProtocol.mss
 YBConstantsStreamProtocol.dash
 YBConstantsStreamProtocol.rtmp
 YBConstantsStreamProtocol.rtp
 YBConstantsStreamProtocol.rtsp
 */
@property (nonatomic, strong ,setter=setContentStreamingProtocol:) NSString* _Nullable  contentStreamingProtocol;

/**
* Transport format of the content, you can use any of these YBConstantsTransportFormat:
 YBConstantsTransportFormat.hlsTs
 YBConstantsTransportFormat.hlsFmp4
 YBConstantsTransportFormat.hlsCmfv
*/
@property(nonatomic, strong, setter=setContentTransportFormat:) NSString* _Nullable contentTransportFormat;

/**
 * Throughput of the client bandwidth in bits per second.
 */
@property(nonatomic, strong) NSNumber * _Nullable contentThroughput; // long

/**
 * Name or value of the current rendition (quality) of the content.
 */
@property(nonatomic, strong) NSString * _Nullable contentRendition;

/**
 * Codename of the CDN where the content is streaming from.
 * See a list of codes in <a href="http://mapi.youbora.com:8081/cdns">http://mapi.youbora.com:8081/cdns</a>.
 */
@property(nonatomic, strong) NSString * _Nullable contentCdn;

/**
 * String with the CDN node id.
 */
@property(nonatomic, strong) NSString * _Nullable contentCdnNode;

/**
 * String with the CDN node content access type.
 *  It defines if the content request hits the cache or not.
 */
@property(nonatomic, strong) NSString * _Nullable contentCdnType;

/**
 * Frames per second of the media being played.
 */
@property(nonatomic, strong) NSNumber * _Nullable contentFps; // double

/**
 * NSDictionary containing mixed extra information about the content like: director, parental rating,
 * device info or the audio channels.
 */
@property(nonatomic, strong) NSDictionary * _Nullable contentMetadata;

/**
 * NSDictionary containing the content metrics.
 */
@property(nonatomic, strong) NSDictionary * _Nullable contentMetrics;

/**
 * NSDictionary containing the session metrics.
 */
@property(nonatomic, strong) NSDictionary * _Nullable sessionMetrics;

/**
 * NSValue containing if seeks should be disabled for life content, only applies if content is live, if it's VOD it gets ignored
 */
@property(nonatomic, strong) NSValue * _Nullable contentIsLiveNoSeek;

/**
 * NSValue containing if monitor should be disabled for life content, only applies if content is live, if it's VOD it gets ignored. Should be true if the player returns non consistent values for the playhead on live, so playhead monitor wont work to detect buffers and seeks.
 */
@property(nonatomic, strong) NSValue * _Nullable contentIsLiveNoMonitor;


/**
 * NSString containing the content package
 */
@property(nonatomic, strong) NSString * _Nullable contentPackage;

/**
 * NSString containing the content saga
 */
@property(nonatomic, strong) NSString * _Nullable contentSaga;

/**
 * NSString containing the content show
 */
@property(nonatomic, strong) NSString * _Nullable contentTvShow;

/**
 * NSString containing the content season
 */
@property(nonatomic, strong) NSString * _Nullable contentSeason;

/**
 * NSString containing the content episode title
 */
@property(nonatomic, strong) NSString * _Nullable contentEpisodeTitle;

/**
 * NSString containing the content channel
 */
@property(nonatomic, strong) NSString * _Nullable contentChannel;

/**
 * NSString containing the content id
 */
@property(nonatomic, strong) NSString * _Nullable contentId;

/**
 * NSString containing the content imdb id
 */
@property(nonatomic, strong) NSString * _Nullable contentImdbId;

/**
 * NSString containing the content gracenote id
 */
@property(nonatomic, strong) NSString * _Nullable contentGracenoteId;

/**
 * NSString containing the content type
 */
@property(nonatomic, strong) NSString * _Nullable contentType;

/**
 * NSString containing the content genre
 */
@property(nonatomic, strong) NSString * _Nullable contentGenre;

/**
 * NSString containing the content language
 */
@property(nonatomic, strong) NSString * _Nullable contentLanguage;

/**
 * NSString containing the content subtitles
 */
@property(nonatomic, strong) NSString * _Nullable contentSubtitles;

/**
 * NSString containing the content contracted resolution
 */
@property(nonatomic, strong) NSString * _Nullable contentContractedResolution;

/**
 * NSString containing the content cost
 */
@property(nonatomic, strong) NSString * _Nullable contentCost;

/**
 * NSString containing the content price
 */
@property(nonatomic, strong) NSString * _Nullable contentPrice;

/**
 * NSString containing the content playback type
 */
@property(nonatomic, strong) NSString * _Nullable contentPlaybackType;

/**
 * NSString containing the content drm
 */
@property(nonatomic, strong) NSString * _Nullable contentDrm;

/**
 * NSString containing the content encoding video codec
 */
@property(nonatomic, strong) NSString * _Nullable contentEncodingVideoCodec;

/**
 * NSString containing the content encoding audio codec
 */
@property(nonatomic, strong) NSString * _Nullable contentEncodingAudioCodec;

/**
 * NSString containing the content encoding codec settings
 */
@property(nonatomic, strong) NSDictionary * _Nullable contentEncodingCodecSettings;

/**
 * NSString containing the content encoding codec profile
 */
@property(nonatomic, strong) NSString * _Nullable contentEncodingCodecProfile;

/**
 * NSString containing the content encoding container format
 */
@property(nonatomic, strong) NSString * _Nullable contentEncodingContainerFormat;

/**
 * NSDictionary containing mixed extra information about the ads like: director, parental rating,
 * device info or the audio channels.
 */
@property(nonatomic, strong) NSDictionary * _Nullable adMetadata;

/**
 * Variable containing number of ads after stop
 */
@property(nonatomic, strong) NSNumber* _Nullable adsAfterStop;

/**
 * Variable containing ad campaign
 */
@property(nonatomic, strong) NSString* _Nullable adCampaign;

/**
 * Variable containing ad title
 */
@property(nonatomic, strong) NSString* _Nullable adTitle;

/**
 * Variable containing ad resource
 */
@property(nonatomic, strong) NSString* _Nullable adResource;

/**
 * Variable containing how many ad breaks will be shown for the active view
 */
@property(nonatomic, strong) NSNumber* _Nullable adGivenBreaks;

/**
 * Variable containing how many ad breaks should be shown for the active view
 */
@property(nonatomic, strong) NSNumber* _Nullable adExpectedBreaks;

/**
 * Variable containing how many ads will be shown for each break
 * Keys must be any of the following YBConstants: YBOPTIONS_AD_POSITION_PRE, YBOPTIONS_AD_POSITION_MID or YBOPTIONS_AD_POSITION_POST
 * Value must be an NSArray containing the number of ads per break (each break is an Array position)
 */
@property(nonatomic, strong) NSDictionary<NSString *, NSArray<NSNumber *> *> * _Nullable adExpectedPattern;

/**
 * Variable containing at which moment of the playback a break should be displayed
 */
@property(nonatomic, strong) NSArray* _Nullable adBreaksTime;

/**
 * Variable containing how many ads should be played for the current break
 */
@property(nonatomic, strong) NSNumber* _Nullable adGivenAds;

/**
 * Variable containing ad creativeId
 */
@property(nonatomic, strong) NSString * _Nullable adCreativeId;

/**
 * Variable containing ad provider
 */
@property(nonatomic, strong) NSString * _Nullable adProvider;

/**
 * If true the plugin will fireStop when going to background
 * Default: true
 */
@property(nonatomic, assign) bool autoDetectBackground;

/**
 * @YES if the current view/session could be affected by an ad blocker.
 * @NO if there is no ad blocker.
 * Default: nil.
 */
@property(nonatomic, strong) NSValue * _Nullable adBlockerDetected;

/**
 * If true no request will we send and saved for later instead
 */
@property(nonatomic, assign) bool offline;

/**
 * User ID value inside your system for anon users
 */
@property(nonatomic, strong) NSString * _Nullable anonymousUser;

/**
 * Flag if Infinity is going to be used
 */
@property(nonatomic, strong) NSValue * _Nullable isInfinity __deprecated_msg("This property will be removed in future releases");

/**
 * Config code for smartswitch
 */
@property(nonatomic, strong) NSString * _Nullable smartswitchConfigCode;

/**
 * Group code for smartswitch
 */
@property(nonatomic, strong) NSString * _Nullable smartswitchGroupCode;

/**
 * Contract code for smartswitch
 */
@property(nonatomic, strong) NSString * _Nullable smartswitchContractCode;

/**
 * Custom parameter 1.
 */
@property(nonatomic, strong, setter=setExtraParam1:) NSString * _Nullable extraparam1 __deprecated_msg("Use customDimension1 instead");

/**
 * Custom parameter 2.
 */
@property(nonatomic, strong, setter=setExtraParam2:) NSString * _Nullable extraparam2 __deprecated_msg("Use customDimension2 instead");

/**
 * Custom parameter 3.
 */
@property(nonatomic, strong, setter=setExtraParam3:) NSString * _Nullable extraparam3 __deprecated_msg("Use customDimension3 instead");

/**
 * Custom parameter 4.
 */
@property(nonatomic, strong, setter=setExtraParam4:) NSString * _Nullable extraparam4 __deprecated_msg("Use customDimension4 instead");

/**
 * Custom parameter 5.
 */
@property(nonatomic, strong, setter=setExtraParam5:) NSString * _Nullable extraparam5 __deprecated_msg("Use customDimension5 instead");

/**
 * Custom parameter 6.
 */
@property(nonatomic, strong, setter=setExtraParam6:) NSString * _Nullable extraparam6 __deprecated_msg("Use customDimension6 instead");

/**
 * Custom parameter 7.
 */
@property(nonatomic, strong, setter=setExtraParam7:) NSString * _Nullable extraparam7 __deprecated_msg("Use customDimension7 instead");

/**
 * Custom parameter 8.
 */
@property(nonatomic, strong, setter=setExtraParam8:) NSString * _Nullable extraparam8 __deprecated_msg("Use customDimension8 instead");

/**
 * Custom parameter 9.
 */
@property(nonatomic, strong, setter=setExtraParam9:) NSString * _Nullable extraparam9 __deprecated_msg("Use customDimension9 instead");

/**
 * Custom parameter 10.
 */
@property(nonatomic, strong, setter=setExtraParam10:) NSString * _Nullable extraparam10 __deprecated_msg("Use customDimension10 instead");

/**
 * Custom parameter 11.
 */
@property(nonatomic, strong, setter=setExtraParam11:) NSString * _Nullable extraparam11 __deprecated_msg("Use customDimension11 instead");

/**
 * Custom parameter 12.
 */
@property(nonatomic, strong, setter=setExtraParam12:) NSString * _Nullable extraparam12 __deprecated_msg("Use customDimension12 instead");

/**
 * Custom parameter 13.
 */
@property(nonatomic, strong, setter=setExtraParam13:) NSString * _Nullable extraparam13 __deprecated_msg("Use customDimension13 instead");

/**
 * Custom parameter 14.
 */
@property(nonatomic, strong, setter=setExtraParam14:) NSString * _Nullable extraparam14 __deprecated_msg("Use customDimension14 instead");

/**
 * Custom parameter 15.
 */
@property(nonatomic, strong, setter=setExtraParam15:) NSString * _Nullable extraparam15 __deprecated_msg("Use customDimension15 instead");

/**
 * Custom parameter 16.
 */
@property(nonatomic, strong, setter=setExtraParam16:) NSString * _Nullable extraparam16 __deprecated_msg("Use customDimension16 instead");

/**
 * Custom parameter 17.
 */
@property(nonatomic, strong, setter=setExtraParam17:) NSString * _Nullable extraparam17 __deprecated_msg("Use customDimension17 instead");

/**
 * Custom parameter 18.
 */
@property(nonatomic, strong, setter=setExtraParam18:) NSString * _Nullable extraparam18 __deprecated_msg("Use customDimension18 instead");

/**
 * Custom parameter 19.
 */
@property(nonatomic, strong, setter=setExtraParam19:) NSString * _Nullable extraparam19 __deprecated_msg("Use customDimension19 instead");

/**
 * Custom parameter 20.
 */
@property(nonatomic, strong, setter=setExtraParam20:) NSString * _Nullable extraparam20 __deprecated_msg("Use customDimension20 instead");

/**
 * Custom dimension 1.
 */
@property(nonatomic, strong, setter=setExtraParam1:) NSString * _Nullable customDimension1 __deprecated_msg("Use contentCustomDimension1 instead");

/**
 * Custom dimension 2.
 */
@property(nonatomic, strong, setter=setExtraParam2:) NSString * _Nullable customDimension2 __deprecated_msg("Use contentCustomDimension2 instead");

/**
 * Custom dimension 3.
 */
@property(nonatomic, strong, setter=setExtraParam3:) NSString * _Nullable customDimension3 __deprecated_msg("Use contentCustomDimension3 instead");

/**
 * Custom dimension 4.
 */
@property(nonatomic, strong, setter=setExtraParam4:) NSString * _Nullable customDimension4 __deprecated_msg("Use contentCustomDimension4 instead");

/**
 * Custom dimension 5.
 */
@property(nonatomic, strong, setter=setExtraParam5:) NSString * _Nullable customDimension5 __deprecated_msg("Use contentCustomDimension5 instead");

/**
 * Custom dimension 6.
 */
@property(nonatomic, strong, setter=setExtraParam6:) NSString * _Nullable customDimension6 __deprecated_msg("Use contentCustomDimension6 instead");

/**
 * Custom dimension 7.
 */
@property(nonatomic, strong, setter=setExtraParam7:) NSString * _Nullable customDimension7 __deprecated_msg("Use contentCustomDimension7 instead");

/**
 * Custom dimension 8.
 */
@property(nonatomic, strong, setter=setExtraParam8:) NSString * _Nullable customDimension8 __deprecated_msg("Use contentCustomDimension8 instead");

/**
 * Custom dimension 9.
 */
@property(nonatomic, strong, setter=setExtraParam9:) NSString * _Nullable customDimension9 __deprecated_msg("Use contentCustomDimension9 instead");

/**
 * Custom dimension 10.
 */
@property(nonatomic, strong, setter=setExtraParam10:) NSString * _Nullable customDimension10 __deprecated_msg("Use contentCustomDimension10 instead");

/**
 * Custom dimension 11.
 */
@property(nonatomic, strong, setter=setExtraParam11:) NSString * _Nullable customDimension11 __deprecated_msg("Use contentCustomDimension11 instead");

/**
 * Custom dimension 12.
 */
@property(nonatomic, strong, setter=setExtraParam12:) NSString * _Nullable customDimension12 __deprecated_msg("Use contentCustomDimension12 instead");

/**
 * Custom dimension 13.
 */
@property(nonatomic, strong, setter=setExtraParam13:) NSString * _Nullable customDimension13 __deprecated_msg("Use contentCustomDimension13 instead");

/**
 * Custom dimension 14.
 */
@property(nonatomic, strong, setter=setExtraParam14:) NSString * _Nullable customDimension14 __deprecated_msg("Use contentCustomDimension14 instead");

/**
 * Custom dimension 15.
 */
@property(nonatomic, strong, setter=setExtraParam15:) NSString * _Nullable customDimension15 __deprecated_msg("Use contentCustomDimension15 instead");

/**
 * Custom dimension 16.
 */
@property(nonatomic, strong, setter=setExtraParam16:) NSString * _Nullable customDimension16 __deprecated_msg("Use contentCustomDimension16 instead");

/**
 * Custom dimension 17.
 */
@property(nonatomic, strong, setter=setExtraParam17:) NSString * _Nullable customDimension17 __deprecated_msg("Use contentCustomDimension17 instead");

/**
 * Custom dimension 18.
 */
@property(nonatomic, strong, setter=setExtraParam18:) NSString * _Nullable customDimension18 __deprecated_msg("Use contentCustomDimension18 instead");

/**
 * Custom dimension 19.
 */
@property(nonatomic, strong, setter=setExtraParam19:) NSString * _Nullable customDimension19 __deprecated_msg("Use contentCustomDimension19 instead");

/**
 * Custom dimension 20.
 */
@property(nonatomic, strong, setter=setExtraParam20:) NSString * _Nullable customDimension20 __deprecated_msg("Use contentCustomDimension20 instead");

/**
 * Custom ad parameter 1.
 */
@property(nonatomic, strong, setter=setAdExtraParam1:) NSString * _Nullable adExtraparam1 __deprecated_msg("Use adCustomDimension1 instead");

/**
 * Custom ad parameter 2.
 */
@property(nonatomic, strong, setter=setAdExtraParam2:) NSString * _Nullable adExtraparam2 __deprecated_msg("Use adCustomDimension2 instead");

/**
 * Custom ad parameter 3.
 */
@property(nonatomic, strong, setter=setAdExtraParam3:) NSString * _Nullable adExtraparam3 __deprecated_msg("Use adCustomDimension3 instead");

/**
 * Custom ad parameter 4.
 */
@property(nonatomic, strong, setter=setAdExtraParam4:) NSString * _Nullable adExtraparam4 __deprecated_msg("Use adCustomDimension4 instead");

/**
 * Custom ad parameter 5.
 */
@property(nonatomic, strong, setter=setAdExtraParam5:) NSString * _Nullable adExtraparam5 __deprecated_msg("Use adCustomDimension5 instead");

/**
 * Custom ad parameter 6.
 */
@property(nonatomic, strong, setter=setAdExtraParam6:) NSString * _Nullable adExtraparam6 __deprecated_msg("Use adCustomDimension6 instead");

/**
 * Custom ad parameter 7.
 */
@property(nonatomic, strong, setter=setAdExtraParam7:) NSString * _Nullable adExtraparam7 __deprecated_msg("Use adCustomDimension7 instead");

/**
 * Custom ad parameter 8.
 */
@property(nonatomic, strong, setter=setAdExtraParam8:) NSString * _Nullable adExtraparam8 __deprecated_msg("Use adCustomDimension8 instead");

/**
 * Custom ad parameter 9.
 */
@property(nonatomic, strong, setter=setAdExtraParam9:) NSString * _Nullable adExtraparam9 __deprecated_msg("Use adCustomDimension9 instead");

/**
 * Custom ad parameter 10.
 */
@property(nonatomic, strong, setter=setAdExtraParam10:) NSString * _Nullable adExtraparam10 __deprecated_msg("Use adCustomDimension10 instead");

/**
 * Content custom dimension 1.
 */
@property(nonatomic, strong) NSString * _Nullable contentCustomDimension1;

/**
 * Content custom dimension 2.
 */
@property(nonatomic, strong) NSString * _Nullable contentCustomDimension2;

/**
 * Content custom dimension 3.
 */
@property(nonatomic, strong) NSString * _Nullable contentCustomDimension3;

/**
 * Content custom dimension 4.
 */
@property(nonatomic, strong) NSString * _Nullable contentCustomDimension4;

/**
 * Content custom dimension 5.
 */
@property(nonatomic, strong) NSString * _Nullable contentCustomDimension5;

/**
 * Content custom dimension 6.
 */
@property(nonatomic, strong) NSString * _Nullable contentCustomDimension6;

/**
 * Content custom dimension 7.
 */
@property(nonatomic, strong) NSString * _Nullable contentCustomDimension7;

/**
 * Content custom dimension 8.
 */
@property(nonatomic, strong) NSString * _Nullable contentCustomDimension8;

/**
 * Content custom dimension 9.
 */
@property(nonatomic, strong) NSString * _Nullable contentCustomDimension9;

/**
 * Content custom dimension 10.
 */
@property(nonatomic, strong) NSString * _Nullable contentCustomDimension10;

/**
 * Content custom dimension 11.
 */
@property(nonatomic, strong) NSString * _Nullable contentCustomDimension11;

/**
 * Content custom dimension 12.
 */
@property(nonatomic, strong) NSString * _Nullable contentCustomDimension12;

/**
 * Content custom dimension 13.
 */
@property(nonatomic, strong) NSString * _Nullable contentCustomDimension13;

/**
 * Content custom dimension 14.
 */
@property(nonatomic, strong) NSString * _Nullable contentCustomDimension14;

/**
 * Content custom dimension 15.
 */
@property(nonatomic, strong) NSString * _Nullable contentCustomDimension15;

/**
 * Content custom dimension 16.
 */
@property(nonatomic, strong) NSString * _Nullable contentCustomDimension16;

/**
 * Content custom dimension 17.
 */
@property(nonatomic, strong) NSString * _Nullable contentCustomDimension17;

/**
 * Content custom dimension 18.
 */
@property(nonatomic, strong) NSString * _Nullable contentCustomDimension18;

/**
 * Content custom dimension 19.
 */
@property(nonatomic, strong) NSString * _Nullable contentCustomDimension19;

/**
 * Content custom dimension 20.
 */
@property(nonatomic, strong) NSString * _Nullable contentCustomDimension20;

/**
 * Custom dimensions object.
 */
@property(nonatomic, strong) NSDictionary * _Nullable contentCustomDimensions;

/**
 * Custom ad dimension 1.
 */
@property(nonatomic, strong) NSString * _Nullable adCustomDimension1;

/**
 * Custom ad dimension 2.
 */
@property(nonatomic, strong) NSString * _Nullable adCustomDimension2;

/**
 * Custom ad dimension 3.
 */
@property(nonatomic, strong) NSString * _Nullable adCustomDimension3;

/**
 * Custom ad dimension 4.
 */
@property(nonatomic, strong) NSString * _Nullable adCustomDimension4;

/**
 * Custom ad dimension 5.
 */
@property(nonatomic, strong) NSString * _Nullable adCustomDimension5;

/**
 * Custom ad dimension 6.
 */
@property(nonatomic, strong) NSString * _Nullable adCustomDimension6;

/**
 * Custom ad dimension 7.
 */
@property(nonatomic, strong) NSString * _Nullable adCustomDimension7;

/**
 * Custom ad dimension 8.
 */
@property(nonatomic, strong) NSString * _Nullable adCustomDimension8;

/**
 * Custom ad dimension 9.
 */
@property(nonatomic, strong) NSString * _Nullable adCustomDimension9;

/**
 * Custom ad dimension 10.
 */
@property(nonatomic, strong) NSString * _Nullable adCustomDimension10;

/*
 * Name of the app
 */
@property(nonatomic, strong) NSString * _Nullable appName;

/**
 * Release version of the app
 */
@property(nonatomic, strong) NSString * _Nullable appReleaseVersion;

/**
 * Option to send on start events to link views with previous session events
 */
@property (nonatomic, strong, nullable) NSString * linkedViewId;

/**
 * Enabling this option enables the posibility of getting the /start request later on the view,
 * making the flow go as follows: /init is sent when the player starts to load content,
 * then when the playback starts /joinTime event will be sent, but with the difference of no /start
 * request, instead it will be delayed until all the option keys from <b>pendingMetadata</b>
 * are not <b>null</b>, this is very important, since an empty string is considered a not null
 * and therefore is a valid value.
 */
@property(nonatomic, assign) BOOL waitForMetadata;

/**
 * Set option keys you want to wait for metadata, in order to work <b>waitForMetadata</b>
 * must be set to true.
 * You need to create an <b>NSArray</b> with all the options you want to make the start be hold on.
 * You can find all the keys with the following format:  YBOPTIONS_KEY_{OPTION_NAME} where option
 * name is the same one as the option itself.
 *
 * Find below an example:
 *
 * NSArray *array = @[YBOPTIONS_KEY_CONTENT_TITLE, YBOPTIONS_KEY_CONTENT_CUSTOM_DIMENSION_1]
 * options.pendingMetadata = array
 *
 * The code above prevent the /start request unless <b>contentTItle</b> and <b>contentCustomDimension1</b>
 * stop being nil (you can set a non nil value to any property when information is available).
 */
@property(nonatomic, strong) NSArray<NSString *> * _Nullable pendingMetadata;

/**
 * If it has elements on it, all the errors matching this code will fire the stop event to end the view
 */
@property(nonatomic, strong) NSArray<NSString *> * _Nullable fatalErrors;

/**
 * If it has elements on it, all the errors matching this code won't fire a stop event to end the view
 */
@property(nonatomic, strong) NSArray<NSString *> * _Nullable nonFatalErrors;

/**
 * If it has elements on it, all the errors matching this code wont be reported
 */
@property(nonatomic, strong) NSArray<NSString *> * _Nullable ignoreErrors;

@end
