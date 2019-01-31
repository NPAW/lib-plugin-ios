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

+ (NSString *) buildRenditionStringWithWidth:(int) width height:(int) height andBitrate:(double) bitrate{
    
    NSMutableString * outStr = [NSMutableString string];
    
    if (width > 0 && height > 0) {
        [outStr appendFormat:@"%dx%d", width, height];
        if (bitrate > 0) {
            [outStr appendFormat:@"@"];
        }
    }
    
    if (bitrate > 0) {
        if (bitrate < 1e3) {
            [outStr appendFormat:@"%.0fbps", bitrate];
        } else if (bitrate < 1e6) {
            [outStr appendFormat:@"%.0fKbps", bitrate/1e3];
        } else {
            [outStr appendFormat:@"%.2fMbps", bitrate/1e6];
        }
    }
    
    return outStr;
}

+ (NSString *) stripProtocol:(NSString *) host {
    if (host == nil) {
        return nil;
    }
    
    // Create regex only once
    static dispatch_once_t dispatchOnceRegex;
    static NSRegularExpression * staticRegex;
    
    dispatch_once(&dispatchOnceRegex, ^{
        NSError *err;
        staticRegex = [NSRegularExpression regularExpressionWithPattern:@"^(.*?://|//)"
                                                                options:NSRegularExpressionCaseInsensitive
                                                                  error:&err];
    });
    
    NSTextCheckingResult * match = [staticRegex firstMatchInString:host options:0 range:NSMakeRange(0, host.length)];
    
    return [host stringByReplacingCharactersInRange:[match rangeAtIndex:1] withString:@""];
}

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

+ (NSMutableDictionary<NSString *, NSString *> *) buildErrorParamsWithMessage:(NSString *) msg code:(NSString *) code metadata:(NSString *) errorMetadata andLevel:(NSString *) level {
    
    NSMutableDictionary<NSString *, NSString *> * params = [NSMutableDictionary dictionaryWithCapacity:4];
    
    bool codeOk = code != nil && code.length > 0;
    bool msgOk = msg != nil && msg.length > 0;
    
    if (codeOk) {
        if (!msgOk) {
            msg = code;
        }
    } else if (msgOk) {
        code = msg;
    } else {
        code = msg = @"PLAY_FAILURE";
    }
    
    params[@"errorCode"] = code;
    params[@"errorMsg"] = msg;
    
    if (errorMetadata != nil && errorMetadata.length > 0) {
        params[@"errorMetadata"] = errorMetadata;
    }
    if(level != nil && level.length > 0){
        params[@"errorLevel"] = level;
    }
    
    /*if (level == nil || level.length == 0) {
        level = @"error";
    }*/
    
    //params[@"errorLevel"] = level;
    
    return params;
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
