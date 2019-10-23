//
//  YBPlayheadMonitorTest.m
//  YouboraLib
//
//  Created by Joan on 22/03/2017.
//  Copyright © 2017 NPAW. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "YBTestablePlayheadMonitor.h"
#import "YBPlayerAdapter.h"

#import "YouboraLib/YouboraLib-Swift.h"

#import <OCMockito/OCMockito.h>
#import <OCHamcrest/OCHamcrest.h>

@interface YBPlayheadMonitorTest : XCTestCase

@property (nonatomic, strong) YBPlayerAdapter * mockAdapter;
@property (nonatomic, strong) YBTestablePlayheadMonitor * monitor;
@property (nonatomic, strong) YBPlaybackFlags * mockFlags;

@end

static int MONITORING_INTERVAL = 800;

@implementation YBPlayheadMonitorTest

- (void)setUp {
    self.mockAdapter = mock([YBPlayerAdapter class]);
    self.mockFlags = mock([YBPlaybackFlags class]);
}

- (void)tearDown {
    self.mockAdapter = nil;
    self.mockFlags = nil;
    self.monitor = nil;
}

- (void)testIntervalAndStartStop {
    
    static int interval = 23;
    
    YBTestablePlayheadMonitor * monitor = [[YBTestablePlayheadMonitor alloc] initWithAdapter:self.mockAdapter type:YouboraBufferTypeBuffer andInterval:interval];
    
    XCTAssertEqual(interval, monitor.timerInterval);
    
    [monitor start];
    [(YBTimer *) verifyCount(monitor.mockTimer, times(1)) start];
    
    [monitor stop];
    [(YBTimer *) verifyCount(monitor.mockTimer, times(1)) stop];
}

- (void)testHealthy {
    [self prepareMocks:YouboraBufferTypeBuffer|YouboraBufferTypeSeek];
    
    stubProperty(self.mockFlags, started, @(true));
    stubProperty(self.mockFlags, joined, @(true));
    
    [given([self.monitor.mockChrono stop]) willReturn:@(MONITORING_INTERVAL)];
    
    for (int i = 0; i <= 10; i++) {
        [given([self.mockAdapter getPlayhead]) willReturn:@(1.0 * i * MONITORING_INTERVAL / 1000)];
        self.monitor.timerCallback(self.monitor.mockTimer, MONITORING_INTERVAL);
    }
    
    [self verifyNotBuffering];
    [self verifyNotSeeking];
}

- (void)testBuffer {
    [self prepareMocks:YouboraBufferTypeBuffer|YouboraBufferTypeSeek];

    stubProperty(self.mockFlags, started, @(true));
    stubProperty(self.mockFlags, joined, @(true));
    
    [given([self.monitor.mockChrono stop]) willReturn:@(MONITORING_INTERVAL)];

    [given([self.mockAdapter getPlayhead]) willReturn:@(1.0 * MONITORING_INTERVAL / 1000)];
    self.monitor.timerCallback(self.monitor.mockTimer, MONITORING_INTERVAL);
    
    // Playhead won't progress
    self.monitor.timerCallback(self.monitor.mockTimer, MONITORING_INTERVAL);
    
    // Verify buffering
    [verifyCount(self.mockAdapter, never()) fireBufferBegin:anything()];
    stubProperty(self.mockFlags, buffering, @(true));

    // Restore playhead progress
    [given([self.mockAdapter getPlayhead]) willReturn:@(2.0 * MONITORING_INTERVAL / 1000)];
    self.monitor.timerCallback(self.monitor.mockTimer, MONITORING_INTERVAL);
    
    [verifyCount(self.mockAdapter, times(1)) fireBufferEnd];
    
    [self verifyNotSeeking];
}

- (void)testSeek {
    [self prepareMocks:YouboraBufferTypeBuffer|YouboraBufferTypeSeek];
    
    stubProperty(self.mockFlags, started, @(true));
    stubProperty(self.mockFlags, joined, @(true));
    
    [given([self.monitor.mockChrono stop]) willReturn:@(MONITORING_INTERVAL)];

    [given([self.mockAdapter getPlayhead]) willReturn:@(1.0 * MONITORING_INTERVAL / 1000)];
    self.monitor.timerCallback(self.monitor.mockTimer, MONITORING_INTERVAL);

    // Playhead jump
    [given([self.mockAdapter getPlayhead]) willReturn:@(10.0 * MONITORING_INTERVAL / 1000)];
    self.monitor.timerCallback(self.monitor.mockTimer, MONITORING_INTERVAL);
    
    // Verify seeking
    [verifyCount(self.mockAdapter, times(1)) fireSeekBegin:anything()];
    stubProperty(self.mockFlags, seeking, @(true));
    
    // Restore playhead progress
    [given([self.mockAdapter getPlayhead]) willReturn:@(11.0 * MONITORING_INTERVAL / 1000)];
    self.monitor.timerCallback(self.monitor.mockTimer, MONITORING_INTERVAL);
    
    [verifyCount(self.mockAdapter, times(1)) fireSeekEnd];
    
    [self verifyNotBuffering];
}

- (void)testBufferNotFiredWhenMonitoringSeek {
    [self prepareMocks:YouboraBufferTypeSeek];
    
    stubProperty(self.mockFlags, started, @(true));
    stubProperty(self.mockFlags, joined, @(true));
    
    [given([self.monitor.mockChrono stop]) willReturn:@(MONITORING_INTERVAL)];
    
    [given([self.mockAdapter getPlayhead]) willReturn:@(1.0 * MONITORING_INTERVAL / 1000)];
    self.monitor.timerCallback(self.monitor.mockTimer, MONITORING_INTERVAL);
    
    // Playhead won't progress
    self.monitor.timerCallback(self.monitor.mockTimer, MONITORING_INTERVAL);
    
    // Restore playhead progress
    [given([self.mockAdapter getPlayhead]) willReturn:@(2.0 * MONITORING_INTERVAL / 1000)];
    self.monitor.timerCallback(self.monitor.mockTimer, MONITORING_INTERVAL);
    
    [self verifyNotBuffering];
    [self verifyNotSeeking];
}

- (void)testSeekNotFiredWhenMonitoringBuffer {
    [self prepareMocks:YouboraBufferTypeBuffer];
    
    stubProperty(self.mockFlags, started, @(true));
    stubProperty(self.mockFlags, joined, @(true));
    
    [given([self.monitor.mockChrono stop]) willReturn:@(MONITORING_INTERVAL)];
    
    [given([self.mockAdapter getPlayhead]) willReturn:@(1.0 * MONITORING_INTERVAL / 1000)];
    self.monitor.timerCallback(self.monitor.mockTimer, MONITORING_INTERVAL);
    
    // Playhead jump
    [given([self.mockAdapter getPlayhead]) willReturn:@(10.0 * MONITORING_INTERVAL / 1000)];
    self.monitor.timerCallback(self.monitor.mockTimer, MONITORING_INTERVAL);
    
    // Restore playhead progress
    [given([self.mockAdapter getPlayhead]) willReturn:@(11.0 * MONITORING_INTERVAL / 1000)];
    self.monitor.timerCallback(self.monitor.mockTimer, MONITORING_INTERVAL);
    
    [self verifyNotBuffering];
    [self verifyNotSeeking];
}

- (void)testBufferThenSeek {
    // Here we test buffer -> seek conversion
    [self prepareMocks:YouboraBufferTypeBuffer|YouboraBufferTypeSeek];

    stubProperty(self.mockFlags, started, @(true));
    stubProperty(self.mockFlags, joined, @(true));
    
    [given([self.monitor.mockChrono stop]) willReturn:@(MONITORING_INTERVAL)];

    [given([self.mockAdapter getPlayhead]) willReturn:@(1.0 * MONITORING_INTERVAL / 1000)];
    self.monitor.timerCallback(self.monitor.mockTimer, MONITORING_INTERVAL);
    
    // Playhead won't progress
    self.monitor.timerCallback(self.monitor.mockTimer, MONITORING_INTERVAL);

    // Verify buffering and update flag
    [verifyCount(self.mockAdapter, never()) fireBufferBegin:anything()];
    stubProperty(self.mockFlags, buffering, @(true));

    // Playhead jump
    [given([self.mockAdapter getPlayhead]) willReturn:@(10.0 * MONITORING_INTERVAL / 1000)];
    self.monitor.timerCallback(self.monitor.mockTimer, MONITORING_INTERVAL);
    
    // Verify seek and update flags
    [verifyCount(self.mockAdapter, times(1)) fireSeekBegin:anything()];
    stubProperty(self.mockFlags, buffering, @(false));
    stubProperty(self.mockFlags, seeking, @(true));
    
    // Restore playhead progress
    [given([self.mockAdapter getPlayhead]) willReturn:@(11.0 * MONITORING_INTERVAL / 1000)];
    self.monitor.timerCallback(self.monitor.mockTimer, MONITORING_INTERVAL);
    
    [verifyCount(self.mockAdapter, never()) fireBufferEnd];
    [verifyCount(self.mockAdapter, times(1)) fireSeekEnd];
}

- (void)testSkipNextTick {
    [self prepareMocks:YouboraBufferTypeBuffer|YouboraBufferTypeSeek];

    stubProperty(self.mockFlags, started, @(true));
    stubProperty(self.mockFlags, joined, @(true));
    
    [given([self.monitor.mockChrono stop]) willReturn:@(MONITORING_INTERVAL)];

    [given([self.mockAdapter getPlayhead]) willReturn:@(1.0 * MONITORING_INTERVAL / 1000)];
    self.monitor.timerCallback(self.monitor.mockTimer, MONITORING_INTERVAL);
    
    // This should prevent buffer from firing the next tick
    [self.monitor skipNextTick];
    
    // Playhead progresses a tiny bit, enough to trigger buffer in normal cases
    [given([self.mockAdapter getPlayhead]) willReturn:@(1.1 * MONITORING_INTERVAL / 1000)];
    self.monitor.timerCallback(self.monitor.mockTimer, MONITORING_INTERVAL);
    
    [self verifyNotBuffering];
    [self verifyNotSeeking];
}

// Common functions
- (void) prepareMocks:(int) monitorType {
    self.monitor = [[YBTestablePlayheadMonitor alloc] initWithAdapter:self.mockAdapter type:monitorType andInterval:MONITORING_INTERVAL];
    
    // Mock flags
    stubProperty(self.mockAdapter, flags, self.mockFlags);
}

- (void) verifyNotSeeking {
    [verifyCount(self.mockAdapter, never()) fireSeekBegin];
    [verifyCount(self.mockAdapter, never()) fireSeekBegin:true];
    [verifyCount(self.mockAdapter, never()) fireSeekBegin:false];
    [verifyCount(self.mockAdapter, never()) fireSeekBegin:anything() convertFromBuffer:true];
    [verifyCount(self.mockAdapter, never()) fireSeekBegin:anything() convertFromBuffer:false];
}

- (void) verifyNotBuffering {
    [verifyCount(self.mockAdapter, never()) fireBufferBegin];
    [verifyCount(self.mockAdapter, never()) fireBufferBegin:true];
    [verifyCount(self.mockAdapter, never()) fireBufferBegin:false];
    [verifyCount(self.mockAdapter, never()) fireBufferBegin:anything() convertFromSeek:true];
    [verifyCount(self.mockAdapter, never()) fireBufferBegin:anything() convertFromSeek:false];
}

@end
