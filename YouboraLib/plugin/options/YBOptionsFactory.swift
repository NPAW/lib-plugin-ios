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
     Method that will build Options based on a json, case there's no json options with default values will be returned
     
     - Parameters:
        - json: Dictionary with all the values to be defined in options
     - Returns: YBOptions with all default values plus the ones sent in values
     */
    static public func buildOptions(json: [String: Any]) -> YBOptions {
        return YBOptionsJsonConverter.buildFromJson(json: json)
    }
    
    /**
     Method that will build a json based on values that are defined in Options
     - Parameters:
        - options: Current options to be converted for json
     - Returns: json with all the values available in current options
     */
    static public func buildJson(options: YBOptions) -> [String: Any] {
        return YBOptionsJsonConverter.convertToJson(options: options)
    }
}
