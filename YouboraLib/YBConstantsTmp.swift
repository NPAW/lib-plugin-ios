//
//  YBConstantsTmp.swift
//  YouboraLib
//
//  Created by nice on 17/01/2020.
//  Copyright © 2020 NPAW. All rights reserved.
//

import Foundation

// Constants made with class instead of structs to support Objc as well

@objcMembers class ConstantsStreamProtocol: NSObject {
    static let hds = "HDS"
    static let hls = "HLS"
    static let mss = "MSS"
    static let dash = "DASH"
    static let rtmp = "RTMP"
    static let rtp = "RTP"
    static let rtsp = "RTSP"
    static let hlsTs = "HLS-TS"
    static let hlsFmp4 = "HLS-FMP4"
}

@objcMembers class ConstantsYouboraService: NSObject {
    static let data = "/data"
    static let `init` = "/init"
    static let start = "/start"
    static let join = "/joinTime"
    static let pause = "/pause"
    static let resume = "/resume"
    static let seek = "/seek"
    static let buffer = "/bufferUnderrun"
    static let error = "/error"
    static let stop = "/stop"
    static let ping = "/ping"
    static let offline = "/offlineEvents"
    static let adInit = "/adInit"
    static let adStart = "/adStart"
    static let adJoin = "/adJoin"
    static let adPause = "/adPause"
    static let adResume = "/adResume"
    static let adBuffer = "/adBufferUnderrun"
    static let adStop = "/adStop"
    static let click = "/adClick"
    static let adError = "/adError"
    static let adManifest = "/adManifest"
    static let adBreakStart = "/adBreakStart"
    static let adBreakStop = "/adBreakStop"
    static let adQuartile = "/adQuartile"
}

@objcMembers class ConstantsYouboraInfinity: NSObject {
    static let sessionStart = "/infinity/session/start"
    static let sessionStop = "/infinity/session/stop"
    static let sessionNav = "/infinity/session/nav"
    static let sessionEvent = "/infinity/session/event"
    static let sessionBeat = "/infinity/session/beat"
    static let videoEvent = "/infinity/video/event"
}

@objcMembers class Constants: NSObject {
    static let successListenerOfflineId = "offline_id"
}

