//
//  YBPlaybackFlags.swift
//  YouboraLib
//
//  Created by Enrique Alfonso Burillo on 23/10/2019.
//  Copyright © 2019 NPAW. All rights reserved.
//

import Foundation

@objcMembers open class YBPlaybackFlags: NSObject {
    /// ---------------------------------
    /// @name Public properties
    /// ---------------------------------

    /// Preloading
    public var preloading = false
    /// Start is sent
    public var started = false
    /// Join is sent
    public var joined = false
    /// Paused
    public var paused = false
    /// Seeking
    public var seeking = false
    /// Buffering
    public var buffering = false
    /// Ended
    public var ended = false
    /// Stopped
    public var stopped = false

    /// Ads only

    ///Ad Manifest file requested
    public var adManifestRequested = false //This one doesn't get reset ever, once it changes to true it's kep that way the whole view
    /// Only used for ads
    public var adInitiated = false
    /// Ad break started
    public var adBreakStarted = false //This doesn't get reset since an ad may have finished but not it's break

    /// ---------------------------------
    /// @name Public methods
    /// ---------------------------------

    public func reset() {
        self.preloading = false
        self.started = false
        self.joined = false
        self.paused = false
        self.seeking = false
        self.buffering = false

        self.adInitiated = false
    }

}
