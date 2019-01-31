//
//  YBInfinityFlags.m
//  YouboraLib
//
//  Created by Enrique Alfonso Burillo on 22/07/2018.
//  Copyright © 2018 NPAW. All rights reserved.
//

#import "YBInfinityFlags.h"

@implementation YBInfinityFlags

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self reset];
    }
    return self;
}

- (void)reset {
    self.started = false;
}

@end
