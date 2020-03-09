//
//  YBLocationParserTests.swift
//  YouboraLib
//
//  Created by Tiago Pereira on 25/02/2020.
//  Copyright © 2020 NPAW. All rights reserved.
//

import Foundation
import XCTest

@objcMembers open class YBLocationParserTest: XCTestCase {

    let validResource = "https://abc.com"
    
    open override class func setUp() {
        super.setUp()
    }

    func testResourceCondition() {
        let parser = YBLocationParser()
        XCTAssertFalse(parser.isSatisfied(resource: nil, manifest: "".data(using: .utf8)))
        let invalidResource = ""

        XCTAssertFalse(parser.isSatisfied(resource: invalidResource, manifest: "".data(using: .utf8) ))

        let validResource = "https://abc.com"
        XCTAssertTrue(parser.isSatisfied(resource: validResource, manifest: "".data(using: .utf8)))
    }

    func testGetRequestResource() {
        let parser = YBLocationParser()

        _ = parser.isSatisfied(resource: nil, manifest: "".data(using: .utf8))
        XCTAssertNil(parser.getRequestSource())

        _ = parser.isSatisfied(resource: "", manifest: "".data(using: .utf8))
        XCTAssertNil(parser.getRequestSource())
        
        _ = parser.isSatisfied(resource: validResource, manifest: "".data(using: .utf8))
        XCTAssertTrue(parser.getRequestSource() == validResource)
    }

    func testLocationParse() {
        let parser = YBLocationParser()
        let url = URL(string: validResource)!

        XCTAssertNil(parser.parseResource(data: nil, response: nil, listenerParents: nil))
        
        let emptyResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        XCTAssertNil(parser.parseResource(data: nil, response: emptyResponse, listenerParents: nil))
        
        let newLocation = "https://newLocation.com"
        let headers = ["Location": newLocation]
        let locationResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: headers)
        
        XCTAssertTrue(parser.parseResource(data: nil, response: locationResponse, listenerParents: nil) == newLocation)
    }
}
