//
//  YBCDNCompressed.swift
//  YouboraLib
//
//  Created by Elisabet Massó on 30/11/22.
//  Copyright © 2022 NPAW. All rights reserved.
//

import Foundation

@objc public class YBCDNCompressed: NSObject, Codable {
    
    var bytes: Int? = nil
    var chunks: Int? = nil
    var averageBw: Int = 0
    var failures: Int = 0
    var downloadMillis: Double? = nil
    var name: String? = nil
    var fullName: String? = nil
//    var active: Bool = false
    var lastSecondsTraffic: Int = 0
    
}
