//
//  YBHlsParser.m
//  YouboraLib
//
//  Created by Joan on 31/03/2017.
//  Copyright © 2017 NPAW. All rights reserved.
//

#import "YBHlsParser.h"
#import "YBLog.h"
#import "YBRequest.h"

#define YB_REG_EXP_VIDEO_EXTENSION_PATTERN @"(\\S*?(\\.m3u8|\\.m3u|\\.ts|\\.mp4)(?:\\?\\S*|\\R|$))"

@interface YBHlsParser()

@property(nonatomic, strong) NSString * realResource;
@property(nonatomic, strong) NSMutableArray<id<HlsTransformDoneDelegate>> * delegates;

@end

@implementation YBHlsParser

static NSRegularExpression * regexPattern;

#pragma mark - Init

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.realResource = nil;
        self.delegates = [NSMutableArray arrayWithCapacity:1];
    }
    return self;
}

#pragma mark - Public methods
- (void) parse:(NSString *) resource parentResource:(nullable NSString *) parentResource {
    if (parentResource == nil) {
        parentResource = @"";
    }
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSError *err;
        regexPattern = [NSRegularExpression regularExpressionWithPattern:YB_REG_EXP_VIDEO_EXTENSION_PATTERN
                                                  options:NSRegularExpressionCaseInsensitive
                                                    error:&err];
    });
    
    // If parsing fails, use parent resource
    NSString * matchingLine = parentResource;
    
    // Try to match against the resource
    NSTextCheckingResult * match = [regexPattern firstMatchInString:resource options:0 range:NSMakeRange(0, resource.length)];
    
    if (match != nil) {
        matchingLine = resource;
    } else {
        // If it doesn't match, maybe it's because of the newlines. It's been observed that in iOS 8.4 this regex sometimes
        // does not match when the string has newlines, while in iOS 9.2 it does. So as a workaround, we split the resource
        // by newlines and try to match against them one by one.
        NSArray<NSString *> * lines = [resource componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        
        for (NSString * line in lines) {
            match = [regexPattern firstMatchInString:line options:0 range:NSMakeRange(0, line.length)];
            if (match != nil) {
                matchingLine = line;
                break;
            }
        }
    }
    
    if (match != nil) {
        NSString * res = [[matchingLine substringWithRange:[match rangeAtIndex:1]] stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        NSString * extension = [matchingLine substringWithRange:[match rangeAtIndex:2]];

        if (res != nil && extension != nil) {
            res = [res stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            if (![res.lowercaseString hasPrefix:@"http"]) {
                NSRange range = [parentResource rangeOfString:@"/" options:NSBackwardsSearch];
                res = [[parentResource substringToIndex:range.location + 1] stringByAppendingString:res]; // "location + 1" to get the '/' character
            }
            
            if ([extension hasSuffix:@"m3u8"] || [extension hasSuffix:@"m3u"]) {
                YBRequest * request = [self createRequestWithHost:res andService:nil];
                
                NSString * nextParentResource = res;
                
                __weak typeof(self) weakSelf = self;
                [request addRequestSuccessListener:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSDictionary<NSString *, id>* listenerParams) {
                    __strong typeof(weakSelf) strongSelf = weakSelf;
                    [strongSelf parse:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] parentResource:nextParentResource];
                }];
                
                [request addRequestErrorListener:^(NSError * _Nullable error) {
                    __strong typeof(weakSelf) strongSelf = weakSelf;
                    [strongSelf done];
                }];
                
                [request send];
            } else {
                self.realResource = res;
                [self done];
            }
        } else {
            self.realResource = res;
            [self done];
        }
    } else {
        [YBLog warn:@"Parse HLS Regex couldn't match"];
        [self done];
    }
}

- (void) addHlsTransformDoneDelegate:(id<HlsTransformDoneDelegate>) delegate {
    if (delegate != nil && ![self.delegates containsObject:delegate]) {
        [self.delegates addObject:delegate];
    }
}

- (void) removeHlsTransformDoneDelegate:(id<HlsTransformDoneDelegate>) delegate {
    if (self.delegates != nil && delegate != nil) {
        [self.delegates removeObject:delegate];
    }
}

- (NSString *) getResource {
    return self.realResource;
}

#pragma mark - Private methods
- (void) done {
    for (id<HlsTransformDoneDelegate> delegate in self.delegates) {
        [delegate hlsTransformDone:[self getResource] fromHlsParser:self];
    }
}

- (YBRequest *) createRequestWithHost:(NSString *) host andService:(NSString *) service {
    return [[YBRequest alloc] initWithHost:host andService:service];
}

@end
