//
//  YBTestablePlayheadMonitor.h
//  YouboraLib
//
//  Created by Joan on 22/03/2017.
//  Copyright © 2017 NPAW. All rights reserved.
//

#import "YBPlayheadMonitor.h"
#import "YBTimer.h"

@class YBChrono;

@interface YBTestablePlayheadMonitor : YBPlayheadMonitor

@property (nonatomic, strong) YBChrono * mockChrono;
@property (nonatomic, strong) YBTimer * mockTimer;
@property (nonatomic, assign) int timerInterval;
@property (copy) TimerCallback timerCallback;

- (YBChrono *) createChrono;

- (YBTimer *) createTimerWithCallback:(TimerCallback) callback andInterval:(int) interval;

@end
