//
//  YBOptionsJsonHelperTest.swift
//  YouboraLib iOS
//
//  Created by Tiago Pereira on 20/10/2020.
//  Copyright © 2020 NPAW. All rights reserved.
//

import XCTest

class YBOptionsValidatorTest: XCTestCase {
    // - test non optional invalid value
    // - test non optional valid value
    // - test non optional nil value
    
    // - test optional invalid value
    // - test optional valid value
    // - test optional nil value
    
    var json: [String: Any?]!
    
    override func setUp() {
        self.json = [
            "prop1": "absccs",
            "prop2": 1234,
            "prop3": true,
            "prop4": nil
        ]
    }
    
    func testNonOptionalInvalidValue() {
        let expectation = XCTestExpectation(description: "Waiting for invalid value")
        let defaultValue = NSNumber(value: 10)
        
        let result = YBOptionsValidator<NSNumber>.validateValue(values: self.json, key: "prop1", defaultValue: defaultValue) {
            expectation.fulfill()
        }
        
        XCTAssertEqual(defaultValue, result)
        
        wait(for: [expectation], timeout: 0.5)
    }
    
    func testNonOptionalValidValue() {
        let defaultValue = "other"
        let keyToTest = "prop1"
        
        let result = YBOptionsValidator<String>.validateValue(values: self.json, key: keyToTest, defaultValue: defaultValue)
        
        if let value = self.json[keyToTest] as? String {
            XCTAssertTrue(value.contains(result))
        } else {
            XCTFail("No value found to compare")
        }
        
        XCTAssertNotEqual(result, defaultValue)
    }
    
    func testNonOptionalNilValue() {
        let defaultValue = "other"
        let keyToTestNil = "prop4"
        let keyToTestNoKey = "prop5"
        
        var result = YBOptionsValidator<String>.validateValue(values: self.json, key: keyToTestNil, defaultValue: defaultValue)
        
        XCTAssertEqual(result, defaultValue)
        
        result = YBOptionsValidator<String>.validateValue(values: self.json, key: keyToTestNoKey, defaultValue: defaultValue)
        
        XCTAssertEqual(result, defaultValue)
    }
    
    func testOptionalNilInvalidValue() {
        let keyToTestNil = "prop2"
        
        let expectation = XCTestExpectation(description: "Waiting for invalid value")
        
        let result = YBOptionsValidator<String>.validateOptionalValue(values: self.json, key: keyToTestNil, defaultValue: nil) {
            expectation.fulfill()
        }
        
        XCTAssertNil(result)
        
        wait(for: [expectation], timeout: 0.5)
    }
    
    func testOptionalNoNilInvalidValue() {
        let defaultValue = "other"
        let key = "prop2"
        
        let expectation = XCTestExpectation(description: "Waiting for invalid value")
        
        let result = YBOptionsValidator<String?>.validateOptionalValue(values: self.json, key: key, defaultValue: defaultValue) {
            expectation.fulfill()
        }
        
        XCTAssertEqual(result, defaultValue)
        
        wait(for: [expectation], timeout: 0.5)
    }
    
    func testOptionalValidValue() {
        let key = "prop1"
        
        let result = YBOptionsValidator<String>.validateOptionalValue(values: self.json, key: key, defaultValue: nil)
        
        XCTAssertNotNil(result)
        
        if let value = self.json[key] as? String, let noNilResult = result {
            XCTAssertTrue(value.contains(noNilResult))
        } else {
            XCTFail("No value found to compare")
        }
    }
    
    func testOptionalNilValue() {
        let defaultValue = "other"
        let key = "prop4"
        
        let result = YBOptionsValidator<String>.validateOptionalValue(values: self.json, key: key, defaultValue: defaultValue)
        
        XCTAssertNil(result)
    }
    
    func testOptionalNoKeyNilValue() {
        let defaultValue = "other"
        let key = "prop5"
        
        let result = YBOptionsValidator<String>.validateOptionalValue(values: self.json, key: key, defaultValue: defaultValue)
        
        XCTAssertNil(result)
    }
}
