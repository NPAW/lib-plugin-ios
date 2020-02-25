//
//  YBTestableResourceTransform.h
//  YouboraLib
//
//  Created by Joan on 05/04/2017.
//  Copyright © 2017 NPAW. All rights reserved.
//

#import "YBResourceTransform.h"

@interface YBTestableResourceTransform : YBResourceTransform

@property(nonatomic, strong) NSDictionary<NSString *, YBCdnParser *> * mockCdnParsers;
@property(nonatomic, strong) YBCdnParser * mockCdnParser;
@property(nonatomic, strong) NSString * lastCreatedCdnParser;
@property(nonatomic, strong) NSTimer * mockTimer;

@end
