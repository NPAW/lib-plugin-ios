//
//  YBTestableSwiftRequest.swift
//  YouboraLib
//
//  Created by Enrique Alfonso Burillo on 17/02/2020.
//  Copyright © 2020 NPAW. All rights reserved.
//

import Foundation

@objcMembers open class YBTestableSwiftRequest: YBSwiftRequest {
    var mockRequest: URLRequest? = nil
    
    override func createRequest(_ url: URL) -> URLRequest {
        return mockRequest!
    }
}
