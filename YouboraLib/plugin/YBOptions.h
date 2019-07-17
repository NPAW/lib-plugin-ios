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

/// Option keys
extern NSString * const YBOPTIONS_KEY_ENABLED;
extern NSString * const YBOPTIONS_KEY_HTTP_SECURE;
extern NSString * const YBOPTIONS_KEY_HOST;
extern NSString * const YBOPTIONS_KEY_ACCOUNT_CODE;
extern NSString * const YBOPTIONS_KEY_USERNAME;
extern NSString * const YBOPTIONS_KEY_ANONYMOUS_USER;
extern NSString * const YBOPTIONS_KEY_OFFLINE;
extern NSString * const YBOPTIONS_KEY_IS_INFINITY;
extern NSString * const YBOPTIONS_KEY_BACKGROUND;
extern NSString * const YBOPTIONS_KEY_AUTOSTART;
extern NSString * const YBOPTIONS_KEY_FORCEINIT;
extern NSString * const YBOPTIONS_KEY_USER_TYPE;
extern NSString * const YBOPTIONS_KEY_USER_EMAIL;
extern NSString * const YBOPTIONS_KEY_EXPERIMENT_IDS;
extern NSString * const YBOPTIONS_KEY_SS_CONFIG_CODE;
extern NSString * const YBOPTIONS_KEY_SS_GROUP_CODE;
extern NSString * const YBOPTIONS_KEY_SS_CONTRACT_CODE;

extern NSString * const YBOPTIONS_KEY_PARSE_HLS;
extern NSString * const YBOPTIONS_KEY_PARSE_CDN_NAME_HEADER;
extern NSString * const YBOPTIONS_KEY_PARSE_CDN_NODE;
extern NSString * const YBOPTIONS_KEY_PARSE_CDN_NODE_LIST;
extern NSString * const YBOPTIONS_KEY_PARSE_LOCATION_HEADER;

extern NSString * const YBOPTIONS_KEY_NETWORK_IP;
extern NSString * const YBOPTIONS_KEY_NETWORK_ISP;
extern NSString * const YBOPTIONS_KEY_NETWORK_CONNECTION_TYPE;
extern NSString * const YBOPTIONS_KEY_USER_OBFUSCATE_IP;

extern NSString * const YBOPTIONS_KEY_DEVICE_CODE;
extern NSString * const YBOPTIONS_KEY_DEVICE_MODEL;
extern NSString * const YBOPTIONS_KEY_DEVICE_BRAND;
extern NSString * const YBOPTIONS_KEY_DEVICE_TYPE;
extern NSString * const YBOPTIONS_KEY_DEVICE_NAME;
extern NSString * const YBOPTIONS_KEY_DEVICE_OS_NAME;
extern NSString * const YBOPTIONS_KEY_DEVICE_OS_VERSION;
extern NSString * const YBOPTIONS_KEY_DEVICE_IS_ANONYMOUS;

extern NSString * const YBOPTIONS_KEY_CONTENT_RESOURCE;
extern NSString * const YBOPTIONS_KEY_CONTENT_IS_LIVE;
extern NSString * const YBOPTIONS_KEY_CONTENT_TITLE;
extern NSString * const YBOPTIONS_KEY_CONTENT_PROGRAM;
extern NSString * const YBOPTIONS_KEY_CONTENT_DURATION;
extern NSString * const YBOPTIONS_KEY_CONTENT_TRANSACTION_CODE;
extern NSString * const YBOPTIONS_KEY_CONTENT_BITRATE;
extern NSString * const YBOPTIONS_KEY_CONTENT_THROUGHPUT;
extern NSString * const YBOPTIONS_KEY_CONTENT_RENDITION;
extern NSString * const YBOPTIONS_KEY_CONTENT_CDN;
extern NSString * const YBOPTIONS_KEY_CONTENT_FPS;
extern NSString * const YBOPTIONS_KEY_CONTENT_STREAMING_PROTOCOL;
extern NSString * const YBOPTIONS_KEY_CONTENT_METADATA;
extern NSString * const YBOPTIONS_KEY_CONTENT_METRICS;
extern NSString * const YBOPTIONS_KEY_CONTENT_IS_LIVE_NO_SEEK;

extern NSString * const YBOPTIONS_KEY_CONTENT_PACKAGE;
extern NSString * const YBOPTIONS_KEY_CONTENT_SAGA;
extern NSString * const YBOPTIONS_KEY_CONTENT_TV_SHOW;
extern NSString * const YBOPTIONS_KEY_CONTENT_SEASON;
extern NSString * const YBOPTIONS_KEY_CONTENT_EPISODE_TITLE;
extern NSString * const YBOPTIONS_KEY_CONTENT_CHANNEL;
extern NSString * const YBOPTIONS_KEY_CONTENT_ID;
extern NSString * const YBOPTIONS_KEY_CONTENT_IMDB_ID;
extern NSString * const YBOPTIONS_KEY_CONTENT_GRACENOTE_ID;
extern NSString * const YBOPTIONS_KEY_CONTENT_TYPE;
extern NSString * const YBOPTIONS_KEY_CONTENT_GENRE;
extern NSString * const YBOPTIONS_KEY_CONTENT_LANGUAGE;
extern NSString * const YBOPTIONS_KEY_CONTENT_SUBTITLES;
extern NSString * const YBOPTIONS_KEY_CONTENT_CONTRACTED_RESOLUTION;
extern NSString * const YBOPTIONS_KEY_CONTENT_COST;
extern NSString * const YBOPTIONS_KEY_CONTENT_PRICE;
extern NSString * const YBOPTIONS_KEY_CONTENT_PLAYBACK_TYPE;
extern NSString * const YBOPTIONS_KEY_CONTENT_DRM;
extern NSString * const YBOPTIONS_KEY_CONTENT_ENCODING_VIDEO_CODEC;
extern NSString * const YBOPTIONS_KEY_CONTENT_ENCODING_AUDIO_CODEC;
extern NSString * const YBOPTIONS_KEY_CONTENT_ENCODING_CODEC_SETTINGS;
extern NSString * const YBOPTIONS_KEY_CONTENT_ENCODING_CODEC_PROFILE;
extern NSString * const YBOPTIONS_KEY_CONTENT_ENCODING_CONTAINER_FORMAT;

extern NSString * const YBOPTIONS_KEY_SESSION_METRICS;

extern NSString * const YBOPTIONS_KEY_AD_METADATA;
extern NSString * const YBOPTIONS_KEY_AD_IGNORE;
extern NSString * const YBOPTIONS_KEY_ADS_AFTERSTOP;
extern NSString * const YBOPTIONS_KEY_AD_CAMPAIGN;
extern NSString * const YBOPTIONS_KEY_AD_TITLE;
extern NSString * const YBOPTIONS_KEY_AD_RESOURCE;
extern NSString * const YBOPTIONS_KEY_AD_GIVEN_BREAKS;
extern NSString * const YBOPTIONS_KEY_AD_EXPECTED_BREAKS;
extern NSString * const YBOPTIONS_KEY_AD_EXPECTED_PATTERN;
extern NSString * const YBOPTIONS_KEY_AD_BREAKS_TIME;
extern NSString * const YBOPTIONS_KEY_AD_GIVEN_ADS;
extern NSString * const YBOPTIONS_KEY_AD_CREATIVEID;
extern NSString * const YBOPTIONS_KEY_AD_PROVIDER;

extern NSString * const YBOPTIONS_KEY_CONTENT_CUSTOM_DIMENSION_1;
extern NSString * const YBOPTIONS_KEY_CONTENT_CUSTOM_DIMENSION_2;
extern NSString * const YBOPTIONS_KEY_CONTENT_CUSTOM_DIMENSION_3;
extern NSString * const YBOPTIONS_KEY_CONTENT_CUSTOM_DIMENSION_4;
extern NSString * const YBOPTIONS_KEY_CONTENT_CUSTOM_DIMENSION_5;
extern NSString * const YBOPTIONS_KEY_CONTENT_CUSTOM_DIMENSION_6;
extern NSString * const YBOPTIONS_KEY_CONTENT_CUSTOM_DIMENSION_7;
extern NSString * const YBOPTIONS_KEY_CONTENT_CUSTOM_DIMENSION_8;
extern NSString * const YBOPTIONS_KEY_CONTENT_CUSTOM_DIMENSION_9;
extern NSString * const YBOPTIONS_KEY_CONTENT_CUSTOM_DIMENSION_10;
extern NSString * const YBOPTIONS_KEY_CONTENT_CUSTOM_DIMENSION_11;
extern NSString * const YBOPTIONS_KEY_CONTENT_CUSTOM_DIMENSION_12;
extern NSString * const YBOPTIONS_KEY_CONTENT_CUSTOM_DIMENSION_13;
extern NSString * const YBOPTIONS_KEY_CONTENT_CUSTOM_DIMENSION_14;
extern NSString * const YBOPTIONS_KEY_CONTENT_CUSTOM_DIMENSION_15;
extern NSString * const YBOPTIONS_KEY_CONTENT_CUSTOM_DIMENSION_16;
extern NSString * const YBOPTIONS_KEY_CONTENT_CUSTOM_DIMENSION_17;
extern NSString * const YBOPTIONS_KEY_CONTENT_CUSTOM_DIMENSION_18;
extern NSString * const YBOPTIONS_KEY_CONTENT_CUSTOM_DIMENSION_19;
extern NSString * const YBOPTIONS_KEY_CONTENT_CUSTOM_DIMENSION_20;

extern NSString * const YBOPTIONS_KEY_AD_CUSTOM_DIMENSION_1;
extern NSString * const YBOPTIONS_KEY_AD_CUSTOM_DIMENSION_2;
extern NSString * const YBOPTIONS_KEY_AD_CUSTOM_DIMENSION_3;
extern NSString * const YBOPTIONS_KEY_AD_CUSTOM_DIMENSION_4;
extern NSString * const YBOPTIONS_KEY_AD_CUSTOM_DIMENSION_5;
extern NSString * const YBOPTIONS_KEY_AD_CUSTOM_DIMENSION_6;
extern NSString * const YBOPTIONS_KEY_AD_CUSTOM_DIMENSION_7;
extern NSString * const YBOPTIONS_KEY_AD_CUSTOM_DIMENSION_8;
extern NSString * const YBOPTIONS_KEY_AD_CUSTOM_DIMENSION_9;
extern NSString * const YBOPTIONS_KEY_AD_CUSTOM_DIMENSION_10;

extern NSString * const YBOPTIONS_KEY_APP_NAME;
extern NSString * const YBOPTIONS_KEY_APP_RELEASE_VERSION;

extern NSString * const YBOPTIONS_KEY_WAIT_METADATA;
extern NSString * const YBOPTIONS_KEY_PENDING_METADATA;

extern NSString * const YBOPTIONS_KEY_SESSION_METRICS;

/// Public methods
- (NSDictionary *) toDictionary;

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
@property(nonatomic, strong) NSString * host;

/**
 * NicePeopleAtWork account code that indicates the customer account.
 */
@property(nonatomic, strong) NSString * accountCode;

/**
 * User ID value inside your system.
 */
@property(nonatomic, strong) NSString * username;

/**
 * User type value inside your system.
 */
@property(nonatomic, strong) NSString * userType;

/**
 * User email
 */
@property(nonatomic, strong) NSString *userEmail;

/**
 * If true the plugin will parse HLS files to use the first .ts file found as resource.
 * It might slow performance down.
 * Default: false
 */
@property(nonatomic, assign) bool parseHls;

/**
 * If true the plugin will parse the resource to try and find out the real given resource instead of the API url
 * It might slow performance down.
 * Default: false
 */
@property(nonatomic, assign) bool parseLocationHeader;

/**
 * If defined, resource parse will try to fetch the CDN code from the custom header defined
 * by this property, e.g. "x-cdn-forward"
 */
@property(nonatomic, strong) NSString * parseCdnNameHeader;

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
@property(nonatomic, strong) NSMutableArray<NSString *> * parseCdnNodeList;

/**
 * List of experiment ids to use with SmartUsers
 */
@property(nonatomic, strong) NSMutableArray<NSString *> * experimentIds;

/**
 * IP of the viewer/user, e.g. "48.15.16.23".
 */
@property(nonatomic, strong) NSString * networkIP;

/**
 * Name of the internet service provider of the viewer/user.
 */
@property(nonatomic, strong) NSString * networkIsp;

/**
 * See a list of codes in <a href="http://mapi.youbora.com:8081/connectionTypes">http://mapi.youbora.com:8081/connectionTypes</a>.
 */
@property(nonatomic, strong) NSString * networkConnectionType;

/**
 * If the ip address should be abfuscated
 */
@property(nonatomic, strong, setter=setNetworkObfuscateIp:) NSValue * networkObfuscateIp __deprecated_msg("Use userObfuscateIp instead");

/**
 * If the ip address should be abfuscated
 */
@property(nonatomic, strong) NSValue * userObfuscateIp;

/**
 * Youbora's device code. If specified it will rewrite info gotten from user agent.
 * See a list of codes in <a href="http://mapi.youbora.com:8081/devices">http://mapi.youbora.com:8081/devices</a>.
 */
@property(nonatomic, strong) NSString * deviceCode;

/**
 * Force init enabled
 */
@property(nonatomic, assign) bool forceInit;

/**
* What will be displayed as the device model on Youbora (provided by default with android.os.Build.MODEL if not set)
*/
@property(nonatomic, strong) NSString * deviceModel;

/**
 * What will be displayed as the device brand on Youbora (provided by default with android.os.Build.BRAND if not set)
 */
@property(nonatomic, strong) NSString * deviceBrand;

/**
 * What will be displayed as the device type on Youbora (pc, smartphone, stb, tv, etc.)
 */
@property(nonatomic, strong) NSString * deviceType;

/**
 * What will be displayed as the device name on Youbora (pc, smartphone, stb, tv, etc.)
 */
@property(nonatomic, strong) NSString * deviceName;

/**
 * OS name that will be displayed on Youbora
 */
@property(nonatomic, strong) NSString * deviceOsName;

/**
 * OS version that will be displayed on Youbora (provided by default with android.os.Build.VERSION.RELEASE if not set)
 */
@property(nonatomic, strong) NSString * deviceOsVersion;

/**
 * Option to not send deviceUUID
 */
@property(nonatomic, assign) BOOL deviceIsAnonymous;

/**
 * URL/path of the current media resource.
 */
@property(nonatomic, strong) NSString * contentResource;

/**
 * @YES if the content is Live. @NO if VOD. Default: nil.
 */
@property(nonatomic, strong) NSValue * contentIsLive;

/**
 * Title of the media.
 */
@property(nonatomic, strong) NSString * contentTitle;

/**
 * Secondary title of the media. This could be program name, season, episode, etc.
 */
@property(nonatomic, strong, setter=setContentTitle2:) NSString * contentTitle2 __deprecated_msg("Use program instead");

/**
 * Program title of the media. This could be program name, season, episode, etc.
 */
@property(nonatomic, strong) NSString * program;

/**
 * Duration of the media <b>in seconds</b>.
 */
@property(nonatomic, strong) NSNumber * contentDuration; // double

/**
 * Custom unique code to identify the view.
 */
@property(nonatomic, strong) NSString * contentTransactionCode;

/**
 * Bitrate of the content in bits per second.
 */
@property(nonatomic, strong) NSNumber * contentBitrate; // long

/**
 * Streaming protocol of the content, accepted types are HDS, HLS, MSS, DASH, RTMP, RTP, RTSP
 */
@property(nonatomic, strong) NSString * contentStreamingProtocol;

/**
 * Throughput of the client bandwidth in bits per second.
 */
@property(nonatomic, strong) NSNumber * contentThroughput; // long

/**
 * Name or value of the current rendition (quality) of the content.
 */
@property(nonatomic, strong) NSString * contentRendition;

/**
 * Codename of the CDN where the content is streaming from.
 * See a list of codes in <a href="http://mapi.youbora.com:8081/cdns">http://mapi.youbora.com:8081/cdns</a>.
 */
@property(nonatomic, strong) NSString * contentCdn;

/**
 * Frames per second of the media being played.
 */
@property(nonatomic, strong) NSNumber * contentFps; // double

/**
 * NSDictionary containing mixed extra information about the content like: director, parental rating,
 * device info or the audio channels.
 */
@property(nonatomic, strong) NSDictionary * contentMetadata;

/**
 * NSDictionary containing the content metrics.
 */
@property(nonatomic, strong) NSDictionary * contentMetrics;

/**
 * NSDictionary containing the session metrics.
 */
@property(nonatomic, strong) NSDictionary * sessionMetrics;

/**
 * NSValue containing if seeks should be disabled for life content, only applies if content is live, if it's VOD it gets ignored
 */
@property(nonatomic, strong) NSValue * contentIsLiveNoSeek;

/**
 * NSString containing the content package
 */
@property(nonatomic, strong) NSString * contentPackage;

/**
 * NSString containing the content saga
 */
@property(nonatomic, strong) NSString * contentSaga;

/**
 * NSString containing the content show
 */
@property(nonatomic, strong) NSString * contentTvShow;

/**
 * NSString containing the content season
 */
@property(nonatomic, strong) NSString * contentSeason;

/**
 * NSString containing the content episode title
 */
@property(nonatomic, strong) NSString * contentEpisodeTitle;

/**
 * NSString containing the content channel
 */
@property(nonatomic, strong) NSString * contentChannel;

/**
 * NSString containing the content id
 */
@property(nonatomic, strong) NSString * contentId;

/**
 * NSString containing the content imdb id
 */
@property(nonatomic, strong) NSString * contentImdbId;

/**
 * NSString containing the content gracenote id
 */
@property(nonatomic, strong) NSString * contentGracenoteId;

/**
 * NSString containing the content type
 */
@property(nonatomic, strong) NSString * contentType;

/**
 * NSString containing the content genre
 */
@property(nonatomic, strong) NSString * contentGenre;

/**
 * NSString containing the content language
 */
@property(nonatomic, strong) NSString * contentLanguage;

/**
 * NSString containing the content subtitles
 */
@property(nonatomic, strong) NSString * contentSubtitles;

/**
 * NSString containing the content contracted resolution
 */
@property(nonatomic, strong) NSString * contentContractedResolution;

/**
 * NSString containing the content cost
 */
@property(nonatomic, strong) NSString * contentCost;

/**
 * NSString containing the content price
 */
@property(nonatomic, strong) NSString * contentPrice;

/**
 * NSString containing the content playback type
 */
@property(nonatomic, strong) NSString * contentPlaybackType;

/**
 * NSString containing the content drm
 */
@property(nonatomic, strong) NSString * contentDrm;

/**
 * NSString containing the content encoding video codec
 */
@property(nonatomic, strong) NSString * contentEncodingVideoCodec;

/**
 * NSString containing the content encoding audio codec
 */
@property(nonatomic, strong) NSString * contentEncodingAudioCodec;

/**
 * NSString containing the content encoding codec settings
 */
@property(nonatomic, strong) NSDictionary * contentEncodingCodecSettings;

/**
 * NSString containing the content encoding codec profile
 */
@property(nonatomic, strong) NSString * contentEncodingCodecProfile;

/**
 * NSString containing the content encoding container format
 */
@property(nonatomic, strong) NSString * contentEncodingContainerFormat;

/**
 * NSDictionary containing mixed extra information about the ads like: director, parental rating,
 * device info or the audio channels.
 */
@property(nonatomic, strong) NSDictionary * adMetadata;

/**
 * Variable containing number of ads after stop
 */
@property(nonatomic, strong) NSNumber* adsAfterStop;

/**
 * Variable containing ad campaign
 */
@property(nonatomic, strong) NSString* adCampaign;

/**
 * Variable containing ad title
 */
@property(nonatomic, strong) NSString* adTitle;

/**
 * Variable containing ad resource
 */
@property(nonatomic, strong) NSString* adResource;

/**
 * Variable containing how many ad breaks will be shown for the active view
 */
@property(nonatomic, strong) NSNumber* adGivenBreaks;

/**
 * Variable containing how many ad breaks should be shown for the active view
 */
@property(nonatomic, strong) NSNumber* adExpectedBreaks;

/**
 * Variable containing how many ads will be shown for each break
 */
@property(nonatomic, strong) NSDictionary* adExpectedPattern;

/**
 * Variable containing at which moment of the playback a break should be displayed
 */
@property(nonatomic, strong) NSArray* adBreaksTime;

/**
 * Variable containing how many ads should be played for the current break
 */
@property(nonatomic, strong) NSNumber* adGivenAds;

/**
 * Variable containing ad creativeId
 */
@property(nonatomic, strong) NSString *adCreativeId;

/**
 * Variable containing ad provider
 */
@property(nonatomic, strong) NSString *adProvider;

/**
 * If true the plugin will fireStop when going to background
 * Default: true
 */
@property(nonatomic, assign) bool autoDetectBackground;

/**
 * If true no request will we send and saved for later instead
 */
@property(nonatomic, assign) bool offline;

/**
 * User ID value inside your system for anon users
 */
@property(nonatomic, strong) NSString * anonymousUser;

/**
 * Flag if Infinity is going to be used
 */
@property(nonatomic, strong) NSValue * isInfinity;

/**
 * Config code for smartswitch
 */
@property(nonatomic, strong) NSString * smartswitchConfigCode;

/**
 * Group code for smartswitch
 */
@property(nonatomic, strong) NSString * smartswitchGroupCode;

/**
 * Contract code for smartswitch
 */
@property(nonatomic, strong) NSString * smartswitchContractCode;

/**
 * Custom parameter 1.
 */
@property(nonatomic, strong, setter=setExtraParam1:) NSString * extraparam1 __deprecated_msg("Use customDimension1 instead");

/**
 * Custom parameter 2.
 */
@property(nonatomic, strong, setter=setExtraParam2:) NSString * extraparam2 __deprecated_msg("Use customDimension2 instead");

/**
 * Custom parameter 3.
 */
@property(nonatomic, strong, setter=setExtraParam3:) NSString * extraparam3 __deprecated_msg("Use customDimension3 instead");

/**
 * Custom parameter 4.
 */
@property(nonatomic, strong, setter=setExtraParam4:) NSString * extraparam4 __deprecated_msg("Use customDimension4 instead");

/**
 * Custom parameter 5.
 */
@property(nonatomic, strong, setter=setExtraParam5:) NSString * extraparam5 __deprecated_msg("Use customDimension5 instead");

/**
 * Custom parameter 6.
 */
@property(nonatomic, strong, setter=setExtraParam6:) NSString * extraparam6 __deprecated_msg("Use customDimension6 instead");

/**
 * Custom parameter 7.
 */
@property(nonatomic, strong, setter=setExtraParam7:) NSString * extraparam7 __deprecated_msg("Use customDimension7 instead");

/**
 * Custom parameter 8.
 */
@property(nonatomic, strong, setter=setExtraParam8:) NSString * extraparam8 __deprecated_msg("Use customDimension8 instead");

/**
 * Custom parameter 9.
 */
@property(nonatomic, strong, setter=setExtraParam9:) NSString * extraparam9 __deprecated_msg("Use customDimension9 instead");

/**
 * Custom parameter 10.
 */
@property(nonatomic, strong, setter=setExtraParam10:) NSString * extraparam10 __deprecated_msg("Use customDimension10 instead");

/**
 * Custom parameter 11.
 */
@property(nonatomic, strong, setter=setExtraParam11:) NSString * extraparam11 __deprecated_msg("Use customDimension11 instead");

/**
 * Custom parameter 12.
 */
@property(nonatomic, strong, setter=setExtraParam12:) NSString * extraparam12 __deprecated_msg("Use customDimension12 instead");

/**
 * Custom parameter 13.
 */
@property(nonatomic, strong, setter=setExtraParam13:) NSString * extraparam13 __deprecated_msg("Use customDimension13 instead");

/**
 * Custom parameter 14.
 */
@property(nonatomic, strong, setter=setExtraParam14:) NSString * extraparam14 __deprecated_msg("Use customDimension14 instead");

/**
 * Custom parameter 15.
 */
@property(nonatomic, strong, setter=setExtraParam15:) NSString * extraparam15 __deprecated_msg("Use customDimension15 instead");

/**
 * Custom parameter 16.
 */
@property(nonatomic, strong, setter=setExtraParam16:) NSString * extraparam16 __deprecated_msg("Use customDimension16 instead");

/**
 * Custom parameter 17.
 */
@property(nonatomic, strong, setter=setExtraParam17:) NSString * extraparam17 __deprecated_msg("Use customDimension17 instead");

/**
 * Custom parameter 18.
 */
@property(nonatomic, strong, setter=setExtraParam18:) NSString * extraparam18 __deprecated_msg("Use customDimension18 instead");

/**
 * Custom parameter 19.
 */
@property(nonatomic, strong, setter=setExtraParam19:) NSString * extraparam19 __deprecated_msg("Use customDimension19 instead");

/**
 * Custom parameter 20.
 */
@property(nonatomic, strong, setter=setExtraParam20:) NSString * extraparam20 __deprecated_msg("Use customDimension20 instead");

/**
 * Custom dimension 1.
 */
@property(nonatomic, strong, setter=setExtraParam1:) NSString * customDimension1 __deprecated_msg("Use contentCustomDimension1 instead");

/**
 * Custom dimension 2.
 */
@property(nonatomic, strong, setter=setExtraParam2:) NSString * customDimension2 __deprecated_msg("Use contentCustomDimension2 instead");

/**
 * Custom dimension 3.
 */
@property(nonatomic, strong, setter=setExtraParam3:) NSString * customDimension3 __deprecated_msg("Use contentCustomDimension3 instead");

/**
 * Custom dimension 4.
 */
@property(nonatomic, strong, setter=setExtraParam4:) NSString * customDimension4 __deprecated_msg("Use contentCustomDimension4 instead");

/**
 * Custom dimension 5.
 */
@property(nonatomic, strong, setter=setExtraParam5:) NSString * customDimension5 __deprecated_msg("Use contentCustomDimension5 instead");

/**
 * Custom dimension 6.
 */
@property(nonatomic, strong, setter=setExtraParam6:) NSString * customDimension6 __deprecated_msg("Use contentCustomDimension6 instead");

/**
 * Custom dimension 7.
 */
@property(nonatomic, strong, setter=setExtraParam7:) NSString * customDimension7 __deprecated_msg("Use contentCustomDimension7 instead");

/**
 * Custom dimension 8.
 */
@property(nonatomic, strong, setter=setExtraParam8:) NSString * customDimension8 __deprecated_msg("Use contentCustomDimension8 instead");

/**
 * Custom dimension 9.
 */
@property(nonatomic, strong, setter=setExtraParam9:) NSString * customDimension9 __deprecated_msg("Use contentCustomDimension9 instead");

/**
 * Custom dimension 10.
 */
@property(nonatomic, strong, setter=setExtraParam10:) NSString * customDimension10 __deprecated_msg("Use contentCustomDimension10 instead");

/**
 * Custom dimension 11.
 */
@property(nonatomic, strong, setter=setExtraParam11:) NSString * customDimension11 __deprecated_msg("Use contentCustomDimension11 instead");

/**
 * Custom dimension 12.
 */
@property(nonatomic, strong, setter=setExtraParam12:) NSString * customDimension12 __deprecated_msg("Use contentCustomDimension12 instead");

/**
 * Custom dimension 13.
 */
@property(nonatomic, strong, setter=setExtraParam13:) NSString * customDimension13 __deprecated_msg("Use contentCustomDimension13 instead");

/**
 * Custom dimension 14.
 */
@property(nonatomic, strong, setter=setExtraParam14:) NSString * customDimension14 __deprecated_msg("Use contentCustomDimension14 instead");

/**
 * Custom dimension 15.
 */
@property(nonatomic, strong, setter=setExtraParam15:) NSString * customDimension15 __deprecated_msg("Use contentCustomDimension15 instead");

/**
 * Custom dimension 16.
 */
@property(nonatomic, strong, setter=setExtraParam16:) NSString * customDimension16 __deprecated_msg("Use contentCustomDimension16 instead");

/**
 * Custom dimension 17.
 */
@property(nonatomic, strong, setter=setExtraParam17:) NSString * customDimension17 __deprecated_msg("Use contentCustomDimension17 instead");

/**
 * Custom dimension 18.
 */
@property(nonatomic, strong, setter=setExtraParam18:) NSString * customDimension18 __deprecated_msg("Use contentCustomDimension18 instead");

/**
 * Custom dimension 19.
 */
@property(nonatomic, strong, setter=setExtraParam19:) NSString * customDimension19 __deprecated_msg("Use contentCustomDimension19 instead");

/**
 * Custom dimension 20.
 */
@property(nonatomic, strong, setter=setExtraParam20:) NSString * customDimension20 __deprecated_msg("Use contentCustomDimension20 instead");

/**
 * Custom ad parameter 1.
 */
@property(nonatomic, strong, setter=setAdExtraParam1:) NSString * adExtraparam1 __deprecated_msg("Use adCustomDimension1 instead");

/**
 * Custom ad parameter 2.
 */
@property(nonatomic, strong, setter=setAdExtraParam2:) NSString * adExtraparam2 __deprecated_msg("Use adCustomDimension2 instead");

/**
 * Custom ad parameter 3.
 */
@property(nonatomic, strong, setter=setAdExtraParam3:) NSString * adExtraparam3 __deprecated_msg("Use adCustomDimension3 instead");

/**
 * Custom ad parameter 4.
 */
@property(nonatomic, strong, setter=setAdExtraParam4:) NSString * adExtraparam4 __deprecated_msg("Use adCustomDimension4 instead");

/**
 * Custom ad parameter 5.
 */
@property(nonatomic, strong, setter=setAdExtraParam5:) NSString * adExtraparam5 __deprecated_msg("Use adCustomDimension5 instead");

/**
 * Custom ad parameter 6.
 */
@property(nonatomic, strong, setter=setAdExtraParam6:) NSString * adExtraparam6 __deprecated_msg("Use adCustomDimension6 instead");

/**
 * Custom ad parameter 7.
 */
@property(nonatomic, strong, setter=setAdExtraParam7:) NSString * adExtraparam7 __deprecated_msg("Use adCustomDimension7 instead");

/**
 * Custom ad parameter 8.
 */
@property(nonatomic, strong, setter=setAdExtraParam8:) NSString * adExtraparam8 __deprecated_msg("Use adCustomDimension8 instead");

/**
 * Custom ad parameter 9.
 */
@property(nonatomic, strong, setter=setAdExtraParam9:) NSString * adExtraparam9 __deprecated_msg("Use adCustomDimension9 instead");

/**
 * Custom ad parameter 10.
 */
@property(nonatomic, strong, setter=setAdExtraParam10:) NSString * adExtraparam10 __deprecated_msg("Use adCustomDimension10 instead");

/**
 * Content custom dimension 1.
 */
@property(nonatomic, strong) NSString * contentCustomDimension1;

/**
 * Content custom dimension 2.
 */
@property(nonatomic, strong) NSString * contentCustomDimension2;

/**
 * Content custom dimension 3.
 */
@property(nonatomic, strong) NSString * contentCustomDimension3;

/**
 * Content custom dimension 4.
 */
@property(nonatomic, strong) NSString * contentCustomDimension4;

/**
 * Content custom dimension 5.
 */
@property(nonatomic, strong) NSString * contentCustomDimension5;

/**
 * Content custom dimension 6.
 */
@property(nonatomic, strong) NSString * contentCustomDimension6;

/**
 * Content custom dimension 7.
 */
@property(nonatomic, strong) NSString * contentCustomDimension7;

/**
 * Content custom dimension 8.
 */
@property(nonatomic, strong) NSString * contentCustomDimension8;

/**
 * Content custom dimension 9.
 */
@property(nonatomic, strong) NSString * contentCustomDimension9;

/**
 * Content custom dimension 10.
 */
@property(nonatomic, strong) NSString * contentCustomDimension10;

/**
 * Content custom dimension 11.
 */
@property(nonatomic, strong) NSString * contentCustomDimension11;

/**
 * Content custom dimension 12.
 */
@property(nonatomic, strong) NSString * contentCustomDimension12;

/**
 * Content custom dimension 13.
 */
@property(nonatomic, strong) NSString * contentCustomDimension13;

/**
 * Content custom dimension 14.
 */
@property(nonatomic, strong) NSString * contentCustomDimension14;

/**
 * Content custom dimension 15.
 */
@property(nonatomic, strong) NSString * contentCustomDimension15;

/**
 * Content custom dimension 16.
 */
@property(nonatomic, strong) NSString * contentCustomDimension16;

/**
 * Content custom dimension 17.
 */
@property(nonatomic, strong) NSString * contentCustomDimension17;

/**
 * Content custom dimension 18.
 */
@property(nonatomic, strong) NSString * contentCustomDimension18;

/**
 * Content custom dimension 19.
 */
@property(nonatomic, strong) NSString * contentCustomDimension19;

/**
 * Content custom dimension 20.
 */
@property(nonatomic, strong) NSString * contentCustomDimension20;

/**
 * Custom ad dimension 1.
 */
@property(nonatomic, strong) NSString * adCustomDimension1;

/**
 * Custom ad dimension 2.
 */
@property(nonatomic, strong) NSString * adCustomDimension2;

/**
 * Custom ad dimension 3.
 */
@property(nonatomic, strong) NSString * adCustomDimension3;

/**
 * Custom ad dimension 4.
 */
@property(nonatomic, strong) NSString * adCustomDimension4;

/**
 * Custom ad dimension 5.
 */
@property(nonatomic, strong) NSString * adCustomDimension5;

/**
 * Custom ad dimension 6.
 */
@property(nonatomic, strong) NSString * adCustomDimension6;

/**
 * Custom ad dimension 7.
 */
@property(nonatomic, strong) NSString * adCustomDimension7;

/**
 * Custom ad dimension 8.
 */
@property(nonatomic, strong) NSString * adCustomDimension8;

/**
 * Custom ad dimension 9.
 */
@property(nonatomic, strong) NSString * adCustomDimension9;

/**
 * Custom ad dimension 10.
 */
@property(nonatomic, strong) NSString * adCustomDimension10;

/*
 * Name of the app
 */
@property(nonatomic, strong) NSString * appName;

/**
 * Release version of the app
 */
@property(nonatomic, strong) NSString * appReleaseVersion;

/**
 * Wait metadata flag
 */
@property(nonatomic, assign) BOOL waitForMetadata;

/**
 * Which parameters will make the start to be delayed
 */
@property(nonatomic, strong) NSArray<NSString *> * pendingMetadata;

@end
