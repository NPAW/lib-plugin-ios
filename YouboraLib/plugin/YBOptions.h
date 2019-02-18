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
 * If true the plugin will parse HLS files to use the first .ts file found as resource.
 * It might slow performance down.
 * Default: false
 */
@property(nonatomic, assign) bool parseHls;

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
@property(nonatomic, strong) NSValue * networkObfuscateIp;

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
 * NSValue containing if seeks should be disabled for life content, only applies if content is live, if it's VOD it gets ignored
 */
@property(nonatomic, strong) NSValue * contentIsLiveNoSeek;

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
 * Custom dimension 1.
 */
@property(nonatomic, strong) NSString * customDimension1;

/**
 * Custom dimension 2.
 */
@property(nonatomic, strong) NSString * customDimension2;

/**
 * Custom dimension 3.
 */
@property(nonatomic, strong) NSString * customDimension3;

/**
 * Custom dimension 4.
 */
@property(nonatomic, strong) NSString * customDimension4;

/**
 * Custom dimension 5.
 */
@property(nonatomic, strong) NSString * customDimension5;

/**
 * Custom dimension 6.
 */
@property(nonatomic, strong) NSString * customDimension6;

/**
 * Custom dimension 7.
 */
@property(nonatomic, strong) NSString * customDimension7;

/**
 * Custom dimension 8.
 */
@property(nonatomic, strong) NSString * customDimension8;

/**
 * Custom dimension 9.
 */
@property(nonatomic, strong) NSString * customDimension9;

/**
 * Custom dimension 10.
 */
@property(nonatomic, strong) NSString * customDimension10;

/**
 * Custom dimension 11.
 */
@property(nonatomic, strong) NSString * customDimension11;

/**
 * Custom dimension 12.
 */
@property(nonatomic, strong) NSString * customDimension12;

/**
 * Custom dimension 13.
 */
@property(nonatomic, strong) NSString * customDimension13;

/**
 * Custom dimension 14.
 */
@property(nonatomic, strong) NSString * customDimension14;

/**
 * Custom dimension 15.
 */
@property(nonatomic, strong) NSString * customDimension15;

/**
 * Custom dimension 16.
 */
@property(nonatomic, strong) NSString * customDimension16;

/**
 * Custom dimension 17.
 */
@property(nonatomic, strong) NSString * customDimension17;

/**
 * Custom dimension 18.
 */
@property(nonatomic, strong) NSString * customDimension18;

/**
 * Custom dimension 19.
 */
@property(nonatomic, strong) NSString * customDimension19;

/**
 * Custom dimension 20.
 */
@property(nonatomic, strong) NSString * customDimension20;

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

@end
