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
        XCTAssertFalse(parser.isSatisfied(resource: nil))
        let invalidResource = ""

        XCTAssertFalse(parser.isSatisfied(resource: invalidResource))

        let validResource = "https://abc.com"
        XCTAssertTrue(parser.isSatisfied(resource: validResource))
    }

    func testGetRequestResource() {
        let parser = YBLocationParser()

        _ = parser.isSatisfied(resource: nil)
        XCTAssertNil(parser.getRequestSource())

        _ = parser.isSatisfied(resource: "")
        XCTAssertNil(parser.getRequestSource())
        
        _ = parser.isSatisfied(resource: validResource)
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
