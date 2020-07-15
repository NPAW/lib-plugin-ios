//
//  YBEventDataSourceTest.swift
//  YouboraLib
//
//  Created by Tiago Pereira on 07/05/2020.
//  Copyright © 2020 NPAW. All rights reserved.
//

import XCTest

class YBEventDataSourceTest: XCTestCase {
    
    var eventDataSource: YBEventDataSource?
    let offlineIds = [1234, 123455, 1234556]

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let dbPath = YBAppDatabase.shared.writableDBPath(dbName: YBAppDatabase.shared.filename)
        do {
            try FileManager.default.removeItem(atPath: dbPath)
            YBAppDatabase.shared.createDatabase(filename: YBAppDatabase.shared.filename)
            
            for i in 0...offlineIds.count - 1 {
                _ = try YBAppDatabase.shared.insertEvent(offlineId: offlineIds[i], jsonEvents: "jsonEvents")
            }
        } catch { }
        self.eventDataSource = YBEventDataSource()
    }

    func testPutNewEvents() {
        let offlineIDTest = 1234
        
        let dSExpectation = expectation(description: "Wait for event data source")
        
        eventDataSource?.putNewEvent(offlineId: offlineIDTest, jsonEvents: "jsonEvents", completion: {
            self.eventDataSource?.allEvents(completion: { events in
                XCTAssertEqual(events.count, 4)
                dSExpectation.fulfill()
            })
        })
        
        wait(for: [dSExpectation], timeout: 5)
    }
    
    func testAllEvents() {
        let dSExpectation = expectation(description: "Wait for event data source")
        
        eventDataSource?.allEvents(completion: { events in
            XCTAssertEqual(events.count, 3)
            dSExpectation.fulfill()
        })
        
        wait(for: [dSExpectation], timeout: 5)
    }
    
    func testFirstID() {
        let dSExpectation = expectation(description: "Wait for event data source")
        
        eventDataSource?.firstId(completion: { offlineId in
            XCTAssertEqual(offlineId, self.offlineIds.first)
            dSExpectation.fulfill()
        })
        
        wait(for: [dSExpectation], timeout: 5)
    }
    
    func testLastID() {
        let dSExpectation = expectation(description: "Wait for event data source")
        
        eventDataSource?.lastId(completion: { offlineId in
            XCTAssertEqual(offlineId, self.offlineIds.last)
            dSExpectation.fulfill()
        })
        
        wait(for: [dSExpectation], timeout: 5)
    }
    
    func testEventsWithOfflineId() {
        let dSExpectation = expectation(description: "Wait for event data source")
        
        eventDataSource?.events(offlineId: self.offlineIds.last!, completion: { events in
            XCTAssertEqual(events.count, 1)
            dSExpectation.fulfill()
        })
        
        wait(for: [dSExpectation], timeout: 5)
    }
    
    func testDeleteEventsWithOfflineId() {
        let dSExpectation = expectation(description: "Wait for event data source")
        
        eventDataSource?.deleteEvents(offlineId: self.offlineIds.last!, completion: {
            self.eventDataSource?.allEvents(completion: { events in
                XCTAssertEqual(events.count, self.offlineIds.count - 1)
                dSExpectation.fulfill()
            })
        })
        
        wait(for: [dSExpectation], timeout: 5)
    }
}
