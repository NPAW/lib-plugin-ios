//
//  YBConstantsTmp.swift
//  YouboraLib
//
//  Created by nice on 17/01/2020.
//  Copyright © 2020 NPAW. All rights reserved.
//

import Foundation

// Constants made with class instead of structs in order to support Objc as well

@objcMembers open class ConstantsStreamProtocol: NSObject {
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

@objcMembers open class ConstantsYouboraService: NSObject {
    static public let data = "/data"
    static public let `init` = "/init"
    static public let start = "/start"
    static public let join = "/joinTime"
    static public let pause = "/pause"
    static public let resume = "/resume"
    static public let seek = "/seek"
    static public let buffer = "/bufferUnderrun"
    static public let error = "/error"
    static public let stop = "/stop"
    static public let ping = "/ping"
    static public let offline = "/offlineEvents"
    static public let adInit = "/adInit"
    static public let adStart = "/adStart"
    static public let adJoin = "/adJoin"
    static public let adPause = "/adPause"
    static public let adResume = "/adResume"
    static public let adBuffer = "/adBufferUnderrun"
    static public let adStop = "/adStop"
    static public let click = "/adClick"
    static public let adError = "/adError"
    static public let adManifest = "/adManifest"
    static public let adBreakStart = "/adBreakStart"
    static public let adBreakStop = "/adBreakStop"
    static public let adQuartile = "/adQuartile"
}

@objcMembers open class ConstantsYouboraInfinity: NSObject {
    static public let sessionStart = "/infinity/session/start"
    static public let sessionStop = "/infinity/session/stop"
    static public let sessionNav = "/infinity/session/nav"
    static public let sessionEvent = "/infinity/session/event"
    static public let sessionBeat = "/infinity/session/beat"
    static public let videoEvent = "/infinity/video/event"
}

@objcMembers open class Constants: NSObject {
    static public let successListenerOfflineId = "offline_id"
    static public var youboraLibVersion: String {
        guard let path = Bundle(for: self).url(forResource: "Info", withExtension: "plist"),
            let values = NSDictionary(contentsOf: path),
            let version = values["CFBundleShortVersionString"] as? String else {
                return ""
        }

        return version
    }
    static public var deviceModels: [String: String] {
        return [
            "iPhone3,3" : "iPhone 4",          // (CDMA/Verizon/Sprint)
            "iPhone4,1" : "iPhone 4S",         //
            "iPhone5,1" : "iPhone 5",          // (model A1428, AT&T/Canada)
            "iPhone5,2" : "iPhone 5",          // (model A1429, everything else)
            "iPad3,4"   : "iPad",              // (4th Generation)
            "iPad2,5"   : "iPad Mini",         // (Original)
            "iPhone5,3" : "iPhone 5c",         // (model A1456, A1532 | GSM)
            "iPhone5,4" : "iPhone 5c",         // (model A1507, A1516, A1526 (China), A1529 | Global)
            "iPhone6,1" : "iPhone 5s",         // (model A1433, A1533 | GSM)
            "iPhone6,2" : "iPhone 5s",         // (model A1457, A1518, A1528 (China), A1530 | Global)
            "iPhone7,1" : "iPhone 6 Plus",     //
            "iPhone7,2" : "iPhone 6",          //
            "iPhone8,1" : "iPhone 6S",         //
            "iPhone8,2" : "iPhone 6S Plus",    //
            "iPhone8,4" : "iPhone SE",         //
            "iPhone9,1" : "iPhone 7",          //
            "iPhone9,3" : "iPhone 7",          //
            "iPhone9,2" : "iPhone 7 Plus",     //
            "iPhone9,4" : "iPhone 7 Plus",     //
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
            
            "iPad4,1"   : "iPad Air",          // 5th Generation iPad (iPad Air) - Wifi
            "iPad4,2"   : "iPad Air",          // 5th Generation iPad (iPad Air) - Cellular
            "iPad4,4"   : "iPad Mini",         // (2nd Generation iPad Mini - Wifi)
            "iPad4,5"   : "iPad Mini",         // (2nd Generation iPad Mini - Cellular)
            "iPad4,7"   : "iPad Mini",         // (3rd Generation iPad Mini - Wifi (model A1599))
            "iPad6,7"   : "iPad Pro (12.9\")", // iPad Pro 12.9 inches - (model A1584)
            "iPad6,8"   : "iPad Pro (12.9\")", // iPad Pro 12.9 inches - (model A1652)
            "iPad6,3"   : "iPad Pro (9.7\")",  // iPad Pro 9.7 inches - (model A1673)
            "iPad6,4"   : "iPad Pro (9.7\")",  // iPad Pro 9.7 inches - (models A1674 and A1675)
            
            "AppleTV5,3": "Apple TV 4G",       // AppleTV 4G
            "AppleTV6,2": "Apple TV 4K"        // AppleTV 4K
        ];
    }
}
