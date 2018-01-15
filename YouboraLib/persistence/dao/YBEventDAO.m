//
//  YBEventDAO.m
//  YouboraLib iOS
//
//  Created by Enrique Alfonso Burillo on 11/01/2018.
//  Copyright © 2018 NPAW. All rights reserved.
//

#import "YBEventDAO.h"
#import "YBAppDatabaseSingleton.h"
#import "YBEvent.h"

@import Realm;

@implementation YBEventDAO

- (void) insertNewEvent: (YBEvent*) event{
    [[[YBAppDatabaseSingleton sharedInstance] getInstance] addObject:event];
}

- (RLMResults<YBEvent*>*) allEvents{
    return [YBEvent allObjects];
}

- (RLMResults<YBEvent*>*) lastOfflineId{
    return [[YBEvent allObjects] sortedResultsUsingKeyPath:@"offlineId" ascending:NO];
}

- (RLMResults<YBEvent*>*) eventWithOfflineId: (NSNumber*) offlineId{
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"offlineId = %@", offlineId];
    
    return [[YBEvent objectsWithPredicate:pred] sortedResultsUsingKeyPath:@"offlineId" ascending:YES];
}

- (RLMResults<YBEvent*>*) firstOfflineId{
    return [[YBEvent allObjects] sortedResultsUsingKeyPath:@"offlineId" ascending:YES];
}

- (void) deleteEventsWithOfflineId: (NSNumber*) offlideId{
    RLMResults<YBEvent *> *events = [self eventWithOfflineId:offlideId];
    [[[YBAppDatabaseSingleton sharedInstance] getInstance] deleteObjects:events];
}

- (void) deleteEventWithEventArray: (NSArray<YBEvent*>*) events{
    [[[YBAppDatabaseSingleton sharedInstance] getInstance] deleteObjects:events];
}

@end
