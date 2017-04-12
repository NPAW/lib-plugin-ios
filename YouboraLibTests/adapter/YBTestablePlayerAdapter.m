//
//  YBTestablePlayerAdapter.m
//  YouboraLib
//
//  Created by Joan on 21/03/2017.
//  Copyright © 2017 NPAW. All rights reserved.
//

#import "YBTestablePlayerAdapter.h"

#import "YBPlayheadMonitor.h"
#import <OCMockito/OCMockito.h>

@interface YBTestablePlayerAdapter()

@end

@implementation YBTestablePlayerAdapter

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.registeredTimes = 0;
        self.unregisteredTimes = 0;
        self.stopTimes = 0;
        self.mockMonitor = mock([YBPlayheadMonitor class]);
    }
    return self;
}

- (void)fireStop {
    self.stopTimes++;
    [super fireStop];
}

- (void)registerListeners {
    self.registeredTimes++;
}

- (void)unregisterListeners {
    self.unregisteredTimes++;
}

- (YBPlayheadMonitor *) createPlayheadMonitorWithType:(int) type andInterval: (int) interval {
    return self.mockMonitor;
}

@end
