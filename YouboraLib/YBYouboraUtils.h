//
//  YBYouboraUtils.h
//  YouboraLib
//
//  Created by Joan on 21/03/2017.
//  Copyright © 2017 NPAW. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * A utility class with static methods
 */
@interface YBYouboraUtils : NSObject

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
+ (NSString *) buildRenditionStringWithWidth:(int) width height:(int) height andBitrate:(double) bitrate;

/**
 * Returns a params dictionary with filled error fields.
 *
 * @param params Map of pre filled params or null. If this is not empty nor null, nothing will be done.
 * @return Built params
 */
+ (NSMutableDictionary<NSString *, NSString *> *) buildErrorParams:(NSDictionary<NSString *, NSString *> *) params;

/**
 * Returns a params dictionary with filled error fields.
 *
 * @param msg Error Message
 * @param code Error code
 * @param errorMetadata additional error info
 * @param level Level of the error. Currently supports 'error' and 'fatal'
 * @return Built params
 */
+ (NSMutableDictionary<NSString *, NSString *> *) buildErrorParamsWithMessage:(NSString *) msg code:(NSString *) code metadata:(NSString *) errorMetadata andLevel:(NSString *) level;

/**
 * Strip [protocol]:// from the beginning of the string.
 * @param host Url
 * @return stripped url
 */
+ (NSString *) stripProtocol:(NSString *) host;

/**
 * Adds specific protocol. ie: [http[s]:]//nqs.nice264.com
 * @param url Domain of the service.
 * @param httpSecure If true will add https, if false http.
 * @return Return the complete service URL.
 */
+ (NSString *) addProtocol:(NSString *) url https:(bool) httpSecure;

/**
 * Returns a JSON-formatted String representation of the list.
 * If the list is nil, nil will be returned.
 * @param list NSArray to convert to JSON
 * @return JSON-formatted NSString
 */
+ (NSString *) stringifyList: (NSArray *) list;

/**
 * Returns a JSON-formatted String representation of the dictionary.
 * If the dict is nil, nil will be returned.
 * @param dict NSDictionary to convert to JSON
 * @return JSON-formatted NSString
 */
+ (NSString *) stringifyDictionary:(NSDictionary *) dict;

/**
 * Returns number if it's not nil, infinity or NaN.
 * Otherwise, def defaultValue will be returned.
 * @param number The number to be parsed
 * @param def Number to return if number is 'incorrect'
 * @return number if it's a 'real' value, def otherwise
 */
+ (NSNumber *) parseNumber:(NSNumber *) number orDefault:(NSNumber *) def;

/**
 * Returns current timestamp in milliseconds
 * @return long timestamp
 */
+ (double) unixTimeNow;

/**
 * Returns display application name
 * @return Application name
 */
+ (NSString *) getAppName;
@end
