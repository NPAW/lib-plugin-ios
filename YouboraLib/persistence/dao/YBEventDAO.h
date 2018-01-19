//
//  YBEventDAO.h
//  YouboraLib iOS
//
//  Created by Enrique Alfonso Burillo on 11/01/2018.
//  Copyright © 2018 NPAW. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YBEvent;

@interface YBEventDAO : NSObject

- (void) insertNewEvent: (YBEvent*) event;

- (NSArray*) allEvents;

- (NSNumber*) lastOfflineId;

- (NSArray*) eventWithOfflineId: (NSNumber*) offlineId;

- (NSNumber*) firstOfflineId;

- (void) deleteEventsWithOfflineId: (NSNumber*) offlideId;

//- (void) deleteEventWithEventArray: (NSArray<YBEvent*>*) events;

@end
