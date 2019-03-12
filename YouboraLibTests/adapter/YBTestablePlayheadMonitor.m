//
//  YBTestablePlayheadMonitor.m
//  YouboraLib
//
//  Created by Joan on 22/03/2017.
//  Copyright © 2017 NPAW. All rights reserved.
//

#import "YBTestablePlayheadMonitor.h"
#import "YBTimer.h"

#import "YouboraLib/YouboraLib-Swift.h"

#import <OCMockito/OCMockito.h>

@implementation YBTestablePlayheadMonitor

- (instancetype) initWithAdapter:(YBPlayerAdapter *) adapter type:(int) type andInterval:(int) interval {

    self.mockTimer = mock([YBTimer class]);
    self.mockChrono = mock([YBChrono class]);
    self.timerInterval = -1;
    
    self = [super initWithAdapter:adapter type:type andInterval:interval];
    return self;
}

- (YBChrono *) createChrono {
    return self.mockChrono;
}

- (YBTimer *) createTimerWithCallback:(TimerCallback) callback andInterval:(int) interval {
    self.timerCallback = callback;
    self.timerInterval = interval;
    return self.mockTimer;
}

@end
