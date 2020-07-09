//
//  YBRequest.swift
//  YouboraLib
//
//  Created by Tiago Pereira on 03/07/2020.
//  Copyright © 2020 NPAW. All rights reserved.
//

import Foundation
#if os(iOS)
import UIKit
#endif

/**
* Type of the success closure
*
*  - data: (Data *) the data as returned by the completionHandler.
*  - response: (URLResponse *) the response as returned by the completionHandler.
*/
@objcMembers public class YBRequestSuccess: NSObject {
    let closure: (_ data: Data, _ response: URLResponse, _ listenerParams: NSMutableDictionary) -> Void
    
    init(closure: @escaping (_ data: Data, _ response: URLResponse, _ listenerParams: NSMutableDictionary) -> Void) {
        self.closure = closure
    }
}

/**
* Type of the error block
*
*  - error: (Error *) error as returned by the completionHandler.
*/
@objcMembers public class YBRequestError: NSObject {
    let closure: (_ error: Error) -> Void
    
    init(closure: @escaping (_ error: Error) -> Void) {
        self.closure = closure
    }
}

/**
* Class with all the http methods used by Youbora
*/
@objcMembers class YouboraHTTPMethod: NSObject {
    static let get = "GET"
    static let post = "POST"
    static let head = "HEAD"
    static let put = "PUT"
    static let delete = "DELETE"
    static let trace = "TRACE"
}

@objcMembers class YBRequest: NSObject {
    /// The host where the YBRequest is performed to
    var host: String

    /// The service. This will be the "/something" part of the url.
    /// For instance the "/start" in "a-fds.youborafds01.com/start"
    var service: String?

    /// NSDictionary with params to add to the http request
    var params: NSMutableDictionary?

    /// NSDictionary with Request Headers to add to the http request
    var requestHeaders: [ String: String]?

    /// The retry interval for this request. In milliseconds. The default value is 5000.
    let retryInterval: UInt

    /// The number of retries for this request. The default value is 3.
    var maxRetries: UInt

    /// Method of the HTTP request. Default is <YouboraHTTPMethodGet>
    var method: String

    /// In case of wanting some params back. Default empty
    var listenerParams: NSMutableDictionary

    /// Request body in case of being method POST
    var body: String
    
    /// Closure to indicate success request
    fileprivate var successListenerList: [YBRequestSuccess?]
    
    /// Closure to indicate error on request
    fileprivate var errorListenerList: [YBRequestError?]
    
    fileprivate static var everySuccessListenerList: [YBRequestSuccess]?
    fileprivate static var everyErrorListenerList: [YBRequestError]?
    
    lazy var userAgent:String = {
        
        // Get machine name
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let machine = machineMirror.children.reduce("") { identifier, element in
          guard let value = element.value as? Int8, value != 0 else { return identifier }
          return identifier + String(UnicodeScalar(UInt8(value)))
        }

        var builtUserAgent: String?
        
        #if os(iOS)
        let device = UIDevice.current

        if let object = Bundle.main.infoDictionary?["CFBundleName"],
            let object1 = Bundle.main.infoDictionary?["CFBundleShortVersionString"] {
            builtUserAgent = "\(object)/\(object1)/\(device.model)/\(machine)/\(device.systemVersion)"
        }
        #else

        var size = 0
        sysctlbyname("hw.model", nil, &size, nil, 0)
        var modelName = [CChar](repeating: 0,  count: size)
        sysctlbyname("hw.model", &modelName, &size, nil, 0)

        let machineName = String(cString: modelName)

        if let object = Bundle.main.infoDictionary?["CFBundleName"],
            let object1 = Bundle.main.infoDictionary?["CFBundleShortVersionString"] {
            builtUserAgent = "\(object)/\(object1)/Mac/\(machineName)/\(ProcessInfo.processInfo.operatingSystemVersion)"
        }


        #endif
        
        guard let tmpBuiltUserAgent = builtUserAgent else {
            return ""
        }
        
        let mutableString = NSMutableString(string: tmpBuiltUserAgent) as CFMutableString
        
        CFStringTransform(mutableString, nil, kCFStringTransformToLatin, false) // transform to latin chars
        CFStringTransform(mutableString, nil, kCFStringTransformStripCombiningMarks, false) // get rid of diacritical signs

        return tmpBuiltUserAgent
    }()
    
    /// indicates the number of times that YBRequest tried to do a request
    var pendingAttemps: UInt

    init(host: String, service: String?) {
        self.host = host
        self.service = service
        self.maxRetries = 3
        self.retryInterval = 5000
        self.body = ""
        self.listenerParams = [:]
        self.method = YouboraHTTPMethod.get
        self.pendingAttemps = 0
        self.successListenerList = Array<YBRequestSuccess?>(repeating: nil, count: 1)
        self.errorListenerList = Array<YBRequestError?>(repeating: nil, count: 1)
    }
    
    /**
    * Sends this Request over the network.
    */
    public func send() {
        self.pendingAttemps = self.maxRetries+1
        self.sendRequest()
    }
    
    /**
    * Builds the url. It consists of the following: <host> + <service> + query params
    * @returns the full query url
    */
    
    public func getUrl() -> URL? {
        var components = URLComponents(string: self.host)
        
        if let service = self.service {
            components?.path = service
        }
        
        if let params = self.params {
            components?.queryItems = params.compactMap { (key: Any, value: Any) -> URLQueryItem? in
                guard let key = key as? String, let value = value as? String else {
                    return nil
                }
                return URLQueryItem(name: key, value: value)
            }
            
            let percentageEncodedQuery = components?.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B").replacingOccurrences(of: "%20", with: "+")
            
            components?.percentEncodedQuery = percentageEncodedQuery
            
        }
        
        return components?.url
    }
    
    /**
     * Sets one key-value pair onto the params
     * @param key param key
     * @param value param value
     */
    public func setParam(_ value: String, _ key: String) {
        if self.params == nil {
            self.params = [:]
        }
        
        self.params?[key] = value
    }
    
    /**
     * Returns the param value for the given key
     * @param key the key for the desired value
     * @returns the param value
     */
    
    public func getParam(key: String) -> String? {
        return params?[key] as? String
    }
    
    private func sendRequest() {
        guard let url = self.getUrl() else {
                return
        }
        
        self.pendingAttemps -= 1
        
        var request = URLRequest(url: url)
        if YBSwiftLog.isAtLeastLevel(.verbose) {
            YBSwiftLog.requestLog("XHR Req: %@", url.absoluteString)
            if self.body != "" && self.method == YouboraHTTPMethod.post {
                YBSwiftLog.debug("Req body: %@", self.body)
            }
        }
        
        // Set request headers if any
        request.allHTTPHeaderFields = self.requestHeaders
        
        request.httpMethod = self.method
        
        if self.body != "" && self.method == YouboraHTTPMethod.post {
            request.httpBody = self.body.data(using: .utf8)
        }
        
        request.addValue(self.getUserAgent(), forHTTPHeaderField: "User-Agent")
        
        // Send request
        URLSession.shared.dataTask(with: request) {[weak self] (data, response, error) in
            guard let strongSelf = self else {
                YBSwiftLog.error("YBRequest instance has been deallocated while waiting for completion handler")
                return
            }
            
            if let response = response as? HTTPURLResponse,
                let service = strongSelf.service{
                YBSwiftLog.debug("Response code for: %@ %ld", service, response.statusCode)
            }
            
            if let error = error {
                self?.didFail(error: error)
            } else {
                self?.didSucceed(data: data, response: response)
            }
        }.resume()
    }
    
    /**
    * Builds a string with the User-Agent header content.
    *
    * This method will also normalize the user agent string. With "normalize"
    * we mean to convert the user-agent string to latin chars with no diacritic
    * signs Normalization could be necessary when the app bundle has non-latin
    * chars. It's been observed that, with Japanese characters, the User-Agent
    * header was arriving empty to the backend
    * @returns The User-Agent built string.
    */
    
    private func getUserAgent() -> String {
        return self.userAgent
    }
    
    private func didSucceed(data: Data?, response: URLResponse?) {
        guard let data = data,
            let response = response else {
                return
        }
        
        for successListener in self.successListenerList {
            successListener?.closure(data, response, self.listenerParams)
        }
    }
    
    private func didFail(error: Error) {
        for errorListener in self.errorListenerList {
            errorListener?.closure(error)
        }
        
        if self.pendingAttemps > 0 {
            if let service = self.service {
                YBSwiftLog.warn("Request \"%@\" failed. Retry %d of %d in %dms.", service, (self.maxRetries + 1 - self.pendingAttemps), self.maxRetries, self.retryInterval)
            }
            
            let deadlineTime = DispatchTime.now() + .seconds(Int(self.retryInterval))
            
            DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
                self.sendRequest()
            }
        } else {
            if let service = self.service {
                YBSwiftLog.error("Aborting failed request \"%@\". Max retries reached(%d)", service, self.maxRetries)
            }
        }
    }
    
    /**
     * Adds a success listener.
     * @param successBlock the listener to add.
     */
    public func addRequestSuccessListener(_ success: YBRequestSuccess) {
        if !self.successListenerList.contains(success) {
            self.successListenerList.append(success)
        }
    }
    
    /**
     * Removes a success listener
     * @param successBlock the listener ot remove
     */
    public func removeRequestSuccessListener(_ success: YBRequestSuccess) {
        if let index = self.successListenerList.index(of: success) {
            self.successListenerList.remove(at: index)
        }
    }
    
    /**
     * Adds an error listener. These listeners will be called for each failed retry. If you want to
     * implement you own retry management, do so here and <setMaxRetries:> to 0.
     * @param errorBlock the listener to add
     */
    public func addRequestErrorListener(_ error: YBRequestError) {
        if !self.errorListenerList.contains(error) {
            self.errorListenerList.append(error)
        }
    }
    /**
     * Remove an error listener
     * @param errorBlock the listener to remove
     */
    public func removeRequestErrorListener(_ error: YBRequestError) {
        if let index = self.errorListenerList.index(of: error) {
            self.errorListenerList.remove(at: index)
        }
    }
    
    /// ---------------------------------
    /// @name Static methods
    /// ---------------------------------
    /**
     * Adds a <b>global</b> success listener. These listeners will be called <b>for all the Requests</b>.
     * @param successBlock the global listener to add.
     */
    static public func addEveryRequestSuccessListener(_ success: YBRequestSuccess) {
        if var everySuccessListenerList = everySuccessListenerList {
            everySuccessListenerList.append(success)
        } else {
            everySuccessListenerList = Array(arrayLiteral: success)
        }
    }
    
    /**
     * Removes a global success listener.
     * @param successBlock the global listener to remove
     */
    static public func removeEveryRequestSuccessListener(_ success: YBRequestSuccess) {
        if let index = everySuccessListenerList?.index(of: success) {
            everySuccessListenerList?.remove(at: index)
        }
    }
    
    /**
     * Adds a <b>global</b> error listener. These listeners will be called <b>for all the Requests</b>.
     * @param errorBlock the global listener to add.
     */
    static public func addEveryRequestErrorListener(_ error: YBRequestError) {
        if var everyErrorListenerList = everyErrorListenerList {
            everyErrorListenerList.append(error)
        } else {
            everyErrorListenerList = Array(arrayLiteral: error)
        }
    }
    
    /**
     * Removes a global error listener.
     * @param errorBlock the global listener to remove
     */
    static public func removeEveryRequestErrorListener(_ error: YBRequestError) {
        if let index = everyErrorListenerList?.index(of: error) {
            everyErrorListenerList?.remove(at: index)
        }
    }
}
