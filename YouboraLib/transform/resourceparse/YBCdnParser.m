//
//  YBCdnParser.m
//  YouboraLib
//
//  Created by Joan on 31/03/2017.
//  Copyright © 2017 NPAW. All rights reserved.
//

#import "YBCdnParser.h"
#import "YBRequest.h"
#import "YBParsableResponseHeader.h"
#import "YBCdnConfig.h"
#import "YBLog.h"

NSString * const YouboraCDNNameLevel3 =     @"Level3";
NSString * const YouboraCDNNameCloudfront = @"Cloudfront";
NSString * const YouboraCDNNameAkamai =     @"Akamai";
NSString * const YouboraCDNNameHighwinds =  @"Highwinds";
NSString * const YouboraCDNNameFastly =     @"Fastly";
NSString * const YouboraCDNNameBalancer =   @"Balancer";
NSString * const YouboraCDNNameTelefonica = @"Telefonica";

@interface YBCdnParser()

// Property redefinition with readwrite access
@property(nonatomic, strong, readwrite) NSMutableDictionary * responses;
@property(nonatomic, strong, readwrite) NSString * cdnNodeHost;
@property(nonatomic, assign, readwrite) YBCdnType cdnNodeType;
@property(nonatomic, strong, readwrite) NSString * cdnNodeTypeString;
@property(nonatomic, strong, readwrite) NSString * cdnName;

@property(nonatomic, strong) YBCdnConfig * cdnConfig;

@property(nonatomic, strong) NSMutableArray<id<CdnTransformDoneDelegate>> * delegates;

@end

@implementation YBCdnParser

// Cdn "database"
static NSMutableDictionary<NSString *, YBCdnConfig *> * cdnDefinitions;

#pragma mark - Init
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.delegates = [NSMutableArray array];
    }
    return self;
}


- (instancetype)initWithCdnConfig:(YBCdnConfig *)cdnConfig {
    self = [self init];
    self.cdnConfig = cdnConfig;
    return self;
}

#pragma mark - Public methods
- (void)parseWithUrl:(NSString *)url andPreviousResponses:(NSDictionary *)responses {
    
    if (responses == nil) {
        self.responses = [NSMutableDictionary dictionary];
    } else {
        self.responses = [NSMutableDictionary dictionaryWithDictionary:responses];
    }
    
    // If we already have a response for the request headers of this CDN, use it
    NSDictionary * response = self.responses[self.cdnConfig.requestHeaders];
    
    if (response != nil) {
        // Use old response headers
        [self parseResponse:response];
    } else {
        // First time we query with these headers, performm request
        [self requestResponse:url];
    }
}

- (void)addCdnTransformDelegate:(id<CdnTransformDoneDelegate>)delegate {
    if (delegate != nil && ![self.delegates containsObject:delegate]) {
        [self.delegates addObject:delegate];
    }
}

- (void)removeCdnTransformDelegate:(id<CdnTransformDoneDelegate>)delegate {
    if (delegate != nil) {
        [self.delegates removeObject:delegate];
    }
}

#pragma mark - Private methods
- (void) requestResponse:(NSString *) url {
    YBRequest * r = [self createRequestWithHost:url andService:nil];
    
    r.method = self.cdnConfig.requestMethod;
    r.requestHeaders = self.cdnConfig.requestHeaders;
    r.maxRetries = 0;
    
    __weak typeof(self) weakSelf = self;

    [r addRequestSuccessListener:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSDictionary<NSString*, id>* _Nullable listenerParams) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        NSHTTPURLResponse * httpResponse = (NSHTTPURLResponse *) response;
        NSDictionary * responseHeaders = httpResponse.allHeaderFields;
        strongSelf.responses[strongSelf.cdnConfig.requestHeaders] = responseHeaders;
        [strongSelf parseResponse:responseHeaders];
        
    }];
    
    [r addRequestErrorListener:^(NSError * _Nullable error) {
        [weakSelf done];
    }];
    
    [r send];
}

- (void) parseResponse:(NSDictionary<NSString *, NSString *> *) response {
    for (YBParsableResponseHeader * parser in self.cdnConfig.parsers) {
        for (NSString * responseHeaderKey in response) {
            if ([parser.headerName caseInsensitiveCompare:responseHeaderKey] == NSOrderedSame) {
                [self executeParser:parser withResponseHeaderValue:response[responseHeaderKey]];
            }
        }
    }
    [self done];
}

- (void) executeParser:(YBParsableResponseHeader *) parser withResponseHeaderValue:(NSString *) headerValue {
    
    NSError *err;
    NSRegularExpression * regex = [NSRegularExpression regularExpressionWithPattern:parser.regexPattern
                                                                            options:NSRegularExpressionCaseInsensitive
                                                                              error:&err];
    
    if (err != nil) {
        [YBLog warn:@"Resoruce parser: error compiling regex: %@", parser.regexPattern];
        return;
    }
    
    if (headerValue == nil || headerValue.length == 0) {
        [YBLog debug:@"Header value is nil or empty"];
        return;
    }
    
    NSTextCheckingResult * match = [regex firstMatchInString:headerValue
                                                    options:0
                                                      range:NSMakeRange(0, headerValue.length)];
    
    if (match == nil) {
        return;
    }
    
    NSString * firstValue = [headerValue substringWithRange:[match rangeAtIndex:1]];
    
    if (firstValue == nil || firstValue.length == 0) {
        return;
    }
    
    NSString * secondValue;
    if (match.numberOfRanges > 2) {
        secondValue = [headerValue substringWithRange:[match rangeAtIndex:2]];
    }
    
    self.cdnName = self.cdnConfig.code;
    
    switch (parser.element) {
        case YBCdnHeaderElementHost:
            self.cdnNodeHost = firstValue;
            break;
        case YBCdnHeaderElementType:
            self.cdnNodeTypeString = firstValue;
            break;
        case YBCdnHeaderElementHostAndType:
            self.cdnNodeHost = firstValue;
            self.cdnNodeTypeString = secondValue;
            break;
        case YBCdnHeaderElementTypeAndHost:
            self.cdnNodeTypeString = firstValue;
            self.cdnNodeHost = secondValue;
            break;
        case YBCdnHeaderElementName:
            self.cdnName = firstValue.uppercaseString;
            break;
    }
    
    if (self.cdnNodeTypeString != nil && self.cdnNodeType == YBCdnTypeUnknown) {
        YBCdnTypeParserBlock typeParser = self.cdnConfig.typeParser;
        if (typeParser != nil) {
            self.cdnNodeType = typeParser(self.cdnNodeTypeString);
        }
    }
}

- (void) done {
    for (id<CdnTransformDoneDelegate> delegate in self.delegates) {
        [delegate cdnTransformDone:self];
    }
}

- (YBRequest *) createRequestWithHost:(nullable NSString *) host andService:(nullable NSString *) service {
    return [[YBRequest alloc] initWithHost:host andService:service];
}

#pragma mark - Static
+ (YBCdnParser *)createWithName:(NSString *)cdnName {
    [YBCdnParser createDefinitions];
    YBCdnConfig * cdnConfig = cdnDefinitions[cdnName];
    if (cdnConfig == nil) {
        return nil;
    } else {
        return [[YBCdnParser alloc] initWithCdnConfig:cdnConfig];
    }
}

+ (NSDictionary<NSString *,YBCdnConfig *> *)definedCdns {
    [YBCdnParser createDefinitions];
    return cdnDefinitions;
}

+ (void)setBalancerHeaderName:(NSString *)cdnNameHeader {
    [YBCdnParser createDefinitions];
    cdnDefinitions[YouboraCDNNameBalancer].parsers.firstObject.headerName = cdnNameHeader;
}

+ (void)addCdn:(NSString *)cdnName withConfig:(YBCdnConfig *)cdnConfig {
    [YBCdnParser createDefinitions];
    cdnDefinitions[cdnName] = cdnConfig;
}

+ (void) createDefinitions {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cdnDefinitions = [NSMutableDictionary dictionaryWithCapacity:6];
        
        YBCdnConfig * cdnConfig;
        
        cdnConfig = [[YBCdnConfig alloc] initWithCode:@"LEVEL3"];
        [cdnConfig.parsers addObject:[[YBParsableResponseHeader alloc] initWithElement:YBCdnHeaderElementHostAndType headerName:@"X-WR-DIAG" andRegexPattern:@"Host:(.+)\\sType:(.+)"]];
        cdnConfig.requestHeaders[@"X-WR-DIAG"] = @"host";
        cdnConfig.typeParser = ^YBCdnType(NSString * type) {
            
            if ([type hasPrefix:@"TCP_HIT"] ||
                [type hasPrefix:@"TCP_MEM_HIT"] ||
                [type hasPrefix:@"TCP_IMS_HIT"]) {
                return YBCdnTypeHit;
            }
            
            if ([type hasPrefix:@"TCP_MISS"]) {
                return YBCdnTypeMiss;
            }
            
            return YBCdnTypeUnknown;
        };
        cdnDefinitions[YouboraCDNNameLevel3] = cdnConfig;
        
        cdnConfig = [[YBCdnConfig alloc] initWithCode:@"TELEFO"];
        [cdnConfig.parsers addObject:[[YBParsableResponseHeader alloc] initWithElement:YBCdnHeaderElementHostAndType headerName:@"x-tcdn" andRegexPattern:@"Host:(.+)\\sType:(.+)"]];
        cdnConfig.requestHeaders[@"x-tcdn"] = @"host";
        cdnConfig.typeParser = ^YBCdnType(NSString * type) {
            if ([type rangeOfString:@"p"].location != NSNotFound ||
                [type rangeOfString:@"c"].location != NSNotFound) {
                return YBCdnTypeHit;
            }
            if ([type rangeOfString:@"i"].location != NSNotFound ||
                [type rangeOfString:@"m"].location != NSNotFound) {
                return YBCdnTypeMiss;
            }
            return YBCdnTypeUnknown;
        };
        cdnDefinitions[YouboraCDNNameTelefonica] = cdnConfig;
        
        cdnConfig = [[YBCdnConfig alloc] initWithCode:@"CLOUDFRT"];
        [cdnConfig.parsers addObject:[[YBParsableResponseHeader alloc] initWithElement:YBCdnHeaderElementHost headerName:@"X-Amz-Cf-Id" andRegexPattern:@"(.+)"]];
        [cdnConfig.parsers addObject:[[YBParsableResponseHeader alloc] initWithElement:YBCdnHeaderElementType headerName:@"X-Cache" andRegexPattern:@"(\\S+)\\s.+"]];
        cdnConfig.typeParser = ^YBCdnType(NSString * type) {
            
            if ([@"Hit" isEqualToString:type]) {
                return YBCdnTypeHit;
            }
            
            if ([@"Miss" isEqualToString:type]) {
                return YBCdnTypeMiss;
            }
            
            return YBCdnTypeUnknown;
        };
        cdnDefinitions[YouboraCDNNameCloudfront] = cdnConfig;
        
        cdnConfig = [[YBCdnConfig alloc] initWithCode:@"AKAMAI"];
        [cdnConfig.parsers addObject:[[YBParsableResponseHeader alloc] initWithElement:YBCdnHeaderElementTypeAndHost headerName:@"X-Cache" andRegexPattern:@"(.+)\\sfrom (.+?(?=.deploy.akamaitechnologies))"]];
        cdnConfig.requestHeaders = [[NSMutableDictionary alloc] initWithDictionary:@{@"Pragma": @"akamai-x-cache-on, akamai-x-cache-remote-on, akamai-x-check-cacheable, akamai-x-get-cache-key, akamai-x-get-extracted-values, akamai-x-get-ssl-client-session-id, akamai-x-get-true-cache-key, akamai-x-serial-no, akamai-x-get-request-id,akamai-x-get-nonces,akamai-x-get-client-ip,akamai-x-feo-trace"}];
        cdnConfig.requestMethod = YouboraHTTPMethodGet;
        cdnConfig.typeParser = ^YBCdnType(NSString * type) {
            
            if ([@"TCP_HIT" isEqualToString:type]) {
                return YBCdnTypeHit;
            }
            
            if ([@"TCP_MISS" isEqualToString:type]) {
                return YBCdnTypeMiss;
            }
            
            return YBCdnTypeUnknown;
        };
        cdnDefinitions[YouboraCDNNameAkamai] = cdnConfig;
        
        cdnConfig = [[YBCdnConfig alloc] initWithCode:@"HIGHNEGR"];
        [cdnConfig.parsers addObject:[[YBParsableResponseHeader alloc] initWithElement:YBCdnHeaderElementHostAndType headerName:@"X-HW" andRegexPattern:@".+,[0-9]+\\.(.+)\\.(.+)"]];
        cdnConfig.typeParser = ^YBCdnType(NSString * type) {
            
            if ([@"c" isEqualToString:type] ||
                [@"x" isEqualToString:type]) {
                return YBCdnTypeHit;
            }
            
            return YBCdnTypeMiss;
        };
        cdnDefinitions[YouboraCDNNameHighwinds] = cdnConfig;
        
        cdnConfig = [[YBCdnConfig alloc] initWithCode:@"FASTLY"];
        [cdnConfig.parsers addObject:[[YBParsableResponseHeader alloc] initWithElement:YBCdnHeaderElementHost headerName:@"X-Served-By" andRegexPattern:@"([^,\\s]+)$"]];
        [cdnConfig.parsers addObject:[[YBParsableResponseHeader alloc] initWithElement:YBCdnHeaderElementType headerName:@"X-Cache" andRegexPattern:@"([^,\\s]+)$"]];
        cdnConfig.requestHeaders[@"X-WR-DIAG"] = @"host";
        cdnConfig.typeParser = ^YBCdnType(NSString * type) {
            
            if ([@"HIT" isEqualToString:type]) {
                return YBCdnTypeHit;
            }
            
            if ([@"MISS" isEqualToString:type]) {
                return YBCdnTypeMiss;
            }
            
            return YBCdnTypeUnknown;
        };
        cdnDefinitions[YouboraCDNNameFastly] = cdnConfig;
        
        cdnConfig = [[YBCdnConfig alloc] initWithCode:nil];
        [cdnConfig.parsers addObject:[[YBParsableResponseHeader alloc] initWithElement:YBCdnHeaderElementName headerName:nil andRegexPattern:@"(.+)"]];
        
        cdnDefinitions[YouboraCDNNameBalancer] = cdnConfig;
        
    });
}

@end
