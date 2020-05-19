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
        
        let resourceUrl = "test"
        XCTAssertEqual(resourceUrl, YBResourceParserUtil.merge(resourseUrl: resourceUrl, adapterUrl: nil))
    }
}
