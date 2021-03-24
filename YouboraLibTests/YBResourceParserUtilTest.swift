//
//  YBResourceParserUtil.swift
//  YouboraLib
//
//  Created by Tiago Pereira on 19/05/2020.
//  Copyright © 2020 NPAW. All rights reserved.
//

import XCTest

class YBResourceParserUtilTest: XCTestCase {
    
    func testMerge() {
        XCTAssertNil(YBResourceParserUtil.merge(resourseUrl: nil, adapterUrl: nil))
        
        let resourceUrl = "testResource"
        XCTAssertEqual(resourceUrl, YBResourceParserUtil.merge(resourseUrl: resourceUrl, adapterUrl: nil))
        
        let adapterUrl = "testAdapter"
        XCTAssertEqual(adapterUrl, YBResourceParserUtil.merge(resourseUrl: nil, adapterUrl: adapterUrl))
        
        XCTAssertEqual(adapterUrl, YBResourceParserUtil.merge(resourseUrl: resourceUrl, adapterUrl: adapterUrl))
    }
    
    func testFinalResource() {
        XCTAssertFalse(YBResourceParserUtil.isFinalURL(resourceUrl: nil))
        
        XCTAssertFalse(YBResourceParserUtil.isFinalURL(resourceUrl: "testResource"))

        XCTAssertFalse(YBResourceParserUtil.isFinalURL(resourceUrl: "testResource.xpto"))
        XCTAssertTrue(YBResourceParserUtil.isFinalURL(resourceUrl: "testResource.mp4"))
    }
    
    func testTranslateTransport() {
        XCTAssertNil(YBResourceParserUtil.translateTransportResource(transportResource: ""))
        
        XCTAssertNil(YBResourceParserUtil.translateTransportResource(transportResource: "testResource.xpto"))
        
        XCTAssertEqual(YBConstantsTransportFormat.hlsFmp4, YBResourceParserUtil.translateTransportResource(transportResource: "testResource.mp4"))
        
        XCTAssertEqual(YBConstantsTransportFormat.hlsTs, YBResourceParserUtil.translateTransportResource(transportResource: "testResource.ts"))

        XCTAssertEqual(YBConstantsTransportFormat.hlsCmfv, YBResourceParserUtil.translateTransportResource(transportResource: "testResource.cmfv"))
    }
}
