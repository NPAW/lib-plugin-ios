//
//  YBBalancerStats.swift
//  YouboraLib
//
//  Created by Elisabet Massó on 30/11/22.
//  Copyright © 2022 NPAW. All rights reserved.
//

import Foundation

@objc open class YBBalancerStats: NSObject, Codable {
    
    var profileName: String? = nil
    internal var cdn: YBCDNStats? = nil
    internal var p2p: YBP2PStats? = nil
    var totalDownloadedBytes: Int? = nil
    var lastSecondsTraffic: Int? = nil
    var lastSeconds: Double? = nil
    var segmentDuration: Int? = nil
    
    var cdnStats: YBCDNStats? {
        get { return cdn }
        set { cdn = newValue }
    }
    var p2pStats: YBP2PStats? {
        get { return p2p }
        set { p2p = newValue }
    }
    
}
