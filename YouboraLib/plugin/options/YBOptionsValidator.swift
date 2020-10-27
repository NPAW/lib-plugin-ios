//
//  YBOptionsValidator.swift
//  YouboraLib
//
//  Created by Tiago Pereira on 27/10/2020.
//  Copyright © 2020 NPAW. All rights reserved.
//

import Foundation

/// Class used to valid values that come from the json, the validation will check if the value exists
/// and if it contains a valid value format also it will set or not a default value depending on the validation result
class YBOptionsValidator<T>: NSObject {
    
    // Type alias to help with testing
    public typealias InvalidCompletion = () -> Void
    
    /**
     Method to validate if a value for key is valid or not and print an invalid message case not
     this method should only be called for non optional properties
     - Parameters:
     - values: Dictionary with all the values to be defined in options
     - key: key of the value to be validated
     - defaultValue: value to be returned case invalid or no result
     - invalidCompletion: completion block to allow to know when invalid is called during the testing
     - Returns: a valid result or default case value not founded or invalid
     */
    static public func validateValue(values: [String: Any?], key: String, defaultValue: T, invalidCompletion: InvalidCompletion? = nil) -> T {
        let containsValue = values[key] != nil
        
        if !containsValue { return defaultValue }
        
        guard let validValue = values[key] as? T else {
            printValueValidation(key: key, invalidCompletion: invalidCompletion)
            return defaultValue
        }
        
        return validValue
    }
    
    /**
     Method to validate if a value for key is valid or not and print an invalid message case not
     this method should only be called for optional properties
     - Parameters:
     - values: Dictionary with all the values to be defined in options
     - key: key of the value to be validated
     - defaultValue: value to be returned case invalid
     - invalidCompletion: completion block to allow to know when invalid is called during the testing
     - Returns: a valid result case everything ok, nil case no value defined or defaultValue case invalid
     */
    static public func validateOptionalValue(values: [String: Any?], key: String, defaultValue: T?, invalidCompletion: InvalidCompletion? = nil) -> T? {
        
        guard let value = values[key] else {
            // case key doesn't exists
            return nil
        }
        
        if value == nil {
            // case key exists but value is nil
            return nil
        }
        
        guard let validValue = value as? T else {
            printValueValidation(key: key, invalidCompletion: invalidCompletion)
            return defaultValue
        }
        
        return validValue
    }
    
    /**
     Method to print error message case something wrong with the validation
     - Parameters:
     - key: key where the invalid value was found
     - invalidCompletion: completion block to allow to know when invalid is called during the testing
     */
    static public func printValueValidation(key: String, invalidCompletion: InvalidCompletion?) {
        
        if let invalidCompletion = invalidCompletion {
            invalidCompletion()
        }
        YBSwiftLog.warn("invalid value for option %@", key)
    }
}
