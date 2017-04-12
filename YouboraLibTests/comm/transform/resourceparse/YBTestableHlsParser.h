//
//  YBTestableHlsParser.h
//  YouboraLib
//
//  Created by Joan on 03/04/2017.
//  Copyright © 2017 NPAW. All rights reserved.
//

#import "YBHlsParser.h"

@class YBRequest;

@interface YBTestableHlsParser : YBHlsParser

@property(nonatomic, strong) YBRequest * mockRequest;

@end
