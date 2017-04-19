//
//  YBNqs6Transform.m
//  YouboraLib
//
//  Created by Joan on 27/03/2017.
//  Copyright © 2017 NPAW. All rights reserved.
//

#import "YBNqs6Transform.h"
#import "YBRequest.h"
#import "YBConstants.h"

#define YB_REG_EXP_ENTITY_TYPE_AND_VALUE @"\"(.+?)\":\"?(.+?)\"?[,}]"

@implementation YBNqs6Transform

static NSRegularExpression * regexPattern;

#pragma mark - Init
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self done];
    }
    return self;
}

#pragma mark - Public methods
- (void)parse:(YBRequest *)request {
    if (request != nil) {
        [YBNqs6Transform cloneParam:@"accountCode" intoParam:@"system" forRequest:request];
        [YBNqs6Transform cloneParam:@"transactionCode" intoParam:@"transcode" forRequest:request];
        [YBNqs6Transform cloneParam:@"username" intoParam:@"user" forRequest:request];
        [YBNqs6Transform cloneParam:@"mediaResource" intoParam:@"resource" forRequest:request];
        [YBNqs6Transform cloneParam:@"errorMsg" intoParam:@"msg" forRequest:request];
        
        NSString * service = request.service;
        
        if (service == nil || service.length == 0) {
            return;
        }
        
        if ([service isEqualToString:YouboraServiceJoin]) {
            [YBNqs6Transform cloneParam:@"playhead" intoParam:@"time" forRequest:request];
        }
        
        if ([service isEqualToString:YouboraServicePing]) {
            /*
             * NQS6 only allows one entity change per ping. In order to be as most backwards
             * compatible as possible, at least we send one.
             * The first match returned by the regex will be sent.
             * We use a regex here since at this point entities is already stringified.
             */
            NSString * entities = request.params[@"entities"];
            
            if (entities != nil) {
                static dispatch_once_t onceToken;
                dispatch_once(&onceToken, ^{
                    NSError *err;
                    regexPattern = [NSRegularExpression regularExpressionWithPattern:YB_REG_EXP_ENTITY_TYPE_AND_VALUE
                                                                             options:NSRegularExpressionCaseInsensitive
                                                                               error:&err];
                });
                
                NSTextCheckingResult * match = [regexPattern firstMatchInString:entities options:0 range:NSMakeRange(0, entities.length)];
                
                if (match != nil) {
                    NSString * entityType = [entities substringWithRange:[match rangeAtIndex:1]];
                    NSString * entityValue = [entities substringWithRange:[match rangeAtIndex:2]];
                    
                    request.params[@"entityType"] = entityType;
                    request.params[@"entityValue"] = entityValue;
                }
            }
        } else if ([service isEqualToString:YouboraServiceBuffer]) {
            [YBNqs6Transform cloneParam:@"bufferDuration" intoParam:@"duration" forRequest:request];
            
        } else if ([service isEqualToString:YouboraServiceSeek]) {
            [YBNqs6Transform cloneParam:@"seekDuration" intoParam:@"duration" forRequest:request];
            
        } else if ([service isEqualToString:YouboraServiceStart]) {
            [YBNqs6Transform cloneParam:@"mediaDuration" intoParam:@"duration" forRequest:request];
            
        } else if ([service isEqualToString:YouboraServiceJoin]) {
            [YBNqs6Transform cloneParam:@"joinDuration" intoParam:@"time" forRequest:request];
            [YBNqs6Transform cloneParam:@"playhead" intoParam:@"eventTime" forRequest:request];
        }
    }
}

#pragma mark - Private methods
+ (void) cloneParam:(nonnull NSString *) param intoParam:(nonnull NSString *) intoParam forRequest:(nonnull YBRequest *) request {
    NSString * paramValue = request.params[param];
    if (paramValue) {
        request.params[intoParam] = paramValue;
    }
}

@end
