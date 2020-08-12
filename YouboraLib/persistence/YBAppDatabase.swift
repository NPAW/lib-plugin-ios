//
//  YBAppDatabase.swift
//  YouboraLib iOS
//
//  Created by Tiago Pereira on 02/05/2020.
//  Copyright © 2020 NPAW. All rights reserved.
//

import Foundation
import SQLite3

@objcMembers public class YBAppDatabase: NSObject {
    let filename: String
    private var isDbOpened: Bool
    private var database: OpaquePointer?
    
    static let shared = YBAppDatabase(dbFilename: "youbora-offline.db")
    
    init(dbFilename: String) {
        self.filename = dbFilename
        self.isDbOpened = false
        
        super.init()
        self.createDatabase(filename: dbFilename)
        
    }
    
    @discardableResult func createDatabase(filename: String) -> Bool {
        let writableDBPath = self.writableDBPath(dbName: filename)
        self.database = nil
        self.isDbOpened = false
        
        if FileManager.default.fileExists(atPath: writableDBPath) {
            return true
        }
        
        if let range = writableDBPath.range(of: filename) {
            let path = writableDBPath.replacingCharacters(in: range, with: "")
            do {
                try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
                if !FileManager.default.createFile(atPath: writableDBPath, contents: nil, attributes: nil) {
                    return  false
                }
            } catch {
                return false
            }
        }
        
        guard let uft8DBpath = self.toUtf8(string: writableDBPath) ,
            let createCommand = self.toUtf8(string: YBEventQueries.createTable) else {
                return false
        }
        
        let result = sqlite3_open_v2(uft8DBpath, &database, SQLITE_OPEN_READWRITE|SQLITE_OPEN_FULLMUTEX|SQLITE_OPEN_CREATE, nil)
        
        if result == SQLITE_OK {
            sqlite3_exec(database, createCommand, nil, nil, nil)
            if #available(iOS 8.2, *) {
                sqlite3_close_v2(database)
            } else {
                sqlite3_close(database)
            }
            return true
        } else {
            return false
        }
    }
    
    func writableDBPath(dbName: String) -> String {
        let pahts = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = pahts[0]
        return documentsDirectory+"/"+dbName
    }
    
    @discardableResult func insertEvent(offlineId: Int, jsonEvents: String) throws -> Int {
        if self.openDB() {
            var statement: OpaquePointer?
            let timestamp = String(format: "%.0f", round(CFAbsoluteTimeGetCurrent()*1000))
            
            // preparing a query compiles the query so it can be re-used.
            if let createQuery = self.toUtf8(string: YBEventQueries.create),
                let jsonEvents = self.toUtf8(string: jsonEvents) {
                sqlite3_prepare_v2(database, createQuery, -1, &statement, nil)
                
                let SQLITE_STATIC = unsafeBitCast(0, to: sqlite3_destructor_type.self)
                sqlite3_bind_text(statement, 1, jsonEvents, -1, SQLITE_STATIC)
                
                if let timestampDouble = Double(timestamp) {
                    sqlite3_bind_double(statement, 2, timestampDouble)
                    sqlite3_bind_int64(statement, 3, sqlite3_int64(offlineId))
                }
            }
            // process result
            if sqlite3_step(statement) != SQLITE_DONE {
                YBSwiftLog.error("SQLite database error: %s", sqlite3_errmsg(database))
            }
            
            let lastId = sqlite3_last_insert_rowid(database)
            sqlite3_finalize(statement)
            self.closeDB()
            
            return Int(lastId)
        }
        
        self.closeDB()
        return -1
    }
    
    func allEvents() throws -> [YBEvent] {
        var events: [YBEvent] = []
        
        if self.openDB() {
            guard let sqlStatement = self.toUtf8(string: YBEventQueries.getAll) else {
                return events
            }
            
            var compiledStatement: OpaquePointer?
            
            let result = sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, nil)
            
            if result == SQLITE_OK {
                while sqlite3_step(compiledStatement) == SQLITE_ROW {
                    if let jsonEvents = self.toUtf8(string: String(cString: sqlite3_column_text(compiledStatement, 1))) {
                        events.append(
                            YBEvent(
                                id: Int(sqlite3_column_int(compiledStatement, 0)),
                                jsonEvents: jsonEvents,
                                dateUpdate: sqlite3_column_double(compiledStatement, 2),
                                offlineId: Int(sqlite3_column_int(compiledStatement, 3))
                            )
                        )
                    }
                }
                sqlite3_reset(compiledStatement)
            } else {
                YBSwiftLog.error("Prepare-error #%li: %s", result, sqlite3_errmsg(database))
            }
            sqlite3_finalize(compiledStatement)
        }
        self.closeDB()
        
        return events
    }
    
    func firstId() throws -> Int {
        if self.openDB() {
            guard let sqlStatement = self.toUtf8(string: YBEventQueries.getFirstId) else {
                return 0
            }
            
            var compiledStatement: OpaquePointer?
            let result = sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, nil)
            
            if result == SQLITE_OK {
                while sqlite3_step(compiledStatement) == SQLITE_ROW {
                    let eventId = sqlite3_column_int(compiledStatement, 0)
                    sqlite3_finalize(compiledStatement)
                    self.closeDB()
                    return Int(eventId)
                }
                sqlite3_reset(compiledStatement)
                sqlite3_finalize(compiledStatement)
            } else {
                YBSwiftLog.error("Prepare-error #%li: %s", result, sqlite3_errmsg(database))
            }
        }
        
        return 0
    }
    
    func lastId() throws -> Int {
        if self.openDB() {
            guard let sqlStatement = self.toUtf8(string: YBEventQueries.getLastId) else {
                return 0
            }
            
            var compiledStatement: OpaquePointer?
            let result = sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, nil)
            
            if result == SQLITE_OK {
                while sqlite3_step(compiledStatement) == SQLITE_ROW {
                    let eventId = sqlite3_column_int(compiledStatement, 0)
                    sqlite3_finalize(compiledStatement)
                    self.closeDB()
                    return Int(eventId)
                }
                sqlite3_reset(compiledStatement)
            } else {
                YBSwiftLog.error("Prepare-error #%li: %s", result, sqlite3_errmsg(database))
            }
        }
        
        return 0
    }
    
    func eventsWith(offlineId: Int) throws -> [YBEvent] {
        var events: [YBEvent] = []
        
        if self.openDB() {
            guard let sqlStatement = self.toUtf8(string: String(format: YBEventQueries.getByOfflineId, offlineId)) else {
                return events
            }
            
            var compiledStatement: OpaquePointer?
            
            let result = sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, nil)
            
            if result == SQLITE_OK {
                sqlite3_bind_int(compiledStatement, 0, Int32(offlineId))
                
                while sqlite3_step(compiledStatement) == SQLITE_ROW {
                    if let jsonEvents = self.toUtf8(string: String(cString: sqlite3_column_text(compiledStatement, 1))) {
                        events.append(
                            YBEvent(
                                id: Int(sqlite3_column_int(compiledStatement, 0)),
                                jsonEvents: jsonEvents,
                                dateUpdate: sqlite3_column_double(compiledStatement, 2),
                                offlineId: Int(sqlite3_column_int(compiledStatement, 3))
                            )
                        )
                    }
                }
                sqlite3_reset(compiledStatement)
                sqlite3_finalize(compiledStatement)
            } else {
                YBSwiftLog.error("Prepare-error #%li: %s", result, sqlite3_errmsg(database))
            }
        }
        self.closeDB()
        
        return events
    }
    
    func removeEventsWith(eventId: Int) throws {
        if self.openDB() {
            var statement: OpaquePointer?
            
            guard let deleteByEventId = self.toUtf8(string: String(format: YBEventQueries.deleteEventsByOfflineId, eventId)) else {
                return
            }
            
            // preparing a query compiles the query so it can be re-used.
            sqlite3_prepare_v2(database, deleteByEventId, -1, &statement, nil)
            
            // process result
            if sqlite3_step(statement) != SQLITE_DONE {
                YBSwiftLog.error("SQLite database error: %s", sqlite3_errmsg(database))
            }
            sqlite3_reset(statement)
            sqlite3_finalize(statement)
        }
        self.closeDB()
    }
    
    private func toUtf8(string: String?) -> String? {
        guard let data = string?.data(using: .utf8),
            let utf8String = String(data: data, encoding: .utf8) else {
                return nil
        }
        
        return utf8String
    }
    
    private func openDB() -> Bool {
        sqlite3_initialize()
        
        if !self.isDbOpened {
            guard let path = self.toUtf8(string:self.writableDBPath(dbName: self.filename)) else {
                return self.isDbOpened
            }
            
            let result = sqlite3_open_v2(path, &database, SQLITE_OPEN_READWRITE|SQLITE_OPEN_FULLMUTEX, nil)
            if result == SQLITE_OK {
                self.isDbOpened = true
            } else {
                YBSwiftLog.error("SQLite database error: %s", sqlite3_errmsg(database))
            }
        }
        
        return self.isDbOpened
    }
    
    private func closeDB() {}
}
