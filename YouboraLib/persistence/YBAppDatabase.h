//
//  YBAppDatabase.h
//  YouboraLib
//
//  Created by Enrique Alfonso Burillo on 16/01/2018.
//  Copyright © 2018 NPAW. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YBEvent;

@interface YBAppDatabase : NSObject

+ (instancetype)sharedInstance;


- (instancetype)initWithDatabaseFilename:(NSString *)dbFilename;

- (NSNumber*) insertEvent:(YBEvent*) event;

- (NSArray*)allEvents;

- (NSNumber*) lastId;

- (NSArray*) eventsWithOfflineId:(NSNumber*) offlineId;

- (NSNumber*) firstId;

- (void) removeEventsWithId:(NSNumber*) offlineId;
@end
