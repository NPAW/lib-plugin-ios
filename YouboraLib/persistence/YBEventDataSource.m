//
//  YBEventDataSource.m
//  YouboraLib iOS
//
//  Created by Enrique Alfonso Burillo on 11/01/2018.
//  Copyright © 2018 NPAW. All rights reserved.
//

#import "YBEventDataSource.h"
#import "YBAppDatabaseSingleton.h"
#import "YBEvent.h"
#import "YBEventDAO.h"

@import Realm;

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

- (void) putNewEvent:(YBEvent*) event completion: (void (^)(NSInteger))querySuccessBlock{
    dispatch_async(dispatch_queue_create("background", 0), ^{
        @autoreleasepool {
            [self.eventDAO insertNewEvent:event];
            if(querySuccessBlock != nil){
                querySuccessBlock(event.id);
            }
        }
    });
}

- (void) allEventsWithCompletion: (void (^)(NSArray*))querySuccessBlock{
    dispatch_async(dispatch_queue_create("background", 0), ^{
        @autoreleasepool {
            RLMResults* results = [self.eventDAO allEvents];
            if(querySuccessBlock != nil){
                querySuccessBlock([self convertToArray:results]);
            }
        }
    });
}

- (void) lastIdWithCompletion: (void (^)(NSNumber*))querySuccessBlock{
    dispatch_async(dispatch_queue_create("background", 0), ^{
        @autoreleasepool {
            RLMResults* results = [self.eventDAO lastOfflineId];
            YBEvent *event = [results firstObject];
            if(querySuccessBlock != nil){
                querySuccessBlock(event.offlineId);
            }
        }
    });
}

- (void) eventsWithOfflineId: (NSNumber*) offlineId completion: (void (^)(NSArray*))querySuccessBlock{
    dispatch_async(dispatch_queue_create("background", 0), ^{
        @autoreleasepool {
            RLMResults* results = [self.eventDAO eventWithOfflineId:offlineId];
            if(querySuccessBlock != nil){
                querySuccessBlock([self convertToArray:results]);
            }
        }
    });
}

- (void) firstIdWithCompletion: (void (^)(NSNumber*))querySuccessBlock{
    dispatch_async(dispatch_queue_create("background", 0), ^{
        @autoreleasepool {
            RLMResults* results = [self.eventDAO firstOfflineId];
            YBEvent *event = [results firstObject];
            if(querySuccessBlock != nil){
                querySuccessBlock(event.offlineId);
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

- (void) deleteEventWithEventArray: (NSArray*) events completion: (void (^)(void))querySuccessBlock{
    dispatch_async(dispatch_queue_create("background", 0), ^{
        @autoreleasepool {
            [self.eventDAO deleteEventWithEventArray:events];
            if(querySuccessBlock != nil){
                querySuccessBlock();
            }
        }
    });
}

#pragma mark Utility methods

- (NSArray*) convertToArray:(RLMResults*) results{
    NSMutableArray *resultsArray = [NSMutableArray array];
    for (YBEvent *event in results) {
        [resultsArray addObject:event];
    }
    return resultsArray;
}

@end
