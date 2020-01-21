//
//  YBYouboraUtils.swift
//  YouboraLib iOS
//
//  Created by nice on 21/01/2020.
//  Copyright © 2020 NPAW. All rights reserved.
//

import Foundation

/**
* A utility class with static methods
*/
@objcMembers class YBYouboraUtilsSwift: NSObject {
    /**
    * Builds a string that represents the rendition.
    *
    * The returned string will have the following format: [width]x[height]@[bitrate][suffix].
    * If either the width or height are &lt; 1, only the bitrate will be returned.
    * If bitrate is &lt; 1, only the dimensions will be returned.
    * If bitrate is &lt; and there is no dimensions, a null will be returned.
    * The bitrate will also have one of the following suffixes depending on its
    * magnitude: bps, Kbps, Mbps
    *
    * @param width The width of the asset.
    * @param height The height of the asset.
    * @param bitrate The indicated bitrate (in the manifest) of the asset.
    * @return A string with the following format: [width]x[height]@[bitrate][suffix]
    */
    static func buildRenditionString(width: Int, height: Int, andBitrate bitrate: Double) -> String {
        var outStr = ""

        if width > 0 && height > 0 {
            outStr += "\(width)x\(height)"
            if bitrate > 0 {
                outStr += "@"
            }
        }

        if bitrate > 0 {
            if bitrate < 1e3 {
                outStr +=  String(format: "%.0fbps", bitrate)
            } else if bitrate < 1e6 {
                outStr += String(format: "%.0fKbps", bitrate/1e3)
            } else {
                outStr += String(format: "%.2fMbps", bitrate/1e6)
            }
        }

        return outStr
    }

    /**
    * Returns a params dictionary with filled error fields.
    *
    * @param params Map of pre filled params or null. If this is not empty nor null, nothing will be done.
    * @return Built params
    */
    static public func buildErrorParams(_ params: [String: Any]?) -> [String: Any] {
        let key = "errorLevel"
        let value = ""

        guard let params = params else {
            return [key: value]
        }

        var noNilParams: [String: Any] = [:]

        for (key, paramValue) in params {
            switch paramValue {
            case Optional<Any>.none:
                noNilParams[key] = value
            default:
                noNilParams[key] = paramValue
            }
        }

        return noNilParams
    }

    /**
     * Returns a params dictionary with filled error fields.
     *
     * @param msg Error Message
     * @param code Error code
     * @param errorMetadata additional error info
     * @param level Level of the error. Currently supports 'error' and 'fatal'
     * @return Built params
     */
    static func buildErrorParams(message msg: String?, code: String?, metadata: String?, andLevel level: String?) -> [String: String] {
        var params: [String: String] = Dictionary(minimumCapacity: 4)

        let finalCode = code != nil && code!.count > 0 ? code : msg
        let finalMessage = msg != nil && msg!.count > 0 ? msg : code

        params["errorCode"] = finalCode != nil ? finalCode : "PLAY_FAILURE"
        params["errorMsg"] = finalMessage != nil ? finalMessage : "PLAY_FAILURE"

        if let errorMetadata = metadata, errorMetadata.count > 0 {
            params["errorMetadata"] = errorMetadata
        }

        if let level = level, level.count > 0 {
            params["errorLevel"] = level
        }

        return params
    }
}

//+ (NSMutableDictionary<NSString *, NSString *> *) buildErrorParamsWithMessage:(NSString *) msg code:(NSString *) code metadata:(NSString *) errorMetadata andLevel:(NSString *) level {
//
//    NSMutableDictionary<NSString *, NSString *> * params = [NSMutableDictionary dictionaryWithCapacity:4];
//
//    bool codeOk = code != nil && code.length > 0;
//    bool msgOk = msg != nil && msg.length > 0;
//
//    if (codeOk) {
//        if (!msgOk) {
//            msg = code;
//        }
//    } else if (msgOk) {
//        code = msg;
//    } else {
//        code = msg = @"PLAY_FAILURE";
//    }
//
//    params[@"errorCode"] = code;
//    params[@"errorMsg"] = msg;
//
//    if (errorMetadata != nil && errorMetadata.length > 0) {
//        params[@"errorMetadata"] = errorMetadata;
//    }
//    if(level != nil && level.length > 0){
//        params[@"errorLevel"] = level;
//    }
//
//    return params;
//}
