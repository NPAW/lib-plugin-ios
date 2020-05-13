//
//  YBResourceParser.swift
//  YouboraLib
//
//  Created by Tiago Pereira on 25/02/2020.
//  Copyright © 2020 NPAW. All rights reserved.
//

import Foundation

/**
   Generic protocol to be implemented in the several resource parsers, basically checks if the resource
    is valid, build a url to be used in a network request and finally parse the data coming from that network request
    to obtain the final resource
*/
@objc public protocol YBResourceParser {
    /**
    Receive a resource and check if it is compatible with the parser case yes save it

    - Parameter resource: String with the resource to check compatibility
    - Parameter manifest: Data data from the request
    - Returns: Boolean indicating if this resource is compatible or not with parser
    */
    @objc func isSatisfied(resource: String?, manifest: Data?) -> Bool
    
    /**
    Return the url or the resource that needs to be parsed. Generally called to do the url request
     it return nil case no resource or case resource is invalid
     
    - Returns: String with url for the resource to be parsed or nil
    */
    @objc func getRequestSource() -> String?
    
    /**
    Receive all the data from a normal network request and try to parse this into the final resource
     and returns it
     
     - Parameter data: Data coming from the network request
     - Parameter response: HTTPURLResponse coming from the network request
     - Parameter listenerParents: Dictionary with listenerParents coming from the network request
     
    - Returns: String nil case no new resource found or invalid data or a new resource case any new was found
    */
    @objc func parseResource(data: Data?, response: HTTPURLResponse?, listenerParents: [String: AnyObject]?) -> String?
    
    /**
       Receive all the data from a normal network request and try to parse this to get transport format, it will check
        if the transport format was already defined by the user and case it didn't it'll try to auto detect it
        
        - Parameter data: Data coming from the network request
        - Parameter response: HTTPURLResponse coming from the network request
        - Parameter listenerParents: Dictionary with listenerParents coming from the network request
        - Parameter userDefinedTransportFormat: String with transport format defined by the user
       - Returns: String nil case user already defined the transport format or transport format in the manifest
       */
       @objc func parseTransportFormat(data: Data?, response: HTTPURLResponse?, listenerParents: [String: AnyObject]?, userDefinedTransportFormat: String?) -> String?
}
