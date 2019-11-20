//
//  YBSwiftRequest.swift
//  YouboraLib
//
//  Created by Enrique Alfonso Burillo on 19/11/2019.
//  Copyright © 2019 NPAW. All rights reserved.
//

#if os(iOS) || os(tvOS)
    import UIKit
#endif

typealias YBRequestSuccessBlock = (Data?, URLResponse?, [String: Any]?) -> Void
typealias YBRequestErrorBlock = (Error?) -> Void

var everySuccessListenerList: [YBRequestSuccessBlock] = []
var everyErrorListenerList: [YBRequestErrorBlock] = []

@objc class YBSwiftRequest: NSObject {
    struct YouboraHttpMethod {
        static let get = "GET"
        let post = "POST"
        let head = "HEAD"
        let options = "OPTIONS"
        let put = "PUT"
        let delete = "DELETE"
        let trace = "TRACE"
    }

    public var host: String?
    public var service: String?
    public var params: [String: String?]?
    public var requestHeaders: [String: String]?
    public var retryInterval: UInt = 5000
    public var maxRetries: UInt = 3
    public var method: String = YouboraHttpMethod.get
    public var listenerParams: [String: Any] = [:]
    public var body: String?

    fileprivate var successListenerList: [YBRequestSuccessBlock] = []
    fileprivate var errorListenerList: [YBRequestErrorBlock] = []
    fileprivate var pendingAttempts: UInt = 0

    lazy var userAgent: String = {
        var size: size_t = 0

        // Set 'oldp' parameter to NULL to get the size of the data
        // returned so we can allocate appropriate amount of space
        sysctlbyname("hw.machine", nil, &size, nil, 0)

        var name = malloc(size)

        // Get the platform name
        sysctlbyname("hw.machine", name, &size, nil, 0)

        var machine = String.init(cString: (name?.bindMemory(to: Int8.self, capacity: size))!, encoding: .utf8)

        free(name)

        #if os(iOS) || os(tvOS)
            var device = UIDevice.current

            let builtUserAgent = String.init(format: "%@/%@/%@/%@/%@",
                                             Bundle.main.infoDictionary?["CFBundleName"] as? String ?? "Unknown",
                                             Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown",
                                             device.model,
                                             machine ?? "Unknown",
                                             device.systemVersion)
        #else
            var size: size_t = 0

            // Set 'oldp' parameter to NULL to get the size of the data
            // returned so we can allocate appropriate amount of space
            sysctlbyname("hw.model", nil, &size, nil, 0)

            var modelName = malloc(size)

            // Get the platform name
            sysctlbyname("hw.model", name, &size, nil, 0)

            var machineName = String.init(cString: (modelName?.bindMemory(to: Int8.self, capacity: size))!, encoding: .utf8)

            free(modelName)

            let builtUserAgent = String.init(format: "%@/%@/%@/%@/%@",
                                            Bundle.main.infoDictionary?["CFBundleName"] as? String ?? "Unknown",
                                            Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown",
                                            "Mac",
                                            machineName ?? "Unknown",
                                            ProcessInfo.processInfo.operatingSystemVersionString)
        #endif

        let inputRef = NSMutableString(string: builtUserAgent) as CFMutableString
        CFStringTransform(inputRef, nil, kCFStringTransformToLatin, false)
        CFStringTransform(inputRef, nil, kCFStringTransformStripCombiningMarks, false)

        return builtUserAgent
    }()

    override init() {
        super.init()
    }

    convenience init(_ host: String?, _ service: String?) {
        self.init()
        self.host = host
        self.service = service
    }

    public func send() {
        self.pendingAttempts = self.maxRetries + 1
        sendRequest()
    }

    public func getUrl() -> URL {
        guard let host = self.host else {
            return URL.init(string: "")!
        }

        var components = URLComponents.init(string: host)

        if let service = self.service {
            components?.path = service
        }

        if let params = self.params, params.count > 0 {
            var queryItems: [URLQueryItem] = []

            for (key, value) in params {
                if let value = value {
                    let queryItem = URLQueryItem.init(name: key, value: value)
                    queryItems.append(queryItem)
                }
            }

            components?.queryItems = queryItems
            let localEncodedQuery = components?.percentEncodedPath.replacingOccurrences(of: "+", with: "%2B").replacingOccurrences(of: "%20", with: "+")
            components?.percentEncodedQuery = localEncodedQuery
        }

        return components?.url ?? URL.init(string: "")!
    }

    public func setParam(_ value: String?, _ key: String) {
        if let value = value {
            if self.params != nil {
                self.params = [key: value]
            } else {
                self.params?[key] = value
            }
        }
    }

    public func getParam(_ key: String) -> String? {
        return self.params?[key]!
    }

    //MARK Private methods
    fileprivate func createRequest(_ url: URL) -> URLRequest {
        return URLRequest.init(url: url)
    }

    fileprivate func sendRequest() {

        self.pendingAttempts -= 1
        do {
            // Create request object
            var request = createRequest(getUrl())

            guard let url = request.url else {
                YBSwiftLog.error("Request URL is nil")
                return
            }

            if YBSwiftLog.isAtLeastLevel(.verbose) {
                YBSwiftLog.requestLog("XHR Req: %@", url.absoluteString)
                if let body = self.body, !(body.isEmpty) {
                    YBSwiftLog.debug("Req body: %@", body)
                }

            }

            // Set request headers if any
            if let requestHeaders = self.requestHeaders, requestHeaders.count > 0 {
                request.allHTTPHeaderFields = self.requestHeaders
            }

            request.httpMethod = self.method

            if let body = self.body, !(body.isEmpty) {
                request.httpBody = body.data(using: .utf8)
            }

            request.setValue(self.userAgent, forHTTPHeaderField: "User-Agent")

            // Send request
            let session = URLSession.shared
            session.dataTask(with: request, completionHandler: { [weak self] data, response, error in
                guard let weakSelf = self else {
                    YBSwiftLog.error("YBRequest instance has been deallocated while waiting for completion handler")
                    return
                }

                if let response = response {
                    let httpResponse = response as? HTTPURLResponse
                    if let httpResponse = httpResponse, let service = weakSelf.service {
                        YBSwiftLog.debug("Response code for: %@ %ld", service, httpResponse.statusCode)
                    }
                }

                if let data = data, let response = response, error == nil {
                    weakSelf.success(data, response)
                } else {
                    if let error = error {
                        weakSelf.fail(error)
                    }
                }
            })
        } catch let error {
            //TODO Add logError method on YBSwiftLog
            //YBSwiftLog.logError(error)
            fail(error)
        }

    }

    fileprivate func success(_ data: Data, _ response: URLResponse) {
        for block: YBRequestSuccessBlock in everySuccessListenerList {
            do {
                block(data, response, self.listenerParams)
            } catch let error {
                //TODO Add logError method on YBSwiftLog
            }

        }

        for block: YBRequestSuccessBlock in self.successListenerList {
            do {
                block(data, response, self.listenerParams)
            } catch let error {
                //TODO Add logError method on YBSwiftLog
            }
        }
    }

    fileprivate func fail(_ error: Error) {
        for block: YBRequestErrorBlock in everyErrorListenerList {
            do {
               block(error)
           } catch let error {
               //TODO Add logError method on YBSwiftLog
           }
        }

        for block: YBRequestErrorBlock in self.errorListenerList {
            do {
               block(error)
           } catch let error {
               //TODO Add logError method on YBSwiftLog
           }
        }

        // Retry
        if self.pendingAttempts > 0 {
            YBSwiftLog.warn("Request \"%@\" failed. Retry %d of %d in %dms.", self.service ?? "Wron service", (self.maxRetries + 1 - self.pendingAttempts), self.maxRetries, self.retryInterval)
            let deadlineTime = DispatchTime.now() + .milliseconds(Int(self.retryInterval))
            DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
                self.sendRequest()
            }
        }
    }

    public func addRequestSuccessListener(_ successBlock: @escaping YBRequestSuccessBlock) {
        if self.successListenerList.filter({ $0 as AnyObject === successBlock as AnyObject}).count == 0 {
            self.successListenerList.append(successBlock)
        }
    }

    public func removeRequestSuccessListener(_ successBlock: @escaping YBRequestSuccessBlock) {
        self.successListenerList = self.successListenerList.filter { $0 as AnyObject !== successBlock as AnyObject }
    }

    public func addRequestErrorListener(_ errorBlock: @escaping YBRequestErrorBlock) {
        if self.errorListenerList.filter({ $0 as AnyObject === errorBlock as AnyObject}).count == 0 {
            self.errorListenerList.append(errorBlock)
        }
    }

    public func removeRequestErrorListener(_ errorBlock: @escaping YBRequestErrorBlock) {
        self.errorListenerList = self.errorListenerList.filter { $0 as AnyObject !== errorBlock as AnyObject }
    }

    public static func addEveryRequestSuccessListener(_ successBlock: @escaping YBRequestSuccessBlock) {
        everySuccessListenerList.append(successBlock)
    }

    public static func removeEveryRequestSuccessListener(_ successBlock: @escaping YBRequestSuccessBlock) {
        everySuccessListenerList = everySuccessListenerList.filter { $0 as AnyObject !== successBlock as AnyObject }
    }

    public static func addEveryRequestErrorListener(_ errorBlock: @escaping YBRequestErrorBlock) {
        everyErrorListenerList.append(errorBlock)
    }

    public static func removeEveryRequestErrorListener(_ errorBlock: @escaping YBRequestErrorBlock) {
        everyErrorListenerList = everyErrorListenerList.filter { $0 as AnyObject !== errorBlock as AnyObject }
    }
}
