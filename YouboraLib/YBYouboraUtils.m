//
//  YBYouboraUtils.m
//  YouboraLib
//
//  Created by Tiago Pereira on 16/07/2020.
//  Copyright © 2020 NPAW. All rights reserved.
//

#import "YBYouboraUtils.h"
#import "YBConstants.h"
#import "YBLog.h"

@implementation YBYouboraUtils

+(NSString* _Nonnull)buildRenditionStringWithWidth:(int32_t)width height:(int32_t)height andBitrate:(double)bitrate {
    NSString *outStr = @"";

    if (width > 0 && height > 0) {
        outStr = [outStr stringByAppendingFormat:@"%dx%d",width, height];
        if (bitrate > 0) {
            outStr = [outStr stringByAppendingString:@"@"];
        }
    }

    if (bitrate > 0) {
        if (bitrate < 1e3) {
            outStr = [outStr stringByAppendingFormat:@"%.0fbps",bitrate];
        } else if (bitrate < 1e6) {
            outStr = [outStr stringByAppendingFormat:@"%.0fKbps",bitrate/1e3];
        } else {
            outStr = [outStr stringByAppendingFormat:@"%.2fMbps",bitrate/1e6];
        }
    }

    return outStr;
}

+(NSDictionary<NSString*, NSString*>* _Nonnull)buildErrorParams:(NSDictionary<NSString*, NSString*>* _Nullable)params {
    
    NSMutableDictionary *newParams = [[NSMutableDictionary alloc] initWithDictionary:params];
    
    NSString* key = YBConstantsErrorParams.level;
    NSString* value = @"";

    if (!params) { return @{key:value}; }

    //Put the value if not present
    if (!newParams[key]) {
        newParams[key] = value;
    }

    return [NSDictionary dictionaryWithDictionary:newParams];
}

+(NSDictionary<NSString*, NSString*>* _Nonnull)buildErrorParamsWithMessage:(NSString* _Nullable)msg code:(NSString* _Nullable)code metadata:(NSString* _Nullable)errorMetadata andLevel:(NSString* _Nullable)level {
    NSMutableDictionary <NSString*, NSString*> *params = [[NSMutableDictionary alloc] initWithCapacity:4];

    NSString *finalCode = (code && code.length > 0) ? code : msg;
    NSString *finalMessage = (msg && msg.length > 0) ? msg : code;
    
    
    params[YBConstantsErrorParams.code] = finalCode ? finalCode : @"PLAY_FAILURE";
    params[YBConstantsErrorParams.message] = finalMessage ? finalMessage : @"PLAY_FAILURE";

    if (errorMetadata && errorMetadata.length > 0) {
        params[YBConstantsErrorParams.metadata] = errorMetadata;
    }
    
    if (level && level.length > 0) {
        params[YBConstantsErrorParams.level] = level;
    }
    
    return [NSDictionary dictionaryWithDictionary:params];
}

+(NSString* _Nullable)stripProtocol:(NSString* _Nullable)host {
    if (!host) {return nil; }
    
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^(.*?://|//)" options:NSRegularExpressionCaseInsensitive error:&error];
    NSString *modifiedHost = [regex stringByReplacingMatchesInString:host options:0 range:NSMakeRange(0, [host length]) withTemplate:@""];
    
    if (error) {
        return nil;
    }
    
    return modifiedHost;
}

+(NSString* _Nonnull)addProtocol:(NSString* _Nullable)url andHttps:(Boolean)httpSecure {
    NSString *stringProtocol = httpSecure ? @"https://" : @"http://";

    if (url) {
        return [stringProtocol stringByAppendingString: url];
    }
    
    return stringProtocol;
}

+(NSString* _Nullable)stringifyList:(NSArray* _Nullable)list {
    if(!list) { return nil; }
    
    NSError *error;
    
    NSData *listData = [NSJSONSerialization dataWithJSONObject:list options:0 error:&error];
    
    if (error) {
        [YBLog error:@"Error converting to json: %@",error];
        return nil;
    }
    
    return [[NSString alloc] initWithData:listData encoding:NSUTF8StringEncoding];
}

+(NSString* _Nullable)stringifyDictionary:(NSDictionary<NSObject*, id>* _Nullable)dict {
    if(!dict) { return nil; }
    
    NSError *error;
    
    NSData *dictData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];
    
    if (error) {
        [YBLog error:@"Error converting to json: %@",error];
        return nil;
    }
    
    return [[NSString alloc] initWithData:dictData encoding:NSUTF8StringEncoding];
}

+(NSNumber* _Nullable)parseNumber:(NSNumber* _Nullable)number orDefault:(NSNumber* _Nullable)def {
    
    if (!number) { return def;}
    
    double val = [number doubleValue];
    
    
    if (!isnan(val) && !isinf(val) && val != INT_MAX && val != INT_MIN) {
        return number;
    }
    
    return def;
}

+(double)unixTimeNow {
    double nowEpochSeconds = [[NSDate new] timeIntervalSince1970];

    return round(nowEpochSeconds * 1000);
}

+(NSString* _Nullable)getAppName {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"];
}

@end
