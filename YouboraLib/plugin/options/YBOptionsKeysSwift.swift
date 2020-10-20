//
//  YBOptionsKeysSwift.swift
//  YouboraLib iOS
//
//  Created by Tiago Pereira on 20/10/2020.
//  Copyright © 2020 NPAW. All rights reserved.
//

import Foundation

/// Class that will contain all the keys for the options available to the plugin
@objcMembers public class YBOptionsKeysSwift: NSObject {
    
    /// All available keys
    public enum Keys: CaseIterable {
        case enabled
    }
    
    /**
     Method to translate enum in a string
     - Parameters:
        - key: option enum key from when we wanna to otain the string key
     - Returns: key in string
     */
    public static func getKeyValue(key: Keys) -> String {
        switch key {
        case .enabled:
            return "enabled"
        }
    }
}
