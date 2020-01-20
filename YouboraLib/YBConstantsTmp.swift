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
}
