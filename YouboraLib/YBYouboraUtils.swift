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
@objcMembers open class YBYouboraUtils: NSObject {
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
    static public func buildRenditionString(withWidth width: Int32, height: Int32, andBitrate bitrate: Double) -> String {
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
    static public func buildErrorParams(_ params: [String: String]?) -> [String: String] {
        let key = YBConstantsErrorParams.level
        let value = ""

        guard var noNilParams = params else {
            return [key: value]
        }

        //Put the value if not present
        if noNilParams[key]  == nil {
            noNilParams[key] = value
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
    static public func buildErrorParams(message msg: String?, code: String?, metadata: String?, andLevel level: String?) -> [String: String] {
        var params: [String: String] = Dictionary(minimumCapacity: 4)

        let finalCode = code != nil && code!.count > 0 ? code : msg
        let finalMessage = msg != nil && msg!.count > 0 ? msg : code

        params[YBConstantsErrorParams.code] = finalCode != nil ? finalCode : "PLAY_FAILURE"
        params[YBConstantsErrorParams.message] = finalMessage != nil ? finalMessage : "PLAY_FAILURE"

        if let errorMetadata = metadata, errorMetadata.count > 0 {
            params[YBConstantsErrorParams.metadata] = errorMetadata
        }

        if let level = level, level.count > 0 {
            params[YBConstantsErrorParams.level] = level
        }

        return params
    }

    /**
     * Strip [protocol]:// from the beginning of the string.
     * @param host Url
     * @return stripped url
     */
    static public func stripProtocol(_ host: String?) -> String? {
        return host?.replacingOccurrences(of: "^(.*?://|//)", with: "", options: .regularExpression)
    }

    /**
     * Adds specific protocol. ie: [http[s]:]//a-fds.youborafds01.com
     * @param url Domain of the service.
     * @param httpSecure If true will add https, if false http.
     * @return Return the complete service URL.
     */
    static public func addProtocol(_ url: String?, https: Bool) -> String {
        let stringProtocol = https ? "https://" : "http://"

        if let newUrl = url {
            return stringProtocol+newUrl
        } else {
             return stringProtocol
        }
    }

    /**
     * Returns a JSON-formatted String representation of the list.
     * If the list is nil, nil will be returned.
     * @param list NSArray to convert to JSON
     * @return JSON-formatted NSString
     */
    static public func stringifyList(_ list: [Any]?) -> String? {
        guard let list = list else { return nil }

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: list, options: .init(rawValue: 0))
            return String(data: jsonData, encoding: .utf8)
        } catch {
            YBSwiftLog.error("Error converting to json: \(error)")
            return nil
        }
    }

    /**
     * Returns a JSON-formatted String representation of the dictionary.
     * If the dict is nil, nil will be returned.
     * @param dict NSDictionary to convert to JSON
     * @return JSON-formatted NSString
     */
    static public func stringifyDictionary(_ dict: [AnyHashable: Any]?) -> String? {
        guard let dict = dict else { return nil }

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dict, options: .init(rawValue: 0))
            return String(data: jsonData, encoding: .utf8)
        } catch {
            YBSwiftLog.error("Error converting to json: \(error)")
            return nil
        }
    }

    /**
     * Returns number if it's not nil, infinity or NaN.
     * Otherwise, def defaultValue will be returned.
     * @param number The number to be parsed
     * @param def Number to return if number is 'incorrect'
     * @return number if it's a 'real' value, def otherwise
     */
    static public func parseNumber(_ number: NSNumber?, orDefault defaultValue: NSNumber?) -> NSNumber? {
        guard let number = number else { return defaultValue }

        let val = number.doubleValue

        if !val.isNaN && !val.isInfinite && val != Double(Int.max) && val != Double(Int.min) {
            return number
        }

        return defaultValue
    }

    /**
     * Returns current timestamp in milliseconds
     * @return long timestamp
     */
    static public func unixTimeNow() -> Double {
        let now = Date()
        let nowEpochSeconds = now.timeIntervalSince1970

        return round(nowEpochSeconds * 1000)
    }

    /**
     * Returns display application name
     * @return Application name
     */
    static public func getAppName() -> String? {
        return Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String
    }
    
    /**
     Function to check if there's an array and case yes if this array contains a value

     - Parameters:
        - array: Array with values to be compared
        - value: Value to check with the values on the array

     - Returns: True case there's a value inside of the array that fits with the value, otherwise false
     */
    static public func containsString(array: [String]?, value: String) -> Bool {
        guard let array = array else { return false }
        
        return array.contains(value)
    }
}
