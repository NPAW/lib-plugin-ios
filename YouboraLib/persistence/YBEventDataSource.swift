//
//  YBEventDataSource.swift
//  YouboraLib iOS
//
//  Created by Tiago Pereira on 04/05/2020.
//  Copyright © 2020 NPAW. All rights reserved.
//

import Foundation

@objcMembers class YBEventDataSource: NSObject {
    let eventDAO: YBEventDAO
    
    override init() {
        self.eventDAO = YBEventDAO()
    }
    
    func putNewEvent(_ event: YBEvent, completion: (() -> Void)? ) {
        DispatchQueue.global(qos: .background).async {
            autoreleasepool {
                self.eventDAO.insertNewEvent(event)
                 completion?()
            }
        }
    }
    
    func allEvents(completion: @escaping ([YBEvent]) -> Void) {
        DispatchQueue.global(qos: .background).async {
            autoreleasepool {
                completion(self.eventDAO.allEvents())
            }
        }
    }
    
    func lastId(completion: @escaping (Int) -> Void) {
        DispatchQueue.global(qos: .background).async {
            autoreleasepool {
                completion(self.eventDAO.lastOfflineId())
            }
        }
    }
    
    func events(offlineId: Int, completion: @escaping ([YBEvent]) -> Void) {
        DispatchQueue.global(qos: .background).async {
            autoreleasepool {
                completion(self.eventDAO.events(offlineId: offlineId))
            }
        }
    }
    
    func firstId(completion: @escaping (Int) -> Void) {
        DispatchQueue.global(qos: .background).async {
            autoreleasepool {
                completion(self.eventDAO.firstOfflineId())
            }
        }
    }
    
    func deleteEvents(offlineId: Int, completion: @escaping () -> Void) {
        DispatchQueue.global(qos: .background).async {
            autoreleasepool {
                self.eventDAO.deleteEvents(offlineId: offlineId)
                completion()
            }
        }
    }
}
