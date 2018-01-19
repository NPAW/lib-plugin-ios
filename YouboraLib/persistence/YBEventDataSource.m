//
//  YBEventDataSource.m
//  YouboraLib iOS
//
//  Created by Enrique Alfonso Burillo on 11/01/2018.
//  Copyright © 2018 NPAW. All rights reserved.
//

#import "YBEventDataSource.h"
#import "YBAppDatabase.h"
#import "YBEvent.h"
#import "YBEventDAO.h"

@interface YBEventDataSource()

@property (nonatomic, strong) YBEventDAO *eventDAO;

@end

@implementation YBEventDataSource

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.eventDAO = [[YBEventDAO alloc] init];
    }
    return self;
}

- (void) putNewEvent:(YBEvent*) event completion: (void (^)(void))querySuccessBlock{
    dispatch_async(dispatch_queue_create("background", 0), ^{
        @autoreleasepool {
            [self.eventDAO insertNewEvent:event];
            if(querySuccessBlock != nil){
                querySuccessBlock();
            }
        }
    });
}

- (void) allEventsWithCompletion: (void (^)(NSArray*))querySuccessBlock{
    dispatch_async(dispatch_queue_create("background", 0), ^{
        @autoreleasepool {
            NSArray* events = [self.eventDAO allEvents];
            if(querySuccessBlock != nil){
                querySuccessBlock(events);
            }
        }
    });
}

- (void) lastIdWithCompletion: (void (^)(NSNumber*))querySuccessBlock{
    dispatch_async(dispatch_queue_create("background", 0), ^{
        @autoreleasepool {
            NSNumber* offlineId  = [self.eventDAO lastOfflineId];
            if(querySuccessBlock != nil){
                querySuccessBlock(offlineId);
            }
        }
    });
}

- (void) eventsWithOfflineId: (NSNumber*) offlineId completion: (void (^)(NSArray*))querySuccessBlock{
    dispatch_async(dispatch_queue_create("background", 0), ^{
        @autoreleasepool {
            NSArray* events = [self.eventDAO eventWithOfflineId:offlineId];
            if(querySuccessBlock != nil){
                querySuccessBlock(events);
            }
        }
    });
}

- (void) firstIdWithCompletion: (void (^)(NSNumber*))querySuccessBlock{
    dispatch_async(dispatch_queue_create("background", 0), ^{
        @autoreleasepool {
            NSNumber* offlineId = [self.eventDAO firstOfflineId];
            if(querySuccessBlock != nil){
                querySuccessBlock(offlineId);
            }
        }
    });
}

- (void) deleteEventsWithOfflineId: (NSNumber*) offlindeId completion: (void (^)(void))querySuccessBlock{
    dispatch_async(dispatch_queue_create("background", 0), ^{
        @autoreleasepool {
            [self.eventDAO deleteEventsWithOfflineId:offlindeId];
            if(querySuccessBlock != nil){
                querySuccessBlock();
            }
        }
    });
}

/*- (void) deleteEventWithEventArray: (NSArray*) events completion: (void (^)(void))querySuccessBlock{
    dispatch_async(dispatch_queue_create("background", 0), ^{
        @autoreleasepool {
            [self.eventDAO deleteEventWithEventArray:events];
            if(querySuccessBlock != nil){
                querySuccessBlock();
            }
        }
    });
}*/

@end
