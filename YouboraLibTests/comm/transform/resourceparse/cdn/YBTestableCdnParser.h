//
//  YBTestableCdnParser.h
//  YouboraLib
//
//  Created by Joan on 04/04/2017.
//  Copyright © 2017 NPAW. All rights reserved.
//

#import "YBCdnParser.h"
@class YBTestableRequest;

@interface YBTestableCdnParser : YBCdnParser

@property(nonatomic, strong) YBTestableRequest * mockRequest;

@end
