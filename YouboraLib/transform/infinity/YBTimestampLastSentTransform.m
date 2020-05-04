//
//  YBTimestampLastSent.m
//  YouboraLib
//
//  Created by Enrique Alfonso Burillo on 18/07/2018.
//  Copyright © 2018 NPAW. All rights reserved.
//

#import "YBTimestampLastSentTransform.h"
#import "YouboraLib/YouboraLib-Swift.h"

@interface YBTimestampLastSentTransform()

@end

@implementation YBTimestampLastSentTransform

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self done];
    }
    return self;
}

- (void) parse:(YBRequest *)request {
    [YBInfinityLocalManager saveLastActiveDate];
}
@end
