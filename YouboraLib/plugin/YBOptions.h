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
@property(nonatomic, strong) NSString * contentTitle2;

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
 * Default: false
 */
@property(nonatomic, assign) bool autoDetectBackground;

/**
 * If true no request will we send and saved for later instead
 */
@property(nonatomic, assign) bool offline;

/**
 * Custom parameter 1.
 */
@property(nonatomic, strong) NSString * extraparam1;

/**
 * Custom parameter 2.
 */
@property(nonatomic, strong) NSString * extraparam2;

/**
 * Custom parameter 3.
 */
@property(nonatomic, strong) NSString * extraparam3;

/**
 * Custom parameter 4.
 */
@property(nonatomic, strong) NSString * extraparam4;

/**
 * Custom parameter 5.
 */
@property(nonatomic, strong) NSString * extraparam5;

/**
 * Custom parameter 6.
 */
@property(nonatomic, strong) NSString * extraparam6;

/**
 * Custom parameter 7.
 */
@property(nonatomic, strong) NSString * extraparam7;

/**
 * Custom parameter 8.
 */
@property(nonatomic, strong) NSString * extraparam8;

/**
 * Custom parameter 9.
 */
@property(nonatomic, strong) NSString * extraparam9;

/**
 * Custom parameter 10.
 */
@property(nonatomic, strong) NSString * extraparam10;

/**
 * Custom parameter 11.
 */
@property(nonatomic, strong) NSString * extraparam11;

/**
 * Custom parameter 12.
 */
@property(nonatomic, strong) NSString * extraparam12;

/**
 * Custom parameter 13.
 */
@property(nonatomic, strong) NSString * extraparam13;

/**
 * Custom parameter 14.
 */
@property(nonatomic, strong) NSString * extraparam14;

/**
 * Custom parameter 15.
 */
@property(nonatomic, strong) NSString * extraparam15;

/**
 * Custom parameter 16.
 */
@property(nonatomic, strong) NSString * extraparam16;

/**
 * Custom parameter 17.
 */
@property(nonatomic, strong) NSString * extraparam17;

/**
 * Custom parameter 18.
 */
@property(nonatomic, strong) NSString * extraparam18;

/**
 * Custom parameter 19.
 */
@property(nonatomic, strong) NSString * extraparam19;

/**
 * Custom parameter 20.
 */
@property(nonatomic, strong) NSString * extraparam20;

/**
 * Custom ad parameter 1.
 */
@property(nonatomic, strong) NSString * adExtraparam1;

/**
 * Custom ad parameter 2.
 */
@property(nonatomic, strong) NSString * adExtraparam2;

/**
 * Custom ad parameter 3.
 */
@property(nonatomic, strong) NSString * adExtraparam3;

/**
 * Custom ad parameter 4.
 */
@property(nonatomic, strong) NSString * adExtraparam4;

/**
 * Custom ad parameter 5.
 */
@property(nonatomic, strong) NSString * adExtraparam5;

/**
 * Custom ad parameter 6.
 */
@property(nonatomic, strong) NSString * adExtraparam6;

/**
 * Custom ad parameter 7.
 */
@property(nonatomic, strong) NSString * adExtraparam7;

/**
 * Custom ad parameter 8.
 */
@property(nonatomic, strong) NSString * adExtraparam8;

/**
 * Custom ad parameter 9.
 */
@property(nonatomic, strong) NSString * adExtraparam9;

/**
 * Custom ad parameter 10.
 */
@property(nonatomic, strong) NSString * adExtraparam10;

@end
