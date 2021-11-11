//
//  YBYBConstantsTmp.swift
//  YouboraLib
//
//  Created by nice on 17/01/2020.
//  Copyright © 2020 NPAW. All rights reserved.
//

import Foundation

// YBConstants made with class instead of structs in order to support Objc as well

// YBConstants with request params
@objcMembers open class YBConstantsRequest: NSObject {
    static public let accountCode = "accountCode"
    static public let username = "username"
    static public let rendition = "rendition"
    static public let title = "title"
    static public let title2 = "title2"
    static public let live = "live"
    static public let mediaDuration = "mediaDuration"
    static public let mediaResource = "mediaResource"
    static public let parsedResource = "parsedResource"
    static public let transactionCode = "transactionCode"
    static public let properties = "properties"
    static public let cdn = "cdn"
    static public let playerVersion = "playerVersion"
    static public let adBlockerDetected = "adsBlocked"
    static public let param1 = "param1"
    static public let param2 = "param2"
    static public let param3 = "param3"
    static public let param4 = "param4"
    static public let param5 = "param5"
    static public let param6 = "param6"
    static public let param7 = "param7"
    static public let param8 = "param8"
    static public let param9 = "param9"
    static public let param10 = "param10"
    static public let param11 = "param11"
    static public let param12 = "param12"
    static public let param13 = "param13"
    static public let param14 = "param14"
    static public let param15 = "param15"
    static public let param16 = "param16"
    static public let param17 = "param17"
    static public let param18 = "param18"
    static public let param19 = "param19"
    static public let param20 = "param20"
    static public let dimensions = "dimensions"
    static public let pluginVersion = "pluginVersion"
    static public let pluginInfo = "pluginInfo"
    static public let isp = "isp"
    static public let connectionType = "connectionType"
    static public let ip = "ip"
    static public let deviceCode = "deviceCode"
    static public let preloadDuration = "preloadDuration"
    static public let player = "player"
    static public let deviceInfo = "deviceInfo"
    static public let userType = "userType"
    static public let streamingProtocol = "streamingProtocol"
    static public let transportFormat = "transportFormat"
    static public let experiments = "experiments"
    static public let obfuscateIp = "obfuscateIp"
    static public let householdId = "householdId"
    static public let navContext = "navContext"
    static public let anonymousUser = "anonymousUser"
    static public let smartswitchConfigCode = "smartswitchConfigCode"
    static public let smartswitchGroupCode = "smartswitchGroupCode"
    static public let smartswitchContractCode = "smartswitchContractCode"
    static public let nodeHost = "nodeHost"
    static public let nodeType = "nodeType"
    static public let appName = "appName"
    static public let appReleaseVersion = "appReleaseVersion"
    static public let email = "email"
    static public let package = "package"
    static public let saga = "saga"
    static public let tvshow = "tvshow"
    static public let season = "season"
    static public let titleEpisode = "titleEpisode"
    static public let channel = "channel"
    static public let contentId = "contentId"
    static public let imdbID = "imdbID"
    static public let gracenoteID = "gracenoteID"
    static public let contentType = "contentType"
    static public let genre = "genre"
    static public let contentLanguage = "contentLanguage"
    static public let subtitles = "subtitles"
    static public let contractedResolution = "contractedResolution"
    static public let cost = "cost"
    static public let price = "price"
    static public let playbackType = "playbackType"
    static public let drm = "drm"
    static public let videoCodec = "videoCodec"
    static public let audioCodec = "audioCodec"
    static public let codecSettings = "codecSettings"
    static public let codecProfile = "codecProfile"
    static public let containerFormat = "containerFormat"
    static public let adsExpected = "adsExpected"
    static public let deviceUUID = "deviceUUID"
    static public let deviceEDID = "deviceEDID"
    static public let p2pEnabled = "p2pEnabled"
    static public let adTitle = "adTitle"
    static public let playhead = "playhead"
    static public let position = "position"
    static public let adDuration = "adDuration"
    static public let adResource = "adResource"
    static public let adCampaign = "adCampaign"
    static public let adPlayerVersion = "adPlayerVersion"
    static public let adProperties = "adProperties"
    static public let adAdapterVersion = "adAdapterVersion"
    static public let adInsertionType = "adInsertionType"
    static public let extraparam1 = "extraparam1"
    static public let extraparam2 = "extraparam2"
    static public let extraparam3 = "extraparam3"
    static public let extraparam4 = "extraparam4"
    static public let extraparam5 = "extraparam5"
    static public let extraparam6 = "extraparam6"
    static public let extraparam7 = "extraparam7"
    static public let extraparam8 = "extraparam8"
    static public let extraparam9 = "extraparam9"
    static public let extraparam10 = "extraparam10"
    static public let skippable = "skippable"
    static public let breakNumber = "breakNumber"
    static public let adCreativeId = "adCreativeId"
    static public let adProvider = "adProvider"
    static public let system = "system"
    static public let isInfinity = "isInfinity"
    static public let pauseDuration = "pauseDuration"
    static public let joinDuration = "joinDuration"
    static public let seekDuration = "seekDuration"
    static public let bufferDuration = "bufferDuration"
    static public let bitrate = "bitrate"
    static public let adJoinDuration = "adJoinDuration"
    static public let adPlayhead = "adPlayhead"
    static public let adPauseDuration = "adPauseDuration"
    static public let adBitrate = "adBitrate"
    static public let adTotalDuration = "adTotalDuration"
    static public let adUrl = "adUrl"
    static public let givenBreaks = "givenBreaks"
    static public let expectedBreaks = "expectedBreaks"
    static public let expectedPattern = "expectedPattern"
    static public let breaksTime = "breaksTime"
    static public let givenAds = "givenAds"
    static public let expectedAds = "expectedAds"
    static public let adViewedDuration = "adViewedDuration"
    static public let adViewability = "adViewability"
    static public let droppedFrames = "droppedFrames"
    static public let playrate = "playrate"
    static public let latency = "latency"
    static public let packetLoss = "packetLoss"
    static public let packetSent = "packetSent"
    static public let metrics = "metrics"
    static public let language = "language"
    static public let sessionMetrics = "sessionMetrics"
    static public let nodeTypeString = "nodeTypeString"
    static public let adNumber = "adNumber"
    static public let fps = "fps"
    static public let throughput = "throughput"
    static public let p2pDownloadedTraffic = "p2pDownloadedTraffic"
    static public let cdnDownloadedTraffic = "cdnDownloadedTraffic"
    static public let sessions = "sessions"
    static public let uploadTraffic = "uploadTraffic"
    static public let adBufferDuration = "adBufferDuration"
    static public let parentId = "parentId"
    static public let totalBytes = "totalBytes"
    static public let linkedViewId = "linkedViewId"
}

// YBConstants with ad insertion types
@objcMembers open class YBConstantsAdInsertionType: NSObject {
    static public let clientSide = "csai"
    static public let serverSide = "ssai"
}

// YBConstants with stream protocols
@objcMembers open class YBConstantsStreamProtocol: NSObject {
    static public let hds = "HDS"
    static public let hls = "HLS"
    static public let mss = "MSS"
    static public let dash = "DASH"
    static public let rtmp = "RTMP"
    static public let rtp = "RTP"
    static public let rtsp = "RTSP"
}

// YBConstants with transport format
@objcMembers open class YBConstantsTransportFormat: NSObject {
    static public let hlsTs = "HLS-TS"
    static public let hlsFmp4 = "HLS-FMP4"
    static public let hlsCmfv = "HLS-CMF"
}

// Service YBConstants
@objcMembers open class YBConstantsYouboraService: NSObject {
    /** /data service */
    static public let data = "/data"
    /** /init service */
    static public let sInit = "/init"
    /** /start service */
    static public let start = "/start"
    /** /joinTime service */
    static public let join = "/joinTime"
    /** /pause service */
    static public let pause = "/pause"
    /** /resume service */
    static public let resume = "/resume"
    /** /seek service */
    static public let seek = "/seek"
    /** /bufferUnderrun service */
    static public let buffer = "/bufferUnderrun"
    /** /error service */
    static public let error = "/error"
    /** /stop service */
    static public let stop = "/stop"
    /** /ping service */
    static public let ping = "/ping"
    /** /offlineEvents */
    static public let offline = "/offlineEvents"
    /** /adInit service */
    static public let adInit = "/adInit"
    /** /adStart service */
    static public let adStart = "/adStart"
    /** /adJoin service */
    static public let adJoin = "/adJoin"
    /** /adPause service */
    static public let adPause = "/adPause"
    /** /adResume service */
    static public let adResume = "/adResume"
    /** /adBufferUnderrun service */
    static public let adBuffer = "/adBufferUnderrun"
    /** /adStop service */
    static public let adStop = "/adStop"
    /** /adClick service */
    static public let click = "/adClick"
    /** /adError service */
    static public let adError = "/adError"
    /** /adManifest service */
    static public let adManifest = "/adManifest"
    /** /adBreakStart service */
    static public let adBreakStart = "/adBreakStart"
    /** /adBreakStop service */
    static public let adBreakStop = "/adBreakStop"
    /** /adQuartile service */
    static public let adQuartile = "/adQuartile"
}

// Infinity service YBConstants
@objcMembers open class YBConstantsYouboraInfinity: NSObject {
    /** /infinity/session/start service **/
    static public let sessionStart = "/infinity/session/start"
    /** /infinity/session/stop service **/
    static public let sessionStop = "/infinity/session/stop"
    /** /infinity/session/nav service **/
    static public let sessionNav = "/infinity/session/nav"
    /** /infinity/session/event service **/
    static public let sessionEvent = "/infinity/session/event"
    /** /infinity/session/beat service **/
    static public let sessionBeat = "/infinity/session/beat"
    /** /infinity/video/event service **/
    static public let videoEvent = "/infinity/video/event"
}

// Infinity service YBConstants
@objcMembers open class YBConstantsErrorParams: NSObject {
    /** Key to save code in error parameters **/
    static public let code = "errorCode"
    /** Key to save message in error parameters **/
    static public let message = "errorMsg"
    /** Key to save metadata in error parameters **/
    static public let metadata = "errorMetadata"
    /** Key to save the level in error parameters **/
    static public let level = "errorLevel"
}

// Generic YBConstants
@objcMembers open class YBConstants: NSObject {
    /** Key for request success param */
    static public let successListenerOfflineId = "offline_id"
    static public let jsInjectionSessionRootNotification = "jsInjectionSessionRootNotification"
    
    // Lib version
    static public var youboraLibVersion = "6.6.6"
    
    static public let preferencesSessionIdKey = "session_id"
    static public let preferencesContextKey = "context_id"
    static public let preferencesLastActiveKey = "last_active_id"

    // Extracted from https://stackoverflow.com/a/20062141 , they keep it pretty up to date
    // Map with ios version and names
    static public var deviceModels: [String: String] {
        return [
            "iPhone3,3": "iPhone 4",          // (CDMA/Verizon/Sprint)
            "iPhone4,1": "iPhone 4S",         //
            "iPhone5,1": "iPhone 5",          // (model A1428, AT&T/Canada)
            "iPhone5,2": "iPhone 5",          // (model A1429, everything else)
            "iPad3,4": "iPad",              // (4th Generation)
            "iPad2,5": "iPad Mini",         // (Original)
            "iPhone5,3": "iPhone 5c",         // (model A1456, A1532 | GSM)
            "iPhone5,4": "iPhone 5c",         // (model A1507, A1516, A1526 (China), A1529 | Global)
            "iPhone6,1": "iPhone 5s",         // (model A1433, A1533 | GSM)
            "iPhone6,2": "iPhone 5s",         // (model A1457, A1518, A1528 (China), A1530 | Global)
            "iPhone7,1": "iPhone 6 Plus",     //
            "iPhone7,2": "iPhone 6",          //
            "iPhone8,1": "iPhone 6S",         //
            "iPhone8,2": "iPhone 6S Plus",    //
            "iPhone8,4": "iPhone SE",         //
            "iPhone9,1": "iPhone 7",          //
            "iPhone9,3": "iPhone 7",          //
            "iPhone9,2": "iPhone 7 Plus",     //
            "iPhone9,4": "iPhone 7 Plus",     //
            "iPhone10,1": "iPhone 8",          // CDMA
            "iPhone10,4": "iPhone 8",          // GSM
            "iPhone10,2": "iPhone 8 Plus",     // CDMA
            "iPhone10,5": "iPhone 8 Plus",     // GSM
            "iPhone10,3": "iPhone X",          // CDMA
            "iPhone10,6": "iPhone X",          // GSM
            "iPhone11,2": "iPhone XS",         //
            "iPhone11,4": "iPhone XS Max",     //
            "iPhone11,6": "iPhone XS Max",     // China
            "iPhone11,8": "iPhone XR",
            "iPhone12,1": "iPhone 11",         //
            "iPhone12,3": "iPhone 11 Pro",     //
            "iPhone12,5": "iPhone 11 Pro Max", //
            "iPhone12,8": "iPhone SE 2nd Gen",
            "iPhone13,1": "iPhone 12 Mini",
            "iPhone13,2": "iPhone 12",
            "iPhone13,3": "iPhone 12 Pro",
            "iPhone13,4": "iPhone 12 Pro Max",
            "iPhone14,2": "iPhone 13 Pro",
            "iPhone14,3": "iPhone 13 Pro Max",
            "iPhone14,4": "iPhone 13 Mini",
            "iPhone14,5": "iPhone 13",
            "iPad4,1": "iPad Air",          // 5th Generation iPad (iPad Air) - Wifi
            "iPad4,2": "iPad Air",          // 5th Generation iPad (iPad Air) - Cellular
            "iPad4,4": "iPad Mini",         // (2nd Generation iPad Mini - Wifi)
            "iPad4,5": "iPad Mini",         // (2nd Generation iPad Mini - Cellular)
            "iPad4,7": "iPad Mini",         // (3rd Generation iPad Mini - Wifi (model A1599))
            "iPad6,7": "iPad Pro (12.9\")", // iPad Pro 12.9 inches - (model A1584)
            "iPad6,8": "iPad Pro (12.9\")", // iPad Pro 12.9 inches - (model A1652)
            "iPad6,3": "iPad Pro (9.7\")",  // iPad Pro 9.7 inches - (model A1673)
            "iPad6,4": "iPad Pro (9.7\")",  // iPad Pro 9.7 inches - (models A1674 and A1675)
            "AppleTV5,3": "Apple TV 4G",       // AppleTV 4G
            "AppleTV6,2": "Apple TV 4K"        // AppleTV 4K
        ]
    }
}
