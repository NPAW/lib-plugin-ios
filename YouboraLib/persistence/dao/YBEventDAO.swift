//
//  YBEventDAO.swift
//  YouboraLib iOS
//
//  Created by Tiago Pereira on 04/05/2020.
//  Copyright © 2020 NPAW. All rights reserved.
//

import Foundation

@objcMembers class YBEventDAO: NSObject {
    func insertNewEvent(_ event: YBEvent) {
        do {
           try YBAppDatabase.shared.insertEvent(event)
        } catch {
            YBSwiftLog.error(error.localizedDescription)
        }
    }
    
    func allEvents() -> [YBEvent] {
        do {
           return try YBAppDatabase.shared.allEvents()
        } catch {
            YBSwiftLog.error(error.localizedDescription)
        }
        return []
    }
    
    func lastOfflineId() -> Int {
        do {
           return try YBAppDatabase.shared.lastId()
        } catch {
            YBSwiftLog.error(error.localizedDescription)
        }
        return 0
    }
    
    func firstOfflineId() -> Int {
        do {
           return try YBAppDatabase.shared.firstId()
        } catch {
            YBSwiftLog.error(error.localizedDescription)
        }
        return 0
    }
    
    func events(offlineId: Int) -> [YBEvent] {
        do {
           return try YBAppDatabase.shared.eventsWith(offlineId: offlineId)
        } catch {
            YBSwiftLog.error(error.localizedDescription)
        }
        return []
    }
    
    func deleteEvents(offlineId: Int) {
        do {
            return try YBAppDatabase.shared.removeEventsWith(eventId: offlineId)
        } catch {
            YBSwiftLog.error(error.localizedDescription)
        }
    }
}
