//
//  YBRecursiveResourceParser.m
//  YouboraLib
//
//  Created by Tiago Pereira on 25/02/2020.
//  Copyright © 2020 NPAW. All rights reserved.
//

#import "YBRecursiveResourceParser.h"
#import "YBRequest.h"

@implementation YBRecursiveResourceParser

+(void)recursivelyParse:(NSString*)resource withParser:(id<YBResourceParser>)parser completion:(Completion)completion {
    if (![parser isSatisfiedWithResource:resource]) {
        completion(resource);
    }
    
    YBRequest *request =  [self createRequestWithHost: [parser getRequestSource] andService: nil]
    
    [request addRequestSuccessListener:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSDictionary<NSString*, id>* _Nullable listenerParams) {
        NSString *finalResource = [parser parseResourceWithData:data response:(NSHTTPURLResponse*)response listenerParents:listenerParams];
        
        [self recursivelyParse:finalResource withParser:parser completion:completion];
    }];
    
    [request addRequestErrorListener:^(NSError * _Nullable error) {
        completion(resource);
    }];
}

+ (YBRequest *) createRequestWithHost:(nullable NSString *) host andService:(nullable NSString *) service {
    return [[YBRequest alloc] initWithHost:host andService:service];
}

@end
