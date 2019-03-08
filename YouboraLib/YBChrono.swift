//
//  YBChrono.swift
//  YouboraLib iOS
//
//  Created by Enrique Alfonso Burillo on 08/03/2019.
//  Copyright © 2019 NPAW. All rights reserved.
//

import Foundation

/**
 * Utility class that provides chronometer like functionality.
 * Used to calculate the elapsed time between <start> and <stop> calls.
 */
class YBChrono: NSObject, NSCopying {
    /// ---------------------------------
    /// @name Public properties
    /// ---------------------------------
    
    /// Start time
    @objc public var startTime: Int64 = 0
    @objc public var stopTime: Int64 = 0
    @objc public var offset: Int64 = 0
    
    /// ---------------------------------
    /// @name Static properties
    /// ---------------------------------
    /**
     * Returns the current time in milliseconds
     * @returns the current time in milliseconds
     */
    //+ (long long) getNow;
    @objc public var now: Int64 {
        get {
            return Int64(round(Date().timeIntervalSince1970 * 1000))
        }
    }
    
    /// ---------------------------------
    /// @name Public methods
    /// ---------------------------------
    /**
     * Returns the time between start and the last stop in ms. Returns -1 if start wasn't called.
     * @param stop If true, it will force a stop if it wasn't sent before.
     * @return Time lapse in ms or -1 if start was not called.
     */
    @objc func getDeltaTime(_ stop: Bool) -> Int64 {
        if (self.startTime <= 0) {
            return -1
        }
        
        if (self.stopTime <= 0) {
            return stop ? self.stop() : YBChrono().now - self.startTime + self.offset
        } else {
            return self.stopTime - self.startTime + self.offset
        }
    }
    
    /**
     * Same as calling <getDeltaTime:> with stop = false
     * @returns the elapsed time in ms since the start call.
     */
    @objc func getDeltaTime() -> Int64 {
        return getDeltaTime(true)
    }
    
    /**
     * Starts timing
     */
    @objc func start() -> Void {
        self.startTime = YBChrono().now
        self.stopTime = 0
    }
    
    /**
     * Stop the timer and returns the difference since it <start>ed
     * @returns the difference since it <start>ed
     */
    @objc func stop() -> Int64 {
        self.stopTime = YBChrono().now
        return getDeltaTime(false)
    }
    
    /**
     * Reset the Chrono to its initial state.
     */
    @objc func reset() -> Void {
        self.startTime = 0
        self.stopTime = 0
        self.offset = 0
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let c = YBChrono()
        c.startTime = self.startTime
        c.stopTime = self.stopTime
        c.offset = self.offset
        return c
    }

}
