//
//  YBYouboraUtils.m
//  YouboraLib
//
//  Created by Joan on 21/03/2017.
//  Copyright © 2017 NPAW. All rights reserved.
//

#import "YBYouboraUtils.h"
#import "YBLog.h"

@implementation YBYouboraUtils

+ (NSString *) addProtocol:(NSString *) url https:(bool) httpSecure {
    if (url == nil) {
        url = @"";
    }
    
    if (httpSecure) {
        return [@"https://" stringByAppendingString:url];
    } else {
        return [@"http://" stringByAppendingString:url];
    }
}

+ (NSMutableDictionary<NSString *, NSString *> *) buildErrorParams:(NSDictionary<NSString *, NSString *> *) params {
    
    NSMutableDictionary<NSString *, NSString *> * mutParams;
    
    NSString * key = @"errorLevel";
    NSString * value = @"";
    
    if (params == nil) {
        mutParams = [NSMutableDictionary dictionaryWithObject:value forKey:key];
    } else {
        mutParams = [NSMutableDictionary dictionaryWithDictionary:params];
        if (mutParams[key] == nil) {
            mutParams[key] = value;
        }
    }
    
    return mutParams;
}

+ (NSString *) stringifyList: (NSArray *) list {
    NSString * json = nil;
    
    if (list != nil) {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:list options:0 error:&error];
        
        if (jsonData == nil || error != nil) {
            [YBLog error:@"Error converting to json: %@", error];
        } else {
            json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        }
    }
    return json;
}

+ (NSString *) stringifyDictionary:(NSDictionary *) dict {
    NSString * json = nil;
    
    if (dict != nil) {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict
                                                           options:0
                                                             error:&error];
        
        if (jsonData == nil || error != nil) {
            [YBLog error:@"Error converting to json: %@", error];
        } else {
            json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        }
    }

    return json;
}

+ (NSNumber *) parseNumber:(NSNumber *) number orDefault:(NSNumber *) def {
    NSNumber * value = def;
    
    if (number != nil) {
        double val = number.doubleValue;
        if (!isnan(val) && !isinf(val) && val != INT_MAX && val != INT_MIN) {
            value = number;
        }
    }
    
    return value;
}

+ (double) unixTimeNow{
    NSDate *now = [NSDate date];
    NSTimeInterval nowEpochSeconds = [now timeIntervalSince1970];
    
    return round(nowEpochSeconds * 1000);
}

+ (NSString *) getAppName{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:(id)kCFBundleNameKey];
}

@end
