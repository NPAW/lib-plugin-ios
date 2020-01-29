//
//  YBTimer.swift
//  YouboraLib
//
//  Created by nice on 22/01/2020.
//  Copyright © 2020 NPAW. All rights reserved.
//

import Foundation

/**
* Type of the success block
*
*  - timer: (YBTimer *) The <YBTimer> from where the callback is being invoked.
*  - diffTime: (long) the time difference between the previous call.
*/
typealias SwiftTimerCallback = (_ timer: YBSwiftTimer, _ diffTime: Int64) -> Void

/**
* An Utility class that provides timed events in a defined time interval.
*/
@objcMembers open class YBSwiftTimer: NSObject {

    /**
     * The period at which to execute the callbacks.
     */
    var interval: Double

    /**
     * Whether the Timer is running or not.
     */
    private (set) var isRunning: Bool

    /**
     * Chrono to inform the callback how much time has passed since the previous call.
     */
    private (set) var chrono: YBChrono

    var callbacks: [SwiftTimerCallback]

    /// Timer to control the callbacks
    private var timer: Timer?

    /**
    * Init
    * Same as calling <initWithCallback:andInterval:> with an interval of 5000
    * @param callback the block to execute every <interval> milliseconds
    * @returns an instance of YBTimer
    */
    convenience init(callback: @escaping SwiftTimerCallback) {
        self.init(callback: callback, andInterval: 5000)
    }

    /**
    * Init
    * @param callback the block to execute every <interval> milliseconds
    * @param intervalMillis interval of the timer
    * @returns an instance of YBTimer
    */
    init(callback: @escaping SwiftTimerCallback, andInterval intervalMillis: Double) {
        self.chrono = YBChrono()
        self.callbacks = [callback]
        self.isRunning = false
        self.interval = intervalMillis
    }

    /**
    * Adds a new callback to fire on the timer
    * @param callback callback that must conform to type TimerCallback
    */

    func addTimerCallback(_ callback: @escaping SwiftTimerCallback) {
        callbacks.append(callback)
    }

    /**
     * Starts the timer.
     */
    func start() {
        if !self.isRunning {
            self.isRunning = true
            self.scheduleTimer()
        }
    }

    /**
     * Stops the timer.
     */
    func stop() {
        if self.isRunning {
            self.isRunning = false
            self.timer?.invalidate()
            self.timer = nil
        }
    }

    private func scheduleTimer() {
        if Thread.isMainThread {
            if self.isRunning {
                self.chrono.start()
                self.timer = Timer.scheduledTimer(timeInterval: self.interval/1000, target: self, selector: #selector(performCallback), userInfo: nil, repeats: false)
            }
        } else {
            DispatchQueue.main.async {
                self.scheduleTimer()
            }
        }
    }

    @objc private func performCallback() {
        if self.callbacks.count > 0 {
            let elapsedTime = self.chrono.stop()
            self.callbacks.forEach { callback in
               callback(self, elapsedTime)
            }
        }
        self.scheduleTimer()
    }
}
