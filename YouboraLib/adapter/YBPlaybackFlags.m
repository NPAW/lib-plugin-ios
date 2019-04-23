//
//  YBPlaybackFlags.m
//  YouboraLib
//
//  Created by Joan on 20/03/2017.
//  Copyright © 2017 NPAW. All rights reserved.
//

#import "YBPlaybackFlags.h"

@implementation YBPlaybackFlags

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self reset];
        self.adManifestRequested = false; //We don't want to be able to reset this one
    }
    return self;
}

- (void)reset {
    self.preloading = false;
    self.started = false;
    self.joined = false;
    self.paused = false;
    self.seeking = false;
    self.buffering = false;
    
    self.adInitiated = false;
    self.adBreakStarted = false;
}

@end
