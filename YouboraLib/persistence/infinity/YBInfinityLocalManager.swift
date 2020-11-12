//
//  YBInfinityLocalManager.swift
//  YouboraLib iOS
//
//  Created by Tiago Pereira on 04/05/2020.
//  Copyright © 2020 NPAW. All rights reserved.
//

import Foundation

@objcMembers public class YBInfinityLocalManager: NSObject {
    
    /**
    * Saves new session id on <NSUserDefaults>
    * @param sessionId sessionId to save
    */
    public static func saveSession(sessionId: String) {
        UserDefaults.standard.set(sessionId, forKey: YBConstants.preferencesSessionIdKey)
    }
    
    /**
    * Gets saved session id on <NSUserDefaults>
    * @return session id to save
    */
    public static func getSessionId() -> String? {
        return UserDefaults.standard.value(forKey: YBConstants.preferencesSessionIdKey) as? String
    }
    
    /**
    * Saves new context on <NSUserDefaults>
    * @param context to save
    */
    public static func saveContext(context: String) {
        UserDefaults.standard.set(context, forKey: YBConstants.preferencesContextKey)
    }
    
    /**
    * Gets saved context on <NSUserDefaults>
    * @return context to save
    */
    public static func getContext() -> String? {
        return UserDefaults.standard.value(forKey: YBConstants.preferencesContextKey) as? String
    }
    
    /**
    * Saves timestamp of last event sent on <NSUserDefaults>
    */
    public static func saveLastActiveDate() {
        UserDefaults.standard.set(NSNumber(value: YBChrono().now), forKey: YBConstants.preferencesLastActiveKey)
    }
    
    /**
    * Gets saved timestamp on <NSUserDefaults>
    * @return context to save
    */
    public static func getLastActive() -> NSNumber? {
        return UserDefaults.standard.value(forKey: YBConstants.preferencesLastActiveKey) as? NSNumber
    }
    
    /**
    * Method that will clean all data in the user defaults realtive with
    * infinity local manager
    */
    public static func cleanLocalManager() {
        DispatchQueue.main.async {
            UserDefaults.standard.removeObject(forKey: YBConstants.preferencesSessionIdKey)
            UserDefaults.standard.removeObject(forKey: YBConstants.preferencesContextKey)
            UserDefaults.standard.removeObject(forKey: YBConstants.preferencesLastActiveKey)
            UserDefaults.standard.synchronize()
        }
    }
}
