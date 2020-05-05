//
//  YBEventDAO.swift
//  YouboraLib iOS
//
//  Created by Tiago Pereira on 04/05/2020.
//  Copyright © 2020 NPAW. All rights reserved.
//

import Foundation

@objcMembers class YBEventDAO: NSObject {

    
    func events(offlineId: Int) -> [YBEvent] {
        
    }
    
    func deleteEvents(offlineId: Int) {
        do {
            return try YBAppDatabase.shared.removeEventsWith(eventId: offlineId)
        } catch {
            YBSwiftLog.error(error.localizedDescription)
        }
    }
}
