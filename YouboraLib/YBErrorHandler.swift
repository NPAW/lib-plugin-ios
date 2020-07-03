//
//  YBErrorHandler.swift
//  YouboraLib
//
//  Created by Tiago Pereira on 21/05/2020.
//  Copyright © 2020 NPAW. All rights reserved.
//

import Foundation

/**
* An utility class that will prevent an error to be
* sent more than once in each x seconds
*/
@objcMembers public class YBErrorHandler: NSObject {
    var message: String?
    var code: String?
    
    var timerToClean: Timer?
    
    let secondsToClean: Int
    
    public var cleanError: (() -> Void)?
    
    /**
     Init the instance and set the number of seconds to clean old error
     
     - Parameter secondsToClean: number of seconds to reset settings and send error again
     - Returns: an instance of YBErrorHandler
    */
    public init(secondsToClean: Int) {
        self.secondsToClean = secondsToClean
    }
    
    /**
     Compares the new error with the old one and check if is new or not.
     Case yes asks to register the new one
     
     - Parameter message: message of the error to be sent
     - Parameter code: code of the error to be sent
     - Returns: true case error is new or false case is the same error
    */
    public func isNewError(message: String?, code: String?) -> Bool {
        if self.timerToClean == nil || (message != self.message || code != self.code) {
            self.initNewError(message: message, code: code)
            return true
        }
        
        return false
    }
    
    /**
        Register the new error invalidate old timer and start a new one
        
        - Parameter message: message of the error to be registered
        - Parameter code: code of the error to be registered
       */
    func initNewError(message: String?, code: String?) {
        self.message = message
        self.code = code
        
        self.timerToClean?.invalidate()
        self.timerToClean = nil
        
        self.timerToClean = Timer.scheduledTimer(
            timeInterval: TimeInterval(self.secondsToClean),
            target: self,
            selector: #selector(cleanOldError),
            userInfo: nil,
            repeats: false
        )
    }
    
    /**
        Clean the old error after the timer being called
    */
    func cleanOldError() {
        message = nil
        code = nil
        self.timerToClean = nil
        self.cleanError?()
    }
}
