//
//  YBTestablePlayerAdapter.h
//  YouboraLib
//
//  Created by Joan on 21/03/2017.
//  Copyright © 2017 NPAW. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "YBPlayerAdapter.h"

@interface YBTestablePlayerAdapter : YBPlayerAdapter<NSString *>

@property (nonatomic, strong) YBPlayheadMonitor * mockMonitor;
@property (nonatomic, assign) int registeredTimes;
@property (nonatomic, assign) int unregisteredTimes;
@property (nonatomic, assign) int stopTimes;

@end
