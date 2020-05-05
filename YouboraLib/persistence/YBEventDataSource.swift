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
    
    func putNewEvent(_ id: Int, jsonEvents: String, completion: (() -> Void)? ) {
        DispatchQueue.global(qos: .background).async {
            autoreleasepool {
               do {
                   try YBAppDatabase.shared.insertEvent(id, jsonEvents: jsonEvents)
                } catch {
                    YBSwiftLog.error(error.localizedDescription)
                }
                 completion?()
            }
        }
    }
    
    func allEvents(completion: @escaping ([YBEvent]) -> Void) {
        DispatchQueue.global(qos: .background).async {
            autoreleasepool {
                do {
                    completion(try YBAppDatabase.shared.allEvents())
                    return
                } catch {
                    YBSwiftLog.error(error.localizedDescription)
                }
                completion([])
            }
        }
    }
    
    func firstId(completion: @escaping (Int) -> Void) {
         DispatchQueue.global(qos: .background).async {
             autoreleasepool {
                 do {
                     completion(try YBAppDatabase.shared.firstId())
                     return
                 } catch {
                     YBSwiftLog.error(error.localizedDescription)
                 }
                 completion(0)
             }
         }
     }
    
    func lastId(completion: @escaping (Int) -> Void) {
        DispatchQueue.global(qos: .background).async {
            autoreleasepool {
                do {
                    completion(try YBAppDatabase.shared.lastId())
                    return
                } catch {
                    YBSwiftLog.error(error.localizedDescription)
                }
                
                completion(0)
            }
        }
    }
    
    func events(offlineId: Int, completion: @escaping ([YBEvent]) -> Void) {
        DispatchQueue.global(qos: .background).async {
            autoreleasepool {
                do {
                    completion(try YBAppDatabase.shared.eventsWith(offlineId: offlineId))
                    return
                } catch {
                    YBSwiftLog.error(error.localizedDescription)
                }
                completion([])
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
