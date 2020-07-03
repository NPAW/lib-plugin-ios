//
//  YBErrorHandlerTest.swift
//  YouboraLib
//
//  Created by Tiago Pereira on 21/05/2020.
//  Copyright © 2020 NPAW. All rights reserved.
//

import XCTest

class YBErrorHandlerTest: XCTestCase {
    let secondsToClean = 1
    var errorHandler: YBErrorHandler?
    
    override func setUp() {
        self.errorHandler = YBErrorHandler(secondsToClean: self.secondsToClean)
    }
    
    func testAttribution() {
        guard let errorHandler = self.errorHandler else {
            XCTFail("No error handler")
            return
        }
        
        let message = "message"
        let code = "code"
        XCTAssertTrue(errorHandler.isNewError(message: message, code: code))
        
        XCTAssertEqual(message, errorHandler.message)
        XCTAssertEqual(code, errorHandler.code)
    }
    
    func testCleanTimer() {
        guard let errorHandler = self.errorHandler else {
            XCTFail("No error handler")
            return
        }
        let expectation = self.expectation(description: "Cleaning")
        
        let message = "message"
        let code = "code"
        XCTAssertTrue(errorHandler.isNewError(message: message, code: code))
        
        errorHandler.cleanError = {
            expectation.fulfill()
            errorHandler.cleanError = nil
        }
        
        waitForExpectations(timeout: 2, handler: nil)
        XCTAssertNil(errorHandler.message)
        XCTAssertNil(errorHandler.code)
    }
    
    func testNotEqual() {
        guard let errorHandler = self.errorHandler else {
            XCTFail("No error handler")
            return
        }
        
        XCTAssertTrue(errorHandler.isNewError(message: "new", code: "new"))
        XCTAssertTrue(errorHandler.isNewError(message: "old", code: "new"))
        XCTAssertTrue(errorHandler.isNewError(message: "old", code: "old"))
        let expectation = self.expectation(description: "Cleaning")
        errorHandler.cleanError = {
            expectation.fulfill()
            errorHandler.cleanError = nil
        }
        waitForExpectations(timeout: 2, handler: nil)
        
        XCTAssertNil(errorHandler.message)
        XCTAssertNil(errorHandler.code)
        
        XCTAssertTrue(errorHandler.isNewError(message: "old", code: "old"))
    }
    
    func testEqual() {
        guard let errorHandler = self.errorHandler else {
            XCTFail("No error handler")
            return
        }
        
        XCTAssertTrue(errorHandler.isNewError(message: "new", code: "new"))
        XCTAssertFalse(errorHandler.isNewError(message: "new", code: "new"))
        
        let expectation = self.expectation(description: "Cleaning")
        
        errorHandler.cleanError = {
            expectation.fulfill()
            errorHandler.cleanError = nil
        }
        
        waitForExpectations(timeout: 2, handler: nil)
        
        XCTAssertTrue(errorHandler.isNewError(message: "new", code: "new"))
    }

}
