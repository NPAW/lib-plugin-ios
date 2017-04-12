//
//  YBTestableCdnParser.h
//  YouboraLib
//
//  Created by Joan on 04/04/2017.
//  Copyright © 2017 NPAW. All rights reserved.
//

#import "YBCdnParser.h"
@class YBRequest;

@interface YBTestableCdnParser : YBCdnParser

@property(nonatomic, strong) YBRequest * mockRequest;

@end
