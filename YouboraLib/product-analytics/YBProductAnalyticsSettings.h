//
//  YBProductAnalyticsSettings.h
//  YouboraLib
//
//  Created by Francisco Expósito on 16/01/2024.
//  Copyright © 2024 NPAW. All rights reserved.

#import <Foundation/Foundation.h>

@interface YBProductAnalyticsSettings : NSObject
    @property(nonatomic, assign) NSInteger highlightContentAfter;
    @property(nonatomic, assign) Boolean enableStateTracking;
    @property(nonatomic, assign) NSInteger activeStateTimeout;
    @property(nonatomic, assign) NSInteger activeStateDimension;
@end
