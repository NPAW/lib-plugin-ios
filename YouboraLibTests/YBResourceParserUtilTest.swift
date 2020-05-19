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
    
    
}
