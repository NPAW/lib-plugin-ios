//
//  YBAppDatabaseTest.swift
//  YouboraLib
//
//  Created by Tiago Pereira on 05/05/2020.
//  Copyright © 2020 NPAW. All rights reserved.
//

import XCTest

class YBAppDatabaseTest: XCTestCase {

    let dbPath = YBAppDatabase.shared.writableDBPath(dbName: YBAppDatabase.shared.filename)
    
    override func setUp() {
        do {
            try FileManager.default.removeItem(atPath: dbPath)
        } catch { }
    }
    
    func testCreation() {
        XCTAssertFalse(FileManager.default.fileExists(atPath: dbPath))
        XCTAssertTrue(YBAppDatabase.shared.createDatabase(filename: YBAppDatabase.shared.filename))
        XCTAssertTrue(FileManager.default.fileExists(atPath: dbPath))
        XCTAssertTrue(YBAppDatabase.shared.createDatabase(filename: YBAppDatabase.shared.filename))
    }
    
    func testInsert() {
        let offlineIDTest = 1234
        let jsonEventsTest = "jsonEvents"
        
        XCTAssertTrue(YBAppDatabase.shared.createDatabase(filename: YBAppDatabase.shared.filename))
        
        do {
            let id = try YBAppDatabase.shared.insertEvent(offlineId: offlineIDTest, jsonEvents: jsonEventsTest)
            XCTAssertNotEqual(id, -1)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testFirsAndLasttEvent() {
        let offlineIds = [1234, 123455, 1234556]
        
        XCTAssertTrue(YBAppDatabase.shared.createDatabase(filename: YBAppDatabase.shared.filename))
        
        do {
            for i in 0...offlineIds.count - 1 {
                 _ = try YBAppDatabase.shared.insertEvent(offlineId: offlineIds[i], jsonEvents: "jsonEvents")
            }
           
            XCTAssertEqual(try YBAppDatabase.shared.firstId(), offlineIds.first)
            XCTAssertEqual(try YBAppDatabase.shared.lastId(), offlineIds.last)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testEventsWithId() {
        let offlineIds = [1234, 123455, 1234556]
        
        var resultIds: [Int] = []
        
        XCTAssertTrue(YBAppDatabase.shared.createDatabase(filename: YBAppDatabase.shared.filename))
        
        do {
            for i in 0...offlineIds.count - 1 {
                resultIds.append(try YBAppDatabase.shared.insertEvent(offlineId: offlineIds[i], jsonEvents: "jsonEvents"))
            }
           
            let eventsWithId = try YBAppDatabase.shared.eventsWith(offlineId: offlineIds[0])
            
            XCTAssertEqual(eventsWithId.count, 1)
            
            if eventsWithId.count > 0 {
                XCTAssertEqual(eventsWithId[0].id, resultIds[0])
                XCTAssertEqual(eventsWithId[0].offlineId, offlineIds[0])
            }
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testAllEvents() {
        let offlineIds = [1234, 123455, 1234556]
        
        var resultIds: [Int] = []
        
        XCTAssertTrue(YBAppDatabase.shared.createDatabase(filename: YBAppDatabase.shared.filename))
        
        do {
            for i in 0...offlineIds.count - 1 {
                resultIds.append(try YBAppDatabase.shared.insertEvent(offlineId: offlineIds[i], jsonEvents: "jsonEvents"))
            }
           
            let events = try YBAppDatabase.shared.allEvents()
            
            XCTAssertEqual(events.count, offlineIds.count)
            
            for i in 0...offlineIds.count - 1 {
                XCTAssertEqual(events[i].id, resultIds[i])
                XCTAssertEqual(events[i].offlineId, offlineIds[i])
            }
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testRemoveEvents() {
        let offlineIds = [1234, 123455, 1234556]
        
        var resultIds: [Int] = []
        
        XCTAssertTrue(YBAppDatabase.shared.createDatabase(filename: YBAppDatabase.shared.filename))
        
        do {
            for i in 0...offlineIds.count - 1 {
                resultIds.append(try YBAppDatabase.shared.insertEvent(offlineId: offlineIds[i], jsonEvents: "jsonEvents"))
            }
            
            XCTAssertEqual(try YBAppDatabase.shared.allEvents().count, 3)
           
            try YBAppDatabase.shared.removeEventsWith(eventId: offlineIds[0])
            XCTAssertEqual(try YBAppDatabase.shared.allEvents().count, 2)
            XCTAssertEqual(try YBAppDatabase.shared.eventsWith(offlineId: offlineIds[0]).count, 0)
            
            try YBAppDatabase.shared.removeEventsWith(eventId: offlineIds[1])
            XCTAssertEqual(try YBAppDatabase.shared.allEvents().count, 1)
            XCTAssertEqual(try YBAppDatabase.shared.eventsWith(offlineId: offlineIds[1]).count, 0)
            
            try YBAppDatabase.shared.removeEventsWith(eventId: offlineIds[2])
            XCTAssertEqual(try YBAppDatabase.shared.allEvents().count, 0)
            XCTAssertEqual(try YBAppDatabase.shared.eventsWith(offlineId: offlineIds[2]).count, 0)
       
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
}
