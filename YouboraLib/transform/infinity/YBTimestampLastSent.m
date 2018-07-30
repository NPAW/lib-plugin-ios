//
//  YBTimestampLastSent.m
//  YouboraLib
//
//  Created by Enrique Alfonso Burillo on 18/07/2018.
//  Copyright © 2018 NPAW. All rights reserved.
//

#import "YBTimestampLastSent.h"

#import "YBInfinityLocalManager.h"

@interface YBTimestampLastSent()

@property(nonatomic, strong) YBInfinityLocalManager * infinityManager;

@end

@implementation YBTimestampLastSent

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.infinityManager = [[YBInfinityLocalManager alloc] init];
        [self done];
    }
    return self;
}

- (void) parse:(YBRequest *)request {
    [self.infinityManager saveLastActiveDate];
}
@end
