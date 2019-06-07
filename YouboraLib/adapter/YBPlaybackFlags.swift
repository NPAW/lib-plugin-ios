//
//  YBPlaybackFlags.swift
//  YouboraLib
//
//  Created by Enrique Alfonso Burillo on 07/06/2019.
//  Copyright © 2019 NPAW. All rights reserved.
//

import Foundation

/**
 * This class contains all the flags related to view status.
 * Each <Plugin> will have an instance of this class.
 */
open class YBPlaybackFlags: NSObject {
    
    /// ---------------------------------
    /// @name Public properties
    /// ---------------------------------
    
    /// Preloading
    @objc public var preloading = false
    
    /// Start is sent
    @objc public var started = false
    
    /// Join is sent
    @objc public var joined = false
    
    /// Paused
    @objc public var paused = false
    
    /// Seeking
    @objc public var seeking = false
    
    /// Buffering
    @objc public var buffering = false
    
    /// Ended
    @objc public var ended = false
    
    /// Stopped
    @objc public var stopped = false
    
    /// Only used for ads
    @objc public var adInitiated = false
    
    /// ---------------------------------
    /// @name Public methods
    /// ---------------------------------
    @objc public func reset() {
        self.preloading = false
        self.started = false
        self.joined = false
        self.paused = false
        self.seeking = false
        self.buffering = false
        
        self.adInitiated = false
    }
}
