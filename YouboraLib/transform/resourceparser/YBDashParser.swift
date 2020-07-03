//
//  YBDashParser.swift
//  YouboraLib
//
//  Created by Tiago Pereira on 25/02/2020.
//  Copyright © 2020 NPAW. All rights reserved.
//

import Foundation

@objcMembers public class YBDashParser: NSObject, YBResourceParser {
    var resource: String?
    
    public func isSatisfied(resource: String?, manifest: Data?) -> Bool {
        guard
            let dataManifest = manifest,
            let manifest = String(data: dataManifest, encoding: .utf8),
            let resource = resource, resource != "" else {
                return false
        }
        
        let valid = manifest.contains("<MPD")
        
        if valid { self.resource = resource }
        
        return valid
    }
    
    public func getRequestSource() -> String? {
        return self.resource
    }
    
    public func parseResource(data: Data?, response: HTTPURLResponse?, listenerParents: [String: AnyObject]?) -> String? {
        guard let data = data,
            let resultData = String(data: data, encoding: .utf8) else {
                return nil
        }
        
        guard let location = self.getLocation(xml: resultData) else {
            return self.getResource(xml: resultData)
        }
        
        return location
    }
    
    public func parseTransportFormat(data: Data?, response: HTTPURLResponse?, listenerParents: [String: AnyObject]?, userDefinedTransportFormat: String?) -> String? {
        if userDefinedTransportFormat != nil {
            return nil
        }
        
        guard let data = data,
            let resultData = String(data: data, encoding: .utf8),
            let mimeType = self.getMimeType(xml: resultData) else {
                return nil
        }
        
        return YBResourceParserUtil.translateTransportResource(transportResource: mimeType)
    }
    
    private func getLocation(xml: String) -> String? {
        return self.getExpression(pattern: "<Location>\n{0,1}(.*)\n{0,1}</Location>", xml: xml)
    }
    
    private func getResource(xml: String) -> String? {
        let resourcePatterns = [
            "<BaseURL>\n{0,1}(.*)\n{0,1}</BaseURL>",
            "<SegmentTemplate.+media=\"(.+?)\".+",
            "<SegmentURL.+media=\"(.+?)\".+"
        ]
        
        for pattern in resourcePatterns {
            if let resource = self.getExpression(pattern: pattern, xml: xml) {
                return resource
            }
        }
        
        return nil
    }
    
    private func getMimeType(xml: String) -> String? {
        let mimeTypePattern = "<AdaptationSet.+mimeType=\"video/(.+?)\".+>"
        
        return self.getExpression(pattern: mimeTypePattern, xml: xml)
    }
    
    private func getExpression(pattern: String, xml: String) -> String? {
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: [])
            
            let matches = regex.matches(in: xml, options: [], range: NSRange(location: 0, length: xml.count))
            
            if matches.count == 0 { return nil }
            
            guard let match = matches.first else {
                return nil
            }
            
            if match.numberOfRanges < 2 { return nil }
            
            guard let range = Range(match.range(at: 1), in: xml) else {
                return nil
            }
            
            return String(xml[range])
            
         } catch {
            return nil
        }
    }
}
