//
//  YBTestableDashParser.h
//  YouboraLib
//
//  Created by nice on 26/11/2019.
//  Copyright © 2019 NPAW. All rights reserved.
//

#import "YBDashParser.h"

@class YBRequest;

@interface YBTestableDashParser : YBDashParser

@property(nonatomic, strong) YBRequest * mockRequest;

@end
