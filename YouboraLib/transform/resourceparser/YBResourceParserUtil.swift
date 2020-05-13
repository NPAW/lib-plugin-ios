//
//  YBResourceParserUtil.swift
//  YouboraLib
//
//  Created by Tiago Pereira on 11/05/2020.
//  Copyright © 2020 NPAW. All rights reserved.
//

import Foundation

internal struct YBResourceParserUtil {
    static func translateTransportResource(transportResource: String) -> String? {
        if transportResource.contains("mp4") || transportResource.contains("m4s") {
            return YBConstantsTransportFormat.hlsFmp4
        }
        
        if transportResource.contains("ts") {
            return YBConstantsTransportFormat.hlsTs
        }
        
        return nil
    }
}
