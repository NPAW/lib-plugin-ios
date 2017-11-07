//
//  YBPlaybackChronos.m
//  YouboraLib
//
//  Created by Joan on 20/03/2017.
//  Copyright © 2017 NPAW. All rights reserved.
//

#import "YBPlaybackChronos.h"
#import "YBChrono.h"

@implementation YBPlaybackChronos

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self reset];
    }
    return self;
}

- (void)reset {
    self.join = [YBChrono new];
    self.seek = [YBChrono new];
    self.pause = [YBChrono new];
    self.buffer = [YBChrono new];
    self.total = [YBChrono new];
    
    self.adInit = [YBChrono new];
}

@end
