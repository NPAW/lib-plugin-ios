//
//  YBOptionsSwiftKeys.swift
//  YouboraLib
//
//  Created by Tiago Pereira on 16/10/2020.
//  Copyright © 2020 NPAW. All rights reserved.
//

import Foundation

/// Class that will make the transions Dictionary(json) to YBOptions and the other way around
@objcMembers public class YBOptionsFactory: NSObject {
    /**
     Method that will create Options with default values
     
     - Returns: YBOptions with all default values
     */
    static public func createOptions() -> YBOptions {
        return YBOptions()
    }
    
    /**
     Method that will create Options based on a json, case there's no json options with default values will be returned
     
     - Parameters:
        - json: Dictionary with all the values to be defined in options
     - Returns: YBOptions with all default values plus the ones sent in values
     */
    static public func createOptions(json: [String: Any]) -> YBOptions {
        return YBOptionsJsonConverter.updateWithJson(json: json, options: self.createOptions())
    }
    
    /**
     Method that will update Options based with the values available on json
     
     - Parameters:
        - json: Dictionary with all the values to be updated in the options
        - options: options to be updated
     - Returns: options with updated values from json
     */
    static public func createOptions(json: [String: Any], options: YBOptions) -> YBOptions {
        return YBOptionsJsonConverter.updateWithJson(json: json, options: options)
    }
    
    /**
     Method that will build a json based on values that are defined in Options
     - Parameters:
        - options: Current options to be converted for json
     - Returns: json with all the values available in current options
     */
    static public func createJson(options: YBOptions) -> [String: Any] {
        return YBOptionsJsonConverter.convertOptions(options: options)
    }
}
