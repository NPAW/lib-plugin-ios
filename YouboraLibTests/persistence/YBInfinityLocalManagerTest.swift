//
//  YBInfinityLocalManagerTest.swift
//  YouboraLib
//
//  Created by Tiago Pereira on 05/05/2020.
//  Copyright © 2020 NPAW. All rights reserved.
//

import XCTest

class YBInfinityLocalManagerTest: XCTestCase {
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        YBInfinityLocalManager.cleanLocalManager()
    }

    func testSaveSesssion() {
        let sessionID = "sessionID"
        XCTAssertNil(YBInfinityLocalManager.getSessionId())
        
        YBInfinityLocalManager.saveSession(sessionId: sessionID)
        XCTAssertEqual(YBInfinityLocalManager.getSessionId(), sessionID)
    }
    
    func testSaveContext() {
        let context = "context"
        XCTAssertNil(YBInfinityLocalManager.getContext())
        
        YBInfinityLocalManager.saveContext(context: context)
        XCTAssertEqual(YBInfinityLocalManager.getContext(), context)
    }
    
    func testLastActive() {
        XCTAssertNil(YBInfinityLocalManager.getLastActive())
        
        YBInfinityLocalManager.saveLastActiveDate()
        XCTAssertNotNil(YBInfinityLocalManager.saveLastActiveDate())
    }
}
