//
//  YBDashParserTest.swift
//  YouboraLib
//
//  Created by Tiago Pereira on 25/02/2020.
//  Copyright © 2020 NPAW. All rights reserved.
//

import XCTest

class YBDashParserTest: XCTestCase {
    
    let invalidResources = [
        "dasd",
        "",
        "@sssxmdp"
    ]
    
    let validResource = "https://abc.mpd"
    
    open override class func setUp() {
        super.setUp()
    }

    func testResourceCondition() {
        let parser = YBDashParser()
        XCTAssertFalse(parser.isSatisfied(resource: nil, manifest: nil))
        
        for invalidResource in self.invalidResources {
             XCTAssertFalse(parser.isSatisfied(resource: invalidResource, manifest: nil))
        }
        
        let testBundle = Bundle(for: self.classForCoder)
        
        let locationXmlPath = testBundle.path(forResource: "dashResponse", ofType: "xml")!
        
        do {
            let xmlData = try Data(contentsOf: URL(fileURLWithPath: locationXmlPath, isDirectory: false), options: [])
             XCTAssertTrue(parser.isSatisfied(resource: validResource, manifest: xmlData))
        } catch {}
    }
    
    func testGetRequestResource() {
        let parser = YBDashParser()
        
        let testBundle = Bundle(for: self.classForCoder)
        
        let locationXmlPath = testBundle.path(forResource: "dashResponse", ofType: "xml")!
        
        do {
            let xmlData = try Data(contentsOf: URL(fileURLWithPath: locationXmlPath, isDirectory: false), options: [])
            
            _ = parser.isSatisfied(resource: nil, manifest: xmlData)
            XCTAssertNil(parser.getRequestSource())

            _ = parser.isSatisfied(resource: "", manifest: "".data(using: .utf8))
            XCTAssertNil(parser.getRequestSource())
            
            for invalidResource in self.invalidResources {
                _ = parser.isSatisfied(resource: invalidResource, manifest: invalidResource.data(using: .utf8))
                XCTAssertNil(parser.getRequestSource())
            }
            
            _ = parser.isSatisfied(resource: validResource, manifest: xmlData)
            XCTAssertTrue(parser.getRequestSource() == validResource)
        } catch {}
    }
    
    func testDashParse() {
        let testBundle = Bundle(for: self.classForCoder)
        let parser = YBDashParser()
        
        let locationXmlPath = testBundle.path(forResource: "dashResponse", ofType: "xml")!
        let expectedLocation = "http://192.168.1.99/actualManifest.mpd"
        
        let finalResourceXmlPath = testBundle.path(forResource: "dashCallbackResponse", ofType: "xml")!
        let expectedFinalResource = "https://boltrljDRMTest1-a.akamaihd.net/media/v1/dash/live/cenc/6028583040001/f39ee0f0-72de-479d-9609-2bf6ea95b427/fed9a7f1-499a-469d-bacd-f25a94eac116/"
        
        do {
            var xmlData = try Data(contentsOf: URL(fileURLWithPath: locationXmlPath, isDirectory: false), options: [])
            
            var parsedResource = parser.parseResource(data: xmlData, response: nil, listenerParents: nil)
            XCTAssertTrue(parsedResource == expectedLocation)
            
            xmlData = try Data(contentsOf: URL(fileURLWithPath: finalResourceXmlPath, isDirectory: false), options: [])
            
            parsedResource = parser.parseResource(data: xmlData, response: nil, listenerParents: nil)
            XCTAssertTrue(parsedResource == expectedFinalResource)
            
        } catch {}
    }
    
    func testTransportFormat() {
        let testBundle = Bundle(for: self.classForCoder)
        let parser = YBDashParser()
        
        let locationXmlPath = testBundle.path(forResource: "dashResponse", ofType: "xml")!
        let finalResourceXmlPath = testBundle.path(forResource: "dashCallbackResponse", ofType: "xml")!

        do {
            var xmlData = try Data(contentsOf: URL(fileURLWithPath: locationXmlPath, isDirectory: false), options: [])
            
            var tranportFormat = parser.parseTransportFormat(data: xmlData, response: nil, listenerParents: nil, userDefinedTransportFormat: nil)
            
            xmlData = try Data(contentsOf: URL(fileURLWithPath: finalResourceXmlPath, isDirectory: false), options: [])
            
            tranportFormat = parser.parseTransportFormat(data: xmlData, response: nil, listenerParents: nil, userDefinedTransportFormat: nil)
            XCTAssertEqual(tranportFormat, YBConstantsTransportFormat.hlsFmp4)
            
            tranportFormat = parser.parseTransportFormat(data: xmlData, response: nil, listenerParents: nil, userDefinedTransportFormat: "")
            XCTAssertNil(tranportFormat)
            
        } catch {}
    }
}
