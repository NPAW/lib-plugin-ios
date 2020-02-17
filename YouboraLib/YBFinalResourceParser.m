//
//  YBFinalResourceParser.m
//  YouboraLib
//
//  Created by Tiago Pereira on 17/02/2020.
//  Copyright © 2020 NPAW. All rights reserved.
//

#import "YBFinalResourceParser.h"
#import "YBRequest.h"

@implementation YBFinalResourceParser

-(Boolean)isSatisfied:(NSString*)resource {;
    return true;
}

- (void)createRequestWithHost:(NSString *)host service:(NSString *)service success:(Success)success failure:(Failure)failure {
    YBRequest * request = [[YBRequest alloc] initWithHost:host andService:service];
    request.method = YouboraHTTPMethodHead;
    request.maxRetries = 0;
    
    [request addRequestSuccessListener:success];
    
    [request addRequestErrorListener:failure];
    
    [request send];
}

@end
