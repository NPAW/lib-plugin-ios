//
//  YBHlsParser.swift
//  YouboraLib
//
//  Created by Tiago Pereira on 25/02/2020.
//  Copyright © 2020 NPAW. All rights reserved.
//
import Foundation

private struct ParseResponse {
    let resource: String
    let dataString: String
    let match: NSTextCheckingResult
    let regexText: String
}

@objcMembers public class YBHlsParser: NSObject, YBResourceParser {
    var resource: String?
    
    public func isSatisfied(resource: String?, manifest: Data?) -> Bool {
        guard
            let dataManifest = manifest,
            let manifest = String(data: dataManifest, encoding: .utf8),
            let resource = resource, resource != "" else {
                return false
        }
        
        let valid = manifest.contains("#EXTM3U")
        
        if valid { self.resource = resource }
        
        return valid
    }
    
    public func getRequestSource() -> String? {
        return self.resource
    }
    
    private func obtainInfo(data: Data?, response: HTTPURLResponse?, listenerParents: [String: AnyObject]?) -> ParseResponse? {
        guard let data = data,
              let resultData = String(data: data, encoding: .utf8)?.replacingOccurrences(of: ",URI=", with: "\n").replacingOccurrences(of: "\"", with: ""),
            let resource = self.resource else {
                return nil
        }
        
        do {
            // Expression to accept all media formats
            let regex = try NSRegularExpression(pattern: "(\\S*?(\\.m3u8|\\.m3u|\\.ts|\\.mp4|\\.m4s|\\.cmfv)(?:\\?\\S*|\\R|$))")
            var regexText = resultData
            
            var tmpMatch = regex.firstMatch(in: resultData, options: [], range: NSRange(location: 0, length: resultData.count))
            
            if tmpMatch == nil {
                // If it doesn't match, maybe it's because of the newlines. It's been observed that in iOS 8.4 this regex sometimes
                // does not match when the string has newlines, while in iOS 9.2 it does. So as a workaround, we split the resource
                // by newlines and try to match against them one by one.
                for line in resultData.components(separatedBy: .newlines) {
                    tmpMatch = regex.firstMatch(in: line, options: [], range: NSRange(location: 0, length: line.count))
                    if tmpMatch != nil {
                        regexText = line
                        break
                    }
                }
            }
            
            if let match = tmpMatch {
                return ParseResponse(resource: resource, dataString: resultData, match: match, regexText: regexText)
            } else {
                return nil
            }
            
        } catch {
            return nil
        }
    }
    public func parseResource(data: Data?, response: HTTPURLResponse?, listenerParents: [String: AnyObject]?) -> String? {
        
        guard let info = self.obtainInfo(data: data, response: response, listenerParents: listenerParents),
            let resRange = Range(info.match.range(at: 1), in: info.regexText),
            let extRange = Range(info.match.range(at: 2), in: info.regexText) else {
                
                // didn't find any compatible resource so returns nil
                return nil
        }
        
        var res = String(info.dataString[resRange]).trimmingCharacters(in: CharacterSet.newlines).trimmingCharacters(in: CharacterSet.whitespaces)
        let ext = String(info.dataString[extRange])
        
        if res.isEmpty || ext.isEmpty { return nil }
        
        // Resource needs to use the host url
        if res.prefix(1) == "/" {
           // Use the base path from the resource
            guard let resource = resource,
                let url = URL(string: resource),
                let basePath = url.host,
                let scheme = url.scheme else {
                return nil
            }
            
            res = scheme+"://"+basePath+res
            
            return res

        }
        
        // Get the base path from the resource and add it top the final resource
        if !res.lowercased().hasPrefix("http") {
            if let basePathRange = info.resource.range(of: "/", options: .backwards) {
                let basePath = String(info.resource[..<basePathRange.upperBound])
                res = basePath+res
            }
        }
        
        return res
    }
    
    public func parseTransportFormat(data: Data?, response: HTTPURLResponse?, listenerParents: [String: AnyObject]?, userDefinedTransportFormat: String?) -> String? {
        if userDefinedTransportFormat != nil {
            return nil
        }
        
        guard let info = self.obtainInfo(data: data, response: response, listenerParents: listenerParents),
            let extRange = Range(info.match.range(at: 2), in: info.regexText) else {
                // didn't found any compatible resource so returns nil
                return nil
        }
        
        return YBResourceParserUtil.translateTransportResource(transportResource: String(info.dataString[extRange]))
    }
}
