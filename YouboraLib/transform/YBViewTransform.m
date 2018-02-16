//
//  YBViewTransform.m
//  YouboraLib
//
//  Created by Joan on 22/03/2017.
//  Copyright © 2017 NPAW. All rights reserved.
//

#import "YBViewTransform.h"

#import "YBPlugin.h"
#import "YBFastDataConfig.h"
#import "YBConstants.h"
#import "YBLog.h"
#import "YBRequest.h"
#import "YBRequestBuilder.h"
#import "YBOptions.h"
#import "YBYouboraUtils.h"

@interface YBViewTransform()

@property(nonatomic, weak) YBPlugin * plugin;
@property(nonatomic, assign) int viewIndex;
@property(nonatomic, strong) NSMutableDictionary * params;
@property(nonatomic, strong) YBRequest * request;
@property(nonatomic, strong) NSString * viewCode;

@end

@implementation YBViewTransform

#pragma mark - Init
- (instancetype)initWithPlugin:(YBPlugin *)plugin {
    self = [super init];
    if (self) {
        self.plugin = plugin;
        self.fastDataConfig = [YBFastDataConfig new];
        self.viewIndex = -1;
        self.viewCode = nil;
        
        NSString * service = YouboraServiceData;
        self.params = [NSMutableDictionary dictionary];
        self.params[@"apiVersion"] = @"v6,v7";
        self.params[@"outputformat"] = @"jsonp";
        YBRequestBuilder * builder = plugin.requestBuilder;
        self.params = [builder buildParams:self.params forService:service];
        if (self.params != nil) {
            if ([@"nicetest" isEqualToString:self.params[@"system"]]) {
                // "nicetest" is the default accountCode.
                // If dound here, it's very likely that the customer has forgotten to set it.
                [YBLog error:@"No accountCode has been set. Pleas set your accountCode in plugin's options."];
            }
            
            // Prepare request but don't send it yet
            self.request = [self createRequestWithHost:[self.plugin getHost] andService:service];
            NSMutableDictionary * paramsRequest = [NSMutableDictionary dictionary];
            [paramsRequest setDictionary:self.params];
            self.request.params = paramsRequest;
        }
        
    }
    return self;
}

#pragma mark - Public methods
- (void) begin {
    
    if(self.plugin != nil && self.plugin.options != nil && self.plugin.options.offline){
        self.fastDataConfig.code = @"OFFLINE_MODE";
        self.fastDataConfig.host = @"OFFLINE_MODE";
        self.fastDataConfig.pingTime = @60;
        [self buildCode];
        [self done];
        [YBLog debug:@"Offline mode, skipping fastdata request..."];
        return;
    }
    
    [self requestData];
}

- (void)parse:(nullable YBRequest *)request {
    NSMutableDictionary<NSString *, NSString *> * params = request.params;
    if (request.host == nil || request.host.length == 0) {
        request.host = self.fastDataConfig.host;
    }
    
    if (params[@"code"] == nil) {
        if(request.service == YouboraServiceOffline){
            [self nextView];
        }
        params[@"code"] = self.viewCode;
    }
    
    // Request-specific transforms
    NSString * service = request.service;
    if (service == YouboraServicePing ||
        service == YouboraServiceStart) {
        
        if (params[@"pingTime"] == nil) {
            params[@"pingTime"] = self.fastDataConfig.pingTime.stringValue;
        }
    }
    if(service == YouboraServiceOffline){
        request.body = [self addCodeToEvents:request.body];
    }
}

- (NSString*) addCodeToEvents:(NSString*) body{
    if(body != nil){
        return [body stringByReplacingOccurrencesOfString:@"[VIEW_CODE]" withString:self.fastDataConfig.code];
    }
    return nil;
}

- (NSString *)nextView {
    self.viewIndex++;
    [self buildCode];
    return self.viewCode;
}

#pragma mark - Private methods
- (void) requestData {
    
    __weak typeof(self) weakSelf = self;
    [self.request addRequestSuccessListener:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSDictionary<NSString*, id>* _Nullable listenerParams) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        if (strongSelf == nil) {
            [YBLog error:@"ViewTransform dealloc'd while waiting for Fastdata!"];
            return;
        }
        
        NSString *jsonpString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        NSString *jsonString;
        if (jsonpString.length > 9) {
            jsonString = [jsonpString substringWithRange:NSMakeRange(7, jsonpString.length - 8)];
        } else {
            [YBLog error:@"FastData format is wrong."];
            return;
        }
        
        NSError *error = nil;
        NSDictionary *msg = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding]
                                                            options:NSJSONReadingAllowFragments error:&error];
        
        if (error != nil || msg == nil) {
            [YBLog error:@"FastData format is wrong."];
            return;
        }
        
        NSDictionary * q = msg[@"q"];
        
        if (q == nil) {
            [YBLog error:@"FastData format is wrong."];
            return;
        }
        
        NSString * host = q[@"h"];
        NSString * code = q[@"c"];
        NSString * pt = q[@"pt"];

        if (host.length > 0 && code.length > 0 && pt.length > 0) {
            if (strongSelf.fastDataConfig == nil) {
                strongSelf.fastDataConfig = [YBFastDataConfig new];
            }
            strongSelf.fastDataConfig.code = code;
            strongSelf.fastDataConfig.host = [YBYouboraUtils addProtocol:host https:(strongSelf.plugin.options.httpSecure)];
            strongSelf.fastDataConfig.pingTime = @(pt.intValue);
            
            [strongSelf buildCode];
            
            [YBLog notice:@"FastData '%@' is ready.", code];
            
            [strongSelf done];
            
        } else {
            [YBLog error:@"FastData format is wrong."];
            return;
        }
        
    }];
    
    [self.request addRequestErrorListener:^(NSError * _Nullable error) {
        [YBLog error:@"Fastdata request failed."];
    }];
    
    [self.request send];
}

- (YBRequest *) createRequestWithHost:(NSString *) host andService:(NSString *) service {
    return [[YBRequest alloc] initWithHost:host andService:service];
}

/*
 * Builds the view code. It has the following scheme:
 * [fast data response code]_[view count]
 *
 * The only thing that matters is that view codes are unique. For this reason we only ask the
 * backend only once for a code, and then append a view counter that is incremented with each
 * view.
 */
- (void) buildCode {
    if (self.fastDataConfig.code != nil && self.fastDataConfig.code.length > 0) {
        self.viewCode = [NSString stringWithFormat:@"%@_%d", self.fastDataConfig.code, self.viewIndex];
    } else {
        self.viewCode = nil;
    }
}

@end
