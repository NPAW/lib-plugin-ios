//
//  YBProductAnalyticsSettings.m
//  YouboraLib
//
//  Created by Francisco Expósito on 16/01/2024.
//  Copyright © 2024 NPAW. All rights reserved.
//

#import "YBProductAnalyticsSettings.h"

@implementation YBProductAnalyticsSettings

- (id)init{
    if (self = [super init]) {
        self.highlightContentAfter = 1000;
        self.enableStateTracking = false;
        self.activeStateTimeout = 30000;
        self.activeStateDimension = 9;
    }
    return self;
}

@end
