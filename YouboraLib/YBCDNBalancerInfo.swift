//
//  YBCDNBalancerInfo.swift
//  YouboraLib
//
//  Created by Elisabet Massó on 30/11/22.
//  Copyright © 2022 NPAW. All rights reserved.
//

import Foundation

/// This class provides p2p and cdn network traffic information for
/// NPAW solution.
@objcMembers open class YBCDNBalancerInfo: NSObject {
    
    var lastBalancerStats: YBBalancerStats? = nil
    var balancerStats: YBBalancerStats? = nil
    
    /// Returns CDN traffic bytes using NPAW balancer. Otherwise nil.
    /// - Returns: CDN traffic bytes or nil.
    public func getCdnTraffic() -> NSNumber? {
        guard let totalDownloadedBytes = balancerStats?.cdnStats?.totalDownloadedBytes else { return nil }
        return NSNumber(value: totalDownloadedBytes)

    }
    
    /// Returns CDN traffic when using multiple cdns, available only for NPAW solution. Otherwise nil.
    /// - Returns: CDN traffic or nil.
    public func getMultiCdnInfo() -> String? {
        guard let balancerStats = balancerStats, let p2pStats = balancerStats.p2pStats, let cdnStats = balancerStats.cdnStats else {
            return nil
        }
        var multiCdnInfo = [String : Any]()
        
        var p2pInfo = [String : Any]()
        p2pInfo["downloaded_bytes"] = p2pStats.downloadedBytes
        p2pInfo["uploaded_bytes"] = p2pStats.uploadedBytes
        p2pInfo["downloaded_chunks"] = p2pStats.downloadedSegments
        p2pInfo["uploaded_chunks"] = p2pStats.uploadedSegments
        p2pInfo["errors"] = p2pStats.failedRequests.total
        p2pInfo["missed_downloaded_chunks"] = p2pStats.failedRequests.absent
        p2pInfo["timeout_errors"] = p2pStats.failedRequests.timeout
        p2pInfo["other_errors"] = p2pStats.failedRequests.error
        p2pInfo["late_uploaded_chunks"] = p2pStats.discardedUploadedChunks
        p2pInfo["late_uploaded_bytes"] = p2pStats.discardedUploadedBytes
        p2pInfo["late_downloaded_bytes"] = p2pStats.discardedDownloadedBytes
        p2pInfo["time"] = p2pStats.downloadMillis
        p2pInfo["active_peers"] = p2pStats.activePeers
        p2pInfo["peers"] = p2pStats.totalPeers
        multiCdnInfo["P2P"] = p2pInfo
        
        var cdnInfo = [String : Any]()
        for cdn in cdnStats.cdns ?? [] {
            cdnInfo["downloaded_bytes"] = cdn.bytes
            cdnInfo["downloaded_chunks"] = cdn.chunks
            cdnInfo["errors"] = cdn.failures
            cdnInfo["time"] = cdn.downloadMillis
            if let cdnName = cdn.name {
                multiCdnInfo[cdnName] = cdnInfo
            }
        }
        
        return YBYouboraUtils.stringifyDictionary(multiCdnInfo)
    }
    
    public func getProfileName() -> String? {
        return balancerStats?.profileName
    }
    
    public func getBalancerVersion() -> String? {
        return balancerStats?.version
    }
    
    public func getCdnPingInfo() -> [String : Any]? {
        guard let balancerStats = balancerStats, let p2pStats = balancerStats.p2pStats, let cdnStats = balancerStats.cdnStats, let cdns = cdnStats.cdns else {
            return nil
        }
        
        var dict = [String : Any]()
        
        for (index, cdn) in cdns.enumerated() {
            if let cdnName = cdn.name {
                dict[cdnName] = updateCDNInfoFor(cdn, atIndex: index)
            }
        }
        
        var p2pInfo = [String : Any]()
        
        let dBytes = (p2pStats.downloadedBytes ?? 0) - (lastBalancerStats?.p2pStats?.downloadedBytes ?? 0)
        if dBytes > 0 {
            p2pInfo["downloaded_bytes"] = dBytes
        }
        let uBytes = (p2pStats.uploadedBytes ?? 0) - (lastBalancerStats?.p2pStats?.uploadedBytes ?? 0)
        if uBytes > 0 {
            p2pInfo["uploaded_bytes"] = uBytes
        }
        let dSegments = (p2pStats.downloadedSegments ?? 0) - (lastBalancerStats?.p2pStats?.downloadedSegments ?? 0)
        if dSegments > 0 {
            p2pInfo["downloaded_chunks"] = dSegments
        }
        let uSegments = (p2pStats.uploadedSegments ?? 0) - (lastBalancerStats?.p2pStats?.uploadedSegments ?? 0)
        if uSegments > 0 {
            p2pInfo["uploaded_chunks"] = uSegments
        }
        let failedRequests = p2pStats.failedRequests.total - (lastBalancerStats?.p2pStats?.failedRequests.total ?? 0)
        if failedRequests > 0 {
            p2pInfo["errors"] = failedRequests
        }
        let absent = p2pStats.failedRequests.absent - (lastBalancerStats?.p2pStats?.failedRequests.absent ?? 0)
        if absent > 0 {
            p2pInfo["missed_downloaded_chunks"] = absent
        }
        let timeout = p2pStats.failedRequests.timeout - (lastBalancerStats?.p2pStats?.failedRequests.timeout ?? 0)
        if timeout > 0 {
            p2pInfo["timeout_errors"] = timeout
        }
        let error = p2pStats.failedRequests.error - (lastBalancerStats?.p2pStats?.failedRequests.error ?? 0)
        if error > 0 {
            p2pInfo["other_errors"] = error
        }
        let discUSegments = (p2pStats.discardedUploadedChunks ?? 0) - (lastBalancerStats?.p2pStats?.discardedUploadedChunks ?? 0)
        if discUSegments > 0 {
            p2pInfo["late_uploaded_chunks"] = discUSegments
        }
        let discUBytes = (p2pStats.discardedUploadedBytes ?? 0) - (lastBalancerStats?.p2pStats?.discardedUploadedBytes ?? 0)
        if discUBytes > 0 {
            p2pInfo["late_uploaded_bytes"] = discUBytes
        }
        let discDBytes = (p2pStats.discardedDownloadedBytes ?? 0) - (lastBalancerStats?.p2pStats?.discardedDownloadedBytes ?? 0)
        if discDBytes > 0 {
            p2pInfo["late_downloaded_bytes"] = discDBytes
        }
        let dMillis = p2pStats.downloadMillis - (lastBalancerStats?.p2pStats?.downloadMillis ?? 0)
        if dMillis > 0 {
            p2pInfo["time"] = dMillis
        }
        let aPeers = (p2pStats.activePeers ?? 0) - (lastBalancerStats?.p2pStats?.activePeers ?? 0)
        if aPeers > 0 {
            p2pInfo["active_peers"] = aPeers
        }
        if let totalPeers = p2pStats.totalPeers, totalPeers > 0 {
            p2pInfo["peers"] = totalPeers
        }
        if !p2pInfo.isEmpty {
            dict["P2P"] = p2pInfo
        }
        
        return dict
        
    }
    
    private func updateCDNInfoFor(_ cdn: YBCDNCompressed, atIndex index: Int) -> [String: Any] {
        var cdnInfo = [String: Any]()
        cdnInfo["provider"] = cdn.name
//        cdnInfo["is_active"] = cdn.active // TODO: Add `active` variable
        
        let prevCdn = lastBalancerStats?.cdnStats?.cdns?[index]

        let bytes = (cdn.bytes ?? 0) - (prevCdn?.bytes ?? 0)
        if bytes > 0 {
            cdnInfo["downloaded_bytes"] = bytes
        }
        let chunks = (cdn.chunks ?? 0) - (prevCdn?.chunks ?? 0)
        if chunks > 0 {
            cdnInfo["downloaded_chunks"] = chunks
        }
        let failures = cdn.failures - (prevCdn?.failures ?? 0)
        if failures > 0 {
            cdnInfo["errors"] = failures
        }
        let downloadMillis = (cdn.downloadMillis ?? 0) - (prevCdn?.downloadMillis ?? 0)
        if downloadMillis > 0 {
            cdnInfo["time"] = downloadMillis
        }
        return cdnInfo
    }
    
    /// Returns segment duration using NPAW balancer API. Otherwise nil.
    /// - Returns: Segment duration or nil.
    public func getSegmentDuration() -> NSNumber? {
        guard let segmentDuration = balancerStats?.segmentDuration else { return nil }
        return NSNumber(value: segmentDuration)
    }
    
    /// Returns CDN balancer API response id, available only for NPAW solution. Otherwise nil.
    /// - Returns: CDN balancer API response id or nil.
    public func getBalancerResponseId() -> String? {
        return balancerStats?.cdnStats?.responseUUID
    }
    
    /// Returns P2P traffic bytes using NPAW balancer. Otherwise nil.
    /// - Returns: P2P traffic bytes or nil.
    public func getP2PTraffic() -> NSNumber? {
        guard let downloadedBytes = balancerStats?.p2pStats?.downloadedBytes else { return nil }
        return NSNumber(value: downloadedBytes)

    }
    
    /// Returns P2P traffic sent in bytes, using NPAW balancer. Otherwise nil.
    /// - Returns: P2P traffic sent in bytes or nil.
    public func getUploadTraffic() -> NSNumber? {
        guard let uploadedBytes = balancerStats?.p2pStats?.uploadedBytes else { return nil }
        return NSNumber(value: uploadedBytes)
    }
    
    /// Returns if P2P is enabled, using NPAW balancer.
    /// - Returns: If P2P is enabled.
    public func getIsP2PEnabled() -> NSValue? {
        guard let downloadEnabled = balancerStats?.p2pStats?.downloadEnabled else { return nil }
        return NSNumber(value: downloadEnabled)
    }
    
    /// Reads local storage to update balancer metrics.
    public func updateBalancerStats() {
        let tmp = YBInfinityLocalManager.getBalancerStats()
        if let tmp = tmp {
            do {
                let localBalancerStats = try YBYouboraUtils.dictionaryToObject(tmp, object: YBBalancerStats.self)
                lastBalancerStats = balancerStats
                balancerStats = localBalancerStats
            } catch {
                YBSwiftLog.error(error.localizedDescription)
            }            
        }
    }
    
}
