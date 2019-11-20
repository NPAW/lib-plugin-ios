//
//  ConstantsSwift.swift
//  YouboraLib
//
//  Created by Enrique Alfonso Burillo on 19/11/2019.
//  Copyright © 2019 NPAW. All rights reserved.
//

import Foundation

public struct Youbora{
    let serviceData = "/data"
    let serviceInit = "/init"
    let serviceStart = "/start"
    let serviceJoin = "/joinTime"
    let servicePause = "/pause"
    let serviceResume = "/resume"
    let serviceSeek = "/seek"
    let serviceBuffer = "/bufferUnderrun"
    let serviceError = "/error"
    let serviceStop = "/stop"
    let servicePing = "/ping"
    let serviceAdInit = "/adInit"
    let serviceAdStart = "/adStart"
    let serviceAdJoin = "/adJoin"
    let serviceAdPause = "/adPause"
    let serviceAdResume = "/adResume"
    let serviceAdBuffer = "/adBufferUnderrun"
    let serviceAdStop = "/adStop"
    let serviceClick = "/adClick"
    let serviceAdError = "/adError"
    let serviceAdManifest = "/adManifest"
    let serviceAdBreakStart = "/adBreakStart"
    let serviceAdBreakStop = "/adBreakStop"
    let serviceAdQUartile = "/adQuartile"
    
    /** Infinity **/
    
    let serviceSessionStart = "/infinity/session/start"
    let serviceSessionStop = "/infinity/session/stop"
    let serviceSessionNav = "/infinity/session/nav"
    let serviceSessionEvent = "/infinity/session/event"
    let serviceSessionBeat = "/infinity/session/beat"
    let serviceSessionVideoEvent = "/infinity/video/event"
    
    // Request success constant
    let successListenerOfflineId = "offline_id"
    
    //TODO: HOW TO THIS IN SWIFT
    /*
     #define MACRO_NAME(f) #f
     #define MACRO_VALUE(f)  MACRO_NAME(f)

     #ifdef YOUBORALIB_VERSION
     NSString * const YouboraLibVersion = @MACRO_VALUE(YOUBORALIB_VERSION);
     #endif
     */
}
