//
//  YBResourceParserUtil.swift
//  YouboraLib
//
//  Created by Tiago Pereira on 11/05/2020.
//  Copyright © 2020 NPAW. All rights reserved.
//

import Foundation

@objcMembers public class YBResourceParserUtil: NSObject {
    public static func merge(resourseUrl: String?, adapterUrl: String?) -> String? {
        guard let adapterUrl = adapterUrl else {
            return resourseUrl
        }
        
        return adapterUrl
    }
    
    public static func isFinalURL(resourceUrl: String?) -> Bool {
        guard let url = resourceUrl,
            let resource = URL(string: url) else {
            return false
        }
        
        let finalResourceExtensions = ["mp4", "ts", "m4s", "cmfv"]
        
        return finalResourceExtensions.contains(resource.pathExtension)
    }
    
    public static func translateTransportResource(transportResource: String) -> String? {
        if transportResource.contains("mp4") || transportResource.contains("m4s") {
            return YBConstantsTransportFormat.hlsFmp4
        }
        
        if transportResource.contains("ts") {
            return YBConstantsTransportFormat.hlsTs
        }
        
        if transportResource.contains("cmfv") {
            return YBConstantsTransportFormat.hlsCmfv
        }
        
        return nil
    }
}
