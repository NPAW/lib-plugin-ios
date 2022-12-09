//
//  YBP2PStats.swift
//  YouboraLib
//
//  Created by Elisabet Massó on 30/11/22.
//  Copyright © 2022 NPAW. All rights reserved.
//

import Foundation

@objc open class YBP2PStats: NSObject, Codable {
    
    // Settings
    var downloadEnabled: Bool = false
    var uploadEnabled: Bool = false
    // Upload
    var uploadedBytes: Int? = nil
    var uploadedSegments: Int? = nil
    // Upload failures
    var discardedUploadedChunks: Int? = nil
    var discardedUploadedBytes: Int? = nil
    // Download
    var downloadedBytes: Int? = nil
    var downloadedSegments: Int? = nil
    // Download failures
    var discardedDownloadedBytes: Int? = nil
    var failedRequests: YBP2PFailedRequests = YBP2PFailedRequests()
    // Peer stats
//    var peerId: String? = nil // TODO: Add this
    var activePeers: Int? = nil
    var totalPeers: Int? = nil
    var downloadAvgBw: Int? = nil
    var downloadMillis: Int = 0
    var lastSecondsDownloadTraffic: Int = 0
    var lastSecondsUploadTraffic: Int = 0
    
}
