//
//  YBSwiftOptions.swift
//  YouboraLib
//
//  Created by Tiago Pereira on 16/10/2020.
//  Copyright © 2020 NPAW. All rights reserved.
//

import Foundation

// Class that will contains all the info relative to the optoins being used by the plugin
public class YBOptionsSwift: NSObject {
    
    /**
     * If enabled the plugin won't send NQS requests.
     * Default: true
     */
    public var enabled: Bool
    
    /**
     * Define the security of NQS calls.
     * If true it will use "https://".
     * If false it will use "http://".
     * Default: true
     */
    public var httpSecure: Bool
    
    /**
     * Host of the Fastdata service.
     */
    public var host: String
    
    /**
     * NicePeopleAtWork account code that indicates the customer account.
     */
    public var accountCode: String
    
    /**
     * User type value inside your system.
     */
    public var username: String
    
    /**
     * User ID value inside your system.
     */
    public var userType: String
    
    /**
     * User email
     */
    public var userEmail: String
    
    /**
    * If true the plugin will parse hls, cdn and location
    * It might slow performance down.
    * Default: false
    */
    public var parseResource: Bool
    
    /**
     * If defined, resource parse will try to fetch the CDN code from the custom header defined
     * by this property, e.g. "x-cdn-forward"
     */
    public var parseCdnNameHeader: String
    
    /**
     * If true the plugin will query the CDN to retrieve the node name.
     * It might slow performance down.
     * Default: false
     */
    public var parseCdnNode: Bool
    
    /**
     * List of CDN names to parse. This is only used when <parseCdnNode> is enabled.
     * Order is respected when trying to match against a CDN.
     * Default: ["Akamai", "Cloudfront", "Level3", "Fastly", "Highwinds"].
     */
    public var parseCdnNodeList: [String]
    
    /**
     * Flag indicating if the cdn parser should search for new cdn
     */
    public var cdnSwitchHeader: [String]
    
    /**
     Interval of time to search for a new cdn
    */
    public var cdnTTL: TimeInterval
    
    /**
     * List of experiment ids to use with SmartUsers
     */
    public var experimentIds: [String]
    
    /**
     * IP of the viewer/user, e.g. "48.15.16.23".
     */
    public var networkIP: String
    
    /**
     * Name of the internet service provider of the viewer/user.
     */
    public var networkIsp: String
    
    /**
     * See a list of codes in <a href="http://mapi.youbora.com:8081/connectionTypes">http://mapi.youbora.com:8081/connectionTypes</a>.
     */
    public var networkConnectionType: String
    
    /**
     * If the ip address should be abfuscated
     */
    public var userObfuscateIp: Bool
    
    /**
     * Youbora's device code. If specified it will rewrite info gotten from user agent.
     * See a list of codes in <a href="http://mapi.youbora.com:8081/devices">http://mapi.youbora.com:8081/devices</a>.
     */
    public var deviceCode: String
    
    /**
     * Force init enabled
     */
    public var forceInit: Bool
    
    /**
    * What will be displayed as the device model on Youbora (provided by default with android.os.Build.MODEL if not set)
    */
    public var deviceModel: String
    
    /**
     * What will be displayed as the device brand on Youbora (provided by default with android.os.Build.BRAND if not set)
     */
    public var deviceBrand: String
    
    /**
     * What will be displayed as the device type on Youbora (pc, smartphone, stb, tv, etc.)
     */
    public var deviceType: String

    /**
     * What will be displayed as the device name on Youbora (pc, smartphone, stb, tv, etc.)
     */
    public var deviceName: String
    
    /**
     * OS name that will be displayed on Youbora
     */
    public var deviceOsName: String
    
    /**
     * OS version that will be displayed on Youbora (provided by default with android.os.Build.VERSION.RELEASE if not set)
     */
    public var deviceOsVersion: String
    
    /**
     * Option to not send deviceUUID
     */
    public var deviceIsAnonymous: Bool
    
    /**
     * URL/path of the current media resource.
     */
    public var contentResource: String
    
    /**
     * true if the content is Live. no if VOD. Default: nil.
     */
    public var contentIsLive: Bool
    
    /**
     * Title of the media.
     */
    public var contentTitle: String
    
    /**
     * Program title of the media. This could be program name, season, episode, etc.
     */
    public var program: String
    
    /**
     * Duration of the media in seconds.
     */
    public var contentDuration: Double
    
    /**
     * Custom unique code to identify the view.
     */
    public var contentTransactionCode: String
    
    /**
     * Bitrate of the content in bits per second.
     */
    public var contentBitrate: Double

    /**
     * Flag that indicates if the plugin should send total bytes or not
     */
    public var sendTotalBytes: Bool
    
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
    public var contentThroughput: Double
    
    /**
     * Name or value of the current rendition (quality) of the content.
     */
    public var contentRendition: String
    
    /**
     * Codename of the CDN where the content is streaming from.
     * See a list of codes in <a href="http://mapi.youbora.com:8081/cdns">http://mapi.youbora.com:8081/cdns</a>.
     */
    public var contentCdn: String
    
    /**
     * Frames per second of the media being played.
     */
    public var contentFps: Double
    
    /**
     * Dictionary containing mixed extra information about the content like: director, parental rating,
     * device info or the audio channels.
     */
    public var contentMetadata: [String: Any]
    
    /**
     * Dictionary containing the content metrics.
     */
    public var contentMetrics: [String: Any]
    
    /**
     * Dictionary containing the session metrics.
     */
    public var sessionMetrics: [String: Any]
    
    /**
     * Bool containing if seeks should be disabled for life content, only applies if content is live, if it's VOD it gets ignored
     */
    public var contentIsLiveNoSeek: Bool?
    
    /**
     * String containing the content package
     */
    public var contentPackage: String
    
    /**
     * String containing the content saga
     */
    public var contentSaga: String
    
    /**
     * String containing the content show
     */
    public var contentTvShow: String
    
    /**
     * String containing the content season
     */
    public var contentSeason: String
    
    /**
     * String containing the content episode title
     */
    public var contentEpisodeTitle: String
    
    /**
     * String containing the content channel
     */
    public var contentChannel: String

    /**
     * String containing the content id
     */
    public var contentId: String
    
    /**
     * String containing the content imdb id
     */
    public var contentImdbId: String
    
    public override init() {
        self.enabled = true
        self.httpSecure = true
        self.host = "a-fds.youborafds01.com"
        
    }
}
