//
//  YBYBConstantsTmp.swift
//  YouboraLib
//
//  Created by nice on 17/01/2020.
//  Copyright © 2020 NPAW. All rights reserved.
//

import Foundation

// YBConstants made with class instead of structs in order to support Objc as well

// YBConstants with stream protocols
@objcMembers open class YBConstantsStreamProtocol: NSObject {
    static public let hds = "HDS"
    static public let hls = "HLS"
    static public let mss = "MSS"
    static public let dash = "DASH"
    static public let rtmp = "RTMP"
    static public let rtp = "RTP"
    static public let rtsp = "RTSP"
    static public let hlsTs = "HLS-TS"
    static public let hlsFmp4 = "HLS-FMP4"
}

// Service YBConstants
@objcMembers open class YBConstantsYouboraService: NSObject {
    /** /data service */
    static public let data = "/data"
    /** /init service */
    static public let `init` = "/init"
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

// Generic YBConstants
@objcMembers open class YBConstants: NSObject {
    /** Key for request success param */
    static public let successListenerOfflineId = "offline_id"
    static public let jsInjectionSessionRootNotification = "jsInjectionSessionRootNotification"
    // Lib version
    static public var youboraLibVersion: String {
        guard let path = Bundle(for: self).url(forResource: "Info", withExtension: "plist"),
            let values = NSDictionary(contentsOf: path),
            let version = values["CFBundleShortVersionString"] as? String else {
                return ""
        }

        return version
    }

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
