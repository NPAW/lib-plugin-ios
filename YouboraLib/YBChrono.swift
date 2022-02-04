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
@objc open class YBChrono: NSObject, NSCopying {
    var value: Any?
    /// ---------------------------------
    /// @name Public properties
    /// ---------------------------------

    /// Start time
    @objc public var startTime: Int64 = 0
    @objc public var stopTime: Int64 = 0
    @objc public var pauseTime: Int64 = 0
    @objc public var offset: Int64 = 0

    /// ---------------------------------
    /// @name Static properties
    /// ---------------------------------
    /**
     * Returns the current time in milliseconds
     * @returns the current time in milliseconds
     */
    @objc public var now: Int64 {
        return Int64(round(Date().timeIntervalSince1970 * 1000))
    }

    /// ---------------------------------
    /// @name Public methods
    /// ---------------------------------
    /**
     * Returns the time between start and the last stop in ms. Returns -1 if start wasn't called.
     * @param stop If true, it will force a stop if it wasn't sent before.
     * @return Time lapse in ms or -1 if start was not called.
     */
    @objc public func getDeltaTime(_ stop: Bool) -> Int64 {
        let now = YBChrono().now
        if self.startTime == 0 {
            return -1
        }
        
        if stop && self.stopTime == 0 {
            self.stop()
        }
        
        let tempOffset = self.pauseTime != 0 ? now - self.pauseTime : 0
        let tempStop = self.stopTime != 0 ? self.stopTime : now
        
        return self.offset - tempOffset + (tempStop - self.startTime)
    }

    /**
     * Same as calling <getDeltaTime:> with stop = false
     * @returns the elapsed time in ms since the start call.
     */
    //TODO: Remove when there is no trace of objc
    @objc public func getDeltaTime() -> Int64 {
        return getDeltaTime(true)
    }

    /**
     * Starts timing
     */
    @objc public func start() {
        self.startTime = YBChrono().now
        self.stopTime = 0
        self.offset = 0
    }
    
    /**
     * Pauses timing
     */
    @objc public func pause() {
        self.pauseTime = YBChrono().now
    }
    
    /**
     * Resumes timing
     */
    @objc public func resume() {
        self.offset -= YBChrono().now - pauseTime
        self.pauseTime = 0
    }

    /**
     * Stop the timer and returns the difference since it <start>ed
     * @returns the difference since it <start>ed
     */
    @objc @discardableResult public func stop() -> Int64 {
        if pauseTime != 0 {
            resume()
        }
        self.stopTime = YBChrono().now
        return getDeltaTime(false)
    }

    /**
     * Reset the Chrono to its initial state.
     */
    @objc public func reset() {
        self.startTime = 0
        self.stopTime = 0
        self.pauseTime = 0
        self.offset = 0
    }

    @objc public func copy(with zone: NSZone? = nil) -> Any {
        let c = YBChrono()
        c.startTime = self.startTime
        c.stopTime = self.stopTime
        c.pauseTime = self.pauseTime
        c.offset = self.offset
        return c
    }

}
