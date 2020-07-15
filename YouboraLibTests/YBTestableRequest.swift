//
//  YBTestableRequest.swift
//  YouboraLib
//
//  Created by Tiago Pereira on 09/07/2020.
//  Copyright © 2020 NPAW. All rights reserved.
//

import Foundation

@objcMembers public class YBTestableRequest: YBRequest {
    public var mockRequest: NSMutableURLRequest?

    override func createRequest(url: URL) -> NSMutableURLRequest? {
        return self.mockRequest
    }
    
    public func mockSucceed(data: Data?, response: URLResponse?, params: NSMutableDictionary?) {
        self.didSucceed(data: data, response: response, params: params)
    }
    
    public func mockFail(error: Error) {
        self.didFail(error: error)
    }
}
