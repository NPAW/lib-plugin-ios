//
//  YBHlsParserTest.swift
//  YouboraLib
//
//  Created by Tiago Pereira on 25/02/2020.
//  Copyright © 2020 NPAW. All rights reserved.
//

import XCTest

@objcMembers open class YBHlsParserTest: XCTestCase {

    let invalidResource = "https://abc.com"
    let validResource = "https://abc.m3u8"
    
    open override class func setUp() {
        super.setUp()
    }

    func testResourceCondition() {
        let parser = YBHlsParser()
        XCTAssertFalse(parser.isSatisfied(resource: nil))
        
        XCTAssertFalse(parser.isSatisfied(resource: invalidResource))

        XCTAssertTrue(parser.isSatisfied(resource: validResource))
    }

    func testGetRequestResource() {
        let parser = YBHlsParser()

        _ = parser.isSatisfied(resource: nil)
        XCTAssertNil(parser.getRequestSource())

        _ = parser.isSatisfied(resource: "")
        XCTAssertNil(parser.getRequestSource())
        
        _ = parser.isSatisfied(resource: invalidResource)
        XCTAssertNil(parser.getRequestSource())
        
        _ = parser.isSatisfied(resource: validResource)
        XCTAssertTrue(parser.getRequestSource() == validResource)
    }
    
    func testResourceParse() {
        let resourceUrl = "http://qthttp.apple.com.edgesuite.net/1010qwoeiuryfg/sl.m3u8"
        let expectedFinalResourceUrl = "http://qthttp.apple.com.edgesuite.net/1010qwoeiuryfg/0640/06400.ts"
        
        let parser = YBHlsParser()
        _ = parser.isSatisfied(resource: resourceUrl)
        
        var responseString = """
            #EXTM3U\n\
            #EXT-X-STREAM-INF:PROGRAM-ID=1, BANDWIDTH=688301\n\
            http://qthttp.apple.com.edgesuite.net/1010qwoeiuryfg/0640_vod.m3u8\n\
            #EXT-X-STREAM-INF:PROGRAM-ID=1, BANDWIDTH=165135\n\
            http://qthttp.apple.com.edgesuite.net/1010qwoeiuryfg/0150_vod.m3u8\n
        """
        
        var parsedResource = parser.parseResource(data: responseString.data(using: .utf8), response: nil, listenerParents: nil)
        
        XCTAssertTrue(parsedResource == "http://qthttp.apple.com.edgesuite.net/1010qwoeiuryfg/0640_vod.m3u8")
        
        responseString = """
            #EXTM3U\n\
            #EXT-X-TARGETDURATION:10\n\
            #EXT-X-MEDIA-SEQUENCE:0\n\
            #EXTINF:10,\n\
            0640/06400.ts\n\
            #EXTINF:10,\n\
            0640/06401.ts\n
        """
        
        parsedResource = parser.parseResource(data: responseString.data(using: .utf8), response: nil, listenerParents: nil)
        
        XCTAssertTrue(parsedResource == expectedFinalResourceUrl)
    }
}
