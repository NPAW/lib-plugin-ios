//
//  YBParsableResponseHeader.m
//  YouboraLib
//
//  Created by Joan on 31/03/2017.
//  Copyright © 2017 NPAW. All rights reserved.
//

#import "YBParsableResponseHeader.h"

@implementation YBParsableResponseHeader

- (instancetype)initWithElement:(YBCdnHeaderElement)element headerName:(nullable NSString *)headerName andRegexPattern:(NSString *)regexPattern {
    self = [super init];
    if (self) {
        self.element = element;
        self.headerName = headerName;
        self.regexPattern = regexPattern;
    }
    return self;
}

@end
