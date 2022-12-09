//
//  YBP2PFailedRequests.swift
//  YouboraLib
//
//  Created by Elisabet Massó on 30/11/22.
//  Copyright © 2022 NPAW. All rights reserved.
//

import Foundation

@objc public class YBP2PFailedRequests: NSObject, Codable {
    
    var absent: Int = 0
    var error: Int = 0
    var timeout: Int = 0
    var total: Int = 0
    
}
