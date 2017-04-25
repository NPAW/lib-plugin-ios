//
//  YBTimer.m
//  YouboraLib
//
//  Created by Joan on 15/03/2017.
//  Copyright © 2017 NPAW. All rights reserved.
//

#import "YBTimer.h"
#import "YBChrono.h"
#import "YBLog.h"

@interface YBTimer()

/// ---------------------------------
/// @name Private properties
/// ---------------------------------

/// Callback list
@property(nonatomic, strong) NSMutableArray<TimerCallback> * callbacks;

/// NSTimer to control the callbacks
@property (nonatomic, strong) NSTimer * timer;

// Duplicate properties with readwrite access
@property(nonatomic, strong, readwrite) YBChrono * chrono;
@property(nonatomic, assign, readwrite) bool isRunning;

@end

@implementation YBTimer

- (instancetype)initWithCallback:(TimerCallback) callback
{
    self = [self initWithCallback:callback andInterval:5000];
    return self;
}

- (instancetype)initWithCallback:(TimerCallback) callback andInterval:(double) intervalMillis
{
    self = [super init];
    if (self) {
        self.chrono = [YBChrono new];
        if (callback == nil) {
            [YBLog warn:@"YBTimer: callback is nil"];
        }
        [self addTimerCallback:callback];
        self.interval = intervalMillis;
    }
    return self;
}

#pragma mark - Public methods
- (void) addTimerCallback:(TimerCallback) callback {
    if (callback != nil) {
        if (self.callbacks == nil) {
            self.callbacks = [NSMutableArray arrayWithObject:callback];
        } else {
            [self.callbacks addObject:callback];
        }
    }
}

- (void) start {
    if (!self.isRunning) {
        self.isRunning = true;
        [self scheduleTimer];
        [YBLog notice:@"Timer started: every %f ms", self.interval];
    }
}

- (void) stop {
    @try {
        if (self.isRunning) {
            self.isRunning = false;
            [self.timer invalidate];
            self.timer = nil;
        }
    } @catch (NSException *exception) {
        [YBLog logException:exception];
    }
}

#pragma mark - Private methods
/// ---------------------------------
/// @name Private methods
/// ---------------------------------
/**
 * Schedules the <timer> to fire in <interval> milliseconds.
 */
- (void) scheduleTimer {
    // Since an NSTimer is being scheduled here, ensure we are on the main thread
    if ([NSThread isMainThread]) {
        if (self.isRunning) {
            [self.chrono start];
            self.timer = [NSTimer scheduledTimerWithTimeInterval:self.interval/1000.0 target:self selector:@selector(performCallback) userInfo:nil repeats:NO];
        }
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self scheduleTimer];
        });
    }
}

/**
 * Method that is called once the <timer> fires
 */
- (void) performCallback {
    if (self.callbacks != nil) {
        long long elapsedTime = [self.chrono stop];
        for (TimerCallback callback in self.callbacks) {
            @try {
                callback(self, elapsedTime);
            } @catch (NSException *exception) {
                [YBLog error:@"Error in timer callback"];
                [YBLog logException:exception];
            }
        }
    }
    [self scheduleTimer];
}

@end
