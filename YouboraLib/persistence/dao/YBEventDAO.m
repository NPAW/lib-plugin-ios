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

@implementation YBEventDAO

-(instancetype) init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void) insertNewEvent: (YBEvent*) event{
    [[YBAppDatabase sharedInstance] insertEvent:event];
    //[[[YBAppDatabaseSingleton sharedInstance] getInstance] addObject:event];
}

- (NSArray<YBEvent*>*) allEvents{
    return [[YBAppDatabase sharedInstance] allEvents];
    //return [YBEvent allObjects];
}

- (NSNumber*) lastOfflineId{
    return [[YBAppDatabase sharedInstance] lastId];
    //return [[YBEvent allObjects] sortedResultsUsingKeyPath:@"offlineId" ascending:NO];
}

- (NSArray<YBEvent*>*) eventWithOfflineId: (NSNumber*) offlineId{
    return [[YBAppDatabase sharedInstance] eventsWithOfflineId:offlineId];
}

- (NSNumber*) firstOfflineId{
    return [[YBAppDatabase sharedInstance] firstId];
    //return [[YBEvent allObjects] sortedResultsUsingKeyPath:@"offlineId" ascending:YES];
}

- (void) deleteEventsWithOfflineId: (NSNumber*) offlideId{
    [[YBAppDatabase sharedInstance] removeEventsWithId:offlideId];
}

@end
