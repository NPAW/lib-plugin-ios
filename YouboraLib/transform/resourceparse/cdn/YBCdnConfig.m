//
//  YBCdnConfig.m
//  YouboraLib
//
//  Created by Joan on 31/03/2017.
//  Copyright © 2017 NPAW. All rights reserved.
//

#import "YBCdnConfig.h"
#import "YBRequest.h"

@implementation YBCdnConfig


- (instancetype)initWithCode:(NSString *)code
{
    self = [super init];
    if (self) {
        self.code = code;
        self.parsers = [NSMutableArray array];
        self.requestHeaders = [NSMutableDictionary dictionary];
        self.requestMethod = YouboraHTTPMethodHead;
        self.typeParser = nil;
    }
    return self;
}

@end
