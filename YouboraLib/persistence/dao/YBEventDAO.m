//
//  YBEventDAO.m
//  YouboraLib iOS
//
//  Created by Enrique Alfonso Burillo on 11/01/2018.
//  Copyright © 2018 NPAW. All rights reserved.
//

#import "YBEventDAO.h"
#import "YouboraLib/YouboraLib-Swift.h"
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
        [YBAppDatabase.shared insertEvent:event];
    } @catch(NSException *exception){
         [YBLog logException:exception];
    }
}

- (NSArray<YBEvent*>*) allEvents{
    @try {
        return [YBAppDatabase.shared allEvents];
    } @catch(NSException *exception){
        [YBLog logException:exception];
    }
    return [[NSArray alloc] init];
}

- (NSNumber*) lastOfflineId{
    @try {
        return [NSNumber numberWithInteger: [YBAppDatabase.shared lastId]];
    } @catch(NSException *exception){
        [YBLog logException:exception];
    }
    return @(0);
}

- (NSArray<YBEvent*>*) eventWithOfflineId: (NSNumber*) offlineId{
    @try {
        return [YBAppDatabase.shared eventsWithOfflineId:[offlineId intValue]];
    } @catch(NSException *exception){
        [YBLog logException:exception];
    }
    return [[NSArray alloc] init];
}

- (NSNumber*) firstOfflineId{
    @try {
        return [NSNumber numberWithInteger:[YBAppDatabase.shared firstId]];
    } @catch(NSException *exception){
        [YBLog logException:exception];
    }
    return @(0);
}

- (void) deleteEventsWithOfflineId: (NSNumber*) offlideId{
    @try {
        [YBAppDatabase.shared removeEventsWithEventId: [offlideId intValue]];
    } @catch(NSException *exception){
        [YBLog logException:exception];
    }
}

@end
