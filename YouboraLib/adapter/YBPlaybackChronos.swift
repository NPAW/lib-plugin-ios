//
//  YBPlaybackChronos.swift
//  YouboraLib
//
//  Created by Enrique Alfonso Burillo on 07/06/2019.
//  Copyright © 2019 NPAW. All rights reserved.
//

import Foundation

/**
 * This class contains all the <YBChrono>s related to view status.
 * Chronos measure time lapses between events.
 * ie: between start and join, between seek-begin and seek-end, etc.
 * Each plugin will have an instance of this class.
 */
open class YBPlaybackChronos : NSObject {
    /** Chrono between start and joinTime. */
    @objc public var join  = YBChrono()
    
    /** Chrono between seek-begin and seek-end. */
    @objc public var seek  = YBChrono()
    
    /** Chrono between pause and resume. */
    @objc public var pause  = YBChrono()
    
    /** Chrono between buffer-begin and buffer-end. */
    @objc public var buffer  = YBChrono()
    
    /** Chrono for the totality of the view. */
    @objc public var total  = YBChrono()
    
    /** Chrono for the Ad Init duration */
    @objc public var adInit  = YBChrono()
    
    /// ---------------------------------
    /// @name Public methods
    /// ---------------------------------
    
    /**
     * Reset chronos
     */
    @objc public func reset() {
        self.join = YBChrono()
        self.seek = YBChrono()
        self.pause = YBChrono()
        self.buffer = YBChrono()
        self.total = YBChrono()
        
        self.adInit = YBChrono()
    }
}

