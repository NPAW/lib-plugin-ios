//
//  YBLocationParser.swift
//  YouboraLib
//
//  Created by Tiago Pereira on 25/02/2020.
//  Copyright © 2020 NPAW. All rights reserved.
//

import Foundation

@objcMembers public class YBLocationParser: NSObject, YBResourceParser {
    var resource: String?
    
    public func isSatisfied(resource: String?, manifest: Data?) -> Bool {
        guard let resource = resource,
            resource != "" else {
                return false
        }
        self.resource = resource
        return true
    }
    
    public func getRequestSource() -> String? {
        return self.resource
    }
    
    public func parseResource(data: Data?, response: HTTPURLResponse?, listenerParents: [String: AnyObject]?) -> String? {
        guard let response = response else {
            return nil
        }
        
        return response.allHeaderFields["Location"] as? String
    }
    
    public func parseTransportFormat(data: Data?, response: HTTPURLResponse?, listenerParents: [String: AnyObject]?, userDefinedTransportFormat: String?) -> String? {
        return nil
    }
}
