//
//  YBOptionsSwiftKeys.swift
//  YouboraLib
//
//  Created by Tiago Pereira on 16/10/2020.
//  Copyright © 2020 NPAW. All rights reserved.
//

import Foundation

/// Class that will make the transions Dictionary(json) to YBOptions and the other way around
public class YBOptionsJsonParser: NSObject {
    
    /**
     Method that will build Options based on a dictionary sent by paramter, it will also do the validation of the data and
     print the errors case any
     
     - Parameters:
        - values: Dictionary with all the values to be defined in options
     - Returns: YBOptions with all default values plus the ones sent in values
     */
    static public func parseFromJson(values: [String: Any?]) -> YBOptionsSwift {
        let options = YBOptionsSwift()
        
        for key in YBOptionsKeysSwift.Keys.allCases {
            let keyValue = YBOptionsKeysSwift.getKeyValue(key: key)
            switch key {
            case .enabled:
                if let enabled = YBOptionsJsonValidator<Bool>.validateValue(values: values, key: keyValue) {
                    options.enabled = enabled
                }
            }
        }
        
        if let enabled = YBOptionsJsonValidator<Bool>.validateValue(values: values, key: YBOptionKeys.enabled) {
            options.enabled = enabled
        }
       
        return options
    }
    
    /**
     Method that will parse current options into a json
     - Parameters:
        - options: Current options to be parsed to json
     - Returns: json with all the values available in current options
     */
    static public func parseToJson(options: YBOptionsSwift) -> [String: Any?] {
        var json: [String: Any] = [:]
        
        for key in YBOptionsKeysSwift.Keys.allCases {
            let keyValue = YBOptionsKeysSwift.getKeyValue(key: key)
            switch key {
            case .enabled:
                json[keyValue] = options.enabled
            }
        }
        
        return json
    }
}

public class YBOptionsJsonValidator<T>: NSObject {
    
    // Type alias to help with testing
    public typealias InvalidCompletion = () -> Void
    
    /**
     Method to validate if a value for key is valid or not and print an invalid message case not
     - Parameters:
        - values: Dictionary with all the values to be defined in options
        - key: key of the value to be validated
        - invalidCompletion: completion block to allow to know when invalid is called during the testing
     - Returns: a valid result or nil case value not founded or invalid
     */
    static public func validateValue(values: [String: Any?], key: String, invalidCompletion: InvalidCompletion? = nil) -> T? {
        let containsValue = values[key] != nil
        
        if !containsValue { return nil }
        
        guard let validValue = values[key] as? T else {
            printValueValidation(key: key, invalidCompletion: invalidCompletion)
            return nil
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
        YBSwiftLog.error("The option %@ is invalid", key)
    }
}
