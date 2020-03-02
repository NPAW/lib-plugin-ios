//
//  YBSwiftRequestTest.swift
//  YouboraLib
//
//  Created by Enrique Alfonso Burillo on 17/02/2020.
//  Copyright © 2020 NPAW. All rights reserved.
//

import Foundation
import XCTest
import OCMockito
import OCHamcrest

typealias DataTaskCompletionCallbackType = (_ data: Data?,  _ response: URLResponse?, _ error: Error?) -> Void

@objcMembers open class YBSwiftRequestTest: XCTest {
    
    open func testGetUrl() {
        let r = YBSwiftRequest("http://host.com", "/service")
        
        XCTAssertEqual("http://host.com/service", r.getUrl()?.absoluteString)
        
        r.params = ["param1":"value1","param2":"2","param3":"23.5","json":"{\"jsonkey\":\"jsonvalue\",\"jsonkey2\":\"jsonvalue2\"}"]
        
        if let url = r.getUrl()?.absoluteString.removingPercentEncoding {
            XCTAssert(url.contains("param1=value1"));
            XCTAssert(url.contains("param2=value2"));
            XCTAssert(url.contains("param3=value23.5"));
            XCTAssert(url.contains("json={"));
            XCTAssert(url.contains("\"jsonkey\":\"jsonvalue\""));
            XCTAssert(url.contains("\"jsonkey2\":\"jsonvalue2\""));
        } else {
            assertionFailure("Url was nil")
        }
    }
    
    open func testRequestParams() {
        let r = YBSwiftRequest("http://host.com", "/service")
        r.setParam("value", forKey: "key")
        XCTAssertNotNil(r.params["key"]);
        r.setParam("value2", forKey: "key2")
        XCTAssertNotNil(r.params["key2"]);
    }
    
    open func testSendSuccessRequest() {
        let r = YBTestableSwiftRequest("http://host.com", "/service")
        r.mockRequest = mock(URLRequest as! AnyClass.self)
    }
}
