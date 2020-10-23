//
//  YBOptionsJsonHelperTest.swift
//  YouboraLib iOS
//
//  Created by Tiago Pereira on 20/10/2020.
//  Copyright © 2020 NPAW. All rights reserved.
//

import XCTest

class YBOptionsJsonHelperTest: XCTestCase {
    
//    var initialOptions: YBOptions!
//    
//    override func setUp() {
//        self.initialOptions = YBOptions()
//    }
//    
//    /// Parser test
//    func testParseFromJsonNoValues() {
//        let json: [String: Any] =  [:]
//        let options = YBOptionsJsonParser.parseFromJson(values: json)
//        
//        XCTAssertEqual(options.enabled, initialOptions.enabled)
//    }
//    
//    func testParseFromJsonInvalid() {
//        let json: [String: Any] =  [YBOptionsKeysSwift.getKeyValue(key: .enabled): "invalid"]
//        
//        let options = YBOptionsJsonParser.parseFromJson(values: json)
//        
//        XCTAssertEqual(options.enabled, initialOptions.enabled)
//    }
//    
//    func testParseFromJson() {
//        let json: [String: Any] =  [YBOptionsKeysSwift.getKeyValue(key: .enabled): false]
//        
//        let options = YBOptionsJsonParser.parseFromJson(values: json)
//        
//        XCTAssertFalse(options.enabled)
//    }
//    
//    func testParseToJson() {
//        var result = YBOptionsJsonParser.parseToJson(options: self.initialOptions)[YBOptionsKeysSwift.getKeyValue(key: .enabled)] as? Bool
//        
//        XCTAssertNotNil(result)
//        XCTAssertEqual(result!, initialOptions.enabled)
//        
//        initialOptions.enabled = true
//        
//        result = YBOptionsJsonParser.parseToJson(options: self.initialOptions)[YBOptionsKeysSwift.getKeyValue(key: .enabled)] as? Bool
//        
//        XCTAssertNotNil(result)
//        XCTAssertTrue(result!)
//
//    }
//    
//    /// Validation tests
//    func testNoValueValidation() {
//        let values: [String: Any?] = [:]
//        var invalidCalled = false
//        
//        let result = YBOptionsJsonValidator<Bool>.validateValue(values: values, key: "temp") {
//            invalidCalled = true
//        }
//        
//        XCTAssertNil(result)
//        XCTAssertFalse(invalidCalled)
//    }
//    
//    func testInvalidValidation() {
//        let values: [String: Any?] = ["temp": "string"]
//        var invalidCalled = false
//        
//        let result = YBOptionsJsonValidator<Bool>.validateValue(values: values, key: "temp") {
//            invalidCalled = true
//        }
//        
//        XCTAssertNil(result)
//        XCTAssertTrue(invalidCalled)
//    }
//    
//    func testValidValue() {
//        let values: [String: Any?] = ["temp": "string"]
//        var invalidCalled = false
//        
//        let result = YBOptionsJsonValidator<String>.validateValue(values: values, key: "temp") {
//            invalidCalled = true
//        }
//        
//        XCTAssertNotNil(result)
//        XCTAssertLessThanOrEqual("string", result!)
//        XCTAssertFalse(invalidCalled)
//    }
}
