//
//  YBSwiftRequest.swift
//  YouboraLib
//
//  Created by Enrique Alfonso Burillo on 04/02/2020.
//  Copyright © 2020 NPAW. All rights reserved.
//

#if os(OSX)
import Cocoa
#else
import UIKit
#endif

@objcMembers open class YouboraHTTPMethod {
    static public let get = "GET"
    static public let post = "POST"
    static public let head = "HEAD"
    static public let options = "OPTIONS"
    static public let put = "PUT"
    static public let delete = "DELETE"
    static public let trace = "TRACE"
}

/**
* Type of the success block
*
*  - data: (Data) the data as returned by the completionHandler.
*  - response: (URLResponse) the response as returned by the completionHandler.
* - listenerParams: ([String: Any]) dictionary that will be returned with some custom value set on success
*/
public typealias SwiftRequestSuccessBlock = (_ data: Data?, _ response: URLResponse?, _ listenerParams: [String: Any]?) -> Void

/**
* Type of the error block
*
*  - error: (Error) error as returned by the completionHandler.
*/
public typealias SwiftRequestErrorBlock = (_ error: Error?) -> Void

@objcMembers open class YBSwiftRequest {

    var host: String?
    var service: String?
    var params = [String: String?](minimumCapacity: 1)
    var requestHeaders: [String: String]?
    var retryInterval: UInt = 5000
    var maxRetries: UInt = 3
    var method: String = YouboraHTTPMethod.get
    var listenerParams = [String: Any](minimumCapacity: 1)
    var body: String = ""

    fileprivate var successListenerList = [SwiftRequestSuccessBlock]()
    fileprivate var errorListenerList = [SwiftRequestErrorBlock]()
    fileprivate var pendingAttemps: UInt = 0

    public static var everySuccessListenerList = [SwiftRequestSuccessBlock]()
    public static var everyErrorListenerList = [SwiftRequestErrorBlock]()

    private lazy var userAgent: String = {
        var size = 0

        // Set 'oldp' parameter to NULL to get the size of the data
        // returned so we can allocate appropriate amount of space
        sysctlbyname("hw.machine", nil, &size, nil, 0)

        var name = [CChar](repeating: 0, count: size)
        // Get the platform name
        sysctlbyname("hw.machine", &name, &size, nil, 0)

        // Place name into a string
        let machine = String(cString: name, encoding: .utf8) ?? ""

        let deviceBundleName = Bundle.main.infoDictionary?["CFBundleName"] ?? ""
        let deviceShortVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] ?? ""

        #if os(OSX)
        // Set 'oldp' parameter to NULL to get the size of the data
        // returned so we can allocate appropriate amount of space
        sysctlbyname("hw.machine", nil, &size, nil, 0)

        var modelName = [CChar](repeating: 0, count: size)
        // Get the platform name
        sysctlbyname("hw.machine", &modelName, &size, nil, 0)

        // Place name into a string
        let machineName = String(cString: name, encoding: .utf8)

        let builtUserAgent = String(format: "%@/%@/%@/%@/%@",
                                    deviceBundleName,
                                    deviceShortVersion,
                                    "Mac",
                                    machineName,
                                    ProcessInfo.processInfo.operatingSystemVersionString)
        #else
        let device = UIDevice.current

        let builtUserAgent = String(format: "%@/%@/%@/%@/%@",
                                    deviceBundleName as? String ?? "",
                                    deviceShortVersion as? String ?? "",
                                    device.model,
                                    machine,
                                    device.systemVersion)

        #endif

        var builtUserAgentNormalized = NSMutableString(string: builtUserAgent) as CFMutableString
        CFStringTransform(builtUserAgentNormalized, nil, kCFStringTransformToLatin, false)  // transform to latin chars
        CFStringTransform(builtUserAgentNormalized, nil, kCFStringTransformStripCombiningMarks, false)  // get rid of diacritical signs

        return String(builtUserAgentNormalized)
    }()

    convenience init() {
        self.init(nil, nil)
    }

    /// ---------------------------------
    /// @name Init
    /// ---------------------------------

    /**
     * YBRequest will generate the URL call.
     *
     * @param host String with the URL of the request. Example: a-fds.youborafds01.com
     * @param service String with the name of the service. Example: '/start'
     * @returns An instance of YBSwiftRequest
     */
    init(_ host: String?, _ service: String?) {
        self.host = host
        self.service = service
    }

    public func send() {
        self.pendingAttemps = self.maxRetries + 1
        self.sendRequest()
    }

    public func getUrl() -> URL? {

        guard let host = self.host else {
            YBSwiftLog.error("Host cannot be nil")
            return nil
        }

        var components = URLComponents(string: host)

        if let service = self.service {
            components?.path = service
        }

        if params.count > 0 {
            var queryItems = [URLQueryItem]()

            for(key, value) in params {
                if let value = value {
                    queryItems.append(URLQueryItem(name: key, value: value))
                }
            }
            components?.queryItems = queryItems
            if let percentEncodedFragment = components?.percentEncodedFragment {
                components?.percentEncodedFragment = percentEncodedFragment.replacingOccurrences(of: "+", with: "%2B").replacingOccurrences(of: "%20", with: "+")
            }
        }
        return components?.url
    }

    public func setParam(_ value: String?, forKey key: String) {
        guard let value = value else {
            return
        }

        self.params[key] = value
    }

    public func getParam(_ key: String) -> String? {
        if let param = self.params[key] {
            return param
        }
        return nil
    }

    // MARK: Static methods

    public func addRequestSuccessListener(successBlock: @escaping SwiftRequestSuccessBlock) -> Int {
        self.successListenerList.append(successBlock)
        return self.successListenerList.count - 1
    }

    public func removeRequestSuccessListener(position: Int) -> SwiftRequestSuccessBlock {
        return self.successListenerList.remove(at: position)
    }

    public func addRequestErrorListener(errorBlock: @escaping SwiftRequestErrorBlock) -> Int {
        self.errorListenerList.append(errorBlock)
        return self.errorListenerList.count - 1
    }

    public func removeRequestErrorListener(position: Int) -> SwiftRequestErrorBlock {
        return self.errorListenerList.remove(at: position)
    }

    public static func addEveryRequestSuccessListener(successBlock: @escaping SwiftRequestSuccessBlock) -> Int {
        self.everySuccessListenerList.append(successBlock)
        return self.everySuccessListenerList.count - 1
    }

    public static func removeEveryRequestSuccessListener(position: Int) -> SwiftRequestSuccessBlock {
        return self.everySuccessListenerList.remove(at: position)
    }

    public static func addEveryRequestErrorListener(errorBlock: @escaping SwiftRequestErrorBlock) -> Int {
        self.everyErrorListenerList.append(errorBlock)
        return self.everyErrorListenerList.count - 1
    }

    public static func removeEveryRequestErrorListener(position: Int) -> SwiftRequestErrorBlock {
        return self.everyErrorListenerList.remove(at: position)
    }

    // MARK: Private methods

    internal func createRequest(_ url: URL) -> URLRequest {
        return URLRequest(url: url)
    }

    private func sendRequest() {
        self.pendingAttemps -= 1

        guard let url = self.getUrl() else {
            YBSwiftLog.debug("Url cannot be nil")
            return
        }

        var request = self.createRequest(url)
        let hasBody = body != "" && self.method == YouboraHTTPMethod.post

        if let stringUrl = request.url?.absoluteString, YBSwiftLog.isAtLeastLevel(.verbose) {
            YBSwiftLog.requestLog("XHR Req: %@", stringUrl)
            if hasBody {
                YBSwiftLog.debug("Req body: %@", self.body)
            }
        }

        // Set request headers if any
        if let headers = self.requestHeaders, headers.count > 0 {
            request.allHTTPHeaderFields = headers
        }

        request.httpMethod = self.method

        if hasBody {
            request.httpBody = self.body.data(using: .utf8)
        }

        // User-agent
        request.setValue(self.userAgent, forHTTPHeaderField: "User-Agent")

        // Send request
        let session = URLSession.shared
        session.dataTask(with: request, completionHandler: { [weak self] (data, response, error) -> Void in
            guard let strongSelf = self else {
                YBSwiftLog.error("YBRequest instance has been deallocated while waiting for completion handler")
                return
            }

            if let response = response as? HTTPURLResponse {
                YBSwiftLog.debug("Response code for: %@ %d", strongSelf.service ?? "unknown", response.statusCode)
            }

            if let error = error {
                strongSelf.didFail(error)
            } else {
                strongSelf.didSucceed(data, response)
            }
        }).resume()
    }

    private func didSucceed(_ data: Data?, _ response: URLResponse?) {
        YBSwiftRequest.everySuccessListenerList.forEach({ item in
            item(data, response, self.listenerParams)
        })

        self.successListenerList.forEach({ item in
            item(data, response, self.listenerParams)
        })
    }

    private func didFail(_ error: Error) {
        YBSwiftRequest.everyErrorListenerList.forEach({ item in
            item(error)
        })

        self.errorListenerList.forEach({item in
            item(error)
        })

        if self.pendingAttemps > 0 {
            YBSwiftLog.warn("Request \"%@\" failed. Retry %d of %d in %dms.", self.service ?? "unknown", (self.maxRetries + 1 - self.pendingAttemps), self.maxRetries, self.retryInterval)
            let timeout = DispatchTime.now() + .milliseconds(Int(self.retryInterval))
            DispatchQueue.main.asyncAfter(deadline: timeout) {
                self.sendRequest()
            }
        }
    }
}
