//
//  YBRequest.m
//  YouboraLib
//
//  Created by Joan on 16/03/2017.
//  Copyright © 2017 NPAW. All rights reserved.
//

#import "YBRequest.h"
#import "YBLog.h"
#import "YBConstants.h"

// Required for User-Agent building
#include <sys/sysctl.h>
#import <UIKit/UIKit.h>

NSString * const YouboraHTTPMethodGet = @"GET";
NSString * const YouboraHTTPMethodPost = @"POST";
NSString * const YouboraHTTPMethodHead = @"HEAD";
NSString * const YouboraHTTPMethodOptions = @"OPTIONS";
NSString * const YouboraHTTPMethodPut = @"PUT";
NSString * const YouboraHTTPMethodDelete = @"DELETE";
NSString * const YouboraHTTPMethodTrace = @"TRACE";

@interface YBRequest()

/// ---------------------------------
/// @name Private properties
/// ---------------------------------

@property(nonatomic, strong) NSMutableArray<YBRequestSuccessBlock> * successListenerList;
@property(nonatomic, strong) NSMutableArray<YBRequestErrorBlock> * errorListenerList;
@property(nonatomic, assign) unsigned int pendingAttempts;

@end

@implementation YBRequest

static NSMutableArray<YBRequestSuccessBlock> * everySuccessListenerList;
static NSMutableArray<YBRequestErrorBlock> * everyErrorListenerList;

#pragma mark - Init
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.successListenerList = [NSMutableArray arrayWithCapacity:1];
        self.errorListenerList = [NSMutableArray arrayWithCapacity:1];
        self.listenerParams = [[NSDictionary alloc] init];
        
        self.maxRetries = 3;
        self.retryInterval = 5000;
        self.method = YouboraHTTPMethodGet;
        self.body = @"";
    }
    return self;
}

- (instancetype) initWithHost:(nullable NSString *) host andService:(nullable NSString *) service {
    self = [self init];
    self.host = host;
    self.service = service;
    return self;
}

#pragma mark - Public methods
-(void)send {
    self.pendingAttempts = self.maxRetries + 1;
    [self sendRequest];
}

-(NSURL *)getUrl {
    //NSURLComponents * components = [NSURLComponents new];
    NSURLComponents * components = [NSURLComponents componentsWithString:self.host];
    //components.host = self.host;
    if (self.service) {
        components.path = self.service;
    }
    
    // Build query params
    if (self.params != nil && self.params.count > 0) {
        
        NSMutableArray<NSURLQueryItem *> * queryItems = [NSMutableArray arrayWithCapacity:self.params.count];
        
        for (NSString * key in self.params) {
            NSString * value = self.params[key];
            if (value != nil) {
                // Avoid sending null values
                NSURLQueryItem * queryItem = [NSURLQueryItem queryItemWithName:key value:value];
                [queryItems addObject:queryItem];
            }
        }
        
        [components setQueryItems:queryItems];
        components.percentEncodedQuery = [[components.percentEncodedQuery stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"] stringByReplacingOccurrencesOfString:@"%20" withString:@"+"];
    }
    
    return components.URL;
}

- (void)setParam:(NSString *)value forKey:(NSString *)key {
    if (value) {
        if (self.params == nil) {
            self.params = [NSMutableDictionary dictionaryWithObject:value forKey:key];
        } else {
            
            [self.params setObject:value forKey:key];
        }
    }
}

- (NSString *)getParam:(NSString *)key {
    return [self.params objectForKey:key];
}

#pragma mark - Private methods
- (NSMutableURLRequest *) createRequestWithUrl:(NSURL *) url {
    return [NSMutableURLRequest requestWithURL:url];
}

- (void) sendRequest {
    self.pendingAttempts--;
    @try {
        // Create request object
        NSMutableURLRequest * request = [self createRequestWithUrl:[self getUrl]];
        
        if ([YBLog isAtLeastLevel:YBLogLevelVerbose]) {
            [YBLog requestLog:@"XHR Req: %@", request.URL.absoluteString];
            if(self.body != nil && ![self.body isEqualToString:@""]){
                if([self.method isEqualToString:YouboraHTTPMethodPost]){
                    [YBLog debug:[NSString stringWithFormat:@"Req body: %@", self.body]];
                }
            }
        }
        
        // Set request headers if any
        if (self.requestHeaders != nil && self.requestHeaders.count > 0) {
            [request setAllHTTPHeaderFields:self.requestHeaders];
        }
        
        request.HTTPMethod = self.method;
        
        if(self.body != nil && ![self.body isEqualToString:@""] && [self.method isEqualToString:YouboraHTTPMethodPost]){
            [request setHTTPBody:[self.body dataUsingEncoding:NSUTF8StringEncoding]];
        }
        
        // User-agent
        [request setValue:[self getUserAgent] forHTTPHeaderField:@"User-Agent"];
        
        // Send request
        __weak typeof(self) weakSelf = self;
        NSURLSession * session = [NSURLSession sharedSession];
        [[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            __strong typeof(weakSelf) strongSelf = self;
            if (strongSelf == nil) {
                [YBLog error:@"YBRequest instance has been deallocated while waiting for completion handler"];
                return;
            }
            
            if(response != nil) {
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                [YBLog debug:[NSString stringWithFormat:@"Response code for: %@ %ld",weakSelf.service, (long)httpResponse.statusCode]];
            }
            
            if (error == nil) {
                [weakSelf didSucceedWithData:data andResponse:response];
            } else {
                [weakSelf didFailWithError:error];
            }
        }] resume];
        
    } @catch (NSException *exception) {
        [YBLog logException:exception];
        [self didFailWithError:nil];
    }
}

- (void) didSucceedWithData:(NSData *) data andResponse:(NSURLResponse *) response {
    for (YBRequestSuccessBlock block in everySuccessListenerList) {
        @try {
            block(data, response, self.listenerParams);
        } @catch (NSException *exception) {
            [YBLog logException:exception];
        }
    }
    
    for (YBRequestSuccessBlock block in self.successListenerList) {
        @try {
            block(data, response, self.listenerParams);
        } @catch (NSException *exception) {
            [YBLog logException:exception];
        }
    }
}

- (void) didFailWithError:(NSError *) error {
    
    // Callbacks
    for (YBRequestErrorBlock block in everyErrorListenerList) {
        @try {
            block(error);
        } @catch (NSException *exception) {
            [YBLog logException:exception];
        }
    }
    
    for (YBRequestErrorBlock block in self.errorListenerList) {
        @try {
            block(error);
        } @catch (NSException *exception) {
            [YBLog logException:exception];
        }
    }
    
    // Retry
    if (self.pendingAttempts > 0) {
        [YBLog warn:[NSString stringWithFormat:@"Request \"%@\" failed. Retry %d of %d in %dms.", self.service, (self.maxRetries + 1 - self.pendingAttempts), self.maxRetries, self.retryInterval]];
        //__weak typeof (self) weakSelf = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.retryInterval * NSEC_PER_MSEC)), dispatch_get_main_queue(), ^{
            //__strong typeof (weakSelf) strongSelf = weakSelf;
            [self sendRequest];
        });
    } else {
        [YBLog error:[NSString stringWithFormat:@"Aborting failed request \"%@\". Max retries reached(%d)", self.service, self.maxRetries]];
    }
}

/**
 * Builds a string with the User-Agent header content.
 *
 * This method will also normalize the user agent string. With "normalize"
 * we mean to convert the user-agent string to latin chars with no diacritic
 * signs Normalization could be necessary when the app bundle has non-latin
 * chars. It's been observed that, with Japanese characters, the User-Agent
 * header was arriving empty to the backend
 * @returns The User-Agent built string.
 */
- (NSString *) getUserAgent {
    
    static NSString * builtUserAgentNormalized;
    
    // Build User-Agent only once
    static dispatch_once_t onceTokenUA;
    dispatch_once(&onceTokenUA, ^{
        size_t size;
        
        // Set 'oldp' parameter to NULL to get the size of the data
        // returned so we can allocate appropriate amount of space
        sysctlbyname("hw.machine", NULL, &size, NULL, 0);
        
        char* name = (char*)malloc(size);
        
        // Get the platform name
        sysctlbyname("hw.machine", name, &size, NULL, 0);
        
        // Place name into a string
        NSString *machine = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
        
        free(name);
        
        UIDevice * device = [UIDevice currentDevice];
        
        NSMutableString * builtUserAgent = [NSMutableString stringWithFormat:@"%@/%@/%@/%@/%@",
                                            [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"],
                                            [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"],
                                            [device model],
                                            machine,
                                            [device systemVersion]
                                            ];
        
        // Transform non-latin to latin and remove diacritical signs
        CFMutableStringRef inputRef = (__bridge CFMutableStringRef) builtUserAgent;
        CFStringTransform(inputRef, NULL, kCFStringTransformToLatin, false); // transform to latin chars
        CFStringTransform(inputRef, NULL, kCFStringTransformStripCombiningMarks, false); // get rid of diacritical signs
        
        builtUserAgentNormalized = builtUserAgent;
    });
    
    return builtUserAgentNormalized;
}

#pragma mark - Static methods
- (void) addRequestSuccessListener:(YBRequestSuccessBlock) successBlock{
    if (successBlock != nil && ![self.successListenerList containsObject:successBlock]) {
        [self.successListenerList addObject:successBlock];
    }
}
- (void) removeRequestSuccessListener:(YBRequestSuccessBlock) successBlock{
    if (successBlock != nil) {
        [self.successListenerList removeObject:successBlock];
    }
}
- (void) addRequestErrorListener:(YBRequestErrorBlock) errorBlock{
    if (errorBlock != nil && ![self.errorListenerList containsObject:errorBlock]) {
        [self.errorListenerList addObject:errorBlock];
    }
}
- (void) removeRequestErrorListener:(YBRequestErrorBlock) errorBlock{
    if (errorBlock != nil) {
        [self.errorListenerList removeObject:errorBlock];
    }
}
+ (void) addEveryRequestSuccessListener:(YBRequestSuccessBlock) successBlock{
    if (successBlock != nil) {
        if (everySuccessListenerList == nil) {
            everySuccessListenerList = [NSMutableArray arrayWithObject:successBlock];
        } else {
            [everySuccessListenerList addObject:successBlock];
        }
    }
}
+ (void) removeEveryRequestSuccessListener:(YBRequestSuccessBlock) successBlock{
    if (everySuccessListenerList != nil && successBlock != nil) {
        [everySuccessListenerList removeObject:successBlock];
    }
}
+ (void) addEveryRequestErrorListener:(YBRequestErrorBlock) errorBlock{
    if (errorBlock != nil) {
        if (everyErrorListenerList == nil) {
            everyErrorListenerList = [NSMutableArray arrayWithObject:errorBlock];
        } else {
            [everyErrorListenerList addObject:errorBlock];
        }
    }
}
+ (void) removeEveryRequestErrorListener:(YBRequestErrorBlock) errorBlock{
    if (everyErrorListenerList != nil && errorBlock != nil) {
        [everyErrorListenerList removeObject:errorBlock];
    }
}
@end
