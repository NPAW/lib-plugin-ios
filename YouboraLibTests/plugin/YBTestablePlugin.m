//
//  YBTestablePlugin.m
//  YouboraLib
//
//  Created by Joan on 28/03/2017.
//  Copyright © 2017 NPAW. All rights reserved.
//

#import "YBTestablePlugin.h"

#import "YBRequestBuilder.h"
#import "YBOptions.h"
#import "YBLog.h"
#import "YBViewTransform.h"
#import "YBResourceTransform.h"
#import "YBPlayerAdapter.h"
#import "YBRequest.h"
#import "YBCommunication.h"
#import "YBTimer.h"
#import "YBPlaybackChronos.h"
#import "YBFastDataConfig.h"
#import "YBFlowTransform.h"
#import "YBPlayheadMonitor.h"

#import "YouboraLib/YouboraLib-Swift.h"

#import <OCMockito/OCMockito.h>

@implementation YBTestablePlugin

- (YBChrono *) createChrono {
    if (self.mockChrono == nil) {
        self.mockChrono = mock([YBChrono class]);
    }
    return self.mockChrono;
}

- (YBTimer *) createTimerWithCallback:(TimerCallback)callback andInterval:(long) interval {
    if (self.mockTimer == nil) {
        self.mockTimer = mock([YBTimer class]);
    }
    // Capture callback
    self.timerCallback = callback;
    return self.mockTimer;
}

- (YBTimer *) createBeatTimeWithCallback:(TimerCallback)callback andInterval:(long) interval {
    if (self.mockBeatTimer == nil) {
        self.mockBeatTimer = mock([YBTimer class]);
    }
    // Capture callback
    self.beatTimerCallback = callback;
    return self.mockBeatTimer;
}

- (YBRequestBuilder *) createRequestBuilder {
    if (self.mockRequestBuilder == nil) {
        self.mockRequestBuilder = mock([YBRequestBuilder class]);
    }
    return self.mockRequestBuilder;
}

- (YBResourceTransform *) createResourceTransform {
    if (self.mockResourceTransform == nil) {
        self.mockResourceTransform = mock([YBResourceTransform class]);
    }
    return self.mockResourceTransform;
}

- (YBViewTransform *) createViewTransform {
    if (self.mockViewTransform == nil) {
        self.mockViewTransform = mock([YBViewTransform class]);
    }
    return self.mockViewTransform;
}

- (YBRequest *) createRequestWithHost:(NSString *)host andService:(NSString *)service {
    if (!self.lastRegistedServices) {
        self.lastRegistedServices = [[NSMutableArray alloc] init];
    }
    
    [self.lastRegistedServices addObject:service];
    
    if (self.mockRequest == nil) {
        self.mockRequest = mock([YBRequest class]);
    }
    self.mockRequest.host = host;
    self.mockRequest.service = service;
    return self.mockRequest;
}

- (YBCommunication *) createCommunication {
    if (self.mockCommunication == nil) {
        self.mockCommunication = mock([YBCommunication class]);
    }
    return self.mockCommunication;
}

- (YBFlowTransform *) createFlowTransform {
    if (self.mockFlowTransform == nil) {
        self.mockFlowTransform = mock([YBFlowTransform class]);
    }
    return self.mockFlowTransform;
}

@end
