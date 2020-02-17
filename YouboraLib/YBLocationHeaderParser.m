//
//  YBLocationHeaderParserTmp.m
//  YouboraLib
//
//  Created by Tiago Pereira on 17/02/2020.
//  Copyright © 2020 NPAW. All rights reserved.
//

#import "YBLocationHeaderParser.h"

@implementation YBLocationHeaderParser

-(void)parseResource:(NSString*_Nonnull)resource completion:(ParseCompletion _Nonnull )completion failure:(ParseFailure _Nonnull )failure {
    [self createRequestWithHost:resource service:nil success:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSDictionary<NSString *,id> * _Nonnull listenerParams) {
        NSHTTPURLResponse * httpResponse = (NSHTTPURLResponse *) response;
        NSDictionary * responseHeaders = httpResponse.allHeaderFields;
        if (responseHeaders != nil && [responseHeaders count] != 0 && responseHeaders[@"Location"] != nil) {
            [self parseResource:responseHeaders[@"Location"] completion:completion failure:failure];
        } else {
            completion(resource);
        }
        
    } failure: failure];
}

@end
