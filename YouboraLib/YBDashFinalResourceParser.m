//
//  YBDashFinalResourceParser.m
//  YouboraLib
//
//  Created by nice on 26/11/2019.
//  Copyright © 2019 NPAW. All rights reserved.
//

#import "YBDashFinalResourceParser.h"

@interface YBDashFinalResourceParser ()

@property (nonatomic, strong) NSString *regex;

@end

@implementation YBDashFinalResourceParser

-(instancetype)initWithRegex:(NSString*)regex {
    self = [super init];
    
    if (self) {
        self.regex = regex;
    }
    
    return self;
}

-(NSString*)parseForDash:(NSString*)dashXml {
    NSRange searchedRange = NSMakeRange(0, [dashXml length]);
    
    NSError *error;
    
    NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:self.regex options:0 error:&error];
    
    NSArray* matches = [regex matchesInString:dashXml options:0 range: searchedRange];
    
    if ([matches count] == 0) {
        return nil;
    }
    
    NSTextCheckingResult *match = [matches objectAtIndex:0];
    
    if (match.numberOfRanges < 2) {
        return nil;
    }
    
    NSString *result = [dashXml substringWithRange:[match rangeAtIndex:1]];
    
    return result;
}

@end
