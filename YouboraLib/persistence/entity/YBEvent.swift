//
//  YBEvent.swift
//  YouboraLib iOS
//
//  Created by Tiago Pereira on 02/05/2020.
//  Copyright © 2020 NPAW. All rights reserved.
//

import Foundation

@objcMembers class YBEvent: NSObject {
    let id: Int
    let jsonEvents: String
    let dateUpdate: Double
    let offlineId: Int
    
    init(id: Int, jsonEvents: String, dateUpdate: Double, offlineId: Int) {
        self.id = id
        self.jsonEvents = jsonEvents
        self.dateUpdate = dateUpdate
        self.offlineId = offlineId
    }
}
