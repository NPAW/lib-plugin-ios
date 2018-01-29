//
//  YBEventDAO.m
//  YouboraLib iOS
//
//  Created by Enrique Alfonso Burillo on 11/01/2018.
//  Copyright © 2018 NPAW. All rights reserved.
//

#import "YBEventDAO.h"
#import "YBAppDatabase.h"
#import "YBEvent.h"
#import "YBLog.h"

@implementation YBEventDAO

-(instancetype) init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void) insertNewEvent: (YBEvent*) event{
    @try {
        [[YBAppDatabase sharedInstance] insertEvent:event];
    } @catch(NSException *exception){
         [YBLog logException:exception];
    }
}

- (NSArray<YBEvent*>*) allEvents{
    @try {
        return [[YBAppDatabase sharedInstance] allEvents];
    } @catch(NSException *exception){
        [YBLog logException:exception];
    }
    return [[NSArray alloc] init];
}

- (NSNumber*) lastOfflineId{
    @try {
        return [[YBAppDatabase sharedInstance] lastId];
    } @catch(NSException *exception){
        [YBLog logException:exception];
    }
    return @(0);
}

- (NSArray<YBEvent*>*) eventWithOfflineId: (NSNumber*) offlineId{
    @try {
        return [[YBAppDatabase sharedInstance] eventsWithOfflineId:offlineId];
    } @catch(NSException *exception){
        [YBLog logException:exception];
    }
    return [[NSArray alloc] init];
}

- (NSNumber*) firstOfflineId{
    @try {
        return [[YBAppDatabase sharedInstance] firstId];
    } @catch(NSException *exception){
        [YBLog logException:exception];
    }
    return @(0);
}

- (void) deleteEventsWithOfflineId: (NSNumber*) offlideId{
    @try {
        [[YBAppDatabase sharedInstance] removeEventsWithId:offlideId];
    } @catch(NSException *exception){
        [YBLog logException:exception];
    }
}

@end
