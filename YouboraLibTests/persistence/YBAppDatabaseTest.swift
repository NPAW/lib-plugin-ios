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
    }
    
    func testInsert() {
        let event = YBEvent(id: 0, jsonEvents: "jsonEvents", dateUpdate: 0, offlineId: 0)
        do {
            let id = try YBAppDatabase.shared.insertEvent(event)
            XCTAssertNotEqual(id, -1)
        } catch {
            XCTFail()
        }
        
    }
}
