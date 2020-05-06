//
//  YBEventQueries.swift
//  YouboraLib iOS
//
//  Created by Tiago Pereira on 02/05/2020.
//  Copyright © 2020 NPAW. All rights reserved.
//

import Foundation

@objcMembers class YBEventQueries:NSObject {
    static let createTable = "CREATE TABLE `Event` (`uid` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, `json_events` TEXT, `date_update` INTEGER, `offline_id` INTEGER NOT NULL);"
    static let create = "INSERT INTO Event(json_events,date_update,offline_id) values (?,?,?)"
    static let getAll = "SELECT * FROM Event"
    static let getLastId = "Select offline_id from Event ORDER BY offline_id DESC LIMIT 1 "
    static let getFirstId = "Select offline_id from Event ORDER BY offline_id ASC LIMIT 1"
    static let getByOfflineId = "Select * from Event where offline_id = %d"
    static let deleteEventsByOfflineId = "Delete from Event where offline_id = %d"
}
