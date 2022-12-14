//
//  YBCDNStats.swift
//  YouboraLib
//
//  Created by Elisabet Massó on 30/11/22.
//  Copyright © 2022 NPAW. All rights reserved.
//

import Foundation

@objc open class YBCDNStats: NSObject, Codable {
    
    var activeSwitching: String? = nil
    var averageBw: Int = 0
    var cdns: [YBCDNCompressed]? = nil
    var failures: Int = 0
//    var fallback: String? = nil // TODO: Add this
//    var mode: String? = nil // TODO: Remove this
    var responseUUID: String? = nil
    var retries: Int = 0
    var totalDownloadedBytes: Int = 0
    var totalDownloadedChunks: Int = 0
    var totalLastsecondsTraffic: Int = 0
    
}
