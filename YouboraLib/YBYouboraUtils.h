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
 * Adds specific protocol. ie: [http[s]:]//a-fds.youborafds01.com
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
