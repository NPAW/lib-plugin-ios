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
    let validResource = """
        #EXTM3U\n\
        #EXT-X-STREAM-INF:PROGRAM-ID=1, BANDWIDTH=688301\n\
        http://qthttp.apple.com.edgesuite.net/1010qwoeiuryfg/0640_vod.m3u8\n\
        #EXT-X-STREAM-INF:PROGRAM-ID=1, BANDWIDTH=165135\n\
        http://qthttp.apple.com.edgesuite.net/1010qwoeiuryfg/0150_vod.m3u8\n
    """
    
    open override class func setUp() {
        super.setUp()
    }
    
    func testResourceCondition() {
        let parser = YBHlsParser()
        XCTAssertFalse(parser.isSatisfied(resource: nil, manifest: nil))
        
        XCTAssertFalse(parser.isSatisfied(resource: invalidResource, manifest: "".data(using: .utf8)))
        
        XCTAssertTrue(parser.isSatisfied(resource: validResource, manifest: validResource.data(using: .utf8)))
    }
    
    func testGetRequestResource() {
        let parser = YBHlsParser()
        
        _ = parser.isSatisfied(resource: nil, manifest: nil)
        XCTAssertNil(parser.getRequestSource())
        
        _ = parser.isSatisfied(resource: "", manifest: nil)
        XCTAssertNil(parser.getRequestSource())
        
        _ = parser.isSatisfied(resource: invalidResource, manifest: "".data(using: .utf8))
        XCTAssertNil(parser.getRequestSource())
    }
    
    func testResourceParse() {
        let resourceUrl = "http://qthttp.apple.com.edgesuite.net/1010qwoeiuryfg/sl.m3u8"
        
        var responseString = """
                   #EXTM3U\n\
                   #EXT-X-STREAM-INF:PROGRAM-ID=1, BANDWIDTH=688301\n\
                   http://qthttp.apple.com.edgesuite.net/1010qwoeiuryfg/0640_vod.m3u8\n\
                   #EXT-X-STREAM-INF:PROGRAM-ID=1, BANDWIDTH=165135\n\
                   http://qthttp.apple.com.edgesuite.net/1010qwoeiuryfg/0150_vod.m3u8\n
               """
        
        let parser = YBHlsParser()
        _ = parser.isSatisfied(resource: resourceUrl, manifest: responseString.data(using: .utf8))
        
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
        
        let expectedFinalResourceUrl = "http://qthttp.apple.com.edgesuite.net/1010qwoeiuryfg/0640/06400.ts"
        XCTAssertTrue(parsedResource == expectedFinalResourceUrl)
    }
    
    func testComplexResourceParse() {
        let resourceUrl = "https://weirdurl.com/abcd/def.ts?testtoken=123456"
        
        var responseString = """
        #EXTM3U\n\
        #EXT-X-VERSION:4\n\
        #EXT-X-MEDIA:TYPE=AUDIO,GROUP-ID="audio-0",NAME="en (Main)",DEFAULT=YES,AUTOSELECT=YES,LANGUAGE="en",URI="https://weirdurl.com/abcd/def.ts?testtoken=123456"\n
        """

        let parser = YBHlsParser()
        _ = parser.isSatisfied(resource: resourceUrl, manifest: responseString.data(using: .utf8))

        var parsedResource = parser.parseResource(data: responseString.data(using: .utf8), response: nil, listenerParents: nil)

        XCTAssertTrue(parsedResource == "https://weirdurl.com/abcd/def.ts?testtoken=123456")
        
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

        let expectedFinalResourceUrl = "https://weirdurl.com/abcd/0640/06400.ts"
        XCTAssertTrue(parsedResource == expectedFinalResourceUrl)
    }
    
    func testHostFinalResource() {
        let resourceUrl = "http://qthttp.apple.com.edgesuite.net/1010qwoeiuryfg/sl.m3u8"
        
        let expectedFinalResourceUrl = "http://qthttp.apple.com.edgesuite.net/0640/06400.ts"
        
        let responseString = """
            #EXTM3U\n\
            #EXT-X-TARGETDURATION:10\n\
            #EXT-X-MEDIA-SEQUENCE:0\n\
            #EXTINF:10,\n\
            /0640/06400.ts\n\
            #EXTINF:10,\n\
            /0640/06401.ts\n
        """
        
        let parser = YBHlsParser()
        _ = parser.isSatisfied(resource: resourceUrl, manifest: responseString.data(using: .utf8))
        
        let parsedResource = parser.parseResource(data: responseString.data(using: .utf8), response: nil, listenerParents: nil)
        
        XCTAssertTrue(parsedResource == expectedFinalResourceUrl)
    }
    
    func testTransportFormat() {
        let resourceUrl = "http://qthttp.apple.com.edgesuite.net/1010qwoeiuryfg/sl.m3u8"
        
        var responseString = """
                      #EXTM3U\n\
                      #EXT-X-STREAM-INF:PROGRAM-ID=1, BANDWIDTH=688301\n\
                      http://qthttp.apple.com.edgesuite.net/1010qwoeiuryfg/0640_vod.m3u8\n\
                      #EXT-X-STREAM-INF:PROGRAM-ID=1, BANDWIDTH=165135\n\
                      http://qthttp.apple.com.edgesuite.net/1010qwoeiuryfg/0150_vod.m3u8\n
                  """
        
        let parser = YBHlsParser()
        _ = parser.isSatisfied(resource: resourceUrl, manifest: responseString.data(using: .utf8))
        
        var transportFormat = parser.parseTransportFormat(data: responseString.data(using: .utf8), response: nil, listenerParents: nil, userDefinedTransportFormat: nil)
        XCTAssertNil(transportFormat)
        
        responseString = """
        #EXTM3U\n\
        #EXT-X-TARGETDURATION:10\n\
        #EXT-X-MEDIA-SEQUENCE:0\n\
        #EXTINF:10,\n\
        0640/06400.ts\n\
        #EXTINF:10,\n\
        0640/06401.ts\n
        """
        
        transportFormat = parser.parseTransportFormat(data: responseString.data(using: .utf8), response: nil, listenerParents: nil, userDefinedTransportFormat: nil)
        XCTAssertEqual(transportFormat, YBConstantsTransportFormat.hlsTs)
        
        transportFormat = parser.parseTransportFormat(data: responseString.data(using: .utf8), response: nil, listenerParents: nil, userDefinedTransportFormat: "noNil")
        XCTAssertNil(transportFormat)
    }
}
