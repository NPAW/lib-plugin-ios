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
        get { return self.parseResource}
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
        get { return self.parseResource}
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
        get { return self.parseResource}
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
     TimeInterval of time to search for a new cdn
    */
    public var cdnTTL: TimeInterval = 60
    
    /**
     * List of experiment ids to use with SmartUsers
     */
    public var experimentIds: [String] = []
    
    /**
     * IP of the viewer/user, e.g. "48.15.16.23".
     */
    public var networkIP: String?
    
    /**
     * Name of the NSNumberernet service provider of the viewer/user.
     */
    public var networkIsp: String?
    
    /**
     * See a list of codes in <a href="http://mapi.youbora.com:8081/connectionTypes">http://mapi.youbora.com:8081/connectionTypes</a>.
     */
    public var networkConnectionType: String?

    /**
     * Force init enabled
     */
    public var forceInit: Bool = false
    
    /**
     * Flag that indicates if the plugin should send total bytes or not default false
     */
    public var sendTotalBytes: NSNumber = NSNumber(value: false)
    
    /**
     * Dictionary containing the session metrics.
     */
    public var sessionMetrics: [String: AnyHashable]?
    
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
    public var isInfinity: NSNumber?
    
    /**
     * Config code for smartswitch
     */
    public var smartswitchConfigCode: String?

    /**
     * Group code for smartswitch
     */
    public var smartswitchGroupCode: String?

    /**
     * Contract code for smartswitch
     */
    public var smartswitchContractCode: String?
    
    /*
     * Name of the app
     */
    public var appName: String?

    /**
     * Release version of the app
     */
    public var appReleaseVersion: String?

    /**
     * Enabling this option enables the posibility of getting the /start request later on the view,
     * making the flow go as follows: /init is sent when the player starts to load content,
     * then when the playback starts /joNSNumberime event will be sent, but with the difference of no /start
     * request, instead it will be delayed until all the option keys from pendingMetadata
     * are not null, this is very important, since an empty string is considered a not null
     * and therefore is a valid value.
     */
    public var waitForMetadata: Bool = false

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
    public var pendingMetadata: [String] = []
    
    // MARK: User Options
    
    /**
     * User type value inside your system.
     */
    public var username: String?
    
    /**
     * User ID value inside your system.
     */
    public var userType: String?
    
    /**
     * User email
     */
    public var userEmail: String?
    
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
    public var userObfuscateIp: NSNumber?
    /**
     * User ID value inside your system for anon users
     */
    public var anonymousUser: String?
    
    // MARK: Device Options
    /**
     * Youbora's device code. If specified it will rewrite info gotten from user agent.
     * See a list of codes in <a href="http://mapi.youbora.com:8081/devices">http://mapi.youbora.com:8081/devices</a>.
     */
    public var deviceCode: String?
    
    /**
    * What will be displayed as the device model on Youbora (provided by default with android.os.Build.MODEL if not set)
    */
    public var deviceModel: String?
    
    /**
     * What will be displayed as the device brand on Youbora (provided by default with android.os.Build.BRAND if not set)
     */
    public var deviceBrand: String?
    
    /**
     * What will be displayed as the device type on Youbora (pc, smartphone, stb, tv, etc.)
     */
    public var deviceType: String?

    /**
     * What will be displayed as the device name on Youbora (pc, smartphone, stb, tv, etc.)
     */
    public var deviceName: String?
    
    /**
     * OS name that will be displayed on Youbora
     */
    public var deviceOsName: String?
    
    /**
     * OS version that will be displayed on Youbora (provided by default with android.os.Build.VERSION.RELEASE if not set)
     */
    public var deviceOsVersion: String?
    
    /**
     * Option to not send deviceUUID
     */
    public var deviceIsAnonymous: Bool = false
    
    // MARK: Content Options
    
    /**
     * URL/path of the current media resource.
     */
    public var contentResource: String?
    
    /**
     * true if the content is Live. false if VOD. Default: nil. If not nill this value will have more priority then
     * the value that comes from the adapter. Case nil the plugin will try to get this value from the adapter
     */
    public var contentIsLive: NSNumber?
    
    /**
     * Title of the media.
     */
    public var contentTitle: String?
    
    /**
     * Secondary title of the media. This could be program name, season, episode, etc.
     */
    @available(*, deprecated, message: "This option will be removed on future releases. Use program instead")
    public var contentTitle2: String?
    
    /**
     * Program title of the media. This could be program name, season, episode, etc.
     */
    public var program: String?
    
    /**
     * Duration of the media in seconds.
     */
    public var contentDuration: NSNumber?
    
    /**
     * Custom unique code to identify the view.
     */
    public var contentTransactionCode: String?
    
    /**
     * Bitrate of the content in bits per second.
     */
    public var contentBitrate: NSNumber?
    
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
    private var _contentStreamingProtocol: String?
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
    private var _contentTransportFormat: String?
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
    public var contentThroughput: NSNumber?
    
    /**
     * Name or value of the current rendition (quality) of the content.
     */
    public var contentRendition: String?
    
    /**
     * Codename of the CDN where the content is streaming from.
     * See a list of codes in <a href="http://mapi.youbora.com:8081/cdns">http://mapi.youbora.com:8081/cdns</a>.
     */
    public var contentCdn: String?
    
    /**
     * Frames per second of the media being played.
     */
    public var contentFps: NSNumber?
    
    /**
     * Dictionary containing mixed extra information about the content like: director, parental rating,
     * device info or the audio channels.
     */
    public var contentMetadata: [String: AnyHashable] = [:]
    
    /**
     * Dictionary containing the content metrics.
     */
    public var contentMetrics: [String: AnyHashable]?
    
    /**
     * Bool containing if seeks should be disabled for life content, only applies if content is live, if it's VOD it gets ignored
     */
    public var contentIsLiveNoSeek: NSNumber = NSNumber(value: false)
    
    /**
     * String containing the content package
     */
    public var contentPackage: String?
    
    /**
     * String containing the content saga
     */
    public var contentSaga: String?
    
    /**
     * String containing the content show
     */
    public var contentTvShow: String?
    
    /**
     * String containing the content season
     */
    public var contentSeason: String?
    
    /**
     * String containing the content episode title
     */
    public var contentEpisodeTitle: String?
    
    /**
     * String containing the content channel
     */
    public var contentChannel: String?

    /**
     * String containing the content id
     */
    public var contentId: String?
    
    /**
     * String containing the content imdb id
     */
    public var contentImdbId: String?
    
    /**
     * NSString containing the content gracenote id
     */
    public var contentGracenoteId: String?

    /**
     * NSString containing the content type
     */
    public var contentType: String?

    /**
     * NSString containing the content genre
     */
    public var contentGenre: String?

    /**
     * NSString containing the content language
     */
    public var contentLanguage: String?

    /**
     * NSString containing the content subtitles
     */
    public var contentSubtitles: String?

    /**
     * NSString containing the content contracted resolution
     */
    public var contentContractedResolution: String?

    /**
     * NSString containing the content cost
     */
    public var contentCost: String?

    /**
     * NSString containing the content price
     */
    public var contentPrice: String?

    /**
     * NSString containing the content playback type
     */
    public var contentPlaybackType: String?

    /**
     * NSString containing the content drm
     */
    public var contentDrm: String?

    /**
     * NSString containing the content encoding video codec
     */
    public var contentEncodingVideoCodec: String?

    /**
     * NSString containing the content encoding audio codec
     */
    public var contentEncodingAudioCodec: String?

    /**
     * NSString containing the content encoding codec settings
     */
    public var contentEncodingCodecSettings: [String: AnyHashable] = [:]

    /**
     * NSString containing the content encoding codec profile
     */
    public var contentEncodingCodecProfile: String?

    /**
     * NSString containing the content encoding container format
     */
    public var contentEncodingContainerFormat: String?
    
    /**
     * Content custom dimension 1.
     */
    public var contentCustomDimension1: String?

    /**
     * Content custom dimension 2.
     */
    public var contentCustomDimension2: String?

    /**
     * Content custom dimension 3.
     */
    public var contentCustomDimension3: String?

    /**
     * Content custom dimension 4.
     */
    public var contentCustomDimension4: String?

    /**
     * Content custom dimension 5.
     */
    public var contentCustomDimension5: String?

    /**
     * Content custom dimension 6.
     */
    public var contentCustomDimension6: String?

    /**
     * Content custom dimension 7.
     */
    public var contentCustomDimension7: String?

    /**
     * Content custom dimension 8.
     */
    public var contentCustomDimension8: String?

    /**
     * Content custom dimension 9.
     */
    public var contentCustomDimension9: String?

    /**
     * Content custom dimension 10.
     */
    public var contentCustomDimension10: String?

    /**
     * Content custom dimension 11.
     */
    public var contentCustomDimension11: String?

    /**
     * Content custom dimension 12.
     */
    public var contentCustomDimension12: String?

    /**
     * Content custom dimension 13.
     */
    public var contentCustomDimension13: String?

    /**
     * Content custom dimension 14.
     */
    public var contentCustomDimension14: String?

    /**
     * Content custom dimension 15.
     */
    public var contentCustomDimension15: String?

    /**
     * Content custom dimension 16.
     */
    public var contentCustomDimension16: String?

    /**
     * Content custom dimension 17.
     */
    public var contentCustomDimension17: String?

    /**
     * Content custom dimension 18.
     */
    public var contentCustomDimension18: String?

    /**
     * Content custom dimension 19.
     */
    public var contentCustomDimension19: String?

    /**
     * Content custom dimension 20.
     */
    public var contentCustomDimension20: String?
    
    /**
     * Custom dimension 1.
     */
    @available(*, deprecated, message: "Use contentCustomDimension1 instead")
    public var customDimension1: String?
    
    /**
     * Custom dimension 2.
     */
    @available(*, deprecated, message: "Use contentCustomDimension2 instead")
    public var customDimension2: String?
    
    /**
     * Custom dimension 3.
     */
    @available(*, deprecated, message: "Use contentCustomDimension3 instead")
    public var customDimension3: String?
    
    /**
     * Custom dimension 4.
     */
    @available(*, deprecated, message: "Use contentCustomDimension4 instead")
    public var customDimension4: String?
    
    /**
     * Custom dimension 5.
     */
    @available(*, deprecated, message: "Use contentCustomDimension5 instead")
    public var customDimension5: String?
    
    /**
     * Custom dimension 6.
     */
    @available(*, deprecated, message: "Use contentCustomDimension6 instead")
    public var customDimension6: String?
    /**
     * Custom dimension 7.
     */
    @available(*, deprecated, message: "Use contentCustomDimension7 instead")
    public var customDimension7: String?
    
    /**
     * Custom dimension 8.
     */
    @available(*, deprecated, message: "Use contentCustomDimension8 instead")
    public var customDimension8: String?
    
    /**
     * Custom dimension 9.
     */
    @available(*, deprecated, message: "Use contentCustomDimension9 instead")
    public var customDimension9: String?
    
    /**
     * Custom dimension 10.
     */
    @available(*, deprecated, message: "Use contentCustomDimension10 instead")
    public var customDimension10: String?
    /**
     * Custom dimension 11.
     */
    @available(*, deprecated, message: "Use contentCustomDimension11 instead")
    public var customDimension11: String?
    
    /**
     * Custom dimension 12.
     */
    @available(*, deprecated, message: "Use contentCustomDimension12 instead")
    public var customDimension12: String?
    
    /**
     * Custom dimension 13.
     */
    @available(*, deprecated, message: "Use contentCustomDimension13 instead")
    public var customDimension13: String?
    
    /**
     * Custom dimension 14.
     */
    @available(*, deprecated, message: "Use contentCustomDimension14 instead")
    public var customDimension14: String?
    
    /**
     * Custom dimension 15.
     */
    @available(*, deprecated, message: "Use contentCustomDimension15 instead")
    public var customDimension15: String?
    
    /**
     * Custom dimension 16.
     */
    @available(*, deprecated, message: "Use contentCustomDimension16 instead")
    public var customDimension16: String?
    
    /**
     * Custom dimension 17.
     */
    @available(*, deprecated, message: "Use contentCustomDimension17 instead")
    public var customDimension17: String?
    
    /**
     * Custom dimension 18.
     */
    @available(*, deprecated, message: "Use contentCustomDimension18 instead")
    public var customDimension18: String?
    
    /**
     * Custom dimension 19.
     */
    @available(*, deprecated, message: "Use contentCustomDimension19 instead")
    public var customDimension19: String?
    
    /**
     * Custom dimension 20.
     */
    @available(*, deprecated, message: "Use contentCustomDimension20 instead")
    public var customDimension20: String?
    
    // MARK: Ads Options
    
    /**
     * NSDictionary containing mixed extra information about the ads like: director, parental rating,
     * device info or the audio channels.
     */
    public var adMetadata: [String: AnyHashable] = [:]

    /**
     * Variable containing number of ads after stop
     */
    public var adsAfterStop: NSNumber = 0

    /**
     * Variable containing ad campaign
     */
    public var adCampaign: String?

    /**
     * Variable containing ad title
     */
    public var adTitle: String?
    /**
     * Variable containing ad resource
     */
    public var adResource: String?

    /**
     * Variable containing how many ad breaks will be shown for the active view
     */
    public var adGivenBreaks: NSNumber?

    /**
     * Variable containing how many ad breaks should be shown for the active view
     */
    public var adExpectedBreaks: NSNumber?

    /**
     * Variable containing how many ads will be shown for each break
     * Keys must be any of the following constants: YBAdPosition.pre, YBAdPosition.mid or YBAdPosition.post
     * Value must be an NSArray containing the number of ads per break (each break is an Array position)
     */
    public var adExpectedPattern: [String: [NSNumber]]?

    /**
     * Variable containing at which moment of the playback a break should be displayed
     */
    public var adBreaksTime: [Any]?

    /**
     * Variable containing how many ads should be played for the current break
     */
    public var adGivenAds: NSNumber?

    /**
     * Variable containing ad creativeId
     */
    public var adCreativeId: String?

    /**
     * Variable containing ad provider
     */
    public var adProvider: String?
    
    /**
     * Custom ad dimension 1.
     */
    public var adCustomDimension1: String?

    /**
     * Custom ad dimension 2.
     */
    public var adCustomDimension2: String?

    /**
     * Custom ad dimension 3.
     */
    public var adCustomDimension3: String?

    /**
     * Custom ad dimension 4.
     */
    public var adCustomDimension4: String?

    /**
     * Custom ad dimension 5.
     */
    public var adCustomDimension5: String?

    /**
     * Custom ad dimension 6.
     */
    public var adCustomDimension6: String?

    /**
     * Custom ad dimension 7.
     */
    public var adCustomDimension7: String?

    /**
     * Custom ad dimension 8.
     */
    public var adCustomDimension8: String?

    /**
     * Custom ad dimension 9.
     */
    public var adCustomDimension9: String?

    /**
     * Custom ad dimension 10.
     */
    public var adCustomDimension10: String?

    /**
     * Custom ad parameter 1.
     */
    @available(*, deprecated, message: "Use adCustomDimension1 instead")
    public var adExtraparam1: String? {
        set {self.adCustomDimension1 = newValue}
        get {return self.adCustomDimension1}
    }

    /**
     * Custom ad parameter 2.
     */
    @available(*, deprecated, message: "Use adCustomDimension2 instead")
    public var adExtraparam2: String? {
        set {self.adCustomDimension2 = newValue}
        get {return self.adCustomDimension2}
    }

    /**
     * Custom ad parameter 3.
     */
    @available(*, deprecated, message: "Use adCustomDimension3 instead")
    public var adExtraparam3: String? {
        set {self.adCustomDimension3 = newValue}
        get {return self.adCustomDimension3}
    }

    /**
     * Custom ad parameter 4.
     */
    @available(*, deprecated, message: "Use adCustomDimension4 instead")
    public var adExtraparam4: String? {
        set {self.adCustomDimension4 = newValue}
        get {return self.adCustomDimension4}
    }

    /**
     * Custom ad parameter 5.
     */
    @available(*, deprecated, message: "Use adCustomDimension5 instead")
    public var adExtraparam5: String? {
        set {self.adCustomDimension5 = newValue}
        get {return self.adCustomDimension5}
    }

    /**
     * Custom ad parameter 6.
     */
    @available(*, deprecated, message: "Use adCustomDimension6 instead")
    public var adExtraparam6: String? {
        set {self.adCustomDimension6 = newValue}
        get {return self.adCustomDimension6}
    }

    /**
     * Custom ad parameter 7.
     */
    @available(*, deprecated, message: "Use adCustomDimension7 instead")
    public var adExtraparam7: String? {
        set {self.adCustomDimension7 = newValue}
        get {return self.adCustomDimension7}
    }

    /**
     * Custom ad parameter 8.
     */
    @available(*, deprecated, message: "Use adCustomDimension8 instead")
    public var adExtraparam8: String? {
        set {self.adCustomDimension8 = newValue}
        get {return self.adCustomDimension8}
    }

    /**
     * Custom ad parameter 9.
     */
    @available(*, deprecated, message: "Use adCustomDimension9 instead")
    public var adExtraparam9: String? {
        set {self.adCustomDimension9 = newValue}
        get {return self.adCustomDimension9}
    }

    /**
     * Custom ad parameter 10.
     */
    @available(*, deprecated, message: "Use adCustomDimension10 instead")
    public var adExtraparam10: String? {
        set {self.adCustomDimension10 = newValue}
        get {return self.adCustomDimension10}
    }
}
