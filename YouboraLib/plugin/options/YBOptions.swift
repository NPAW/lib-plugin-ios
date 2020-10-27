//
//  YBSwiftOptions.swift
//  YouboraLib
//
//  Created by Tiago Pereira on 16/10/2020.
//  Copyright © 2020 NPAW. All rights reserved.
//

import Foundation

/**
 * This class stores all the Youbora configuration settings.
 * Any value specified in this class, if set, will override the info the plugin is able to get on
 * its own.
 *
 * The only required option is the accountCode.
 */
@objcMembers public class YBOptions: NSObject {
    // MARK: Generic Options
    /**
     * If enabled the plugin won't send NQS requests.
     * Default: true
     */
    public var enabled: Bool = true
    
    /**
     * Define the security of NQS calls.
     * If true it will use "https://".
     * If false it will use "http://".
     * Default: true
     */
    public var httpSecure: Bool = true
    
    /**
     * Host of the Fastdata service.
     */
    public var host: String = "a-fds.youborafds01.com"
    
    /**
     * NicePeopleAtWork account code that indicates the customer account.
     */
    public var accountCode: String = "nicetest"
    
    /**
    * If true the plugin will parse hls, cdn and location
    * It might slow performance down.
    * Default: false
    */
    public var parseResource: Bool = false
    
    /**
     * If true the plugin will parse HLS files to use the first .ts file found as resource.
     * It might slow performance down.
     * Default: false
     */
    @available(*, deprecated, message: "Use parseResource instead")
    public var parseHls: Bool {
        set {
            if !self.parseResource && newValue {
                self.parseResource = newValue
            }
        }
        get { self.parseResource}
    }

    /**
     * If true the plugin will look for the location and segment values inside dash manifest to retrieve the actual resource
     * It might slow performance down.
     * Default: false
     */
    @available(*, deprecated, message: "Use parseResource instead")
    public var parseDash: Bool {
        set {
            if !self.parseResource && newValue {
                self.parseResource = newValue
            }
        }
        get { self.parseResource}
    }

    /**
     * If true the plugin will parse the resource to try and find out the real given resource instead of the API url
     * It might slow performance down.
     * Default: false
     */
    @available(*, deprecated, message: "Use parseResource instead")
    public var parseLocationHeader: Bool {
        set {
            if !self.parseResource && newValue {
                self.parseResource = newValue
            }
        }
        get { self.parseResource}
    }
    
    /**
     * If defined, resource parse will try to fetch the CDN code from the custom header defined
     * by this property, e.g. "x-cdn-forward"
     */
    public var parseCdnNameHeader: String = "x-cdn-forward"
    
    /**
     * If true the plugin will query the CDN to retrieve the node name.
     * It might slow performance down.
     * Default: false
     */
    public var parseCdnNode: Bool = false
    
    /**
     * List of CDN names to parse. This is only used when <parseCdnNode> is enabled.
     * Order is respected when trying to match against a CDN.
     * Default: ["Akamai", "Cloudfront", "Level3", "Fastly", "Highwinds", "Telefonica", "Amazon"].
     */
    public var parseCdnNodeList: [String] = [
        YBCdnName.akamai,
        YBCdnName.cloudfront,
        YBCdnName.level3,
        YBCdnName.fastly,
        YBCdnName.highwinds,
        YBCdnName.telefonica,
        YBCdnName.amazon
    ]
    
    /**
     * Flag indicating if the cdn parser should search for new cdn
     */
    public var cdnSwitchHeader: Bool = false
    
    /**
     NSNumbererval of time to search for a new cdn
    */
    public var cdnTTL: TimeInterval = 60
    
    /**
     * List of experiment ids to use with SmartUsers
     */
    public var experimentIds: [String] = []
    
    /**
     * IP of the viewer/user, e.g. "48.15.16.23".
     */
    public var networkIP: String? = nil
    
    /**
     * Name of the NSNumberernet service provider of the viewer/user.
     */
    public var networkIsp: String? = nil
    
    /**
     * See a list of codes in <a href="http://mapi.youbora.com:8081/connectionTypes">http://mapi.youbora.com:8081/connectionTypes</a>.
     */
    public var networkConnectionType: String? = nil

    /**
     * Force init enabled
     */
    public var forceInit: Bool = false
    
    /**
     * Flag that indicates if the plugin should send total bytes or not default false
     */
    public var sendTotalBytes: Bool = false
    
    /**
     * Dictionary containing the session metrics.
     */
    public var sessionMetrics: [String: Any] = [:]
    
    /**
     * If true the plugin will fireStop when going to background
     * Default: true
     */
    public var autoDetectBackground: Bool = true

    /**
     * If true no request will we send and saved for later instead
     */
    public var offline: Bool = false
    
    /**
     * Flag if Infinity is going to be used
     */
    @available(*, deprecated, message: "This property will be removed in future releases")
    public var isInfinity: NSNumber? = nil
    
    /**
     * Config code for smartswitch
     */
    public var smartswitchConfigCode: String? = nil

    /**
     * Group code for smartswitch
     */
    public var smartswitchGroupCode: String? = nil

    /**
     * Contract code for smartswitch
     */
    public var smartswitchContractCode: String? = nil
    
    /*
     * Name of the app
     */
    public var appName: String? = nil

    /**
     * Release version of the app
     */
    public var appReleaseVersion: String? = nil

    /**
     * Enabling this option enables the posibility of getting the /start request later on the view,
     * making the flow go as follows: /init is sent when the player starts to load content,
     * then when the playback starts /joNSNumberime event will be sent, but with the difference of no /start
     * request, instead it will be delayed until all the option keys from pendingMetadata
     * are not null, this is very important, since an empty string is considered a not null
     * and therefore is a valid value.
     */
    public var waitForMetadata:Bool = false

    /**
     * Set option keys you want to wait for metadata, in order to work waitForMetadata
     * must be set to true.
     * You need to create an NSArray with all the options you want to make the start be hold on.
     * You can find all the keys with the following format:  YBOptionsKeys.Property.{option name} where option
     * name is the same one as the option itself.
     *
     * Find below an example:
     *
     * NSArray *array = @[ YBOptionsKeys.Property.contentTitle, YBOptionsKeys.Property.contentCustomDimension1]
     * options.pendingMetadata = array
     *
     * The code above prevent the /start request unless contentTItle and contentCustomDimension1
     * stop being nil (you can set a non nil value to any property when information is available).
     */
    public var pendingMetadata: [String] = [];
    
    // MARK: User Options
    
    /**
     * User type value inside your system.
     */
    public var username: String? = nil
    
    /**
     * User ID value inside your system.
     */
    public var userType: String? = nil
    
    /**
     * User email
     */
    public var userEmail: String? = nil
    
    /**
     * If the ip address should be abfuscated
     */
    @available(*, deprecated, message: "Use userObfuscateIp instead")
    public var networkObfuscateIp: NSNumber? {
        set { self.userObfuscateIp = newValue }
        get { return self.userObfuscateIp }
    }
    
    /**
     * If the ip address should be abfuscated
     */
    public var userObfuscateIp: NSNumber? = nil
    /**
     * User ID value inside your system for anon users
     */
    public var anonymousUser: String? = nil
    
    // MARK: Device Options
    /**
     * Youbora's device code. If specified it will rewrite info gotten from user agent.
     * See a list of codes in <a href="http://mapi.youbora.com:8081/devices">http://mapi.youbora.com:8081/devices</a>.
     */
    public var deviceCode: String? = nil
    
    /**
    * What will be displayed as the device model on Youbora (provided by default with android.os.Build.MODEL if not set)
    */
    public var deviceModel: String? = nil
    
    /**
     * What will be displayed as the device brand on Youbora (provided by default with android.os.Build.BRAND if not set)
     */
    public var deviceBrand: String? = nil
    
    /**
     * What will be displayed as the device type on Youbora (pc, smartphone, stb, tv, etc.)
     */
    public var deviceType: String? = nil

    /**
     * What will be displayed as the device name on Youbora (pc, smartphone, stb, tv, etc.)
     */
    public var deviceName: String? = nil
    
    /**
     * OS name that will be displayed on Youbora
     */
    public var deviceOsName: String? = nil
    
    /**
     * OS version that will be displayed on Youbora (provided by default with android.os.Build.VERSION.RELEASE if not set)
     */
    public var deviceOsVersion: String? = nil
    
    /**
     * Option to not send deviceUUID
     */
    public var deviceIsAnonymous: Bool = false
    
    // MARK: Content Options
    
    /**
     * URL/path of the current media resource.
     */
    public var contentResource: String? = nil
    
    /**
     * true if the content is Live. false if VOD. Default: nil. If not nill this value will have more priority then
     * the value that comes from the adapter. Case nil the plugin will try to get this value from the adapter
     */
    public var contentIsLive: NSNumber? = nil
    
    /**
     * Title of the media.
     */
    public var contentTitle: String? = nil
    
    /**
     * Secondary title of the media. This could be program name, season, episode, etc.
     */
    @available(*, deprecated, message: "This option will be removed on future releases. Use program instead")
    public var contentTitle2: String? = nil
    
    /**
     * Program title of the media. This could be program name, season, episode, etc.
     */
    public var program: String? = nil
    
    /**
     * Duration of the media in seconds.
     */
    public var contentDuration: NSNumber? = nil
    
    /**
     * Custom unique code to identify the view.
     */
    public var contentTransactionCode: String? = nil
    
    /**
     * Bitrate of the content in bits per second.
     */
    public var contentBitrate: NSNumber? = nil
    
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
    private var _contentStreamingProtocol: String? = nil
    public var contentStreamingProtocol: String? {
        set {
            let allowedProtocols = [
                YBConstantsStreamProtocol.dash,
                YBConstantsStreamProtocol.hds,
                YBConstantsStreamProtocol.hls,
                YBConstantsStreamProtocol.mss,
                YBConstantsStreamProtocol.rtmp,
                YBConstantsStreamProtocol.rtp,
                YBConstantsStreamProtocol.rtsp
            ]
            
            if let newValue = newValue, allowedProtocols.contains(newValue) {
                self._contentStreamingProtocol = newValue
            }
        }
        
        get { return _contentStreamingProtocol }
    }
    
    /**
    * Transport format of the content, you can use any of these YBConstantsTransportFormat:
    YBConstantsTransportFormat.hlsTs
    YBConstantsTransportFormat.hlsFmp4
    */
    private var _contentTransportFormat: String? = nil
    public var contentTransportFormat: String? {
        set {
            let allowedProtocols = [
                YBConstantsTransportFormat.hlsTs,
                YBConstantsTransportFormat.hlsFmp4
            ]
            
            if let newValue = newValue, allowedProtocols.contains(newValue) {
                self._contentTransportFormat = newValue
            }
        }
        
        get { return _contentTransportFormat }
    }
    
    /**
     * Throughput of the client bandwidth in bits per second.
     */
    public var contentThroughput: NSNumber? = nil
    
    /**
     * Name or value of the current rendition (quality) of the content.
     */
    public var contentRendition: String? = nil
    
    /**
     * Codename of the CDN where the content is streaming from.
     * See a list of codes in <a href="http://mapi.youbora.com:8081/cdns">http://mapi.youbora.com:8081/cdns</a>.
     */
    public var contentCdn: String? = nil
    
    /**
     * Frames per second of the media being played.
     */
    public var contentFps: NSNumber? = nil
    
    /**
     * Dictionary containing mixed extra information about the content like: director, parental rating,
     * device info or the audio channels.
     */
    public var contentMetadata: [String: Any] = [:]
    
    /**
     * Dictionary containing the content metrics.
     */
    public var contentMetrics: [String: Any] = [:]
    
    /**
     * Bool containing if seeks should be disabled for life content, only applies if content is live, if it's VOD it gets ignored
     */
    public var contentIsLiveNoSeek: Bool = false
    
    /**
     * String containing the content package
     */
    public var contentPackage: String? = nil
    
    /**
     * String containing the content saga
     */
    public var contentSaga: String? = nil
    
    /**
     * String containing the content show
     */
    public var contentTvShow: String? = nil
    
    /**
     * String containing the content season
     */
    public var contentSeason: String? = nil
    
    /**
     * String containing the content episode title
     */
    public var contentEpisodeTitle: String? = nil
    
    /**
     * String containing the content channel
     */
    public var contentChannel: String? = nil

    /**
     * String containing the content id
     */
    public var contentId: String? = nil
    
    /**
     * String containing the content imdb id
     */
    public var contentImdbId: String? = nil
    
    /**
     * NSString containing the content gracenote id
     */
    public var contentGracenoteId: String? = nil

    /**
     * NSString containing the content type
     */
    public var contentType: String? = nil

    /**
     * NSString containing the content genre
     */
    public var contentGenre: String? = nil

    /**
     * NSString containing the content language
     */
    public var contentLanguage: String? = nil

    /**
     * NSString containing the content subtitles
     */
    public var contentSubtitles: String? = nil

    /**
     * NSString containing the content contracted resolution
     */
    public var contentContractedResolution: String? = nil

    /**
     * NSString containing the content cost
     */
    public var contentCost: String? = nil

    /**
     * NSString containing the content price
     */
    public var contentPrice: String? = nil

    /**
     * NSString containing the content playback type
     */
    public var contentPlaybackType: String? = nil

    /**
     * NSString containing the content drm
     */
    public var contentDrm: String? = nil

    /**
     * NSString containing the content encoding video codec
     */
    public var contentEncodingVideoCodec: String? = nil

    /**
     * NSString containing the content encoding audio codec
     */
    public var contentEncodingAudioCodec: String? = nil

    /**
     * NSString containing the content encoding codec settings
     */
    public var contentEncodingCodecSettings: [String: Any] = [:]

    /**
     * NSString containing the content encoding codec profile
     */
    public var contentEncodingCodecProfile: String? = nil

    /**
     * NSString containing the content encoding container format
     */
    public var contentEncodingContainerFormat: String? = nil
    
    /**
     * Content custom dimension 1.
     */
    public var contentCustomDimension1: String? = nil

    /**
     * Content custom dimension 2.
     */
    public var contentCustomDimension2: String? = nil

    /**
     * Content custom dimension 3.
     */
    public var contentCustomDimension3: String? = nil

    /**
     * Content custom dimension 4.
     */
    public var contentCustomDimension4: String? = nil

    /**
     * Content custom dimension 5.
     */
    public var contentCustomDimension5: String? = nil

    /**
     * Content custom dimension 6.
     */
    public var contentCustomDimension6: String? = nil

    /**
     * Content custom dimension 7.
     */
    public var contentCustomDimension7: String? = nil

    /**
     * Content custom dimension 8.
     */
    public var contentCustomDimension8: String? = nil

    /**
     * Content custom dimension 9.
     */
    public var contentCustomDimension9: String? = nil

    /**
     * Content custom dimension 10.
     */
    public var contentCustomDimension10: String? = nil

    /**
     * Content custom dimension 11.
     */
    public var contentCustomDimension11: String? = nil

    /**
     * Content custom dimension 12.
     */
    public var contentCustomDimension12: String? = nil

    /**
     * Content custom dimension 13.
     */
    public var contentCustomDimension13: String? = nil

    /**
     * Content custom dimension 14.
     */
    public var contentCustomDimension14: String? = nil

    /**
     * Content custom dimension 15.
     */
    public var contentCustomDimension15: String? = nil

    /**
     * Content custom dimension 16.
     */
    public var contentCustomDimension16: String? = nil

    /**
     * Content custom dimension 17.
     */
    public var contentCustomDimension17: String? = nil

    /**
     * Content custom dimension 18.
     */
    public var contentCustomDimension18: String? = nil

    /**
     * Content custom dimension 19.
     */
    public var contentCustomDimension19: String? = nil

    /**
     * Content custom dimension 20.
     */
    public var contentCustomDimension20: String? = nil
    
    /**
     * Custom dimension 1.
     */
    @available(*, deprecated, message: "Use contentCustomDimension1 instead")
    public var customDimension1: String? {
        set{ self.contentCustomDimension1 = newValue}
        get {self.contentCustomDimension1}
    }
    
    /**
     * Custom dimension 2.
     */
    @available(*, deprecated, message: "Use contentCustomDimension2 instead")
    public var customDimension2: String? {
        set{ self.contentCustomDimension2 = newValue}
        get {self.contentCustomDimension2}
    }
    
    /**
     * Custom dimension 3.
     */
    @available(*, deprecated, message: "Use contentCustomDimension3 instead")
    public var customDimension3: String? {
        set{ self.contentCustomDimension3 = newValue}
        get {self.contentCustomDimension3}
    }
    
    /**
     * Custom dimension 4.
     */
    @available(*, deprecated, message: "Use contentCustomDimension4 instead")
    public var customDimension4 : String? {
        set{ self.contentCustomDimension4 = newValue}
        get {self.contentCustomDimension4}
    }
    
    /**
     * Custom dimension 5.
     */
    @available(*, deprecated, message: "Use contentCustomDimension5 instead")
    public var customDimension5 : String? {
        set{ self.contentCustomDimension5 = newValue}
        get {self.contentCustomDimension5}
    }
    
    /**
     * Custom dimension 6.
     */
    @available(*, deprecated, message: "Use contentCustomDimension6 instead")
    public var customDimension6 : String? {
        set{ self.contentCustomDimension6 = newValue}
        get {self.contentCustomDimension6}
    }
    /**
     * Custom dimension 7.
     */
    @available(*, deprecated, message: "Use contentCustomDimension7 instead")
    public var customDimension7: String? {
        set{ self.contentCustomDimension7 = newValue}
        get {self.contentCustomDimension7}
    }
    
    /**
     * Custom dimension 8.
     */
    @available(*, deprecated, message: "Use contentCustomDimension8 instead")
    public var customDimension8: String? {
        set{ self.contentCustomDimension8 = newValue}
        get {self.contentCustomDimension8}
    }
    
    /**
     * Custom dimension 9.
     */
    @available(*, deprecated, message: "Use contentCustomDimension9 instead")
    public var customDimension9: String? {
        set{ self.contentCustomDimension9 = newValue}
        get {self.contentCustomDimension9}
    }
    
    /**
     * Custom dimension 10.
     */
    @available(*, deprecated, message: "Use contentCustomDimension10 instead")
    public var customDimension10: String? {
        set{ self.contentCustomDimension10 = newValue}
        get {self.contentCustomDimension10}
    }
    /**
     * Custom dimension 11.
     */
    @available(*, deprecated, message: "Use contentCustomDimension11 instead")
    public var customDimension11: String? {
        set{ self.contentCustomDimension11 = newValue}
        get {self.contentCustomDimension11}
    }
    
    /**
     * Custom dimension 12.
     */
    @available(*, deprecated, message: "Use contentCustomDimension12 instead")
    public var customDimension12: String? {
        set{ self.contentCustomDimension12 = newValue}
        get {self.contentCustomDimension12}
    }
    
    /**
     * Custom dimension 13.
     */
    @available(*, deprecated, message: "Use contentCustomDimension13 instead")
    public var customDimension13: String? {
        set{ self.contentCustomDimension13 = newValue}
        get {self.contentCustomDimension13}
    }
    
    /**
     * Custom dimension 14.
     */
    @available(*, deprecated, message: "Use contentCustomDimension14 instead")
    public var customDimension14: String? {
        set{ self.contentCustomDimension14 = newValue}
        get {self.contentCustomDimension14}
    }
    
    /**
     * Custom dimension 15.
     */
    @available(*, deprecated, message: "Use contentCustomDimension15 instead")
    public var customDimension15: String? {
        set{ self.contentCustomDimension15 = newValue}
        get {self.contentCustomDimension15}
    }
    
    /**
     * Custom dimension 16.
     */
    @available(*, deprecated, message: "Use contentCustomDimension16 instead")
    public var customDimension16: String? {
        set{ self.contentCustomDimension16 = newValue}
        get {self.contentCustomDimension16}
    }
    
    /**
     * Custom dimension 17.
     */
    @available(*, deprecated, message: "Use contentCustomDimension17 instead")
    public var customDimension17: String? {
        set{ self.contentCustomDimension17 = newValue}
        get {self.contentCustomDimension17}
    }
    
    /**
     * Custom dimension 18.
     */
    @available(*, deprecated, message: "Use contentCustomDimension18 instead")
    public var customDimension18: String? {
        set{ self.contentCustomDimension18 = newValue}
        get {self.contentCustomDimension18}
    }
    
    /**
     * Custom dimension 19.
     */
    @available(*, deprecated, message: "Use contentCustomDimension19 instead")
    public var customDimension19: String? {
        set{ self.contentCustomDimension19 = newValue}
        get {self.contentCustomDimension19}
    }
    
    /**
     * Custom dimension 20.
     */
    @available(*, deprecated, message: "Use contentCustomDimension20 instead")
    public var customDimension20: String? {
        set{ self.contentCustomDimension20 = newValue}
        get {self.contentCustomDimension20}
    }
    
    // MARK: Ads Options
    
    /**
     * NSDictionary containing mixed extra information about the ads like: director, parental rating,
     * device info or the audio channels.
     */
    public var adMetadata: [String: Any] = [:]

    /**
     * Variable containing number of ads after stop
     */
    public var adsAfterStop: NSNumber = 0

    /**
     * Variable containing ad campaign
     */
    public var adCampaign: String? = nil

    /**
     * Variable containing ad title
     */
    public var adTitle: String? = nil
    /**
     * Variable containing ad resource
     */
    public var adResource: String? = nil

    /**
     * Variable containing how many ad breaks will be shown for the active view
     */
    public var adGivenBreaks: NSNumber? = nil

    /**
     * Variable containing how many ad breaks should be shown for the active view
     */
    public var adExpectedBreaks: NSNumber? = nil

    /**
     * Variable containing how many ads will be shown for each break
     * Keys must be any of the following constants: YBAdPosition.pre, YBAdPosition.mid or YBAdPosition.post
     * Value must be an NSArray containing the number of ads per break (each break is an Array position)
     */
    public var adExpectedPattern: [String: [NSNumber]]? = nil

    /**
     * Variable containing at which moment of the playback a break should be displayed
     */
    public var adBreaksTime: [Any]? = nil;

    /**
     * Variable containing how many ads should be played for the current break
     */
    public var adGivenAds: NSNumber? = nil;

    /**
     * Variable containing ad creativeId
     */
    public var adCreativeId: String? = nil;

    /**
     * Variable containing ad provider
     */
    public var adProvider: String? = nil;
    
    /**
     * Custom ad dimension 1.
     */
    public var adCustomDimension1: String? = nil;

    /**
     * Custom ad dimension 2.
     */
    public var adCustomDimension2: String? = nil;

    /**
     * Custom ad dimension 3.
     */
    public var adCustomDimension3: String? = nil;

    /**
     * Custom ad dimension 4.
     */
    public var adCustomDimension4: String? = nil;

    /**
     * Custom ad dimension 5.
     */
    public var adCustomDimension5: String? = nil;

    /**
     * Custom ad dimension 6.
     */
    public var adCustomDimension6: String? = nil;

    /**
     * Custom ad dimension 7.
     */
    public var adCustomDimension7: String? = nil;

    /**
     * Custom ad dimension 8.
     */
    public var adCustomDimension8: String? = nil;

    /**
     * Custom ad dimension 9.
     */
    public var adCustomDimension9: String? = nil;

    /**
     * Custom ad dimension 10.
     */
    public var adCustomDimension10: String? = nil;

    /**
     * Custom ad parameter 1.
     */
    @available(*, deprecated, message: "Use adCustomDimension1 instead")
    public var adExtraparam1: String? {
        set{ self.adCustomDimension1 = newValue}
        get {self.adCustomDimension1}
    }

    /**
     * Custom ad parameter 2.
     */
    @available(*, deprecated, message: "Use adCustomDimension2 instead")
    public var adExtraparam2: String? {
        set{ self.adCustomDimension2 = newValue}
        get {self.adCustomDimension2}
    }

    /**
     * Custom ad parameter 3.
     */
    @available(*, deprecated, message: "Use adCustomDimension3 instead")
    public var adExtraparam3: String? {
        set{ self.adCustomDimension3 = newValue}
        get {self.adCustomDimension3}
    }

    /**
     * Custom ad parameter 4.
     */
    @available(*, deprecated, message: "Use adCustomDimension4 instead")
    public var adExtraparam4: String? {
        set{ self.adCustomDimension4 = newValue}
        get {self.adCustomDimension4}
    }

    /**
     * Custom ad parameter 5.
     */
    @available(*, deprecated, message: "Use adCustomDimension5 instead")
    public var adExtraparam5: String? {
        set{ self.adCustomDimension5 = newValue}
        get {self.adCustomDimension5}
    }

    /**
     * Custom ad parameter 6.
     */
    @available(*, deprecated, message: "Use adCustomDimension6 instead")
    public var adExtraparam6: String? {
        set{ self.adCustomDimension6 = newValue}
        get {self.adCustomDimension6}
    }

    /**
     * Custom ad parameter 7.
     */
    @available(*, deprecated, message: "Use adCustomDimension7 instead")
    public var adExtraparam7: String? {
        set{ self.adCustomDimension7 = newValue}
        get {self.adCustomDimension7}
    }

    /**
     * Custom ad parameter 8.
     */
    @available(*, deprecated, message: "Use adCustomDimension8 instead")
    public var adExtraparam8: String? {
        set{ self.adCustomDimension8 = newValue}
        get {self.adCustomDimension8}
    }

    /**
     * Custom ad parameter 9.
     */
    @available(*, deprecated, message: "Use adCustomDimension9 instead")
    public var adExtraparam9: String? {
        set{ self.adCustomDimension9 = newValue}
        get {self.adCustomDimension9}
    }

    /**
     * Custom ad parameter 10.
     */
    @available(*, deprecated, message: "Use adCustomDimension10 instead")
    public var adExtraparam10: String? {
        set{ self.adCustomDimension10 = newValue}
        get {self.adCustomDimension10}
    }
}
