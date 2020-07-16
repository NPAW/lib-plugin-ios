//
//  YBPlaybackFlags.m
//  YouboraLib
//
//  Created by Tiago Pereira on 16/07/2020.
//  Copyright © 2020 NPAW. All rights reserved.
//

#import "YBPlaybackFlags.h"

@implementation YBPlaybackFlags

-(instancetype)init {
    self = [super init];
    
    if (self) {
        [self reset];
    }
    
    return self;
}

-(void)reset {
    self.preloading = false;
    self.started = false;
    self.joined = false;
    self.paused = false;
    self.seeking = false;
    self.buffering = false;
    self.ended = false;
    self.stopped = false;
    self.adManifestRequested = false;
    self.adInitiated = false;
    self.adBreakStarted = false;
}
@end
