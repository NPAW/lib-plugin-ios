//
//  YBPlayheadMonitor.m
//  YouboraLib
//
//  Created by Joan on 21/03/2017.
//  Copyright © 2017 NPAW. All rights reserved.
//

#import "YBPlayheadMonitor.h"

#import "YBTimer.h"
#import "YBChrono.h"
#import "YBPlayerAdapter.h"
#import "YBPlaybackFlags.h"

int const YouboraBufferTypeNone = 0;
int const YouboraBufferTypeBuffer = 1;
int const YouboraBufferTypeSeek = 2;

double const YB_BUFFER_THRESHOLD_RATIO = 0.5;
double const YB_SEEK_THRESHOLD_RATIO = 2.0;

@interface YBPlayheadMonitor()

@property(nonatomic, strong) YBTimer * timer;
@property(nonatomic, assign) double lastPlayhead;
@property(nonatomic, strong) YBChrono * chrono;
@property(nonatomic, assign) bool bufferEnabled;
@property(nonatomic, assign) bool seekEnabled;
@property(nonatomic, weak) YBPlayerAdapter * adapter;

@end

@implementation YBPlayheadMonitor

#pragma mark - Init
- (instancetype) initWithAdapter:(YBPlayerAdapter *) adapter type:(int) type {
    self = [self initWithAdapter:adapter type:type andInterval:800];
    return self;
}

- (instancetype) initWithAdapter:(YBPlayerAdapter *) adapter type:(int) type andInterval:(int) interval {
    self = [super init];
    if (self) {
        self.adapter = adapter;
        self.seekEnabled = (type & YouboraBufferTypeSeek) == YouboraBufferTypeSeek;
        self.bufferEnabled = (type & YouboraBufferTypeBuffer) == YouboraBufferTypeBuffer;
        
        self.chrono = [self createChrono];
        self.lastPlayhead = 0;
        
        if (interval > 0) {
            __weak typeof(self) weakSelf = self;
            self.timer = [self createTimerWithCallback:^(YBTimer *timer, long long diffTime) {
                __strong typeof(weakSelf) strongSelf = weakSelf;
                if (strongSelf) {
                    [strongSelf progress];
                }
            } andInterval:interval];
        }
    }
    return self;
}

#pragma mark - Public methods
- (void) start {
    if (self.timer != nil) {
        [self.timer start];
    }
}

- (void) stop {
    if (self.timer != nil) {
        [self.timer stop];
    }
}

- (void) skipNextTick {
    self.lastPlayhead = 0;
}

- (NSNumber *)getPlayhead {
    return [self.adapter getPlayhead];
}

- (void)progress {
    // Reset timer
    long long deltaTime = [self.chrono stop];
    [self.chrono start];
    
    // Define thresholds
    double bufferThreshold = deltaTime * YB_BUFFER_THRESHOLD_RATIO;
    double seekThreshold = deltaTime * YB_SEEK_THRESHOLD_RATIO;

    if ([self.adapter getPlayrate] != nil && [[self.adapter getPlayrate] doubleValue] != 0.0 && [[self.adapter getPlayrate] doubleValue] != 1.0) {
        bufferThreshold = bufferThreshold * [[self.adapter getPlayrate] doubleValue];
        seekThreshold = seekThreshold * [[self.adapter getPlayrate] doubleValue];
    }
    
    // Calculate diff playhead
    NSNumber * playhead = [self getPlayhead];
    double currentPlayhead = playhead? playhead.doubleValue : 0.0;
    double diffPlayhead = ABS(self.lastPlayhead - currentPlayhead) * 1000.0;
        
    if (diffPlayhead < bufferThreshold) {
        // Playhead is stalling: buffer
        if (self.bufferEnabled &&
            self.lastPlayhead > 0 &&
            !self.adapter.flags.paused &&
            !self.adapter.flags.seeking) {
            [self.adapter fireBufferBegin:false]; // don't convert to seek
        }
    } else if (diffPlayhead > seekThreshold) {
        // Playhead has jumped: seek
        if (self.seekEnabled && self.lastPlayhead > 0) {
            [self.adapter fireSeekBegin:true]; // convert fom buffer to seek
        }
    } else {
        // Healthy: close buffers and seeks
        if (self.seekEnabled && self.adapter.flags.seeking) {
            [self.adapter fireSeekEnd];
        } else if (self.bufferEnabled && self.adapter.flags.buffering) {
            [self.adapter fireBufferEnd];
        }
    }
    
    // Update playhead
    self.lastPlayhead = currentPlayhead;
}

#pragma mark - Private methods
- (YBChrono *) createChrono {
    return [YBChrono new];
}

- (YBTimer *) createTimerWithCallback:(TimerCallback) callback andInterval:(int) interval {
    return [[YBTimer alloc] initWithCallback:callback andInterval:interval];
}

@end
