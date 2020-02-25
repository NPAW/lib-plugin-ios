//
//  YBHlsParser.swift
//  YouboraLib
//
//  Created by Tiago Pereira on 25/02/2020.
//  Copyright © 2020 NPAW. All rights reserved.
//
import Foundation

@objcMembers public class YBHlsParser: NSObject, YBResourceParser {
    var resource: String?
    
    public func isSatisfied(resource: String?) -> Bool {
        guard let resource = resource,
            resource != "" else {
                return false
        }
        
        //Check if is a video resource is based on the regular expression
        do {
            let regex = try NSRegularExpression(pattern: "(\\S*?(\\.m3u8|\\.m3u)(?:\\?\\S*|\\R|$))")
            
            if regex.firstMatch(in: resource, options: [], range: NSRange(location: 0, length: resource.count)) == nil {
                return false
            }
        } catch {
            return false
        }
        
        self.resource = resource
        return true
    }
    
    public func getRequestSource() -> String? {
        return self.resource
    }
    
    public func parseResource(data: Data?, response: HTTPURLResponse?, listenerParents: [String: AnyObject]?) -> String? {
        guard let data = data,
            let resultData = String(data: data, encoding: .utf8),
            let resource = self.resource else {
                return nil
        }
        
        do {
            // Expression to accept all media formats
            let regex = try NSRegularExpression(pattern: "(\\S*?(\\.m3u8|\\.m3u|\\.ts|\\.mp4)(?:\\?\\S*|\\R|$))")
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
            
            guard let match = tmpMatch ,
                let resRange = Range(match.range(at: 1), in: regexText),
                let extRange = Range(match.range(at: 2), in: regexText) else {
                    
                // didn't found any compatible resource so returns nil
                return nil
            }
            
            var res = String(resultData[resRange]).trimmingCharacters(in: CharacterSet.newlines).trimmingCharacters(in: CharacterSet.whitespaces)
            let ext = String(resultData[extRange])
            
            if res.isEmpty || ext.isEmpty { return nil }
            
            // Get the base path from the resource and add it top the final resource
            if !res.lowercased().hasPrefix("http") {
                if let basePathRange = resource.range(of: "/", options: .backwards) {
                    let basePath = String(resource[..<basePathRange.upperBound])
                    res = basePath+res
                }
            }
            
            return res
        } catch {
            return nil
        }
    }
}
