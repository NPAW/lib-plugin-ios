//
//  YBTestablePlugin.h
//  YouboraLib
//
//  Created by Joan on 28/03/2017.
//  Copyright © 2017 NPAW. All rights reserved.
//

#import "YBPlugin.h"

@class YBRequestBuilder, YBOptions, YBResourceTransform, YBViewTransform, YBTimer, YBPlayerAdapter, YBCommunication, YBChrono, YBFlowTransform, YBNqs6Transform;

#import "YBTimer.h"

@interface YBTestablePlugin : YBPlugin

@property(nonatomic, strong) YBChrono * mockChrono;
@property(nonatomic, strong) YBTimer * mockTimer;
@property(nonatomic, strong) YBTimer * mockBeatTimer;
@property(nonatomic, strong) YBRequestBuilder * mockRequestBuilder;
@property(nonatomic, strong) YBResourceTransform * mockResourceTransform;
@property(nonatomic, strong) YBFlowTransform * mockFlowTransform;
@property(nonatomic, strong) YBNqs6Transform * mockNqs6Transform;
@property(nonatomic, strong) YBViewTransform * mockViewTransform;
@property(nonatomic, strong) YBCommunication * mockCommunication;
@property(nonatomic, strong) YBRequest * mockRequest;

@property(nonatomic, copy) TimerCallback timerCallback;
@property(nonatomic, copy) TimerCallback beatTimerCallback;

@property(nonatomic) NSMutableArray<NSString*> *lastRegistedServices;
@end
