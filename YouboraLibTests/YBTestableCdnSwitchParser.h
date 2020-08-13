//
//  YBTestableCdnSwitchParser.h
//  YouboraLib
//
//  Created by Tiago Pereira on 12/08/2020.
//  Copyright © 2020 NPAW. All rights reserved.
//

#import "YBCdnSwitchParser.h"

@class YBRequest;

@interface YBTestableCdnSwitchParser : YBCdnSwitchParser

@property(nonatomic, strong) YBRequest * mockRequest;

@end
