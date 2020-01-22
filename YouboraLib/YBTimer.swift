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
typealias TimerCallback = (_ timer: YBSwiftTimer, _ diffTime: Int64) -> Void

/**
* An Utility class that provides timed events in a defined time interval.
*/
@objcMembers class YBSwiftTimer: NSObject {
    
    /**
     * The period at which to execute the callbacks.
     */
    var interval: Double
    
    /**
     * Whether the Timer is running or not.
     */
    var isRunning: Bool { return isRunningAux }
    private var isRunningAux: Bool
    
    /**
     * Chrono to inform the callback how much time has passed since the previous call.
     */
    var chrono: YBChrono { return chronoAux }
    var chronoAux: YBChrono
    
    var callbacks: [TimerCallback]
    
    /// Timer to control the callbacks
    private var timer: Timer?
    
    /**
    * Init
    * Same as calling <initWithCallback:andInterval:> with an interval of 5000
    * @param callback the block to execute every <interval> milliseconds
    * @returns an instance of YBTimer
    */
    init(callback: TimerCallback?) {
        
        self.chronoAux = YBChrono()
        self.interval = 5000
        self.callbacks = []
        self.isRunningAux = false
        
        if let callback = callback {
            callbacks.append(callback)
        }
    }
    
    /**
    * Init
    * @param callback the block to execute every <interval> milliseconds
    * @param intervalMillis interval of the timer
    * @returns an instance of YBTimer
    */
    init(callback: TimerCallback?, andInterval intervalMillis: Double) {
        self.chronoAux = YBChrono()
        self.interval = intervalMillis
        self.callbacks = []
        self.isRunningAux = false
        
        if let callback = callback {
            callbacks.append(callback)
        }
    }
    
    /**
    * Adds a new callback to fire on the timer
    * @param callback callback that must conform to type TimerCallback
    */
    
    func addTimerCallback(_ callback: @escaping TimerCallback) {
        callbacks.append(callback)
    }
    
    /**
     * Starts the timer.
     */
    func start() {
        if (!self.isRunningAux) {
            self.isRunningAux = true
            self.scheduleTimer()
        }
    }
    
    /**
     * Stops the timer.
     */
    func stop() {
        if (!self.isRunningAux) {
            self.isRunningAux = false
            if let timer = timer {
                timer.invalidate()
                self.timer = nil
            }
        }
    }
    
    private func scheduleTimer() {
        if (Thread.isMainThread) {
            if (self.isRunning) {
                self.chronoAux.start()
                self.timer = Timer.scheduledTimer(timeInterval: self.interval/1000, target: self, selector:#selector(performCallback), userInfo: nil, repeats: false)
            }
        } else {
            DispatchQueue.main.async {
                self.scheduleTimer()
            }
        }
    }
    
    @objc private func performCallback() {
        if (self.callbacks.count > 0) {
            let elapsedTime = self.chronoAux.stop()
            self.callbacks.forEach{ callback in
               callback(self, elapsedTime)
            }
        }
        self.scheduleTimer()
    }
}
