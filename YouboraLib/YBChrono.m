//
//  YBChrono.m
//  YouboraLib
//
//  Created by Joan on 15/03/2017.
//  Copyright © 2017 NPAW. All rights reserved.
//

#import "YBChrono.h"

@implementation YBChrono

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self reset];
    }
    return self;
}

- (void) reset {
    self.startTime = 0;
    self.stopTime = 0;
    self.offset = 0;
}

- (void) start {
    self.startTime = [YBChrono getNow];
    self.stopTime = 0;
}

- (long long) getDeltaTime:(bool) stop {
    if (self.startTime <= 0) {
        return -1;
    }
    
    if (self.stopTime <= 0) {
        return stop? [self stop] : [YBChrono getNow] - self.startTime + self.offset;
    } else {
        return self.stopTime - self.startTime + self.offset;
    }
}

- (long long) getDeltaTime {
    return [self getDeltaTime:true];
}

- (long long) stop {
    self.stopTime = [YBChrono getNow];
    return [self getDeltaTime:false];
}

- (YBChrono *) copy {
    YBChrono * c = [YBChrono new];
    c.startTime = self.startTime;
    c.stopTime = self.stopTime;
    c.offset = self.offset;
    return c;
}

+ (long long) getNow {
    return round([[NSDate date] timeIntervalSince1970]*1000);
}

@end
